import 'package:creaturely/ui/app_controller.dart';
import 'package:creaturely/ui/navigation/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fixtures.dart';
import '../support/widget_harness.dart';

void main() {
  testWidgets('generic identifiers expose custom type, service contacts, and issued date', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(520, 1000);
    addTearDown(tester.view.reset);
    final harness = await WidgetHarness.create(snapshot: fixtureSnapshot());
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

    expect(find.text('Edit identifier'), findsOneWidget);
    expect(find.text('Aug 1, 2025'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('identifier_type')));
    await WidgetHarness.pumpFrames(tester);
    await tester.tap(find.text('Other').last);
    await WidgetHarness.pumpFrames(tester);
    await tester.enterText(find.byKey(const ValueKey('identifier_custom_type')), 'Shell mark');
    await tester.enterText(
      find.byKey(const ValueKey('identifier_url')),
      'https://registry.example.invalid/moss',
    );
    await tester.enterText(find.byKey(const ValueKey('identifier_phone')), '+1 555 010 0099');
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await WidgetHarness.pumpFrames(tester);

    final saved = await harness.database.snapshot();
    final identifier = saved.identifiers.single;
    expect(identifier.id, 'identifier-1');
    expect(identifier.type, 'Shell mark');
    expect(identifier.url, 'https://registry.example.invalid/moss');
    expect(identifier.phone, '+1 555 010 0099');
    expect(identifier.issuedOn, DateTime.utc(2025, 8, 1));
    expect(
      harness.container.read(appControllerProvider).snapshot.identifiers.single.type,
      'Shell mark',
    );
  });
}
