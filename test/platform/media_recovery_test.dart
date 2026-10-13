import 'dart:io';

import 'package:creaturely/data/document_storage.dart';
import 'package:creaturely/platform/media_service.dart';
import 'package:creaturely/ui/app_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'lost picker results survive a storage failure and are acknowledged only after persistence',
    () async {
      final temporary = await Directory.systemTemp.createTemp('creaturely-picker-retry-');
      final root = Directory('${temporary.path}/attachments');
      final storage = await DocumentStorage.open(root);
      final source = await File('${temporary.path}/synthetic.png').writeAsBytes([1, 3, 3, 7]);
      var nativeCalls = 0;
      final media = SystemMediaService(
        recoverLostImages: () async {
          nativeCalls++;
          return [source];
        },
      );
      final container = ProviderContainer(
        overrides: [
          documentStorageProvider.overrideWith((ref) async => storage),
          mediaServiceProvider.overrideWithValue(media),
        ],
      );
      addTearDown(() async {
        container.dispose();
        await temporary.delete(recursive: true);
      });
      await root.delete(recursive: true);
      await File(root.path).writeAsString('Synthetic unavailable storage');
      await expectLater(
        container.read(recoveredMediaProvider.future),
        throwsA(isA<FileSystemException>()),
      );
      expect(nativeCalls, 1);
      await File(root.path).delete();
      await root.create();
      container.invalidate(recoveredMediaProvider);
      final recovered = await container.read(recoveredMediaProvider.future);
      expect(recovered, hasLength(1));
      expect(await File(recovered.single.path).readAsBytes(), [1, 3, 3, 7]);
      expect(nativeCalls, 1);
      await storage.consumeRecovered(recovered.single.path);
      container.invalidate(recoveredMediaProvider);
      expect(await container.read(recoveredMediaProvider.future), isEmpty);
      expect(nativeCalls, 1);
      storage.release(recovered.single.path);
    },
  );

  test('native lost-result errors can be retried without caching the failure', () async {
    var attempts = 0;
    final media = SystemMediaService(
      recoverLostImages: () async {
        if (++attempts == 1) throw StateError('Synthetic picker error');
        return [];
      },
    );
    await expectLater(media.recoverImages(), throwsStateError);
    expect(await media.recoverImages(), isEmpty);
    expect(attempts, 2);
  });
}
