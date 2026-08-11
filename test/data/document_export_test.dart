import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:creaturely/data/document_storage.dart';
import 'package:creaturely/data/export_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory sandbox;
  late DocumentStorage storage;

  setUp(() async {
    sandbox = await Directory.systemTemp.createTemp('creaturely-test-');
    storage = await DocumentStorage.open(Directory('${sandbox.path}/managed'));
  });

  tearDown(() async {
    if (await sandbox.exists()) {
      await sandbox.delete(recursive: true);
    }
  });

  test('imports into app storage, deduplicates hashes, and exposes failure states', () async {
    final firstSource = File('${sandbox.path}/certificate.pdf')
      ..writeAsBytesSync(fixtureAttachment);
    final secondSource = File('${sandbox.path}/copy.pdf')..writeAsBytesSync(fixtureAttachment);
    final first = await storage.importFile(firstSource);
    final second = await storage.importFile(secondSource);
    expect(first.path, second.path);
    expect(first.checksumSha256, fixtureChecksum);

    var document = fixtureSnapshot(storedPath: first.path).documents.single;
    expect(await storage.inspect(document), AttachmentHealth.available);
    await File(first.path).writeAsBytes(<int>[9, 9, 9]);
    expect(await storage.inspect(document), AttachmentHealth.corrupt);
    await File(first.path).delete();
    expect(await storage.inspect(document), AttachmentHealth.missing);

    document = document.copyWith(storedPath: '${sandbox.path}/does-not-exist.pdf');
    expect(await storage.inspect(document), AttachmentHealth.missing);
  });

  test('staged attachment swap commits atomically and can be finalized', () async {
    final old = File('${storage.root.path}/old.bin')..writeAsBytesSync(<int>[1]);
    expect(await old.exists(), isTrue);
    final swap = await storage.stageRestore(<String, Uint8List>{
      fixtureChecksum: fixtureAttachment,
    });
    await swap.commit();
    expect(await old.exists(), isFalse);
    expect(await File(swap.finalPaths[fixtureChecksum]!).readAsBytes(), fixtureAttachment);
    await swap.finalize();
  });

  test('delete-everything clears attachments and recoverable safety copies', () async {
    final parent = storage.root.parent;
    final attachment = File('${storage.root.path}/private.blob')
      ..writeAsBytesSync(fixtureAttachment);
    final migration = Directory('${parent.path}/migration-safety')..createSync();
    final recovery = Directory('${parent.path}/recovery')..createSync();
    File('${migration.path}/pre-open.sqlite').writeAsBytesSync(fixtureAttachment);
    File('${recovery.path}/before-restore.creaturely').writeAsBytesSync(fixtureAttachment);

    await storage.deleteJournalArtifacts();

    expect(await attachment.exists(), isFalse);
    expect(await migration.exists(), isFalse);
    expect(await recovery.exists(), isFalse);
    expect(await storage.root.exists(), isTrue);
    expect(await storage.root.list().toList(), isEmpty);
  });

  test('PDF, CSV, ZIP, selected originals, and temporary cleanup are verifiable', () async {
    final snapshot = fixtureSnapshot();
    final bundle = await const PetExportService().build(
      snapshot: snapshot,
      animalId: 'animal-1',
      startDate: DateTime.utc(2026, 3, 1),
      endDate: DateTime.utc(2027, 4),
      selectedDocumentIds: const <String>{'document-1'},
      attachmentBytes: <String, Uint8List>{fixtureChecksum: fixtureAttachment},
    );

    expect(utf8.decode(bundle.pdf.take(5).toList()), '%PDF-');
    final printablePdf = latin1.decode(bundle.pdf, allowInvalid: true);
    expect(printablePdf, contains('Moss'));
    expect(printablePdf, contains('diagnostic disclaimer'));
    expect(printablePdf, contains('veterinary advice'));
    expect(printablePdf, contains('/Subtype/Type0'));
    expect(printablePdf, contains('/ToUnicode'));

    final csv = utf8.decode(bundle.csv);
    expect(csv, startsWith('record_type,timestamp_utc_or_date'));
    expect(csv, contains('document,2026-03-08,Rabies certificate'));
    expect(csv, contains('respiratory_session'));
    expect(csv, contains(',30000,10,20.0,'));
    expect(csv, contains('0.12,kg,lb'));
    expect(csv, contains('Quiet after lights out.'));
    expect(csv, contains('2026-03-08T14:35:00.000Z'));
    expect(csv, contains('8.0,16.0,28.0'));
    expect(csv, contains('medication,2026-03-07,Supportive care'));
    expect(csv, contains('20 mg/mL'));
    expect(csv, contains('Lakeside Veterinary Pharmacy'));
    expect(csv, contains('RX-042'));
    expect(csv, contains('2026-04-01'));
    expect(csv, contains('medication_schedule'));
    expect(csv, contains('2027-03-08'));
    expect(csv, isNot(contains('reminder_at_utc')));

    final archive = ZipDecoder().decodeBytes(bundle.zip);
    expect(archive.find('creaturely-summary.pdf')?.readBytes(), bundle.pdf);
    expect(archive.find('creaturely-raw-data.csv')?.readBytes(), bundle.csv);
    final originals = archive.files.where((entry) => entry.name.startsWith('documents/'));
    expect(originals, hasLength(1));
    expect(originals.single.readBytes(), fixtureAttachment);

    final files = await TemporaryExportFiles.write(sandbox, bundle);
    expect(await files.pdf.exists(), isTrue);
    expect(await files.csv.exists(), isTrue);
    expect(await files.zip.exists(), isTrue);
    final exportDirectory = files.directory;
    await files.cleanup();
    expect(await exportDirectory.exists(), isFalse);
  });

  test('document metadata remains in reports when its original is not selected', () async {
    final bundle = await const PetExportService().build(
      snapshot: fixtureSnapshot(),
      animalId: 'animal-1',
      startDate: DateTime.utc(2026),
      endDate: DateTime.utc(2028),
      selectedDocumentIds: const <String>{},
      attachmentBytes: const <String, Uint8List>{},
    );

    expect(utf8.decode(bundle.csv), contains('document,2026-03-08,Rabies certificate'));
    final archive = ZipDecoder().decodeBytes(bundle.zip);
    expect(archive.files.where((entry) => entry.name.startsWith('documents/')), isEmpty);
  });

  test('missing selected document prevents a partial export package', () async {
    await expectLater(
      const PetExportService().build(
        snapshot: fixtureSnapshot(),
        animalId: 'animal-1',
        startDate: DateTime.utc(2026),
        endDate: DateTime.utc(2028),
        selectedDocumentIds: const <String>{'document-1'},
        attachmentBytes: const <String, Uint8List>{},
      ),
      throwsA(isA<FileSystemException>()),
    );
  });

  test('media type inference supports images and PDFs without hidden uploads', () {
    expect(DocumentStorage.mediaTypeForPath('scan.PDF'), 'application/pdf');
    expect(DocumentStorage.mediaTypeForPath('photo.heic'), 'image/heic');
    expect(DocumentStorage.mediaTypeForPath('photo.png'), 'image/png');
  });
}
