import 'dart:async';

import 'package:creaturely/platform/time_zone_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

void main() {
  setUpAll(tz_data.initializeTimeZones);

  test('device time zone is applied before recurrence and reminder work', () async {
    final service = DeviceTimeZoneService(lookupIdentifier: () async => 'America/Chicago');

    final identifier = await service.configure();

    expect(identifier, 'America/Chicago');
    expect(tz.local.name, 'America/Chicago');
  });

  test('an unavailable platform lookup falls back to UTC without hanging', () async {
    final service = DeviceTimeZoneService(
      lookupIdentifier: () => Completer<String>().future,
      timeout: const Duration(milliseconds: 1),
    );

    final identifier = await service.configure();

    expect(identifier, isNull);
    expect(tz.local, tz.UTC);
  });

  test('an unknown zone falls back to UTC', () async {
    final service = DeviceTimeZoneService(lookupIdentifier: () async => 'Invalid/Creaturely');

    final identifier = await service.configure();

    expect(identifier, isNull);
    expect(tz.local, tz.UTC);
  });
}
