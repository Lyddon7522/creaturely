import 'dart:async';

import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;

abstract interface class TimeZoneService {
  /// Returns the resolved IANA identifier, or null when UTC is only a fallback.
  Future<String?> configure();
}

/// Resolves the device zone after Flutter has mounted its first loading view.
///
/// Some platform channels are not ready early enough to be awaited before
/// `runApp`. A bounded lookup keeps a platform failure from trapping the user
/// on the native launch screen. UTC is a safe fallback; the next launch retries.
class DeviceTimeZoneService implements TimeZoneService {
  DeviceTimeZoneService({
    Future<String> Function()? lookupIdentifier,
    this.timeout = const Duration(seconds: 2),
  }) : _lookupIdentifier = lookupIdentifier ?? _deviceIdentifier;

  final Future<String> Function() _lookupIdentifier;
  final Duration timeout;

  @override
  Future<String?> configure() async {
    tz.setLocalLocation(tz.UTC);
    try {
      final identifier = await _lookupIdentifier().timeout(timeout);
      tz.setLocalLocation(tz.getLocation(identifier));
      return identifier;
    } on Object {
      // A lookup, plugin, or zone-database failure must never block the journal.
      tz.setLocalLocation(tz.UTC);
      return null;
    }
  }

  static Future<String> _deviceIdentifier() async =>
      (await FlutterTimezone.getLocalTimezone()).identifier;
}
