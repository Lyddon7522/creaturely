import 'package:creaturely/domain/models.dart';
import 'package:creaturely/platform/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/widget_harness.dart';

void main() {
  testWidgets('onboarding remains useful after denied permission and creates any species', (
    tester,
  ) async {
    final harness = await WidgetHarness.create(
      snapshot: CreaturelySnapshot.empty(at: DateTime.utc(2026)),
      permission: NotificationPermissionState.denied,
    );
    addTearDown(() => harness.close(tester));
    await harness.pumpApp(tester);

    expect(find.text('Know their normal.'), findsOneWidget);
    expect(find.textContaining('No account, ads, analytics'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await WidgetHarness.pumpFrames(tester);
    expect(find.text('You decide where copies go.'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await WidgetHarness.pumpFrames(tester);

    await tester.tap(find.byKey(const ValueKey('request_notifications')));
    await WidgetHarness.pumpFrames(tester);
    expect(find.textContaining('Notifications are off'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await WidgetHarness.pumpFrames(tester);

    await tester.enterText(find.byKey(const ValueKey('onboarding_animal_name')), 'Ripple');
    await tester.tap(find.byKey(const ValueKey('onboarding_species')));
    await WidgetHarness.pumpFrames(tester);
    await tester.tap(find.text('Other').last);
    await WidgetHarness.pumpFrames(tester);
    await tester.enterText(find.byKey(const ValueKey('onboarding_custom_species')), 'Axolotl');
    await tester.enterText(
      find.byKey(const ValueKey('onboarding_breed')),
      'Wild type / leucistic mix',
    );
    await tester.ensureVisible(find.byKey(const ValueKey('onboarding_threshold_target')));
    await tester.pump();
    await tester.enterText(find.byKey(const ValueKey('onboarding_threshold_minimum')), '8');
    await tester.enterText(find.byKey(const ValueKey('onboarding_threshold_target')), '16');
    await tester.enterText(find.byKey(const ValueKey('onboarding_threshold_maximum')), '28');
    await tester.ensureVisible(find.byKey(const ValueKey('accept_disclaimer')));
    await tester.pump();
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -160));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('accept_disclaimer')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('finish_onboarding')));
    await WidgetHarness.pumpFrames(tester, count: 20);

    expect(find.text('Ripple'), findsWidgets);
    expect(find.textContaining('Axolotl'), findsWidgets);
    final saved = await harness.database.snapshot();
    expect(saved.settings.onboardingComplete, isTrue);
    expect(saved.animals.single.name, 'Ripple');
    expect(saved.animals.single.species, 'Axolotl');
    expect(saved.animals.single.breed, 'Wild type / leucistic mix');
    expect(saved.animals.single.thresholds.minimum, 8);
    expect(saved.animals.single.thresholds.target, 16);
    expect(saved.animals.single.thresholds.maximum, 28);
    expect(saved.settings.notificationsAllowed, isFalse);
  });

  testWidgets('onboarding navigation works when animations are disabled', (tester) async {
    addTearDown(tester.platformDispatcher.clearAllTestValues);
    tester.platformDispatcher.accessibilityFeaturesTestValue = const FakeAccessibilityFeatures(
      disableAnimations: true,
    );
    final harness = await WidgetHarness.create(snapshot: CreaturelySnapshot.empty());
    addTearDown(() => harness.close(tester));
    await harness.pumpApp(tester);

    await tester.tap(find.text('Continue'));
    await tester.pump();
    expect(find.text('You decide where copies go.'), findsOneWidget);

    await tester.tap(find.text('Back'));
    await tester.pump();
    expect(find.text('Know their normal.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
