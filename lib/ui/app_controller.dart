import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../platform/notification_service.dart';
import 'state/care_controller.dart';
import 'state/dependencies.dart';

export 'state/animal_controller.dart';
export 'state/care_controller.dart';
export 'state/dependencies.dart';
export 'state/media_controller.dart';
export 'state/query_providers.dart';
export 'state/recovery_controller.dart';
export 'state/settings_controller.dart';

final appControllerProvider = NotifierProvider<AppController, AppStatus>(AppController.new);

class AppStatus {
  const AppStatus({
    this.loading = true,
    this.error,
    this.pendingRoute,
    this.recoveryError,
    this.notificationActionError,
  });
  final bool loading;
  final Object? error;
  final String? pendingRoute;
  final Object? recoveryError;
  final Object? notificationActionError;
  AppStatus withRecoveryError(Object? value) => AppStatus(
    loading: loading,
    error: error,
    pendingRoute: pendingRoute,
    recoveryError: value,
    notificationActionError: notificationActionError,
  );
  AppStatus withNotificationActionError(Object? value) => AppStatus(
    loading: loading,
    error: error,
    pendingRoute: pendingRoute,
    recoveryError: recoveryError,
    notificationActionError: value,
  );
}

/// Owns startup and foreground lifecycle, not the journal's records or commands.
class AppController extends Notifier<AppStatus> {
  Future<void>? _initializing;
  Future<bool>? _notificationInitialization;
  bool _initialized = false;
  bool _notificationsReady = false;
  bool _navigationReady = false;
  bool _resuming = false;
  bool _draining = false;
  final List<NotificationAction> _actions = [];

  @override
  AppStatus build() => const AppStatus();

  Future<void> initialize() {
    if (!ref.mounted || _initialized) return Future.value();
    return _initializing ??= _initialize().whenComplete(() => _initializing = null);
  }

  Future<void> _initialize() async {
    if (!state.loading) state = const AppStatus();
    final timeZones = ref.read(timeZoneServiceProvider);
    final care = ref.read(careControllerProvider.notifier);
    try {
      final zone = await timeZones.configure();
      if (!ref.mounted) return;
      final notificationsReady = await _ensureNotifications();
      if (!ref.mounted) return;
      await care.maintain(timeZoneId: zone, syncReminders: notificationsReady);
      if (!ref.mounted) return;
      _initialized = true;
      state = const AppStatus(loading: false);
      unawaited(_drainActions());
      unawaited(createAutomaticRecovery());
    } on Object catch (error) {
      if (ref.mounted) state = AppStatus(loading: false, error: error);
    }
  }

  Future<bool> _ensureNotifications() {
    if (!ref.mounted) return Future.value(false);
    if (_notificationsReady) return Future.value(true);
    return _notificationInitialization ??= _initializeNotifications().whenComplete(
      () => _notificationInitialization = null,
    );
  }

  Future<bool> _initializeNotifications() async {
    final reminders = ref.read(reminderServiceProvider);
    try {
      await reminders.initialize(_queueAction);
      if (!ref.mounted) return false;
      _notificationsReady = true;
      return true;
    } on Object catch (error, stack) {
      _reportNotificationError(error, stack);
      return false;
    }
  }

  void _queueAction(NotificationAction action) {
    if (!ref.mounted) return;
    _actions.add(action);
    unawaited(_drainActions());
  }

  void _reportNotificationError(Object error, StackTrace stack) {
    if (ref.mounted) ref.read(reminderSyncProvider.notifier).reportError(error, stack);
  }

  Future<void> retryReminders() async {
    if (await _ensureNotifications() && ref.mounted) {
      await ref.read(reminderSyncProvider.notifier).synchronize();
    }
  }

  Future<void> createAutomaticRecovery() async {
    if (!ref.mounted || !_initialized) return;
    final repository = ref.read(repositoryProvider);
    try {
      final settings = await repository.database.readSettings();
      if (!ref.mounted || !settings.automaticRecoveryEnabled) return;
      state = state.withRecoveryError(null);
      final manager = await ref.read(recoverySnapshotManagerProvider.future);
      if (!ref.mounted) return;
      await manager.createAndPrune();
    } on Object catch (error) {
      if (ref.mounted) state = state.withRecoveryError(error);
    }
  }

  void navigationReady() {
    if (!ref.mounted) return;
    _navigationReady = true;
    unawaited(_drainActions());
  }

  Future<void> _drainActions() async {
    if (!ref.mounted ||
        _draining ||
        !_initialized ||
        !_navigationReady ||
        state.notificationActionError != null) {
      return;
    }
    _draining = true;
    final database = ref.read(repositoryProvider).database;
    final care = ref.read(careControllerProvider.notifier);
    try {
      while (_actions.isNotEmpty && ref.mounted) {
        final action = _actions.removeAt(0);
        try {
          final animals = await database.readAnimals();
          if (!ref.mounted) return;
          if (action.kind == NotificationActionKind.doseStatus ||
              action.kind == NotificationActionKind.openDose) {
            final dose = await database.findDose(action.id);
            if (!ref.mounted) return;
            if (dose == null ||
                !animals.any((animal) => animal.id == dose.animalId && !animal.archived)) {
              continue;
            }
            if (action.kind == NotificationActionKind.doseStatus) {
              await care.recordDose(action.id, action.status!);
            } else {
              state = AppStatus(
                loading: false,
                recoveryError: state.recoveryError,
                pendingRoute:
                    '/medication/${Uri.encodeComponent(dose.medicationId)}/${Uri.encodeComponent(dose.animalId)}',
              );
            }
          } else {
            if (!animals.any((animal) => animal.id == action.animalId && !animal.archived)) {
              continue;
            }
            final animalId = Uri.encodeComponent(action.animalId!);
            state = AppStatus(
              loading: false,
              recoveryError: state.recoveryError,
              pendingRoute: action.kind == NotificationActionKind.openRespiratory
                  ? '/record/breaths/$animalId?context=${action.context!.name}'
                  : '/health/new/$animalId',
            );
          }
        } on Object catch (error) {
          if (ref.mounted) {
            _actions.insert(0, action);
            state = state.withNotificationActionError(error);
          }
          break;
        }
      }
    } finally {
      _draining = false;
    }
  }

  void consumePendingRoute() {
    if (ref.mounted) {
      state = AppStatus(
        loading: false,
        recoveryError: state.recoveryError,
        notificationActionError: state.notificationActionError,
      );
    }
  }

  Future<void> retryNotificationAction() async {
    if (!ref.mounted) return;
    state = state.withNotificationActionError(null);
    await _drainActions();
  }

  Future<void> handleAppResumed() async {
    if (!ref.mounted || !_initialized || _resuming) return;
    _resuming = true;
    final timeZones = ref.read(timeZoneServiceProvider);
    final care = ref.read(careControllerProvider.notifier);
    try {
      final zone = await timeZones.configure();
      if (!ref.mounted) return;
      final notificationsReady = await _ensureNotifications();
      if (!ref.mounted) return;
      await care.maintain(timeZoneId: zone, syncReminders: notificationsReady);
    } on Object catch (error, stack) {
      _reportNotificationError(error, stack);
    } finally {
      _resuming = false;
    }
  }
}
