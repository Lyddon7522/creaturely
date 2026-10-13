import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../domain/care_data.dart';
import '../domain/models.dart' as domain;

part 'database.g.dart';

@DataClassName('AnimalEntity')
class AnimalRows extends Table {
  TextColumn get id => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get name => text()();
  TextColumn get photoPath => text().nullable()();
  TextColumn get species => text()();
  TextColumn get breed => text().nullable()();
  TextColumn get sexOrStatus => text().nullable()();
  DateTimeColumn get dateOfBirth => dateTime().nullable()();
  IntColumn get approximateAgeMonths => integer().nullable()();
  TextColumn get colorMarkings => text().nullable()();
  RealColumn get currentWeightKg => real().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
  RealColumn get thresholdMinimum => real().nullable()();
  RealColumn get thresholdTarget => real().nullable()();
  RealColumn get thresholdMaximum => real().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('IdentifierEntity')
class IdentifierRows extends Table {
  TextColumn get id => text()();
  TextColumn get animalId => text().references(AnimalRows, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get type => text()();
  TextColumn get value => text()();
  TextColumn get issuer => text().nullable()();
  TextColumn get url => text().nullable()();
  TextColumn get phone => text().nullable()();
  DateTimeColumn get issuedOn => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('RespiratorySessionEntity')
class RespiratorySessionRows extends Table {
  TextColumn get id => text()();
  TextColumn get animalId => text().references(AnimalRows, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get recordedAt => dateTime()();
  IntColumn get durationMilliseconds => integer()();
  IntColumn get breathCount => integer()();
  RealColumn get ratePerMinute => real()();
  TextColumn get context => text()();
  TextColumn get note => text().nullable()();
  RealColumn get thresholdMinimum => real().nullable()();
  RealColumn get thresholdTarget => real().nullable()();
  RealColumn get thresholdMaximum => real().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('RespiratoryReminderEntity')
class RespiratoryReminderRows extends Table {
  TextColumn get id => text()();
  TextColumn get animalId => text().references(AnimalRows, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  TextColumn get context => text()();
  TextColumn get recurrence => text()();
  TextColumn get timeZoneId => text()();
  TextColumn get timesJson => text().withDefault(const Constant('[]'))();
  TextColumn get weekdaysJson => text().withDefault(const Constant('[]'))();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('WeightReminderEntity')
class WeightReminderRows extends Table {
  TextColumn get id => text()();
  TextColumn get animalId => text().references(AnimalRows, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  TextColumn get recurrence => text()();
  TextColumn get timeZoneId => text()();
  TextColumn get timesJson => text().withDefault(const Constant('[]'))();
  TextColumn get weekdaysJson => text().withDefault(const Constant('[]'))();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('MedicationEntity')
class MedicationRows extends Table {
  TextColumn get id => text()();
  TextColumn get animalId => text().references(AnimalRows, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get name => text()();
  TextColumn get form => text()();
  RealColumn get doseAmount => real()();
  TextColumn get doseUnit => text()();
  TextColumn get instructions => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  TextColumn get strength => text().nullable()();
  TextColumn get prescriber => text().nullable()();
  TextColumn get pharmacy => text().nullable()();
  TextColumn get prescriptionNumber => text().nullable()();
  IntColumn get refillsRemaining => integer().nullable()();
  DateTimeColumn get nextRefillDate => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('MedicationScheduleEntity')
class MedicationScheduleRows extends Table {
  TextColumn get id => text()();
  TextColumn get medicationId =>
      text().references(MedicationRows, #id, onDelete: KeyAction.cascade)();
  TextColumn get animalId => text().references(AnimalRows, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get kind => text()();
  IntColumn get intervalHours => integer().nullable()();
  TextColumn get timesJson => text().withDefault(const Constant('[]'))();
  TextColumn get weekdaysJson => text().withDefault(const Constant('[]'))();
  TextColumn get timeZoneId => text().withDefault(const Constant('Etc/UTC'))();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@TableIndex(name: 'dose_medication_due', columns: {#medicationId, #dueAt})
@TableIndex(name: 'dose_pending_due', columns: {#status, #dueAt})
@DataClassName('DoseLedgerEntity')
class DoseLedgerRows extends Table {
  TextColumn get id => text()();
  TextColumn get medicationId =>
      text().references(MedicationRows, #id, onDelete: KeyAction.cascade)();
  TextColumn get scheduleId =>
      text().nullable().references(MedicationScheduleRows, #id, onDelete: KeyAction.setNull)();
  TextColumn get animalId => text().references(AnimalRows, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get dueAt => dateTime()();
  TextColumn get intendedLocalTime => text()();
  TextColumn get timeZoneId => text()();
  TextColumn get status => text()();
  DateTimeColumn get administeredAt => dateTime().nullable()();
  TextColumn get note => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('HealthRecordEntity')
class HealthRecordRows extends Table {
  TextColumn get id => text()();
  TextColumn get animalId => text().references(AnimalRows, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get occurredAt => dateTime()();
  TextColumn get kind => text()();
  TextColumn get title => text()();
  RealColumn get canonicalValue => real().nullable()();
  TextColumn get canonicalUnit => text().nullable()();
  TextColumn get enteredUnit => text().nullable()();
  TextColumn get note => text().nullable()();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('CareDocumentEntity')
class CareDocumentRows extends Table {
  TextColumn get id => text()();
  TextColumn get animalId => text().references(AnimalRows, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get documentDate => dateTime()();
  TextColumn get title => text()();
  TextColumn get category => text()();
  TextColumn get storedPath => text()();
  TextColumn get mediaType => text()();
  TextColumn get checksumSha256 => text()();
  IntColumn get byteLength => integer()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get expiryDate => dateTime().nullable()();
  DateTimeColumn get reminderAt => dateTime().nullable()();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('SettingEntity')
class SettingRows extends Table {
  TextColumn get key => text()();
  TextColumn get jsonValue => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

@DriftDatabase(
  tables: [
    AnimalRows,
    IdentifierRows,
    RespiratorySessionRows,
    RespiratoryReminderRows,
    WeightReminderRows,
    MedicationRows,
    MedicationScheduleRows,
    DoseLedgerRows,
    HealthRecordRows,
    CareDocumentRows,
    SettingRows,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase()
    : super(
        driftDatabase(
          name: 'creaturely',
          native: const DriftNativeOptions(databasePath: _databasePathWithSafetySnapshot),
        ),
      );

  AppDatabase.forTesting(super.executor);

  @override
  DriftDatabaseOptions get options => const DriftDatabaseOptions(storeDateTimeAsText: true);

  @override
  int get schemaVersion => domain.CreaturelySnapshot.currentSchemaVersion;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
    },
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.createTable(careDocumentRows);
        await migrator.addColumn(medicationScheduleRows, medicationScheduleRows.timeZoneId);
      }
      if (from < 3) {
        await migrator.createTable(respiratoryReminderRows);
      }
      if (from < 4) {
        await migrator.createTable(weightReminderRows);
        // The nullable legacy column remains for a portable migration, but
        // document reminders are retired and must not remain scheduled.
        await customStatement('UPDATE care_document_rows SET reminder_at = NULL');
      }
      if (from < 5) {
        await migrator.addColumn(medicationRows, medicationRows.strength);
        await migrator.addColumn(medicationRows, medicationRows.pharmacy);
        await migrator.addColumn(medicationRows, medicationRows.prescriptionNumber);
        await migrator.addColumn(medicationRows, medicationRows.refillsRemaining);
        await migrator.addColumn(medicationRows, medicationRows.nextRefillDate);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      // Add non-unique query indexes to existing schema-v5 journals as well.
      final ledger = await customSelect(
        "SELECT name FROM sqlite_master WHERE type = 'table' AND name = 'dose_ledger_rows'",
      ).get();
      if (ledger.isNotEmpty) {
        await customStatement(
          'CREATE INDEX IF NOT EXISTS dose_medication_due ON dose_ledger_rows (medication_id, due_at)',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS dose_pending_due ON dose_ledger_rows (status, due_at)',
        );
      }
    },
  );

  Future<domain.CreaturelySnapshot> snapshot({DateTime? exportedAt}) => transaction(() async {
    return domain.CreaturelySnapshot(
      schemaVersion: schemaVersion,
      exportedAt: exportedAt ?? DateTime.now().toUtc(),
      animals: (await select(animalRows).get()).map(_animalFromEntity).toList(),
      identifiers: (await select(identifierRows).get()).map(_identifierFromEntity).toList(),
      respiratorySessions: (await select(
        respiratorySessionRows,
      ).get()).map(_sessionFromEntity).toList(),
      respiratoryReminders: (await select(
        respiratoryReminderRows,
      ).get()).map(_respiratoryReminderFromEntity).toList(),
      weightReminders: (await select(
        weightReminderRows,
      ).get()).map(_weightReminderFromEntity).toList(),
      medications: (await select(medicationRows).get()).map(_medicationFromEntity).toList(),
      medicationSchedules: (await select(
        medicationScheduleRows,
      ).get()).map(_scheduleFromEntity).toList(),
      doseLedger: (await select(doseLedgerRows).get()).map(_doseFromEntity).toList(),
      healthRecords: (await select(healthRecordRows).get()).map(_healthFromEntity).toList(),
      documents: (await select(careDocumentRows).get()).map(_documentFromEntity).toList(),
      settings: await readSettings(),
    );
  });

  Future<List<domain.Animal>> readAnimals() async =>
      (await select(animalRows).get()).map(_animalFromEntity).toList();

  Stream<List<domain.Animal>> watchAnimals({String? animalId}) {
    final query = select(animalRows);
    if (animalId != null) query.where((row) => row.id.equals(animalId));
    return query
        .watch()
        .distinct(_sameRows)
        .map((rows) => List.unmodifiable(rows.map(_animalFromEntity)));
  }

  Stream<List<domain.AnimalIdentifier>> watchIdentifiers({String? animalId}) {
    final query = select(identifierRows);
    if (animalId != null) query.where((row) => row.animalId.equals(animalId));
    return query
        .watch()
        .distinct(_sameRows)
        .map((rows) => List.unmodifiable(rows.map(_identifierFromEntity)));
  }

  Stream<List<domain.RespiratorySession>> watchSessions({String? animalId, int? limit}) {
    final query = select(respiratorySessionRows);
    if (animalId != null) query.where((row) => row.animalId.equals(animalId));
    if (limit != null) {
      query
        ..orderBy([(row) => OrderingTerm.desc(row.recordedAt), (row) => OrderingTerm.desc(row.id)])
        ..limit(limit);
    }
    return query
        .watch()
        .distinct(_sameRows)
        .map((rows) => List.unmodifiable(rows.map(_sessionFromEntity)));
  }

  Stream<List<domain.RespiratoryReminder>> watchRespiratoryReminders({String? animalId}) {
    final query = select(respiratoryReminderRows);
    if (animalId != null) query.where((row) => row.animalId.equals(animalId));
    return query
        .watch()
        .distinct(_sameRows)
        .map((rows) => List.unmodifiable(rows.map(_respiratoryReminderFromEntity)));
  }

  Stream<List<domain.WeightCheckReminder>> watchWeightReminders({String? animalId}) {
    final query = select(weightReminderRows);
    if (animalId != null) query.where((row) => row.animalId.equals(animalId));
    return query
        .watch()
        .distinct(_sameRows)
        .map((rows) => List.unmodifiable(rows.map(_weightReminderFromEntity)));
  }

  Stream<List<domain.Medication>> watchMedications({String? animalId}) {
    final query = select(medicationRows);
    if (animalId != null) query.where((row) => row.animalId.equals(animalId));
    return query
        .watch()
        .distinct(_sameRows)
        .map((rows) => List.unmodifiable(rows.map(_medicationFromEntity)));
  }

  Stream<List<domain.MedicationSchedule>> watchSchedules({String? animalId}) {
    final query = select(medicationScheduleRows);
    if (animalId != null) query.where((row) => row.animalId.equals(animalId));
    return query
        .watch()
        .distinct(_sameRows)
        .map((rows) => List.unmodifiable(rows.map(_scheduleFromEntity)));
  }

  Stream<List<domain.DoseLedgerEntry>> watchDoses({String? animalId}) {
    final query = select(doseLedgerRows);
    if (animalId != null) query.where((row) => row.animalId.equals(animalId));
    return query
        .watch()
        .distinct(_sameRows)
        .map((rows) => List.unmodifiable(rows.map(_doseFromEntity)));
  }

  Stream<List<domain.HealthRecord>> watchHealthRecords({String? animalId}) {
    final query = select(healthRecordRows);
    if (animalId != null) query.where((row) => row.animalId.equals(animalId));
    return query
        .watch()
        .distinct(_sameRows)
        .map((rows) => List.unmodifiable(rows.map(_healthFromEntity)));
  }

  Stream<List<domain.CareDocument>> watchDocuments({String? animalId}) {
    final query = select(careDocumentRows);
    if (animalId != null) query.where((row) => row.animalId.equals(animalId));
    return query
        .watch()
        .distinct(_sameRows)
        .map((rows) => List.unmodifiable(rows.map(_documentFromEntity)));
  }

  Future<domain.AppSettings> readSettings() async {
    final row = await (select(
      settingRows,
    )..where((row) => row.key.equals('app'))).getSingleOrNull();
    return row == null
        ? const domain.AppSettings()
        : domain.AppSettings.fromJson(jsonDecode(row.jsonValue) as Map<String, Object?>);
  }

  Stream<domain.AppSettings> watchSettings() =>
      (select(settingRows)..where((row) => row.key.equals('app'))).watchSingleOrNull().map(
        (row) => row == null
            ? const domain.AppSettings()
            : domain.AppSettings.fromJson(jsonDecode(row.jsonValue) as Map<String, Object?>),
      );

  Future<domain.DoseLedgerEntry?> findDose(String id) async {
    final row = await (select(doseLedgerRows)..where((row) => row.id.equals(id))).getSingleOrNull();
    return row == null ? null : _doseFromEntity(row);
  }

  Future<DateTime?> lastPlannedDose(String medicationId) async {
    final query = select(doseLedgerRows)
      ..where((row) => row.medicationId.equals(medicationId))
      ..orderBy([(row) => OrderingTerm.desc(row.dueAt)])
      ..limit(1);
    return (await query.getSingleOrNull())?.dueAt;
  }

  Future<void> markOverdue(DateTime now) =>
      (update(doseLedgerRows)..where(
            (row) =>
                row.status.equals('unrecorded') &
                row.dueAt.isSmallerThanValue(now.subtract(const Duration(hours: 2))),
          ))
          .write(DoseLedgerRowsCompanion(status: const Value('missed'), updatedAt: Value(now)));

  /// A consistent read of only the tables used by care maintenance/scheduling.
  Future<CareData> readCareData() => transaction(
    () async => CareData(
      animals: (await select(animalRows).get()).map(_animalFromEntity).toList(),
      respiratoryReminders: (await select(
        respiratoryReminderRows,
      ).get()).map(_respiratoryReminderFromEntity).toList(),
      weightReminders: (await select(
        weightReminderRows,
      ).get()).map(_weightReminderFromEntity).toList(),
      medications: (await select(medicationRows).get()).map(_medicationFromEntity).toList(),
      medicationSchedules: (await select(
        medicationScheduleRows,
      ).get()).map(_scheduleFromEntity).toList(),
      doseLedger: (await (select(
        doseLedgerRows,
      )..where((row) => row.status.equals('unrecorded'))).get()).map(_doseFromEntity).toList(),
      settings: await readSettings(),
    ),
  );

  Future<void> replaceWith(domain.CreaturelySnapshot value) => transaction(() async {
    await delete(doseLedgerRows).go();
    await delete(medicationScheduleRows).go();
    await delete(medicationRows).go();
    await delete(weightReminderRows).go();
    await delete(respiratoryReminderRows).go();
    await delete(respiratorySessionRows).go();
    await delete(identifierRows).go();
    await delete(healthRecordRows).go();
    await delete(careDocumentRows).go();
    await delete(animalRows).go();
    await delete(settingRows).go();

    for (final animal in value.animals) {
      await upsertAnimal(animal);
    }
    for (final identifier in value.identifiers) {
      await upsertIdentifier(identifier);
    }
    for (final session in value.respiratorySessions) {
      await upsertRespiratorySession(session);
    }
    for (final reminder in value.respiratoryReminders) {
      await upsertRespiratoryReminder(reminder);
    }
    for (final reminder in value.weightReminders) {
      await upsertWeightReminder(reminder);
    }
    for (final medication in value.medications) {
      await upsertMedication(medication);
    }
    for (final schedule in value.medicationSchedules) {
      await upsertMedicationSchedule(schedule);
    }
    for (final dose in value.doseLedger) {
      await upsertDose(dose);
    }
    for (final health in value.healthRecords) {
      await upsertHealthRecord(health);
    }
    for (final document in value.documents) {
      await upsertDocument(document);
    }
    await saveSettings(value.settings);
  });

  Future<void> upsertAnimal(domain.Animal animal) => into(animalRows).insertOnConflictUpdate(
    AnimalRowsCompanion(
      id: Value(animal.id),
      createdAt: Value(animal.createdAt.toUtc()),
      updatedAt: Value(animal.updatedAt.toUtc()),
      name: Value(animal.name),
      photoPath: Value(animal.photoPath),
      species: Value(animal.species),
      breed: Value(animal.breed),
      sexOrStatus: Value(animal.sexOrStatus),
      dateOfBirth: Value(
        animal.dateOfBirth == null ? null : domain.canonicalCalendarDate(animal.dateOfBirth!),
      ),
      approximateAgeMonths: Value(animal.approximateAgeMonths),
      colorMarkings: Value(animal.colorMarkings),
      currentWeightKg: Value(animal.currentWeightKg),
      notes: Value(animal.notes),
      archived: Value(animal.archived),
      thresholdMinimum: Value(animal.thresholds.minimum),
      thresholdTarget: Value(animal.thresholds.target),
      thresholdMaximum: Value(animal.thresholds.maximum),
    ),
  );

  Future<void> upsertIdentifier(domain.AnimalIdentifier identifier) =>
      into(identifierRows).insertOnConflictUpdate(
        IdentifierRowsCompanion(
          id: Value(identifier.id),
          animalId: Value(identifier.animalId),
          createdAt: Value(identifier.createdAt.toUtc()),
          updatedAt: Value(identifier.updatedAt.toUtc()),
          type: Value(identifier.type),
          value: Value(identifier.value),
          issuer: Value(identifier.issuer),
          url: Value(identifier.url),
          phone: Value(identifier.phone),
          issuedOn: Value(
            identifier.issuedOn == null ? null : domain.canonicalCalendarDate(identifier.issuedOn!),
          ),
          notes: Value(identifier.notes),
          archived: Value(identifier.archived),
        ),
      );

  Future<void> upsertRespiratorySession(domain.RespiratorySession session) =>
      into(respiratorySessionRows).insertOnConflictUpdate(
        RespiratorySessionRowsCompanion(
          id: Value(session.id),
          animalId: Value(session.animalId),
          createdAt: Value(session.createdAt.toUtc()),
          updatedAt: Value(session.updatedAt.toUtc()),
          recordedAt: Value(session.recordedAt.toUtc()),
          durationMilliseconds: Value(session.durationMilliseconds),
          breathCount: Value(session.breathCount),
          ratePerMinute: Value(session.ratePerMinute),
          context: Value(session.context.name),
          note: Value(session.note),
          thresholdMinimum: Value(session.thresholdSnapshot.minimum),
          thresholdTarget: Value(session.thresholdSnapshot.target),
          thresholdMaximum: Value(session.thresholdSnapshot.maximum),
        ),
      );

  Future<void> upsertRespiratoryReminder(domain.RespiratoryReminder reminder) =>
      into(respiratoryReminderRows).insertOnConflictUpdate(
        RespiratoryReminderRowsCompanion(
          id: Value(reminder.id),
          animalId: Value(reminder.animalId),
          createdAt: Value(reminder.createdAt.toUtc()),
          updatedAt: Value(reminder.updatedAt.toUtc()),
          startDate: Value(domain.canonicalCalendarDate(reminder.startDate)),
          endDate: Value(
            reminder.endDate == null ? null : domain.canonicalCalendarDate(reminder.endDate!),
          ),
          context: Value(reminder.context.name),
          recurrence: Value(reminder.recurrence.name),
          timeZoneId: Value(reminder.timeZoneId),
          timesJson: Value(
            jsonEncode(reminder.times.map((time) => time.toJson()).toList(growable: false)),
          ),
          weekdaysJson: Value(jsonEncode(reminder.weekdays.toList(growable: false))),
          enabled: Value(reminder.enabled),
        ),
      );

  Future<void> upsertWeightReminder(domain.WeightCheckReminder reminder) =>
      into(weightReminderRows).insertOnConflictUpdate(
        WeightReminderRowsCompanion(
          id: Value(reminder.id),
          animalId: Value(reminder.animalId),
          createdAt: Value(reminder.createdAt.toUtc()),
          updatedAt: Value(reminder.updatedAt.toUtc()),
          startDate: Value(domain.canonicalCalendarDate(reminder.startDate)),
          endDate: Value(
            reminder.endDate == null ? null : domain.canonicalCalendarDate(reminder.endDate!),
          ),
          recurrence: Value(reminder.recurrence.name),
          timeZoneId: Value(reminder.timeZoneId),
          timesJson: Value(
            jsonEncode(reminder.times.map((time) => time.toJson()).toList(growable: false)),
          ),
          weekdaysJson: Value(jsonEncode(reminder.weekdays.toList(growable: false))),
          enabled: Value(reminder.enabled),
        ),
      );

  Future<void> upsertMedication(domain.Medication medication) =>
      into(medicationRows).insertOnConflictUpdate(
        MedicationRowsCompanion(
          id: Value(medication.id),
          animalId: Value(medication.animalId),
          createdAt: Value(medication.createdAt.toUtc()),
          updatedAt: Value(medication.updatedAt.toUtc()),
          name: Value(medication.name),
          form: Value(medication.form),
          doseAmount: Value(medication.doseAmount),
          doseUnit: Value(medication.doseUnit),
          instructions: Value(medication.instructions),
          startDate: Value(domain.canonicalCalendarDate(medication.startDate)),
          endDate: Value(
            medication.endDate == null ? null : domain.canonicalCalendarDate(medication.endDate!),
          ),
          strength: Value(medication.strength),
          prescriber: Value(medication.prescriber),
          pharmacy: Value(medication.pharmacy),
          prescriptionNumber: Value(medication.prescriptionNumber),
          refillsRemaining: Value(medication.refillsRemaining),
          nextRefillDate: Value(
            medication.nextRefillDate == null
                ? null
                : domain.canonicalCalendarDate(medication.nextRefillDate!),
          ),
          notes: Value(medication.notes),
          active: Value(medication.active),
        ),
      );

  Future<void> upsertMedicationSchedule(domain.MedicationSchedule schedule) =>
      into(medicationScheduleRows).insertOnConflictUpdate(
        MedicationScheduleRowsCompanion(
          id: Value(schedule.id),
          medicationId: Value(schedule.medicationId),
          animalId: Value(schedule.animalId),
          createdAt: Value(schedule.createdAt.toUtc()),
          updatedAt: Value(schedule.updatedAt.toUtc()),
          kind: Value(schedule.kind.name),
          intervalHours: Value(schedule.intervalHours),
          timesJson: Value(
            jsonEncode(schedule.times.map((time) => time.toJson()).toList(growable: false)),
          ),
          weekdaysJson: Value(jsonEncode(schedule.weekdays.toList(growable: false))),
          timeZoneId: Value(schedule.timeZoneId),
          enabled: Value(schedule.enabled),
        ),
      );

  Future<void> upsertDose(domain.DoseLedgerEntry dose) =>
      into(doseLedgerRows).insertOnConflictUpdate(
        DoseLedgerRowsCompanion(
          id: Value(dose.id),
          medicationId: Value(dose.medicationId),
          scheduleId: Value(dose.scheduleId),
          animalId: Value(dose.animalId),
          createdAt: Value(dose.createdAt.toUtc()),
          updatedAt: Value(dose.updatedAt.toUtc()),
          dueAt: Value(dose.dueAt.toUtc()),
          intendedLocalTime: Value(dose.intendedLocalTime),
          timeZoneId: Value(dose.timeZoneId),
          status: Value(dose.status.name),
          administeredAt: Value(dose.administeredAt?.toUtc()),
          note: Value(dose.note),
        ),
      );

  Future<void> upsertHealthRecord(domain.HealthRecord record) =>
      into(healthRecordRows).insertOnConflictUpdate(
        HealthRecordRowsCompanion(
          id: Value(record.id),
          animalId: Value(record.animalId),
          createdAt: Value(record.createdAt.toUtc()),
          updatedAt: Value(record.updatedAt.toUtc()),
          occurredAt: Value(record.occurredAt.toUtc()),
          kind: Value(record.kind.name),
          title: Value(record.title),
          canonicalValue: Value(record.canonicalValue),
          canonicalUnit: Value(record.canonicalUnit),
          enteredUnit: Value(record.enteredUnit),
          note: Value(record.note),
          archived: Value(record.archived),
        ),
      );

  Future<void> upsertDocument(domain.CareDocument document) =>
      into(careDocumentRows).insertOnConflictUpdate(
        CareDocumentRowsCompanion(
          id: Value(document.id),
          animalId: Value(document.animalId),
          createdAt: Value(document.createdAt.toUtc()),
          updatedAt: Value(document.updatedAt.toUtc()),
          documentDate: Value(domain.canonicalCalendarDate(document.documentDate)),
          title: Value(document.title),
          category: Value(document.category.name),
          storedPath: Value(document.storedPath),
          mediaType: Value(document.mediaType),
          checksumSha256: Value(document.checksumSha256),
          byteLength: Value(document.byteLength),
          notes: Value(document.notes),
          expiryDate: Value(
            document.expiryDate == null ? null : domain.canonicalCalendarDate(document.expiryDate!),
          ),
          archived: Value(document.archived),
        ),
      );

  Future<void> saveSettings(domain.AppSettings settings) => into(settingRows)
      .insertOnConflictUpdate(
        SettingRowsCompanion(
          key: const Value('app'),
          jsonValue: Value(jsonEncode(settings.toJson())),
        ),
      );

  Future<void> deleteRecord(domain.RecordKind tableName, String id) async {
    switch (tableName) {
      case domain.RecordKind.respiratorySession:
        await (delete(respiratorySessionRows)..where((row) => row.id.equals(id))).go();
      case domain.RecordKind.respiratoryReminder:
        await (delete(respiratoryReminderRows)..where((row) => row.id.equals(id))).go();
      case domain.RecordKind.weightReminder:
        await (delete(weightReminderRows)..where((row) => row.id.equals(id))).go();
      case domain.RecordKind.medication:
        await (delete(medicationRows)..where((row) => row.id.equals(id))).go();
      case domain.RecordKind.healthRecord:
        await (delete(healthRecordRows)..where((row) => row.id.equals(id))).go();
      case domain.RecordKind.document:
        await (delete(careDocumentRows)..where((row) => row.id.equals(id))).go();
      case domain.RecordKind.identifier:
        await (delete(identifierRows)..where((row) => row.id.equals(id))).go();
    }
  }

  domain.Animal _animalFromEntity(AnimalEntity row) => domain.Animal(
    id: row.id,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
    name: row.name,
    photoPath: row.photoPath,
    species: row.species,
    breed: row.breed,
    sexOrStatus: row.sexOrStatus,
    dateOfBirth: row.dateOfBirth == null ? null : domain.canonicalCalendarDate(row.dateOfBirth!),
    approximateAgeMonths: row.approximateAgeMonths,
    colorMarkings: row.colorMarkings,
    currentWeightKg: row.currentWeightKg,
    notes: row.notes,
    archived: row.archived,
    thresholds: domain.RespiratoryThresholds(
      minimum: row.thresholdMinimum,
      target: row.thresholdTarget,
      maximum: row.thresholdMaximum,
    ),
  );

  domain.AnimalIdentifier _identifierFromEntity(IdentifierEntity row) => domain.AnimalIdentifier(
    id: row.id,
    animalId: row.animalId,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
    type: row.type,
    value: row.value,
    issuer: row.issuer,
    url: row.url,
    phone: row.phone,
    issuedOn: row.issuedOn == null ? null : domain.canonicalCalendarDate(row.issuedOn!),
    notes: row.notes,
    archived: row.archived,
  );

  domain.RespiratorySession _sessionFromEntity(RespiratorySessionEntity row) =>
      domain.RespiratorySession(
        id: row.id,
        animalId: row.animalId,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        recordedAt: row.recordedAt,
        durationMilliseconds: row.durationMilliseconds,
        breathCount: row.breathCount,
        ratePerMinute: row.ratePerMinute,
        context: domain.RespiratoryContext.values.byName(row.context),
        note: row.note,
        thresholdSnapshot: domain.RespiratoryThresholds(
          minimum: row.thresholdMinimum,
          target: row.thresholdTarget,
          maximum: row.thresholdMaximum,
        ),
      );

  domain.RespiratoryReminder _respiratoryReminderFromEntity(RespiratoryReminderEntity row) {
    final rawTimes = jsonDecode(row.timesJson) as List<Object?>;
    final rawWeekdays = jsonDecode(row.weekdaysJson) as List<Object?>;
    return domain.RespiratoryReminder(
      id: row.id,
      animalId: row.animalId,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      startDate: domain.canonicalCalendarDate(row.startDate),
      endDate: row.endDate == null ? null : domain.canonicalCalendarDate(row.endDate!),
      context: domain.RespiratoryContext.values.byName(row.context),
      recurrence: domain.ReminderRecurrence.values.byName(row.recurrence),
      timeZoneId: row.timeZoneId,
      times: rawTimes
          .map((value) => domain.LocalClockTime.fromJson(value as Map<String, Object?>))
          .toList(growable: false),
      weekdays: rawWeekdays.map((value) => value as int).toSet(),
      enabled: row.enabled,
    );
  }

  domain.WeightCheckReminder _weightReminderFromEntity(WeightReminderEntity row) {
    final rawTimes = jsonDecode(row.timesJson) as List<Object?>;
    final rawWeekdays = jsonDecode(row.weekdaysJson) as List<Object?>;
    return domain.WeightCheckReminder(
      id: row.id,
      animalId: row.animalId,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      startDate: domain.canonicalCalendarDate(row.startDate),
      endDate: row.endDate == null ? null : domain.canonicalCalendarDate(row.endDate!),
      recurrence: domain.ReminderRecurrence.values.byName(row.recurrence),
      timeZoneId: row.timeZoneId,
      times: rawTimes
          .map((value) => domain.LocalClockTime.fromJson(value as Map<String, Object?>))
          .toList(growable: false),
      weekdays: rawWeekdays.map((value) => value as int).toSet(),
      enabled: row.enabled,
    );
  }

  domain.Medication _medicationFromEntity(MedicationEntity row) => domain.Medication(
    id: row.id,
    animalId: row.animalId,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
    name: row.name,
    form: row.form,
    doseAmount: row.doseAmount,
    doseUnit: row.doseUnit,
    instructions: row.instructions,
    startDate: domain.canonicalCalendarDate(row.startDate),
    endDate: row.endDate == null ? null : domain.canonicalCalendarDate(row.endDate!),
    strength: row.strength,
    prescriber: row.prescriber,
    pharmacy: row.pharmacy,
    prescriptionNumber: row.prescriptionNumber,
    refillsRemaining: row.refillsRemaining,
    nextRefillDate: row.nextRefillDate == null
        ? null
        : domain.canonicalCalendarDate(row.nextRefillDate!),
    notes: row.notes,
    active: row.active,
  );

  domain.MedicationSchedule _scheduleFromEntity(MedicationScheduleEntity row) {
    final rawTimes = jsonDecode(row.timesJson) as List<Object?>;
    final rawWeekdays = jsonDecode(row.weekdaysJson) as List<Object?>;
    return domain.MedicationSchedule(
      id: row.id,
      medicationId: row.medicationId,
      animalId: row.animalId,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      kind: domain.ScheduleKind.values.byName(row.kind),
      intervalHours: row.intervalHours,
      times: rawTimes
          .map((value) => domain.LocalClockTime.fromJson(value as Map<String, Object?>))
          .toList(growable: false),
      weekdays: rawWeekdays.map((value) => value as int).toSet(),
      timeZoneId: row.timeZoneId,
      enabled: row.enabled,
    );
  }

  domain.DoseLedgerEntry _doseFromEntity(DoseLedgerEntity row) => domain.DoseLedgerEntry(
    id: row.id,
    medicationId: row.medicationId,
    scheduleId: row.scheduleId,
    animalId: row.animalId,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
    dueAt: row.dueAt,
    intendedLocalTime: row.intendedLocalTime,
    timeZoneId: row.timeZoneId,
    status: domain.DoseStatus.values.byName(row.status),
    administeredAt: row.administeredAt,
    note: row.note,
  );

  domain.HealthRecord _healthFromEntity(HealthRecordEntity row) => domain.HealthRecord(
    id: row.id,
    animalId: row.animalId,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
    occurredAt: row.occurredAt,
    kind: domain.HealthRecordKind.values.byName(row.kind),
    title: row.title,
    canonicalValue: row.canonicalValue,
    canonicalUnit: row.canonicalUnit,
    enteredUnit: row.enteredUnit,
    note: row.note,
    archived: row.archived,
  );

  domain.CareDocument _documentFromEntity(CareDocumentEntity row) => domain.CareDocument(
    id: row.id,
    animalId: row.animalId,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
    documentDate: domain.canonicalCalendarDate(row.documentDate),
    title: row.title,
    category: domain.DocumentCategory.values.byName(row.category),
    storedPath: row.storedPath,
    mediaType: row.mediaType,
    checksumSha256: row.checksumSha256,
    byteLength: row.byteLength,
    notes: row.notes,
    expiryDate: row.expiryDate == null ? null : domain.canonicalCalendarDate(row.expiryDate!),
    archived: row.archived,
  );
}

Future<String> _databasePathWithSafetySnapshot() async {
  final directory = await getApplicationDocumentsDirectory();
  final database = File(path.join(directory.path, 'creaturely.sqlite'));
  if (await database.exists() && await database.length() > 0) {
    final safetyDirectory = Directory(path.join(directory.path, 'migration-safety'));
    await safetyDirectory.create(recursive: true);
    final stamp = DateTime.now().toUtc().toIso8601String().replaceAll(':', '-');
    final destination = File(path.join(safetyDirectory.path, 'pre-open-$stamp.sqlite'));
    await database.copy(destination.path);
    for (final suffix in const <String>['-wal', '-shm']) {
      final sidecar = File('${database.path}$suffix');
      if (await sidecar.exists()) {
        await sidecar.copy('${destination.path}$suffix');
      }
    }
    final snapshots =
        (await safetyDirectory
              .list()
              .where((entity) => entity is File && path.basename(entity.path).endsWith('.sqlite'))
              .cast<File>()
              .toList())
          ..sort((a, b) => b.path.compareTo(a.path));
    for (final stale in snapshots.skip(3)) {
      for (final suffix in const <String>['', '-wal', '-shm']) {
        final file = File('${stale.path}$suffix');
        if (await file.exists()) {
          await file.delete();
        }
      }
    }
  }
  return database.path;
}

bool _sameRows<T>(List<T> before, List<T> after) {
  if (before.length != after.length) return false;
  for (var index = 0; index < before.length; index++) {
    if (before[index] != after[index]) return false;
  }
  return true;
}
