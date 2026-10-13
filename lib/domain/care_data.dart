import 'models.dart';

/// The records needed to plan active care. This is not a portable journal snapshot.
class CareData {
  CareData({
    required List<Animal> animals,
    required List<Medication> medications,
    required List<MedicationSchedule> medicationSchedules,
    required List<DoseLedgerEntry> doseLedger,
    required List<RespiratoryReminder> respiratoryReminders,
    required List<WeightCheckReminder> weightReminders,
    required this.settings,
  }) : animals = List.unmodifiable(animals),
       medications = List.unmodifiable(medications),
       medicationSchedules = List.unmodifiable(medicationSchedules),
       doseLedger = List.unmodifiable(doseLedger),
       respiratoryReminders = List.unmodifiable(respiratoryReminders),
       weightReminders = List.unmodifiable(weightReminders);

  final List<Animal> animals;
  final List<Medication> medications;
  final List<MedicationSchedule> medicationSchedules;
  final List<DoseLedgerEntry> doseLedger;
  final List<RespiratoryReminder> respiratoryReminders;
  final List<WeightCheckReminder> weightReminders;
  final AppSettings settings;
}
