import 'dart:convert';
import 'dart:typed_data';

import 'package:creaturely/data/backup_service.dart';
import 'package:creaturely/domain/models.dart';
import 'package:creaturely/platform/document_save_service.dart';
import 'package:creaturely/ui/app_controller.dart';
import 'package:creaturely/ui/core/theme.dart';
import 'package:creaturely/ui/features/settings/data_management_screen.dart';
import 'package:creaturely/ui/navigation/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fixtures.dart';
import '../support/widget_harness.dart';

void main() {
  testWidgets('medication editing reschedules without duplicate future ledger entries', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(700, 1000);
    addTearDown(tester.view.reset);
    final harness = await WidgetHarness.create(snapshot: fixtureSnapshot());
    addTearDown(() => harness.close(tester));
    await harness.pumpApp(tester);

    harness.container.read(routerProvider).push<void>('/medication/med-1/edit/animal-1');
    await WidgetHarness.pumpFrames(tester);
    expect(find.byKey(const ValueKey('medication_name')), findsOneWidget);
    expect(find.byKey(const ValueKey('medication_strength')), findsOneWidget);
    expect(find.byKey(const ValueKey('medication_pharmacy')), findsOneWidget);
    expect(find.textContaining('local clock time'), findsNothing);
    expect(find.textContaining('exact alarms'), findsNothing);
    final instructions = find.byKey(const ValueKey('medication_instructions'));
    await tester.enterText(instructions, 'Updated after veterinarian review');
    await tester.enterText(
      find.byKey(const ValueKey('medication_pharmacy')),
      'Harbor Veterinary Pharmacy',
    );
    final clearRefillDate = find.byTooltip('Clear next refill date');
    await tester.ensureVisible(clearRefillDate);
    await tester.pump();
    await tester.tap(clearRefillDate);
    await tester.pump();
    await tester.dragUntilVisible(
      find.byKey(const ValueKey('save_medication')),
      find.byType(ListView),
      const Offset(0, -500),
    );
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('save_medication')));
    await WidgetHarness.pumpFrames(tester, count: 30);

    final saved = await harness.database.snapshot();
    expect(saved.medications.single.instructions, 'Updated after veterinarian review');
    expect(saved.medications.single.strength, '20 mg/mL');
    expect(saved.medications.single.pharmacy, 'Harbor Veterinary Pharmacy');
    expect(saved.medications.single.prescriptionNumber, 'RX-042');
    expect(saved.medications.single.refillsRemaining, 2);
    expect(saved.medications.single.nextRefillDate, isNull);
    expect(saved.medicationSchedules, hasLength(1));
    final future = saved.doseLedger.where((dose) => dose.status == DoseStatus.unrecorded).toList();
    expect(future, isNotEmpty);
    expect(future.map((dose) => dose.id).toSet(), hasLength(future.length));
    expect(saved.doseLedger.where((dose) => dose.status == DoseStatus.given), hasLength(1));
  });

  testWidgets('a new medication adds only the chosen time and allows removing it', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(700, 1000);
    addTearDown(tester.view.reset);
    final harness = await WidgetHarness.create(snapshot: fixtureSnapshot());
    addTearDown(() => harness.close(tester));
    await harness.pumpApp(tester);

    harness.container.read(routerProvider).push<void>('/medication/new/animal-1');
    await WidgetHarness.pumpFrames(tester);
    final addTime = find.text('Add time');
    await tester.dragUntilVisible(addTime, find.byType(ListView), const Offset(0, -500));
    await tester.pump();

    expect(find.byKey(const ValueKey('schedule_time_08:00')), findsNothing);
    await tester.tap(addTime);
    await WidgetHarness.pumpFrames(tester);
    await tester.tap(find.byTooltip('Switch to text input mode'));
    await tester.pump();
    final timeFields = find.descendant(
      of: find.byType(TimePickerDialog),
      matching: find.byType(TextFormField),
    );
    expect(timeFields, findsNWidgets(2));
    await tester.enterText(timeFields.at(0), '9');
    await tester.enterText(timeFields.at(1), '00');
    await tester.tap(find.text('OK'));
    await WidgetHarness.pumpFrames(tester);

    expect(find.byKey(const ValueKey('schedule_time_08:00')), findsNothing);
    expect(find.byKey(const ValueKey('schedule_time_09:00')), findsOneWidget);
    expect(find.text('9:00 AM'), findsOneWidget);

    await tester.tap(find.byTooltip('Remove 9:00 AM'));
    await tester.pump();
    expect(find.byKey(const ValueKey('schedule_time_09:00')), findsNothing);
    expect(find.text('Add time'), findsOneWidget);
  });

  testWidgets('optional medication details remain usable with large text on a narrow screen', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(430, 1000);
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(() {
      tester.view.reset();
      tester.platformDispatcher.clearTextScaleFactorTestValue();
    });
    final harness = await WidgetHarness.create(snapshot: fixtureSnapshot());
    addTearDown(() => harness.close(tester));
    await harness.pumpApp(tester);

    harness.container.read(routerProvider).push<void>('/medication/med-1/edit/animal-1');
    await WidgetHarness.pumpFrames(tester);
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('medication_next_refill_date')),
      240,
      scrollable: find
          .descendant(of: find.byType(ListView), matching: find.byType(Scrollable))
          .first,
    );
    await tester.pump();

    expect(find.byKey(const ValueKey('medication_refills_remaining')), findsOneWidget);
    expect(find.byKey(const ValueKey('medication_next_refill_date')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('creating a backup opens the document saver with a valid open archive', (
    tester,
  ) async {
    final json = fixtureSnapshot().toJson();
    json['documents'] = <Object?>[];
    final saver = _CapturingDocumentSaver();
    final harness = await WidgetHarness.create(
      snapshot: CreaturelySnapshot.fromJson(json),
      documentSaver: saver,
    );
    addTearDown(() => harness.close(tester));
    await harness.pumpApp(tester);
    harness.container.read(routerProvider).go('/data');
    await WidgetHarness.pumpFrames(tester);

    await tester.tap(find.text('Create .creaturely backup'));
    await WidgetHarness.pumpFrames(tester, count: 30);

    expect(saver.calls, 1);
    expect(saver.fileName, startsWith('creaturely-'));
    expect(saver.fileName, endsWith('.creaturely'));
    expect(saver.allowedExtensions, const <String>['creaturely']);
    final validated = const CreaturelyBackupService().validate(saver.bytes!);
    expect(validated.snapshot.animals.single.name, 'Moss');
    expect(find.text('Creaturely backup saved.'), findsOneWidget);
  });

  testWidgets('pet exports can be saved or shared and restore remains deliberate', (tester) async {
    final source = fixtureSnapshot();
    final original = source.documents.single;
    final recentDocument = CareDocument(
      id: original.id,
      animalId: original.animalId,
      createdAt: original.createdAt,
      updatedAt: original.updatedAt,
      documentDate: DateTime.now().subtract(const Duration(days: 1)),
      title: original.title,
      category: original.category,
      storedPath: original.storedPath,
      mediaType: original.mediaType,
      checksumSha256: original.checksumSha256,
      byteLength: original.byteLength,
      notes: original.notes,
      expiryDate: original.expiryDate,
    );
    final snapshot = CreaturelySnapshot(
      schemaVersion: source.schemaVersion,
      exportedAt: source.exportedAt,
      animals: source.animals,
      identifiers: source.identifiers,
      respiratorySessions: source.respiratorySessions,
      respiratoryReminders: source.respiratoryReminders,
      weightReminders: source.weightReminders,
      medications: source.medications,
      medicationSchedules: source.medicationSchedules,
      doseLedger: source.doseLedger,
      healthRecords: source.healthRecords,
      documents: <CareDocument>[recentDocument],
      settings: source.settings,
    );
    final saver = _CapturingDocumentSaver();
    final harness = await WidgetHarness.create(snapshot: snapshot, documentSaver: saver);
    addTearDown(() => harness.close(tester));
    await harness.pumpApp(tester);
    harness.container.read(routerProvider).go('/data');
    await WidgetHarness.pumpFrames(tester);

    expect(find.text('Pet export'), findsOneWidget);
    expect(find.text('Vet-friendly export'), findsNothing);
    final openExport = find.byKey(const ValueKey('open_pet_export'));
    await tester.ensureVisible(openExport);
    await tester.pump();
    expect(openExport, findsOneWidget);
    expect(find.byKey(const ValueKey('save_export_pdf')), findsNothing);
    await tester.tap(openExport);
    await WidgetHarness.pumpFrames(tester);
    expect(find.text('Choose export format'), findsOneWidget);
    expect(find.byKey(const ValueKey('export_format_pdf')), findsOneWidget);
    expect(find.byKey(const ValueKey('export_format_csv')), findsOneWidget);
    expect(find.byKey(const ValueKey('export_format_zip')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('export_format_csv')));
    await tester.pump();
    expect(find.text('CSV data'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('save_selected_export')));
    await WidgetHarness.pumpFrames(tester, count: 40);
    expect(saver.calls, 1);
    expect(saver.fileName, endsWith('.csv'));
    expect(saver.allowedExtensions, const <String>['csv']);
    expect(utf8.decode(saver.bytes!), startsWith('record_type,timestamp_utc_or_date'));
    expect(find.text('CSV export saved.'), findsOneWidget);

    final documentChoice = find.widgetWithText(CheckboxListTile, 'Rabies certificate');
    expect(documentChoice, findsOneWidget);
    await tester.ensureVisible(documentChoice);
    await tester.pump();
    await tester.tap(documentChoice);
    await tester.pump();
    expect(tester.widget<CheckboxListTile>(documentChoice).value, isTrue);

    final bytes = const CreaturelyBackupService().create(
      snapshot: fixtureSnapshot(),
      attachments: <String, Uint8List>{fixtureChecksum: fixtureAttachment},
    );
    final validated = const CreaturelyBackupService().validate(bytes);
    bool? dialogResult;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: FilledButton(
              onPressed: () async {
                dialogResult = await showDialog<bool>(
                  context: context,
                  builder: (context) => RestoreConfirmationDialog(validated: validated),
                );
              },
              child: const Text('Open confirmation'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open confirmation'));
    await WidgetHarness.pumpFrames(tester);
    expect(find.text('Replace this local journal?'), findsOneWidget);
    expect(find.textContaining('Nothing is partially imported'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('confirm_restore')));
    await WidgetHarness.pumpFrames(tester);
    expect(dialogResult, isTrue);
  });

  testWidgets('light/dark themes, text scaling, and accessible contrast remain usable', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(430, 1000);
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(() {
      tester.view.reset();
      tester.platformDispatcher.clearTextScaleFactorTestValue();
    });
    final harness = await WidgetHarness.create(snapshot: fixtureSnapshot());
    addTearDown(() => harness.close(tester));
    await harness.pumpApp(tester);
    expect(tester.takeException(), isNull);

    final notifier = harness.container.read(appControllerProvider.notifier);
    final current = harness.container.read(appControllerProvider).snapshot.settings;
    await notifier.saveSettings(current.copyWith(theme: AppThemePreference.dark));
    await WidgetHarness.pumpFrames(tester);
    expect(tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode, ThemeMode.dark);
    expect(tester.takeException(), isNull);

    for (final theme in <ThemeData>[CreaturelyTheme.light, CreaturelyTheme.dark]) {
      final scheme = theme.colorScheme;
      expect(_contrast(scheme.primary, scheme.onPrimary), greaterThanOrEqualTo(4.5));
      expect(_contrast(scheme.surface, scheme.onSurface), greaterThanOrEqualTo(4.5));
    }
  });

  testWidgets('opening and saving weight forms preserves exact canonical kilograms', (
    tester,
  ) async {
    const preciseAnimalKilograms = 1.23456789;
    const preciseRecordKilograms = 2.34567891;
    final source = fixtureSnapshot();
    final precise = CreaturelySnapshot(
      schemaVersion: source.schemaVersion,
      exportedAt: source.exportedAt,
      animals: <Animal>[source.animals.single.copyWith(currentWeightKg: preciseAnimalKilograms)],
      identifiers: source.identifiers,
      respiratorySessions: source.respiratorySessions,
      respiratoryReminders: source.respiratoryReminders,
      weightReminders: source.weightReminders,
      medications: source.medications,
      medicationSchedules: source.medicationSchedules,
      doseLedger: source.doseLedger,
      healthRecords: <HealthRecord>[
        HealthRecord.fromJson(<String, Object?>{
          ...source.healthRecords.single.toJson(),
          'canonicalValue': preciseRecordKilograms,
        }),
      ],
      documents: source.documents,
      settings: source.settings,
    );
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(700, 1000);
    addTearDown(tester.view.reset);
    final harness = await WidgetHarness.create(snapshot: precise);
    addTearDown(() => harness.close(tester));
    await harness.pumpApp(tester);

    harness.container.read(routerProvider).push<void>('/animal/animal-1/edit');
    await WidgetHarness.pumpFrames(tester);
    expect(find.byKey(const ValueKey('animal_weight')), findsOneWidget);
    final saveAnimal = find.byKey(const ValueKey('save_animal'));
    await tester.ensureVisible(saveAnimal);
    await tester.pump();
    await tester.tap(saveAnimal);
    await WidgetHarness.pumpFrames(tester);
    var saved = await harness.database.snapshot();
    expect(saved.animals.single.currentWeightKg, preciseAnimalKilograms);

    harness.container.read(routerProvider).push<void>('/health/weight-1/edit/animal-1');
    await WidgetHarness.pumpFrames(tester);
    expect(find.textContaining('stored canonically'), findsNothing);
    final saveHealth = find.byKey(const ValueKey('save_health_record'));
    await tester.ensureVisible(saveHealth);
    await tester.pump();
    await tester.tap(saveHealth);
    await WidgetHarness.pumpFrames(tester);

    saved = await harness.database.snapshot();
    expect(saved.healthRecords.single.canonicalValue, preciseRecordKilograms);
    expect(saved.animals.single.currentWeightKg, preciseRecordKilograms);
  });
}

class _CapturingDocumentSaver implements DocumentSaveService {
  int calls = 0;
  String? fileName;
  Uint8List? bytes;
  List<String>? allowedExtensions;

  @override
  Future<Uri?> save({
    required String fileName,
    required String dialogTitle,
    required Uint8List bytes,
    required List<String> allowedExtensions,
  }) async {
    calls++;
    this.fileName = fileName;
    this.bytes = bytes;
    this.allowedExtensions = allowedExtensions;
    return Uri.file('/chosen/$fileName');
  }
}

double _contrast(Color first, Color second) {
  final bright = first.computeLuminance() > second.computeLuminance() ? first : second;
  final dark = identical(bright, first) ? second : first;
  return (bright.computeLuminance() + 0.05) / (dark.computeLuminance() + 0.05);
}
