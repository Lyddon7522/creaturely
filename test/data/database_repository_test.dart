import 'package:creaturely/data/database.dart';
import 'package:creaturely/data/repository.dart';
import 'package:creaturely/domain/models.dart';
import 'package:creaturely/platform/notification_service.dart';
import 'package:creaturely/platform/time_zone_service.dart';
import 'package:creaturely/ui/app_controller.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../support/fixtures.dart';

void main() {
  late AppDatabase database;
  late CreaturelyRepository repository;

  setUpAll(tz_data.initializeTimeZones);

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = CreaturelyRepository(database);
  });

  tearDown(() => database.close());

  test('Drift round-trip preserves the complete typed snapshot', () async {
    final expected = fixtureSnapshot();
    await repository.replaceSnapshot(expected);
    final actual = await repository.loadSnapshot();

    expect(actual.animals.single.toJson(), expected.animals.single.toJson());
    expect(actual.identifiers.single.toJson(), expected.identifiers.single.toJson());
    expect(
      actual.respiratorySessions.single.toJson(),
      expected.respiratorySessions.single.toJson(),
    );
    expect(
      actual.respiratoryReminders.single.toJson(),
      expected.respiratoryReminders.single.toJson(),
    );
    expect(actual.weightReminders.single.toJson(), expected.weightReminders.single.toJson());
    expect(actual.medications.single.toJson(), expected.medications.single.toJson());
    expect(
      actual.medicationSchedules.single.toJson(),
      expected.medicationSchedules.single.toJson(),
    );
    expect(actual.doseLedger.single.toJson(), expected.doseLedger.single.toJson());
    expect(actual.healthRecords.single.toJson(), expected.healthRecords.single.toJson());
    expect(actual.documents.single.toJson(), expected.documents.single.toJson());
    expect(actual.settings.toJson(), expected.settings.toJson());
  });

  test('replace is transactional when a restored snapshot has invalid ownership', () async {
    await repository.replaceSnapshot(fixtureSnapshot());
    final invalid = CreaturelySnapshot(
      schemaVersion: CreaturelySnapshot.currentSchemaVersion,
      exportedAt: fixtureTime,
      animals: const <Animal>[],
      identifiers: const <AnimalIdentifier>[],
      respiratorySessions: const <RespiratorySession>[],
      medications: const <Medication>[],
      medicationSchedules: const <MedicationSchedule>[],
      doseLedger: const <DoseLedgerEntry>[],
      healthRecords: const <HealthRecord>[],
      documents: fixtureSnapshot().documents,
      settings: const AppSettings(),
    );

    await expectLater(repository.replaceSnapshot(invalid), throwsA(isA<Exception>()));
    final after = await repository.loadSnapshot();
    expect(after.animals.single.name, 'Moss');
    expect(after.documents.single.id, 'document-1');
  });

  test('saving a weigh-in updates canonical current weight without unit loss', () async {
    await repository.saveAnimal(fixtureAnimal());
    final record = HealthRecord(
      id: 'weight-new',
      animalId: 'animal-1',
      createdAt: fixtureTime,
      updatedAt: fixtureTime.add(const Duration(minutes: 1)),
      occurredAt: fixtureTime,
      kind: HealthRecordKind.weight,
      title: 'Weigh-in',
      canonicalValue: 1.23456789,
      canonicalUnit: 'kg',
      enteredUnit: 'lb',
    );
    await repository.saveHealthRecord(record);

    final snapshot = await repository.loadSnapshot();
    expect(snapshot.healthRecords.single.canonicalValue, 1.23456789);
    expect(snapshot.animals.single.currentWeightKg, 1.23456789);
  });

  test('backfilled and redated weigh-ins keep the latest occurrence as current', () async {
    await repository.saveAnimal(fixtureAnimal());
    final older = _weightRecord(
      id: 'weight-older',
      occurredAt: fixtureTime.add(const Duration(days: 1)),
      value: 1,
    );
    final newer = _weightRecord(
      id: 'weight-newer',
      occurredAt: fixtureTime.add(const Duration(days: 2)),
      value: 2,
    );

    await repository.saveHealthRecord(newer);
    await repository.saveHealthRecord(older);

    var snapshot = await repository.loadSnapshot();
    expect(snapshot.animals.single.currentWeightKg, 2);

    await repository.saveHealthRecord(
      _weightRecord(
        id: newer.id,
        createdAt: newer.createdAt,
        updatedAt: fixtureTime.add(const Duration(days: 3)),
        occurredAt: fixtureTime,
        value: 3,
      ),
    );

    snapshot = await repository.loadSnapshot();
    expect(snapshot.animals.single.currentWeightKg, 1);
  });

  test('deleting weigh-ins restores the latest remaining weight and then clears it', () async {
    await repository.saveAnimal(fixtureAnimal());
    final older = _weightRecord(id: 'weight-older', occurredAt: fixtureTime, value: 1);
    final newer = _weightRecord(
      id: 'weight-newer',
      occurredAt: fixtureTime.add(const Duration(days: 1)),
      value: 2,
    );
    await repository.saveHealthRecord(older);
    await repository.saveHealthRecord(newer);

    await repository.delete('health_records', newer.id);
    var snapshot = await repository.loadSnapshot();
    expect(snapshot.animals.single.currentWeightKg, 1);

    await repository.delete('health_records', older.id);
    snapshot = await repository.loadSnapshot();
    expect(snapshot.animals.single.currentWeightKg, isNull);
  });

  test('changing a weigh-in to another record kind recomputes current weight', () async {
    await repository.saveAnimal(fixtureAnimal());
    final weight = _weightRecord(id: 'weight-to-edit', occurredAt: fixtureTime, value: 1);
    await repository.saveHealthRecord(weight);

    await repository.saveHealthRecord(
      HealthRecord(
        id: weight.id,
        animalId: weight.animalId,
        createdAt: weight.createdAt,
        updatedAt: fixtureTime.add(const Duration(minutes: 1)),
        occurredAt: weight.occurredAt,
        kind: HealthRecordKind.observation,
        title: 'General observation',
        note: 'No longer a weigh-in.',
      ),
    );

    final snapshot = await repository.loadSnapshot();
    expect(snapshot.animals.single.currentWeightKg, isNull);
  });

  test('medication edit replaces future unrecorded doses without duplicates', () async {
    final initial = fixtureSnapshot();
    await repository.replaceSnapshot(
      CreaturelySnapshot(
        schemaVersion: initial.schemaVersion,
        exportedAt: initial.exportedAt,
        animals: initial.animals,
        identifiers: initial.identifiers,
        respiratorySessions: initial.respiratorySessions,
        respiratoryReminders: initial.respiratoryReminders,
        weightReminders: initial.weightReminders,
        medications: initial.medications,
        medicationSchedules: initial.medicationSchedules,
        doseLedger: <DoseLedgerEntry>[
          fixtureDose(status: DoseStatus.unrecorded),
          DoseLedgerEntry(
            id: 'given-history',
            medicationId: 'med-1',
            scheduleId: 'schedule-1',
            animalId: 'animal-1',
            createdAt: fixtureTime,
            updatedAt: fixtureTime,
            dueAt: fixtureTime,
            intendedLocalTime: '2026-03-07T06:00',
            timeZoneId: 'America/Chicago',
            status: DoseStatus.given,
            administeredAt: fixtureTime,
          ),
        ],
        healthRecords: initial.healthRecords,
        documents: initial.documents,
        settings: initial.settings,
      ),
    );
    final replacementSchedule = MedicationSchedule(
      id: 'schedule-new',
      medicationId: 'med-1',
      animalId: 'animal-1',
      createdAt: fixtureTime,
      updatedAt: fixtureTime,
      kind: ScheduleKind.daily,
      timeZoneId: 'America/Chicago',
      times: const <LocalClockTime>[LocalClockTime(19, 0)],
    );
    final replacementDose = DoseLedgerEntry(
      id: 'dose-new',
      medicationId: 'med-1',
      scheduleId: 'schedule-new',
      animalId: 'animal-1',
      createdAt: fixtureTime,
      updatedAt: fixtureTime,
      dueAt: fixtureTime.add(const Duration(days: 1)),
      intendedLocalTime: '2026-03-08T19:00',
      timeZoneId: 'America/Chicago',
      status: DoseStatus.unrecorded,
    );

    await repository.saveMedication(
      fixtureMedication().copyWith(instructions: 'Updated instruction'),
      <MedicationSchedule>[replacementSchedule],
      <DoseLedgerEntry>[replacementDose],
    );
    final result = await repository.loadSnapshot();
    expect(result.medicationSchedules.map((value) => value.id), <String>['schedule-new']);
    expect(result.doseLedger.map((value) => value.id).toSet(), <String>{
      'given-history',
      'dose-new',
    });
    expect(
      result.doseLedger.singleWhere((value) => value.id == 'given-history').scheduleId,
      isNull,
    );
  });

  for (final status in <DoseStatus>[DoseStatus.given, DoseStatus.skipped]) {
    test('medication edit does not regenerate a recently ${status.name} dose', () async {
      final dueAt = DateTime.utc(2026, 3, 7, 14, 30);
      final now = dueAt.add(const Duration(hours: 1));
      final completedDose = DoseLedgerEntry(
        id: 'completed-${status.name}',
        medicationId: 'med-1',
        scheduleId: 'schedule-1',
        animalId: 'animal-1',
        createdAt: fixtureTime,
        updatedAt: now,
        dueAt: dueAt,
        intendedLocalTime: '2026-03-07T08:30',
        timeZoneId: 'America/Chicago',
        status: status,
        administeredAt: status == DoseStatus.given ? now : null,
      );
      final initial = fixtureSnapshot();
      await repository.replaceSnapshot(
        CreaturelySnapshot(
          schemaVersion: initial.schemaVersion,
          exportedAt: initial.exportedAt,
          animals: initial.animals,
          identifiers: initial.identifiers,
          respiratorySessions: initial.respiratorySessions,
          respiratoryReminders: initial.respiratoryReminders,
          weightReminders: initial.weightReminders,
          medications: initial.medications,
          medicationSchedules: initial.medicationSchedules,
          doseLedger: <DoseLedgerEntry>[completedDose],
          healthRecords: initial.healthRecords,
          documents: initial.documents,
          settings: initial.settings,
        ),
      );
      final controller = AppController(
        repository: repository,
        reminders: const NoopReminderService(),
        timeZones: const _UnresolvedTimeZoneService(),
        clock: () => now,
      );
      addTearDown(controller.dispose);
      await controller.initialize();

      await controller.saveMedication(
        fixtureMedication().copyWith(updatedAt: now),
        <MedicationSchedule>[fixtureSchedule().copyWith(updatedAt: now)],
      );

      final occurrenceEntries = controller.state.snapshot.doseLedger
          .where((dose) => dose.medicationId == 'med-1' && dose.dueAt.isAtSameMomentAs(dueAt))
          .toList(growable: false);
      expect(occurrenceEntries, hasLength(1));
      expect(occurrenceEntries.single.status, status);
    });
  }

  test('deactivating medication preserves history without generating future doses', () async {
    await repository.replaceSnapshot(fixtureSnapshot());
    final controller = AppController(
      repository: repository,
      reminders: const NoopReminderService(),
      timeZones: const _UnresolvedTimeZoneService(),
      clock: () => fixtureTime,
    );
    addTearDown(controller.dispose);
    await controller.initialize();

    await controller.saveMedication(
      fixtureMedication().copyWith(active: false, updatedAt: fixtureTime),
      <MedicationSchedule>[fixtureSchedule()],
    );

    final result = controller.state.snapshot;
    expect(result.medications.single.active, isFalse);
    expect(result.doseLedger, hasLength(1));
    expect(result.doseLedger.single.status, DoseStatus.given);
    expect(result.doseLedger.where((dose) => dose.status == DoseStatus.unrecorded), isEmpty);
  });

  test('resume rebases local-time schedules after a device time-zone change', () async {
    await repository.replaceSnapshot(fixtureSnapshot());
    final timeZones = _MutableTimeZoneService('America/Chicago');
    final controller = AppController(
      repository: repository,
      reminders: const NoopReminderService(permission: NotificationPermissionState.allowed),
      timeZones: timeZones,
      clock: () => fixtureTime,
    );
    addTearDown(controller.dispose);

    await controller.initialize();
    expect(controller.state.snapshot.medicationSchedules.single.timeZoneId, 'America/Chicago');
    timeZones.identifier = 'America/Los_Angeles';
    await controller.handleAppResumed();

    final result = controller.state.snapshot;
    expect(result.medicationSchedules.single.timeZoneId, 'America/Los_Angeles');
    expect(result.respiratoryReminders.single.timeZoneId, 'America/Los_Angeles');
    expect(result.weightReminders.single.timeZoneId, 'America/Los_Angeles');
    final generated = result.doseLedger
        .where((dose) => dose.status == DoseStatus.unrecorded)
        .toList(growable: false);
    expect(generated, isNotEmpty);
    expect(generated.map((dose) => dose.id).toSet(), hasLength(generated.length));
    expect(generated.every((dose) => dose.timeZoneId == 'America/Los_Angeles'), isTrue);
    final losAngeles = tz.getLocation('America/Los_Angeles');
    expect(generated.map((dose) => tz.TZDateTime.from(dose.dueAt, losAngeles).hour).toSet(), <int>{
      8,
    });
    expect(result.doseLedger.where((dose) => dose.status == DoseStatus.given), hasLength(1));
  });

  test('turning notifications off clears already scheduled reminders', () async {
    await repository.replaceSnapshot(fixtureSnapshot());
    final reminders = _CapturingReminderService();
    final controller = AppController(
      repository: repository,
      reminders: reminders,
      timeZones: const _UnresolvedTimeZoneService(),
      clock: () => fixtureTime,
    );
    addTearDown(controller.dispose);
    await controller.initialize();
    expect(reminders.syncCalls, 1);

    await controller.saveSettings(
      controller.state.snapshot.settings.copyWith(notificationsAllowed: false),
    );

    expect(reminders.clearCalls, 1);
  });

  test('weight notification opens a new weigh-in for the correct animal', () async {
    await repository.replaceSnapshot(fixtureSnapshot());
    final reminders = _CapturingReminderService();
    final controller = AppController(
      repository: repository,
      reminders: reminders,
      timeZones: const _UnresolvedTimeZoneService(),
      clock: () => fixtureTime,
    );
    addTearDown(controller.dispose);
    await controller.initialize();

    reminders.trigger(
      NotificationAction.openWeight(reminderId: 'weight-reminder-1', animalId: 'animal-1'),
    );

    expect(controller.state.pendingRoute, '/health/new/animal-1');
  });

  test('platform reminder failures never block the local journal', () async {
    await repository.replaceSnapshot(fixtureSnapshot());
    final controller = AppController(
      repository: repository,
      reminders: const _FailingReminderService(),
      timeZones: const _UnresolvedTimeZoneService(),
      clock: () => fixtureTime,
    );
    addTearDown(controller.dispose);

    await controller.initialize();

    expect(controller.state.loading, isFalse);
    expect(controller.state.error, isNull);
    expect(controller.state.snapshot.animals.single.name, 'Moss');
    expect(await controller.requestNotifications(), NotificationPermissionState.denied);
    expect(controller.state.snapshot.settings.notificationsAllowed, isFalse);
    expect(controller.state.snapshot.settings.notificationPermissionAsked, isTrue);
  });

  test('actual Drift v1 schema migrates through weight reminders in v4', () async {
    await database.close();
    final executor = NativeDatabase.memory(
      setup: (sqlite) {
        sqlite.execute('''
          CREATE TABLE medication_schedule_rows (
            id TEXT NOT NULL PRIMARY KEY,
            medication_id TEXT NOT NULL,
            animal_id TEXT NOT NULL,
            created_at INTEGER NOT NULL,
            updated_at INTEGER NOT NULL,
            kind TEXT NOT NULL,
            interval_hours INTEGER,
            times_json TEXT NOT NULL DEFAULT '[]',
            weekdays_json TEXT NOT NULL DEFAULT '[]',
            enabled INTEGER NOT NULL DEFAULT 1
          )
        ''');
        sqlite.userVersion = 1;
      },
    );
    final migrated = AppDatabase.forTesting(executor);
    addTearDown(migrated.close);

    final columns = await migrated
        .customSelect('PRAGMA table_info(medication_schedule_rows)')
        .get();
    expect(columns.map((row) => row.read<String>('name')), contains('time_zone_id'));
    final tables = await migrated
        .customSelect("SELECT name FROM sqlite_master WHERE type = 'table'")
        .get();
    expect(tables.map((row) => row.read<String>('name')), contains('care_document_rows'));
    expect(tables.map((row) => row.read<String>('name')), contains('respiratory_reminder_rows'));
    expect(tables.map((row) => row.read<String>('name')), contains('weight_reminder_rows'));
  });

  test('v4 migration retires legacy document reminder timestamps', () async {
    await database.close();
    final executor = NativeDatabase.memory(
      setup: (sqlite) {
        sqlite.execute('''
          CREATE TABLE care_document_rows (
            id TEXT NOT NULL PRIMARY KEY,
            reminder_at TEXT
          )
        ''');
        sqlite.execute('''
          INSERT INTO care_document_rows (id, reminder_at)
          VALUES ('legacy-document', '2027-02-08T15:00:00.000Z')
        ''');
        sqlite.userVersion = 3;
      },
    );
    final migrated = AppDatabase.forTesting(executor);
    addTearDown(migrated.close);

    final row = await migrated
        .customSelect("SELECT reminder_at FROM care_document_rows WHERE id = 'legacy-document'")
        .getSingle();
    expect(row.data['reminder_at'], isNull);
  });
}

HealthRecord _weightRecord({
  required String id,
  required DateTime occurredAt,
  required double value,
  DateTime? createdAt,
  DateTime? updatedAt,
}) => HealthRecord(
  id: id,
  animalId: 'animal-1',
  createdAt: createdAt ?? fixtureTime,
  updatedAt: updatedAt ?? fixtureTime,
  occurredAt: occurredAt,
  kind: HealthRecordKind.weight,
  title: 'Weigh-in',
  canonicalValue: value,
  canonicalUnit: 'kg',
  enteredUnit: 'kg',
);

class _MutableTimeZoneService implements TimeZoneService {
  _MutableTimeZoneService(this.identifier);

  String identifier;

  @override
  Future<String?> configure() async {
    tz.setLocalLocation(tz.getLocation(identifier));
    return identifier;
  }
}

class _UnresolvedTimeZoneService implements TimeZoneService {
  const _UnresolvedTimeZoneService();

  @override
  Future<String?> configure() async => null;
}

class _CapturingReminderService implements ReminderService {
  int syncCalls = 0;
  int clearCalls = 0;
  void Function(NotificationAction action)? _onAction;

  void trigger(NotificationAction action) => _onAction!(action);

  @override
  Future<void> clear() async {
    clearCalls++;
  }

  @override
  Future<void> initialize(void Function(NotificationAction action) onAction) async {
    _onAction = onAction;
  }

  @override
  Future<NotificationPermissionState> requestPermission() async =>
      NotificationPermissionState.allowed;

  @override
  Future<void> sync(CreaturelySnapshot snapshot, DateTime now) async {
    syncCalls++;
  }
}

class _FailingReminderService implements ReminderService {
  const _FailingReminderService();

  @override
  Future<void> clear() => throw StateError('Platform notifications unavailable');

  @override
  Future<void> initialize(void Function(NotificationAction action) onAction) =>
      throw StateError('Platform notifications unavailable');

  @override
  Future<NotificationPermissionState> requestPermission() =>
      throw StateError('Platform notifications unavailable');

  @override
  Future<void> sync(CreaturelySnapshot snapshot, DateTime now) =>
      throw StateError('Platform notifications unavailable');
}
