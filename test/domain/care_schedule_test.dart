import 'package:creaturely/domain/care_schedule.dart';
import 'package:creaturely/domain/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tz_data;

import '../support/fixtures.dart';

void main() {
  setUpAll(tz_data.initializeTimeZones);

  test('unified schedule orders medication, breathing, and weight care', () {
    final source = fixtureSnapshot();
    final breathing = fixtureRespiratoryReminder().copyWith(
      times: const <LocalClockTime>[LocalClockTime(9, 0)],
    );
    final dose = fixtureDose(status: DoseStatus.unrecorded);
    final weight = fixtureWeightReminder().copyWith(
      recurrence: ReminderRecurrence.daily,
      times: const <LocalClockTime>[LocalClockTime(12, 0)],
    );
    final snapshot = CreaturelySnapshot(
      schemaVersion: source.schemaVersion,
      exportedAt: source.exportedAt,
      animals: source.animals,
      identifiers: source.identifiers,
      respiratorySessions: source.respiratorySessions,
      respiratoryReminders: <RespiratoryReminder>[breathing],
      weightReminders: <WeightCheckReminder>[weight],
      medications: source.medications,
      medicationSchedules: source.medicationSchedules,
      doseLedger: <DoseLedgerEntry>[dose],
      healthRecords: source.healthRecords,
      documents: source.documents,
      settings: source.settings,
    );

    final items = const CareScheduleBuilder().build(
      snapshot: snapshot,
      animalId: 'animal-1',
      rangeStartUtc: DateTime.utc(2026, 3, 8),
      rangeEndUtc: DateTime.utc(2026, 3, 9, 6),
    );

    expect(items.map((value) => value.kind), <CareScheduleItemKind>[
      CareScheduleItemKind.respiratory,
      CareScheduleItemKind.medication,
      CareScheduleItemKind.weight,
    ]);
    expect(
      items.map((value) => value.dueAt).toList(),
      orderedEquals([
        DateTime.utc(2026, 3, 8, 14),
        DateTime.utc(2026, 3, 8, 14, 30),
        DateTime.utc(2026, 3, 8, 17),
      ]),
    );
  });

  test('schedule excludes archived animals and disabled reminders', () {
    final source = fixtureSnapshot();
    final animal = source.animals.single.copyWith(archived: true);
    final snapshot = CreaturelySnapshot(
      schemaVersion: source.schemaVersion,
      exportedAt: source.exportedAt,
      animals: <Animal>[animal],
      identifiers: source.identifiers,
      respiratorySessions: source.respiratorySessions,
      respiratoryReminders: <RespiratoryReminder>[
        fixtureRespiratoryReminder().copyWith(enabled: false),
      ],
      weightReminders: source.weightReminders,
      medications: source.medications,
      medicationSchedules: source.medicationSchedules,
      doseLedger: source.doseLedger,
      healthRecords: source.healthRecords,
      documents: source.documents,
      settings: source.settings,
    );

    expect(
      const CareScheduleBuilder().build(
        snapshot: snapshot,
        rangeStartUtc: DateTime.utc(2026),
        rangeEndUtc: DateTime.utc(2028),
      ),
      isEmpty,
    );
  });
}
