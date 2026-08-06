import '../domain/retention.dart';
import '../platform/cloud_recovery_bridge.dart';
import 'backup_service.dart';
import 'document_storage.dart';
import 'repository.dart';

class RecoverySnapshotManager {
  const RecoverySnapshotManager({
    required this.store,
    required this.documents,
    required this.backups,
    required this.cloud,
    this.retention = const SnapshotRetention(),
    this.automaticInterval = const Duration(days: 1),
  });

  final SnapshotStore store;
  final DocumentStorage documents;
  final CreaturelyBackupService backups;
  final CloudRecoveryBridge cloud;
  final SnapshotRetention retention;
  final Duration automaticInterval;

  Future<CloudSnapshotInfo> createAndPrune({bool force = false}) async {
    final status = await cloud.status();
    if (status != CloudRecoveryState.available) {
      throw CloudRecoveryException(status, _message(status));
    }
    final now = DateTime.now().toUtc();
    final existing = List<CloudSnapshotInfo>.of(await cloud.list());
    existing.sort((left, right) => right.createdAt.compareTo(left.createdAt));
    if (!force && existing.isNotEmpty) {
      final elapsed = now.difference(existing.first.createdAt.toUtc());
      if (elapsed < automaticInterval) {
        return existing.first;
      }
    }
    final snapshot = await store.loadSnapshot();
    final attachments = await documents.readAttachments(snapshot.documents);
    final animalPhotos = await documents.readAnimalPhotos(snapshot.animals);
    final bytes = backups.create(
      snapshot: snapshot,
      attachments: attachments,
      animalPhotos: animalPhotos,
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

  String _message(CloudRecoveryState state) => switch (state) {
    CloudRecoveryState.signedOut => 'Sign in to the platform cloud account to use recovery.',
    CloudRecoveryState.offline => 'Recovery is offline. Local journaling is unaffected.',
    CloudRecoveryState.quotaExceeded => 'The cloud provider reports that storage is full.',
    CloudRecoveryState.conflict =>
      'The cloud provider reported a conflicting recovery snapshot. Local data was not changed.',
    CloudRecoveryState.notConfigured => 'Recovery capability is not configured in this build.',
    CloudRecoveryState.permissionDenied => 'Cloud recovery permission was declined.',
    CloudRecoveryState.unknownError => 'The cloud provider returned an unknown error.',
    CloudRecoveryState.available => 'Recovery is available.',
  };
}
