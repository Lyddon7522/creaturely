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

  /// User-visible copy: Selected animal: {value1}. Change animal.
  ///
  /// In en, this message translates to:
  /// **'Selected animal: {value1}. Change animal.'**
  String selectedAnimalChangeAnimal(Object value1);

  /// User-visible copy: Loading Creaturely
  ///
  /// In en, this message translates to:
  /// **'Loading Creaturely'**
  String get loadingCreaturely;

  /// User-visible copy: Creaturely. Know their normal.
  ///
  /// In en, this message translates to:
  /// **'Creaturely. Know their normal.'**
  String get creaturelyKnowTheirNormal;

  /// User-visible copy: Creaturely, your way
  ///
  /// In en, this message translates to:
  /// **'Creaturely, your way'**
  String get creaturelyYourWay;

  /// User-visible copy: Comfort, reminders, privacy, and your own copies.
  ///
  /// In en, this message translates to:
  /// **'Comfort, reminders, privacy, and your own copies.'**
  String get comfortRemindersPrivacyAndYourOwnCopies;

  /// User-visible copy: Appearance & units
  ///
  /// In en, this message translates to:
  /// **'Appearance & units'**
  String get appearanceUnits;

  /// User-visible copy: Theme
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// User-visible copy: System
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// User-visible copy: Light
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// User-visible copy: Dark
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// User-visible copy: Weight display
  ///
  /// In en, this message translates to:
  /// **'Weight display'**
  String get weightDisplay;

  /// User-visible copy: Recording feedback
  ///
  /// In en, this message translates to:
  /// **'Recording feedback'**
  String get recordingFeedback;

  /// User-visible copy: Haptic tap
  ///
  /// In en, this message translates to:
  /// **'Haptic tap'**
  String get hapticTap;

  /// User-visible copy: On by default for each recorded breath.
  ///
  /// In en, this message translates to:
  /// **'On by default for each recorded breath.'**
  String get onByDefaultForEachRecordedBreath;

  /// User-visible copy: Tap sound
  ///
  /// In en, this message translates to:
  /// **'Tap sound'**
  String get tapSound;

  /// User-visible copy: Off by default.
  ///
  /// In en, this message translates to:
  /// **'Off by default.'**
  String get offByDefault;

  /// User-visible copy: Default breathing timer
  ///
  /// In en, this message translates to:
  /// **'Default breathing timer'**
  String get defaultBreathingTimer;

  /// User-visible copy: {value1} s
  ///
  /// In en, this message translates to:
  /// **'{value1} s'**
  String s(Object value1);

  /// User-visible copy: Reminders & recovery
  ///
  /// In en, this message translates to:
  /// **'Reminders & recovery'**
  String get remindersRecovery;

  /// User-visible copy: Notifications
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// User-visible copy: Medication, breathing, and weight reminders can be scheduled.
  ///
  /// In en, this message translates to:
  /// **'Medication, breathing, and weight reminders can be scheduled.'**
  String get medicationBreathingAndWeightRemindersCanBeScheduled;

  /// User-visible copy: Due care remains visible in the app.
  ///
  /// In en, this message translates to:
  /// **'Due care remains visible in the app.'**
  String get dueCareRemainsVisibleInTheApp;

  /// User-visible copy: Automatic recovery snapshots
  ///
  /// In en, this message translates to:
  /// **'Automatic recovery snapshots'**
  String get automaticRecoverySnapshots;

  /// User-visible copy: Off • local data remains the source of truth
  ///
  /// In en, this message translates to:
  /// **'Off • local data remains the source of truth'**
  String get offLocalDataRemainsTheSourceOfTruth;

  /// User-visible copy: Your data
  ///
  /// In en, this message translates to:
  /// **'Your data'**
  String get yourData;

  /// User-visible copy: Backup, restore & pet export
  ///
  /// In en, this message translates to:
  /// **'Backup, restore & pet export'**
  String get backupRestorePetExport;

  /// User-visible copy: Save backups and save or share pet health summaries.
  ///
  /// In en, this message translates to:
  /// **'Save backups and save or share pet health summaries.'**
  String get saveBackupsAndSaveOrSharePetHealthSummaries;

  /// User-visible copy: Delete local journal
  ///
  /// In en, this message translates to:
  /// **'Delete local journal'**
  String get deleteLocalJournal;

  /// User-visible copy: Remove records and app-managed attachments.
  ///
  /// In en, this message translates to:
  /// **'Remove records and app-managed attachments.'**
  String get removeRecordsAndAppManagedAttachments;

  /// User-visible copy: Help & feedback
  ///
  /// In en, this message translates to:
  /// **'Help & feedback'**
  String get helpFeedback;

  /// User-visible copy: Report a bug
  ///
  /// In en, this message translates to:
  /// **'Report a bug'**
  String get reportABug;

  /// User-visible copy: Open a private-data-safe GitHub issue form.
  ///
  /// In en, this message translates to:
  /// **'Open a private-data-safe GitHub issue form.'**
  String get openAPrivateDataSafeGitHubIssueForm;

  /// User-visible copy: View Creaturely source
  ///
  /// In en, this message translates to:
  /// **'View Creaturely source'**
  String get viewCreaturelySource;

  /// User-visible copy: Copy technical details
  ///
  /// In en, this message translates to:
  /// **'Copy technical details'**
  String get copyTechnicalDetails;

  /// User-visible copy: App, platform, and locale only—never journal data.
  ///
  /// In en, this message translates to:
  /// **'App, platform, and locale only—never journal data.'**
  String get appPlatformAndLocaleOnlyNeverJournalData;

  /// User-visible copy: Trust & transparency
  ///
  /// In en, this message translates to:
  /// **'Trust & transparency'**
  String get trustTransparency;

  /// User-visible copy: Privacy
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// User-visible copy: Terms
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get terms;

  /// User-visible copy: Medical disclaimer
  ///
  /// In en, this message translates to:
  /// **'Medical disclaimer'**
  String get medicalDisclaimer2;

  /// User-visible copy: About & open-source licenses
  ///
  /// In en, this message translates to:
  /// **'About & open-source licenses'**
  String get aboutOpenSourceLicenses;

  /// User-visible copy: Could not open the link on this device.
  ///
  /// In en, this message translates to:
  /// **'Could not open the link on this device.'**
  String get couldNotOpenTheLinkOnThisDevice;

  /// User-visible copy: Creaturely 1.0.0 (1)
  /// Platform: {value1}
  /// OS version: {value2}
  /// Locale: {value3}
  ///
  /// In en, this message translates to:
  /// **'Creaturely 1.0.0 (1)\nPlatform: {value1}\nOS version: {value2}\nLocale: {value3}'**
  String creaturely1001PlatformOSVersionLocale(Object value1, Object value2, Object value3);

  /// User-visible copy: Technical details copied.
  ///
  /// In en, this message translates to:
  /// **'Technical details copied.'**
  String get technicalDetailsCopied;

  /// User-visible copy: Private CloudKit recovery
  ///
  /// In en, this message translates to:
  /// **'Private CloudKit recovery'**
  String get privateCloudKitRecovery;

  /// User-visible copy: Google Drive appData recovery
  ///
  /// In en, this message translates to:
  /// **'Google Drive appData recovery'**
  String get googleDriveAppDataRecovery;

  /// User-visible copy: Provider not selected
  ///
  /// In en, this message translates to:
  /// **'Provider not selected'**
  String get providerNotSelected;

  /// User-visible copy: Pet export
  ///
  /// In en, this message translates to:
  /// **'Pet export'**
  String get petExport;

  /// User-visible copy: Export {value1}’s health history
  ///
  /// In en, this message translates to:
  /// **'Export {value1}’s health history'**
  String exportSHealthHistory(Object value1);

  /// User-visible copy: Copies you control
  ///
  /// In en, this message translates to:
  /// **'Copies you control'**
  String get copiesYouControl;

  /// User-visible copy: Choose a date range and create a vet-friendly PDF, CSV, or document package.
  ///
  /// In en, this message translates to:
  /// **'Choose a date range and create a vet-friendly PDF, CSV, or document package.'**
  String get chooseADateRangeAndCreateAVetFriendly;

  /// User-visible copy: Create an open backup, safely restore one, or save and share a focused pet health summary.
  ///
  /// In en, this message translates to:
  /// **'Create an open backup, safely restore one, or save and share a focused pet health summary.'**
  String get createAnOpenBackupSafelyRestoreOneOrSave;

  /// User-visible copy: Save-file and share actions open only when you choose them. Creaturely performs no upload on its own
  ///
  /// In en, this message translates to:
  /// **'Save-file and share actions open only when you choose them. Creaturely performs no upload on its own during normal journaling.'**
  String get saveFileAndShareActionsOpenOnlyWhenYou;

  /// User-visible copy: Whole-journal backup
  ///
  /// In en, this message translates to:
  /// **'Whole-journal backup'**
  String get wholeJournalBackup;

  /// User-visible copy: Create .creaturely backup
  ///
  /// In en, this message translates to:
  /// **'Create .creaturely backup'**
  String get createCreaturelyBackup;

  /// User-visible copy: {value1} animals • {value2} documents
  ///
  /// In en, this message translates to:
  /// **'{value1} animals • {value2} documents'**
  String animalsDocuments(Object value1, Object value2);

  /// User-visible copy: Restore from .creaturely
  ///
  /// In en, this message translates to:
  /// **'Restore from .creaturely'**
  String get restoreFromCreaturely;

  /// User-visible copy: Fully validated before an atomic replacement.
  ///
  /// In en, this message translates to:
  /// **'Fully validated before an atomic replacement.'**
  String get fullyValidatedBeforeAnAtomicReplacement;

  /// User-visible copy: Export options
  ///
  /// In en, this message translates to:
  /// **'Export options'**
  String get exportOptions;

  /// User-visible copy: Animal
  ///
  /// In en, this message translates to:
  /// **'Animal'**
  String get animal;

  /// User-visible copy: Date range
  ///
  /// In en, this message translates to:
  /// **'Date range'**
  String get dateRange;

  /// User-visible copy: Original documents to include
  ///
  /// In en, this message translates to:
  /// **'Original documents to include'**
  String get originalDocumentsToInclude;

  /// User-visible copy: No documents in this range.
  ///
  /// In en, this message translates to:
  /// **'No documents in this range.'**
  String get noDocumentsInThisRange;

  /// User-visible copy: Export or share
  ///
  /// In en, this message translates to:
  /// **'Export or share'**
  String get exportOrShare;

  /// User-visible copy: Save Creaturely backup
  ///
  /// In en, this message translates to:
  /// **'Save Creaturely backup'**
  String get saveCreaturelyBackup;

  /// User-visible copy: Creaturely backup saved.
  ///
  /// In en, this message translates to:
  /// **'Creaturely backup saved.'**
  String get creaturelyBackupSaved;

  /// User-visible copy: Backup could not be created
  ///
  /// In en, this message translates to:
  /// **'Backup could not be created'**
  String get backupCouldNotBeCreated;

  /// User-visible copy: Backup restored successfully.
  ///
  /// In en, this message translates to:
  /// **'Backup restored successfully.'**
  String get backupRestoredSuccessfully;

  /// User-visible copy: Restore stopped safely
  ///
  /// In en, this message translates to:
  /// **'Restore stopped safely'**
  String get restoreStoppedSafely;

  /// User-visible copy: Creaturely pet health summary
  ///
  /// In en, this message translates to:
  /// **'Creaturely pet health summary'**
  String get creaturelyPetHealthSummary;

  /// User-visible copy: Creaturely pet health export
  ///
  /// In en, this message translates to:
  /// **'Creaturely pet health export'**
  String get creaturelyPetHealthExport;

  /// User-visible copy: Export could not be shared
  ///
  /// In en, this message translates to:
  /// **'Export could not be shared'**
  String get exportCouldNotBeShared;

  /// User-visible copy: Save {value1} pet export
  ///
  /// In en, this message translates to:
  /// **'Save {value1} pet export'**
  String savePetExport(Object value1);

  /// User-visible copy: {value1} export saved.
  ///
  /// In en, this message translates to:
  /// **'{value1} export saved.'**
  String exportSaved(Object value1);

  /// User-visible copy: {value1} export could not be saved
  ///
  /// In en, this message translates to:
  /// **'{value1} export could not be saved'**
  String exportCouldNotBeSaved(Object value1);

  /// User-visible copy: PDF summary
  ///
  /// In en, this message translates to:
  /// **'PDF summary'**
  String get pdfSummary;

  /// User-visible copy: A readable overview of the selected dates.
  ///
  /// In en, this message translates to:
  /// **'A readable overview of the selected dates.'**
  String get aReadableOverviewOfTheSelectedDates;

  /// User-visible copy: CSV data
  ///
  /// In en, this message translates to:
  /// **'CSV data'**
  String get csvData;

  /// User-visible copy: Raw journal data for a spreadsheet.
  ///
  /// In en, this message translates to:
  /// **'Raw journal data for a spreadsheet.'**
  String get rawJournalDataForASpreadsheet;

  /// User-visible copy: ZIP package
  ///
  /// In en, this message translates to:
  /// **'ZIP package'**
  String get zipPackage;

  /// User-visible copy: PDF, CSV, and any selected original documents.
  ///
  /// In en, this message translates to:
  /// **'PDF, CSV, and any selected original documents.'**
  String get pdfCSVAndAnySelectedOriginalDocuments;

  /// User-visible copy: Choose export format
  ///
  /// In en, this message translates to:
  /// **'Choose export format'**
  String get chooseExportFormat;

  /// User-visible copy: Select one format, then save it to Files or share it with another app.
  ///
  /// In en, this message translates to:
  /// **'Select one format, then save it to Files or share it with another app.'**
  String get selectOneFormatThenSaveItToFilesOr;

  /// User-visible copy: Save to Files
  ///
  /// In en, this message translates to:
  /// **'Save to Files'**
  String get saveToFiles;

  /// User-visible copy: Share
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// User-visible copy: Replace this local journal?
  ///
  /// In en, this message translates to:
  /// **'Replace this local journal?'**
  String get replaceThisLocalJournal;

  /// User-visible copy: Validated backup from {value1}.
  ///
  /// {value2} animals, {value3} breathing sessions, {value4} medications
  ///
  /// In en, this message translates to:
  /// **'Validated backup from {value1}.\n\n{value2} animals, {value3} breathing sessions, {value4} medications, and {value5} documents.\n\nCreaturely will create a safety snapshot first. Nothing is partially imported.'**
  String validatedBackupFromAnimalsBreathingSessionsMedicationsAndDocuments(
    Object value1,
    Object value2,
    Object value3,
    Object value4,
    Object value5,
  );

  /// User-visible copy: Restore
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// User-visible copy: This removes the journal from this device
  ///
  /// In en, this message translates to:
  /// **'This removes the journal from this device'**
  String get thisRemovesTheJournalFromThisDevice;

  /// User-visible copy: Animal records, measurements, schedules, dose history, settings, and app-managed attachments will be
  ///
  /// In en, this message translates to:
  /// **'Animal records, measurements, schedules, dose history, settings, and app-managed attachments will be deleted. Backups you already saved are not affected.'**
  String get animalRecordsMeasurementsSchedulesDoseHistorySettingsAndApp;

  /// User-visible copy: Create a .creaturely backup first if you might want this journal again.
  ///
  /// In en, this message translates to:
  /// **'Create a .creaturely backup first if you might want this journal again.'**
  String get createACreaturelyBackupFirstIfYouMightWant;

  /// User-visible copy: Type DELETE to confirm
  ///
  /// In en, this message translates to:
  /// **'Type DELETE to confirm'**
  String get typeDELETEToConfirm;

  /// User-visible copy: DELETE
  ///
  /// In en, this message translates to:
  /// **'DELETE'**
  String get delete;

  /// User-visible copy: Delete everything local
  ///
  /// In en, this message translates to:
  /// **'Delete everything local'**
  String get deleteEverythingLocal;

  /// User-visible copy: Recovery snapshots
  ///
  /// In en, this message translates to:
  /// **'Recovery snapshots'**
  String get recoverySnapshots;

  /// User-visible copy: Optional recovery, not sync
  ///
  /// In en, this message translates to:
  /// **'Optional recovery, not sync'**
  String get optionalRecoveryNotSync;

  /// User-visible copy: Local data always wins during normal use. Private provider storage is used only after you opt in.
  ///
  /// In en, this message translates to:
  /// **'Local data always wins during normal use. Private provider storage is used only after you opt in.'**
  String get localDataAlwaysWinsDuringNormalUsePrivateProvider;

  /// User-visible copy: At most once a day • {value1}
  ///
  /// In en, this message translates to:
  /// **'At most once a day • {value1}'**
  String atMostOnceADay(Object value1);

  /// User-visible copy: Provider-managed encryption
  ///
  /// In en, this message translates to:
  /// **'Provider-managed encryption'**
  String get providerManagedEncryption;

  /// User-visible copy: Creaturely does not invent an account or custom encryption scheme.
  ///
  /// In en, this message translates to:
  /// **'Creaturely does not invent an account or custom encryption scheme.'**
  String get creaturelyDoesNotInventAnAccountOrCustomEncryption;

  /// User-visible copy: Back up now
  ///
  /// In en, this message translates to:
  /// **'Back up now'**
  String get backUpNow;

  /// User-visible copy: Check account access
  ///
  /// In en, this message translates to:
  /// **'Check account access'**
  String get checkAccountAccess;

  /// User-visible copy: Refresh recovery list
  ///
  /// In en, this message translates to:
  /// **'Refresh recovery list'**
  String get refreshRecoveryList;

  /// User-visible copy: Recovery points
  ///
  /// In en, this message translates to:
  /// **'Recovery points'**
  String get recoveryPoints;

  /// User-visible copy: No recovery snapshots
  ///
  /// In en, this message translates to:
  /// **'No recovery snapshots'**
  String get noRecoverySnapshots;

  /// User-visible copy: Create one when the provider is available.
  ///
  /// In en, this message translates to:
  /// **'Create one when the provider is available.'**
  String get createOneWhenTheProviderIsAvailable;

  /// User-visible copy: {value1} bytes
  ///
  /// In en, this message translates to:
  /// **'{value1} bytes'**
  String bytes(Object value1);

  /// User-visible copy: Creaturely keeps the newest recovery point, plus up to 7 daily, 4 weekly, and 6 monthly points. Olde
  ///
  /// In en, this message translates to:
  /// **'Creaturely keeps the newest recovery point, plus up to 7 daily, 4 weekly, and 6 monthly points. Older copies are removed automatically.'**
  String get creaturelyKeepsTheNewestRecoveryPointPlusUpTo;

  /// User-visible copy: Checking {value1}…
  ///
  /// In en, this message translates to:
  /// **'Checking {value1}…'**
  String checking(Object value1);

  /// User-visible copy: {value1} is available.
  ///
  /// In en, this message translates to:
  /// **'{value1} is available.'**
  String isAvailable(Object value1);

  /// User-visible copy: The platform cloud account is signed out. Local journaling remains available.
  ///
  /// In en, this message translates to:
  /// **'The platform cloud account is signed out. Local journaling remains available.'**
  String get thePlatformCloudAccountIsSignedOutLocalJournaling;

  /// User-visible copy: The cloud provider is offline. Local journaling remains available.
  ///
  /// In en, this message translates to:
  /// **'The cloud provider is offline. Local journaling remains available.'**
  String get theCloudProviderIsOfflineLocalJournalingRemainsAvailable;

  /// User-visible copy: Cloud storage is full. Existing local data is safe.
  ///
  /// In en, this message translates to:
  /// **'Cloud storage is full. Existing local data is safe.'**
  String get cloudStorageIsFullExistingLocalDataIsSafe;

  /// User-visible copy: The cloud provider reported a conflict. Existing local data was not changed.
  ///
  /// In en, this message translates to:
  /// **'The cloud provider reported a conflict. Existing local data was not changed.'**
  String get theCloudProviderReportedAConflictExistingLocalData;

  /// User-visible copy: This build is missing the platform recovery capability or release configuration.
  ///
  /// In en, this message translates to:
  /// **'This build is missing the platform recovery capability or release configuration.'**
  String get thisBuildIsMissingThePlatformRecoveryCapabilityOr;

  /// User-visible copy: Cloud recovery access was declined. Local use is unaffected.
  ///
  /// In en, this message translates to:
  /// **'Cloud recovery access was declined. Local use is unaffected.'**
  String get cloudRecoveryAccessWasDeclinedLocalUseIsUnaffected;

  /// User-visible copy: The cloud provider returned an error. Local use is unaffected.
  ///
  /// In en, this message translates to:
  /// **'The cloud provider returned an error. Local use is unaffected.'**
  String get theCloudProviderReturnedAnErrorLocalUseIs;

  /// User-visible copy: private CloudKit
  ///
  /// In en, this message translates to:
  /// **'private CloudKit'**
  String get privateCloudKit;

  /// User-visible copy: Google Drive appData
  ///
  /// In en, this message translates to:
  /// **'Google Drive appData'**
  String get googleDriveAppData;

  /// User-visible copy: platform recovery
  ///
  /// In en, this message translates to:
  /// **'platform recovery'**
  String get platformRecovery;

  /// User-visible copy: About Creaturely
  ///
  /// In en, this message translates to:
  /// **'About Creaturely'**
  String get aboutCreaturely;

  /// User-visible copy: GNU GPLv3 license
  ///
  /// In en, this message translates to:
  /// **'GNU GPLv3 license'**
  String get gnuGPLv3License;

  /// User-visible copy: LICENSE
  ///
  /// In en, this message translates to:
  /// **'LICENSE'**
  String get license;

  /// User-visible copy: Plain-language promise
  ///
  /// In en, this message translates to:
  /// **'Plain-language promise'**
  String get plainLanguagePromise;

  /// User-visible copy: Vector42 collects no Creaturely data. There is no account, analytics, advertising, crash-reporting S
  ///
  /// In en, this message translates to:
  /// **'Vector42 collects no Creaturely data. There is no account, analytics, advertising, crash-reporting SDK, backend, or proprietary health-data collection.'**
  String get vector42CollectsNoCreaturelyDataThereIsNoAccount;

  /// User-visible copy: On-device journal
  ///
  /// In en, this message translates to:
  /// **'On-device journal'**
  String get onDeviceJournal;

  /// User-visible copy: Normal operation uses local SQLite and app-managed files. Creaturely does not make network calls whi
  ///
  /// In en, this message translates to:
  /// **'Normal operation uses local SQLite and app-managed files. Creaturely does not make network calls while you browse, record, chart, or edit care.'**
  String get normalOperationUsesLocalSQLiteAndAppManagedFiles;

  /// User-visible copy: Copies you choose
  ///
  /// In en, this message translates to:
  /// **'Copies you choose'**
  String get copiesYouChoose;

  /// User-visible copy: When you explicitly save a backup or share a report, the selected file destination, app, or cloud pr
  ///
  /// In en, this message translates to:
  /// **'When you explicitly save a backup or share a report, the selected file destination, app, or cloud provider processes that file under its own terms. Optional recovery snapshots use private CloudKit on iOS or Google Drive appData on Android only after opt-in.'**
  String get whenYouExplicitlySaveABackupOrShareA;

  /// User-visible copy: Local file integrity
  ///
  /// In en, this message translates to:
  /// **'Local file integrity'**
  String get localFileIntegrity;

  /// User-visible copy: Imported documents stay in app-managed storage. Creaturely uses local checksums to show when a docum
  ///
  /// In en, this message translates to:
  /// **'Imported documents stay in app-managed storage. Creaturely uses local checksums to show when a document is missing or has changed, and converts stored weight values only for your chosen display unit.'**
  String get importedDocumentsStayInAppManagedStorageCreaturelyUses;

  /// User-visible copy: Your controls
  ///
  /// In en, this message translates to:
  /// **'Your controls'**
  String get yourControls;

  /// User-visible copy: You can export an open backup, restore it, archive individual animals, delete records, or delete the
  ///
  /// In en, this message translates to:
  /// **'You can export an open backup, restore it, archive individual animals, delete records, or delete the entire local journal from Data management.'**
  String get youCanExportAnOpenBackupRestoreItArchive;

  /// User-visible copy: Personal journal
  ///
  /// In en, this message translates to:
  /// **'Personal journal'**
  String get personalJournal;

  /// User-visible copy: Creaturely is free software provided to help one keeper organize information for animals on one acti
  ///
  /// In en, this message translates to:
  /// **'Creaturely is free software provided to help one keeper organize information for animals on one active device. You remain responsible for the accuracy of entries, backups, medication decisions, and veterinary care.'**
  String get creaturelyIsFreeSoftwareProvidedToHelpOneKeeper;

  /// User-visible copy: No warranty
  ///
  /// In en, this message translates to:
  /// **'No warranty'**
  String get noWarranty;

  /// User-visible copy: Creaturely is provided without warranty, to the extent permitted by law, under the GNU General Publi
  ///
  /// In en, this message translates to:
  /// **'Creaturely is provided without warranty, to the extent permitted by law, under the GNU General Public License version 3.'**
  String get creaturelyIsProvidedWithoutWarrantyToTheExtentPermitted;

  /// User-visible copy: Operating systems may delay or suppress reminders. Always use the care plan supplied by your veterin
  ///
  /// In en, this message translates to:
  /// **'Operating systems may delay or suppress reminders. Always use the care plan supplied by your veterinarian and do not rely on Creaturely as the sole medication safeguard.'**
  String get operatingSystemsMayDelayOrSuppressRemindersAlwaysUse;

  /// User-visible copy: Owner-supplied ranges
  ///
  /// In en, this message translates to:
  /// **'Owner-supplied ranges'**
  String get ownerSuppliedRanges;

  /// User-visible copy: Creaturely ships no species-wide clinical thresholds. Any minimum, target, or maximum shown was ente
  ///
  /// In en, this message translates to:
  /// **'Creaturely ships no species-wide clinical thresholds. Any minimum, target, or maximum shown was entered by you and should come from a care plan you trust.'**
  String get creaturelyShipsNoSpeciesWideClinicalThresholdsAnyMinimum;

  /// User-visible copy: Neutral descriptions
  ///
  /// In en, this message translates to:
  /// **'Neutral descriptions'**
  String get neutralDescriptions;

  /// User-visible copy: Above, below, and in-range labels compare a measurement only with your saved values. They are not di
  ///
  /// In en, this message translates to:
  /// **'Above, below, and in-range labels compare a measurement only with your saved values. They are not diagnoses, risk scores, or predictions.'**
  String get aboveBelowAndInRangeLabelsCompareAMeasurement;

  /// User-visible copy: Manual breathing observations
  ///
  /// In en, this message translates to:
  /// **'Manual breathing observations'**
  String get manualBreathingObservations;

  /// User-visible copy: Breathing entries come from keeper taps. They are not phone-sensor readings and do not measure heart
  ///
  /// In en, this message translates to:
  /// **'Breathing entries come from keeper taps. They are not phone-sensor readings and do not measure heart rate.'**
  String get breathingEntriesComeFromKeeperTapsTheyAreNot;

  /// User-visible copy: When concerned
  ///
  /// In en, this message translates to:
  /// **'When concerned'**
  String get whenConcerned;

  /// User-visible copy: Contact a veterinarian or appropriate emergency service when an animal appears unwell or you are wor
  ///
  /// In en, this message translates to:
  /// **'Contact a veterinarian or appropriate emergency service when an animal appears unwell or you are worried. Do not delay care to take or enter a measurement.'**
  String get contactAVeterinarianOrAppropriateEmergencyServiceWhenAn;

  /// User-visible copy: Calm care, made visible.
  ///
  /// In en, this message translates to:
  /// **'Calm care, made visible.'**
  String get calmCareMadeVisible;

  /// User-visible copy: Creaturely makes everyday pet observations easier to understand, remember, and share.
  ///
  /// In en, this message translates to:
  /// **'Creaturely makes everyday pet observations easier to understand, remember, and share.'**
  String get creaturelyMakesEverydayPetObservationsEasierToUnderstandRemember;

  /// User-visible copy: Creaturely 1.0
  ///
  /// In en, this message translates to:
  /// **'Creaturely 1.0'**
  String get creaturely10;

  /// User-visible copy: A local-first pet-health journal published by Vector42 for Android and iOS. Application identifier:
  ///
  /// In en, this message translates to:
  /// **'A local-first pet-health journal published by Vector42 for Android and iOS. Application identifier: com.vector42.creaturely.'**
  String get aLocalFirstPetHealthJournalPublishedByVector42;

  /// User-visible copy: Free and open source
  ///
  /// In en, this message translates to:
  /// **'Free and open source'**
  String get freeAndOpenSource;

  /// User-visible copy: Read the GNU GPLv3 license
  ///
  /// In en, this message translates to:
  /// **'Read the GNU GPLv3 license'**
  String get readTheGNUGPLv3License;

  /// User-visible copy: Open-source package licenses
  ///
  /// In en, this message translates to:
  /// **'Open-source package licenses'**
  String get openSourcePackageLicenses;

  /// User-visible copy: © Vector42 • GNU GPLv3
  ///
  /// In en, this message translates to:
  /// **'© Vector42 • GNU GPLv3'**
  String get vector42GNUGPLv3;

  /// User-visible copy: No animal selected
  ///
  /// In en, this message translates to:
  /// **'No animal selected'**
  String get noAnimalSelected;

  /// User-visible copy: Add an animal to create a care schedule.
  ///
  /// In en, this message translates to:
  /// **'Add an animal to create a care schedule.'**
  String get addAnAnimalToCreateACareSchedule;

  /// User-visible copy: Add scheduled care
  ///
  /// In en, this message translates to:
  /// **'Add scheduled care'**
  String get addScheduledCare;

  /// User-visible copy: Breathing reminder
  ///
  /// In en, this message translates to:
  /// **'Breathing reminder'**
  String get breathingReminder;

  /// User-visible copy: Weight check reminder
  ///
  /// In en, this message translates to:
  /// **'Weight check reminder'**
  String get weightCheckReminder;

  /// User-visible copy: {value1}’s schedule
  ///
  /// In en, this message translates to:
  /// **'{value1}’s schedule'**
  String sSchedule(Object value1);

  /// User-visible copy: Medication, breathing checks, and weight checks.
  ///
  /// In en, this message translates to:
  /// **'Medication, breathing checks, and weight checks.'**
  String get medicationBreathingChecksAndWeightChecks;

  /// User-visible copy: Today
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// User-visible copy: 7 days
  ///
  /// In en, this message translates to:
  /// **'7 days'**
  String get label7Days;

  /// User-visible copy: Schedules
  ///
  /// In en, this message translates to:
  /// **'Schedules'**
  String get schedules;

  /// User-visible copy: Notifications are off. Your care schedule still works here in Creaturely.
  ///
  /// In en, this message translates to:
  /// **'Notifications are off. Your care schedule still works here in Creaturely.'**
  String get notificationsAreOffYourCareScheduleStillWorksHere;

  /// User-visible copy: Nothing scheduled today
  ///
  /// In en, this message translates to:
  /// **'Nothing scheduled today'**
  String get nothingScheduledToday;

  /// User-visible copy: Nothing scheduled in the next 7 days
  ///
  /// In en, this message translates to:
  /// **'Nothing scheduled in the next 7 days'**
  String get nothingScheduledInTheNext7Days;

  /// User-visible copy: Use Add to create a breathing reminder, medication, or weight check.
  ///
  /// In en, this message translates to:
  /// **'Use Add to create a breathing reminder, medication, or weight check.'**
  String get useAddToCreateABreathingReminderMedicationOr;

  /// User-visible copy: No saved schedules
  ///
  /// In en, this message translates to:
  /// **'No saved schedules'**
  String get noSavedSchedules;

  /// User-visible copy: Breathing reminders
  ///
  /// In en, this message translates to:
  /// **'Breathing reminders'**
  String get breathingReminders;

  /// User-visible copy: Medication schedules
  ///
  /// In en, this message translates to:
  /// **'Medication schedules'**
  String get medicationSchedules;

  /// User-visible copy: Weight check reminders
  ///
  /// In en, this message translates to:
  /// **'Weight check reminders'**
  String get weightCheckReminders;

  /// User-visible copy: Delete breathing reminder?
  ///
  /// In en, this message translates to:
  /// **'Delete breathing reminder?'**
  String get deleteBreathingReminder;

  /// User-visible copy: This removes future prompts. Saved breathing measurements are unchanged.
  ///
  /// In en, this message translates to:
  /// **'This removes future prompts. Saved breathing measurements are unchanged.'**
  String get thisRemovesFuturePromptsSavedBreathingMeasurementsAreUnchanged;

  /// User-visible copy: Delete
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete2;

  /// User-visible copy: Delete weight check reminder?
  ///
  /// In en, this message translates to:
  /// **'Delete weight check reminder?'**
  String get deleteWeightCheckReminder;

  /// User-visible copy: This removes future prompts. Saved weight measurements are unchanged.
  ///
  /// In en, this message translates to:
  /// **'This removes future prompts. Saved weight measurements are unchanged.'**
  String get thisRemovesFuturePromptsSavedWeightMeasurementsAreUnchanged;

  /// User-visible copy: Tomorrow
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// User-visible copy: Given
  ///
  /// In en, this message translates to:
  /// **'Given'**
  String get given;

  /// User-visible copy: Skip
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// User-visible copy: Start breathing check
  ///
  /// In en, this message translates to:
  /// **'Start breathing check'**
  String get startBreathingCheck;

  /// User-visible copy: Record weight
  ///
  /// In en, this message translates to:
  /// **'Record weight'**
  String get recordWeight;

  /// User-visible copy: Skipped
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get skipped;

  /// User-visible copy: Missed
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get missed;

  /// User-visible copy: Every day
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get everyDay;

  /// User-visible copy: Sleeping
  ///
  /// In en, this message translates to:
  /// **'Sleeping'**
  String get sleeping;

  /// User-visible copy: Resting
  ///
  /// In en, this message translates to:
  /// **'Resting'**
  String get resting;

  /// User-visible copy: {value1} breathing check
  ///
  /// In en, this message translates to:
  /// **'{value1} breathing check'**
  String breathingCheck(Object value1);

  /// User-visible copy: Breathing reminder options
  ///
  /// In en, this message translates to:
  /// **'Breathing reminder options'**
  String get breathingReminderOptions;

  /// User-visible copy: Edit
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// User-visible copy: Active
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// User-visible copy: Paused
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get paused;

  /// User-visible copy: Mon
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mon;

  /// User-visible copy: Tue
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tue;

  /// User-visible copy: Wed
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wed;

  /// User-visible copy: Thu
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thu;

  /// User-visible copy: Fri
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fri;

  /// User-visible copy: Sat
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get sat;

  /// User-visible copy: Sun
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sun;

  /// User-visible copy: Weight check
  ///
  /// In en, this message translates to:
  /// **'Weight check'**
  String get weightCheck;

  /// User-visible copy: Weight reminder options
  ///
  /// In en, this message translates to:
  /// **'Weight reminder options'**
  String get weightReminderOptions;

  /// User-visible copy: No active times
  ///
  /// In en, this message translates to:
  /// **'No active times'**
  String get noActiveTimes;

  /// User-visible copy: Daily • {value1}
  ///
  /// In en, this message translates to:
  /// **'Daily • {value1}'**
  String daily(Object value1);

  /// User-visible copy: Selected days • {value1}
  ///
  /// In en, this message translates to:
  /// **'Selected days • {value1}'**
  String selectedDays(Object value1);

  /// User-visible copy: Every {value1} hours • starts {value2}
  ///
  /// In en, this message translates to:
  /// **'Every {value1} hours • starts {value2}'**
  String everyHoursStarts(Object value1, Object value2);

  /// User-visible copy: Repeat
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get repeat;

  /// User-visible copy: Selected weekdays
  ///
  /// In en, this message translates to:
  /// **'Selected weekdays'**
  String get selectedWeekdays;

  /// User-visible copy: Reminder times
  ///
  /// In en, this message translates to:
  /// **'Reminder times'**
  String get reminderTimes;

  /// User-visible copy: Add time
  ///
  /// In en, this message translates to:
  /// **'Add time'**
  String get addTime;

  /// User-visible copy: Add at least one time.
  ///
  /// In en, this message translates to:
  /// **'Add at least one time.'**
  String get addAtLeastOneTime;

  /// User-visible copy: Remove {value1}
  ///
  /// In en, this message translates to:
  /// **'Remove {value1}'**
  String remove(Object value1);

  /// User-visible copy: Animal not found.
  ///
  /// In en, this message translates to:
  /// **'Animal not found.'**
  String get animalNotFound;

  /// User-visible copy: Add weight reminder
  ///
  /// In en, this message translates to:
  /// **'Add weight reminder'**
  String get addWeightReminder;

  /// User-visible copy: Edit weight reminder
  ///
  /// In en, this message translates to:
  /// **'Edit weight reminder'**
  String get editWeightReminder;

  /// User-visible copy: Weight check for {value1}
  ///
  /// In en, this message translates to:
  /// **'Weight check for {value1}'**
  String weightCheckFor(Object value1);

  /// User-visible copy: Choose when you want a gentle prompt to record a weigh-in.
  ///
  /// In en, this message translates to:
  /// **'Choose when you want a gentle prompt to record a weigh-in.'**
  String get chooseWhenYouWantAGentlePromptToRecord;

  /// User-visible copy: Notifications are off. This reminder will still appear in Schedule.
  ///
  /// In en, this message translates to:
  /// **'Notifications are off. This reminder will still appear in Schedule.'**
  String get notificationsAreOffThisReminderWillStillAppearIn;

  /// User-visible copy: Turn on notifications
  ///
  /// In en, this message translates to:
  /// **'Turn on notifications'**
  String get turnOnNotifications;

  /// User-visible copy: Start date
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get startDate;

  /// User-visible copy: End date
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get endDate;

  /// User-visible copy: No end date
  ///
  /// In en, this message translates to:
  /// **'No end date'**
  String get noEndDate;

  /// User-visible copy: Reminder active
  ///
  /// In en, this message translates to:
  /// **'Reminder active'**
  String get reminderActive;

  /// User-visible copy: Turn this off without deleting the schedule.
  ///
  /// In en, this message translates to:
  /// **'Turn this off without deleting the schedule.'**
  String get turnThisOffWithoutDeletingTheSchedule;

  /// User-visible copy: Save reminder
  ///
  /// In en, this message translates to:
  /// **'Save reminder'**
  String get saveReminder;

  /// User-visible copy: Add at least one reminder time.
  ///
  /// In en, this message translates to:
  /// **'Add at least one reminder time.'**
  String get addAtLeastOneReminderTime;

  /// User-visible copy: Choose at least one weekday.
  ///
  /// In en, this message translates to:
  /// **'Choose at least one weekday.'**
  String get chooseAtLeastOneWeekday;

  /// User-visible copy: The end date must be on or after the start date.
  ///
  /// In en, this message translates to:
  /// **'The end date must be on or after the start date.'**
  String get theEndDateMustBeOnOrAfterThe;

  /// User-visible copy: Could not save. Your changes are kept here; try again.
  ///
  /// In en, this message translates to:
  /// **'Could not save. Your changes are kept here; try again.'**
  String get couldNotSaveYourChangesAreKeptHereTry;

  /// User-visible copy: Clear end date
  ///
  /// In en, this message translates to:
  /// **'Clear end date'**
  String get clearEndDate;

  /// User-visible copy: Add breathing reminder
  ///
  /// In en, this message translates to:
  /// **'Add breathing reminder'**
  String get addBreathingReminder;

  /// User-visible copy: Edit breathing reminder
  ///
  /// In en, this message translates to:
  /// **'Edit breathing reminder'**
  String get editBreathingReminder;

  /// User-visible copy: Breathing check for {value1}
  ///
  /// In en, this message translates to:
  /// **'Breathing check for {value1}'**
  String breathingCheckFor(Object value1);

  /// User-visible copy: Choose when you want a gentle prompt to take a manual reading.
  ///
  /// In en, this message translates to:
  /// **'Choose when you want a gentle prompt to take a manual reading.'**
  String get chooseWhenYouWantAGentlePromptToTake;

  /// User-visible copy: Observation context
  ///
  /// In en, this message translates to:
  /// **'Observation context'**
  String get observationContext;

  /// User-visible copy: Weigh-in
  ///
  /// In en, this message translates to:
  /// **'Weigh-in'**
  String get weighIn;

  /// User-visible copy: Add health record
  ///
  /// In en, this message translates to:
  /// **'Add health record'**
  String get addHealthRecord;

  /// User-visible copy: Edit health record
  ///
  /// In en, this message translates to:
  /// **'Edit health record'**
  String get editHealthRecord;

  /// User-visible copy: A note about {value1}
  ///
  /// In en, this message translates to:
  /// **'A note about {value1}'**
  String aNoteAbout(Object value1);

  /// User-visible copy: Record what you observed without turning the animal into a condition.
  ///
  /// In en, this message translates to:
  /// **'Record what you observed without turning the animal into a condition.'**
  String get recordWhatYouObservedWithoutTurningTheAnimalInto;

  /// User-visible copy: Record type
  ///
  /// In en, this message translates to:
  /// **'Record type'**
  String get recordType;

  /// User-visible copy: Allergy or sensitivity
  ///
  /// In en, this message translates to:
  /// **'Allergy or sensitivity'**
  String get allergyOrSensitivity;

  /// User-visible copy: Condition or body issue
  ///
  /// In en, this message translates to:
  /// **'Condition or body issue'**
  String get conditionOrBodyIssue;

  /// User-visible copy: Custom observation
  ///
  /// In en, this message translates to:
  /// **'Custom observation'**
  String get customObservation;

  /// User-visible copy: Label
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get label;

  /// User-visible copy: Name or observation *
  ///
  /// In en, this message translates to:
  /// **'Name or observation *'**
  String get nameOrObservation;

  /// User-visible copy: Enter a short label.
  ///
  /// In en, this message translates to:
  /// **'Enter a short label.'**
  String get enterAShortLabel;

  /// User-visible copy: Weight *
  ///
  /// In en, this message translates to:
  /// **'Weight *'**
  String get weight2;

  /// User-visible copy: Enter a positive weight.
  ///
  /// In en, this message translates to:
  /// **'Enter a positive weight.'**
  String get enterAPositiveWeight;

  /// User-visible copy: Unit
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// User-visible copy: Date
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// User-visible copy: Notes
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// User-visible copy: Save record
  ///
  /// In en, this message translates to:
  /// **'Save record'**
  String get saveRecord;

  /// User-visible copy: No trends yet
  ///
  /// In en, this message translates to:
  /// **'No trends yet'**
  String get noTrendsYet;

  /// User-visible copy: Add an animal and record measurements to see descriptive trends.
  ///
  /// In en, this message translates to:
  /// **'Add an animal and record measurements to see descriptive trends.'**
  String get addAnAnimalAndRecordMeasurementsToSeeDescriptive;

  /// User-visible copy: Show chart
  ///
  /// In en, this message translates to:
  /// **'Show chart'**
  String get showChart;

  /// User-visible copy: Show measurement list
  ///
  /// In en, this message translates to:
  /// **'Show measurement list'**
  String get showMeasurementList;

  /// User-visible copy: Choose another range or record a new measurement from the Animals dashboard.
  ///
  /// In en, this message translates to:
  /// **'Choose another range or record a new measurement from the Animals dashboard.'**
  String get chooseAnotherRangeOrRecordANewMeasurementFrom;

  /// User-visible copy: Sparse data: each saved measurement is shown; a line is not interpreted as a forecast.
  ///
  /// In en, this message translates to:
  /// **'Sparse data: each saved measurement is shown; a line is not interpreted as a forecast.'**
  String get sparseDataEachSavedMeasurementIsShownALine;

  /// User-visible copy: Descriptive view only: latest, average, and observed range. No predictions or diagnosis.
  ///
  /// In en, this message translates to:
  /// **'Descriptive view only: latest, average, and observed range. No predictions or diagnosis.'**
  String get descriptiveViewOnlyLatestAverageAndObservedRangeNo;

  /// User-visible copy: No medication outcomes in this range
  ///
  /// In en, this message translates to:
  /// **'No medication outcomes in this range'**
  String get noMedicationOutcomesInThisRange;

  /// User-visible copy: Given, skipped, and missed doses will appear here after they are recorded.
  ///
  /// In en, this message translates to:
  /// **'Given, skipped, and missed doses will appear here after they are recorded.'**
  String get givenSkippedAndMissedDosesWillAppearHereAfter;

  /// User-visible copy: By medication
  ///
  /// In en, this message translates to:
  /// **'By medication'**
  String get byMedication;

  /// User-visible copy: Counts reflect the dose statuses recorded in this date range.
  ///
  /// In en, this message translates to:
  /// **'Counts reflect the dose statuses recorded in this date range.'**
  String get countsReflectTheDoseStatusesRecordedInThisDate;

  /// User-visible copy: {value1} given • {value2} skipped • {value3} missed
  ///
  /// In en, this message translates to:
  /// **'{value1} given • {value2} skipped • {value3} missed'**
  String givenSkippedMissed(Object value1, Object value2, Object value3);

  /// User-visible copy: Custom
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// User-visible copy: All
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// User-visible copy: Latest
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get latest;

  /// User-visible copy: Average
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get average;

  /// User-visible copy: Observed range
  ///
  /// In en, this message translates to:
  /// **'Observed range'**
  String get observedRange;

  /// User-visible copy: {value1} measurements. Latest {value2} {value3}. Observed range {value4} to {value5} {value6}.
  ///
  /// In en, this message translates to:
  /// **'{value1} measurements. Latest {value2} {value3}. Observed range {value4} to {value5} {value6}.'**
  String measurementsLatestObservedRangeTo(
    Object value1,
    Object value2,
    Object value3,
    Object value4,
    Object value5,
    Object value6,
  );

  /// User-visible copy: Accessible measurement list with {value1} rows
  ///
  /// In en, this message translates to:
  /// **'Accessible measurement list with {value1} rows'**
  String accessibleMeasurementListWithRows(Object value1);

  /// User-visible copy: Date and time
  ///
  /// In en, this message translates to:
  /// **'Date and time'**
  String get dateAndTime;

  /// User-visible copy: Measurement
  ///
  /// In en, this message translates to:
  /// **'Measurement'**
  String get measurement;

  /// User-visible copy: Recorded as
  ///
  /// In en, this message translates to:
  /// **'Recorded as'**
  String get recordedAs;

  /// User-visible copy: Recorded as {value1}
  ///
  /// In en, this message translates to:
  /// **'Recorded as {value1}'**
  String recordedAs2(Object value1);

  /// User-visible copy: Other
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// User-visible copy: Dog
  ///
  /// In en, this message translates to:
  /// **'Dog'**
  String get dog;

  /// User-visible copy: Cat
  ///
  /// In en, this message translates to:
  /// **'Cat'**
  String get cat;

  /// User-visible copy: Bird
  ///
  /// In en, this message translates to:
  /// **'Bird'**
  String get bird;

  /// User-visible copy: Rabbit
  ///
  /// In en, this message translates to:
  /// **'Rabbit'**
  String get rabbit;

  /// User-visible copy: Reptile
  ///
  /// In en, this message translates to:
  /// **'Reptile'**
  String get reptile;

  /// User-visible copy: Horse
  ///
  /// In en, this message translates to:
  /// **'Horse'**
  String get horse;

  /// User-visible copy: Fish
  ///
  /// In en, this message translates to:
  /// **'Fish'**
  String get fish;

  /// User-visible copy: Mixed breed
  ///
  /// In en, this message translates to:
  /// **'Mixed breed'**
  String get mixedBreed;

  /// User-visible copy: Labrador Retriever
  ///
  /// In en, this message translates to:
  /// **'Labrador Retriever'**
  String get labradorRetriever;

  /// User-visible copy: Golden Retriever
  ///
  /// In en, this message translates to:
  /// **'Golden Retriever'**
  String get goldenRetriever;

  /// User-visible copy: German Shepherd
  ///
  /// In en, this message translates to:
  /// **'German Shepherd'**
  String get germanShepherd;

  /// User-visible copy: French Bulldog
  ///
  /// In en, this message translates to:
  /// **'French Bulldog'**
  String get frenchBulldog;

  /// User-visible copy: Poodle
  ///
  /// In en, this message translates to:
  /// **'Poodle'**
  String get poodle;

  /// User-visible copy: Beagle
  ///
  /// In en, this message translates to:
  /// **'Beagle'**
  String get beagle;

  /// User-visible copy: Dachshund
  ///
  /// In en, this message translates to:
  /// **'Dachshund'**
  String get dachshund;

  /// User-visible copy: Australian Shepherd
  ///
  /// In en, this message translates to:
  /// **'Australian Shepherd'**
  String get australianShepherd;

  /// User-visible copy: Border Collie
  ///
  /// In en, this message translates to:
  /// **'Border Collie'**
  String get borderCollie;

  /// User-visible copy: Chihuahua
  ///
  /// In en, this message translates to:
  /// **'Chihuahua'**
  String get chihuahua;

  /// User-visible copy: Shih Tzu
  ///
  /// In en, this message translates to:
  /// **'Shih Tzu'**
  String get shihTzu;

  /// User-visible copy: Yorkshire Terrier
  ///
  /// In en, this message translates to:
  /// **'Yorkshire Terrier'**
  String get yorkshireTerrier;

  /// User-visible copy: Boxer
  ///
  /// In en, this message translates to:
  /// **'Boxer'**
  String get boxer;

  /// User-visible copy: Siberian Husky
  ///
  /// In en, this message translates to:
  /// **'Siberian Husky'**
  String get siberianHusky;

  /// User-visible copy: Domestic Shorthair
  ///
  /// In en, this message translates to:
  /// **'Domestic Shorthair'**
  String get domesticShorthair;

  /// User-visible copy: Domestic Longhair
  ///
  /// In en, this message translates to:
  /// **'Domestic Longhair'**
  String get domesticLonghair;

  /// User-visible copy: Maine Coon
  ///
  /// In en, this message translates to:
  /// **'Maine Coon'**
  String get maineCoon;

  /// User-visible copy: Siamese
  ///
  /// In en, this message translates to:
  /// **'Siamese'**
  String get siamese;

  /// User-visible copy: Ragdoll
  ///
  /// In en, this message translates to:
  /// **'Ragdoll'**
  String get ragdoll;

  /// User-visible copy: Bengal
  ///
  /// In en, this message translates to:
  /// **'Bengal'**
  String get bengal;

  /// User-visible copy: British Shorthair
  ///
  /// In en, this message translates to:
  /// **'British Shorthair'**
  String get britishShorthair;

  /// User-visible copy: Persian
  ///
  /// In en, this message translates to:
  /// **'Persian'**
  String get persian;

  /// User-visible copy: Sphynx
  ///
  /// In en, this message translates to:
  /// **'Sphynx'**
  String get sphynx;

  /// User-visible copy: Russian Blue
  ///
  /// In en, this message translates to:
  /// **'Russian Blue'**
  String get russianBlue;

  /// User-visible copy: Abyssinian
  ///
  /// In en, this message translates to:
  /// **'Abyssinian'**
  String get abyssinian;

  /// User-visible copy: Mixed or hybrid
  ///
  /// In en, this message translates to:
  /// **'Mixed or hybrid'**
  String get mixedOrHybrid;

  /// User-visible copy: Budgerigar
  ///
  /// In en, this message translates to:
  /// **'Budgerigar'**
  String get budgerigar;

  /// User-visible copy: Cockatiel
  ///
  /// In en, this message translates to:
  /// **'Cockatiel'**
  String get cockatiel;

  /// User-visible copy: African Grey
  ///
  /// In en, this message translates to:
  /// **'African Grey'**
  String get africanGrey;

  /// User-visible copy: Canary
  ///
  /// In en, this message translates to:
  /// **'Canary'**
  String get canary;

  /// User-visible copy: Lovebird
  ///
  /// In en, this message translates to:
  /// **'Lovebird'**
  String get lovebird;

  /// User-visible copy: Conure
  ///
  /// In en, this message translates to:
  /// **'Conure'**
  String get conure;

  /// User-visible copy: Finch
  ///
  /// In en, this message translates to:
  /// **'Finch'**
  String get finch;

  /// User-visible copy: Macaw
  ///
  /// In en, this message translates to:
  /// **'Macaw'**
  String get macaw;

  /// User-visible copy: Holland Lop
  ///
  /// In en, this message translates to:
  /// **'Holland Lop'**
  String get hollandLop;

  /// User-visible copy: Mini Rex
  ///
  /// In en, this message translates to:
  /// **'Mini Rex'**
  String get miniRex;

  /// User-visible copy: Netherland Dwarf
  ///
  /// In en, this message translates to:
  /// **'Netherland Dwarf'**
  String get netherlandDwarf;

  /// User-visible copy: Lionhead
  ///
  /// In en, this message translates to:
  /// **'Lionhead'**
  String get lionhead;

  /// User-visible copy: Flemish Giant
  ///
  /// In en, this message translates to:
  /// **'Flemish Giant'**
  String get flemishGiant;

  /// User-visible copy: English Lop
  ///
  /// In en, this message translates to:
  /// **'English Lop'**
  String get englishLop;

  /// User-visible copy: Quarter Horse
  ///
  /// In en, this message translates to:
  /// **'Quarter Horse'**
  String get quarterHorse;

  /// User-visible copy: Thoroughbred
  ///
  /// In en, this message translates to:
  /// **'Thoroughbred'**
  String get thoroughbred;

  /// User-visible copy: Arabian
  ///
  /// In en, this message translates to:
  /// **'Arabian'**
  String get arabian;

  /// User-visible copy: Appaloosa
  ///
  /// In en, this message translates to:
  /// **'Appaloosa'**
  String get appaloosa;

  /// User-visible copy: Paint Horse
  ///
  /// In en, this message translates to:
  /// **'Paint Horse'**
  String get paintHorse;

  /// User-visible copy: Warmblood
  ///
  /// In en, this message translates to:
  /// **'Warmblood'**
  String get warmblood;

  /// User-visible copy: Morgan
  ///
  /// In en, this message translates to:
  /// **'Morgan'**
  String get morgan;

  /// User-visible copy: Bearded Dragon
  ///
  /// In en, this message translates to:
  /// **'Bearded Dragon'**
  String get beardedDragon;

  /// User-visible copy: Leopard Gecko
  ///
  /// In en, this message translates to:
  /// **'Leopard Gecko'**
  String get leopardGecko;

  /// User-visible copy: Ball Python
  ///
  /// In en, this message translates to:
  /// **'Ball Python'**
  String get ballPython;

  /// User-visible copy: Corn Snake
  ///
  /// In en, this message translates to:
  /// **'Corn Snake'**
  String get cornSnake;

  /// User-visible copy: Crested Gecko
  ///
  /// In en, this message translates to:
  /// **'Crested Gecko'**
  String get crestedGecko;

  /// User-visible copy: Red-eared Slider
  ///
  /// In en, this message translates to:
  /// **'Red-eared Slider'**
  String get redEaredSlider;

  /// User-visible copy: Betta
  ///
  /// In en, this message translates to:
  /// **'Betta'**
  String get betta;

  /// User-visible copy: Goldfish
  ///
  /// In en, this message translates to:
  /// **'Goldfish'**
  String get goldfish;

  /// User-visible copy: Guppy
  ///
  /// In en, this message translates to:
  /// **'Guppy'**
  String get guppy;

  /// User-visible copy: Angelfish
  ///
  /// In en, this message translates to:
  /// **'Angelfish'**
  String get angelfish;

  /// User-visible copy: Tetra
  ///
  /// In en, this message translates to:
  /// **'Tetra'**
  String get tetra;

  /// User-visible copy: Cichlid
  ///
  /// In en, this message translates to:
  /// **'Cichlid'**
  String get cichlid;

  /// User-visible copy: Use zero or a positive number.
  ///
  /// In en, this message translates to:
  /// **'Use zero or a positive number.'**
  String get useZeroOrAPositiveNumber;

  /// User-visible copy: Species *
  ///
  /// In en, this message translates to:
  /// **'Species *'**
  String get species;

  /// User-visible copy: Choose a common species or enter your own
  ///
  /// In en, this message translates to:
  /// **'Choose a common species or enter your own'**
  String get chooseACommonSpeciesOrEnterYourOwn;

  /// User-visible copy: Species name *
  ///
  /// In en, this message translates to:
  /// **'Species name *'**
  String get speciesName;

  /// User-visible copy: Enter the species.
  ///
  /// In en, this message translates to:
  /// **'Enter the species.'**
  String get enterTheSpecies;

  /// User-visible copy: Breed or variety (optional)
  ///
  /// In en, this message translates to:
  /// **'Breed or variety (optional)'**
  String get breedOrVarietyOptional;

  /// User-visible copy: Free-form entry; multiple breeds are welcome
  ///
  /// In en, this message translates to:
  /// **'Free-form entry; multiple breeds are welcome'**
  String get freeFormEntryMultipleBreedsAreWelcome;

  /// User-visible copy: Choose a suggestion or type any breed or mix
  ///
  /// In en, this message translates to:
  /// **'Choose a suggestion or type any breed or mix'**
  String get chooseASuggestionOrTypeAnyBreedOrMix;

  /// User-visible copy: Minimum respiratory rate can't be higher than target or maximum.
  ///
  /// In en, this message translates to:
  /// **'Minimum respiratory rate can\'\'t be higher than target or maximum.'**
  String get minimumRespiratoryRateCanTBeHigherThanTarget;

  /// User-visible copy: Target respiratory rate can't be higher than maximum or lower than minimum.
  ///
  /// In en, this message translates to:
  /// **'Target respiratory rate can\'\'t be higher than maximum or lower than minimum.'**
  String get targetRespiratoryRateCanTBeHigherThanMaximum;

  /// User-visible copy: Maximum respiratory rate can't be lower than target or minimum.
  ///
  /// In en, this message translates to:
  /// **'Maximum respiratory rate can\'\'t be lower than target or minimum.'**
  String get maximumRespiratoryRateCanTBeLowerThanTarget;

  /// User-visible copy: Minimum
  ///
  /// In en, this message translates to:
  /// **'Minimum'**
  String get minimum;

  /// User-visible copy: Target
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get target;

  /// User-visible copy: Maximum
  ///
  /// In en, this message translates to:
  /// **'Maximum'**
  String get maximum;

  /// User-visible copy: Resting respiratory rate
  ///
  /// In en, this message translates to:
  /// **'Resting respiratory rate'**
  String get restingRespiratoryRate;

  /// User-visible copy: Optional. Only enter values supplied by you or your veterinarian. Creaturely does not provide specie
  ///
  /// In en, this message translates to:
  /// **'Optional. Only enter values supplied by you or your veterinarian. Creaturely does not provide species-wide clinical defaults.'**
  String get optionalOnlyEnterValuesSuppliedByYouOrYour;

  /// User-visible copy: All values use breaths/min. Leave any field blank if it is unknown.
  ///
  /// In en, this message translates to:
  /// **'All values use breaths/min. Leave any field blank if it is unknown.'**
  String get allValuesUseBreathsMinLeaveAnyFieldBlank;

  /// User-visible copy: Edit {value1}
  ///
  /// In en, this message translates to:
  /// **'Edit {value1}'**
  String edit2(Object value1);

  /// User-visible copy: Choose animal photo
  ///
  /// In en, this message translates to:
  /// **'Choose animal photo'**
  String get chooseAnimalPhoto;

  /// User-visible copy: Name *
  ///
  /// In en, this message translates to:
  /// **'Name *'**
  String get name;

  /// User-visible copy: Sex (optional)
  ///
  /// In en, this message translates to:
  /// **'Sex (optional)'**
  String get sexOptional;

  /// User-visible copy: Male
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// User-visible copy: Female
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// User-visible copy: Not specified
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get notSpecified;

  /// User-visible copy: Date of birth
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get dateOfBirth;

  /// User-visible copy: Clear date of birth
  ///
  /// In en, this message translates to:
  /// **'Clear date of birth'**
  String get clearDateOfBirth;

  /// User-visible copy: Not supplied
  ///
  /// In en, this message translates to:
  /// **'Not supplied'**
  String get notSupplied;

  /// User-visible copy: Age (months)
  ///
  /// In en, this message translates to:
  /// **'Age (months)'**
  String get ageMonths;

  /// User-visible copy: Optional estimate
  ///
  /// In en, this message translates to:
  /// **'Optional estimate'**
  String get optionalEstimate;

  /// User-visible copy: Calculated from birth date
  ///
  /// In en, this message translates to:
  /// **'Calculated from birth date'**
  String get calculatedFromBirthDate;

  /// User-visible copy: Color and markings
  ///
  /// In en, this message translates to:
  /// **'Color and markings'**
  String get colorAndMarkings;

  /// User-visible copy: Current weight ({value1})
  ///
  /// In en, this message translates to:
  /// **'Current weight ({value1})'**
  String currentWeight2(Object value1);

  /// User-visible copy: Identifiers
  ///
  /// In en, this message translates to:
  /// **'Identifiers'**
  String get identifiers;

  /// User-visible copy: Add
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// User-visible copy: No identifiers saved.
  ///
  /// In en, this message translates to:
  /// **'No identifiers saved.'**
  String get noIdentifiersSaved;

  /// User-visible copy: Identifier actions
  ///
  /// In en, this message translates to:
  /// **'Identifier actions'**
  String get identifierActions;

  /// User-visible copy: Archive animal
  ///
  /// In en, this message translates to:
  /// **'Archive animal'**
  String get archiveAnimal;

  /// User-visible copy: Hide from active care without deleting the journal.
  ///
  /// In en, this message translates to:
  /// **'Hide from active care without deleting the journal.'**
  String get hideFromActiveCareWithoutDeletingTheJournal;

  /// User-visible copy: Save animal
  ///
  /// In en, this message translates to:
  /// **'Save animal'**
  String get saveAnimal;

  /// User-visible copy: Choose from gallery
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// User-visible copy: Take a photo
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takeAPhoto;

  /// User-visible copy: Delete {value1} identifier?
  ///
  /// In en, this message translates to:
  /// **'Delete {value1} identifier?'**
  String deleteIdentifier(Object value1);

  /// User-visible copy: {value1} will be removed from this local journal.
  ///
  /// In en, this message translates to:
  /// **'{value1} will be removed from this local journal.'**
  String willBeRemovedFromThisLocalJournal(Object value1);

  /// User-visible copy: Review the respiratory-rate values and try again.
  ///
  /// In en, this message translates to:
  /// **'Review the respiratory-rate values and try again.'**
  String get reviewTheRespiratoryRateValuesAndTryAgain;

  /// User-visible copy: This field is required.
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get thisFieldIsRequired;

  /// User-visible copy: Use a whole number.
  ///
  /// In en, this message translates to:
  /// **'Use a whole number.'**
  String get useAWholeNumber;

  /// User-visible copy: Use a positive number.
  ///
  /// In en, this message translates to:
  /// **'Use a positive number.'**
  String get useAPositiveNumber;

  /// User-visible copy: Microchip
  ///
  /// In en, this message translates to:
  /// **'Microchip'**
  String get microchip;

  /// User-visible copy: Tag
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get tag;

  /// User-visible copy: Band
  ///
  /// In en, this message translates to:
  /// **'Band'**
  String get band;

  /// User-visible copy: Tattoo
  ///
  /// In en, this message translates to:
  /// **'Tattoo'**
  String get tattoo;

  /// User-visible copy: Registry
  ///
  /// In en, this message translates to:
  /// **'Registry'**
  String get registry;

  /// User-visible copy: Add identifier
  ///
  /// In en, this message translates to:
  /// **'Add identifier'**
  String get addIdentifier;

  /// User-visible copy: Edit identifier
  ///
  /// In en, this message translates to:
  /// **'Edit identifier'**
  String get editIdentifier;

  /// User-visible copy: Type
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// User-visible copy: Custom type *
  ///
  /// In en, this message translates to:
  /// **'Custom type *'**
  String get customType;

  /// User-visible copy: Enter an identifier type.
  ///
  /// In en, this message translates to:
  /// **'Enter an identifier type.'**
  String get enterAnIdentifierType;

  /// User-visible copy: Identifier *
  ///
  /// In en, this message translates to:
  /// **'Identifier *'**
  String get identifier;

  /// User-visible copy: Enter the identifier.
  ///
  /// In en, this message translates to:
  /// **'Enter the identifier.'**
  String get enterTheIdentifier;

  /// User-visible copy: Issuer or service
  ///
  /// In en, this message translates to:
  /// **'Issuer or service'**
  String get issuerOrService;

  /// User-visible copy: Service URL
  ///
  /// In en, this message translates to:
  /// **'Service URL'**
  String get serviceURL;

  /// User-visible copy: Service phone
  ///
  /// In en, this message translates to:
  /// **'Service phone'**
  String get servicePhone;

  /// User-visible copy: Implanted or issued date
  ///
  /// In en, this message translates to:
  /// **'Implanted or issued date'**
  String get implantedOrIssuedDate;

  /// User-visible copy: Clear date
  ///
  /// In en, this message translates to:
  /// **'Clear date'**
  String get clearDate;

  /// User-visible copy: No active animals
  ///
  /// In en, this message translates to:
  /// **'No active animals'**
  String get noActiveAnimals;

  /// User-visible copy: Archived journals remain safe below. Add an animal or reopen an archived profile.
  ///
  /// In en, this message translates to:
  /// **'Archived journals remain safe below. Add an animal or reopen an archived profile.'**
  String get archivedJournalsRemainSafeBelowAddAnAnimalOr;

  /// User-visible copy: Archived journals
  ///
  /// In en, this message translates to:
  /// **'Archived journals'**
  String get archivedJournals;

  /// User-visible copy: {value1} • Hidden from active care
  ///
  /// In en, this message translates to:
  /// **'{value1} • Hidden from active care'**
  String hiddenFromActiveCare(Object value1);

  /// User-visible copy:  (approximate)
  ///
  /// In en, this message translates to:
  /// **' (approximate)'**
  String get approximate;

  /// User-visible copy: Breathing range supplied by you or your veterinarian: {value1} / {value2} / {value3} breaths/min (mi
  ///
  /// In en, this message translates to:
  /// **'Breathing range supplied by you or your veterinarian: {value1} / {value2} / {value3} breaths/min (min / target / max).'**
  String breathingRangeSuppliedByYouOrYourVeterinarianBreaths(
    Object value1,
    Object value2,
    Object value3,
  );

  /// User-visible copy: Other animals
  ///
  /// In en, this message translates to:
  /// **'Other animals'**
  String get otherAnimals;

  /// User-visible copy: Switch to {value1}, {value2}
  ///
  /// In en, this message translates to:
  /// **'Switch to {value1}, {value2}'**
  String switchTo(Object value1, Object value2);

  /// User-visible copy: Add pet
  ///
  /// In en, this message translates to:
  /// **'Add pet'**
  String get addPet;

  /// User-visible copy: Add document
  ///
  /// In en, this message translates to:
  /// **'Add document'**
  String get addDocument;

  /// User-visible copy: Edit document
  ///
  /// In en, this message translates to:
  /// **'Edit document'**
  String get editDocument;

  /// User-visible copy: Document for {value1}
  ///
  /// In en, this message translates to:
  /// **'Document for {value1}'**
  String documentFor(Object value1);

  /// User-visible copy: Images and PDFs are copied into Creaturely-managed storage.
  ///
  /// In en, this message translates to:
  /// **'Images and PDFs are copied into Creaturely-managed storage.'**
  String get imagesAndPDFsAreCopiedIntoCreaturelyManagedStorage;

  /// User-visible copy: Use recovered image
  ///
  /// In en, this message translates to:
  /// **'Use recovered image'**
  String get useRecoveredImage;

  /// User-visible copy: The original stored file is missing. Select a replacement before saving, or keep the visible record
  ///
  /// In en, this message translates to:
  /// **'The original stored file is missing. Select a replacement before saving, or keep the visible record in the timeline.'**
  String get theOriginalStoredFileIsMissingSelectAReplacement;

  /// User-visible copy: This stored file no longer matches its checksum. Select a clean replacement before sharing or backin
  ///
  /// In en, this message translates to:
  /// **'This stored file no longer matches its checksum. Select a clean replacement before sharing or backing it up.'**
  String get thisStoredFileNoLongerMatchesItsChecksumSelect;

  /// User-visible copy: {value1} • {value2} bytes
  ///
  /// In en, this message translates to:
  /// **'{value1} • {value2} bytes'**
  String bytes2(Object value1, Object value2);

  /// User-visible copy: Choose an image or PDF
  ///
  /// In en, this message translates to:
  /// **'Choose an image or PDF'**
  String get chooseAnImageOrPDF;

  /// User-visible copy: Browse Files
  ///
  /// In en, this message translates to:
  /// **'Browse Files'**
  String get browseFiles;

  /// User-visible copy: Photo library
  ///
  /// In en, this message translates to:
  /// **'Photo library'**
  String get photoLibrary;

  /// User-visible copy: Take photo
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get takePhoto;

  /// User-visible copy: Title *
  ///
  /// In en, this message translates to:
  /// **'Title *'**
  String get title;

  /// User-visible copy: Enter a title.
  ///
  /// In en, this message translates to:
  /// **'Enter a title.'**
  String get enterATitle;

  /// User-visible copy: Category
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// User-visible copy: Document date
  ///
  /// In en, this message translates to:
  /// **'Document date'**
  String get documentDate;

  /// User-visible copy: Expiry date (optional)
  ///
  /// In en, this message translates to:
  /// **'Expiry date (optional)'**
  String get expiryDateOptional;

  /// User-visible copy: No expiry date
  ///
  /// In en, this message translates to:
  /// **'No expiry date'**
  String get noExpiryDate;

  /// User-visible copy: Save document
  ///
  /// In en, this message translates to:
  /// **'Save document'**
  String get saveDocument;

  /// User-visible copy: Add medication
  ///
  /// In en, this message translates to:
  /// **'Add medication'**
  String get addMedication;

  /// User-visible copy: Edit medication
  ///
  /// In en, this message translates to:
  /// **'Edit medication'**
  String get editMedication;

  /// User-visible copy: Medication for {value1}
  ///
  /// In en, this message translates to:
  /// **'Medication for {value1}'**
  String medicationFor(Object value1);

  /// User-visible copy: Add directions and dose times for {value1}.
  ///
  /// In en, this message translates to:
  /// **'Add directions and dose times for {value1}.'**
  String addDirectionsAndDoseTimesFor(Object value1);

  /// User-visible copy: Notifications are off. Due doses remain visible in Creaturely, and the schedule can still be saved.
  ///
  /// In en, this message translates to:
  /// **'Notifications are off. Due doses remain visible in Creaturely, and the schedule can still be saved.'**
  String get notificationsAreOffDueDosesRemainVisibleInCreaturely;

  /// User-visible copy: Medication name *
  ///
  /// In en, this message translates to:
  /// **'Medication name *'**
  String get medicationName;

  /// User-visible copy: Form *
  ///
  /// In en, this message translates to:
  /// **'Form *'**
  String get form;

  /// User-visible copy: Tablet, liquid, drops, injection…
  ///
  /// In en, this message translates to:
  /// **'Tablet, liquid, drops, injection…'**
  String get tabletLiquidDropsInjection;

  /// User-visible copy: Dose amount *
  ///
  /// In en, this message translates to:
  /// **'Dose amount *'**
  String get doseAmount;

  /// User-visible copy: Dose unit *
  ///
  /// In en, this message translates to:
  /// **'Dose unit *'**
  String get doseUnit;

  /// User-visible copy: mg, mL, tablet
  ///
  /// In en, this message translates to:
  /// **'mg, mL, tablet'**
  String get mgMLTablet;

  /// User-visible copy: Instructions *
  ///
  /// In en, this message translates to:
  /// **'Instructions *'**
  String get instructions;

  /// User-visible copy: Active medication
  ///
  /// In en, this message translates to:
  /// **'Active medication'**
  String get activeMedication;

  /// User-visible copy: Inactive records remain in the timeline.
  ///
  /// In en, this message translates to:
  /// **'Inactive records remain in the timeline.'**
  String get inactiveRecordsRemainInTheTimeline;

  /// User-visible copy: Save medication
  ///
  /// In en, this message translates to:
  /// **'Save medication'**
  String get saveMedication;

  /// User-visible copy: Complete every schedule before saving.
  ///
  /// In en, this message translates to:
  /// **'Complete every schedule before saving.'**
  String get completeEveryScheduleBeforeSaving;

  /// User-visible copy: Schedule type
  ///
  /// In en, this message translates to:
  /// **'Schedule type'**
  String get scheduleType;

  /// User-visible copy: Repeating interval
  ///
  /// In en, this message translates to:
  /// **'Repeating interval'**
  String get repeatingInterval;

  /// User-visible copy: Remove schedule
  ///
  /// In en, this message translates to:
  /// **'Remove schedule'**
  String get removeSchedule;

  /// User-visible copy: Every
  ///
  /// In en, this message translates to:
  /// **'Every'**
  String get every;

  /// User-visible copy: {value1} hours
  ///
  /// In en, this message translates to:
  /// **'{value1} hours'**
  String hours(Object value1);

  /// User-visible copy: Set start time
  ///
  /// In en, this message translates to:
  /// **'Set start time'**
  String get setStartTime;

  /// User-visible copy: Change start time
  ///
  /// In en, this message translates to:
  /// **'Change start time'**
  String get changeStartTime;

  /// User-visible copy: Medication not found
  ///
  /// In en, this message translates to:
  /// **'Medication not found'**
  String get medicationNotFound;

  /// User-visible copy: This medication may have been removed from the journal.
  ///
  /// In en, this message translates to:
  /// **'This medication may have been removed from the journal.'**
  String get thisMedicationMayHaveBeenRemovedFromTheJournal;

  /// User-visible copy: Directions
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get directions;

  /// User-visible copy: Next dose
  ///
  /// In en, this message translates to:
  /// **'Next dose'**
  String get nextDose;

  /// User-visible copy: This medication is inactive. Its past dose history remains available.
  ///
  /// In en, this message translates to:
  /// **'This medication is inactive. Its past dose history remains available.'**
  String get thisMedicationIsInactiveItsPastDoseHistoryRemains;

  /// User-visible copy: No upcoming dose
  ///
  /// In en, this message translates to:
  /// **'No upcoming dose'**
  String get noUpcomingDose;

  /// User-visible copy: Review the saved schedule or add a dose time.
  ///
  /// In en, this message translates to:
  /// **'Review the saved schedule or add a dose time.'**
  String get reviewTheSavedScheduleOrAddADoseTime;

  /// User-visible copy: No saved dose times
  ///
  /// In en, this message translates to:
  /// **'No saved dose times'**
  String get noSavedDoseTimes;

  /// User-visible copy: Reminders active
  ///
  /// In en, this message translates to:
  /// **'Reminders active'**
  String get remindersActive;

  /// User-visible copy: Reminders paused
  ///
  /// In en, this message translates to:
  /// **'Reminders paused'**
  String get remindersPaused;

  /// User-visible copy: Last 30 days
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get last30Days;

  /// User-visible copy: Dose history
  ///
  /// In en, this message translates to:
  /// **'Dose history'**
  String get doseHistory;

  /// User-visible copy: No completed doses yet
  ///
  /// In en, this message translates to:
  /// **'No completed doses yet'**
  String get noCompletedDosesYet;

  /// User-visible copy: Given, skipped, and missed doses will appear here.
  ///
  /// In en, this message translates to:
  /// **'Given, skipped, and missed doses will appear here.'**
  String get givenSkippedAndMissedDosesWillAppearHere;

  /// User-visible copy: Inactive
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// User-visible copy: Mark given
  ///
  /// In en, this message translates to:
  /// **'Mark given'**
  String get markGiven;

  /// User-visible copy: Skip dose
  ///
  /// In en, this message translates to:
  /// **'Skip dose'**
  String get skipDose;

  /// User-visible copy: Pending
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// User-visible copy: Resting breathing recorder for {value1}
  ///
  /// In en, this message translates to:
  /// **'Resting breathing recorder for {value1}'**
  String restingBreathingRecorderFor(Object value1);

  /// User-visible copy: Cancel recording
  ///
  /// In en, this message translates to:
  /// **'Cancel recording'**
  String get cancelRecording;

  /// User-visible copy: {value1} breaths. {value2} seconds elapsed. {value3} seconds remaining.
  ///
  /// In en, this message translates to:
  /// **'{value1} breaths. {value2} seconds elapsed. {value3} seconds remaining.'**
  String breathsSecondsElapsedSecondsRemaining(Object value1, Object value2, Object value3);

  /// User-visible copy: {value1} s elapsed
  ///
  /// In en, this message translates to:
  /// **'{value1} s elapsed'**
  String sElapsed(Object value1);

  /// User-visible copy: {value1} s left
  ///
  /// In en, this message translates to:
  /// **'{value1} s left'**
  String sLeft(Object value1);

  /// User-visible copy: Record one breath
  ///
  /// In en, this message translates to:
  /// **'Record one breath'**
  String get recordOneBreath;

  /// User-visible copy: Record breath
  ///
  /// In en, this message translates to:
  /// **'Record breath'**
  String get recordBreath;

  /// User-visible copy: TAP FOR EACH
  /// BREATH
  ///
  /// In en, this message translates to:
  /// **'TAP FOR EACH\nBREATH'**
  String get tapFOREACHBREATH;

  /// User-visible copy: Undo last
  ///
  /// In en, this message translates to:
  /// **'Undo last'**
  String get undoLast;

  /// User-visible copy: Could not save the recording. Your breaths are kept here; try again.
  ///
  /// In en, this message translates to:
  /// **'Could not save the recording. Your breaths are kept here; try again.'**
  String get couldNotSaveTheRecordingYourBreathsAreKept;

  /// User-visible copy: Discard this recording?
  ///
  /// In en, this message translates to:
  /// **'Discard this recording?'**
  String get discardThisRecording;

  /// User-visible copy: The breaths counted in this session will not be saved.
  ///
  /// In en, this message translates to:
  /// **'The breaths counted in this session will not be saved.'**
  String get theBreathsCountedInThisSessionWillNotBe;

  /// User-visible copy: Keep recording
  ///
  /// In en, this message translates to:
  /// **'Keep recording'**
  String get keepRecording;

  /// User-visible copy: Discard
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// User-visible copy: Count {value1}’s breaths
  ///
  /// In en, this message translates to:
  /// **'Count {value1}’s breaths'**
  String countSBreaths(Object value1);

  /// User-visible copy: Wait until {value1} is quietly resting or sleeping. Tap once for each rise of the chest. Creaturely
  ///
  /// In en, this message translates to:
  /// **'Wait until {value1} is quietly resting or sleeping. Tap once for each rise of the chest. Creaturely uses the actual elapsed time.'**
  String waitUntilIsQuietlyRestingOrSleepingTapOnce(Object value1);

  /// User-visible copy: Context
  ///
  /// In en, this message translates to:
  /// **'Context'**
  String get context;

  /// User-visible copy: Timer
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get timer;

  /// User-visible copy: 15 s
  ///
  /// In en, this message translates to:
  /// **'15 s'**
  String get label15S;

  /// User-visible copy: 20 s
  ///
  /// In en, this message translates to:
  /// **'20 s'**
  String get label20S;

  /// User-visible copy: 30 s
  ///
  /// In en, this message translates to:
  /// **'30 s'**
  String get label30S;

  /// User-visible copy: 60 s
  ///
  /// In en, this message translates to:
  /// **'60 s'**
  String get label60S;

  /// User-visible copy: Start counting
  ///
  /// In en, this message translates to:
  /// **'Start counting'**
  String get startCounting;

  /// User-visible copy: Paused after interruption
  ///
  /// In en, this message translates to:
  /// **'Paused after interruption'**
  String get pausedAfterInterruption;

  /// User-visible copy: Check that the animal is still settled, then continue.
  ///
  /// In en, this message translates to:
  /// **'Check that the animal is still settled, then continue.'**
  String get checkThatTheAnimalIsStillSettledThenContinue;

  /// User-visible copy: Resume
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// User-visible copy: No breaths counted
  ///
  /// In en, this message translates to:
  /// **'No breaths counted'**
  String get noBreathsCounted;

  /// User-visible copy: {value1} breaths/min
  ///
  /// In en, this message translates to:
  /// **'{value1} breaths/min'**
  String breathsMin(Object value1);

  /// User-visible copy: Optional note
  ///
  /// In en, this message translates to:
  /// **'Optional note'**
  String get optionalNote;

  /// User-visible copy: Try again
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// User-visible copy: Save session
  ///
  /// In en, this message translates to:
  /// **'Save session'**
  String get saveSession;

  /// User-visible copy: Below your minimum of {value1} breaths/min
  ///
  /// In en, this message translates to:
  /// **'Below your minimum of {value1} breaths/min'**
  String belowYourMinimumOfBreathsMin(Object value1);

  /// User-visible copy: Above your maximum of {value1} breaths/min
  ///
  /// In en, this message translates to:
  /// **'Above your maximum of {value1} breaths/min'**
  String aboveYourMaximumOfBreathsMin(Object value1);

  /// User-visible copy: Within your saved range of {value1}–{value2} breaths/min
  ///
  /// In en, this message translates to:
  /// **'Within your saved range of {value1}–{value2} breaths/min'**
  String withinYourSavedRangeOfBreathsMin(Object value1, Object value2);

  /// User-visible copy: At or above your saved minimum of {value1} breaths/min
  ///
  /// In en, this message translates to:
  /// **'At or above your saved minimum of {value1} breaths/min'**
  String atOrAboveYourSavedMinimumOfBreathsMin(Object value1);

  /// User-visible copy: At or below your saved maximum of {value1} breaths/min
  ///
  /// In en, this message translates to:
  /// **'At or below your saved maximum of {value1} breaths/min'**
  String atOrBelowYourSavedMaximumOfBreathsMin(Object value1);

  /// User-visible copy: Saved target: {value1} breaths/min
  ///
  /// In en, this message translates to:
  /// **'Saved target: {value1} breaths/min'**
  String savedTargetBreathsMin(Object value1);

  /// User-visible copy: No personal range configured
  ///
  /// In en, this message translates to:
  /// **'No personal range configured'**
  String get noPersonalRangeConfigured;

  /// User-visible copy: Add an animal to begin a timeline.
  ///
  /// In en, this message translates to:
  /// **'Add an animal to begin a timeline.'**
  String get addAnAnimalToBeginATimeline;

  /// User-visible copy: {value1}’s timeline
  ///
  /// In en, this message translates to:
  /// **'{value1}’s timeline'**
  String sTimeline(Object value1);

  /// User-visible copy: Every care moment, newest first.
  ///
  /// In en, this message translates to:
  /// **'Every care moment, newest first.'**
  String get everyCareMomentNewestFirst;

  /// User-visible copy: Health
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get health;

  /// User-visible copy: Choose date range
  ///
  /// In en, this message translates to:
  /// **'Choose date range'**
  String get chooseDateRange;

  /// User-visible copy: Clear date range
  ///
  /// In en, this message translates to:
  /// **'Clear date range'**
  String get clearDateRange;

  /// User-visible copy: Nothing recorded here yet
  ///
  /// In en, this message translates to:
  /// **'Nothing recorded here yet'**
  String get nothingRecordedHereYet;

  /// User-visible copy: Use a quick action from {value1}’s dashboard to add the first entry.
  ///
  /// In en, this message translates to:
  /// **'Use a quick action from {value1}’s dashboard to add the first entry.'**
  String useAQuickActionFromSDashboardToAdd(Object value1);

  /// User-visible copy: Try clearing a filter or choosing a wider date range.
  ///
  /// In en, this message translates to:
  /// **'Try clearing a filter or choosing a wider date range.'**
  String get tryClearingAFilterOrChoosingAWiderDate;

  /// User-visible copy: Edit breathing note
  ///
  /// In en, this message translates to:
  /// **'Edit breathing note'**
  String get editBreathingNote;

  /// User-visible copy: Note
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// User-visible copy: Delete {value1}?
  ///
  /// In en, this message translates to:
  /// **'Delete {value1}?'**
  String delete3(Object value1);

  /// User-visible copy: This also removes future reminders. Past exported copies are unchanged.
  ///
  /// In en, this message translates to:
  /// **'This also removes future reminders. Past exported copies are unchanged.'**
  String get thisAlsoRemovesFutureRemindersPastExportedCopiesAre;

  /// User-visible copy: This record will be removed from the local journal.
  ///
  /// In en, this message translates to:
  /// **'This record will be removed from the local journal.'**
  String get thisRecordWillBeRemovedFromTheLocalJournal;

  /// User-visible copy: Breathing session
  ///
  /// In en, this message translates to:
  /// **'Breathing session'**
  String get breathingSession;

  /// User-visible copy: Recorded
  ///
  /// In en, this message translates to:
  /// **'Recorded'**
  String get recorded;

  /// User-visible copy: Counted
  ///
  /// In en, this message translates to:
  /// **'Counted'**
  String get counted;

  /// User-visible copy: {value1} breaths in {value2} seconds
  ///
  /// In en, this message translates to:
  /// **'{value1} breaths in {value2} seconds'**
  String breathsInSeconds(Object value1, Object value2);

  /// User-visible copy: Saved range
  ///
  /// In en, this message translates to:
  /// **'Saved range'**
  String get savedRange;

  /// User-visible copy: min {value1}
  ///
  /// In en, this message translates to:
  /// **'min {value1}'**
  String min(Object value1);

  /// User-visible copy: target {value1}
  ///
  /// In en, this message translates to:
  /// **'target {value1}'**
  String target2(Object value1);

  /// User-visible copy: max {value1}
  ///
  /// In en, this message translates to:
  /// **'max {value1}'**
  String max(Object value1);

  /// User-visible copy: No note added.
  ///
  /// In en, this message translates to:
  /// **'No note added.'**
  String get noNoteAdded;

  /// User-visible copy: Edit note
  ///
  /// In en, this message translates to:
  /// **'Edit note'**
  String get editNote;

  /// User-visible copy: Update dose
  ///
  /// In en, this message translates to:
  /// **'Update dose'**
  String get updateDose;

  /// User-visible copy: Status
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// User-visible copy: Not recorded yet
  ///
  /// In en, this message translates to:
  /// **'Not recorded yet'**
  String get notRecordedYet;

  /// User-visible copy: Actually administered
  ///
  /// In en, this message translates to:
  /// **'Actually administered'**
  String get actuallyAdministered;

  /// User-visible copy: Dose note (optional)
  ///
  /// In en, this message translates to:
  /// **'Dose note (optional)'**
  String get doseNoteOptional;

  /// User-visible copy: Stored file missing
  ///
  /// In en, this message translates to:
  /// **'Stored file missing'**
  String get storedFileMissing;

  /// User-visible copy: Stored file changed or corrupt
  ///
  /// In en, this message translates to:
  /// **'Stored file changed or corrupt'**
  String get storedFileChangedOrCorrupt;

  /// User-visible copy: Entry actions
  ///
  /// In en, this message translates to:
  /// **'Entry actions'**
  String get entryActions;

  /// User-visible copy: Edit dose
  ///
  /// In en, this message translates to:
  /// **'Edit dose'**
  String get editDose;

  /// User-visible copy: {value1} of 4
  ///
  /// In en, this message translates to:
  /// **'{value1} of 4'**
  String of4(Object value1);

  /// User-visible copy: Back
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// User-visible copy: Create journal
  ///
  /// In en, this message translates to:
  /// **'Create journal'**
  String get createJournal;

  /// User-visible copy: Please acknowledge the medical disclaimer.
  ///
  /// In en, this message translates to:
  /// **'Please acknowledge the medical disclaimer.'**
  String get pleaseAcknowledgeTheMedicalDisclaimer;

  /// User-visible copy: Welcome
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// User-visible copy: Know their normal.
  ///
  /// In en, this message translates to:
  /// **'Know their normal.'**
  String get knowTheirNormal;

  /// User-visible copy: Track everyday signs, spot changes, and keep a clearer health history for every animal in your life.
  ///
  /// In en, this message translates to:
  /// **'Track everyday signs, spot changes, and keep a clearer health history for every animal in your life.'**
  String get trackEverydaySignsSpotChangesAndKeepAClearer;

  /// User-visible copy: No account, ads, analytics, or background health-data collection.
  ///
  /// In en, this message translates to:
  /// **'No account, ads, analytics, or background health-data collection.'**
  String get noAccountAdsAnalyticsOrBackgroundHealthDataCollection;

  /// User-visible copy: Local first
  ///
  /// In en, this message translates to:
  /// **'Local first'**
  String get localFirst;

  /// User-visible copy: You decide where copies go.
  ///
  /// In en, this message translates to:
  /// **'You decide where copies go.'**
  String get youDecideWhereCopiesGo;

  /// User-visible copy: Your device is the source of truth. You can create an open .creaturely backup to Files, iCloud Drive
  ///
  /// In en, this message translates to:
  /// **'Your device is the source of truth. You can create an open .creaturely backup to Files, iCloud Drive, Google Drive, Dropbox, or another provider you choose.'**
  String get yourDeviceIsTheSourceOfTruthYouCan;

  /// User-visible copy: Cloud access is optional. Declining it never limits the journal.
  ///
  /// In en, this message translates to:
  /// **'Cloud access is optional. Declining it never limits the journal.'**
  String get cloudAccessIsOptionalDecliningItNeverLimitsThe;

  /// User-visible copy: Optional recovery snapshots are backup and restore—not live multi-device sync.
  ///
  /// In en, this message translates to:
  /// **'Optional recovery snapshots are backup and restore—not live multi-device sync.'**
  String get optionalRecoverySnapshotsAreBackupAndRestoreNotLive;

  /// User-visible copy: Reminders
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get reminders;

  /// User-visible copy: Helpful, never required.
  ///
  /// In en, this message translates to:
  /// **'Helpful, never required.'**
  String get helpfulNeverRequired;

  /// User-visible copy: Creaturely can schedule medication, breathing, and weight reminders on this device. You can say no n
  ///
  /// In en, this message translates to:
  /// **'Creaturely can schedule medication, breathing, and weight reminders on this device. You can say no now and change this later.'**
  String get creaturelyCanScheduleMedicationBreathingAndWeightRemindersOn;

  /// User-visible copy: Notifications are off. Medication schedules and due doses will still appear inside Creaturely.
  ///
  /// In en, this message translates to:
  /// **'Notifications are off. Medication schedules and due doses will still appear inside Creaturely.'**
  String get notificationsAreOffMedicationSchedulesAndDueDosesWill;

  /// User-visible copy: Notifications are ready. Individual schedules remain under your control.
  ///
  /// In en, this message translates to:
  /// **'Notifications are ready. Individual schedules remain under your control.'**
  String get notificationsAreReadyIndividualSchedulesRemainUnderYourControl;

  /// User-visible copy: Allow reminders
  ///
  /// In en, this message translates to:
  /// **'Allow reminders'**
  String get allowReminders;

  /// User-visible copy: First animal
  ///
  /// In en, this message translates to:
  /// **'First animal'**
  String get firstAnimal;

  /// User-visible copy: Who are you caring for?
  ///
  /// In en, this message translates to:
  /// **'Who are you caring for?'**
  String get whoAreYouCaringFor;

  /// User-visible copy: Only a name and species are needed. Add or change anything else later.
  ///
  /// In en, this message translates to:
  /// **'Only a name and species are needed. Add or change anything else later.'**
  String get onlyANameAndSpeciesAreNeededAddOr;

  /// User-visible copy: Enter a name.
  ///
  /// In en, this message translates to:
  /// **'Enter a name.'**
  String get enterAName;

  /// User-visible copy: Approximate age in months (optional)
  ///
  /// In en, this message translates to:
  /// **'Approximate age in months (optional)'**
  String get approximateAgeInMonthsOptional;

  /// User-visible copy: Enter a whole number of months.
  ///
  /// In en, this message translates to:
  /// **'Enter a whole number of months.'**
  String get enterAWholeNumberOfMonths;

  /// User-visible copy: I understand this is a journal, not veterinary care.
  ///
  /// In en, this message translates to:
  /// **'I understand this is a journal, not veterinary care.'**
  String get iUnderstandThisIsAJournalNotVeterinaryCare;

  /// User-visible copy: Page unavailable
  ///
  /// In en, this message translates to:
  /// **'Page unavailable'**
  String get pageUnavailable;

  /// User-visible copy: This page could not be opened
  ///
  /// In en, this message translates to:
  /// **'This page could not be opened'**
  String get thisPageCouldNotBeOpened;

  /// User-visible copy: Return to the Animals dashboard.
  ///
  /// In en, this message translates to:
  /// **'Return to the Animals dashboard.'**
  String get returnToTheAnimalsDashboard;

  /// User-visible copy: Go to Animals
  ///
  /// In en, this message translates to:
  /// **'Go to Animals'**
  String get goToAnimals;

  /// User-visible copy: Creaturely could not open the local journal
  ///
  /// In en, this message translates to:
  /// **'Creaturely could not open the local journal'**
  String get creaturelyCouldNotOpenTheLocalJournal;

  /// User-visible copy: Creaturely navigation
  ///
  /// In en, this message translates to:
  /// **'Creaturely navigation'**
  String get creaturelyNavigation;

  /// User-visible copy: Reminder is incomplete.
  ///
  /// In en, this message translates to:
  /// **'Reminder is incomplete.'**
  String get reminderIsIncomplete;

  /// User-visible copy: Weight reminder is incomplete.
  ///
  /// In en, this message translates to:
  /// **'Weight reminder is incomplete.'**
  String get weightReminderIsIncomplete;

  /// User-visible copy: Reminders could not be updated. Your journal is saved.
  ///
  /// In en, this message translates to:
  /// **'Reminders could not be updated. Your journal is saved.'**
  String get remindersCouldNotBeUpdatedYourJournalIsSaved;

  /// User-visible copy: Retry
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// User-visible copy: Medication reminders
  ///
  /// In en, this message translates to:
  /// **'Medication reminders'**
  String get medicationReminders;

  /// User-visible copy: Reminders the keeper has configured for medication care.
  ///
  /// In en, this message translates to:
  /// **'Reminders the keeper has configured for medication care.'**
  String get remindersTheKeeperHasConfiguredForMedicationCare;

  /// User-visible copy: Reminders the keeper has configured for manual breathing checks.
  ///
  /// In en, this message translates to:
  /// **'Reminders the keeper has configured for manual breathing checks.'**
  String get remindersTheKeeperHasConfiguredForManualBreathingChecks;

  /// User-visible copy: Record a weigh-in when it works for you.
  ///
  /// In en, this message translates to:
  /// **'Record a weigh-in when it works for you.'**
  String get recordAWeighInWhenItWorksForYou;

  /// User-visible copy: Reminders the keeper has configured for recording weight checks.
  ///
  /// In en, this message translates to:
  /// **'Reminders the keeper has configured for recording weight checks.'**
  String get remindersTheKeeperHasConfiguredForRecordingWeightChecks;

  /// User-visible copy: {value1} for {value2}
  ///
  /// In en, this message translates to:
  /// **'{value1} for {value2}'**
  String medicationForAnimal(Object value1, Object value2);

  /// No description provided for @recoveredImageNotice.
  ///
  /// In en, this message translates to:
  /// **'An image selection was recovered. You can use it in an animal profile or document.'**
  String get recoveredImageNotice;

  /// No description provided for @attachmentCleanupFailed.
  ///
  /// In en, this message translates to:
  /// **'Unused files could not be removed. Your journal is saved.'**
  String get attachmentCleanupFailed;

  /// No description provided for @fileOperationFailed.
  ///
  /// In en, this message translates to:
  /// **'The file could not be opened. Try choosing it again.'**
  String get fileOperationFailed;

  /// No description provided for @timerStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'{status, select, ready{Ready} running{Running} paused{Paused} completed{Completed} cancelled{Cancelled} saved{Saved} other{Unknown}}'**
  String timerStatusLabel(String status);

  /// No description provided for @respiratoryContextLabel.
  ///
  /// In en, this message translates to:
  /// **'{value, select, sleeping{Sleeping} resting{Resting} other{Unknown}}'**
  String respiratoryContextLabel(String value);

  /// No description provided for @operationFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not complete this action. Please try again.'**
  String get operationFailed;

  /// No description provided for @medicationDose.
  ///
  /// In en, this message translates to:
  /// **'Medication dose'**
  String get medicationDose;

  /// No description provided for @sleepingBreathingCheck.
  ///
  /// In en, this message translates to:
  /// **'Sleeping breathing check'**
  String get sleepingBreathingCheck;

  /// No description provided for @restingBreathingCheck.
  ///
  /// In en, this message translates to:
  /// **'Resting breathing check'**
  String get restingBreathingCheck;

  /// No description provided for @manualRespiratoryRateReminder.
  ///
  /// In en, this message translates to:
  /// **'Manual respiratory-rate reminder'**
  String get manualRespiratoryRateReminder;

  /// No description provided for @recordAWeighIn.
  ///
  /// In en, this message translates to:
  /// **'Record a weigh-in'**
  String get recordAWeighIn;

  /// No description provided for @categoryVaccination.
  ///
  /// In en, this message translates to:
  /// **'Vaccination'**
  String get categoryVaccination;

  /// No description provided for @categoryLaboratory.
  ///
  /// In en, this message translates to:
  /// **'Laboratory'**
  String get categoryLaboratory;

  /// No description provided for @categoryImaging.
  ///
  /// In en, this message translates to:
  /// **'Imaging'**
  String get categoryImaging;

  /// No description provided for @categoryPrescription.
  ///
  /// In en, this message translates to:
  /// **'Prescription'**
  String get categoryPrescription;

  /// No description provided for @categoryInsurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get categoryInsurance;

  /// No description provided for @categoryIdentification.
  ///
  /// In en, this message translates to:
  /// **'Identification'**
  String get categoryIdentification;

  /// No description provided for @healthAllergy.
  ///
  /// In en, this message translates to:
  /// **'Allergy'**
  String get healthAllergy;

  /// No description provided for @healthCondition.
  ///
  /// In en, this message translates to:
  /// **'Condition'**
  String get healthCondition;

  /// No description provided for @pdfSubject.
  ///
  /// In en, this message translates to:
  /// **'User-created animal health journal summary'**
  String get pdfSubject;

  /// No description provided for @pdfKeywords.
  ///
  /// In en, this message translates to:
  /// **'Creaturely, animal health journal, diagnostic disclaimer, veterinary advice'**
  String get pdfKeywords;

  /// No description provided for @careSummary.
  ///
  /// In en, this message translates to:
  /// **'Care summary'**
  String get careSummary;

  /// No description provided for @noBreathingSessionsInRange.
  ///
  /// In en, this message translates to:
  /// **'No resting breathing sessions in this range.'**
  String get noBreathingSessionsInRange;

  /// No description provided for @breaths.
  ///
  /// In en, this message translates to:
  /// **'Breaths'**
  String get breaths;

  /// No description provided for @elapsed.
  ///
  /// In en, this message translates to:
  /// **'Elapsed'**
  String get elapsed;

  /// No description provided for @rate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rate;

  /// No description provided for @includedDocuments.
  ///
  /// In en, this message translates to:
  /// **'Included documents'**
  String get includedDocuments;

  /// No description provided for @pdfDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Creaturely is a personal journal, not a diagnostic tool. This summary is user-entered information and does not replace veterinary advice.'**
  String get pdfDisclaimer;

  /// No description provided for @chooseDate.
  ///
  /// In en, this message translates to:
  /// **'Choose date'**
  String get chooseDate;

  /// No description provided for @countSleepingBreaths.
  ///
  /// In en, this message translates to:
  /// **'Count breaths when your animal is calm and sleeping.'**
  String get countSleepingBreaths;

  /// No description provided for @countRestingBreaths.
  ///
  /// In en, this message translates to:
  /// **'Count breaths when your animal is calm and resting.'**
  String get countRestingBreaths;

  /// No description provided for @pdfTitle.
  ///
  /// In en, this message translates to:
  /// **'Creaturely health summary - {name}'**
  String pdfTitle(Object name);

  /// No description provided for @pdfPage.
  ///
  /// In en, this message translates to:
  /// **'Creaturely - Page {page} of {pages}'**
  String pdfPage(Object page, Object pages);

  /// No description provided for @pdfRange.
  ///
  /// In en, this message translates to:
  /// **'Journal range: {start} to {end}'**
  String pdfRange(Object start, Object end);

  /// No description provided for @pdfBreathingSummary.
  ///
  /// In en, this message translates to:
  /// **'{count} breathing sessions; latest {latest}, range {minimum} to {maximum} breaths/minute.'**
  String pdfBreathingSummary(Object count, Object latest, Object minimum, Object maximum);

  /// No description provided for @pdfActiveMedications.
  ///
  /// In en, this message translates to:
  /// **'{count} active medications.'**
  String pdfActiveMedications(Object count);

  /// No description provided for @pdfGivenDoses.
  ///
  /// In en, this message translates to:
  /// **'{given} of {recorded} recorded doses marked given.'**
  String pdfGivenDoses(Object given, Object recorded);

  /// No description provided for @pdfHealthCount.
  ///
  /// In en, this message translates to:
  /// **'{count} physical-health records.'**
  String pdfHealthCount(Object count);

  /// No description provided for @pdfSeconds.
  ///
  /// In en, this message translates to:
  /// **'{seconds} s'**
  String pdfSeconds(Object seconds);

  /// No description provided for @pdfRate.
  ///
  /// In en, this message translates to:
  /// **'{rate}/min'**
  String pdfRate(Object rate);

  /// No description provided for @pdfFrom.
  ///
  /// In en, this message translates to:
  /// **'From {date}'**
  String pdfFrom(Object date);

  /// No description provided for @pdfThrough.
  ///
  /// In en, this message translates to:
  /// **'through {date}'**
  String pdfThrough(Object date);

  /// No description provided for @pdfStrength.
  ///
  /// In en, this message translates to:
  /// **'Strength: {value}'**
  String pdfStrength(Object value);

  /// No description provided for @pdfPrescriber.
  ///
  /// In en, this message translates to:
  /// **'Prescriber: {value}'**
  String pdfPrescriber(Object value);

  /// No description provided for @pdfPharmacy.
  ///
  /// In en, this message translates to:
  /// **'Pharmacy: {value}'**
  String pdfPharmacy(Object value);

  /// No description provided for @pdfPrescription.
  ///
  /// In en, this message translates to:
  /// **'Prescription: {value}'**
  String pdfPrescription(Object value);

  /// No description provided for @pdfRefills.
  ///
  /// In en, this message translates to:
  /// **'Refills remaining: {value}'**
  String pdfRefills(Object value);

  /// No description provided for @pdfNextRefill.
  ///
  /// In en, this message translates to:
  /// **'Next refill: {date}'**
  String pdfNextRefill(Object date);

  /// No description provided for @pdfNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes: {value}'**
  String pdfNotes(Object value);

  /// No description provided for @timelineBreathingDetail.
  ///
  /// In en, this message translates to:
  /// **'{rate} breaths/min • {context}'**
  String timelineBreathingDetail(Object rate, Object context);

  /// No description provided for @journalOpenFailedHelp.
  ///
  /// In en, this message translates to:
  /// **'Try again or reopen Creaturely. Your journal has not been reset.'**
  String get journalOpenFailedHelp;

  /// No description provided for @backupCorruptHelp.
  ///
  /// In en, this message translates to:
  /// **'The file is damaged or incomplete. Choose another backup.'**
  String get backupCorruptHelp;

  /// No description provided for @backupUnsupportedHelp.
  ///
  /// In en, this message translates to:
  /// **'This backup version is not supported by this version of Creaturely.'**
  String get backupUnsupportedHelp;

  /// No description provided for @fileUnavailableHelp.
  ///
  /// In en, this message translates to:
  /// **'A required file is unavailable or could not be read. Check the selected file and available storage.'**
  String get fileUnavailableHelp;

  /// No description provided for @journalDataUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unable to load journal data'**
  String get journalDataUnavailable;

  /// No description provided for @journalDataUnavailableHelp.
  ///
  /// In en, this message translates to:
  /// **'Try again. Your changes on this screen are kept.'**
  String get journalDataUnavailableHelp;

  /// No description provided for @automaticRecoveryFailed.
  ///
  /// In en, this message translates to:
  /// **'Automatic backup failed. Your local journal is available.'**
  String get automaticRecoveryFailed;

  /// No description provided for @temporaryExportCleanupFailed.
  ///
  /// In en, this message translates to:
  /// **'The temporary export file could not be removed.'**
  String get temporaryExportCleanupFailed;

  /// Noun displayed under the counted breaths.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {breath} other {breaths}}'**
  String countedBreathNoun(int count);

  /// Number of records in a trend summary.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {1 entry} other {{count} entries}}'**
  String entryCount(int count);

  /// Animal age in completed months.
  ///
  /// In en, this message translates to:
  /// **'{months, plural, one {1 month} other {{months} months}} old{qualifier}'**
  String ageMonthsOld(int months, String qualifier);

  /// Animal age in completed years and remaining months.
  ///
  /// In en, this message translates to:
  /// **'{years, plural, one {1 year} other {{years} years}}{months, plural, =0 {} one {, 1 month} other {, {months} months}} old{qualifier}'**
  String ageYearsOld(int years, int months, String qualifier);

  /// Unit label for respiratory rates.
  ///
  /// In en, this message translates to:
  /// **'breaths/min'**
  String get respiratoryRateUnit;

  /// Empty breathing trend title.
  ///
  /// In en, this message translates to:
  /// **'No breathing data in this range'**
  String get noBreathingDataInRange;

  /// Empty weight trend title.
  ///
  /// In en, this message translates to:
  /// **'No weight data in this range'**
  String get noWeightDataInRange;

  /// Validation help for an identifier service website.
  ///
  /// In en, this message translates to:
  /// **'Enter a complete URL, including https://.'**
  String get enterCompleteServiceUrl;

  /// Native feedback failure during a breathing session.
  ///
  /// In en, this message translates to:
  /// **'Tap feedback is unavailable. Your breaths are still being counted.'**
  String get feedbackUnavailable;

  /// A notification action could not be saved. Retry applies the retained action.
  ///
  /// In en, this message translates to:
  /// **'Could not complete the reminder action. Try again.'**
  String get notificationActionFailed;
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
