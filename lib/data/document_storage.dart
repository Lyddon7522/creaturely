import 'dart:io';

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

abstract interface class AttachmentSwap {
  Map<String, String> get finalPaths;

  Future<void> commit();

  Future<void> rollback();

  Future<void> finalize();
}

abstract interface class RestoreDocumentStore {
  Future<Map<String, Uint8List>> readAttachments(Iterable<CareDocument> documents);

  Future<Map<String, Uint8List>> readAnimalPhotos(Iterable<Animal> animals);

  Future<AttachmentSwap> stageRestore(Map<String, Uint8List> attachments);
}

class DocumentStorage implements RestoreDocumentStore {
  DocumentStorage._(this.root);

  final Directory root;

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

  Future<StoredAttachment> importFile(File source) async {
    if (!await source.exists()) {
      throw FileSystemException('The selected document is no longer available.', source.path);
    }
    final checksum = await checksumFile(source);
    final existing = await _findByHash(checksum);
    final extension = path.extension(source.path).toLowerCase();
    final target = existing ?? File(path.join(root.path, '$checksum$extension'));
    if (existing == null) {
      await source.copy(target.path);
    }
    return StoredAttachment(
      path: target.path,
      checksumSha256: checksum,
      byteLength: await target.length(),
      mediaType: mediaTypeForPath(source.path),
    );
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
    await root.create(recursive: true);
  }

  @override
  Future<Map<String, Uint8List>> readAttachments(Iterable<CareDocument> documents) async {
    final result = <String, Uint8List>{};
    for (final document in documents) {
      if (result.containsKey(document.checksumSha256)) {
        continue;
      }
      final file = File(document.storedPath);
      if (!await file.exists()) {
        throw FileSystemException(
          'Cannot back up missing document "${document.title}".',
          document.storedPath,
        );
      }
      final bytes = await file.readAsBytes();
      final actual = sha256.convert(bytes).toString();
      if (actual != document.checksumSha256) {
        throw const FormatException('A document checksum changed before backup.');
      }
      result[actual] = bytes;
    }
    return result;
  }

  @override
  Future<Map<String, Uint8List>> readAnimalPhotos(Iterable<Animal> animals) async {
    final result = <String, Uint8List>{};
    for (final animal in animals) {
      final photoPath = animal.photoPath;
      if (photoPath == null || result.containsKey(photoPath)) {
        continue;
      }
      final file = File(photoPath);
      if (!await file.exists()) {
        throw FileSystemException(
          'Cannot back up missing profile photo for "${animal.name}".',
          photoPath,
        );
      }
      result[photoPath] = await file.readAsBytes();
    }
    return result;
  }

  @override
  Future<AttachmentSwap> stageRestore(Map<String, Uint8List> attachments) async {
    final parent = root.parent;
    final stamp = DateTime.now().microsecondsSinceEpoch;
    final staging = Directory(path.join(parent.path, '.creaturely-restore-$stamp'));
    final previous = Directory(path.join(parent.path, '.creaturely-previous-$stamp'));
    await staging.create(recursive: true);
    final finalPaths = <String, String>{};
    try {
      for (final entry in attachments.entries) {
        final actual = sha256.convert(entry.value).toString();
        if (actual != entry.key) {
          throw const FormatException('Restore staging received corrupt attachment bytes.');
        }
        final staged = File(path.join(staging.path, '${entry.key}.blob'));
        await staged.writeAsBytes(entry.value, flush: true);
        finalPaths[entry.key] = path.join(root.path, '${entry.key}.blob');
      }
      return StagedAttachmentSwap._(
        root: root,
        staging: staging,
        previous: previous,
        finalPaths: finalPaths,
      );
    } catch (_) {
      if (await staging.exists()) {
        await staging.delete(recursive: true);
      }
      rethrow;
    }
  }

  Future<File?> _findByHash(String checksum) async {
    await for (final entity in root.list()) {
      if (entity is File && path.basename(entity.path).startsWith(checksum)) {
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

class StagedAttachmentSwap implements AttachmentSwap {
  StagedAttachmentSwap._({
    required this.root,
    required this.staging,
    required this.previous,
    required this.finalPaths,
  });

  final Directory root;
  final Directory staging;
  final Directory previous;
  @override
  final Map<String, String> finalPaths;
  bool _committed = false;

  @override
  Future<void> commit() async {
    if (_committed) {
      throw StateError('Attachment swap was already committed.');
    }
    if (await root.exists()) {
      await root.rename(previous.path);
    }
    try {
      await staging.rename(root.path);
      _committed = true;
    } catch (_) {
      if (await previous.exists() && !await root.exists()) {
        await previous.rename(root.path);
      }
      rethrow;
    }
  }

  @override
  Future<void> rollback() async {
    if (_committed && await root.exists()) {
      await root.delete(recursive: true);
    } else if (await staging.exists()) {
      await staging.delete(recursive: true);
    }
    if (await previous.exists()) {
      await previous.rename(root.path);
    }
    _committed = false;
  }

  @override
  Future<void> finalize() async {
    if (!_committed) {
      throw StateError('Cannot finalize an uncommitted attachment swap.');
    }
    if (await previous.exists()) {
      await previous.delete(recursive: true);
    }
  }
}
