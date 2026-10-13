import 'package:timezone/timezone.dart' as tz;

import 'models.dart';
import 'time_zone.dart';

class ScheduledOccurrence {
  const ScheduledOccurrence({
    required this.dueAtUtc,
    required this.intendedLocalTime,
    required this.timeZoneId,
  });

  final DateTime dueAtUtc;
  final String intendedLocalTime;
  final String timeZoneId;
}

class RecurrenceEngine {
  const RecurrenceEngine();

  List<ScheduledOccurrence> generate({
    required Medication medication,
    required MedicationSchedule schedule,
    required DateTime rangeStartUtc,
    required DateTime rangeEndUtc,
  }) {
    if (!schedule.isValid) {
      throw ArgumentError.value(schedule, 'schedule', 'Schedule is incomplete.');
    }
    if (!rangeStartUtc.isBefore(rangeEndUtc)) {
      return const <ScheduledOccurrence>[];
    }
    final location = timeZoneLocation(schedule.timeZoneId);
    final medicationStart = tz.TZDateTime(
      location,
      medication.startDate.year,
      medication.startDate.month,
      medication.startDate.day,
    );
    final medicationEnd = medication.endDate == null
        ? null
        : tz.TZDateTime(
            location,
            medication.endDate!.year,
            medication.endDate!.month,
            medication.endDate!.day,
            23,
            59,
            59,
            999,
          );
    final rangeStart = tz.TZDateTime.from(rangeStartUtc, location);
    final rangeEnd = tz.TZDateTime.from(rangeEndUtc, location);

    return switch (schedule.kind) {
      ScheduleKind.interval => _interval(
        schedule: schedule,
        location: location,
        medicationStart: medicationStart,
        medicationEnd: medicationEnd,
        rangeStart: rangeStart,
        rangeEnd: rangeEnd,
      ),
      ScheduleKind.daily || ScheduleKind.selectedWeekdays => _calendar(
        schedule: schedule,
        location: location,
        medicationStart: medicationStart,
        medicationEnd: medicationEnd,
        rangeStart: rangeStart,
        rangeEnd: rangeEnd,
      ),
    };
  }

  List<ScheduledOccurrence> _calendar({
    required MedicationSchedule schedule,
    required tz.Location location,
    required tz.TZDateTime medicationStart,
    required tz.TZDateTime? medicationEnd,
    required tz.TZDateTime rangeStart,
    required tz.TZDateTime rangeEnd,
  }) {
    final result = <ScheduledOccurrence>[];
    var date = tz.TZDateTime(location, rangeStart.year, rangeStart.month, rangeStart.day, 12);
    final lastDate = tz.TZDateTime(location, rangeEnd.year, rangeEnd.month, rangeEnd.day, 12);
    final times = [...schedule.times]..sort();

    while (!date.isAfter(lastDate)) {
      final eligibleDay =
          schedule.kind == ScheduleKind.daily || schedule.weekdays.contains(date.weekday);
      if (eligibleDay) {
        for (final time in times) {
          final due = tz.TZDateTime(
            location,
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
          if (_inside(
            due: due,
            medicationStart: medicationStart,
            medicationEnd: medicationEnd,
            rangeStart: rangeStart,
            rangeEnd: rangeEnd,
          )) {
            result.add(
              ScheduledOccurrence(
                dueAtUtc: due.toUtc(),
                intendedLocalTime:
                    '${due.year.toString().padLeft(4, '0')}-'
                    '${due.month.toString().padLeft(2, '0')}-'
                    '${due.day.toString().padLeft(2, '0')}T${time.encoded}',
                timeZoneId: schedule.timeZoneId,
              ),
            );
          }
        }
      }
      date = tz.TZDateTime(location, date.year, date.month, date.day + 1, 12);
    }
    result.sort((a, b) => a.dueAtUtc.compareTo(b.dueAtUtc));
    return result;
  }

  List<ScheduledOccurrence> _interval({
    required MedicationSchedule schedule,
    required tz.Location location,
    required tz.TZDateTime medicationStart,
    required tz.TZDateTime? medicationEnd,
    required tz.TZDateTime rangeStart,
    required tz.TZDateTime rangeEnd,
  }) {
    final firstTime = schedule.times.isEmpty
        ? LocalClockTime(medicationStart.hour, medicationStart.minute)
        : schedule.times.first;
    var due = tz.TZDateTime(
      location,
      medicationStart.year,
      medicationStart.month,
      medicationStart.day,
      firstTime.hour,
      firstTime.minute,
    );
    if (due.isBefore(medicationStart)) {
      due = _addWallClockHours(due, schedule.intervalHours!, location);
    }
    final result = <ScheduledOccurrence>[];
    while (due.isBefore(rangeEnd) && (medicationEnd == null || !due.isAfter(medicationEnd))) {
      if (!due.isBefore(rangeStart)) {
        result.add(
          ScheduledOccurrence(
            dueAtUtc: due.toUtc(),
            intendedLocalTime:
                '${due.year.toString().padLeft(4, '0')}-'
                '${due.month.toString().padLeft(2, '0')}-'
                '${due.day.toString().padLeft(2, '0')}T'
                '${due.hour.toString().padLeft(2, '0')}:'
                '${due.minute.toString().padLeft(2, '0')}',
            timeZoneId: schedule.timeZoneId,
          ),
        );
      }
      due = _addWallClockHours(due, schedule.intervalHours!, location);
    }
    return result;
  }

  tz.TZDateTime _addWallClockHours(tz.TZDateTime value, int hours, tz.Location location) =>
      tz.TZDateTime(location, value.year, value.month, value.day, value.hour + hours, value.minute);

  bool _inside({
    required tz.TZDateTime due,
    required tz.TZDateTime medicationStart,
    required tz.TZDateTime? medicationEnd,
    required tz.TZDateTime rangeStart,
    required tz.TZDateTime rangeEnd,
  }) =>
      !due.isBefore(medicationStart) &&
      (medicationEnd == null || !due.isAfter(medicationEnd)) &&
      !due.isBefore(rangeStart) &&
      due.isBefore(rangeEnd);
}

class CalendarReminderEngine {
  const CalendarReminderEngine();

  List<ScheduledOccurrence> generate({
    required CalendarReminder reminder,
    required DateTime rangeStartUtc,
    required DateTime rangeEndUtc,
  }) {
    if (!reminder.isValid) {
      throw ArgumentError.value(reminder, 'reminder', 'Reminder is incomplete.');
    }
    if (!rangeStartUtc.isBefore(rangeEndUtc) || !reminder.enabled) {
      return const <ScheduledOccurrence>[];
    }
    final location = timeZoneLocation(reminder.timeZoneId);
    final reminderStart = tz.TZDateTime(
      location,
      reminder.startDate.year,
      reminder.startDate.month,
      reminder.startDate.day,
    );
    final reminderEnd = reminder.endDate == null
        ? null
        : tz.TZDateTime(
            location,
            reminder.endDate!.year,
            reminder.endDate!.month,
            reminder.endDate!.day,
            23,
            59,
            59,
            999,
          );
    final rangeStart = tz.TZDateTime.from(rangeStartUtc, location);
    final rangeEnd = tz.TZDateTime.from(rangeEndUtc, location);
    final times = [...reminder.times]..sort();
    final result = <ScheduledOccurrence>[];
    var date = tz.TZDateTime(location, rangeStart.year, rangeStart.month, rangeStart.day, 12);
    final lastDate = tz.TZDateTime(location, rangeEnd.year, rangeEnd.month, rangeEnd.day, 12);

    while (!date.isAfter(lastDate)) {
      final eligibleDay =
          reminder.recurrence == ReminderRecurrence.daily ||
          reminder.weekdays.contains(date.weekday);
      if (eligibleDay) {
        for (final time in times) {
          final due = tz.TZDateTime(
            location,
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
          if (!due.isBefore(reminderStart) &&
              (reminderEnd == null || !due.isAfter(reminderEnd)) &&
              !due.isBefore(rangeStart) &&
              due.isBefore(rangeEnd)) {
            result.add(
              ScheduledOccurrence(
                dueAtUtc: due.toUtc(),
                intendedLocalTime:
                    '${due.year.toString().padLeft(4, '0')}-'
                    '${due.month.toString().padLeft(2, '0')}-'
                    '${due.day.toString().padLeft(2, '0')}T${time.encoded}',
                timeZoneId: reminder.timeZoneId,
              ),
            );
          }
        }
      }
      date = tz.TZDateTime(location, date.year, date.month, date.day + 1, 12);
    }
    result.sort((a, b) => a.dueAtUtc.compareTo(b.dueAtUtc));
    return result;
  }
}
