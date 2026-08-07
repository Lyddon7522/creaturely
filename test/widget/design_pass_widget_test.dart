import 'package:creaturely/domain/models.dart';
import 'package:creaturely/ui/app_controller.dart';
import 'package:creaturely/ui/navigation/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../support/fixtures.dart';
import '../support/widget_harness.dart';

void main() {
  testWidgets('animal home prioritizes today and routes shortcuts to management views', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(430, 1000);
    addTearDown(tester.view.reset);
    final harness = await WidgetHarness.create(snapshot: fixtureSnapshot());
    addTearDown(() => harness.close(tester));
    await harness.pumpApp(tester);

    expect(find.text('Today at a glance'), findsOneWidget);
    expect(find.text('Latest breathing'), findsOneWidget);
    expect(find.text('Current weight'), findsOneWidget);
    final animalsHome = find.byKey(const PageStorageKey<String>('animals_home'));
    await tester.drag(animalsHome, const Offset(0, -500));
    await WidgetHarness.pumpFrames(tester);
    expect(find.text('Review doses'), findsOneWidget);
    expect(find.text('View files'), findsOneWidget);

    final medications = find.bySemanticsLabel('Medications for Moss. Review doses.');
    expect(tester.getCenter(medications).dy, lessThan(950));
    await tester.tap(medications);
    await WidgetHarness.pumpFrames(tester);
    expect(find.text('Moss’s schedule'), findsOneWidget);
    expect(find.text('Today'), findsWidgets);

    harness.container.read(routerProvider).go('/animals');
    await WidgetHarness.pumpFrames(tester);
    final documents = find.bySemanticsLabel('Documents for Moss. View files.');
    expect(tester.getCenter(documents).dy, lessThan(950));
    await tester.tap(documents);
    await WidgetHarness.pumpFrames(tester);
    expect(find.text('Rabies certificate'), findsOneWidget);
    expect(find.text('Resting breathing'), findsNothing);
    expect(find.byTooltip('Add document'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('animal export opens a focused pet export without backup controls', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(430, 1000);
    addTearDown(tester.view.reset);
    final harness = await WidgetHarness.create(snapshot: fixtureSnapshot());
    addTearDown(() => harness.close(tester));
    await harness.pumpApp(tester);

    await tester.tap(find.byKey(const ValueKey('animal_export')));
    await WidgetHarness.pumpFrames(tester);

    expect(find.text('Pet export'), findsOneWidget);
    expect(find.text('Export Moss’s health history'), findsOneWidget);
    expect(find.text('Export options'), findsOneWidget);
    expect(find.text('Create .creaturely backup'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('animal home uses Font Awesome species icons and a compact pet switcher', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(430, 1000);
    addTearDown(tester.view.reset);
    final json = fixtureSnapshot().toJson();
    json['animals'] = <Object?>[
      fixtureAnimal(name: 'Penelope', species: 'Dog').toJson(),
      fixtureAnimal(id: 'animal-2', name: 'Chloe', species: 'Cat').toJson(),
    ];
    final harness = await WidgetHarness.create(snapshot: CreaturelySnapshot.fromJson(json));
    addTearDown(() => harness.close(tester));
    await harness.pumpApp(tester);

    final dogIcons = find.byKey(const ValueKey('animal_avatar_icon_animal-1'));
    expect(dogIcons, findsWidgets);
    expect(tester.widget<FaIcon>(dogIcons.first).icon, FontAwesomeIcons.dog.data);
    final animalsHome = find.byKey(const PageStorageKey<String>('animals_home'));
    await tester.drag(animalsHome, const Offset(0, -1100));
    await WidgetHarness.pumpFrames(tester);

    expect(find.text('Other animals'), findsOneWidget);
    expect(find.byKey(const ValueKey('other_animal_animal-1')), findsNothing);
    expect(find.byKey(const ValueKey('other_animal_animal-2')), findsOneWidget);
    expect(find.byKey(const ValueKey('other_animal_add')), findsOneWidget);
    final catIcon = find.byKey(const ValueKey('animal_avatar_icon_animal-2'));
    expect(catIcon, findsOneWidget);
    expect(tester.widget<FaIcon>(catIcon).icon, FontAwesomeIcons.cat.data);

    await tester.tap(find.byKey(const ValueKey('other_animal_animal-2')));
    await WidgetHarness.pumpFrames(tester);
    expect(harness.container.read(appControllerProvider).selectedAnimal?.id, 'animal-2');
    expect(find.byKey(const ValueKey('animal_avatar_icon_animal-2')), findsWidgets);

    await tester.drag(animalsHome, const Offset(0, -1100));
    await WidgetHarness.pumpFrames(tester);
    expect(find.byKey(const ValueKey('other_animal_animal-1')), findsOneWidget);
    expect(find.byKey(const ValueKey('other_animal_animal-2')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('medication trend rows open details and support recording the next dose', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(430, 1000);
    addTearDown(tester.view.reset);
    final now = DateTime.now().toUtc();
    final json = fixtureSnapshot().toJson();
    json['medicationSchedules'] = <Object?>[];
    json['doseLedger'] = <Object?>[
      _dose('given', now.subtract(const Duration(days: 3)), DoseStatus.given).toJson(),
      _dose('skipped', now.subtract(const Duration(days: 2)), DoseStatus.skipped).toJson(),
      _dose('missed', now.subtract(const Duration(days: 1)), DoseStatus.missed).toJson(),
      _dose('next', now.add(const Duration(hours: 1)), DoseStatus.unrecorded).toJson(),
    ];
    final harness = await WidgetHarness.create(snapshot: CreaturelySnapshot.fromJson(json));
    addTearDown(() => harness.close(tester));
    await harness.pumpApp(tester);

    harness.container.read(routerProvider).go('/trends?tab=medication');
    await WidgetHarness.pumpFrames(tester);
    expect(find.text('Unrecorded'), findsNothing);
    expect(find.text('1 given • 1 skipped • 1 missed'), findsOneWidget);

    await tester.tap(find.text('Supportive care'));
    await WidgetHarness.pumpFrames(tester);
    expect(find.byKey(const ValueKey('medication_details')), findsOneWidget);
    expect(find.text('Directions'), findsOneWidget);
    expect(find.text('Give with food'), findsOneWidget);
    expect(find.byKey(const ValueKey('medication_next_dose')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('record_next_dose_given')));
    await WidgetHarness.pumpFrames(tester);
    final saved = harness.container.read(appControllerProvider).snapshot;
    expect(saved.doseLedger.singleWhere((value) => value.id == 'next').status, DoseStatus.given);
    expect(tester.takeException(), isNull);
  });
}

DoseLedgerEntry _dose(String id, DateTime dueAt, DoseStatus status) => DoseLedgerEntry(
  id: id,
  medicationId: 'med-1',
  animalId: 'animal-1',
  createdAt: dueAt,
  updatedAt: dueAt,
  dueAt: dueAt,
  intendedLocalTime: dueAt.toIso8601String(),
  timeZoneId: 'Etc/UTC',
  status: status,
  administeredAt: status == DoseStatus.given ? dueAt : null,
);
