// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Creaturely';

  @override
  String get animals => 'Animals';

  @override
  String get timeline => 'Timeline';

  @override
  String get trends => 'Trends';

  @override
  String get schedule => 'Schedule';

  @override
  String get settings => 'Settings';

  @override
  String get continueLabel => 'Continue';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get addAnimal => 'Add animal';

  @override
  String get noAnimalsTitle => 'Make space for the animal you care for';

  @override
  String get noAnimalsBody =>
      'Creaturely works for any species. Add an animal to begin a private health journal.';

  @override
  String get medicalDisclaimer =>
      'Creaturely is a journal, not a diagnostic tool. Measurements and reminders do not replace advice from a veterinarian.';

  @override
  String get privacySummary => 'Your journal stays on this device. Vector42 collects no data.';

  @override
  String get respiratoryRate => 'Resting breathing';

  @override
  String get quickActions => 'Quick actions';

  @override
  String get countBreaths => 'Count breaths';

  @override
  String get logWeight => 'Log weight';

  @override
  String get observation => 'Observation';

  @override
  String get medications => 'Medication';

  @override
  String get documents => 'Documents';

  @override
  String get healthRecords => 'Health records';

  @override
  String get emptyTimeline => 'Nothing recorded in this range yet.';

  @override
  String get permissionDenied =>
      'Notifications are off. Creaturely still works; reminders will remain visible in the app.';

  @override
  String get seekAdvice =>
      'If you are concerned about your animal, contact a veterinarian. Creaturely does not diagnose conditions.';
}
