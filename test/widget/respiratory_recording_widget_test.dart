import 'package:creaturely/platform/feedback_service.dart';
import 'package:creaturely/ui/app_controller.dart';
import 'package:creaturely/ui/core/theme.dart';
import 'package:creaturely/ui/features/respiratory/respiratory_recording_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fixtures.dart';
import '../support/widget_harness.dart';

void main() {
  testWidgets('recorder gives clear tap/undo/cancel/interruption/completion feedback', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(700, 1100);
    addTearDown(tester.view.reset);
    final feedback = _CapturingFeedback();
    final harness = await WidgetHarness.create(snapshot: fixtureSnapshot(), feedback: feedback);
    addTearDown(() => harness.close(tester));
    await harness.container.read(appControllerProvider.notifier).initialize();
    var now = DateTime.utc(2026, 4, 1, 12);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: harness.container,
        child: MaterialApp(
          theme: CreaturelyTheme.light,
          home: RespiratoryRecordingScreen(animalId: 'animal-1', clock: () => now),
        ),
      ),
    );
    await tester.pump();
    expect(find.textContaining('does not use phone telemetry'), findsNothing);
    await tester.tap(find.byKey(const ValueKey('start_breathing_session')));
    await tester.pump();

    now = now.add(const Duration(seconds: 2));
    await tester.tap(find.byKey(const ValueKey('breath_tap_target')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 80));
    expect(tester.widget<Text>(find.byKey(const ValueKey('breath_count'))).data, '1');
    expect(find.byKey(const ValueKey('breath_pulse_active')), findsOneWidget);
    final pulseCenter = tester.getCenter(find.byKey(const ValueKey('breath_pulse_circle')));
    final buttonCenter = tester.getCenter(find.byKey(const ValueKey('breath_tap_target')));
    expect((pulseCenter - buttonCenter).distance, lessThan(1));
    expect(feedback.calls, 1);
    expect(feedback.lastHaptics, isTrue);
    expect(feedback.lastSound, isFalse);

    await tester.tap(find.byKey(const ValueKey('undo_breath')));
    await tester.pump();
    expect(tester.widget<Text>(find.byKey(const ValueKey('breath_count'))).data, '0');

    now = now.add(const Duration(seconds: 1));
    await tester.tap(find.byKey(const ValueKey('breath_tap_target')));
    now = now.add(const Duration(seconds: 1));
    await tester.tap(find.byKey(const ValueKey('breath_tap_target')));
    await tester.pump();
    await tester.tap(find.byTooltip('Cancel recording'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Discard this recording?'), findsOneWidget);
    await tester.tap(find.text('Keep recording'));
    await tester.pump(const Duration(milliseconds: 300));

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    expect(find.text('Paused after interruption'), findsOneWidget);
    await tester.tap(find.text('Resume'));
    await tester.pump();

    now = now.add(const Duration(seconds: 31));
    await tester.pump(const Duration(milliseconds: 120));
    expect(find.byKey(const ValueKey('calculated_rate')), findsOneWidget);
    expect(find.byKey(const ValueKey('breathing_threshold_alert')), findsOneWidget);
    expect(find.text('Below your minimum of 8 breaths/min'), findsOneWidget);
    expect(
      tester.widget<Text>(find.byKey(const ValueKey('breathing_threshold_message'))).style?.color,
      CreaturelyTheme.light.colorScheme.onErrorContainer,
    );
    expect(find.textContaining('Creaturely does not diagnose'), findsOneWidget);
    final semantics = tester.ensureSemantics();
    expect(find.bySemanticsLabel(RegExp('2 breaths')), findsWidgets);
    semantics.dispose();

    await tester.binding.handlePopRoute();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Discard this recording?'), findsOneWidget);
    await tester.tap(find.text('Keep recording'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byKey(const ValueKey('calculated_rate')), findsOneWidget);
  });

  testWidgets('recorder names the configured maximum when a result is above it', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(700, 1100);
    addTearDown(tester.view.reset);
    final harness = await WidgetHarness.create(snapshot: fixtureSnapshot());
    addTearDown(() => harness.close(tester));
    await harness.container.read(appControllerProvider.notifier).initialize();
    var now = DateTime.utc(2026, 4, 1, 12);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: harness.container,
        child: MaterialApp(
          theme: CreaturelyTheme.light,
          home: RespiratoryRecordingScreen(animalId: 'animal-1', clock: () => now),
        ),
      ),
    );
    await tester.tap(find.text('15 s'));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('start_breathing_session')));
    await tester.pump();

    now = now.add(const Duration(seconds: 1));
    for (var index = 0; index < 8; index++) {
      await tester.tap(find.byKey(const ValueKey('breath_tap_target')));
    }
    now = now.add(const Duration(seconds: 15));
    await tester.pump(const Duration(milliseconds: 120));

    expect(find.text('30 breaths/min'), findsOneWidget);
    expect(find.byKey(const ValueKey('breathing_threshold_alert')), findsOneWidget);
    expect(find.text('Above your maximum of 28 breaths/min'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class _CapturingFeedback implements RecordingFeedback {
  int calls = 0;
  bool? lastHaptics;
  bool? lastSound;

  @override
  Future<void> breath({required bool haptics, required bool sound}) async {
    calls++;
    lastHaptics = haptics;
    lastSound = sound;
  }
}
