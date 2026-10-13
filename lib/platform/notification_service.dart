import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../domain/care_data.dart';
import '../domain/models.dart';
import '../domain/recurrence.dart';
import '../l10n/app_strings.dart';

enum NotificationPermissionState { unknown, allowed, denied }

enum NotificationActionKind { doseStatus, openDose, openRespiratory, openWeight }

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

  factory NotificationAction.openDose(String id) =>
      NotificationAction._(kind: NotificationActionKind.openDose, id: id);

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
  Future<void> sync(CareData care, DateTime now);
  Future<void> clear();
}

class LocalReminderService implements ReminderService {
  LocalReminderService({
    FlutterLocalNotificationsPlugin? plugin,
    CalendarReminderEngine reminders = const CalendarReminderEngine(),
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin(),
       _reminders = reminders;

  static const String _doseCategory = 'creaturely-dose-v1';
  static const String _givenAction = 'given';
  static const String _skipAction = 'skip';

  final FlutterLocalNotificationsPlugin _plugin;
  final CalendarReminderEngine _reminders;
  void Function(NotificationAction action)? _onAction;
  Future<void> _tail = Future.value();
  bool _launchConsumed = false;
  bool _ready = false;
  bool _disposed = false;

  @override
  Future<void> initialize(void Function(NotificationAction action) onAction) async {
    if (_disposed) throw StateError('Notification service is disposed.');
    _onAction = onAction;
    if (_ready) return;
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
              appStrings.given,
              options: <DarwinNotificationActionOption>{DarwinNotificationActionOption.foreground},
            ),
            DarwinNotificationAction.plain(
              _skipAction,
              appStrings.skip,
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.foreground,
                DarwinNotificationActionOption.destructive,
              },
            ),
          ],
        ),
      ],
    );
    final initialized = await _plugin.initialize(
      settings: InitializationSettings(android: android, iOS: darwin),
      onDidReceiveNotificationResponse: _handleResponse,
    );
    if (initialized == false) throw StateError('Notifications could not be initialized.');
    if (!_launchConsumed) {
      final launch = await _plugin.getNotificationAppLaunchDetails();
      _launchConsumed = true;
      final response = launch?.notificationResponse;
      if (launch?.didNotificationLaunchApp == true && response != null) _handleResponse(response);
    }
    _ready = true;
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
  Future<void> sync(CareData care, DateTime now) => _serialize(() => _sync(care, now));

  Future<void> _sync(CareData care, DateTime now) async {
    if (!_ready) throw StateError('Notifications have not been initialized.');
    final activeAnimals = care.animals
        .where((animal) => !animal.archived)
        .map((animal) => animal.id)
        .toSet();
    final medications = <String, Medication>{
      for (final medication in care.medications) medication.id: medication,
    };
    final plans = <_NotificationPlan>[];
    for (final dose in care.doseLedger.where(
      (dose) =>
          activeAnimals.contains(dose.animalId) &&
          dose.status == DoseStatus.unrecorded &&
          dose.dueAt.isAfter(now) &&
          medications[dose.medicationId]?.active == true,
    )) {
      final medication = medications[dose.medicationId]!;
      plans.add(
        _NotificationPlan(
          key: 'dose:${dose.id}',
          dueAt: dose.dueAt,
          title: appStrings.medicationForAnimal(medication.name, _animalName(care, dose.animalId)),
          body: '${medication.doseAmount} ${medication.doseUnit} • ${medication.instructions}',
          payload: jsonEncode(<String, Object?>{'kind': 'dose', 'id': dose.id}),
          details: NotificationDetails(
            android: AndroidNotificationDetails(
              'creaturely_medication',
              appStrings.medicationReminders,
              channelDescription: appStrings.remindersTheKeeperHasConfiguredForMedicationCare,
              importance: Importance.high,
              priority: Priority.high,
              actions: <AndroidNotificationAction>[
                AndroidNotificationAction(_givenAction, appStrings.given, showsUserInterface: true),
                AndroidNotificationAction(_skipAction, appStrings.skip, showsUserInterface: true),
              ],
            ),
            iOS: const DarwinNotificationDetails(categoryIdentifier: _doseCategory),
          ),
        ),
      );
    }

    final reminderWindowEnd = now.add(const Duration(days: 90));
    for (final reminder in care.respiratoryReminders.where(
      (value) => value.enabled && activeAnimals.contains(value.animalId),
    )) {
      for (final occurrence in _reminders.generate(
        reminder: reminder,
        rangeStartUtc: now,
        rangeEndUtc: reminderWindowEnd,
      )) {
        plans.add(
          _NotificationPlan(
            key: 'respiratory:${reminder.id}:${occurrence.intendedLocalTime}',
            dueAt: occurrence.dueAtUtc,
            title: appStrings.breathingCheckFor(_animalName(care, reminder.animalId)),
            body: reminder.context == RespiratoryContext.sleeping
                ? appStrings.countSleepingBreaths
                : appStrings.countRestingBreaths,
            payload: jsonEncode(<String, Object?>{
              'kind': 'respiratory',
              'id': reminder.id,
              'animalId': reminder.animalId,
              'context': reminder.context.name,
            }),
            details: NotificationDetails(
              android: AndroidNotificationDetails(
                'creaturely_breathing',
                appStrings.breathingReminders,
                channelDescription:
                    appStrings.remindersTheKeeperHasConfiguredForManualBreathingChecks,
                importance: Importance.high,
                priority: Priority.high,
              ),
              iOS: const DarwinNotificationDetails(),
            ),
          ),
        );
      }
    }

    for (final reminder in care.weightReminders.where(
      (value) => value.enabled && activeAnimals.contains(value.animalId),
    )) {
      for (final occurrence in _reminders.generate(
        reminder: reminder,
        rangeStartUtc: now,
        rangeEndUtc: reminderWindowEnd,
      )) {
        plans.add(
          _NotificationPlan(
            key: 'weight:${reminder.id}:${occurrence.intendedLocalTime}',
            dueAt: occurrence.dueAtUtc,
            title: appStrings.weightCheckFor(_animalName(care, reminder.animalId)),
            body: appStrings.recordAWeighInWhenItWorksForYou,
            payload: jsonEncode(<String, Object?>{
              'kind': 'weight',
              'id': reminder.id,
              'animalId': reminder.animalId,
            }),
            details: NotificationDetails(
              android: AndroidNotificationDetails(
                'creaturely_weight',
                appStrings.weightCheckReminders,
                channelDescription:
                    appStrings.remindersTheKeeperHasConfiguredForRecordingWeightChecks,
                importance: Importance.high,
                priority: Priority.high,
              ),
              iOS: const DarwinNotificationDetails(),
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
    final desired = plans.take(limit).toList();
    final ids = desired.map((plan) => stableNotificationId(plan.key)).toSet();
    // Remove only obsolete reminders. A failed replacement keeps the other
    // valid pending notifications instead of erasing the whole schedule.
    for (final pending in await _plugin.pendingNotificationRequests()) {
      if (!ids.contains(pending.id)) await _plugin.cancel(id: pending.id);
    }
    for (final plan in desired) {
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
  Future<void> clear() => _serialize(_plugin.cancelAllPendingNotifications);

  Future<void> _serialize(Future<void> Function() action) {
    final work = _tail.then((_) {
      if (_disposed) throw StateError('Notification service is disposed.');
      return action();
    });
    _tail = work.catchError((Object _) {});
    return work;
  }

  void dispose() {
    _disposed = true;
    _onAction = null;
  }

  void _handleResponse(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null) {
      return;
    }
    Object? decoded;
    try {
      decoded = jsonDecode(payload);
    } on FormatException {
      return;
    }
    if (decoded is! Map<String, Object?> ||
        decoded['id'] is! String ||
        (decoded['id'] as String).isEmpty) {
      return;
    }
    if (decoded['kind'] == 'dose') {
      final id = decoded['id'] as String;
      if (response.actionId == _givenAction || response.actionId == _skipAction) {
        _onAction?.call(
          NotificationAction.dose(
            id,
            response.actionId == _givenAction ? DoseStatus.given : DoseStatus.skipped,
          ),
        );
      } else if (response.notificationResponseType ==
          NotificationResponseType.selectedNotification) {
        _onAction?.call(NotificationAction.openDose(id));
      }
      return;
    }
    if (decoded['animalId'] is! String || (decoded['animalId'] as String).isEmpty) return;
    if (decoded['kind'] == 'respiratory') {
      final contextName = decoded['context'];
      if (!RespiratoryContext.values.any((value) => value.name == contextName)) return;
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

  String _animalName(CareData care, String animalId) =>
      care.animals.firstWhere((animal) => animal.id == animalId).name;

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
  Future<void> sync(CareData care, DateTime now) async {}

  @override
  Future<void> clear() async {}
}
