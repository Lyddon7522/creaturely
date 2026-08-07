import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/Roboto_LICENSE.txt');
    yield LicenseEntryWithLineBreaks(const <String>['Roboto'], license);
  });
  tz_data.initializeTimeZones();
  tz.setLocalLocation(tz.UTC);
  runApp(const ProviderScope(child: CreaturelyApp()));
}
