import 'package:creaturely/ui/features/animals/animal_profile_fields.dart';
import 'package:creaturely/ui/navigation/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fixtures.dart';
import '../support/widget_harness.dart';

void main() {
  testWidgets('add animal uses species dropdown and accepts suggested or mixed breeds', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 1000);
    addTearDown(tester.view.reset);
    final harness = await WidgetHarness.create(snapshot: fixtureSnapshot());
    addTearDown(() => harness.close(tester));
    await harness.pumpApp(tester);

    harness.container.read(routerProvider).push<void>('/animal/new');
    await WidgetHarness.pumpFrames(tester);

    expect(
      tester.widget(find.byKey(const ValueKey('animal_species'))),
      isA<DropdownButtonFormField<String>>(),
    );
    await tester.enterText(find.byKey(const ValueKey('animal_name')), 'Juniper');
    await tester.enterText(find.byKey(const ValueKey('animal_breed')), 'Lab');
    await WidgetHarness.pumpFrames(tester);
    expect(find.text('Labrador Retriever'), findsOneWidget);
    await tester.tap(find.text('Labrador Retriever'));
    await WidgetHarness.pumpFrames(tester);
    await tester.enterText(
      find.byKey(const ValueKey('animal_breed')),
      'Labrador Retriever / Poodle',
    );

    await tester.dragUntilVisible(
      find.byKey(const ValueKey('animal_threshold_target')),
      find.byType(ListView),
      const Offset(0, -500),
    );
    await tester.pump();
    expect(find.textContaining('All values use breaths/min'), findsOneWidget);
    await tester.enterText(find.byKey(const ValueKey('animal_threshold_minimum')), '10');
    await tester.enterText(find.byKey(const ValueKey('animal_threshold_target')), '20');
    await tester.enterText(find.byKey(const ValueKey('animal_threshold_maximum')), '30');
    await tester.pump();
    expect(find.text('10'), findsOneWidget);
    expect(find.text('20'), findsOneWidget);
    expect(find.text('30'), findsOneWidget);

    tester.testTextInput.hide();
    await tester.pump();
    await tester.dragUntilVisible(
      find.byKey(const ValueKey('save_animal')),
      find.byType(ListView),
      const Offset(0, -600),
    );
    await tester.drag(find.byType(ListView), const Offset(0, -120));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('save_animal')));
    await WidgetHarness.pumpFrames(tester, count: 20);

    final saved = await harness.database.snapshot();
    final juniper = saved.animals.singleWhere((animal) => animal.name == 'Juniper');
    expect(juniper.species, 'Dog');
    expect(juniper.breed, 'Labrador Retriever / Poodle');
    expect(juniper.thresholds.minimum, 10);
    expect(juniper.thresholds.target, 20);
    expect(juniper.thresholds.maximum, 30);
  });

  testWidgets('breathing range explains which value conflicts with the other limits', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 1000);
    addTearDown(tester.view.reset);
    final formKey = GlobalKey<FormState>();
    final minimum = TextEditingController();
    final target = TextEditingController();
    final maximum = TextEditingController();
    addTearDown(() {
      minimum.dispose();
      target.dispose();
      maximum.dispose();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: RespiratoryThresholdFields(
                minimum: minimum,
                target: target,
                maximum: maximum,
                keyPrefix: 'validation',
              ),
            ),
          ),
        ),
      ),
    );

    await tester.enterText(find.byKey(const ValueKey('validation_threshold_minimum')), '40');
    await tester.enterText(find.byKey(const ValueKey('validation_threshold_target')), '20');
    await tester.enterText(find.byKey(const ValueKey('validation_threshold_maximum')), '30');
    expect(formKey.currentState!.validate(), isFalse);
    await tester.pump();

    expect(
      find.text("Minimum breathing rate can't be higher than target or maximum."),
      findsOneWidget,
    );
    expect(
      find.text("Target breathing rate can't be higher than maximum or lower than minimum."),
      findsOneWidget,
    );
    expect(
      find.text("Maximum breathing rate can't be lower than target or minimum."),
      findsOneWidget,
    );
    final minimumTop = tester.getTopLeft(
      find.byKey(const ValueKey('validation_threshold_minimum')),
    );
    final targetTop = tester.getTopLeft(find.byKey(const ValueKey('validation_threshold_target')));
    final maximumTop = tester.getTopLeft(
      find.byKey(const ValueKey('validation_threshold_maximum')),
    );
    expect(targetTop.dy, greaterThan(minimumTop.dy));
    expect(maximumTop.dy, greaterThan(targetTop.dy));
    expect(
      tester
          .widget<Text>(find.text("Minimum breathing rate can't be higher than target or maximum."))
          .maxLines,
      3,
    );
    expect(tester.takeException(), isNull);

    await tester.enterText(find.byKey(const ValueKey('validation_threshold_minimum')), '10');
    await tester.enterText(find.byKey(const ValueKey('validation_threshold_target')), '20');
    await tester.enterText(find.byKey(const ValueKey('validation_threshold_maximum')), '30');
    expect(formKey.currentState!.validate(), isTrue);
    await tester.pump();
    expect(find.textContaining("breathing rate can't"), findsNothing);
  });
}
