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
  String get todayAtAGlance => 'Today at a glance';

  @override
  String get latestBreathing => 'Latest breathing';

  @override
  String get breathing => 'Breathing';

  @override
  String get weight => 'Weight';

  @override
  String get currentWeight => 'Current weight';

  @override
  String get medicationStatus => 'Medications';

  @override
  String get dosesDueSoon => 'Doses due soon';

  @override
  String get notRecorded => 'Not recorded';

  @override
  String get currentRecordedWeight => 'Current recorded weight';

  @override
  String get reviewSchedules => 'Review schedules';

  @override
  String get next24Hours => 'Next 24 hours';

  @override
  String get countBreathsToStartTrend => 'Count breaths to start a trend';

  @override
  String get logWeightToStartTrend => 'Log a weight to start a trend';

  @override
  String recordedDate(String date) {
    return 'Recorded $date';
  }

  @override
  String activeMedicationCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count active',
      one: '1 active',
      zero: '0 active',
    );
    return '$_temp0';
  }

  @override
  String shortDoseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count doses',
      one: '1 dose',
      zero: '0 doses',
    );
    return '$_temp0';
  }

  @override
  String editAnimal(String animalName) {
    return 'Edit $animalName';
  }

  @override
  String exportAnimal(String animalName) {
    return 'Export $animalName';
  }

  @override
  String animalDashboard(String animalName) {
    return '$animalName dashboard';
  }

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
