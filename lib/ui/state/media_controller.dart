import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/document_storage.dart';
import 'dependencies.dart';

final recoveredMediaProvider =
    AsyncNotifierProvider<RecoveredMediaController, List<StoredAttachment>>(
      RecoveredMediaController.new,
      retry: (retryCount, error) => null,
    );

class RecoveredMediaController extends AsyncNotifier<List<StoredAttachment>> {
  @override
  Future<List<StoredAttachment>> build() async {
    final media = ref.watch(mediaServiceProvider);
    final storage = await ref.watch(documentStorageProvider.future);
    if (!ref.mounted) return const [];
    // Once the native lost-result call consumes images, finish preserving them
    // even if the provider is disposed. No ref is used after that call.
    for (final file in await media.recoverImages()) {
      await storage.retainRecovered(file);
    }
    media.acknowledgeRecoveredImages();
    return storage.recoveredImages();
  }

  Future<void> consume(StoredAttachment attachment) async {
    final storage = await ref.read(documentStorageProvider.future);
    if (!ref.mounted) throw StateError('The image selection was cancelled.');
    await storage.consumeRecovered(attachment.path);
    final images = await storage.recoveredImages();
    if (ref.mounted) state = AsyncData(images);
  }
}

final attachmentCleanupProvider = AsyncNotifierProvider<AttachmentCleanupController, void>(
  AttachmentCleanupController.new,
);

class AttachmentCleanupController extends AsyncNotifier<void> {
  Future<void> _tail = Future.value();
  @override
  void build() {}

  Future<void> collect() {
    if (!ref.mounted) return Future.value();
    final repository = ref.read(repositoryProvider);
    final storage = ref.read(documentStorageProvider.future);
    final task = _tail.then((_) async {
      if (!ref.mounted) return;
      try {
        final documents = await storage;
        await documents.exclusiveFiles(
          () async => documents.collectGarbage(await repository.attachmentReferences()),
        );
        if (ref.mounted) state = const AsyncData(null);
      } on Object catch (error, stack) {
        if (ref.mounted) state = AsyncError(error, stack);
      }
    });
    _tail = task;
    return task;
  }
}
