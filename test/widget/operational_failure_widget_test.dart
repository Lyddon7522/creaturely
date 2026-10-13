import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:creaturely/data/repository.dart';
import 'package:creaturely/domain/models.dart';
import 'package:creaturely/platform/cloud_recovery_bridge.dart';
import 'package:creaturely/platform/document_save_service.dart';
import 'package:creaturely/platform/media_service.dart';
import 'package:creaturely/ui/app_controller.dart';
import 'package:creaturely/ui/navigation/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fixtures.dart';
import '../support/widget_harness.dart';

void main() {
  testWidgets(
    'failed journal queries show recovery, do not masquerade as empty data, and retry explicitly',
    (tester) async {
      var reads = 0;
      final harness = await WidgetHarness.create(
        snapshot: fixtureSnapshot(),
        providerOverrides: [
          animalsProvider(null).overrideWith((ref) {
            if (++reads == 1) return Stream.error(StateError('Synthetic query failure'));
            return ref.read(repositoryProvider).database.watchAnimals();
          }),
        ],
      );
      addTearDown(() => harness.close(tester));
      await harness.pumpApp(tester);
      expect(find.text('Unable to load journal data'), findsOneWidget);
      expect(find.text('Meet Creaturely'), findsNothing);
      expect(find.text('Moss'), findsNothing);
      await tester.pump(const Duration(seconds: 10));
      expect(reads, 1);
      await tester.tap(find.text('Try again'));
      await WidgetHarness.pumpFrames(tester);
      expect(reads, 2);
      expect(find.text('Moss'), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('an identifier save failure keeps the edited draft open for retry', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(520, 1000);
    addTearDown(tester.view.reset);
    late _FailIdentifierOnce repository;
    final harness = await WidgetHarness.create(
      snapshot: fixtureSnapshot(),
      repositoryFactory: (db) => repository = _FailIdentifierOnce(db),
    );
    addTearDown(() => harness.close(tester));
    await harness.pumpApp(tester);
    harness.container.read(routerProvider).push<void>('/animal/animal-1/edit');
    await WidgetHarness.pumpFrames(tester);
    await tester.dragUntilVisible(find.text('A-42'), find.byType(ListView), const Offset(0, -500));
    await tester.pump();
    await tester.tap(find.byTooltip('Identifier actions'));
    await WidgetHarness.pumpFrames(tester);
    await tester.tap(find.text('Edit').last);
    await WidgetHarness.pumpFrames(tester);
    await tester.enterText(find.byKey(const ValueKey('identifier_phone')), '+1 555 010 0199');
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await WidgetHarness.pumpFrames(tester);
    expect(find.text('Edit identifier'), findsOneWidget);
    expect(find.text('+1 555 010 0199'), findsOneWidget);
    expect(find.text('Could not save. Your changes are kept here; try again.'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await WidgetHarness.pumpFrames(tester);
    expect(find.text('Edit identifier'), findsNothing);
    expect(repository.ids, ['identifier-1', 'identifier-1']);
    expect((await harness.database.snapshot()).identifiers.single.phone, '+1 555 010 0199');
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'a picker returning after the document form closes does not import or mutate disposed state',
    (tester) async {
      final media = _DeferredPicker();
      final harness = await WidgetHarness.create(snapshot: fixtureSnapshot(), media: media);
      addTearDown(() => harness.close(tester));
      await harness.pumpApp(tester);
      harness.container.read(routerProvider).push<void>('/document/new/animal-1');
      await WidgetHarness.pumpFrames(tester);
      await tester.tap(find.byKey(const ValueKey('pick_document')));
      await WidgetHarness.pumpFrames(tester);
      expect(media.calls, 1);
      harness.container.read(routerProvider).pop();
      await WidgetHarness.pumpFrames(tester);
      final file = File('${harness.temporaryDirectory.path}/synthetic.pdf')
        ..writeAsBytesSync(fixtureAttachment);
      media.result.complete(file);
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
      await WidgetHarness.pumpFrames(tester);
      expect(harness.documents.root.listSync(recursive: true).whereType<File>(), isEmpty);
      expect((await harness.database.snapshot()).documents, hasLength(1));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('an export finishing after its screen closes does not open the native saver', (
    tester,
  ) async {
    final json = fixtureSnapshot().toJson()..['documents'] = <Object?>[];
    late _DelayedSnapshot repository;
    final saver = _CountingSaver();
    final harness = await WidgetHarness.create(
      snapshot: CreaturelySnapshot.fromJson(json),
      clock: () => fixtureTime.add(const Duration(days: 2)),
      documentSaver: saver,
      repositoryFactory: (db) => repository = _DelayedSnapshot(db),
    );
    addTearDown(() => harness.close(tester));
    await harness.pumpApp(tester);
    harness.container.read(routerProvider).push<void>('/data');
    await WidgetHarness.pumpFrames(tester);
    await tester.ensureVisible(find.byKey(const ValueKey('open_pet_export')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('open_pet_export')));
    await WidgetHarness.pumpFrames(tester);
    await tester.tap(find.byKey(const ValueKey('export_format_csv')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('save_selected_export')));
    await WidgetHarness.pumpFrames(tester);
    for (var attempt = 0; attempt < 100 && !repository.entered.isCompleted; attempt++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 5)));
      await tester.pump();
    }
    expect(repository.entered.isCompleted, isTrue);
    expect(
      tester
          .widget<DropdownButtonFormField<String>>(find.byType(DropdownButtonFormField<String>))
          .onChanged,
      isNull,
    );
    harness.container.read(routerProvider).pop();
    await WidgetHarness.pumpFrames(tester);
    repository.finish.complete();
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
    await WidgetHarness.pumpFrames(tester);
    expect(saver.calls, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a failed recovery preference save is visible and leaves the switch unchanged', (
    tester,
  ) async {
    final harness = await WidgetHarness.create(
      snapshot: fixtureSnapshot(),
      cloud: _AvailableCloud(),
      repositoryFactory: _FailRecoverySettings.new,
    );
    addTearDown(() => harness.close(tester));
    await harness.pumpApp(tester);
    harness.container.read(routerProvider).push<void>('/recovery');
    await WidgetHarness.pumpFrames(tester);
    final toggle = find.byType(SwitchListTile);
    await tester.tap(toggle);
    await WidgetHarness.pumpFrames(tester);
    expect(tester.widget<SwitchListTile>(toggle).value, isFalse);
    expect(find.text('Could not complete this action. Please try again.'), findsOneWidget);
    expect((await harness.database.readSettings()).automaticRecoveryEnabled, isFalse);
    expect(tester.takeException(), isNull);
  });
}

class _FailIdentifierOnce extends CreaturelyRepository {
  _FailIdentifierOnce(super.database);
  final List<String> ids = [];
  @override
  Future<void> saveIdentifier(AnimalIdentifier identifier) async {
    ids.add(identifier.id);
    if (ids.length == 1) throw StateError('Synthetic identifier write failure');
    await super.saveIdentifier(identifier);
  }
}

class _DeferredPicker extends SystemMediaService {
  final result = Completer<File?>();
  int calls = 0;
  @override
  Future<File?> pickFile(List<String> extensions) {
    calls++;
    return result.future;
  }
}

class _DelayedSnapshot extends CreaturelyRepository {
  _DelayedSnapshot(super.database);
  final entered = Completer<void>();
  final finish = Completer<void>();
  @override
  Future<CreaturelySnapshot> loadSnapshot() async {
    final snapshot = await super.loadSnapshot();
    entered.complete();
    await finish.future;
    return snapshot;
  }
}

class _CountingSaver implements DocumentSaveService {
  int calls = 0;
  @override
  Future<Uri?> save({
    required String fileName,
    required String dialogTitle,
    required Uint8List bytes,
    required List<String> allowedExtensions,
  }) async {
    calls++;
    return Uri.file(fileName);
  }
}

class _FailRecoverySettings extends CreaturelyRepository {
  _FailRecoverySettings(super.database);
  @override
  Future<void> saveSettings(AppSettings settings) async {
    if (settings.automaticRecoveryEnabled) throw StateError('Synthetic settings write failure');
    await super.saveSettings(settings);
  }
}

class _AvailableCloud implements CloudRecoveryBridge {
  @override
  Future<CloudRecoveryState> status() async => CloudRecoveryState.available;
  @override
  Future<CloudRecoveryState> authorize() async => CloudRecoveryState.available;
  @override
  Future<List<CloudSnapshotInfo>> list() async => [];
  @override
  Future<void> delete(String id) async {}
  @override
  Future<Uint8List> download(String id) async => Uint8List(0);
  @override
  Future<void> upload(String id, Uint8List bytes, DateTime createdAt) async {}
}
