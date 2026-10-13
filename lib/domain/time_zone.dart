import 'package:timezone/data/latest.dart' as data;
import 'package:timezone/timezone.dart' as tz;

/// Uses the bundled IANA database; validation never contacts a network service.
bool isKnownTimeZone(String name) {
  // Before initialization timezone only supplies its built-in UTC location.
  if (tz.timeZoneDatabase.locations.length < 2) {
    data.initializeTimeZones();
  }
  return name == 'UTC' || tz.timeZoneDatabase.locations.containsKey(name);
}

tz.Location timeZoneLocation(String name) => name == 'UTC' ? tz.UTC : tz.getLocation(name);
