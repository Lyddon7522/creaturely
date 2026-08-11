import 'package:creaturely/domain/migrations.dart';
import 'package:creaturely/domain/retention.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('retention keeps latest plus daily, weekly, and monthly recovery buckets', () {
    final snapshots = <RecoverySnapshot>[
      for (var day = 0; day < 240; day++)
        RecoverySnapshot(
          id: 'snapshot-$day',
          createdAt: DateTime.utc(2026, 7, 28).subtract(Duration(days: day)),
        ),
    ];
    final retained = const SnapshotRetention().retain(snapshots);

    expect(retained.first.id, 'snapshot-0');
    expect(retained.map((value) => value.id).toSet().length, retained.length);
    expect(retained.length, lessThanOrEqualTo(1 + 7 + 4 + 6));
    expect(retained.any((value) => value.createdAt.month < DateTime.utc(2026, 7).month), isTrue);
  });

  test('migration planner declares v1 through v5 and rejects unsupported versions', () {
    final steps = const MigrationPlanner().plan(1, 5);
    expect(steps, hasLength(4));
    expect(steps.first.fromVersion, 1);
    expect(steps.first.toVersion, 2);
    expect(steps.first.description, contains('time-zone'));
    expect(steps[1].fromVersion, 2);
    expect(steps[1].toVersion, 3);
    expect(steps[1].description, contains('respiratory-rate reminders'));
    expect(steps[2].fromVersion, 3);
    expect(steps[2].toVersion, 4);
    expect(steps[2].description, contains('weight-check reminders'));
    expect(steps.last.fromVersion, 4);
    expect(steps.last.toVersion, 5);
    expect(steps.last.description, contains('prescription and refill details'));
    expect(() => const MigrationPlanner().plan(0, 5), throwsUnsupportedError);
    expect(() => const MigrationPlanner().plan(5, 6), throwsUnsupportedError);
  });
}
