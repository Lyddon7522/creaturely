import 'dart:io';

import 'package:archive/archive.dart';
import 'package:creaturely/data/backup_service.dart';
import 'package:creaturely/data/database.dart';
import 'package:creaturely/data/document_storage.dart';
import 'package:creaturely/data/repository.dart';
import 'package:creaturely/domain/models.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fixtures.dart';

void main() {
  test('restoring data preserves this device notification and cloud choices', () async {
    final directory = await Directory.systemTemp.createTemp('restore-device-choices-');
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(() async {
      await db.close();
      await directory.delete(recursive: true);
    });
    final repository = CreaturelyRepository(db);
    await repository.replaceSnapshot(CreaturelySnapshot.empty());
    final storage = await DocumentStorage.open(Directory('${directory.path}/attachments'));
    final json = fixtureSnapshot().toJson();
    json['settings'] = const AppSettings(
      notificationsAllowed: true,
      notificationPermissionAsked: true,
      automaticRecoveryEnabled: true,
      cloudProvider: CloudProvider.cloudKit,
      defaultTimerSeconds: 60,
    ).toJson();
    const backups = CreaturelyBackupService();
    await AtomicRestoreCoordinator(
      backups: backups,
      store: repository,
      documents: storage,
      safetyWriter: DirectorySafetySnapshotWriter(Directory('${directory.path}/recovery')),
    ).restore(
      backups.create(
        snapshot: CreaturelySnapshot.fromJson(json),
        attachments: {fixtureChecksum: fixtureAttachment},
      ),
    );
    final settings = await db.readSettings();
    expect(settings.notificationsAllowed, isFalse);
    expect(settings.notificationPermissionAsked, isFalse);
    expect(settings.automaticRecoveryEnabled, isFalse);
    expect(settings.cloudProvider, CloudProvider.none);
    expect(settings.defaultTimerSeconds, 60);
  });
  for (final afterCommit in [false, true]) {
    test(
      'restore interruption ${afterCommit ? 'after' : 'before'} commit leaves readable references',
      () async {
        final directory = await Directory.systemTemp.createTemp('restore-interruption-');
        final db = AppDatabase.forTesting(NativeDatabase(File('${directory.path}/journal.sqlite')));
        final repository = CreaturelyRepository(db);
        final storage = await DocumentStorage.open(Directory('${directory.path}/attachments'));
        final source = File('${directory.path}/source.pdf');
        await source.writeAsBytes(fixtureAttachment);
        final original = await storage.importFile(source);
        final json = fixtureSnapshot().toJson();
        json['documents'] = [
          {...fixtureSnapshot().documents.single.toJson(), 'storedPath': original.path},
        ];
        await repository.replaceSnapshot(CreaturelySnapshot.fromJson(json));
        final next = fixtureSnapshot().toJson();
        next['animals'] = [
          {...fixtureAnimal().toJson(), 'name': 'Restored animal'},
        ];
        const backups = CreaturelyBackupService();
        final bytes = backups.create(
          snapshot: CreaturelySnapshot.fromJson(next),
          attachments: {fixtureChecksum: fixtureAttachment},
        );
        await expectLater(
          AtomicRestoreCoordinator(
            backups: backups,
            store: _InterruptedStore(repository, afterCommit),
            documents: storage,
            safetyWriter: DirectorySafetySnapshotWriter(Directory('${directory.path}/recovery')),
          ).restore(bytes),
          throwsStateError,
        );
        await db.close();
        final reopened = AppDatabase.forTesting(
          NativeDatabase(File('${directory.path}/journal.sqlite')),
        );
        final result = await reopened.snapshot();
        expect(result.animals.single.name, afterCommit ? 'Restored animal' : 'Moss');
        expect(await File(result.documents.single.storedPath).readAsBytes(), fixtureAttachment);
        expect(await File(original.path).exists(), isTrue);
        await reopened.close();
        await directory.delete(recursive: true);
      },
    );
  }
  for (final corrupt in [false, true]) {
    test(
      'valid restore repairs a ${corrupt ? 'corrupt' : 'missing'} current attachment and retains recovery metadata',
      () async {
        final directory = await Directory.systemTemp.createTemp('restore-damaged-');
        final db = AppDatabase.forTesting(NativeDatabase.memory());
        final repository = CreaturelyRepository(db);
        final storage = await DocumentStorage.open(Directory('${directory.path}/attachments'));
        final original = File('${directory.path}/attachments/current.pdf');
        if (corrupt) await original.writeAsBytes([9, 9, 9]);
        await repository.replaceSnapshot(fixtureSnapshot(storedPath: original.path));
        const backups = CreaturelyBackupService();
        final bytes = backups.create(
          snapshot: fixtureSnapshot(),
          attachments: {fixtureChecksum: fixtureAttachment},
        );
        final recovery = Directory('${directory.path}/recovery');
        await AtomicRestoreCoordinator(
          backups: backups,
          store: repository,
          documents: storage,
          safetyWriter: DirectorySafetySnapshotWriter(recovery),
        ).restore(bytes);
        final result = await repository.loadSnapshot();
        expect(await storage.inspect(result.documents.single), AttachmentHealth.available);
        final safety = (await recovery.list().toList()).whereType<File>().single;
        expect(safety.path, endsWith('.recovery.zip'));
        expect(
          ZipDecoder().decodeBytes(await safety.readAsBytes()).find('original-data.json'),
          isNotNull,
        );
        if (corrupt) {
          final archive = ZipDecoder().decodeBytes(await safety.readAsBytes());
          final retained = archive.files.singleWhere(
            (entry) => entry.name.startsWith('available/'),
          );
          expect(retained.readBytes(), [9, 9, 9]);
        }
        await db.close();
        await directory.delete(recursive: true);
      },
    );
  }
  test(
    'overlapping restores publish complete generations in order and collect unreachable files',
    () async {
      final directory = await Directory.systemTemp.createTemp('restore-concurrent-');
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(() async {
        await db.close();
        await directory.delete(recursive: true);
      });
      final repository = CreaturelyRepository(db);
      await repository.replaceSnapshot(fixtureSnapshot());
      final storage = await DocumentStorage.open(Directory('${directory.path}/attachments'));
      const backups = CreaturelyBackupService();
      ValidatedBackup backup(String name) {
        final json = fixtureSnapshot().toJson();
        json['animals'] = [
          {...fixtureAnimal().toJson(), 'name': name},
        ];
        return backups.validate(
          backups.create(
            snapshot: CreaturelySnapshot.fromJson(json),
            attachments: {fixtureChecksum: fixtureAttachment},
          ),
        );
      }

      final coordinator = AtomicRestoreCoordinator(
        backups: backups,
        store: repository,
        documents: storage,
        safetyWriter: DirectorySafetySnapshotWriter(Directory('${directory.path}/recovery')),
      );
      await Future.wait([
        coordinator.restoreValidated(backup('First restored animal')),
        coordinator.restoreValidated(backup('Second restored animal')),
      ]);
      final snapshot = await repository.loadSnapshot();
      expect(snapshot.animals.single.name, 'Second restored animal');
      await storage.collectGarbage(await repository.attachmentReferences());
      expect(await storage.inspect(snapshot.documents.single), AttachmentHealth.available);
      final files = (await storage.root.list(recursive: true).toList()).whereType<File>();
      expect(files.map((file) => file.path), [snapshot.documents.single.storedPath]);
    },
  );
}

class _InterruptedStore implements SnapshotStore {
  _InterruptedStore(this.store, this.afterCommit);
  final CreaturelyRepository store;
  final bool afterCommit;
  @override
  Future<CreaturelySnapshot> loadSnapshot() => store.loadSnapshot();
  @override
  Future<void> replaceSnapshot(CreaturelySnapshot snapshot) async {
    if (!afterCommit) throw StateError('Interrupted before database commit');
    await store.replaceSnapshot(snapshot);
  }

  @override
  Future<T> exclusive<T>(Future<T> Function() action) async {
    final result = await store.exclusive(action);
    if (afterCommit) throw StateError('Interrupted after database commit');
    return result;
  }
}
