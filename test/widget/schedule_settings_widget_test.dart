import 'package:creaturely/domain/models.dart';
import 'package:creaturely/platform/external_link_service.dart';
import 'package:creaturely/ui/app_controller.dart';
import 'package:creaturely/ui/navigation/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fixtures.dart';
import '../support/widget_harness.dart';

void main() {
  testWidgets('Schedule unifies care and reminder times are optional until chosen', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(430, 1000);
    addTearDown(tester.view.reset);
    final json = fixtureSnapshot().toJson();
    final settings = json['settings']! as Map<String, Object?>;
    settings['notificationsAllowed'] = false;
    settings['notificationPermissionAsked'] = true;
    final harness = await WidgetHarness.create(snapshot: CreaturelySnapshot.fromJson(json));
    addTearDown(() => harness.close(tester));
    await harness.pumpApp(tester);

    harness.container.read(routerProvider).go('/schedule');
    await WidgetHarness.pumpFrames(tester);
    expect(find.text('Moss’s schedule'), findsOneWidget);
    expect(find.byTooltip('Settings'), findsOneWidget);
    expect(find.text('Today'), findsWidgets);
    expect(find.text('7 days'), findsOneWidget);
    expect(find.text('Schedules'), findsOneWidget);

    await tester.tap(find.byTooltip('Record weight'));
    await WidgetHarness.pumpFrames(tester);
    expect(find.text('Add health record'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pageBack();
    await WidgetHarness.pumpFrames(tester);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Schedules'));
    await WidgetHarness.pumpFrames(tester);
    expect(find.text('Sleeping breathing check'), findsOneWidget);
    expect(find.text('Supportive care'), findsOneWidget);
    expect(find.text('Weight check'), findsOneWidget);
    expect(find.text('Rabies certificate'), findsNothing);

    harness.container.read(routerProvider).push('/breathing-reminder/new/animal-1');
    await WidgetHarness.pumpFrames(tester);
    expect(find.text('Add breathing reminder'), findsOneWidget);
    expect(find.textContaining('still appear in Schedule'), findsOneWidget);
    expect(find.byType(InputChip), findsNothing);

    await tester.tap(find.byKey(const ValueKey('add_rrr_time')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await WidgetHarness.pumpFrames(tester);
    expect(find.byType(InputChip), findsOneWidget);

    tester.widget<InputChip>(find.byType(InputChip)).onDeleted!();
    await WidgetHarness.pumpFrames(tester);
    expect(find.byType(InputChip), findsNothing);

    await tester.tap(find.byKey(const ValueKey('add_rrr_time')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await WidgetHarness.pumpFrames(tester);
    await tester.ensureVisible(find.byKey(const ValueKey('save_rrr_reminder')));
    await tester.tap(find.byKey(const ValueKey('save_rrr_reminder')));
    await WidgetHarness.pumpFrames(tester, count: 24);

    expect(
      harness.container.read(appControllerProvider).snapshot.respiratoryReminders,
      hasLength(2),
    );

    harness.container.read(routerProvider).push('/weight-reminder/new/animal-1');
    await WidgetHarness.pumpFrames(tester);
    expect(find.text('Add weight reminder'), findsOneWidget);
    expect(find.byType(InputChip), findsNothing);

    await tester.tap(find.byKey(const ValueKey('add_weight_time')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await WidgetHarness.pumpFrames(tester);
    expect(find.byType(InputChip), findsOneWidget);

    tester.widget<InputChip>(find.byType(InputChip)).onDeleted!();
    await WidgetHarness.pumpFrames(tester);
    expect(find.byType(InputChip), findsNothing);

    await tester.tap(find.byKey(const ValueKey('add_weight_time')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await WidgetHarness.pumpFrames(tester);
    final saveWeightReminder = find.byKey(const ValueKey('save_weight_reminder'));
    await tester.ensureVisible(saveWeightReminder);
    await tester.drag(find.byType(ListView).last, const Offset(0, -120));
    await tester.pumpAndSettle();
    await tester.tap(saveWeightReminder);
    await WidgetHarness.pumpFrames(tester, count: 24);

    expect(harness.container.read(appControllerProvider).snapshot.weightReminders, hasLength(2));
  });

  testWidgets('Settings opens GitHub bug reports without including journal data', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(430, 900);
    addTearDown(tester.view.reset);
    final links = _CapturingExternalLinks();
    final harness = await WidgetHarness.create(snapshot: fixtureSnapshot(), externalLinks: links);
    addTearDown(() => harness.close(tester));
    await harness.pumpApp(tester);

    harness.container.read(routerProvider).push('/settings');
    await WidgetHarness.pumpFrames(tester);
    await tester.scrollUntilVisible(find.text('Report a bug'), 500);
    await tester.tap(find.text('Report a bug'));
    await WidgetHarness.pumpFrames(tester);

    expect(links.opened, hasLength(1));
    expect(links.opened.single.host, 'github.com');
    expect(links.opened.single.path, '/Lyddon7522/Creaturely/issues/new');
    expect(links.opened.single.queryParameters['template'], 'bug_report.yml');
    expect(links.opened.single.toString(), isNot(contains('Moss')));
  });
}

class _CapturingExternalLinks implements ExternalLinkService {
  final List<Uri> opened = <Uri>[];

  @override
  Future<bool> open(Uri uri) async {
    opened.add(uri);
    return true;
  }
}
