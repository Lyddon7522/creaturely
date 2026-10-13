import 'dart:async';
import 'dart:convert';

import 'package:creaturely/domain/models.dart';
import 'package:creaturely/platform/notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as data;

import '../support/fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('dexterous.com/flutter/local_notifications');
  final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  late Map<int, Map<String, Object?>> pending;
  late List<String> calls;
  Object? launch;
  bool failSchedule = false;
  bool failInitialization = false;
  Completer<void>? scheduleGate;
  setUp(() {
    data.initializeTimeZones();
    AndroidFlutterLocalNotificationsPlugin.registerWith();
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    pending = {};
    calls = [];
    launch = null;
    failSchedule = false;
    failInitialization = false;
    scheduleGate = null;
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call.method);
      final args = call.arguments is Map
          ? (call.arguments as Map<Object?, Object?>)
          : <Object?, Object?>{};
      switch (call.method) {
        case 'initialize':
          return !failInitialization;
        case 'getNotificationAppLaunchDetails':
          return launch;
        case 'pendingNotificationRequests':
          return pending.values.toList();
        case 'zonedSchedule':
          if (scheduleGate != null) await scheduleGate!.future;
          if (failSchedule) throw PlatformException(code: 'schedule-failed');
          final id = args['id']! as int;
          pending[id] = {
            'id': id,
            'title': args['title'],
            'body': args['body'],
            'payload': args['payload'],
          };
        case 'cancel':
          pending.remove(args['id']);
        case 'cancelAllPendingNotifications':
          pending.clear();
      }
      return null;
    });
  });
  tearDown(() {
    messenger.setMockMethodCallHandler(channel, null);
    debugDefaultTargetPlatformOverride = null;
  });

  test('terminated launch actions are read once even when initialization is retried', () async {
    launch = {
      'notificationLaunchedApp': true,
      'notificationResponse': {
        'notificationId': 1,
        'actionId': 'given',
        'notificationResponseType': 1,
        'payload': jsonEncode({'kind': 'dose', 'id': 'dose-1'}),
      },
    };
    final actions = <NotificationAction>[];
    final reminders = LocalReminderService();
    await reminders.initialize(actions.add);
    await reminders.initialize(actions.add);
    expect(actions, hasLength(1));
    expect(actions.single.id, 'dose-1');
    expect(actions.single.status, DoseStatus.given);
  });

  test('a rejected native initialization is observable and retried', () async {
    final reminders = LocalReminderService();
    failInitialization = true;
    await expectLater(reminders.initialize((_) {}), throwsStateError);
    expect(calls, isNot(contains('getNotificationAppLaunchDetails')));
    failInitialization = false;
    await reminders.initialize((_) {});
    expect(calls.where((value) => value == 'initialize'), hasLength(2));
    expect(calls.where((value) => value == 'getNotificationAppLaunchDetails'), hasLength(1));
  });

  test('a terminated medication notification body tap opens the existing dose', () async {
    launch = {
      'notificationLaunchedApp': true,
      'notificationResponse': {
        'notificationId': 1,
        'notificationResponseType': 0,
        'payload': jsonEncode({'kind': 'dose', 'id': 'dose-1'}),
      },
    };
    final actions = <NotificationAction>[];
    await LocalReminderService().initialize(actions.add);
    expect(actions.single.kind, NotificationActionKind.openDose);
    expect(actions.single.id, 'dose-1');
  });

  test('malformed cold-launch payload is ignored safely', () async {
    launch = {
      'notificationLaunchedApp': true,
      'notificationResponse': {
        'notificationId': 1,
        'notificationResponseType': 0,
        'payload': '{broken',
      },
    };
    final actions = <NotificationAction>[];
    await LocalReminderService().initialize(actions.add);
    expect(actions, isEmpty);
  });

  test('archived animals schedule no breathing, weight, or medication reminders', () async {
    final json = fixtureSnapshot().toJson();
    json['animals'] = [
      {...fixtureAnimal().toJson(), 'archived': true},
    ];
    final reminders = LocalReminderService();
    await reminders.initialize((_) {});
    await reminders.sync(fixtureCareData(CreaturelySnapshot.fromJson(json)), fixtureTime);
    expect(pending, isEmpty);
    expect(calls, isNot(contains('zonedSchedule')));
  });

  test('failed rescheduling retains valid pending reminders and exposes the error', () async {
    final reminders = LocalReminderService();
    await reminders.initialize((_) {});
    await reminders.sync(fixtureCareData(), DateTime.now().toUtc());
    expect(pending, isNotEmpty);
    final previous = pending.keys.toSet();
    failSchedule = true;
    await expectLater(
      reminders.sync(fixtureCareData(), DateTime.now().toUtc()),
      throwsA(isA<PlatformException>()),
    );
    expect(pending.keys.toSet(), previous);
    expect(calls, isNot(contains('cancelAllPendingNotifications')));
  });

  test('overlapping sync and clear operations complete in request order', () async {
    final reminders = LocalReminderService();
    await reminders.initialize((_) {});
    scheduleGate = Completer<void>();
    final first = reminders.sync(fixtureCareData(), DateTime.now().toUtc());
    await Future<void>.delayed(Duration.zero);
    final clear = reminders.clear();
    expect(calls, isNot(contains('cancelAllPendingNotifications')));
    scheduleGate!.complete();
    await first;
    await clear;
    expect(pending, isEmpty);
    expect(calls.last, 'cancelAllPendingNotifications');
  });
}
