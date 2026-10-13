import 'dart:async';
import 'dart:io';

import 'package:creaturely/data/backup_service.dart';
import 'package:creaturely/data/database.dart';
import 'package:creaturely/data/document_storage.dart';
import 'package:creaturely/data/repository.dart';
import 'package:creaturely/domain/care_data.dart';
import 'package:creaturely/domain/models.dart';
import 'package:creaturely/platform/notification_service.dart';
import 'package:creaturely/platform/time_zone_service.dart';
import 'package:creaturely/ui/app_controller.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase database;
  late Directory directory;
  late DocumentStorage storage;
  late ProviderContainer container;
  setUp(() async {
    directory = await Directory.systemTemp.createTemp('creaturely-review-');
    storage = await DocumentStorage.open(Directory('${directory.path}/attachments'));
    database = AppDatabase.forTesting(NativeDatabase.memory());
    await database.replaceWith(fixtureSnapshot());
    container = ProviderContainer(
      overrides: [
        repositoryProvider.overrideWithValue(CreaturelyRepository(database)),
        documentStorageProvider.overrideWith((ref) async => storage),
        reminderServiceProvider.overrideWithValue(const NoopReminderService()),
        wallClockProvider.overrideWithValue(() => fixtureTime),
        timeZoneServiceProvider.overrideWithValue(
          DeviceTimeZoneService(lookupIdentifier: () async => 'UTC'),
        ),
      ],
    );
  });
  tearDown(() async {
    container.dispose();
    await database.close();
    await directory.delete(recursive: true);
  });

  test('a committed save remains successful after its provider is disposed', () async {
    final repository = _DelayedSave(database);
    container.updateOverrides([
      repositoryProvider.overrideWithValue(repository),
      documentStorageProvider.overrideWith((ref) async => storage),
      reminderServiceProvider.overrideWithValue(const NoopReminderService()),
      wallClockProvider.overrideWithValue(() => fixtureTime),
      timeZoneServiceProvider.overrideWithValue(
        DeviceTimeZoneService(lookupIdentifier: () async => 'UTC'),
      ),
    ]);
    final save = container
        .read(animalControllerProvider.notifier)
        .saveAnimal(fixtureAnimal().copyWith(name: 'Updated synthetic animal'));
    await repository.committed.future;
    container.dispose();
    repository.finish.complete();
    await expectLater(save, completes);
    expect((await database.readAnimals()).single.name, 'Updated synthetic animal');
  });

  test('a repeated notification action preserves the recorded administration time', () async {
    final original = (await database.findDose('dose-1'))!;
    await container.read(careControllerProvider.notifier).recordDose('dose-1', DoseStatus.given);
    final result = (await database.findDose('dose-1'))!;
    expect(result.administeredAt, original.administeredAt);
    expect(result.updatedAt, original.updatedAt);
  });

  test('a failed notification initialization remains visible until a real retry', () async {
    final service = _FailInitialization();
    container.updateOverrides([
      repositoryProvider.overrideWithValue(CreaturelyRepository(database)),
      documentStorageProvider.overrideWith((ref) async => storage),
      reminderServiceProvider.overrideWithValue(service),
      wallClockProvider.overrideWithValue(() => fixtureTime),
      timeZoneServiceProvider.overrideWithValue(
        DeviceTimeZoneService(lookupIdentifier: () async => 'UTC'),
      ),
    ]);
    await container.read(appControllerProvider.notifier).initialize();
    expect(container.read(appControllerProvider).error, isNull);
    expect(container.read(reminderSyncProvider).hasError, isTrue);
    expect(service.syncs, 0);
    await container.read(appControllerProvider.notifier).retryReminders();
    expect(service.initializations, 2);
    expect(service.syncs, 1);
    expect(container.read(reminderSyncProvider).hasError, isFalse);
  });
  test(
    'editing a given dose can clear its note without changing its administration time',
    () async {
      final before = (await database.findDose('dose-1'))!;
      await container
          .read(careControllerProvider.notifier)
          .recordDose(before.id, DoseStatus.given, clearNote: true);
      final after = (await database.findDose('dose-1'))!;
      expect(after.note, isNull);
      expect(after.administeredAt, before.administeredAt);
    },
  );

  test('an in-flight document save waits for cleanup and owns its draft lease', () async {
    final source = await File('${directory.path}/synthetic.pdf').writeAsBytes(fixtureAttachment);
    final attachment = await storage.importFile(source);
    final entered = Completer<void>();
    final finish = Completer<void>();
    final cleanup = storage.exclusiveFiles(() async {
      final references = await container.read(repositoryProvider).attachmentReferences();
      entered.complete();
      await finish.future;
      await storage.collectGarbage(references);
    });
    await entered.future;
    final document = CareDocument.fromJson({
      ...fixtureSnapshot().documents.single.toJson(),
      'storedPath': attachment.path,
    });
    final save = container.read(careControllerProvider.notifier).saveDocument(document);
    // Let the command acquire its lease and queue behind the file lock, then
    // simulate closing the form and releasing the form's separate draft lease.
    await Future<void>.delayed(Duration.zero);
    storage.release(attachment.path);
    finish.complete();
    await cleanup;
    await save;
    expect(
      await storage.inspect((await database.watchDocuments().first).single),
      AttachmentHealth.available,
    );
  });

  test('a queued save retains its attachment after its form releases the draft', () async {
    final repository = _DelayedSessionSave(database);
    container.updateOverrides([
      repositoryProvider.overrideWithValue(repository),
      documentStorageProvider.overrideWith((ref) async => storage),
      reminderServiceProvider.overrideWithValue(const NoopReminderService()),
      wallClockProvider.overrideWithValue(() => fixtureTime),
      timeZoneServiceProvider.overrideWithValue(
        DeviceTimeZoneService(lookupIdentifier: () async => 'UTC'),
      ),
    ]);
    final source = await File('${directory.path}/synthetic.pdf').writeAsBytes(fixtureAttachment);
    final attachment = await storage.importFile(source);
    final care = container.read(careControllerProvider.notifier);
    final preceding = care.saveRespiratorySession(fixtureSnapshot().respiratorySessions.single);
    await repository.entered.future;
    final save = care.saveDocument(
      CareDocument.fromJson({
        ...fixtureSnapshot().documents.single.toJson(),
        'storedPath': attachment.path,
      }),
    );
    await Future<void>.delayed(Duration.zero);
    storage.release(attachment.path);
    await storage.collectGarbage(await repository.attachmentReferences());
    expect(await File(attachment.path).exists(), isTrue);
    repository.finish.complete();
    await preceding;
    await save;
    expect(
      await storage.inspect((await database.watchDocuments().first).single),
      AttachmentHealth.available,
    );
  });

  test('committed restore succeeds when optional foreground maintenance fails', () async {
    container.updateOverrides([
      repositoryProvider.overrideWithValue(CreaturelyRepository(database)),
      documentStorageProvider.overrideWith((ref) async => storage),
      reminderServiceProvider.overrideWithValue(const NoopReminderService()),
      wallClockProvider.overrideWithValue(() => fixtureTime),
      timeZoneServiceProvider.overrideWithValue(_FailTimeZone()),
    ]);
    final json = fixtureSnapshot().toJson();
    json['animals'] = [
      {...fixtureAnimal().toJson(), 'name': 'Restored synthetic animal'},
    ];
    const backups = CreaturelyBackupService();
    final backup = backups.validate(
      backups.create(
        snapshot: CreaturelySnapshot.fromJson(json),
        attachments: {fixtureChecksum: fixtureAttachment},
      ),
    );
    await expectLater(
      container.read(recoveryControllerProvider.notifier).restore(backup),
      completes,
    );
    expect((await database.readAnimals()).single.name, 'Restored synthetic animal');
    expect(container.read(reminderSyncProvider).hasError, isTrue);
  });
  test('automatic recovery failures are observable without blocking the local journal', () async {
    await database.saveSettings(
      (await database.readSettings()).copyWith(automaticRecoveryEnabled: true),
    );
    final failed = Completer<void>();
    container.listen(appControllerProvider, (_, status) {
      if (status.recoveryError != null && !failed.isCompleted) failed.complete();
    });
    await container.read(appControllerProvider.notifier).initialize();
    await failed.future;
    expect(container.read(appControllerProvider).loading, isFalse);
    expect(container.read(appControllerProvider).error, isNull);
    expect(container.read(appControllerProvider).recoveryError, isNotNull);
    expect((await database.readAnimals()).single.name, 'Moss');
  });

  test('a failed cold-launch dose action remains queued for an explicit retry', () async {
    final repository = _FailDoseOnce(database);
    container.updateOverrides([
      repositoryProvider.overrideWithValue(repository),
      documentStorageProvider.overrideWith((ref) async => storage),
      reminderServiceProvider.overrideWithValue(_StartupDoseAction()),
      wallClockProvider.overrideWithValue(() => fixtureTime),
      timeZoneServiceProvider.overrideWithValue(
        DeviceTimeZoneService(lookupIdentifier: () async => 'UTC'),
      ),
    ]);
    final failed = Completer<void>();
    container.listen(appControllerProvider, (_, status) {
      if (status.notificationActionError != null && !failed.isCompleted) failed.complete();
    });
    final app = container.read(appControllerProvider.notifier);
    app.navigationReady();
    await app.initialize();
    await failed.future;
    expect((await database.findDose('dose-1'))!.status, DoseStatus.given);
    await app.retryNotificationAction();
    expect((await database.findDose('dose-1'))!.status, DoseStatus.skipped);
    expect(container.read(appControllerProvider).notificationActionError, isNull);
    expect(repository.writes, 2);
  });
}

class _DelayedSave extends CreaturelyRepository {
  _DelayedSave(super.database);
  final committed = Completer<void>();
  final finish = Completer<void>();
  @override
  Future<void> saveAnimal(Animal animal) async {
    await super.saveAnimal(animal);
    committed.complete();
    await finish.future;
  }
}

class _FailInitialization extends NoopReminderService {
  int syncs = 0;
  int initializations = 0;
  @override
  Future<void> initialize(void Function(NotificationAction) onAction) async {
    if (++initializations == 1) throw StateError('Synthetic plugin initialization failure');
  }

  @override
  Future<void> sync(CareData care, DateTime now) async => syncs++;
}

class _DelayedSessionSave extends CreaturelyRepository {
  _DelayedSessionSave(super.database);
  final entered = Completer<void>();
  final finish = Completer<void>();
  @override
  Future<void> saveRespiratorySession(RespiratorySession session) async {
    entered.complete();
    await finish.future;
    await super.saveRespiratorySession(session);
  }
}

class _FailTimeZone implements TimeZoneService {
  @override
  Future<String?> configure() async => throw StateError('Synthetic device time zone failure');
}

class _FailDoseOnce extends CreaturelyRepository {
  _FailDoseOnce(super.database);
  int writes = 0;
  @override
  Future<void> saveDose(DoseLedgerEntry dose) async {
    if (++writes == 1) throw StateError('Synthetic dose write failure');
    await super.saveDose(dose);
  }
}

class _StartupDoseAction extends NoopReminderService {
  @override
  Future<void> initialize(void Function(NotificationAction) onAction) async =>
      onAction(NotificationAction.dose('dose-1', DoseStatus.skipped));
}
