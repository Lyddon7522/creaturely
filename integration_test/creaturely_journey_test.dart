import 'package:creaturely/domain/models.dart';
import 'package:creaturely/main.dart' as creaturely;
import 'package:creaturely/platform/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/support/widget_harness.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('real application bootstrap reaches a usable local screen', (tester) async {
    creaturely.main();
    for (var index = 0; index < 80; index++) {
      await tester.pump(const Duration(milliseconds: 50));
      final onboardingReady = find.text('Know their normal.').evaluate().isNotEmpty;
      final journalReady =
          find.byType(NavigationBar).evaluate().isNotEmpty ||
          find.byType(NavigationRail).evaluate().isNotEmpty;
      if (onboardingReady || journalReady) {
        break;
      }
    }

    expect(
      find.text('Know their normal.').evaluate().isNotEmpty ||
          find.byType(NavigationBar).evaluate().isNotEmpty ||
          find.byType(NavigationRail).evaluate().isNotEmpty,
      isTrue,
      reason: 'The native launch view must never remain indefinitely.',
    );
  });

  testWidgets('keeper can decline reminders, add a custom species, and reach all core areas', (
    tester,
  ) async {
    final harness = await WidgetHarness.create(
      snapshot: CreaturelySnapshot.empty(),
      permission: NotificationPermissionState.denied,
    );
    addTearDown(() => harness.close(tester));
    await harness.pumpApp(tester);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    final notificationRequest = find.byKey(const ValueKey('request_notifications'));
    await tester.ensureVisible(notificationRequest);
    await tester.pumpAndSettle();
    await tester.tap(notificationRequest);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('onboarding_animal_name')), 'Juniper');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    final species = find.byKey(const ValueKey('onboarding_species'));
    await tester.ensureVisible(species);
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(of: species, matching: find.byType(DropdownButton<String>)));
    await tester.pumpAndSettle();
    final otherSpecies = find.text('Other');
    if (otherSpecies.evaluate().isEmpty) {
      await tester.scrollUntilVisible(otherSpecies, 180, scrollable: find.byType(Scrollable).last);
    }
    await tester.tap(otherSpecies.last);
    await tester.pumpAndSettle();
    final customSpecies = find.byKey(const ValueKey('onboarding_custom_species'));
    await tester.ensureVisible(customSpecies);
    await tester.pumpAndSettle();
    await tester.enterText(customSpecies, 'Gecko');
    final animalStep = find.byKey(const ValueKey('onboarding_animal_step'));
    final animalStepScrollable = find.descendant(
      of: animalStep,
      matching: find.byWidgetPredicate(
        (widget) => widget is Scrollable && widget.axisDirection == AxisDirection.down,
      ),
    );
    expect(animalStepScrollable, findsOneWidget);
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    final disclaimer = find.byKey(const ValueKey('accept_disclaimer'));
    await tester.scrollUntilVisible(
      disclaimer.hitTestable(),
      180,
      scrollable: animalStepScrollable,
    );
    await tester.pumpAndSettle();
    await tester.tap(disclaimer.hitTestable());
    await tester.pump();
    expect(
      tester.widget<CheckboxListTile>(find.byKey(const ValueKey('accept_disclaimer'))).value,
      isTrue,
    );
    final finishOnboarding = find.byKey(const ValueKey('finish_onboarding'));
    await tester.ensureVisible(finishOnboarding);
    await tester.pumpAndSettle();
    await tester.tap(finishOnboarding.hitTestable());
    await WidgetHarness.pumpFrames(tester, count: 20);

    expect(find.text('Juniper'), findsWidgets);
    for (final destination in <String>['Trends', 'Timeline', 'Schedule', 'Animals']) {
      await tester.tap(find.text(destination).last);
      await WidgetHarness.pumpFrames(tester);
      expect(find.text(destination), findsWidgets);
    }
    await tester.tap(find.byTooltip('Settings'));
    await WidgetHarness.pumpFrames(tester);
    expect(find.text('Settings'), findsWidgets);
    await tester.pageBack();
    await WidgetHarness.pumpFrames(tester);
    expect(find.text('Animals'), findsWidgets);
  });
}
