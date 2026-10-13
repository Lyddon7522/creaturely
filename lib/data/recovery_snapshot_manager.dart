import '../domain/retention.dart';
import '../platform/cloud_recovery_bridge.dart';
import 'backup_service.dart';
import 'document_storage.dart';
import 'repository.dart';

class RecoverySnapshotManager {
  RecoverySnapshotManager({
    required this.store,
    required this.documents,
    required this.backups,
    required this.cloud,
    this.retention = const SnapshotRetention(),
    this.automaticInterval = const Duration(days: 1),
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final SnapshotStore store;
  final DocumentStorage documents;
  final CreaturelyBackupService backups;
  final CloudRecoveryBridge cloud;
  final SnapshotRetention retention;
  final Duration automaticInterval;
  final DateTime Function() _clock;
  Future<void> _tail = Future.value();

  Future<CloudSnapshotInfo> createAndPrune({bool force = false}) {
    final work = _tail.then((_) => _createAndPrune(force: force));
    _tail = work.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    return work;
  }

  Future<CloudSnapshotInfo> _createAndPrune({required bool force}) async {
    final status = await cloud.status();
    if (status != CloudRecoveryState.available) {
      throw CloudRecoveryException(status, 'Cloud recovery is unavailable (${status.name}).');
    }
    final now = _clock().toUtc();
    final existing = List<CloudSnapshotInfo>.of(await cloud.list());
    existing.sort((left, right) => right.createdAt.compareTo(left.createdAt));
    if (!force && existing.isNotEmpty) {
      final elapsed = now.difference(existing.first.createdAt.toUtc());
      if (elapsed < automaticInterval) {
        return existing.first;
      }
    }
    final bytes = await documents.exclusiveFiles(
      () async => backups.createFromFiles(snapshot: await store.loadSnapshot()),
    );
    final id = 'snapshot-${now.toIso8601String()}';
    await cloud.upload(id, bytes, now);

    final remote = await cloud.list();
    final keep = retention
        .retain(remote.map((item) => RecoverySnapshot(id: item.id, createdAt: item.createdAt)))
        .map((item) => item.id)
        .toSet();
    for (final item in remote.where((value) => !keep.contains(value.id))) {
      await cloud.delete(item.id);
    }
    return CloudSnapshotInfo(id: id, createdAt: now, byteLength: bytes.length);
  }
}
