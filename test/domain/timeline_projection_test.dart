import 'package:creaturely/domain/models.dart';
import 'package:creaturely/domain/timeline.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const projection = MedicationTimelineProjection();
  final now = DateTime.utc(2026, 7, 28, 12);

  test('shows only the nearest upcoming dose for each medication', () {
    final doses = <DoseLedgerEntry>[
      _dose('a-far', 'med-a', now.add(const Duration(days: 80))),
      _dose('b-next', 'med-b', now.add(const Duration(hours: 3))),
      _dose('a-next', 'med-a', now.add(const Duration(hours: 1))),
      _dose('a-later', 'med-a', now.add(const Duration(days: 2))),
    ];

    final next = projection.nextByMedication(doses, now: now);

    expect(next.map((dose) => dose.id), <String>['a-next', 'b-next']);
  });

  test('keeps future repetitions out of history and bounds the schedule window', () {
    final past = _dose('past', 'med-a', now.subtract(const Duration(minutes: 1)));
    final next = _dose('next', 'med-a', now.add(const Duration(hours: 1)));
    final thisWeek = _dose('week', 'med-a', now.add(const Duration(days: 6)));
    final far = _dose('far', 'med-a', now.add(const Duration(days: 80)));
    final recorded = _dose(
      'recorded',
      'med-a',
      now.add(const Duration(days: 80)),
      status: DoseStatus.given,
    );

    expect(projection.belongsInHistory(past, now: now), isTrue);
    expect(projection.belongsInHistory(next, now: now), isFalse);
    expect(projection.belongsInHistory(recorded, now: now), isTrue);
    expect(
      projection
          .upcomingWindow(<DoseLedgerEntry>[far, thisWeek, next], now: now)
          .map((dose) => dose.id),
      <String>['next', 'week'],
    );
  });
}

DoseLedgerEntry _dose(
  String id,
  String medicationId,
  DateTime dueAt, {
  DoseStatus status = DoseStatus.unrecorded,
}) => DoseLedgerEntry(
  id: id,
  medicationId: medicationId,
  scheduleId: 'schedule-$medicationId',
  animalId: 'animal-1',
  createdAt: DateTime.utc(2026, 7, 1),
  updatedAt: DateTime.utc(2026, 7, 1),
  dueAt: dueAt,
  intendedLocalTime: dueAt.toIso8601String(),
  timeZoneId: 'UTC',
  status: status,
  administeredAt: status == DoseStatus.given ? dueAt : null,
);
