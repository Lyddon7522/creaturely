import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;

import '../../data/backup_service.dart';
import '../../domain/models.dart';
import 'care_controller.dart';
import 'command_controller.dart';
import 'dependencies.dart';
import 'media_controller.dart';

final recoveryControllerProvider = AsyncNotifierProvider<RecoveryController, void>(
  RecoveryController.new,
);

class RecoveryController extends CommandController {
  Future<Uint8List> createBackup() => run(() async {
    final repository = ref.read(repositoryProvider);
    final documents = await ref.read(documentStorageProvider.future);
    return documents.exclusiveFiles(
      () async => const CreaturelyBackupService().createFromFiles(
        snapshot: await repository.loadSnapshot(),
      ),
    );
  });

  Future<void> restore(ValidatedBackup backup) => run(() async {
    final repository = ref.read(repositoryProvider);
    final timeZones = ref.read(timeZoneServiceProvider);
    final documents = await ref.read(documentStorageProvider.future);
    await AtomicRestoreCoordinator(
      backups: const CreaturelyBackupService(),
      store: repository,
      documents: documents,
      safetyWriter: DirectorySafetySnapshotWriter(
        Directory(path.join(documents.root.parent.path, 'recovery')),
      ),
    ).restoreValidated(backup);
    // The restore is committed. Optional maintenance cannot turn that success
    // into a reported restore failure or invite a second restore on retry.
    if (!ref.mounted) return;
    try {
      final care = ref.read(careControllerProvider.notifier);
      final zone = await timeZones.configure();
      if (ref.mounted) await care.maintain(timeZoneId: zone);
    } on Object catch (error, stack) {
      if (ref.mounted) ref.read(reminderSyncProvider.notifier).reportError(error, stack);
    }
    if (ref.mounted) await ref.read(attachmentCleanupProvider.notifier).collect();
  });

  Future<void> deleteLocalJournal() => run(() async {
    final repository = ref.read(repositoryProvider);
    final media = ref.read(mediaServiceProvider);
    final recovered = ref.read(recoveredMediaProvider.future);
    final documents = await ref.read(documentStorageProvider.future);
    try {
      await recovered;
    } on Object {
      // Failed picker recovery must not block the keeper's erase-everything choice.
    }
    await documents.exclusiveFiles(() async {
      await repository.replaceSnapshot(CreaturelySnapshot.empty());
      await documents.deleteJournalArtifacts();
    });
    media.acknowledgeRecoveredImages();
    if (ref.mounted) {
      ref.invalidate(recoveredMediaProvider);
      await ref.read(reminderSyncProvider.notifier).synchronize();
    }
  });
}
