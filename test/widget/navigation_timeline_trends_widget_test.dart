import 'package:creaturely/domain/models.dart';
import 'package:creaturely/ui/navigation/app_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import '../support/fixtures.dart';
import '../support/widget_harness.dart';

void main() {
  testWidgets('responsive navigation, unified filters, document failure, and chart/table parity', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1000, 900);
    addTearDown(tester.view.reset);
    final harness = await WidgetHarness.create(snapshot: fixtureSnapshot());
    addTearDown(() => harness.close(tester));
    await harness.pumpApp(tester);

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(
      tester
          .widget<NavigationRail>(find.byType(NavigationRail))
          .destinations
          .map((destination) => (destination.label as Text).data),
      <String>['Animals', 'Trends', 'Timeline', 'Schedule'],
    );
    final semantics = tester.ensureSemantics();
    expect(find.bySemanticsLabel('Moss dashboard'), findsOneWidget);

    harness.container.read(routerProvider).go('/timeline');
    await WidgetHarness.pumpFrames(tester);
    expect(find.text('Moss’s timeline'), findsOneWidget);
    expect(find.text('Resting breathing'), findsOneWidget);
    expect(find.text('Rabies certificate'), findsOneWidget);
    expect(find.text('Quiet after lights out.'), findsOneWidget);
    expect(find.text('0.26 lb'), findsOneWidget);

    await tester.tap(find.text('Resting breathing'));
    await WidgetHarness.pumpFrames(tester);
    expect(find.text('Breathing session'), findsOneWidget);
    expect(find.text('10 breaths in 30.0 seconds'), findsOneWidget);
    expect(find.text('Quiet after lights out.'), findsWidgets);
    await tester.binding.handlePopRoute();
    await WidgetHarness.pumpFrames(tester);

    await tester.tap(find.text('Documents'));
    await WidgetHarness.pumpFrames(tester);
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
    await tester.pump();
    expect(find.text('Rabies certificate'), findsOneWidget);
    expect(find.text('Resting breathing'), findsNothing);
    expect(find.text('Stored file missing'), findsOneWidget);

    harness.container.read(routerProvider).go('/trends');
    await WidgetHarness.pumpFrames(tester);
    await tester.tap(find.text('All'));
    await WidgetHarness.pumpFrames(tester);
    expect(
      find.bySemanticsLabel(RegExp(r'1 measurements\. Latest 20 breaths/min')),
      findsOneWidget,
    );
    expect(find.text('20'), findsNWidgets(2));
    expect(find.text('20.0'), findsOneWidget);
    expect(find.text('Average'), findsOneWidget);
    expect(find.text('breaths/min • 1 entry'), findsOneWidget);

    await tester.tap(find.byTooltip('Show accessible data table'));
    await WidgetHarness.pumpFrames(tester);
    expect(find.bySemanticsLabel('Accessible measurement table with 1 rows'), findsOneWidget);
    expect(find.text('20 breaths/min'), findsOneWidget);
    expect(find.text('10.0 breaths in 30000 ms'), findsOneWidget);

    tester.view.physicalSize = const Size(430, 900);
    await WidgetHarness.pumpFrames(tester);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });

  testWidgets('an archived-only journal remains reachable and can be reopened', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(430, 1000);
    addTearDown(tester.view.reset);
    final json = fixtureSnapshot().toJson();
    final animals = (json['animals']! as List<Object?>).cast<Map<String, Object?>>();
    animals[0] = <String, Object?>{...animals.single, 'archived': true};
    final harness = await WidgetHarness.create(snapshot: CreaturelySnapshot.fromJson(json));
    addTearDown(() => harness.close(tester));
    await harness.pumpApp(tester);

    expect(find.text('No active animals'), findsOneWidget);
    expect(find.text('Archived journals'), findsOneWidget);
    await tester.tap(find.widgetWithText(ListTile, 'Moss'));
    await WidgetHarness.pumpFrames(tester);
    expect(find.text('Edit Moss'), findsOneWidget);

    final archiveToggle = find.widgetWithText(SwitchListTile, 'Archive animal');
    await tester.dragUntilVisible(archiveToggle, find.byType(ListView), const Offset(0, -500));
    await tester.pump();
    expect(tester.widget<SwitchListTile>(archiveToggle).value, isTrue);
    await tester.tap(archiveToggle);
    await tester.dragUntilVisible(
      find.byKey(const ValueKey('save_animal')),
      find.byType(ListView),
      const Offset(0, -500),
    );
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('save_animal')));
    await WidgetHarness.pumpFrames(tester, count: 24);

    expect(find.bySemanticsLabel('Moss dashboard'), findsOneWidget);
  });

  testWidgets('short landscape viewports use compact headers and scroll timeline chrome', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1000, 430);
    addTearDown(tester.view.reset);
    final now = DateTime.now().toUtc();
    final json = fixtureSnapshot().toJson();
    json['respiratorySessions'] = <Object?>[
      _session('breathing-landscape', now.subtract(const Duration(hours: 1)), 30).toJson(),
    ];
    final harness = await WidgetHarness.create(snapshot: CreaturelySnapshot.fromJson(json));
    addTearDown(() => harness.close(tester));
    await harness.pumpApp(tester);

    harness.container.read(routerProvider).go('/trends');
    await WidgetHarness.pumpFrames(tester);
    var appBar = tester.widget<AppBar>(find.byType(AppBar));
    expect(appBar.toolbarHeight, 48);
    expect(tester.widgetList<Tab>(find.byType(Tab)).map((tab) => tab.height), everyElement(42));
    expect(tester.getCenter(find.text('7D')).dy, lessThan(130));
    expect(tester.takeException(), isNull);

    harness.container.read(routerProvider).go('/timeline');
    await WidgetHarness.pumpFrames(tester);
    appBar = tester.widget<AppBar>(find.byType(AppBar));
    expect(appBar.toolbarHeight, 48);
    final timelineList = find.byKey(const PageStorageKey<String>('timeline_list'));
    expect(
      find.descendant(of: timelineList, matching: find.text('Moss’s timeline')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('trend summary stays compact and averages the selected breathing and weight data', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(430, 1000);
    addTearDown(tester.view.reset);
    final now = DateTime.now().toUtc();
    final json = fixtureSnapshot().toJson();
    json['respiratorySessions'] = <Object?>[
      _session('breathing-a', now.subtract(const Duration(hours: 3)), 34).toJson(),
      _session('breathing-b', now.subtract(const Duration(hours: 2)), 24).toJson(),
      _session('breathing-c', now.subtract(const Duration(hours: 1)), 30).toJson(),
    ];
    json['healthRecords'] = <Object?>[
      _weight('weight-a', now.subtract(const Duration(hours: 3)), 1).toJson(),
      _weight('weight-b', now.subtract(const Duration(hours: 2)), 2).toJson(),
      _weight('weight-c', now.subtract(const Duration(hours: 1)), 3).toJson(),
    ];
    json['doseLedger'] = <Object?>[
      _doseWithStatus(
        'given-dose',
        now.subtract(const Duration(hours: 3)),
        DoseStatus.given,
      ).toJson(),
      _doseWithStatus(
        'skipped-dose',
        now.subtract(const Duration(hours: 2)),
        DoseStatus.skipped,
      ).toJson(),
      _doseWithStatus(
        'missed-dose',
        now.subtract(const Duration(hours: 1)),
        DoseStatus.missed,
      ).toJson(),
    ];
    final harness = await WidgetHarness.create(snapshot: CreaturelySnapshot.fromJson(json));
    addTearDown(() => harness.close(tester));
    await harness.pumpApp(tester);

    harness.container.read(routerProvider).go('/trends');
    await WidgetHarness.pumpFrames(tester);

    expect(find.text('30'), findsWidgets);
    expect(find.text('30.0'), findsNothing);
    expect(find.text('24–34'), findsOneWidget);
    expect(find.text('29.3'), findsOneWidget);
    expect(find.text('breaths/min • 3 entries'), findsOneWidget);
    expect(find.textContaining('latest, average, and observed range'), findsOneWidget);
    final latestTop = tester.getTopLeft(find.text('Latest')).dy;
    expect(tester.getTopLeft(find.text('Average')).dy, closeTo(latestTop, 1));
    expect(tester.getTopLeft(find.text('Observed range')).dy, closeTo(latestTop, 1));
    final tooltip = tester
        .widget<LineChart>(find.byType(LineChart))
        .data
        .lineTouchData
        .touchTooltipData;
    expect(tooltip.fitInsideHorizontally, isTrue);
    expect(tooltip.fitInsideVertically, isTrue);
    expect(tooltip.maxContentWidth, lessThanOrEqualTo(170));
    final chartData = tester.widget<LineChart>(find.byType(LineChart)).data;
    expect(chartData.minY, 5);
    expect(chartData.maxY, 35);
    expect(chartData.titlesData.leftTitles.sideTitles.interval, 5);
    expect(chartData.titlesData.bottomTitles.sideTitles.interval, 1);
    expect(chartData.borderData.show, isTrue);
    expect(chartData.borderData.border.top.style, BorderStyle.solid);
    expect(chartData.borderData.border.bottom.style, BorderStyle.solid);
    expect(chartData.borderData.border.left.style, BorderStyle.none);
    expect(chartData.borderData.border.right.style, BorderStyle.none);
    expect(find.textContaining('given, 0 skipped'), findsNothing);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Weight'));
    await WidgetHarness.pumpFrames(tester);
    expect(find.text('Average'), findsOneWidget);
    expect(find.text('4.4'), findsOneWidget);
    expect(find.text('lb • 3 entries'), findsOneWidget);
    expect(find.text('From first'), findsNothing);

    await tester.ensureVisible(find.text('Medication'));
    await tester.tap(find.text('Medication'));
    await WidgetHarness.pumpFrames(tester);
    expect(find.text('Given'), findsOneWidget);
    expect(find.text('Skipped'), findsOneWidget);
    expect(find.text('Missed'), findsOneWidget);
    expect(find.text('Unrecorded'), findsOneWidget);
    expect(find.text('1 given • 1 skipped • 1 missed'), findsOneWidget);
    expect(find.text('By medication'), findsOneWidget);
    expect(find.text('Supportive care'), findsOneWidget);
    expect(find.byTooltip('Show accessible data table'), findsNothing);
  });

  testWidgets('future medication repetitions live in the bounded Schedule view', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(430, 1000);
    addTearDown(tester.view.reset);
    final now = DateTime.now().toUtc();
    final next = now.add(const Duration(hours: 1));
    final thisWeek = now.add(const Duration(days: 2));
    final far = now.add(const Duration(days: 80));
    final json = fixtureSnapshot().toJson();
    json['doseLedger'] = <Object?>[
      _dose('next-dose', next).toJson(),
      _dose('week-dose', thisWeek).toJson(),
      _dose('far-dose', far).toJson(),
    ];
    final harness = await WidgetHarness.create(snapshot: CreaturelySnapshot.fromJson(json));
    addTearDown(() => harness.close(tester));
    await harness.pumpApp(tester);

    harness.container.read(routerProvider).go('/timeline');
    await WidgetHarness.pumpFrames(tester);

    expect(find.byKey(const ValueKey('upcoming_medication_card')), findsNothing);
    expect(find.text(DateFormat.jm().format(next.toLocal())), findsNothing);

    harness.container.read(routerProvider).go('/schedule');
    await WidgetHarness.pumpFrames(tester);
    await tester.tap(find.text('7 days'));
    await WidgetHarness.pumpFrames(tester);

    await tester.scrollUntilVisible(find.text('Supportive care'), 240);
    expect(find.text('Supportive care'), findsOneWidget);
    final secondDay = DateFormat.EEEE().add_MMMd().format(thisWeek.toLocal());
    await tester.scrollUntilVisible(find.text(secondDay), 300);
    expect(find.text(secondDay), findsOneWidget);
    expect(find.text('Supportive care'), findsOneWidget);
    expect(find.text(DateFormat.EEEE().add_MMMd().format(far.toLocal())), findsNothing);
  });

  testWidgets('timeline lazily builds a long local journal as it is scrolled', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(430, 900);
    addTearDown(tester.view.reset);
    final now = DateTime.now().toUtc();
    final json = fixtureSnapshot().toJson();
    json['respiratorySessions'] = <Object?>[];
    json['medications'] = <Object?>[];
    json['medicationSchedules'] = <Object?>[];
    json['doseLedger'] = <Object?>[];
    json['documents'] = <Object?>[];
    json['healthRecords'] = <Object?>[
      for (var index = 0; index < 80; index++)
        HealthRecord(
          id: 'observation-$index',
          animalId: 'animal-1',
          createdAt: now.subtract(Duration(minutes: index)),
          updatedAt: now.subtract(Duration(minutes: index)),
          occurredAt: now.subtract(Duration(minutes: index)),
          kind: HealthRecordKind.observation,
          title: 'Observation $index',
          note: 'Journal detail $index',
        ).toJson(),
    ];
    final harness = await WidgetHarness.create(snapshot: CreaturelySnapshot.fromJson(json));
    addTearDown(() => harness.close(tester));
    await harness.pumpApp(tester);
    harness.container.read(routerProvider).go('/timeline');
    await WidgetHarness.pumpFrames(tester);

    const lastItemKey = ValueKey<String>('timeline_observation_observation-79');
    final timelineList = find.byKey(const PageStorageKey<String>('timeline_list'));
    final verticalScrollable = find.byWidgetPredicate(
      (widget) => widget is Scrollable && widget.axisDirection == AxisDirection.down,
    );
    final timelineScrollable = find.descendant(of: timelineList, matching: verticalScrollable);
    expect(timelineList, findsOneWidget);
    expect(timelineScrollable, findsOneWidget);
    expect(find.byKey(lastItemKey), findsNothing);

    await tester.scrollUntilVisible(
      find.byKey(lastItemKey),
      700,
      scrollable: timelineScrollable,
      maxScrolls: 40,
    );
    await tester.pump();

    expect(find.byKey(lastItemKey), findsOneWidget);
    expect(find.text('Observation 79'), findsOneWidget);
    final offsetBeforeSwitch = tester.state<ScrollableState>(timelineScrollable).position.pixels;
    expect(offsetBeforeSwitch, greaterThan(0));

    await tester.tap(find.text('Trends'));
    await WidgetHarness.pumpFrames(tester);
    await tester.tap(find.text('Timeline'));
    await WidgetHarness.pumpFrames(tester);
    final restoredScrollable = find.descendant(
      of: find.byKey(const PageStorageKey<String>('timeline_list')),
      matching: verticalScrollable,
    );
    expect(
      tester.state<ScrollableState>(restoredScrollable).position.pixels,
      closeTo(offsetBeforeSwitch, 1),
    );

    await tester.tap(find.text('Timeline'));
    await WidgetHarness.pumpFrames(tester);
    expect(tester.state<ScrollableState>(restoredScrollable).position.pixels, closeTo(0, 1));
    expect(find.text('Moss’s timeline'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

RespiratorySession _session(String id, DateTime at, double rate) => RespiratorySession(
  id: id,
  animalId: 'animal-1',
  createdAt: at,
  updatedAt: at,
  recordedAt: at,
  durationMilliseconds: 60000,
  breathCount: rate.round(),
  ratePerMinute: rate,
  context: RespiratoryContext.resting,
  thresholdSnapshot: const RespiratoryThresholds(minimum: 8, target: 16, maximum: 28),
);

HealthRecord _weight(String id, DateTime at, double kilograms) => HealthRecord(
  id: id,
  animalId: 'animal-1',
  createdAt: at,
  updatedAt: at,
  occurredAt: at,
  kind: HealthRecordKind.weight,
  title: 'Weigh-in',
  canonicalValue: kilograms,
  canonicalUnit: 'kg',
  enteredUnit: 'kg',
);

DoseLedgerEntry _dose(String id, DateTime dueAt) => DoseLedgerEntry(
  id: id,
  medicationId: 'med-1',
  scheduleId: 'schedule-1',
  animalId: 'animal-1',
  createdAt: dueAt.subtract(const Duration(days: 1)),
  updatedAt: dueAt.subtract(const Duration(days: 1)),
  dueAt: dueAt,
  intendedLocalTime: dueAt.toIso8601String(),
  timeZoneId: 'UTC',
  status: DoseStatus.unrecorded,
);

DoseLedgerEntry _doseWithStatus(String id, DateTime dueAt, DoseStatus status) => DoseLedgerEntry(
  id: id,
  medicationId: 'med-1',
  scheduleId: 'schedule-1',
  animalId: 'animal-1',
  createdAt: dueAt.subtract(const Duration(days: 1)),
  updatedAt: dueAt,
  dueAt: dueAt,
  intendedLocalTime: dueAt.toIso8601String(),
  timeZoneId: 'UTC',
  status: status,
  administeredAt: status == DoseStatus.given ? dueAt : null,
);
