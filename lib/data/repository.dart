import 'package:drift/drift.dart';

import '../domain/models.dart';
import 'database.dart';

abstract interface class SnapshotStore {
  Future<CreaturelySnapshot> loadSnapshot();
  Future<void> replaceSnapshot(CreaturelySnapshot snapshot);
}

class CreaturelyRepository implements SnapshotStore {
  const CreaturelyRepository(this.database);

  final AppDatabase database;

  @override
  Future<CreaturelySnapshot> loadSnapshot() => database.snapshot();

  @override
  Future<void> replaceSnapshot(CreaturelySnapshot snapshot) => database.replaceWith(snapshot);

  Future<void> saveAnimal(Animal animal) => database.upsertAnimal(animal);

  Future<void> saveIdentifier(AnimalIdentifier identifier) => database.upsertIdentifier(identifier);

  Future<void> saveRespiratorySession(RespiratorySession session) =>
      database.upsertRespiratorySession(session);

  Future<void> saveRespiratoryReminder(RespiratoryReminder reminder) =>
      database.upsertRespiratoryReminder(reminder);

  Future<void> saveWeightReminder(WeightCheckReminder reminder) =>
      database.upsertWeightReminder(reminder);

  Future<void> saveMedication(
    Medication medication,
    Iterable<MedicationSchedule> schedules,
    Iterable<DoseLedgerEntry> doseEntries,
  ) => database.transaction(() async {
    final existingDoses = await (database.select(
      database.doseLedgerRows,
    )..where((row) => row.medicationId.equals(medication.id))).get();
    final recordedOccurrenceTimes = existingDoses
        .where((dose) => dose.status != DoseStatus.unrecorded.name)
        .map((dose) => dose.dueAt.toUtc().millisecondsSinceEpoch)
        .toSet();
    await database.upsertMedication(medication);
    await (database.delete(
      database.medicationScheduleRows,
    )..where((row) => row.medicationId.equals(medication.id))).go();
    await (database.delete(database.doseLedgerRows)..where(
          (row) =>
              row.medicationId.equals(medication.id) &
              row.status.equals(DoseStatus.unrecorded.name),
        ))
        .go();
    for (final schedule in schedules) {
      await database.upsertMedicationSchedule(schedule);
    }
    final generatedOccurrenceTimes = <int>{};
    for (final dose in doseEntries) {
      if (dose.status == DoseStatus.unrecorded) {
        final occurrenceTime = dose.dueAt.toUtc().millisecondsSinceEpoch;
        if (recordedOccurrenceTimes.contains(occurrenceTime) ||
            !generatedOccurrenceTimes.add(occurrenceTime)) {
          continue;
        }
      }
      await database.upsertDose(dose);
    }
  });

  Future<void> saveDose(DoseLedgerEntry dose) => database.upsertDose(dose);

  Future<void> saveHealthRecord(HealthRecord record) => database.transaction(() async {
    final previous = await (database.select(
      database.healthRecordRows,
    )..where((row) => row.id.equals(record.id))).getSingleOrNull();
    await database.upsertHealthRecord(record);

    final affectedAnimals = <String>{};
    if (previous?.kind == HealthRecordKind.weight.name) {
      affectedAnimals.add(previous!.animalId);
    }
    if (record.kind == HealthRecordKind.weight) {
      affectedAnimals.add(record.animalId);
    }
    for (final animalId in affectedAnimals) {
      await _refreshCurrentWeight(animalId);
    }
  });

  Future<void> saveDocument(CareDocument document) => database.upsertDocument(document);

  Future<void> saveSettings(AppSettings settings) => database.saveSettings(settings);

  Future<void> delete(String kind, String id) {
    if (kind != 'health_records') {
      return database.deleteRecord(kind, id);
    }
    return database.transaction(() async {
      final record = await (database.select(
        database.healthRecordRows,
      )..where((row) => row.id.equals(id))).getSingleOrNull();
      await database.deleteRecord(kind, id);
      if (record?.kind == HealthRecordKind.weight.name) {
        await _refreshCurrentWeight(record!.animalId);
      }
    });
  }

  Future<void> _refreshCurrentWeight(String animalId) async {
    final latest =
        await (database.select(database.healthRecordRows)
              ..where(
                (row) =>
                    row.animalId.equals(animalId) &
                    row.kind.equals(HealthRecordKind.weight.name) &
                    row.canonicalValue.isNotNull() &
                    row.archived.equals(false),
              )
              ..orderBy([
                (row) => OrderingTerm.desc(row.occurredAt),
                (row) => OrderingTerm.desc(row.updatedAt),
                (row) => OrderingTerm.desc(row.createdAt),
                (row) => OrderingTerm.desc(row.id),
              ])
              ..limit(1))
            .getSingleOrNull();
    await (database.update(database.animalRows)..where((row) => row.id.equals(animalId))).write(
      AnimalRowsCompanion(currentWeightKg: Value(latest?.canonicalValue)),
    );
  }
}
