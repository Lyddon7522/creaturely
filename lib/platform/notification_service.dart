import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../domain/models.dart';
import '../domain/recurrence.dart';

enum NotificationPermissionState { unknown, allowed, denied }

enum NotificationActionKind { doseStatus, openRespiratory, openWeight }

class NotificationAction {
  const NotificationAction._({
    required this.kind,
    required this.id,
    this.status,
    this.animalId,
    this.context,
  });

  factory NotificationAction.dose(String id, DoseStatus status) =>
      NotificationAction._(kind: NotificationActionKind.doseStatus, id: id, status: status);

  factory NotificationAction.openRespiratory({
    required String reminderId,
    required String animalId,
    required RespiratoryContext context,
  }) => NotificationAction._(
    kind: NotificationActionKind.openRespiratory,
    id: reminderId,
    animalId: animalId,
    context: context,
  );

  factory NotificationAction.openWeight({required String reminderId, required String animalId}) =>
      NotificationAction._(
        kind: NotificationActionKind.openWeight,
        id: reminderId,
        animalId: animalId,
      );

  final NotificationActionKind kind;
  final String id;
  final DoseStatus? status;
  final String? animalId;
  final RespiratoryContext? context;
}

abstract interface class ReminderService {
  Future<void> initialize(void Function(NotificationAction action) onAction);
  Future<NotificationPermissionState> requestPermission();
  Future<void> sync(CreaturelySnapshot snapshot, DateTime now);
  Future<void> clear();
}

class LocalReminderService implements ReminderService {
  LocalReminderService({
    FlutterLocalNotificationsPlugin? plugin,
    RespiratoryReminderEngine respiratory = const RespiratoryReminderEngine(),
    WeightReminderEngine weight = const WeightReminderEngine(),
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin(),
       _respiratory = respiratory,
       _weight = weight;

  static const String _doseCategory = 'creaturely-dose-v1';
  static const String _givenAction = 'given';
  static const String _skipAction = 'skip';

  final FlutterLocalNotificationsPlugin _plugin;
  final RespiratoryReminderEngine _respiratory;
  final WeightReminderEngine _weight;
  void Function(NotificationAction action)? _onAction;

  @override
  Future<void> initialize(void Function(NotificationAction action) onAction) async {
    _onAction = onAction;
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final darwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      notificationCategories: <DarwinNotificationCategory>[
        DarwinNotificationCategory(
          _doseCategory,
          actions: <DarwinNotificationAction>[
            DarwinNotificationAction.plain(
              _givenAction,
              'Given',
              options: <DarwinNotificationActionOption>{DarwinNotificationActionOption.foreground},
            ),
            DarwinNotificationAction.plain(
              _skipAction,
              'Skip',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.foreground,
                DarwinNotificationActionOption.destructive,
              },
            ),
          ],
        ),
      ],
    );
    await _plugin.initialize(
      settings: InitializationSettings(android: android, iOS: darwin),
      onDidReceiveNotificationResponse: _handleResponse,
    );
  }

  @override
  Future<NotificationPermissionState> requestPermission() async {
    bool? allowed;
    if (defaultTargetPlatform == TargetPlatform.android) {
      allowed = await _plugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      allowed = await _plugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } else {
      return NotificationPermissionState.allowed;
    }
    return allowed == true
        ? NotificationPermissionState.allowed
        : NotificationPermissionState.denied;
  }

  @override
  Future<void> sync(CreaturelySnapshot snapshot, DateTime now) async {
    await _plugin.cancelAllPendingNotifications();
    final medications = <String, Medication>{
      for (final medication in snapshot.medications) medication.id: medication,
    };
    final plans = <_NotificationPlan>[];
    for (final dose in snapshot.doseLedger.where(
      (dose) =>
          dose.status == DoseStatus.unrecorded &&
          dose.dueAt.isAfter(now) &&
          medications[dose.medicationId]?.active == true,
    )) {
      final medication = medications[dose.medicationId]!;
      plans.add(
        _NotificationPlan(
          key: 'dose:${dose.id}',
          dueAt: dose.dueAt,
          title: '${medication.name} for ${_animalName(snapshot, dose.animalId)}',
          body: '${medication.doseAmount} ${medication.doseUnit} • ${medication.instructions}',
          payload: jsonEncode(<String, Object?>{'kind': 'dose', 'id': dose.id}),
          details: const NotificationDetails(
            android: AndroidNotificationDetails(
              'creaturely_medication',
              'Medication reminders',
              channelDescription: 'Reminders the keeper has configured for medication care.',
              importance: Importance.high,
              priority: Priority.high,
              actions: <AndroidNotificationAction>[
                AndroidNotificationAction(_givenAction, 'Given', showsUserInterface: true),
                AndroidNotificationAction(_skipAction, 'Skip', showsUserInterface: true),
              ],
            ),
            iOS: DarwinNotificationDetails(categoryIdentifier: _doseCategory),
          ),
        ),
      );
    }

    final reminderWindowEnd = now.add(const Duration(days: 90));
    for (final reminder in snapshot.respiratoryReminders.where((value) => value.enabled)) {
      for (final occurrence in _respiratory.generate(
        reminder: reminder,
        rangeStartUtc: now,
        rangeEndUtc: reminderWindowEnd,
      )) {
        final contextLabel = reminder.context == RespiratoryContext.sleeping
            ? 'sleeping'
            : 'resting';
        plans.add(
          _NotificationPlan(
            key: 'respiratory:${reminder.id}:${occurrence.intendedLocalTime}',
            dueAt: occurrence.dueAtUtc,
            title: 'Breathing check for ${_animalName(snapshot, reminder.animalId)}',
            body: 'Count $contextLabel breaths when your animal is calm.',
            payload: jsonEncode(<String, Object?>{
              'kind': 'respiratory',
              'id': reminder.id,
              'animalId': reminder.animalId,
              'context': reminder.context.name,
            }),
            details: const NotificationDetails(
              android: AndroidNotificationDetails(
                'creaturely_breathing',
                'Breathing reminders',
                channelDescription:
                    'Reminders the keeper has configured for manual breathing checks.',
                importance: Importance.high,
                priority: Priority.high,
              ),
              iOS: DarwinNotificationDetails(),
            ),
          ),
        );
      }
    }

    for (final reminder in snapshot.weightReminders.where((value) => value.enabled)) {
      for (final occurrence in _weight.generate(
        reminder: reminder,
        rangeStartUtc: now,
        rangeEndUtc: reminderWindowEnd,
      )) {
        plans.add(
          _NotificationPlan(
            key: 'weight:${reminder.id}:${occurrence.intendedLocalTime}',
            dueAt: occurrence.dueAtUtc,
            title: 'Weight check for ${_animalName(snapshot, reminder.animalId)}',
            body: 'Record a weigh-in when it works for you.',
            payload: jsonEncode(<String, Object?>{
              'kind': 'weight',
              'id': reminder.id,
              'animalId': reminder.animalId,
            }),
            details: const NotificationDetails(
              android: AndroidNotificationDetails(
                'creaturely_weight',
                'Weight check reminders',
                channelDescription:
                    'Reminders the keeper has configured for recording weight checks.',
                importance: Importance.high,
                priority: Priority.high,
              ),
              iOS: DarwinNotificationDetails(),
            ),
          ),
        );
      }
    }

    plans.sort((left, right) {
      final byDate = left.dueAt.compareTo(right.dueAt);
      return byDate == 0 ? left.key.compareTo(right.key) : byDate;
    });
    // iOS retains at most 64 pending notifications. The rolling 60-item
    // window leaves room for operating-system bookkeeping and is refreshed
    // after launches and schedule edits.
    final limit = defaultTargetPlatform == TargetPlatform.iOS ? 60 : 500;
    for (final plan in plans.take(limit)) {
      await _plugin.zonedSchedule(
        id: stableNotificationId(plan.key),
        scheduledDate: tz.TZDateTime.from(plan.dueAt, tz.local),
        title: plan.title,
        body: plan.body,
        payload: plan.payload,
        notificationDetails: plan.details,
        // Inexact scheduling works without Android's restricted exact-alarm
        // capability. The in-app schedule always remains the source of truth.
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  @override
  Future<void> clear() => _plugin.cancelAllPendingNotifications();

  void _handleResponse(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null) {
      return;
    }
    final decoded = jsonDecode(payload);
    if (decoded is! Map<String, Object?>) {
      return;
    }
    if (decoded['kind'] == 'dose' &&
        (response.actionId == _givenAction || response.actionId == _skipAction)) {
      _onAction?.call(
        NotificationAction.dose(
          decoded['id'] as String,
          response.actionId == _givenAction ? DoseStatus.given : DoseStatus.skipped,
        ),
      );
      return;
    }
    if (decoded['kind'] == 'respiratory') {
      _onAction?.call(
        NotificationAction.openRespiratory(
          reminderId: decoded['id'] as String,
          animalId: decoded['animalId'] as String,
          context: RespiratoryContext.values.byName(decoded['context'] as String),
        ),
      );
      return;
    }
    if (decoded['kind'] == 'weight') {
      _onAction?.call(
        NotificationAction.openWeight(
          reminderId: decoded['id'] as String,
          animalId: decoded['animalId'] as String,
        ),
      );
    }
  }

  String _animalName(CreaturelySnapshot snapshot, String animalId) =>
      snapshot.animals.firstWhere((animal) => animal.id == animalId).name;

  @visibleForTesting
  static int stableNotificationId(String value) {
    final bytes = sha256.convert(utf8.encode(value)).bytes;
    final data = ByteData.sublistView(Uint8List.fromList(bytes));
    return data.getUint32(0) & 0x7fffffff;
  }
}

class _NotificationPlan {
  const _NotificationPlan({
    required this.key,
    required this.dueAt,
    required this.title,
    required this.body,
    required this.payload,
    required this.details,
  });

  final String key;
  final DateTime dueAt;
  final String title;
  final String body;
  final String payload;
  final NotificationDetails details;
}

class NoopReminderService implements ReminderService {
  const NoopReminderService({this.permission = NotificationPermissionState.denied});

  final NotificationPermissionState permission;

  @override
  Future<void> initialize(void Function(NotificationAction action) onAction) async {}

  @override
  Future<NotificationPermissionState> requestPermission() async => permission;

  @override
  Future<void> sync(CreaturelySnapshot snapshot, DateTime now) async {}

  @override
  Future<void> clear() async {}
}
