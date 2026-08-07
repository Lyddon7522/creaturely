class RecoverySnapshot {
  const RecoverySnapshot({required this.id, required this.createdAt});

  final String id;
  final DateTime createdAt;
}

class SnapshotRetention {
  const SnapshotRetention({this.daily = 7, this.weekly = 4, this.monthly = 6});

  final int daily;
  final int weekly;
  final int monthly;

  List<RecoverySnapshot> retain(Iterable<RecoverySnapshot> snapshots) {
    final sorted = snapshots.toList(growable: false)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    if (sorted.isEmpty) {
      return const <RecoverySnapshot>[];
    }

    final kept = <String, RecoverySnapshot>{sorted.first.id: sorted.first};
    _keepBuckets(
      sorted,
      kept,
      daily,
      (date) => '${date.toUtc().year}-${date.toUtc().month}-${date.toUtc().day}',
    );
    _keepBuckets(sorted, kept, weekly, (date) {
      final utc = date.toUtc();
      final monday = utc.subtract(Duration(days: utc.weekday - DateTime.monday));
      return '${monday.year}-${monday.month}-${monday.day}';
    });
    _keepBuckets(sorted, kept, monthly, (date) => '${date.toUtc().year}-${date.toUtc().month}');

    final result = kept.values.toList(growable: false)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return result;
  }

  void _keepBuckets(
    List<RecoverySnapshot> sorted,
    Map<String, RecoverySnapshot> kept,
    int limit,
    String Function(DateTime) bucketFor,
  ) {
    final buckets = <String>{};
    for (final snapshot in sorted) {
      final bucket = bucketFor(snapshot.createdAt);
      if (buckets.add(bucket)) {
        kept[snapshot.id] = snapshot;
        if (buckets.length >= limit) {
          return;
        }
      }
    }
  }
}
