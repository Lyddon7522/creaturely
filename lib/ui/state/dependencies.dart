import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/backup_service.dart';
import '../../data/database.dart';
import '../../data/document_storage.dart';
import '../../data/recovery_snapshot_manager.dart';
import '../../data/repository.dart';
import '../../platform/cloud_recovery_bridge.dart';
import '../../platform/document_save_service.dart';
import '../../platform/external_link_service.dart';
import '../../platform/feedback_service.dart';
import '../../platform/media_service.dart';
import '../../platform/notification_service.dart';
import '../../platform/time_zone_service.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final repositoryProvider = Provider<CreaturelyRepository>(
  (ref) => CreaturelyRepository(ref.watch(databaseProvider)),
);

final documentStorageProvider = FutureProvider<DocumentStorage>(
  (ref) => DocumentStorage.openDefault(),
);

final reminderServiceProvider = Provider<ReminderService>((ref) {
  final reminders = LocalReminderService();
  ref.onDispose(reminders.dispose);
  return reminders;
});

final timeZoneServiceProvider = Provider<TimeZoneService>((ref) => DeviceTimeZoneService());

final recordingFeedbackProvider = Provider<RecordingFeedback>(
  (ref) => const SystemRecordingFeedback(),
);

final cloudRecoveryBridgeProvider = Provider<CloudRecoveryBridge>(
  (ref) => const MethodChannelCloudRecoveryBridge(),
);

final documentSaveServiceProvider = Provider<DocumentSaveService>(
  (ref) => const SystemDocumentSaveService(),
);

final externalLinkServiceProvider = Provider<ExternalLinkService>(
  (ref) => const SystemExternalLinkService(),
);

final recoverySnapshotManagerProvider = FutureProvider<RecoverySnapshotManager>((ref) async {
  final repository = ref.watch(repositoryProvider);
  final cloud = ref.watch(cloudRecoveryBridgeProvider);
  final clock = ref.watch(wallClockProvider);
  final documents = await ref.watch(documentStorageProvider.future);
  return RecoverySnapshotManager(
    store: repository,
    documents: documents,
    backups: const CreaturelyBackupService(),
    cloud: cloud,
    clock: clock,
  );
});

final wallClockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

final mediaServiceProvider = Provider<MediaService>((ref) => SystemMediaService());
