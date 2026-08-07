import 'dart:io';
import 'dart:typed_data';

import 'package:creaturely/data/backup_service.dart';
import 'package:creaturely/data/document_storage.dart';
import 'package:creaturely/data/recovery_snapshot_manager.dart';
import 'package:creaturely/data/repository.dart';
import 'package:creaturely/domain/models.dart';
import 'package:creaturely/platform/cloud_recovery_bridge.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fixtures.dart';

void main() {
  group('RecoverySnapshotManager automatic frequency', () {
    late Directory temporaryDirectory;
    late DocumentStorage documents;
    late _RecordingStore store;
    late _RecordingCloudBridge cloud;

    setUp(() {
      temporaryDirectory = Directory.systemTemp.createTempSync('creaturely-recovery-test-');
      documents = DocumentStorage.openSync(Directory('${temporaryDirectory.path}/attachments'));
      final json = fixtureSnapshot().toJson()..['documents'] = <Object?>[];
      store = _RecordingStore(CreaturelySnapshot.fromJson(json));
      cloud = _RecordingCloudBridge();
    });

    tearDown(() {
      if (temporaryDirectory.existsSync()) {
        temporaryDirectory.deleteSync(recursive: true);
      }
    });

    test('reuses a recent automatic snapshot without loading or uploading journal data', () async {
      final recent = CloudSnapshotInfo(
        id: 'recent',
        createdAt: DateTime.now().toUtc().subtract(const Duration(hours: 1)),
        byteLength: 42,
      );
      cloud.snapshots.add(recent);
      final manager = RecoverySnapshotManager(
        store: store,
        documents: documents,
        backups: const CreaturelyBackupService(),
        cloud: cloud,
      );

      final result = await manager.createAndPrune();

      expect(result.id, recent.id);
      expect(store.loadCalls, 0);
      expect(cloud.uploadCalls, 0);
      expect(cloud.deletedIds, isEmpty);
    });

    test('a deliberate manual snapshot bypasses the daily interval', () async {
      cloud.snapshots.add(
        CloudSnapshotInfo(
          id: 'recent',
          createdAt: DateTime.now().toUtc().subtract(const Duration(hours: 1)),
          byteLength: 42,
        ),
      );
      final manager = RecoverySnapshotManager(
        store: store,
        documents: documents,
        backups: const CreaturelyBackupService(),
        cloud: cloud,
      );

      final result = await manager.createAndPrune(force: true);

      expect(result.id, startsWith('snapshot-'));
      expect(store.loadCalls, 1);
      expect(cloud.uploadCalls, 1);
      expect(cloud.snapshots.map((value) => value.id), contains(result.id));
      expect(cloud.deletedIds, contains('recent'));
    });
  });
}

class _RecordingStore implements SnapshotStore {
  _RecordingStore(this.snapshot);

  CreaturelySnapshot snapshot;
  int loadCalls = 0;

  @override
  Future<CreaturelySnapshot> loadSnapshot() async {
    loadCalls++;
    return snapshot;
  }

  @override
  Future<void> replaceSnapshot(CreaturelySnapshot snapshot) async {
    this.snapshot = snapshot;
  }
}

class _RecordingCloudBridge implements CloudRecoveryBridge {
  final List<CloudSnapshotInfo> snapshots = <CloudSnapshotInfo>[];
  final List<String> deletedIds = <String>[];
  int uploadCalls = 0;

  @override
  Future<CloudRecoveryState> authorize() async => CloudRecoveryState.available;

  @override
  Future<void> delete(String id) async {
    deletedIds.add(id);
    snapshots.removeWhere((value) => value.id == id);
  }

  @override
  Future<Uint8List> download(String id) async => Uint8List(0);

  @override
  Future<List<CloudSnapshotInfo>> list() async => List<CloudSnapshotInfo>.of(snapshots);

  @override
  Future<CloudRecoveryState> status() async => CloudRecoveryState.available;

  @override
  Future<void> upload(String id, Uint8List bytes, DateTime createdAt) async {
    uploadCalls++;
    snapshots.add(CloudSnapshotInfo(id: id, createdAt: createdAt, byteLength: bytes.length));
  }
}
