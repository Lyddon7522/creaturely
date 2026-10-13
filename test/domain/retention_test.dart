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
}
