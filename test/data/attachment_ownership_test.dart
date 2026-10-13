import 'dart:io';

import 'package:creaturely/data/document_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fixtures.dart';

void main() {
  late Directory directory;
  late DocumentStorage storage;
  setUp(() async {
    directory = await Directory.systemTemp.createTemp('creaturely-ownership-');
    storage = await DocumentStorage.open(Directory('${directory.path}/attachments'));
  });
  tearDown(() => directory.delete(recursive: true));

  test('recovered image metadata survives deduplication against a restored blob', () async {
    final generation = await storage.stageRestore({fixtureChecksum: fixtureAttachment});
    await generation.commit();
    final source = await File('${directory.path}/recovered.png').writeAsBytes(fixtureAttachment);
    await storage.retainRecovered(source);
    storage = await DocumentStorage.open(storage.root);
    final recovered = (await storage.recoveredImages()).single;
    expect(recovered.path, generation.finalPaths[fixtureChecksum]);
    expect(recovered.mediaType, 'image/png');
  });

  test(
    'pending imports are leased, deduplicated, and removed only after their last owner',
    () async {
      final source = await File('${directory.path}/synthetic.png').writeAsBytes([1, 2, 3]);
      final first = await storage.importFile(source);
      final second = await storage.importFile(source);
      expect(second.path, first.path);
      storage.release(first.path);
      await storage.collectGarbage({});
      expect(await File(first.path).exists(), isTrue);
      storage.release(second.path);
      await storage.collectGarbage({first.path});
      expect(await File(first.path).exists(), isTrue);
      await storage.collectGarbage({});
      expect(await File(first.path).exists(), isFalse);
    },
  );

  test('overlapping recovered images survive restart and transfer ownership to a draft', () async {
    final first = await File('${directory.path}/one.png').writeAsBytes([1, 2]);
    final second = await File('${directory.path}/two.png').writeAsBytes([3, 4]);
    await Future.wait([storage.retainRecovered(first), storage.retainRecovered(second)]);
    storage = await DocumentStorage.open(storage.root);
    final recovered = await storage.recoveredImages();
    expect(recovered, hasLength(2));
    await storage.collectGarbage({});
    await storage.consumeRecovered(recovered.first.path);
    expect(await storage.recoveredImages(), hasLength(1));
    await storage.collectGarbage({});
    expect(await File(recovered.first.path).exists(), isTrue);
    storage.release(recovered.first.path);
    await storage.collectGarbage({});
    expect(await File(recovered.first.path).exists(), isFalse);
    expect(await File(recovered.last.path).exists(), isTrue);
  });
}
