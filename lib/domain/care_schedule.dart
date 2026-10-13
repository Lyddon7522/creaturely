import 'models.dart';
import 'recurrence.dart';

enum CareScheduleItemKind { medication, respiratory, weight }

class RespiratoryReminderOccurrence {
  const RespiratoryReminderOccurrence({required this.reminder, required this.occurrence});

  final RespiratoryReminder reminder;
  final ScheduledOccurrence occurrence;
}

class WeightReminderOccurrence {
  const WeightReminderOccurrence({required this.reminder, required this.occurrence});

  final WeightCheckReminder reminder;
  final ScheduledOccurrence occurrence;
}

class CareScheduleItem {
  const CareScheduleItem({
    required this.id,
    required this.animalId,
    required this.dueAt,
    required this.kind,
    this.medication,
    required this.source,
    this.status,
  });

  final String id;
  final String animalId;
  final DateTime dueAt;
  final CareScheduleItemKind kind;
  final Medication? medication;
  final Object source;
  final DoseStatus? status;
}

class CareScheduleBuilder {
  const CareScheduleBuilder({this.reminderEngine = const CalendarReminderEngine()});

  final CalendarReminderEngine reminderEngine;

  List<CareScheduleItem> build({
    required Iterable<Animal> animals,
    required Iterable<Medication> medications,
    required Iterable<DoseLedgerEntry> doses,
    required Iterable<RespiratoryReminder> respiratoryReminders,
    required Iterable<WeightCheckReminder> weightReminders,
    required DateTime rangeStartUtc,
    required DateTime rangeEndUtc,
    String? animalId,
  }) {
    if (!rangeStartUtc.isBefore(rangeEndUtc)) {
      return const <CareScheduleItem>[];
    }
    bool includesAnimal(String value) => animalId == null || value == animalId;
    final activeAnimals = <String>{
      for (final animal in animals)
        if (!animal.archived) animal.id,
    };
    final byMedication = <String, Medication>{
      for (final medication in medications)
        if (medication.active) medication.id: medication,
    };
    final items = <CareScheduleItem>[];

    for (final dose in doses) {
      final medication = byMedication[dose.medicationId];
      if (medication == null ||
          !activeAnimals.contains(dose.animalId) ||
          !includesAnimal(dose.animalId) ||
          dose.dueAt.isBefore(rangeStartUtc) ||
          !dose.dueAt.isBefore(rangeEndUtc)) {
        continue;
      }
      items.add(
        CareScheduleItem(
          id: 'dose:${dose.id}',
          animalId: dose.animalId,
          dueAt: dose.dueAt,
          kind: CareScheduleItemKind.medication,
          medication: medication,
          source: dose,
          status: dose.status,
        ),
      );
    }

    for (final reminder in respiratoryReminders) {
      if (!activeAnimals.contains(reminder.animalId) ||
          !includesAnimal(reminder.animalId) ||
          !reminder.enabled) {
        continue;
      }
      for (final occurrence in reminderEngine.generate(
        reminder: reminder,
        rangeStartUtc: rangeStartUtc,
        rangeEndUtc: rangeEndUtc,
      )) {
        items.add(
          CareScheduleItem(
            id: 'respiratory:${reminder.id}:${occurrence.intendedLocalTime}',
            animalId: reminder.animalId,
            dueAt: occurrence.dueAtUtc,
            kind: CareScheduleItemKind.respiratory,
            source: RespiratoryReminderOccurrence(reminder: reminder, occurrence: occurrence),
          ),
        );
      }
    }

    for (final reminder in weightReminders) {
      if (!activeAnimals.contains(reminder.animalId) ||
          !includesAnimal(reminder.animalId) ||
          !reminder.enabled) {
        continue;
      }
      for (final occurrence in reminderEngine.generate(
        reminder: reminder,
        rangeStartUtc: rangeStartUtc,
        rangeEndUtc: rangeEndUtc,
      )) {
        items.add(
          CareScheduleItem(
            id: 'weight:${reminder.id}:${occurrence.intendedLocalTime}',
            animalId: reminder.animalId,
            dueAt: occurrence.dueAtUtc,
            kind: CareScheduleItemKind.weight,
            source: WeightReminderOccurrence(reminder: reminder, occurrence: occurrence),
          ),
        );
      }
    }

    items.sort((left, right) {
      final byTime = left.dueAt.compareTo(right.dueAt);
      return byTime != 0 ? byTime : left.id.compareTo(right.id);
    });
    return items;
  }
}
