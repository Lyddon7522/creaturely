import 'dart:ui';

import 'generated/app_localizations.dart';

export 'generated/app_localizations.dart';

/// Native callbacks have no widget context. They use the supported language of
/// the device, matching the app's locale resolution. Widgets use their context.
AppLocalizations get appStrings {
  final language = PlatformDispatcher.instance.locale.languageCode;
  final locale = AppLocalizations.supportedLocales.firstWhere(
    (locale) => locale.languageCode == language,
    orElse: () => AppLocalizations.supportedLocales.first,
  );
  return lookupAppLocalizations(locale);
}
