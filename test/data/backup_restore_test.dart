import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:creaturely/data/backup_service.dart';
import 'package:creaturely/data/document_storage.dart';
import 'package:creaturely/data/repository.dart';
import 'package:creaturely/domain/models.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fixtures.dart';

void main() {
  const backups = CreaturelyBackupService();

  test('open .creaturely archive round-trips canonical data and deduplicated blobs', () {
    final bytes = backups.create(
      snapshot: fixtureSnapshot(),
      attachments: <String, Uint8List>{fixtureChecksum: fixtureAttachment},
    );
    final archive = ZipDecoder().decodeBytes(bytes);
    expect(archive.find('manifest.json'), isNotNull);
    expect(archive.find('data.json'), isNotNull);
    expect(archive.files.where((entry) => entry.name.startsWith('attachments/')), hasLength(1));

    final validated = backups.validate(bytes);
    expect(validated.snapshot.animals.single.species, 'Axolotl');
    expect(validated.snapshot.respiratoryReminders.single.id, 'respiratory-reminder-1');
    expect(validated.snapshot.weightReminders.single.id, 'weight-reminder-1');
    expect(validated.snapshot.documents.single.storedPath, startsWith('attachments/'));
    expect(validated.attachments[fixtureChecksum], fixtureAttachment);
  });

  test('profile photos round-trip as validated content-addressed attachment blobs', () {
    final source = fixtureSnapshot();
    const originalPhotoPath = '/managed/moss-profile.jpg';
    final photoBytes = Uint8List.fromList(<int>[42, 7, 9, 11]);
    final photoAnimal = source.animals.single.copyWith(photoPath: originalPhotoPath);
    final withPhoto = CreaturelySnapshot(
      schemaVersion: source.schemaVersion,
      exportedAt: source.exportedAt,
      animals: <Animal>[photoAnimal],
      identifiers: source.identifiers,
      respiratorySessions: source.respiratorySessions,
      respiratoryReminders: source.respiratoryReminders,
      weightReminders: source.weightReminders,
      medications: source.medications,
      medicationSchedules: source.medicationSchedules,
      doseLedger: source.doseLedger,
      healthRecords: source.healthRecords,
      documents: source.documents,
      settings: source.settings,
    );

    final bytes = backups.create(
      snapshot: withPhoto,
      attachments: <String, Uint8List>{fixtureChecksum: fixtureAttachment},
      animalPhotos: <String, Uint8List>{originalPhotoPath: photoBytes},
    );
    final archive = ZipDecoder().decodeBytes(bytes);
    expect(archive.files.where((entry) => entry.name.startsWith('attachments/')), hasLength(2));

    final validated = backups.validate(bytes);
    expect(
      validated.snapshot.animals.single.photoPath,
      matches(RegExp(r'^attachments/[a-f0-9]{64}\.blob$')),
    );
    expect(validated.attachments[sha256.convert(photoBytes).toString()], orderedEquals(photoBytes));
  });

  test('canonical data checksum corruption is rejected before import', () {
    final valid = backups.create(
      snapshot: fixtureSnapshot(),
      attachments: <String, Uint8List>{fixtureChecksum: fixtureAttachment},
    );
    final archive = ZipDecoder().decodeBytes(valid);
    archive.add(ArchiveFile.string('data.json', '{}'));

    expect(
      () => backups.validate(ZipEncoder().encodeBytes(archive)),
      throwsA(isA<CorruptBackupException>()),
    );
  });

  test('unsupported format versions are explicitly rejected', () {
    final valid = backups.create(
      snapshot: fixtureSnapshot(),
      attachments: <String, Uint8List>{fixtureChecksum: fixtureAttachment},
    );
    final archive = ZipDecoder().decodeBytes(valid);
    final manifestFile = archive.find('manifest.json')!;
    final manifest = jsonDecode(utf8.decode(manifestFile.readBytes()!)) as Map<String, Object?>;
    manifest['formatVersion'] = 999;
    archive.add(ArchiveFile.string('manifest.json', jsonEncode(manifest)));

    expect(
      () => backups.validate(ZipEncoder().encodeBytes(archive)),
      throwsA(isA<UnsupportedBackupException>()),
    );
  });

  test('unsupported portable data schema is rejected without import', () {
    final valid = backups.create(
      snapshot: fixtureSnapshot(),
      attachments: <String, Uint8List>{fixtureChecksum: fixtureAttachment},
    );
    final archive = ZipDecoder().decodeBytes(valid);
    final dataFile = archive.find('data.json')!;
    final data = jsonDecode(utf8.decode(dataFile.readBytes()!)) as Map<String, Object?>;
    data['schemaVersion'] = 1;
    final encodedData = utf8.encode(jsonEncode(data));
    archive.add(ArchiveFile.bytes('data.json', encodedData));

    final manifestFile = archive.find('manifest.json')!;
    final manifest = jsonDecode(utf8.decode(manifestFile.readBytes()!)) as Map<String, Object?>;
    manifest['schemaVersion'] = 1;
    manifest['dataChecksumSha256'] = sha256.convert(encodedData).toString();
    archive.add(ArchiveFile.string('manifest.json', jsonEncode(manifest)));

    expect(
      () => backups.validate(ZipEncoder().encodeBytes(archive)),
      throwsA(isA<UnsupportedBackupException>()),
    );
  });

  test('schema v2 backups migrate to v5 after checksum validation', () {
    final valid = backups.create(
      snapshot: fixtureSnapshot(),
      attachments: <String, Uint8List>{fixtureChecksum: fixtureAttachment},
    );
    final archive = ZipDecoder().decodeBytes(valid);
    final dataFile = archive.find('data.json')!;
    final data = jsonDecode(utf8.decode(dataFile.readBytes()!)) as Map<String, Object?>;
    data['schemaVersion'] = 2;
    data.remove('respiratoryReminders');
    data.remove('weightReminders');
    final encodedData = utf8.encode(jsonEncode(data));
    archive.add(ArchiveFile.bytes('data.json', encodedData));

    final manifestFile = archive.find('manifest.json')!;
    final manifest = jsonDecode(utf8.decode(manifestFile.readBytes()!)) as Map<String, Object?>;
    manifest['schemaVersion'] = 2;
    manifest['dataChecksumSha256'] = sha256.convert(encodedData).toString();
    archive.add(ArchiveFile.string('manifest.json', jsonEncode(manifest)));

    final restored = backups.validate(ZipEncoder().encodeBytes(archive)).snapshot;
    expect(restored.schemaVersion, CreaturelySnapshot.currentSchemaVersion);
    expect(restored.respiratoryReminders, isEmpty);
    expect(restored.weightReminders, isEmpty);
    expect(restored.animals.single.name, 'Moss');
  });

  test('schema v3 backups migrate to v5 after checksum validation', () {
    final valid = backups.create(
      snapshot: fixtureSnapshot(),
      attachments: <String, Uint8List>{fixtureChecksum: fixtureAttachment},
    );
    final archive = ZipDecoder().decodeBytes(valid);
    final dataFile = archive.find('data.json')!;
    final data = jsonDecode(utf8.decode(dataFile.readBytes()!)) as Map<String, Object?>;
    data['schemaVersion'] = 3;
    data.remove('weightReminders');
    final legacyDocument = (data['documents']! as List<Object?>).single as Map<String, Object?>;
    legacyDocument['reminderAt'] = '2027-02-08T15:00:00.000Z';
    final encodedData = utf8.encode(jsonEncode(data));
    archive.add(ArchiveFile.bytes('data.json', encodedData));

    final manifestFile = archive.find('manifest.json')!;
    final manifest = jsonDecode(utf8.decode(manifestFile.readBytes()!)) as Map<String, Object?>;
    manifest['schemaVersion'] = 3;
    manifest['dataChecksumSha256'] = sha256.convert(encodedData).toString();
    archive.add(ArchiveFile.string('manifest.json', jsonEncode(manifest)));

    final restored = backups.validate(ZipEncoder().encodeBytes(archive)).snapshot;
    expect(restored.schemaVersion, CreaturelySnapshot.currentSchemaVersion);
    expect(restored.respiratoryReminders.single.id, 'respiratory-reminder-1');
    expect(restored.weightReminders, isEmpty);
    expect(restored.documents.single.toJson(), isNot(contains('reminderAt')));
  });

  test('schema v4 backups migrate to v5 with empty medication details', () {
    final valid = backups.create(
      snapshot: fixtureSnapshot(),
      attachments: <String, Uint8List>{fixtureChecksum: fixtureAttachment},
    );
    final archive = ZipDecoder().decodeBytes(valid);
    final dataFile = archive.find('data.json')!;
    final data = jsonDecode(utf8.decode(dataFile.readBytes()!)) as Map<String, Object?>;
    data['schemaVersion'] = 4;
    final legacyMedication = (data['medications']! as List<Object?>).single as Map<String, Object?>;
    for (final key in <String>[
      'strength',
      'pharmacy',
      'prescriptionNumber',
      'refillsRemaining',
      'nextRefillDate',
    ]) {
      legacyMedication.remove(key);
    }
    final encodedData = utf8.encode(jsonEncode(data));
    archive.add(ArchiveFile.bytes('data.json', encodedData));

    final manifestFile = archive.find('manifest.json')!;
    final manifest = jsonDecode(utf8.decode(manifestFile.readBytes()!)) as Map<String, Object?>;
    manifest['schemaVersion'] = 4;
    manifest['dataChecksumSha256'] = sha256.convert(encodedData).toString();
    archive.add(ArchiveFile.string('manifest.json', jsonEncode(manifest)));

    final restored = backups.validate(ZipEncoder().encodeBytes(archive)).snapshot;
    expect(restored.schemaVersion, CreaturelySnapshot.currentSchemaVersion);
    expect(restored.weightReminders.single.id, 'weight-reminder-1');
    expect(restored.medications.single.strength, isNull);
    expect(restored.medications.single.pharmacy, isNull);
    expect(restored.medications.single.prescriptionNumber, isNull);
    expect(restored.medications.single.refillsRemaining, isNull);
    expect(restored.medications.single.nextRefillDate, isNull);
  });

  test('negative refill counts reject the entire archive', () {
    final json = fixtureSnapshot().toJson();
    final medication = (json['medications']! as List<Object?>).single as Map<String, Object?>;
    medication['refillsRemaining'] = -1;
    final snapshot = CreaturelySnapshot.fromJson(json);
    final bytes = backups.create(
      snapshot: snapshot,
      attachments: <String, Uint8List>{fixtureChecksum: fixtureAttachment},
    );

    expect(() => backups.validate(bytes), throwsA(isA<CorruptBackupException>()));
  });

  test('broken animal ownership references reject the entire archive', () {
    final source = fixtureSnapshot();
    final brokenSession = RespiratorySession.fromJson(<String, Object?>{
      ...source.respiratorySessions.single.toJson(),
      'animalId': 'absent',
    });
    final broken = CreaturelySnapshot(
      schemaVersion: source.schemaVersion,
      exportedAt: source.exportedAt,
      animals: source.animals,
      identifiers: source.identifiers,
      respiratorySessions: <RespiratorySession>[brokenSession],
      respiratoryReminders: source.respiratoryReminders,
      weightReminders: source.weightReminders,
      medications: source.medications,
      medicationSchedules: source.medicationSchedules,
      doseLedger: source.doseLedger,
      healthRecords: source.healthRecords,
      documents: source.documents,
      settings: source.settings,
    );
    final bytes = backups.create(
      snapshot: broken,
      attachments: <String, Uint8List>{fixtureChecksum: fixtureAttachment},
    );
    expect(
      () => backups.validate(bytes),
      throwsA(
        isA<CorruptBackupException>().having(
          (error) => error.message,
          'message',
          contains('broken record references'),
        ),
      ),
    );
  });

  test('duplicate stable IDs reject the entire archive', () {
    final source = fixtureSnapshot();
    final json = source.toJson();
    final animals = json['animals']! as List<Object?>;
    json['animals'] = <Object?>[
      ...animals,
      <String, Object?>{...(animals.single as Map<String, Object?>), 'name': 'Duplicate Moss'},
    ];
    final duplicate = CreaturelySnapshot.fromJson(json);
    final bytes = backups.create(
      snapshot: duplicate,
      attachments: <String, Uint8List>{fixtureChecksum: fixtureAttachment},
    );

    expect(
      () => backups.validate(bytes),
      throwsA(
        isA<CorruptBackupException>().having(
          (error) => error.message,
          'message',
          contains('duplicate animals IDs'),
        ),
      ),
    );
  });

  test('undeclared archive files are rejected', () {
    final valid = backups.create(
      snapshot: fixtureSnapshot(),
      attachments: <String, Uint8List>{fixtureChecksum: fixtureAttachment},
    );
    final archive = ZipDecoder().decodeBytes(valid)
      ..add(ArchiveFile.string('unexpected.txt', 'not declared by the manifest'));

    expect(
      () => backups.validate(ZipEncoder().encodeBytes(archive)),
      throwsA(
        isA<CorruptBackupException>().having(
          (error) => error.message,
          'message',
          contains('undeclared files'),
        ),
      ),
    );
  });

  test('atomic restore rolls database back if attachment commit fails', () async {
    final previous = fixtureSnapshot();
    final nextJson = previous.toJson();
    final nextAnimals = (nextJson['animals']! as List<Object?>).cast<Map<String, Object?>>();
    nextAnimals[0] = <String, Object?>{...nextAnimals[0], 'name': 'Restored Moss'};
    final next = CreaturelySnapshot.fromJson(nextJson);
    final bytes = backups.create(
      snapshot: next,
      attachments: <String, Uint8List>{fixtureChecksum: fixtureAttachment},
    );
    final store = _MemoryStore(previous);
    final swap = _FailingSwap(<String, String>{fixtureChecksum: '/managed/restored.blob'});
    final documents = _FakeRestoreDocuments(swap);
    final safety = _MemorySafetyWriter();
    final coordinator = AtomicRestoreCoordinator(
      backups: backups,
      store: store,
      documents: documents,
      safetyWriter: safety,
    );

    await expectLater(coordinator.restore(bytes), throwsStateError);
    expect(store.current.animals.single.name, 'Moss');
    expect(store.replacements.map((value) => value.animals.single.name), <String>[
      'Restored Moss',
      'Moss',
    ]);
    expect(swap.rollbackCalled, isTrue);
    expect(swap.finalizeCalled, isFalse);
    expect(safety.bytes, isNotEmpty);
  });
}

class _MemoryStore implements SnapshotStore {
  _MemoryStore(this.current);

  CreaturelySnapshot current;
  final List<CreaturelySnapshot> replacements = <CreaturelySnapshot>[];

  @override
  Future<CreaturelySnapshot> loadSnapshot() async => current;

  @override
  Future<void> replaceSnapshot(CreaturelySnapshot snapshot) async {
    replacements.add(snapshot);
    current = snapshot;
  }
}

class _FakeRestoreDocuments implements RestoreDocumentStore {
  _FakeRestoreDocuments(this.swap);

  final AttachmentSwap swap;

  @override
  Future<Map<String, Uint8List>> readAttachments(Iterable<CareDocument> documents) async =>
      <String, Uint8List>{fixtureChecksum: fixtureAttachment};

  @override
  Future<Map<String, Uint8List>> readAnimalPhotos(Iterable<Animal> animals) async =>
      const <String, Uint8List>{};

  @override
  Future<AttachmentSwap> stageRestore(Map<String, Uint8List> attachments) async => swap;
}

class _FailingSwap implements AttachmentSwap {
  _FailingSwap(this.finalPaths);

  @override
  final Map<String, String> finalPaths;
  bool rollbackCalled = false;
  bool finalizeCalled = false;

  @override
  Future<void> commit() async => throw StateError('Simulated atomic file-swap failure.');

  @override
  Future<void> finalize() async {
    finalizeCalled = true;
  }

  @override
  Future<void> rollback() async {
    rollbackCalled = true;
  }
}

class _MemorySafetyWriter implements SafetySnapshotWriter {
  Uint8List bytes = Uint8List(0);

  @override
  Future<File> write(Uint8List bytes) async {
    this.bytes = bytes;
    return File('/unused/pre-restore.creaturely');
  }
}
