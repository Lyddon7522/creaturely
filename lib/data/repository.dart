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
    for (final dose in doseEntries) {
      await database.upsertDose(dose);
    }
  });

  Future<void> saveDose(DoseLedgerEntry dose) => database.upsertDose(dose);

  Future<void> saveHealthRecord(HealthRecord record) => database.transaction(() async {
    await database.upsertHealthRecord(record);
    if (record.kind == HealthRecordKind.weight && record.canonicalValue != null) {
      final current = await (database.select(
        database.animalRows,
      )..where((row) => row.id.equals(record.animalId))).getSingle();
      await database.upsertAnimal(
        Animal(
          id: current.id,
          createdAt: current.createdAt,
          updatedAt: record.updatedAt,
          name: current.name,
          photoPath: current.photoPath,
          species: current.species,
          breed: current.breed,
          sexOrStatus: current.sexOrStatus,
          dateOfBirth: current.dateOfBirth,
          approximateAgeMonths: current.approximateAgeMonths,
          colorMarkings: current.colorMarkings,
          currentWeightKg: record.canonicalValue,
          notes: current.notes,
          archived: current.archived,
          thresholds: RespiratoryThresholds(
            minimum: current.thresholdMinimum,
            target: current.thresholdTarget,
            maximum: current.thresholdMaximum,
          ),
        ),
      );
    }
  });

  Future<void> saveDocument(CareDocument document) => database.upsertDocument(document);

  Future<void> saveSettings(AppSettings settings) => database.saveSettings(settings);

  Future<void> delete(String kind, String id) => database.deleteRecord(kind, id);
}
