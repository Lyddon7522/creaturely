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

  test('migration planner declares v1 through v4 and rejects unsupported versions', () {
    final steps = const MigrationPlanner().plan(1, 4);
    expect(steps, hasLength(3));
    expect(steps.first.fromVersion, 1);
    expect(steps.first.toVersion, 2);
    expect(steps.first.description, contains('time-zone'));
    expect(steps[1].fromVersion, 2);
    expect(steps[1].toVersion, 3);
    expect(steps[1].description, contains('respiratory-rate reminders'));
    expect(steps.last.fromVersion, 3);
    expect(steps.last.toVersion, 4);
    expect(steps.last.description, contains('weight-check reminders'));
    expect(() => const MigrationPlanner().plan(0, 4), throwsUnsupportedError);
    expect(() => const MigrationPlanner().plan(4, 5), throwsUnsupportedError);
  });
}
