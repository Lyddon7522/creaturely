import 'package:creaturely/domain/models.dart';
import 'package:creaturely/domain/respiratory_timer.dart';
import 'package:creaturely/domain/trends.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fixtures.dart';

void main() {
  test('published records defensively copy lists and sets', () {
    final times = [const LocalClockTime(8, 0)];
    final weekdays = {1};
    final original = fixtureSchedule();
    final schedule = MedicationSchedule(
      id: original.id,
      medicationId: original.medicationId,
      animalId: original.animalId,
      createdAt: original.createdAt,
      updatedAt: original.updatedAt,
      kind: original.kind,
      timeZoneId: original.timeZoneId,
      times: times,
      weekdays: weekdays,
    );
    times[0] = const LocalClockTime(9, 0);
    weekdays.add(2);
    expect(schedule.times.single.hour, 8);
    expect(schedule.weekdays, {1});
    expect(() => schedule.times[0] = const LocalClockTime(10, 0), throwsUnsupportedError);
    expect(() => fixtureSnapshot().animals.clear(), throwsUnsupportedError);
  });

  test('archived weight records are excluded from active trends', () {
    final weight = fixtureSnapshot().healthRecords.single;
    final archived = HealthRecord.fromJson({...weight.toJson(), 'archived': true});
    expect(
      const TrendDataBuilder().weight([weight, archived], weight.animalId, WeightUnit.kilograms),
      hasLength(1),
    );
  });
  test('unknown IANA names and missing current-schema collections fail validation', () {
    expect(fixtureSchedule().copyWith(timeZoneId: 'Missing/Zone').isValid, isFalse);
    expect(
      fixtureSnapshot().respiratoryReminders.single.copyWith(timeZoneId: 'Missing/Zone').isValid,
      isFalse,
    );
    final json = fixtureSnapshot().toJson()..remove('weightReminders');
    expect(() => CreaturelySnapshot.fromJson(json), throwsFormatException);
  });
  test('elapsed timing ignores wall-clock jumps and a failed save leaves a retryable record', () {
    var wall = fixtureTime;
    var elapsed = Duration.zero;
    final timer = RespiratoryTimerController(
      targetDuration: const Duration(seconds: 15),
      clock: () => wall,
      elapsedClock: () => elapsed,
    )..start();
    elapsed = const Duration(seconds: 2);
    timer.recordBreath();
    wall = wall.subtract(const Duration(hours: 4));
    elapsed = const Duration(seconds: 15);
    timer.tick();
    expect(timer.snapshot().elapsed, const Duration(seconds: 15));
    RespiratorySession draft() => timer.buildSession(
      id: 'stable-retry-id',
      animalId: 'animal-1',
      context: RespiratoryContext.resting,
      thresholds: const RespiratoryThresholds(),
      recordedAt: fixtureTime,
    );
    final first = draft();
    expect(timer.status, RespiratoryTimerStatus.completed);
    expect(draft().toJson(), first.toJson());
    timer.markSaved();
    expect(timer.status, RespiratoryTimerStatus.saved);
  });
}
