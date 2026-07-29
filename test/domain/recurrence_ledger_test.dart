import 'package:creaturely/domain/models.dart';
import 'package:creaturely/domain/recurrence.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../support/fixtures.dart';

void main() {
  setUpAll(tz_data.initializeTimeZones);

  test('daily local time remains 08:30 across the spring DST transition', () {
    final occurrences = const RecurrenceEngine().generate(
      medication: fixtureMedication(),
      schedule: fixtureSchedule(),
      rangeStartUtc: DateTime.utc(2026, 3, 7),
      rangeEndUtc: DateTime.utc(2026, 3, 11),
    );

    expect(occurrences, hasLength(4));
    final chicago = tz.getLocation('America/Chicago');
    expect(
      occurrences.map((value) => tz.TZDateTime.from(value.dueAtUtc, chicago).hour).toSet(),
      <int>{8},
    );
    expect(occurrences.map((value) => value.intendedLocalTime.substring(11)).toSet(), <String>{
      '08:30',
    });
    expect(occurrences[0].dueAtUtc.hour, 14);
    expect(occurrences[1].dueAtUtc.hour, 13);
  });

  test('a nonexistent spring-forward time keeps its scheduling intent', () {
    final schedule = MedicationSchedule(
      id: 'gap',
      medicationId: 'med-1',
      animalId: 'animal-1',
      createdAt: fixtureTime,
      updatedAt: fixtureTime,
      kind: ScheduleKind.daily,
      timeZoneId: 'America/Chicago',
      times: const <LocalClockTime>[LocalClockTime(2, 30)],
    );
    final occurrences = const RecurrenceEngine().generate(
      medication: fixtureMedication(),
      schedule: schedule,
      rangeStartUtc: DateTime.utc(2026, 3, 8),
      rangeEndUtc: DateTime.utc(2026, 3, 9),
    );

    expect(occurrences, hasLength(1));
    expect(occurrences.single.intendedLocalTime, '2026-03-08T02:30');
    final resolved = tz.TZDateTime.from(
      occurrences.single.dueAtUtc,
      tz.getLocation('America/Chicago'),
    );
    expect(resolved.hour, 3);
    expect(resolved.minute, 30);
  });

  test('selected weekdays include only intended local weekdays', () {
    final schedule = MedicationSchedule(
      id: 'weekdays',
      medicationId: 'med-1',
      animalId: 'animal-1',
      createdAt: fixtureTime,
      updatedAt: fixtureTime,
      kind: ScheduleKind.selectedWeekdays,
      timeZoneId: 'America/Chicago',
      times: const <LocalClockTime>[LocalClockTime(9, 0)],
      weekdays: const <int>{DateTime.monday, DateTime.friday},
    );
    final occurrences = const RecurrenceEngine().generate(
      medication: fixtureMedication(),
      schedule: schedule,
      rangeStartUtc: DateTime.utc(2026, 3, 7),
      rangeEndUtc: DateTime.utc(2026, 3, 15),
    );
    final local = tz.getLocation('America/Chicago');
    expect(
      occurrences.map((value) => tz.TZDateTime.from(value.dueAtUtc, local).weekday).toSet(),
      <int>{DateTime.monday, DateTime.friday},
    );
  });

  test('24-hour intervals keep their wall-clock start across DST', () {
    final schedule = MedicationSchedule(
      id: 'interval',
      medicationId: 'med-1',
      animalId: 'animal-1',
      createdAt: fixtureTime,
      updatedAt: fixtureTime,
      kind: ScheduleKind.interval,
      intervalHours: 24,
      timeZoneId: 'America/Chicago',
      times: const <LocalClockTime>[LocalClockTime(8, 30)],
    );
    final occurrences = const RecurrenceEngine().generate(
      medication: fixtureMedication(),
      schedule: schedule,
      rangeStartUtc: DateTime.utc(2026, 3, 7),
      rangeEndUtc: DateTime.utc(2026, 3, 11),
    );
    final local = tz.getLocation('America/Chicago');

    expect(occurrences, hasLength(4));
    expect(
      occurrences.map((value) => tz.TZDateTime.from(value.dueAtUtc, local).hour).toSet(),
      <int>{8},
    );
    expect(occurrences.map((value) => value.intendedLocalTime.substring(11)).toSet(), <String>{
      '08:30',
    });
  });

  test('interval schedules require one valid wall-clock anchor', () {
    MedicationSchedule schedule(List<LocalClockTime> times) => MedicationSchedule(
      id: 'interval',
      medicationId: 'med-1',
      animalId: 'animal-1',
      createdAt: fixtureTime,
      updatedAt: fixtureTime,
      kind: ScheduleKind.interval,
      intervalHours: 12,
      timeZoneId: 'America/Chicago',
      times: times,
    );

    expect(schedule(const <LocalClockTime>[]).isValid, isFalse);
    expect(
      schedule(const <LocalClockTime>[LocalClockTime(8, 30), LocalClockTime(20, 30)]).isValid,
      isFalse,
    );
    expect(schedule(const <LocalClockTime>[LocalClockTime(8, 30)]).isValid, isTrue);
  });

  test('breathing reminders preserve local time across DST', () {
    final occurrences = const RespiratoryReminderEngine().generate(
      reminder: fixtureRespiratoryReminder(),
      rangeStartUtc: DateTime.utc(2026, 3, 7),
      rangeEndUtc: DateTime.utc(2026, 3, 11),
    );
    final chicago = tz.getLocation('America/Chicago');

    expect(occurrences, hasLength(3));
    expect(
      occurrences.map((value) => tz.TZDateTime.from(value.dueAtUtc, chicago).hour).toSet(),
      <int>{21},
    );
    expect(occurrences.map((value) => value.intendedLocalTime.substring(11)).toSet(), <String>{
      '21:00',
    });
    expect(occurrences.first.dueAtUtc.hour, 3);
    expect(occurrences[1].dueAtUtc.hour, 2);
  });

  test('selected-weekday breathing reminders include only keeper choices', () {
    final reminder = fixtureRespiratoryReminder().copyWith(
      recurrence: ReminderRecurrence.selectedWeekdays,
      weekdays: const <int>{DateTime.monday, DateTime.thursday},
    );
    final occurrences = const RespiratoryReminderEngine().generate(
      reminder: reminder,
      rangeStartUtc: DateTime.utc(2026, 3, 7),
      rangeEndUtc: DateTime.utc(2026, 3, 15),
    );
    final chicago = tz.getLocation('America/Chicago');

    expect(
      occurrences.map((value) => tz.TZDateTime.from(value.dueAtUtc, chicago).weekday).toSet(),
      <int>{DateTime.monday, DateTime.thursday},
    );
  });

  test('weight reminders preserve local time across DST', () {
    final reminder = fixtureWeightReminder().copyWith(recurrence: ReminderRecurrence.daily);
    final occurrences = const WeightReminderEngine().generate(
      reminder: reminder,
      rangeStartUtc: DateTime.utc(2026, 3, 7),
      rangeEndUtc: DateTime.utc(2026, 3, 11),
    );
    final chicago = tz.getLocation('America/Chicago');

    expect(occurrences, hasLength(4));
    expect(
      occurrences.map((value) => tz.TZDateTime.from(value.dueAtUtc, chicago).hour).toSet(),
      <int>{10},
    );
    expect(occurrences.map((value) => value.intendedLocalTime.substring(11)).toSet(), <String>{
      '10:00',
    });
    expect(occurrences.first.dueAtUtc.hour, 16);
    expect(occurrences[1].dueAtUtc.hour, 15);
  });

  test('selected-weekday weight reminders include only keeper choices', () {
    final reminder = fixtureWeightReminder().copyWith(
      recurrence: ReminderRecurrence.selectedWeekdays,
      weekdays: const <int>{DateTime.tuesday, DateTime.saturday},
    );
    final occurrences = const WeightReminderEngine().generate(
      reminder: reminder,
      rangeStartUtc: DateTime.utc(2026, 3, 7),
      rangeEndUtc: DateTime.utc(2026, 3, 22),
    );
    final chicago = tz.getLocation('America/Chicago');

    expect(
      occurrences.map((value) => tz.TZDateTime.from(value.dueAtUtc, chicago).weekday).toSet(),
      <int>{DateTime.tuesday, DateTime.saturday},
    );
  });

  group('dose ledger', () {
    test('supports given, skip, missed, and explicit reopen transitions', () {
      final unrecorded = fixtureDose(status: DoseStatus.unrecorded);
      final administeredAt = fixtureTime.add(const Duration(hours: 1, minutes: 47));
      final given = unrecorded.transition(
        to: DoseStatus.given,
        at: fixtureTime.add(const Duration(hours: 2)),
        administeredAt: administeredAt,
        note: 'With a snack.',
      );
      expect(given.status, DoseStatus.given);
      expect(given.administeredAt, administeredAt);
      expect(given.note, 'With a snack.');
      expect(() => given.transition(to: DoseStatus.skipped, at: fixtureTime), throwsStateError);
      final reopened = given.reopen(at: fixtureTime.add(const Duration(hours: 3)));
      expect(reopened.status, DoseStatus.unrecorded);
      expect(reopened.administeredAt, isNull);
      expect(
        reopened.transition(to: DoseStatus.skipped, at: fixtureTime).status,
        DoseStatus.skipped,
      );
    });

    test('marks overdue entries missed and calculates descriptive adherence', () {
      final unrecorded = fixtureDose(status: DoseStatus.unrecorded);
      final marked = const MedicationLedger().markOverdue(<DoseLedgerEntry>[
        unrecorded,
      ], now: unrecorded.dueAt.add(const Duration(hours: 3)));
      expect(marked.single.status, DoseStatus.missed);
      expect(
        const MedicationLedger().adherence(<DoseLedgerEntry>[
          ...marked,
          fixtureDose(),
          fixtureDose(status: DoseStatus.skipped),
          fixtureDose(status: DoseStatus.unrecorded),
        ]),
        closeTo(1 / 3, 1e-10),
      );
    });
  });
}
