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
    required this.title,
    required this.detail,
    required this.source,
    this.status,
  });

  final String id;
  final String animalId;
  final DateTime dueAt;
  final CareScheduleItemKind kind;
  final String title;
  final String detail;
  final Object source;
  final DoseStatus? status;
}

class CareScheduleBuilder {
  const CareScheduleBuilder({
    this.respiratoryReminderEngine = const RespiratoryReminderEngine(),
    this.weightReminderEngine = const WeightReminderEngine(),
  });

  final RespiratoryReminderEngine respiratoryReminderEngine;
  final WeightReminderEngine weightReminderEngine;

  List<CareScheduleItem> build({
    required CreaturelySnapshot snapshot,
    required DateTime rangeStartUtc,
    required DateTime rangeEndUtc,
    String? animalId,
  }) {
    if (!rangeStartUtc.isBefore(rangeEndUtc)) {
      return const <CareScheduleItem>[];
    }
    bool includesAnimal(String value) => animalId == null || value == animalId;
    final activeAnimals = <String>{
      for (final animal in snapshot.animals)
        if (!animal.archived) animal.id,
    };
    final medications = <String, Medication>{
      for (final medication in snapshot.medications)
        if (medication.active) medication.id: medication,
    };
    final items = <CareScheduleItem>[];

    for (final dose in snapshot.doseLedger) {
      final medication = medications[dose.medicationId];
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
          title: medication.name,
          detail: '${medication.doseAmount} ${medication.doseUnit} • ${medication.instructions}',
          source: dose,
          status: dose.status,
        ),
      );
    }

    for (final reminder in snapshot.respiratoryReminders) {
      if (!activeAnimals.contains(reminder.animalId) ||
          !includesAnimal(reminder.animalId) ||
          !reminder.enabled) {
        continue;
      }
      for (final occurrence in respiratoryReminderEngine.generate(
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
            title: reminder.context == RespiratoryContext.sleeping
                ? 'Sleeping breathing check'
                : 'Resting breathing check',
            detail: 'Manual respiratory-rate reminder',
            source: RespiratoryReminderOccurrence(reminder: reminder, occurrence: occurrence),
          ),
        );
      }
    }

    for (final reminder in snapshot.weightReminders) {
      if (!activeAnimals.contains(reminder.animalId) ||
          !includesAnimal(reminder.animalId) ||
          !reminder.enabled) {
        continue;
      }
      for (final occurrence in weightReminderEngine.generate(
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
            title: 'Weight check',
            detail: 'Record a weigh-in',
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
