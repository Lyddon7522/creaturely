import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'Creaturely'**
  String get appName;

  /// No description provided for @animals.
  ///
  /// In en, this message translates to:
  /// **'Animals'**
  String get animals;

  /// No description provided for @timeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get timeline;

  /// No description provided for @trends.
  ///
  /// In en, this message translates to:
  /// **'Trends'**
  String get trends;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @addAnimal.
  ///
  /// In en, this message translates to:
  /// **'Add animal'**
  String get addAnimal;

  /// No description provided for @noAnimalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Make space for the animal you care for'**
  String get noAnimalsTitle;

  /// No description provided for @noAnimalsBody.
  ///
  /// In en, this message translates to:
  /// **'Creaturely works for any species. Add an animal to begin a private health journal.'**
  String get noAnimalsBody;

  /// No description provided for @medicalDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Creaturely is a journal, not a diagnostic tool. Measurements and reminders do not replace advice from a veterinarian.'**
  String get medicalDisclaimer;

  /// No description provided for @privacySummary.
  ///
  /// In en, this message translates to:
  /// **'Your journal stays on this device. Vector42 collects no data.'**
  String get privacySummary;

  /// No description provided for @respiratoryRate.
  ///
  /// In en, this message translates to:
  /// **'Resting breathing'**
  String get respiratoryRate;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get quickActions;

  /// No description provided for @countBreaths.
  ///
  /// In en, this message translates to:
  /// **'Count breaths'**
  String get countBreaths;

  /// No description provided for @logWeight.
  ///
  /// In en, this message translates to:
  /// **'Log weight'**
  String get logWeight;

  /// No description provided for @observation.
  ///
  /// In en, this message translates to:
  /// **'Observation'**
  String get observation;

  /// No description provided for @todayAtAGlance.
  ///
  /// In en, this message translates to:
  /// **'Today at a glance'**
  String get todayAtAGlance;

  /// No description provided for @latestBreathing.
  ///
  /// In en, this message translates to:
  /// **'Latest breathing'**
  String get latestBreathing;

  /// No description provided for @breathing.
  ///
  /// In en, this message translates to:
  /// **'Breathing'**
  String get breathing;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @currentWeight.
  ///
  /// In en, this message translates to:
  /// **'Current weight'**
  String get currentWeight;

  /// No description provided for @medicationStatus.
  ///
  /// In en, this message translates to:
  /// **'Medications'**
  String get medicationStatus;

  /// No description provided for @dosesDueSoon.
  ///
  /// In en, this message translates to:
  /// **'Doses due soon'**
  String get dosesDueSoon;

  /// No description provided for @notRecorded.
  ///
  /// In en, this message translates to:
  /// **'Not recorded'**
  String get notRecorded;

  /// No description provided for @currentRecordedWeight.
  ///
  /// In en, this message translates to:
  /// **'Current recorded weight'**
  String get currentRecordedWeight;

  /// No description provided for @reviewSchedules.
  ///
  /// In en, this message translates to:
  /// **'Review schedules'**
  String get reviewSchedules;

  /// No description provided for @next24Hours.
  ///
  /// In en, this message translates to:
  /// **'Next 24 hours'**
  String get next24Hours;

  /// No description provided for @countBreathsToStartTrend.
  ///
  /// In en, this message translates to:
  /// **'Count breaths to start a trend'**
  String get countBreathsToStartTrend;

  /// No description provided for @logWeightToStartTrend.
  ///
  /// In en, this message translates to:
  /// **'Log a weight to start a trend'**
  String get logWeightToStartTrend;

  /// No description provided for @recordedDate.
  ///
  /// In en, this message translates to:
  /// **'Recorded {date}'**
  String recordedDate(String date);

  /// No description provided for @activeMedicationCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 active} =1{1 active} other{{count} active}}'**
  String activeMedicationCount(int count);

  /// No description provided for @shortDoseCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 doses} =1{1 dose} other{{count} doses}}'**
  String shortDoseCount(int count);

  /// No description provided for @editAnimal.
  ///
  /// In en, this message translates to:
  /// **'Edit {animalName}'**
  String editAnimal(String animalName);

  /// No description provided for @exportAnimal.
  ///
  /// In en, this message translates to:
  /// **'Export {animalName}'**
  String exportAnimal(String animalName);

  /// No description provided for @animalDashboard.
  ///
  /// In en, this message translates to:
  /// **'{animalName} dashboard'**
  String animalDashboard(String animalName);

  /// No description provided for @medications.
  ///
  /// In en, this message translates to:
  /// **'Medication'**
  String get medications;

  /// No description provided for @medicationPrescriptionDetails.
  ///
  /// In en, this message translates to:
  /// **'Prescription & supply'**
  String get medicationPrescriptionDetails;

  /// No description provided for @medicationPrescriptionDetailsHint.
  ///
  /// In en, this message translates to:
  /// **'Optional medicine, veterinarian, and refill information.'**
  String get medicationPrescriptionDetailsHint;

  /// No description provided for @medicationStrengthLabel.
  ///
  /// In en, this message translates to:
  /// **'Strength or concentration'**
  String get medicationStrengthLabel;

  /// No description provided for @medicationStrengthHint.
  ///
  /// In en, this message translates to:
  /// **'For example, 20 mg/mL'**
  String get medicationStrengthHint;

  /// No description provided for @medicationPrescriberLabel.
  ///
  /// In en, this message translates to:
  /// **'Prescribing veterinarian or clinic'**
  String get medicationPrescriberLabel;

  /// No description provided for @medicationPharmacyLabel.
  ///
  /// In en, this message translates to:
  /// **'Pharmacy'**
  String get medicationPharmacyLabel;

  /// No description provided for @medicationPrescriptionNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Prescription number'**
  String get medicationPrescriptionNumberLabel;

  /// No description provided for @medicationRefillsRemainingLabel.
  ///
  /// In en, this message translates to:
  /// **'Refills remaining'**
  String get medicationRefillsRemainingLabel;

  /// No description provided for @medicationNextRefillDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Next refill date'**
  String get medicationNextRefillDateLabel;

  /// No description provided for @medicationNoRefillDate.
  ///
  /// In en, this message translates to:
  /// **'No refill date'**
  String get medicationNoRefillDate;

  /// No description provided for @medicationClearNextRefillDate.
  ///
  /// In en, this message translates to:
  /// **'Clear next refill date'**
  String get medicationClearNextRefillDate;

  /// No description provided for @medicationRefillsValidation.
  ///
  /// In en, this message translates to:
  /// **'Use a whole number of zero or more.'**
  String get medicationRefillsValidation;

  /// No description provided for @documents.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documents;

  /// No description provided for @healthRecords.
  ///
  /// In en, this message translates to:
  /// **'Health records'**
  String get healthRecords;

  /// No description provided for @emptyTimeline.
  ///
  /// In en, this message translates to:
  /// **'Nothing recorded in this range yet.'**
  String get emptyTimeline;

  /// No description provided for @permissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Notifications are off. Creaturely still works; reminders will remain visible in the app.'**
  String get permissionDenied;

  /// No description provided for @seekAdvice.
  ///
  /// In en, this message translates to:
  /// **'If you are concerned about your animal, contact a veterinarian. Creaturely does not diagnose conditions.'**
  String get seekAdvice;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
