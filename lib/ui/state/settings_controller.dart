import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models.dart';
import '../../platform/notification_service.dart';
import 'care_controller.dart';
import 'command_controller.dart';
import 'dependencies.dart';

final settingsControllerProvider = AsyncNotifierProvider<SettingsController, void>(
  SettingsController.new,
);

class SettingsController extends CommandController {
  Future<NotificationPermissionState> requestNotifications() async {
    final permission = await ref.read(reminderServiceProvider).requestPermission();
    await updateSettings(
      (current) => current.copyWith(
        notificationPermissionAsked: true,
        notificationsAllowed: permission == NotificationPermissionState.allowed,
      ),
      syncReminders: true,
    );
    return permission;
  }

  Future<void> updateSettings(
    AppSettings Function(AppSettings) update, {
    bool syncReminders = false,
  }) => run(() async {
    final repository = ref.read(repositoryProvider);
    final changed = await repository.exclusive(() async {
      final current = await repository.database.readSettings();
      final next = update(current);
      if (!const [15, 20, 30, 60].contains(next.defaultTimerSeconds)) {
        throw ArgumentError.value(
          next.defaultTimerSeconds,
          'defaultTimerSeconds',
          'Unsupported timer choice.',
        );
      }
      await repository.saveSettings(next);
      return current.notificationsAllowed != next.notificationsAllowed;
    });
    if (ref.mounted && (changed || syncReminders)) {
      await ref.read(reminderSyncProvider.notifier).synchronize();
    }
  });
}
