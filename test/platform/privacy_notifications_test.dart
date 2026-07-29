import 'dart:io';

import 'package:creaturely/platform/notification_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('notification IDs are stable, positive, and record-specific', () {
    final first = LocalReminderService.stableNotificationId('dose:one');
    expect(first, LocalReminderService.stableNotificationId('dose:one'));
    expect(first, isNonNegative);
    expect(first, isNot(LocalReminderService.stableNotificationId('dose:two')));
  });

  test('normal Dart operation has no networking or telemetry dependency', () {
    final pubspec = File('pubspec.yaml').readAsStringSync().toLowerCase();
    for (final forbidden in <String>[
      'package:http',
      'firebase',
      'sentry',
      'analytics',
      'crashlytics',
      'amplitude',
      'mixpanel',
    ]) {
      expect(pubspec, isNot(contains(forbidden)), reason: 'Found forbidden dependency: $forbidden');
    }

    final dartSources = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .map((file) => file.readAsStringSync())
        .join('\n');
    for (final forbidden in <String>[
      'HttpClient(',
      'Socket.connect(',
      'package:http/',
      'package:dio/',
    ]) {
      expect(dartSources, isNot(contains(forbidden)), reason: 'Normal app traffic: $forbidden');
    }

    final androidBridge = File(
      'android/app/src/main/kotlin/com/vector42/creaturely/MainActivity.kt',
    ).readAsStringSync();
    expect(androidBridge.toLowerCase(), contains('explicit recovery bridge'));
    expect(androidBridge, contains('drive.appdata'));
    expect(androidBridge, contains('appDataFolder'));
  });
}
