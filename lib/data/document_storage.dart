import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../domain/models.dart';

enum AttachmentHealth { available, missing, corrupt }

class StoredAttachment {
  const StoredAttachment({
    required this.path,
    required this.checksumSha256,
    required this.byteLength,
    required this.mediaType,
  });

  final String path;
  final String checksumSha256;
  final int byteLength;
  final String mediaType;
}

abstract interface class AttachmentGeneration {
  Map<String, String> get finalPaths;

  Future<void> commit();

  Future<void> rollback();
}

abstract interface class RestoreDocumentStore {
  Future<T> exclusiveFiles<T>(Future<T> Function() action);
  Future<AttachmentGeneration> stageRestore(Map<String, Uint8List> attachments);
}

class DocumentStorage implements RestoreDocumentStore {
  DocumentStorage._(this.root);

  final Directory root;
  final Map<String, int> _leases = {};
  final Object _fileLock = Object();
  Future<void> _fileTail = Future.value();

  @override
  Future<T> exclusiveFiles<T>(Future<T> Function() action) {
    if (Zone.current[_fileLock] == this) return action();
    final operation = _fileTail.then((_) => runZoned(action, zoneValues: {_fileLock: this}));
    _fileTail = operation.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    return operation;
  }

  static Future<DocumentStorage> openDefault() async {
    final documents = await getApplicationDocumentsDirectory();
    return DocumentStorage.open(Directory(path.join(documents.path, 'attachments')));
  }

  static Future<DocumentStorage> open(Directory root) async {
    await root.create(recursive: true);
    return DocumentStorage._(root);
  }

  @visibleForTesting
  static DocumentStorage openSync(Directory root) {
    root.createSync(recursive: true);
    return DocumentStorage._(root);
  }

  Future<StoredAttachment> importFile(File source) => exclusiveFiles(() => _importFile(source));

  Future<StoredAttachment> _importFile(File source) async {
    if (!await source.exists()) {
      throw FileSystemException('The selected document is no longer available.', source.path);
    }
    final extension = path.extension(source.path).toLowerCase();
    final staging = await root.createTemp('import-');
    late StoredAttachment attachment;
    try {
      final staged = await source.copy(path.join(staging.path, 'content$extension'));
      final stagedPath = staged.path;
      // Hash the copied bytes, so a source changed during picking cannot produce
      // a filename/checksum that describes different bytes. Hashing stays off UI.
      final checksum = await Isolate.run(() => DocumentStorage.checksumFile(File(stagedPath)));
      final length = await staged.length();
      final existing = await _findByHash(checksum);
      final target = existing ?? await staged.rename(path.join(root.path, '$checksum$extension'));
      attachment = StoredAttachment(
        path: target.path,
        checksumSha256: checksum,
        byteLength: length,
        mediaType: mediaTypeForPath(source.path),
      );
    } finally {
      await staging.delete(recursive: true);
    }
    // Acquire only after all fallible work (including staging cleanup) succeeds.
    _leases.update(attachment.path, (count) => count + 1, ifAbsent: () => 1);
    return attachment;
  }

  void release(String filePath) {
    final count = _leases[filePath] ?? 0;
    if (count <= 1) {
      _leases.remove(filePath);
    } else {
      _leases[filePath] = count - 1;
    }
  }

  /// Hold references while a command waits in its queue, even if its form closes.
  Future<T> withLease<T>(Iterable<String> paths, Future<T> Function() action) async {
    final held = paths.toSet();
    for (final filePath in held) {
      _leases.update(filePath, (count) => count + 1, ifAbsent: () => 1);
    }
    try {
      return await action();
    } finally {
      for (final filePath in held) {
        release(filePath);
      }
    }
  }

  File get _recoveredIndex => File(path.join(root.path, '.recovered.json'));

  Future<List<StoredAttachment>> recoveredImages() => exclusiveFiles(_readRecoveredImages);

  Future<List<StoredAttachment>> _readRecoveredImages() async {
    if (!await _recoveredIndex.exists()) return const [];
    final decoded = jsonDecode(await _recoveredIndex.readAsString());
    final entries = switch (decoded) {
      Map<String, Object?>() => decoded.map((key, value) => MapEntry(key, value as String)),
      // Preserve images retained by builds with the original path-only index.
      List<Object?>() => {
        for (final filePath in decoded.cast<String>()) filePath: mediaTypeForPath(filePath),
      },
      _ => throw const FormatException('Recovered image index is invalid.'),
    };
    final result = <StoredAttachment>[];
    for (final entry in entries.entries) {
      final filePath = entry.key;
      if (!path.isWithin(root.path, filePath)) {
        throw const FormatException('Recovered image path is outside attachment storage.');
      }
      final file = File(filePath);
      if (await file.exists()) {
        result.add(
          StoredAttachment(
            path: filePath,
            checksumSha256: await checksumFile(file),
            byteLength: await file.length(),
            mediaType: entry.value,
          ),
        );
      }
    }
    return List.unmodifiable(result);
  }

  Future<void> _writeRecoveredIndex(Iterable<StoredAttachment> images) async {
    final temporary = File('${_recoveredIndex.path}.tmp');
    await temporary.writeAsString(
      jsonEncode({for (final image in images) image.path: image.mediaType}),
      flush: true,
    );
    await temporary.rename(_recoveredIndex.path);
  }

  Future<void> retainRecovered(File file) => exclusiveFiles(() async {
    final existing = await recoveredImages();
    final imported = await importFile(file);
    try {
      await _writeRecoveredIndex([...existing, imported]);
    } finally {
      release(imported.path);
    }
  });

  Future<void> consumeRecovered(String filePath) => exclusiveFiles(() async {
    final recovered = await recoveredImages();
    if (!recovered.any((item) => item.path == filePath)) {
      throw const FormatException('The recovered image is no longer available.');
    }
    _leases.update(filePath, (count) => count + 1, ifAbsent: () => 1);
    try {
      await _writeRecoveredIndex(recovered.where((item) => item.path != filePath));
    } on Object {
      release(filePath);
      rethrow;
    }
  });

  Future<void> collectGarbage(Set<String> referencedPaths) =>
      exclusiveFiles(() => _collectGarbage(referencedPaths));

  Future<void> _collectGarbage(Set<String> referencedPaths) async {
    final retained = {
      ...referencedPaths,
      ..._leases.keys,
      ...(await recoveredImages()).map((item) => item.path),
      _recoveredIndex.path,
    };
    final directories = <Directory>[];
    await for (final entity in root.list(recursive: true, followLinks: false)) {
      if (entity is File && !retained.contains(entity.path)) {
        await entity.delete();
      } else if (entity is Directory) {
        directories.add(entity);
      }
    }
    directories.sort((a, b) => b.path.length.compareTo(a.path.length));
    for (final directory in directories) {
      if (await directory.list().isEmpty) await directory.delete();
    }
  }

  Future<AttachmentHealth> inspect(CareDocument document) async {
    final file = File(document.storedPath);
    if (!await file.exists()) {
      return AttachmentHealth.missing;
    }
    if (await file.length() != document.byteLength) {
      return AttachmentHealth.corrupt;
    }
    return await checksumFile(file) == document.checksumSha256
        ? AttachmentHealth.available
        : AttachmentHealth.corrupt;
  }

  /// Removes every app-managed file that can contain journal content.
  ///
  /// The live SQLite rows are cleared separately while the database is open.
  /// This method covers attachments plus the recoverable migration/restore
  /// copies that would otherwise outlive the keeper's delete-everything choice.
  Future<void> deleteJournalArtifacts() async {
    for (final directory in <Directory>[
      root,
      Directory(path.join(root.parent.path, 'migration-safety')),
      Directory(path.join(root.parent.path, 'recovery')),
    ]) {
      if (await directory.exists()) {
        await directory.delete(recursive: true);
      }
    }
    _leases.clear();
    await root.create(recursive: true);
  }

  @override
  Future<AttachmentGeneration> stageRestore(Map<String, Uint8List> attachments) async {
    final staging = await root.createTemp('generation-');
    final finalPaths = <String, String>{};
    try {
      for (final entry in attachments.entries) {
        final actual = sha256.convert(entry.value).toString();
        if (actual != entry.key) {
          throw const FormatException('Restore staging received corrupt attachment bytes.');
        }
        final staged = File(path.join(staging.path, '${entry.key}.blob'));
        await staged.writeAsBytes(entry.value, flush: true);
        finalPaths[entry.key] = path.join(staging.path, '${entry.key}.blob');
      }
      return StagedAttachmentGeneration._(
        staging: staging,
        finalPaths: Map.unmodifiable(finalPaths),
      );
    } catch (_) {
      if (await staging.exists()) {
        await staging.delete(recursive: true);
      }
      rethrow;
    }
  }

  Future<File?> _findByHash(String checksum) async {
    await for (final entity in root.list(recursive: true, followLinks: false)) {
      if (entity is File &&
          path.basename(entity.path).startsWith(checksum) &&
          await checksumFile(entity) == checksum) {
        return entity;
      }
    }
    return null;
  }

  static Future<String> checksumFile(File file) async =>
      (await sha256.bind(file.openRead()).first).toString();

  static String mediaTypeForPath(String value) {
    return switch (path.extension(value).toLowerCase()) {
      '.pdf' => 'application/pdf',
      '.png' => 'image/png',
      '.gif' => 'image/gif',
      '.heic' || '.heif' => 'image/heic',
      '.webp' => 'image/webp',
      _ => 'image/jpeg',
    };
  }
}

/// A generation is published before any database row refers to it. Old paths
/// remain valid across process termination on either side of the SQLite commit.
class StagedAttachmentGeneration implements AttachmentGeneration {
  StagedAttachmentGeneration._({required this.staging, required this.finalPaths});

  final Directory staging;
  @override
  final Map<String, String> finalPaths;

  @override
  Future<void> commit() async {
    await File(path.join(staging.path, '.complete')).writeAsString('1', flush: true);
  }

  @override
  Future<void> rollback() async {
    if (await staging.exists()) {
      await staging.delete(recursive: true);
    }
  }
}
