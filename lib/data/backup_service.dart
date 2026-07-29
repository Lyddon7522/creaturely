import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as path;

import '../domain/models.dart';
import 'document_storage.dart';
import 'repository.dart';

class UnsupportedBackupException implements Exception {
  const UnsupportedBackupException(this.message);

  final String message;

  @override
  String toString() => 'UnsupportedBackupException: $message';
}

class CorruptBackupException implements Exception {
  const CorruptBackupException(this.message);

  final String message;

  @override
  String toString() => 'CorruptBackupException: $message';
}

class AttachmentInventoryEntry {
  const AttachmentInventoryEntry({
    required this.checksumSha256,
    required this.archivePath,
    required this.byteLength,
  });

  factory AttachmentInventoryEntry.fromJson(Map<String, Object?> json) => AttachmentInventoryEntry(
    checksumSha256: json['checksumSha256'] as String,
    archivePath: json['archivePath'] as String,
    byteLength: json['byteLength'] as int,
  );

  final String checksumSha256;
  final String archivePath;
  final int byteLength;

  Map<String, Object?> toJson() => {
    'checksumSha256': checksumSha256,
    'archivePath': archivePath,
    'byteLength': byteLength,
  };
}

class BackupManifest {
  const BackupManifest({
    required this.createdAt,
    required this.schemaVersion,
    required this.dataChecksumSha256,
    required this.attachments,
  });

  factory BackupManifest.fromJson(Map<String, Object?> json) {
    if (json['format'] != formatName) {
      throw const UnsupportedBackupException('This is not a Creaturely backup.');
    }
    final version = json['formatVersion'];
    if (version != currentFormatVersion) {
      throw UnsupportedBackupException('Backup format version $version is not supported.');
    }
    if (json['dataFile'] != 'data.json') {
      throw const CorruptBackupException('Canonical data file declaration is invalid.');
    }
    final schemaVersion = json['schemaVersion'];
    final checksum = json['dataChecksumSha256'];
    if (schemaVersion is! int || checksum is! String || !_sha256Pattern.hasMatch(checksum)) {
      throw const CorruptBackupException('Backup schema or data checksum is invalid.');
    }
    final rawAttachments = json['attachments'];
    if (rawAttachments is! List<Object?>) {
      throw const CorruptBackupException('Attachment inventory is missing.');
    }
    final attachments = rawAttachments
        .map((item) {
          if (item is! Map<String, Object?>) {
            throw const CorruptBackupException('Attachment inventory entry is invalid.');
          }
          final entry = AttachmentInventoryEntry.fromJson(item);
          if (!_sha256Pattern.hasMatch(entry.checksumSha256) ||
              entry.archivePath != 'attachments/${entry.checksumSha256}.blob' ||
              entry.byteLength < 0) {
            throw const CorruptBackupException('Attachment inventory metadata is invalid.');
          }
          return entry;
        })
        .toList(growable: false);
    if (attachments.map((entry) => entry.checksumSha256).toSet().length != attachments.length ||
        attachments.map((entry) => entry.archivePath).toSet().length != attachments.length) {
      throw const CorruptBackupException('Attachment inventory contains duplicate entries.');
    }
    return BackupManifest(
      createdAt: DateTime.parse(json['createdAt'] as String),
      schemaVersion: schemaVersion,
      dataChecksumSha256: checksum,
      attachments: attachments,
    );
  }

  static const String formatName = 'creaturely-backup';
  static const int currentFormatVersion = 1;

  final DateTime createdAt;
  final int schemaVersion;
  final String dataChecksumSha256;
  final List<AttachmentInventoryEntry> attachments;

  Map<String, Object?> toJson() => {
    'format': formatName,
    'formatVersion': currentFormatVersion,
    'schemaVersion': schemaVersion,
    'createdAt': createdAt.toUtc().toIso8601String(),
    'dataFile': 'data.json',
    'dataChecksumSha256': dataChecksumSha256,
    'attachments': attachments.map((entry) => entry.toJson()).toList(growable: false),
  };
}

class ValidatedBackup {
  const ValidatedBackup({
    required this.manifest,
    required this.snapshot,
    required this.attachments,
  });

  final BackupManifest manifest;
  final CreaturelySnapshot snapshot;
  final Map<String, Uint8List> attachments;
}

class CreaturelyBackupService {
  const CreaturelyBackupService();

  Uint8List create({
    required CreaturelySnapshot snapshot,
    required Map<String, Uint8List> attachments,
    Map<String, Uint8List> animalPhotos = const <String, Uint8List>{},
  }) {
    final inventory = <AttachmentInventoryEntry>[];
    final portableDocuments = <CareDocument>[];
    final portableAnimals = <Animal>[];
    final seen = <String>{};

    void addInventory(String checksum, Uint8List bytes) {
      if (seen.add(checksum)) {
        inventory.add(
          AttachmentInventoryEntry(
            checksumSha256: checksum,
            archivePath: 'attachments/$checksum.blob',
            byteLength: bytes.length,
          ),
        );
      }
    }

    for (final animal in snapshot.animals) {
      final photoPath = animal.photoPath;
      if (photoPath == null) {
        portableAnimals.add(animal);
        continue;
      }
      final bytes = animalPhotos[photoPath];
      if (bytes == null) {
        throw CorruptBackupException(
          'Profile photo for "${animal.name}" is missing from the attachment set.',
        );
      }
      final checksum = sha256.convert(bytes).toString();
      addInventory(checksum, bytes);
      portableAnimals.add(animal.copyWith(photoPath: 'attachments/$checksum.blob'));
    }

    for (final document in snapshot.documents) {
      final bytes = attachments[document.checksumSha256];
      if (bytes == null) {
        throw CorruptBackupException(
          'Document "${document.title}" is missing from the attachment set.',
        );
      }
      final actual = sha256.convert(bytes).toString();
      if (actual != document.checksumSha256 || bytes.length != document.byteLength) {
        throw CorruptBackupException('Document "${document.title}" failed checksum validation.');
      }
      final archivePath = 'attachments/${document.checksumSha256}.blob';
      portableDocuments.add(document.copyWith(storedPath: archivePath));
      addInventory(document.checksumSha256, bytes);
    }

    final portable = _withPortablePaths(
      snapshot,
      animals: portableAnimals,
      documents: portableDocuments,
    );
    final data = utf8.encode(portable.toCanonicalJson());
    final manifest = BackupManifest(
      createdAt: snapshot.exportedAt,
      schemaVersion: snapshot.schemaVersion,
      dataChecksumSha256: sha256.convert(data).toString(),
      attachments: inventory,
    );
    final archive = Archive()
      ..add(ArchiveFile.string('manifest.json', jsonEncode(manifest.toJson())))
      ..add(ArchiveFile.bytes('data.json', data));
    for (final entry in inventory) {
      final bytes =
          attachments[entry.checksumSha256] ??
          animalPhotos.values.firstWhere(
            (value) => sha256.convert(value).toString() == entry.checksumSha256,
          );
      archive.add(ArchiveFile.bytes(entry.archivePath, bytes));
    }
    return ZipEncoder().encodeBytes(archive);
  }

  ValidatedBackup validate(Uint8List bytes) {
    late final Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(bytes, verify: true);
    } on Object catch (error) {
      throw CorruptBackupException('The archive could not be opened: $error');
    }
    final archivePaths = <String>{};
    for (final entry in archive) {
      if (_unsafePath(entry.name)) {
        throw const CorruptBackupException('The archive contains an unsafe file path.');
      }
      if (!archivePaths.add(entry.name)) {
        throw const CorruptBackupException('The archive contains duplicate file paths.');
      }
    }
    final manifestBytes = archive.find('manifest.json')?.readBytes();
    final dataBytes = archive.find('data.json')?.readBytes();
    if (manifestBytes == null || dataBytes == null) {
      throw const CorruptBackupException('Manifest or canonical data is missing.');
    }

    late final BackupManifest manifest;
    late CreaturelySnapshot snapshot;
    try {
      manifest = BackupManifest.fromJson(
        jsonDecode(utf8.decode(manifestBytes)) as Map<String, Object?>,
      );
      if (sha256.convert(dataBytes).toString() != manifest.dataChecksumSha256) {
        throw const CorruptBackupException('Canonical data checksum does not match.');
      }
      snapshot = CreaturelySnapshot.decode(utf8.decode(dataBytes));
    } on UnsupportedBackupException {
      rethrow;
    } on CorruptBackupException {
      rethrow;
    } on Object catch (error) {
      throw CorruptBackupException('Backup metadata is invalid: $error');
    }

    if (manifest.schemaVersion != snapshot.schemaVersion) {
      throw const CorruptBackupException('Manifest and data schema versions disagree.');
    }
    if (snapshot.schemaVersion < 2 ||
        snapshot.schemaVersion > CreaturelySnapshot.currentSchemaVersion) {
      throw UnsupportedBackupException(
        'Schema version ${snapshot.schemaVersion} is not supported.',
      );
    }
    snapshot = _migrateSupportedSnapshot(snapshot);
    _validateSnapshot(snapshot);

    final expectedArchivePaths = <String>{
      'manifest.json',
      'data.json',
      ...manifest.attachments.map((entry) => entry.archivePath),
    };
    if (archivePaths.length != expectedArchivePaths.length ||
        !archivePaths.containsAll(expectedArchivePaths)) {
      throw const CorruptBackupException('The archive contains undeclared files.');
    }

    final attachmentBytes = <String, Uint8List>{};
    for (final inventory in manifest.attachments) {
      final content = archive.find(inventory.archivePath)?.readBytes();
      if (content == null ||
          content.length != inventory.byteLength ||
          sha256.convert(content).toString() != inventory.checksumSha256) {
        throw CorruptBackupException('Attachment ${inventory.checksumSha256} failed validation.');
      }
      attachmentBytes[inventory.checksumSha256] = content;
    }
    for (final document in snapshot.documents) {
      final content = attachmentBytes[document.checksumSha256];
      if (content == null) {
        throw CorruptBackupException(
          'Document "${document.title}" refers to an absent attachment.',
        );
      }
      if (document.storedPath != 'attachments/${document.checksumSha256}.blob' ||
          document.byteLength != content.length) {
        throw CorruptBackupException(
          'Document "${document.title}" has inconsistent attachment metadata.',
        );
      }
    }
    final referenced = snapshot.documents.map((document) => document.checksumSha256).toSet();
    for (final animal in snapshot.animals) {
      final portablePath = animal.photoPath;
      if (portablePath == null) {
        continue;
      }
      final checksum = _checksumFromPortablePath(portablePath);
      if (checksum == null || !attachmentBytes.containsKey(checksum)) {
        throw CorruptBackupException(
          'Profile photo for "${animal.name}" refers to an absent attachment.',
        );
      }
      referenced.add(checksum);
    }
    if (referenced.length != attachmentBytes.length ||
        !attachmentBytes.keys.every(referenced.contains)) {
      throw const CorruptBackupException('Attachment inventory contains unreferenced blobs.');
    }
    return ValidatedBackup(manifest: manifest, snapshot: snapshot, attachments: attachmentBytes);
  }

  bool _unsafePath(String value) =>
      value.startsWith('/') ||
      value.startsWith('\\') ||
      value.split(RegExp(r'[/\\]')).contains('..');

  void _validateSnapshot(CreaturelySnapshot snapshot) {
    _requireUniqueIds('animals', snapshot.animals.map((value) => value.id));
    _requireUniqueIds('identifiers', snapshot.identifiers.map((value) => value.id));
    _requireUniqueIds(
      'respiratory sessions',
      snapshot.respiratorySessions.map((value) => value.id),
    );
    _requireUniqueIds(
      'respiratory reminders',
      snapshot.respiratoryReminders.map((value) => value.id),
    );
    _requireUniqueIds('weight reminders', snapshot.weightReminders.map((value) => value.id));
    _requireUniqueIds('medications', snapshot.medications.map((value) => value.id));
    _requireUniqueIds(
      'medication schedules',
      snapshot.medicationSchedules.map((value) => value.id),
    );
    _requireUniqueIds('dose ledger', snapshot.doseLedger.map((value) => value.id));
    _requireUniqueIds('health records', snapshot.healthRecords.map((value) => value.id));
    _requireUniqueIds('documents', snapshot.documents.map((value) => value.id));

    final animals = <String, Animal>{for (final animal in snapshot.animals) animal.id: animal};
    final medications = <String, Medication>{
      for (final medication in snapshot.medications) medication.id: medication,
    };
    final schedules = <String, MedicationSchedule>{
      for (final schedule in snapshot.medicationSchedules) schedule.id: schedule,
    };
    bool badAnimal(String id) => !animals.containsKey(id);

    if (snapshot.identifiers.any(
          (value) =>
              badAnimal(value.animalId) || value.type.trim().isEmpty || value.value.trim().isEmpty,
        ) ||
        snapshot.respiratorySessions.any(
          (value) =>
              badAnimal(value.animalId) ||
              value.durationMilliseconds <= 0 ||
              value.breathCount <= 0 ||
              !value.ratePerMinute.isFinite ||
              value.ratePerMinute < 0 ||
              !value.thresholdSnapshot.isValid ||
              (value.ratePerMinute -
                          (value.breathCount *
                              Duration.millisecondsPerMinute /
                              value.durationMilliseconds))
                      .abs() >
                  1e-7,
        ) ||
        snapshot.respiratoryReminders.any((value) => badAnimal(value.animalId) || !value.isValid) ||
        snapshot.weightReminders.any((value) => badAnimal(value.animalId) || !value.isValid) ||
        snapshot.medications.any(
          (value) =>
              badAnimal(value.animalId) ||
              value.name.trim().isEmpty ||
              value.form.trim().isEmpty ||
              value.doseUnit.trim().isEmpty ||
              value.instructions.trim().isEmpty ||
              !value.doseAmount.isFinite ||
              value.doseAmount <= 0 ||
              (value.endDate != null && compareCalendarDates(value.endDate!, value.startDate) < 0),
        ) ||
        snapshot.medicationSchedules.any((value) {
          final medication = medications[value.medicationId];
          return badAnimal(value.animalId) ||
              medication == null ||
              medication.animalId != value.animalId ||
              value.timeZoneId.trim().isEmpty ||
              !value.isValid;
        }) ||
        snapshot.doseLedger.any((value) {
          final medication = medications[value.medicationId];
          final schedule = value.scheduleId == null ? null : schedules[value.scheduleId];
          return badAnimal(value.animalId) ||
              medication == null ||
              medication.animalId != value.animalId ||
              value.intendedLocalTime.trim().isEmpty ||
              (value.scheduleId != null &&
                  (schedule == null ||
                      schedule.medicationId != value.medicationId ||
                      schedule.animalId != value.animalId));
        }) ||
        snapshot.healthRecords.any(
          (value) =>
              badAnimal(value.animalId) ||
              value.title.trim().isEmpty ||
              (value.canonicalValue != null &&
                  (!value.canonicalValue!.isFinite ||
                      (value.kind == HealthRecordKind.weight && value.canonicalValue! < 0))),
        ) ||
        snapshot.documents.any(
          (value) =>
              badAnimal(value.animalId) ||
              value.title.trim().isEmpty ||
              value.mediaType.trim().isEmpty ||
              value.byteLength < 0 ||
              !_sha256Pattern.hasMatch(value.checksumSha256),
        ) ||
        snapshot.animals.any(
          (value) =>
              value.name.trim().isEmpty ||
              value.species.trim().isEmpty ||
              !value.thresholds.isValid ||
              (value.approximateAgeMonths != null && value.approximateAgeMonths! < 0) ||
              (value.currentWeightKg != null &&
                  (!value.currentWeightKg!.isFinite || value.currentWeightKg! < 0)),
        ) ||
        !const <int>[15, 20, 30, 60].contains(snapshot.settings.defaultTimerSeconds)) {
      throw const CorruptBackupException(
        'Backup contains invalid records or broken record references.',
      );
    }
  }

  CreaturelySnapshot _migrateSupportedSnapshot(CreaturelySnapshot snapshot) {
    if (snapshot.schemaVersion == CreaturelySnapshot.currentSchemaVersion) {
      return snapshot;
    }
    if (snapshot.schemaVersion == 2 || snapshot.schemaVersion == 3) {
      return CreaturelySnapshot(
        schemaVersion: CreaturelySnapshot.currentSchemaVersion,
        exportedAt: snapshot.exportedAt,
        animals: snapshot.animals,
        identifiers: snapshot.identifiers,
        respiratorySessions: snapshot.respiratorySessions,
        respiratoryReminders: snapshot.schemaVersion == 2
            ? const <RespiratoryReminder>[]
            : snapshot.respiratoryReminders,
        weightReminders: const <WeightCheckReminder>[],
        medications: snapshot.medications,
        medicationSchedules: snapshot.medicationSchedules,
        doseLedger: snapshot.doseLedger,
        healthRecords: snapshot.healthRecords,
        documents: snapshot.documents,
        settings: snapshot.settings,
      );
    }
    throw UnsupportedBackupException('Schema version ${snapshot.schemaVersion} is not supported.');
  }

  void _requireUniqueIds(String label, Iterable<String> ids) {
    final values = ids.toList(growable: false);
    if (values.any((id) => id.trim().isEmpty) || values.toSet().length != values.length) {
      throw CorruptBackupException('Backup contains invalid or duplicate $label IDs.');
    }
  }

  String? _checksumFromPortablePath(String value) {
    final match = RegExp(r'^attachments/([a-f0-9]{64})\.blob$').firstMatch(value);
    return match?.group(1);
  }

  CreaturelySnapshot _withPortablePaths(
    CreaturelySnapshot snapshot, {
    required List<Animal> animals,
    required List<CareDocument> documents,
  }) => CreaturelySnapshot(
    schemaVersion: snapshot.schemaVersion,
    exportedAt: snapshot.exportedAt,
    animals: animals,
    identifiers: snapshot.identifiers,
    respiratorySessions: snapshot.respiratorySessions,
    respiratoryReminders: snapshot.respiratoryReminders,
    weightReminders: snapshot.weightReminders,
    medications: snapshot.medications,
    medicationSchedules: snapshot.medicationSchedules,
    doseLedger: snapshot.doseLedger,
    healthRecords: snapshot.healthRecords,
    documents: documents,
    settings: snapshot.settings,
  );
}

final RegExp _sha256Pattern = RegExp(r'^[a-f0-9]{64}$');

abstract interface class SafetySnapshotWriter {
  Future<File> write(Uint8List bytes);
}

class DirectorySafetySnapshotWriter implements SafetySnapshotWriter {
  const DirectorySafetySnapshotWriter(this.directory);

  final Directory directory;

  @override
  Future<File> write(Uint8List bytes) async {
    await directory.create(recursive: true);
    final stamp = DateTime.now().toUtc().toIso8601String().replaceAll(':', '-');
    final file = File(path.join(directory.path, 'before-restore-$stamp.creaturely'));
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}

class AtomicRestoreCoordinator {
  const AtomicRestoreCoordinator({
    required this.backups,
    required this.store,
    required this.documents,
    required this.safetyWriter,
  });

  final CreaturelyBackupService backups;
  final SnapshotStore store;
  final RestoreDocumentStore documents;
  final SafetySnapshotWriter safetyWriter;

  Future<void> restore(Uint8List bytes) async {
    final validated = backups.validate(bytes);
    final previous = await store.loadSnapshot();
    final previousAttachments = await documents.readAttachments(previous.documents);
    final previousPhotos = await documents.readAnimalPhotos(previous.animals);
    await safetyWriter.write(
      backups.create(
        snapshot: previous,
        attachments: previousAttachments,
        animalPhotos: previousPhotos,
      ),
    );
    final staged = await documents.stageRestore(validated.attachments);
    final remapped = _remapPaths(validated.snapshot, staged.finalPaths);

    var databaseChanged = false;
    try {
      await store.replaceSnapshot(remapped);
      databaseChanged = true;
      await staged.commit();
    } on Object {
      if (databaseChanged) {
        await store.replaceSnapshot(previous);
      }
      await staged.rollback();
      rethrow;
    }
    await staged.finalize();
  }

  CreaturelySnapshot _remapPaths(CreaturelySnapshot snapshot, Map<String, String> finalPaths) =>
      CreaturelySnapshot(
        schemaVersion: snapshot.schemaVersion,
        exportedAt: snapshot.exportedAt,
        animals: snapshot.animals
            .map((animal) {
              final portablePath = animal.photoPath;
              if (portablePath == null) {
                return animal;
              }
              final checksum = path.basenameWithoutExtension(portablePath);
              final finalPath = finalPaths[checksum];
              if (finalPath == null) {
                throw CorruptBackupException('Profile photo for "${animal.name}" was not staged.');
              }
              return animal.copyWith(photoPath: finalPath);
            })
            .toList(growable: false),
        identifiers: snapshot.identifiers,
        respiratorySessions: snapshot.respiratorySessions,
        respiratoryReminders: snapshot.respiratoryReminders,
        weightReminders: snapshot.weightReminders,
        medications: snapshot.medications,
        medicationSchedules: snapshot.medicationSchedules,
        doseLedger: snapshot.doseLedger,
        healthRecords: snapshot.healthRecords,
        documents: snapshot.documents
            .map((document) => document.copyWith(storedPath: finalPaths[document.checksumSha256]!))
            .toList(growable: false),
        settings: snapshot.settings,
      );
}
