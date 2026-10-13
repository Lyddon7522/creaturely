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
  String get medicationPrescriptionDetails => 'Prescription & supply';

  @override
  String get medicationPrescriptionDetailsHint =>
      'Optional medicine, veterinarian, and refill information.';

  @override
  String get medicationStrengthLabel => 'Strength or concentration';

  @override
  String get medicationStrengthHint => 'For example, 20 mg/mL';

  @override
  String get medicationPrescriberLabel => 'Prescribing veterinarian or clinic';

  @override
  String get medicationPharmacyLabel => 'Pharmacy';

  @override
  String get medicationPrescriptionNumberLabel => 'Prescription number';

  @override
  String get medicationRefillsRemainingLabel => 'Refills remaining';

  @override
  String get medicationNextRefillDateLabel => 'Next refill date';

  @override
  String get medicationNoRefillDate => 'No refill date';

  @override
  String get medicationClearNextRefillDate => 'Clear next refill date';

  @override
  String get medicationRefillsValidation => 'Use a whole number of zero or more.';

  @override
  String get documents => 'Documents';

  @override
  String get healthRecords => 'Health records';

  @override
  String get permissionDenied =>
      'Notifications are off. Creaturely still works; reminders will remain visible in the app.';

  @override
  String get seekAdvice =>
      'If you are concerned about your animal, contact a veterinarian. Creaturely does not diagnose conditions.';

  @override
  String selectedAnimalChangeAnimal(Object value1) {
    return 'Selected animal: $value1. Change animal.';
  }

  @override
  String get loadingCreaturely => 'Loading Creaturely';

  @override
  String get creaturelyKnowTheirNormal => 'Creaturely. Know their normal.';

  @override
  String get creaturelyYourWay => 'Creaturely, your way';

  @override
  String get comfortRemindersPrivacyAndYourOwnCopies =>
      'Comfort, reminders, privacy, and your own copies.';

  @override
  String get appearanceUnits => 'Appearance & units';

  @override
  String get theme => 'Theme';

  @override
  String get system => 'System';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get weightDisplay => 'Weight display';

  @override
  String get recordingFeedback => 'Recording feedback';

  @override
  String get hapticTap => 'Haptic tap';

  @override
  String get onByDefaultForEachRecordedBreath => 'On by default for each recorded breath.';

  @override
  String get tapSound => 'Tap sound';

  @override
  String get offByDefault => 'Off by default.';

  @override
  String get defaultBreathingTimer => 'Default breathing timer';

  @override
  String s(Object value1) {
    return '$value1 s';
  }

  @override
  String get remindersRecovery => 'Reminders & recovery';

  @override
  String get notifications => 'Notifications';

  @override
  String get medicationBreathingAndWeightRemindersCanBeScheduled =>
      'Medication, breathing, and weight reminders can be scheduled.';

  @override
  String get dueCareRemainsVisibleInTheApp => 'Due care remains visible in the app.';

  @override
  String get automaticRecoverySnapshots => 'Automatic recovery snapshots';

  @override
  String get offLocalDataRemainsTheSourceOfTruth => 'Off • local data remains the source of truth';

  @override
  String get yourData => 'Your data';

  @override
  String get backupRestorePetExport => 'Backup, restore & pet export';

  @override
  String get saveBackupsAndSaveOrSharePetHealthSummaries =>
      'Save backups and save or share pet health summaries.';

  @override
  String get deleteLocalJournal => 'Delete local journal';

  @override
  String get removeRecordsAndAppManagedAttachments => 'Remove records and app-managed attachments.';

  @override
  String get helpFeedback => 'Help & feedback';

  @override
  String get reportABug => 'Report a bug';

  @override
  String get openAPrivateDataSafeGitHubIssueForm => 'Open a private-data-safe GitHub issue form.';

  @override
  String get viewCreaturelySource => 'View Creaturely source';

  @override
  String get copyTechnicalDetails => 'Copy technical details';

  @override
  String get appPlatformAndLocaleOnlyNeverJournalData =>
      'App, platform, and locale only—never journal data.';

  @override
  String get trustTransparency => 'Trust & transparency';

  @override
  String get privacy => 'Privacy';

  @override
  String get terms => 'Terms';

  @override
  String get medicalDisclaimer2 => 'Medical disclaimer';

  @override
  String get aboutOpenSourceLicenses => 'About & open-source licenses';

  @override
  String get couldNotOpenTheLinkOnThisDevice => 'Could not open the link on this device.';

  @override
  String creaturely1001PlatformOSVersionLocale(Object value1, Object value2, Object value3) {
    return 'Creaturely 1.0.0 (1)\nPlatform: $value1\nOS version: $value2\nLocale: $value3';
  }

  @override
  String get technicalDetailsCopied => 'Technical details copied.';

  @override
  String get privateCloudKitRecovery => 'Private CloudKit recovery';

  @override
  String get googleDriveAppDataRecovery => 'Google Drive appData recovery';

  @override
  String get providerNotSelected => 'Provider not selected';

  @override
  String get petExport => 'Pet export';

  @override
  String exportSHealthHistory(Object value1) {
    return 'Export $value1’s health history';
  }

  @override
  String get copiesYouControl => 'Copies you control';

  @override
  String get chooseADateRangeAndCreateAVetFriendly =>
      'Choose a date range and create a vet-friendly PDF, CSV, or document package.';

  @override
  String get createAnOpenBackupSafelyRestoreOneOrSave =>
      'Create an open backup, safely restore one, or save and share a focused pet health summary.';

  @override
  String get saveFileAndShareActionsOpenOnlyWhenYou =>
      'Save-file and share actions open only when you choose them. Creaturely performs no upload on its own during normal journaling.';

  @override
  String get wholeJournalBackup => 'Whole-journal backup';

  @override
  String get createCreaturelyBackup => 'Create .creaturely backup';

  @override
  String animalsDocuments(Object value1, Object value2) {
    return '$value1 animals • $value2 documents';
  }

  @override
  String get restoreFromCreaturely => 'Restore from .creaturely';

  @override
  String get fullyValidatedBeforeAnAtomicReplacement =>
      'Fully validated before an atomic replacement.';

  @override
  String get exportOptions => 'Export options';

  @override
  String get animal => 'Animal';

  @override
  String get dateRange => 'Date range';

  @override
  String get originalDocumentsToInclude => 'Original documents to include';

  @override
  String get noDocumentsInThisRange => 'No documents in this range.';

  @override
  String get exportOrShare => 'Export or share';

  @override
  String get saveCreaturelyBackup => 'Save Creaturely backup';

  @override
  String get creaturelyBackupSaved => 'Creaturely backup saved.';

  @override
  String get backupCouldNotBeCreated => 'Backup could not be created';

  @override
  String get backupRestoredSuccessfully => 'Backup restored successfully.';

  @override
  String get restoreStoppedSafely => 'Restore stopped safely';

  @override
  String get creaturelyPetHealthSummary => 'Creaturely pet health summary';

  @override
  String get creaturelyPetHealthExport => 'Creaturely pet health export';

  @override
  String get exportCouldNotBeShared => 'Export could not be shared';

  @override
  String savePetExport(Object value1) {
    return 'Save $value1 pet export';
  }

  @override
  String exportSaved(Object value1) {
    return '$value1 export saved.';
  }

  @override
  String exportCouldNotBeSaved(Object value1) {
    return '$value1 export could not be saved';
  }

  @override
  String get pdfSummary => 'PDF summary';

  @override
  String get aReadableOverviewOfTheSelectedDates => 'A readable overview of the selected dates.';

  @override
  String get csvData => 'CSV data';

  @override
  String get rawJournalDataForASpreadsheet => 'Raw journal data for a spreadsheet.';

  @override
  String get zipPackage => 'ZIP package';

  @override
  String get pdfCSVAndAnySelectedOriginalDocuments =>
      'PDF, CSV, and any selected original documents.';

  @override
  String get chooseExportFormat => 'Choose export format';

  @override
  String get selectOneFormatThenSaveItToFilesOr =>
      'Select one format, then save it to Files or share it with another app.';

  @override
  String get saveToFiles => 'Save to Files';

  @override
  String get share => 'Share';

  @override
  String get replaceThisLocalJournal => 'Replace this local journal?';

  @override
  String validatedBackupFromAnimalsBreathingSessionsMedicationsAndDocuments(
    Object value1,
    Object value2,
    Object value3,
    Object value4,
    Object value5,
  ) {
    return 'Validated backup from $value1.\n\n$value2 animals, $value3 breathing sessions, $value4 medications, and $value5 documents.\n\nCreaturely will create a safety snapshot first. Nothing is partially imported.';
  }

  @override
  String get restore => 'Restore';

  @override
  String get thisRemovesTheJournalFromThisDevice => 'This removes the journal from this device';

  @override
  String get animalRecordsMeasurementsSchedulesDoseHistorySettingsAndApp =>
      'Animal records, measurements, schedules, dose history, settings, and app-managed attachments will be deleted. Backups you already saved are not affected.';

  @override
  String get createACreaturelyBackupFirstIfYouMightWant =>
      'Create a .creaturely backup first if you might want this journal again.';

  @override
  String get typeDELETEToConfirm => 'Type DELETE to confirm';

  @override
  String get delete => 'DELETE';

  @override
  String get deleteEverythingLocal => 'Delete everything local';

  @override
  String get recoverySnapshots => 'Recovery snapshots';

  @override
  String get optionalRecoveryNotSync => 'Optional recovery, not sync';

  @override
  String get localDataAlwaysWinsDuringNormalUsePrivateProvider =>
      'Local data always wins during normal use. Private provider storage is used only after you opt in.';

  @override
  String atMostOnceADay(Object value1) {
    return 'At most once a day • $value1';
  }

  @override
  String get providerManagedEncryption => 'Provider-managed encryption';

  @override
  String get creaturelyDoesNotInventAnAccountOrCustomEncryption =>
      'Creaturely does not invent an account or custom encryption scheme.';

  @override
  String get backUpNow => 'Back up now';

  @override
  String get checkAccountAccess => 'Check account access';

  @override
  String get refreshRecoveryList => 'Refresh recovery list';

  @override
  String get recoveryPoints => 'Recovery points';

  @override
  String get noRecoverySnapshots => 'No recovery snapshots';

  @override
  String get createOneWhenTheProviderIsAvailable => 'Create one when the provider is available.';

  @override
  String bytes(Object value1) {
    return '$value1 bytes';
  }

  @override
  String get creaturelyKeepsTheNewestRecoveryPointPlusUpTo =>
      'Creaturely keeps the newest recovery point, plus up to 7 daily, 4 weekly, and 6 monthly points. Older copies are removed automatically.';

  @override
  String checking(Object value1) {
    return 'Checking $value1…';
  }

  @override
  String isAvailable(Object value1) {
    return '$value1 is available.';
  }

  @override
  String get thePlatformCloudAccountIsSignedOutLocalJournaling =>
      'The platform cloud account is signed out. Local journaling remains available.';

  @override
  String get theCloudProviderIsOfflineLocalJournalingRemainsAvailable =>
      'The cloud provider is offline. Local journaling remains available.';

  @override
  String get cloudStorageIsFullExistingLocalDataIsSafe =>
      'Cloud storage is full. Existing local data is safe.';

  @override
  String get theCloudProviderReportedAConflictExistingLocalData =>
      'The cloud provider reported a conflict. Existing local data was not changed.';

  @override
  String get thisBuildIsMissingThePlatformRecoveryCapabilityOr =>
      'This build is missing the platform recovery capability or release configuration.';

  @override
  String get cloudRecoveryAccessWasDeclinedLocalUseIsUnaffected =>
      'Cloud recovery access was declined. Local use is unaffected.';

  @override
  String get theCloudProviderReturnedAnErrorLocalUseIs =>
      'The cloud provider returned an error. Local use is unaffected.';

  @override
  String get privateCloudKit => 'private CloudKit';

  @override
  String get googleDriveAppData => 'Google Drive appData';

  @override
  String get platformRecovery => 'platform recovery';

  @override
  String get aboutCreaturely => 'About Creaturely';

  @override
  String get gnuGPLv3License => 'GNU GPLv3 license';

  @override
  String get license => 'LICENSE';

  @override
  String get plainLanguagePromise => 'Plain-language promise';

  @override
  String get vector42CollectsNoCreaturelyDataThereIsNoAccount =>
      'Vector42 collects no Creaturely data. There is no account, analytics, advertising, crash-reporting SDK, backend, or proprietary health-data collection.';

  @override
  String get onDeviceJournal => 'On-device journal';

  @override
  String get normalOperationUsesLocalSQLiteAndAppManagedFiles =>
      'Normal operation uses local SQLite and app-managed files. Creaturely does not make network calls while you browse, record, chart, or edit care.';

  @override
  String get copiesYouChoose => 'Copies you choose';

  @override
  String get whenYouExplicitlySaveABackupOrShareA =>
      'When you explicitly save a backup or share a report, the selected file destination, app, or cloud provider processes that file under its own terms. Optional recovery snapshots use private CloudKit on iOS or Google Drive appData on Android only after opt-in.';

  @override
  String get localFileIntegrity => 'Local file integrity';

  @override
  String get importedDocumentsStayInAppManagedStorageCreaturelyUses =>
      'Imported documents stay in app-managed storage. Creaturely uses local checksums to show when a document is missing or has changed, and converts stored weight values only for your chosen display unit.';

  @override
  String get yourControls => 'Your controls';

  @override
  String get youCanExportAnOpenBackupRestoreItArchive =>
      'You can export an open backup, restore it, archive individual animals, delete records, or delete the entire local journal from Data management.';

  @override
  String get personalJournal => 'Personal journal';

  @override
  String get creaturelyIsFreeSoftwareProvidedToHelpOneKeeper =>
      'Creaturely is free software provided to help one keeper organize information for animals on one active device. You remain responsible for the accuracy of entries, backups, medication decisions, and veterinary care.';

  @override
  String get noWarranty => 'No warranty';

  @override
  String get creaturelyIsProvidedWithoutWarrantyToTheExtentPermitted =>
      'Creaturely is provided without warranty, to the extent permitted by law, under the GNU General Public License version 3.';

  @override
  String get operatingSystemsMayDelayOrSuppressRemindersAlwaysUse =>
      'Operating systems may delay or suppress reminders. Always use the care plan supplied by your veterinarian and do not rely on Creaturely as the sole medication safeguard.';

  @override
  String get ownerSuppliedRanges => 'Owner-supplied ranges';

  @override
  String get creaturelyShipsNoSpeciesWideClinicalThresholdsAnyMinimum =>
      'Creaturely ships no species-wide clinical thresholds. Any minimum, target, or maximum shown was entered by you and should come from a care plan you trust.';

  @override
  String get neutralDescriptions => 'Neutral descriptions';

  @override
  String get aboveBelowAndInRangeLabelsCompareAMeasurement =>
      'Above, below, and in-range labels compare a measurement only with your saved values. They are not diagnoses, risk scores, or predictions.';

  @override
  String get manualBreathingObservations => 'Manual breathing observations';

  @override
  String get breathingEntriesComeFromKeeperTapsTheyAreNot =>
      'Breathing entries come from keeper taps. They are not phone-sensor readings and do not measure heart rate.';

  @override
  String get whenConcerned => 'When concerned';

  @override
  String get contactAVeterinarianOrAppropriateEmergencyServiceWhenAn =>
      'Contact a veterinarian or appropriate emergency service when an animal appears unwell or you are worried. Do not delay care to take or enter a measurement.';

  @override
  String get calmCareMadeVisible => 'Calm care, made visible.';

  @override
  String get creaturelyMakesEverydayPetObservationsEasierToUnderstandRemember =>
      'Creaturely makes everyday pet observations easier to understand, remember, and share.';

  @override
  String get creaturely10 => 'Creaturely 1.0';

  @override
  String get aLocalFirstPetHealthJournalPublishedByVector42 =>
      'A local-first pet-health journal published by Vector42 for Android and iOS. Application identifier: com.vector42.creaturely.';

  @override
  String get freeAndOpenSource => 'Free and open source';

  @override
  String get readTheGNUGPLv3License => 'Read the GNU GPLv3 license';

  @override
  String get openSourcePackageLicenses => 'Open-source package licenses';

  @override
  String get vector42GNUGPLv3 => '© Vector42 • GNU GPLv3';

  @override
  String get noAnimalSelected => 'No animal selected';

  @override
  String get addAnAnimalToCreateACareSchedule => 'Add an animal to create a care schedule.';

  @override
  String get addScheduledCare => 'Add scheduled care';

  @override
  String get breathingReminder => 'Breathing reminder';

  @override
  String get weightCheckReminder => 'Weight check reminder';

  @override
  String sSchedule(Object value1) {
    return '$value1’s schedule';
  }

  @override
  String get medicationBreathingChecksAndWeightChecks =>
      'Medication, breathing checks, and weight checks.';

  @override
  String get today => 'Today';

  @override
  String get label7Days => '7 days';

  @override
  String get schedules => 'Schedules';

  @override
  String get notificationsAreOffYourCareScheduleStillWorksHere =>
      'Notifications are off. Your care schedule still works here in Creaturely.';

  @override
  String get nothingScheduledToday => 'Nothing scheduled today';

  @override
  String get nothingScheduledInTheNext7Days => 'Nothing scheduled in the next 7 days';

  @override
  String get useAddToCreateABreathingReminderMedicationOr =>
      'Use Add to create a breathing reminder, medication, or weight check.';

  @override
  String get noSavedSchedules => 'No saved schedules';

  @override
  String get breathingReminders => 'Breathing reminders';

  @override
  String get medicationSchedules => 'Medication schedules';

  @override
  String get weightCheckReminders => 'Weight check reminders';

  @override
  String get deleteBreathingReminder => 'Delete breathing reminder?';

  @override
  String get thisRemovesFuturePromptsSavedBreathingMeasurementsAreUnchanged =>
      'This removes future prompts. Saved breathing measurements are unchanged.';

  @override
  String get delete2 => 'Delete';

  @override
  String get deleteWeightCheckReminder => 'Delete weight check reminder?';

  @override
  String get thisRemovesFuturePromptsSavedWeightMeasurementsAreUnchanged =>
      'This removes future prompts. Saved weight measurements are unchanged.';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get given => 'Given';

  @override
  String get skip => 'Skip';

  @override
  String get startBreathingCheck => 'Start breathing check';

  @override
  String get recordWeight => 'Record weight';

  @override
  String get skipped => 'Skipped';

  @override
  String get missed => 'Missed';

  @override
  String get everyDay => 'Every day';

  @override
  String get sleeping => 'Sleeping';

  @override
  String get resting => 'Resting';

  @override
  String breathingCheck(Object value1) {
    return '$value1 breathing check';
  }

  @override
  String get breathingReminderOptions => 'Breathing reminder options';

  @override
  String get edit => 'Edit';

  @override
  String get active => 'Active';

  @override
  String get paused => 'Paused';

  @override
  String get mon => 'Mon';

  @override
  String get tue => 'Tue';

  @override
  String get wed => 'Wed';

  @override
  String get thu => 'Thu';

  @override
  String get fri => 'Fri';

  @override
  String get sat => 'Sat';

  @override
  String get sun => 'Sun';

  @override
  String get weightCheck => 'Weight check';

  @override
  String get weightReminderOptions => 'Weight reminder options';

  @override
  String get noActiveTimes => 'No active times';

  @override
  String daily(Object value1) {
    return 'Daily • $value1';
  }

  @override
  String selectedDays(Object value1) {
    return 'Selected days • $value1';
  }

  @override
  String everyHoursStarts(Object value1, Object value2) {
    return 'Every $value1 hours • starts $value2';
  }

  @override
  String get repeat => 'Repeat';

  @override
  String get selectedWeekdays => 'Selected weekdays';

  @override
  String get reminderTimes => 'Reminder times';

  @override
  String get addTime => 'Add time';

  @override
  String get addAtLeastOneTime => 'Add at least one time.';

  @override
  String remove(Object value1) {
    return 'Remove $value1';
  }

  @override
  String get animalNotFound => 'Animal not found.';

  @override
  String get addWeightReminder => 'Add weight reminder';

  @override
  String get editWeightReminder => 'Edit weight reminder';

  @override
  String weightCheckFor(Object value1) {
    return 'Weight check for $value1';
  }

  @override
  String get chooseWhenYouWantAGentlePromptToRecord =>
      'Choose when you want a gentle prompt to record a weigh-in.';

  @override
  String get notificationsAreOffThisReminderWillStillAppearIn =>
      'Notifications are off. This reminder will still appear in Schedule.';

  @override
  String get turnOnNotifications => 'Turn on notifications';

  @override
  String get startDate => 'Start date';

  @override
  String get endDate => 'End date';

  @override
  String get noEndDate => 'No end date';

  @override
  String get reminderActive => 'Reminder active';

  @override
  String get turnThisOffWithoutDeletingTheSchedule =>
      'Turn this off without deleting the schedule.';

  @override
  String get saveReminder => 'Save reminder';

  @override
  String get addAtLeastOneReminderTime => 'Add at least one reminder time.';

  @override
  String get chooseAtLeastOneWeekday => 'Choose at least one weekday.';

  @override
  String get theEndDateMustBeOnOrAfterThe => 'The end date must be on or after the start date.';

  @override
  String get couldNotSaveYourChangesAreKeptHereTry =>
      'Could not save. Your changes are kept here; try again.';

  @override
  String get clearEndDate => 'Clear end date';

  @override
  String get addBreathingReminder => 'Add breathing reminder';

  @override
  String get editBreathingReminder => 'Edit breathing reminder';

  @override
  String breathingCheckFor(Object value1) {
    return 'Breathing check for $value1';
  }

  @override
  String get chooseWhenYouWantAGentlePromptToTake =>
      'Choose when you want a gentle prompt to take a manual reading.';

  @override
  String get observationContext => 'Observation context';

  @override
  String get weighIn => 'Weigh-in';

  @override
  String get addHealthRecord => 'Add health record';

  @override
  String get editHealthRecord => 'Edit health record';

  @override
  String aNoteAbout(Object value1) {
    return 'A note about $value1';
  }

  @override
  String get recordWhatYouObservedWithoutTurningTheAnimalInto =>
      'Record what you observed without turning the animal into a condition.';

  @override
  String get recordType => 'Record type';

  @override
  String get allergyOrSensitivity => 'Allergy or sensitivity';

  @override
  String get conditionOrBodyIssue => 'Condition or body issue';

  @override
  String get customObservation => 'Custom observation';

  @override
  String get label => 'Label';

  @override
  String get nameOrObservation => 'Name or observation *';

  @override
  String get enterAShortLabel => 'Enter a short label.';

  @override
  String get weight2 => 'Weight *';

  @override
  String get enterAPositiveWeight => 'Enter a positive weight.';

  @override
  String get unit => 'Unit';

  @override
  String get date => 'Date';

  @override
  String get notes => 'Notes';

  @override
  String get saveRecord => 'Save record';

  @override
  String get noTrendsYet => 'No trends yet';

  @override
  String get addAnAnimalAndRecordMeasurementsToSeeDescriptive =>
      'Add an animal and record measurements to see descriptive trends.';

  @override
  String get showChart => 'Show chart';

  @override
  String get showMeasurementList => 'Show measurement list';

  @override
  String get chooseAnotherRangeOrRecordANewMeasurementFrom =>
      'Choose another range or record a new measurement from the Animals dashboard.';

  @override
  String get sparseDataEachSavedMeasurementIsShownALine =>
      'Sparse data: each saved measurement is shown; a line is not interpreted as a forecast.';

  @override
  String get descriptiveViewOnlyLatestAverageAndObservedRangeNo =>
      'Descriptive view only: latest, average, and observed range. No predictions or diagnosis.';

  @override
  String get noMedicationOutcomesInThisRange => 'No medication outcomes in this range';

  @override
  String get givenSkippedAndMissedDosesWillAppearHereAfter =>
      'Given, skipped, and missed doses will appear here after they are recorded.';

  @override
  String get byMedication => 'By medication';

  @override
  String get countsReflectTheDoseStatusesRecordedInThisDate =>
      'Counts reflect the dose statuses recorded in this date range.';

  @override
  String givenSkippedMissed(Object value1, Object value2, Object value3) {
    return '$value1 given • $value2 skipped • $value3 missed';
  }

  @override
  String get custom => 'Custom';

  @override
  String get all => 'All';

  @override
  String get latest => 'Latest';

  @override
  String get average => 'Average';

  @override
  String get observedRange => 'Observed range';

  @override
  String measurementsLatestObservedRangeTo(
    Object value1,
    Object value2,
    Object value3,
    Object value4,
    Object value5,
    Object value6,
  ) {
    return '$value1 measurements. Latest $value2 $value3. Observed range $value4 to $value5 $value6.';
  }

  @override
  String accessibleMeasurementListWithRows(Object value1) {
    return 'Accessible measurement list with $value1 rows';
  }

  @override
  String get dateAndTime => 'Date and time';

  @override
  String get measurement => 'Measurement';

  @override
  String get recordedAs => 'Recorded as';

  @override
  String recordedAs2(Object value1) {
    return 'Recorded as $value1';
  }

  @override
  String get other => 'Other';

  @override
  String get dog => 'Dog';

  @override
  String get cat => 'Cat';

  @override
  String get bird => 'Bird';

  @override
  String get rabbit => 'Rabbit';

  @override
  String get reptile => 'Reptile';

  @override
  String get horse => 'Horse';

  @override
  String get fish => 'Fish';

  @override
  String get mixedBreed => 'Mixed breed';

  @override
  String get labradorRetriever => 'Labrador Retriever';

  @override
  String get goldenRetriever => 'Golden Retriever';

  @override
  String get germanShepherd => 'German Shepherd';

  @override
  String get frenchBulldog => 'French Bulldog';

  @override
  String get poodle => 'Poodle';

  @override
  String get beagle => 'Beagle';

  @override
  String get dachshund => 'Dachshund';

  @override
  String get australianShepherd => 'Australian Shepherd';

  @override
  String get borderCollie => 'Border Collie';

  @override
  String get chihuahua => 'Chihuahua';

  @override
  String get shihTzu => 'Shih Tzu';

  @override
  String get yorkshireTerrier => 'Yorkshire Terrier';

  @override
  String get boxer => 'Boxer';

  @override
  String get siberianHusky => 'Siberian Husky';

  @override
  String get domesticShorthair => 'Domestic Shorthair';

  @override
  String get domesticLonghair => 'Domestic Longhair';

  @override
  String get maineCoon => 'Maine Coon';

  @override
  String get siamese => 'Siamese';

  @override
  String get ragdoll => 'Ragdoll';

  @override
  String get bengal => 'Bengal';

  @override
  String get britishShorthair => 'British Shorthair';

  @override
  String get persian => 'Persian';

  @override
  String get sphynx => 'Sphynx';

  @override
  String get russianBlue => 'Russian Blue';

  @override
  String get abyssinian => 'Abyssinian';

  @override
  String get mixedOrHybrid => 'Mixed or hybrid';

  @override
  String get budgerigar => 'Budgerigar';

  @override
  String get cockatiel => 'Cockatiel';

  @override
  String get africanGrey => 'African Grey';

  @override
  String get canary => 'Canary';

  @override
  String get lovebird => 'Lovebird';

  @override
  String get conure => 'Conure';

  @override
  String get finch => 'Finch';

  @override
  String get macaw => 'Macaw';

  @override
  String get hollandLop => 'Holland Lop';

  @override
  String get miniRex => 'Mini Rex';

  @override
  String get netherlandDwarf => 'Netherland Dwarf';

  @override
  String get lionhead => 'Lionhead';

  @override
  String get flemishGiant => 'Flemish Giant';

  @override
  String get englishLop => 'English Lop';

  @override
  String get quarterHorse => 'Quarter Horse';

  @override
  String get thoroughbred => 'Thoroughbred';

  @override
  String get arabian => 'Arabian';

  @override
  String get appaloosa => 'Appaloosa';

  @override
  String get paintHorse => 'Paint Horse';

  @override
  String get warmblood => 'Warmblood';

  @override
  String get morgan => 'Morgan';

  @override
  String get beardedDragon => 'Bearded Dragon';

  @override
  String get leopardGecko => 'Leopard Gecko';

  @override
  String get ballPython => 'Ball Python';

  @override
  String get cornSnake => 'Corn Snake';

  @override
  String get crestedGecko => 'Crested Gecko';

  @override
  String get redEaredSlider => 'Red-eared Slider';

  @override
  String get betta => 'Betta';

  @override
  String get goldfish => 'Goldfish';

  @override
  String get guppy => 'Guppy';

  @override
  String get angelfish => 'Angelfish';

  @override
  String get tetra => 'Tetra';

  @override
  String get cichlid => 'Cichlid';

  @override
  String get useZeroOrAPositiveNumber => 'Use zero or a positive number.';

  @override
  String get species => 'Species *';

  @override
  String get chooseACommonSpeciesOrEnterYourOwn => 'Choose a common species or enter your own';

  @override
  String get speciesName => 'Species name *';

  @override
  String get enterTheSpecies => 'Enter the species.';

  @override
  String get breedOrVarietyOptional => 'Breed or variety (optional)';

  @override
  String get freeFormEntryMultipleBreedsAreWelcome =>
      'Free-form entry; multiple breeds are welcome';

  @override
  String get chooseASuggestionOrTypeAnyBreedOrMix => 'Choose a suggestion or type any breed or mix';

  @override
  String get minimumRespiratoryRateCanTBeHigherThanTarget =>
      'Minimum respiratory rate can\'t be higher than target or maximum.';

  @override
  String get targetRespiratoryRateCanTBeHigherThanMaximum =>
      'Target respiratory rate can\'t be higher than maximum or lower than minimum.';

  @override
  String get maximumRespiratoryRateCanTBeLowerThanTarget =>
      'Maximum respiratory rate can\'t be lower than target or minimum.';

  @override
  String get minimum => 'Minimum';

  @override
  String get target => 'Target';

  @override
  String get maximum => 'Maximum';

  @override
  String get restingRespiratoryRate => 'Resting respiratory rate';

  @override
  String get optionalOnlyEnterValuesSuppliedByYouOrYour =>
      'Optional. Only enter values supplied by you or your veterinarian. Creaturely does not provide species-wide clinical defaults.';

  @override
  String get allValuesUseBreathsMinLeaveAnyFieldBlank =>
      'All values use breaths/min. Leave any field blank if it is unknown.';

  @override
  String edit2(Object value1) {
    return 'Edit $value1';
  }

  @override
  String get chooseAnimalPhoto => 'Choose animal photo';

  @override
  String get name => 'Name *';

  @override
  String get sexOptional => 'Sex (optional)';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get notSpecified => 'Not specified';

  @override
  String get dateOfBirth => 'Date of birth';

  @override
  String get clearDateOfBirth => 'Clear date of birth';

  @override
  String get notSupplied => 'Not supplied';

  @override
  String get ageMonths => 'Age (months)';

  @override
  String get optionalEstimate => 'Optional estimate';

  @override
  String get calculatedFromBirthDate => 'Calculated from birth date';

  @override
  String get colorAndMarkings => 'Color and markings';

  @override
  String currentWeight2(Object value1) {
    return 'Current weight ($value1)';
  }

  @override
  String get identifiers => 'Identifiers';

  @override
  String get add => 'Add';

  @override
  String get noIdentifiersSaved => 'No identifiers saved.';

  @override
  String get identifierActions => 'Identifier actions';

  @override
  String get archiveAnimal => 'Archive animal';

  @override
  String get hideFromActiveCareWithoutDeletingTheJournal =>
      'Hide from active care without deleting the journal.';

  @override
  String get saveAnimal => 'Save animal';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get takeAPhoto => 'Take a photo';

  @override
  String deleteIdentifier(Object value1) {
    return 'Delete $value1 identifier?';
  }

  @override
  String willBeRemovedFromThisLocalJournal(Object value1) {
    return '$value1 will be removed from this local journal.';
  }

  @override
  String get reviewTheRespiratoryRateValuesAndTryAgain =>
      'Review the respiratory-rate values and try again.';

  @override
  String get thisFieldIsRequired => 'This field is required.';

  @override
  String get useAWholeNumber => 'Use a whole number.';

  @override
  String get useAPositiveNumber => 'Use a positive number.';

  @override
  String get microchip => 'Microchip';

  @override
  String get tag => 'Tag';

  @override
  String get band => 'Band';

  @override
  String get tattoo => 'Tattoo';

  @override
  String get registry => 'Registry';

  @override
  String get addIdentifier => 'Add identifier';

  @override
  String get editIdentifier => 'Edit identifier';

  @override
  String get type => 'Type';

  @override
  String get customType => 'Custom type *';

  @override
  String get enterAnIdentifierType => 'Enter an identifier type.';

  @override
  String get identifier => 'Identifier *';

  @override
  String get enterTheIdentifier => 'Enter the identifier.';

  @override
  String get issuerOrService => 'Issuer or service';

  @override
  String get serviceURL => 'Service URL';

  @override
  String get servicePhone => 'Service phone';

  @override
  String get implantedOrIssuedDate => 'Implanted or issued date';

  @override
  String get clearDate => 'Clear date';

  @override
  String get noActiveAnimals => 'No active animals';

  @override
  String get archivedJournalsRemainSafeBelowAddAnAnimalOr =>
      'Archived journals remain safe below. Add an animal or reopen an archived profile.';

  @override
  String get archivedJournals => 'Archived journals';

  @override
  String hiddenFromActiveCare(Object value1) {
    return '$value1 • Hidden from active care';
  }

  @override
  String get approximate => ' (approximate)';

  @override
  String breathingRangeSuppliedByYouOrYourVeterinarianBreaths(
    Object value1,
    Object value2,
    Object value3,
  ) {
    return 'Breathing range supplied by you or your veterinarian: $value1 / $value2 / $value3 breaths/min (min / target / max).';
  }

  @override
  String get otherAnimals => 'Other animals';

  @override
  String switchTo(Object value1, Object value2) {
    return 'Switch to $value1, $value2';
  }

  @override
  String get addPet => 'Add pet';

  @override
  String get addDocument => 'Add document';

  @override
  String get editDocument => 'Edit document';

  @override
  String documentFor(Object value1) {
    return 'Document for $value1';
  }

  @override
  String get imagesAndPDFsAreCopiedIntoCreaturelyManagedStorage =>
      'Images and PDFs are copied into Creaturely-managed storage.';

  @override
  String get useRecoveredImage => 'Use recovered image';

  @override
  String get theOriginalStoredFileIsMissingSelectAReplacement =>
      'The original stored file is missing. Select a replacement before saving, or keep the visible record in the timeline.';

  @override
  String get thisStoredFileNoLongerMatchesItsChecksumSelect =>
      'This stored file no longer matches its checksum. Select a clean replacement before sharing or backing it up.';

  @override
  String bytes2(Object value1, Object value2) {
    return '$value1 • $value2 bytes';
  }

  @override
  String get chooseAnImageOrPDF => 'Choose an image or PDF';

  @override
  String get browseFiles => 'Browse Files';

  @override
  String get photoLibrary => 'Photo library';

  @override
  String get takePhoto => 'Take photo';

  @override
  String get title => 'Title *';

  @override
  String get enterATitle => 'Enter a title.';

  @override
  String get category => 'Category';

  @override
  String get documentDate => 'Document date';

  @override
  String get expiryDateOptional => 'Expiry date (optional)';

  @override
  String get noExpiryDate => 'No expiry date';

  @override
  String get saveDocument => 'Save document';

  @override
  String get addMedication => 'Add medication';

  @override
  String get editMedication => 'Edit medication';

  @override
  String medicationFor(Object value1) {
    return 'Medication for $value1';
  }

  @override
  String addDirectionsAndDoseTimesFor(Object value1) {
    return 'Add directions and dose times for $value1.';
  }

  @override
  String get notificationsAreOffDueDosesRemainVisibleInCreaturely =>
      'Notifications are off. Due doses remain visible in Creaturely, and the schedule can still be saved.';

  @override
  String get medicationName => 'Medication name *';

  @override
  String get form => 'Form *';

  @override
  String get tabletLiquidDropsInjection => 'Tablet, liquid, drops, injection…';

  @override
  String get doseAmount => 'Dose amount *';

  @override
  String get doseUnit => 'Dose unit *';

  @override
  String get mgMLTablet => 'mg, mL, tablet';

  @override
  String get instructions => 'Instructions *';

  @override
  String get activeMedication => 'Active medication';

  @override
  String get inactiveRecordsRemainInTheTimeline => 'Inactive records remain in the timeline.';

  @override
  String get saveMedication => 'Save medication';

  @override
  String get completeEveryScheduleBeforeSaving => 'Complete every schedule before saving.';

  @override
  String get scheduleType => 'Schedule type';

  @override
  String get repeatingInterval => 'Repeating interval';

  @override
  String get removeSchedule => 'Remove schedule';

  @override
  String get every => 'Every';

  @override
  String hours(Object value1) {
    return '$value1 hours';
  }

  @override
  String get setStartTime => 'Set start time';

  @override
  String get changeStartTime => 'Change start time';

  @override
  String get medicationNotFound => 'Medication not found';

  @override
  String get thisMedicationMayHaveBeenRemovedFromTheJournal =>
      'This medication may have been removed from the journal.';

  @override
  String get directions => 'Directions';

  @override
  String get nextDose => 'Next dose';

  @override
  String get thisMedicationIsInactiveItsPastDoseHistoryRemains =>
      'This medication is inactive. Its past dose history remains available.';

  @override
  String get noUpcomingDose => 'No upcoming dose';

  @override
  String get reviewTheSavedScheduleOrAddADoseTime =>
      'Review the saved schedule or add a dose time.';

  @override
  String get noSavedDoseTimes => 'No saved dose times';

  @override
  String get remindersActive => 'Reminders active';

  @override
  String get remindersPaused => 'Reminders paused';

  @override
  String get last30Days => 'Last 30 days';

  @override
  String get doseHistory => 'Dose history';

  @override
  String get noCompletedDosesYet => 'No completed doses yet';

  @override
  String get givenSkippedAndMissedDosesWillAppearHere =>
      'Given, skipped, and missed doses will appear here.';

  @override
  String get inactive => 'Inactive';

  @override
  String get markGiven => 'Mark given';

  @override
  String get skipDose => 'Skip dose';

  @override
  String get pending => 'Pending';

  @override
  String restingBreathingRecorderFor(Object value1) {
    return 'Resting breathing recorder for $value1';
  }

  @override
  String get cancelRecording => 'Cancel recording';

  @override
  String breathsSecondsElapsedSecondsRemaining(Object value1, Object value2, Object value3) {
    return '$value1 breaths. $value2 seconds elapsed. $value3 seconds remaining.';
  }

  @override
  String sElapsed(Object value1) {
    return '$value1 s elapsed';
  }

  @override
  String sLeft(Object value1) {
    return '$value1 s left';
  }

  @override
  String get recordOneBreath => 'Record one breath';

  @override
  String get recordBreath => 'Record breath';

  @override
  String get tapFOREACHBREATH => 'TAP FOR EACH\nBREATH';

  @override
  String get undoLast => 'Undo last';

  @override
  String get couldNotSaveTheRecordingYourBreathsAreKept =>
      'Could not save the recording. Your breaths are kept here; try again.';

  @override
  String get discardThisRecording => 'Discard this recording?';

  @override
  String get theBreathsCountedInThisSessionWillNotBe =>
      'The breaths counted in this session will not be saved.';

  @override
  String get keepRecording => 'Keep recording';

  @override
  String get discard => 'Discard';

  @override
  String countSBreaths(Object value1) {
    return 'Count $value1’s breaths';
  }

  @override
  String waitUntilIsQuietlyRestingOrSleepingTapOnce(Object value1) {
    return 'Wait until $value1 is quietly resting or sleeping. Tap once for each rise of the chest. Creaturely uses the actual elapsed time.';
  }

  @override
  String get context => 'Context';

  @override
  String get timer => 'Timer';

  @override
  String get label15S => '15 s';

  @override
  String get label20S => '20 s';

  @override
  String get label30S => '30 s';

  @override
  String get label60S => '60 s';

  @override
  String get startCounting => 'Start counting';

  @override
  String get pausedAfterInterruption => 'Paused after interruption';

  @override
  String get checkThatTheAnimalIsStillSettledThenContinue =>
      'Check that the animal is still settled, then continue.';

  @override
  String get resume => 'Resume';

  @override
  String get noBreathsCounted => 'No breaths counted';

  @override
  String breathsMin(Object value1) {
    return '$value1 breaths/min';
  }

  @override
  String get optionalNote => 'Optional note';

  @override
  String get tryAgain => 'Try again';

  @override
  String get saveSession => 'Save session';

  @override
  String belowYourMinimumOfBreathsMin(Object value1) {
    return 'Below your minimum of $value1 breaths/min';
  }

  @override
  String aboveYourMaximumOfBreathsMin(Object value1) {
    return 'Above your maximum of $value1 breaths/min';
  }

  @override
  String withinYourSavedRangeOfBreathsMin(Object value1, Object value2) {
    return 'Within your saved range of $value1–$value2 breaths/min';
  }

  @override
  String atOrAboveYourSavedMinimumOfBreathsMin(Object value1) {
    return 'At or above your saved minimum of $value1 breaths/min';
  }

  @override
  String atOrBelowYourSavedMaximumOfBreathsMin(Object value1) {
    return 'At or below your saved maximum of $value1 breaths/min';
  }

  @override
  String savedTargetBreathsMin(Object value1) {
    return 'Saved target: $value1 breaths/min';
  }

  @override
  String get noPersonalRangeConfigured => 'No personal range configured';

  @override
  String get addAnAnimalToBeginATimeline => 'Add an animal to begin a timeline.';

  @override
  String sTimeline(Object value1) {
    return '$value1’s timeline';
  }

  @override
  String get everyCareMomentNewestFirst => 'Every care moment, newest first.';

  @override
  String get health => 'Health';

  @override
  String get chooseDateRange => 'Choose date range';

  @override
  String get clearDateRange => 'Clear date range';

  @override
  String get nothingRecordedHereYet => 'Nothing recorded here yet';

  @override
  String useAQuickActionFromSDashboardToAdd(Object value1) {
    return 'Use a quick action from $value1’s dashboard to add the first entry.';
  }

  @override
  String get tryClearingAFilterOrChoosingAWiderDate =>
      'Try clearing a filter or choosing a wider date range.';

  @override
  String get editBreathingNote => 'Edit breathing note';

  @override
  String get note => 'Note';

  @override
  String delete3(Object value1) {
    return 'Delete $value1?';
  }

  @override
  String get thisAlsoRemovesFutureRemindersPastExportedCopiesAre =>
      'This also removes future reminders. Past exported copies are unchanged.';

  @override
  String get thisRecordWillBeRemovedFromTheLocalJournal =>
      'This record will be removed from the local journal.';

  @override
  String get breathingSession => 'Breathing session';

  @override
  String get recorded => 'Recorded';

  @override
  String get counted => 'Counted';

  @override
  String breathsInSeconds(Object value1, Object value2) {
    return '$value1 breaths in $value2 seconds';
  }

  @override
  String get savedRange => 'Saved range';

  @override
  String min(Object value1) {
    return 'min $value1';
  }

  @override
  String target2(Object value1) {
    return 'target $value1';
  }

  @override
  String max(Object value1) {
    return 'max $value1';
  }

  @override
  String get noNoteAdded => 'No note added.';

  @override
  String get editNote => 'Edit note';

  @override
  String get updateDose => 'Update dose';

  @override
  String get status => 'Status';

  @override
  String get notRecordedYet => 'Not recorded yet';

  @override
  String get actuallyAdministered => 'Actually administered';

  @override
  String get doseNoteOptional => 'Dose note (optional)';

  @override
  String get storedFileMissing => 'Stored file missing';

  @override
  String get storedFileChangedOrCorrupt => 'Stored file changed or corrupt';

  @override
  String get entryActions => 'Entry actions';

  @override
  String get editDose => 'Edit dose';

  @override
  String of4(Object value1) {
    return '$value1 of 4';
  }

  @override
  String get back => 'Back';

  @override
  String get createJournal => 'Create journal';

  @override
  String get pleaseAcknowledgeTheMedicalDisclaimer => 'Please acknowledge the medical disclaimer.';

  @override
  String get welcome => 'Welcome';

  @override
  String get knowTheirNormal => 'Know their normal.';

  @override
  String get trackEverydaySignsSpotChangesAndKeepAClearer =>
      'Track everyday signs, spot changes, and keep a clearer health history for every animal in your life.';

  @override
  String get noAccountAdsAnalyticsOrBackgroundHealthDataCollection =>
      'No account, ads, analytics, or background health-data collection.';

  @override
  String get localFirst => 'Local first';

  @override
  String get youDecideWhereCopiesGo => 'You decide where copies go.';

  @override
  String get yourDeviceIsTheSourceOfTruthYouCan =>
      'Your device is the source of truth. You can create an open .creaturely backup to Files, iCloud Drive, Google Drive, Dropbox, or another provider you choose.';

  @override
  String get cloudAccessIsOptionalDecliningItNeverLimitsThe =>
      'Cloud access is optional. Declining it never limits the journal.';

  @override
  String get optionalRecoverySnapshotsAreBackupAndRestoreNotLive =>
      'Optional recovery snapshots are backup and restore—not live multi-device sync.';

  @override
  String get reminders => 'Reminders';

  @override
  String get helpfulNeverRequired => 'Helpful, never required.';

  @override
  String get creaturelyCanScheduleMedicationBreathingAndWeightRemindersOn =>
      'Creaturely can schedule medication, breathing, and weight reminders on this device. You can say no now and change this later.';

  @override
  String get notificationsAreOffMedicationSchedulesAndDueDosesWill =>
      'Notifications are off. Medication schedules and due doses will still appear inside Creaturely.';

  @override
  String get notificationsAreReadyIndividualSchedulesRemainUnderYourControl =>
      'Notifications are ready. Individual schedules remain under your control.';

  @override
  String get allowReminders => 'Allow reminders';

  @override
  String get firstAnimal => 'First animal';

  @override
  String get whoAreYouCaringFor => 'Who are you caring for?';

  @override
  String get onlyANameAndSpeciesAreNeededAddOr =>
      'Only a name and species are needed. Add or change anything else later.';

  @override
  String get enterAName => 'Enter a name.';

  @override
  String get approximateAgeInMonthsOptional => 'Approximate age in months (optional)';

  @override
  String get enterAWholeNumberOfMonths => 'Enter a whole number of months.';

  @override
  String get iUnderstandThisIsAJournalNotVeterinaryCare =>
      'I understand this is a journal, not veterinary care.';

  @override
  String get pageUnavailable => 'Page unavailable';

  @override
  String get thisPageCouldNotBeOpened => 'This page could not be opened';

  @override
  String get returnToTheAnimalsDashboard => 'Return to the Animals dashboard.';

  @override
  String get goToAnimals => 'Go to Animals';

  @override
  String get creaturelyCouldNotOpenTheLocalJournal => 'Creaturely could not open the local journal';

  @override
  String get creaturelyNavigation => 'Creaturely navigation';

  @override
  String get reminderIsIncomplete => 'Reminder is incomplete.';

  @override
  String get weightReminderIsIncomplete => 'Weight reminder is incomplete.';

  @override
  String get remindersCouldNotBeUpdatedYourJournalIsSaved =>
      'Reminders could not be updated. Your journal is saved.';

  @override
  String get retry => 'Retry';

  @override
  String get medicationReminders => 'Medication reminders';

  @override
  String get remindersTheKeeperHasConfiguredForMedicationCare =>
      'Reminders the keeper has configured for medication care.';

  @override
  String get remindersTheKeeperHasConfiguredForManualBreathingChecks =>
      'Reminders the keeper has configured for manual breathing checks.';

  @override
  String get recordAWeighInWhenItWorksForYou => 'Record a weigh-in when it works for you.';

  @override
  String get remindersTheKeeperHasConfiguredForRecordingWeightChecks =>
      'Reminders the keeper has configured for recording weight checks.';

  @override
  String medicationForAnimal(Object value1, Object value2) {
    return '$value1 for $value2';
  }

  @override
  String get recoveredImageNotice =>
      'An image selection was recovered. You can use it in an animal profile or document.';

  @override
  String get attachmentCleanupFailed => 'Unused files could not be removed. Your journal is saved.';

  @override
  String get fileOperationFailed => 'The file could not be opened. Try choosing it again.';

  @override
  String timerStatusLabel(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'ready': 'Ready',
      'running': 'Running',
      'paused': 'Paused',
      'completed': 'Completed',
      'cancelled': 'Cancelled',
      'saved': 'Saved',
      'other': 'Unknown',
    });
    return '$_temp0';
  }

  @override
  String respiratoryContextLabel(String value) {
    String _temp0 = intl.Intl.selectLogic(value, {
      'sleeping': 'Sleeping',
      'resting': 'Resting',
      'other': 'Unknown',
    });
    return '$_temp0';
  }

  @override
  String get operationFailed => 'Could not complete this action. Please try again.';

  @override
  String get medicationDose => 'Medication dose';

  @override
  String get sleepingBreathingCheck => 'Sleeping breathing check';

  @override
  String get restingBreathingCheck => 'Resting breathing check';

  @override
  String get manualRespiratoryRateReminder => 'Manual respiratory-rate reminder';

  @override
  String get recordAWeighIn => 'Record a weigh-in';

  @override
  String get categoryVaccination => 'Vaccination';

  @override
  String get categoryLaboratory => 'Laboratory';

  @override
  String get categoryImaging => 'Imaging';

  @override
  String get categoryPrescription => 'Prescription';

  @override
  String get categoryInsurance => 'Insurance';

  @override
  String get categoryIdentification => 'Identification';

  @override
  String get healthAllergy => 'Allergy';

  @override
  String get healthCondition => 'Condition';

  @override
  String get pdfSubject => 'User-created animal health journal summary';

  @override
  String get pdfKeywords =>
      'Creaturely, animal health journal, diagnostic disclaimer, veterinary advice';

  @override
  String get careSummary => 'Care summary';

  @override
  String get noBreathingSessionsInRange => 'No resting breathing sessions in this range.';

  @override
  String get breaths => 'Breaths';

  @override
  String get elapsed => 'Elapsed';

  @override
  String get rate => 'Rate';

  @override
  String get includedDocuments => 'Included documents';

  @override
  String get pdfDisclaimer =>
      'Creaturely is a personal journal, not a diagnostic tool. This summary is user-entered information and does not replace veterinary advice.';

  @override
  String get chooseDate => 'Choose date';

  @override
  String get countSleepingBreaths => 'Count breaths when your animal is calm and sleeping.';

  @override
  String get countRestingBreaths => 'Count breaths when your animal is calm and resting.';

  @override
  String pdfTitle(Object name) {
    return 'Creaturely health summary - $name';
  }

  @override
  String pdfPage(Object page, Object pages) {
    return 'Creaturely - Page $page of $pages';
  }

  @override
  String pdfRange(Object start, Object end) {
    return 'Journal range: $start to $end';
  }

  @override
  String pdfBreathingSummary(Object count, Object latest, Object minimum, Object maximum) {
    return '$count breathing sessions; latest $latest, range $minimum to $maximum breaths/minute.';
  }

  @override
  String pdfActiveMedications(Object count) {
    return '$count active medications.';
  }

  @override
  String pdfGivenDoses(Object given, Object recorded) {
    return '$given of $recorded recorded doses marked given.';
  }

  @override
  String pdfHealthCount(Object count) {
    return '$count physical-health records.';
  }

  @override
  String pdfSeconds(Object seconds) {
    return '$seconds s';
  }

  @override
  String pdfRate(Object rate) {
    return '$rate/min';
  }

  @override
  String pdfFrom(Object date) {
    return 'From $date';
  }

  @override
  String pdfThrough(Object date) {
    return 'through $date';
  }

  @override
  String pdfStrength(Object value) {
    return 'Strength: $value';
  }

  @override
  String pdfPrescriber(Object value) {
    return 'Prescriber: $value';
  }

  @override
  String pdfPharmacy(Object value) {
    return 'Pharmacy: $value';
  }

  @override
  String pdfPrescription(Object value) {
    return 'Prescription: $value';
  }

  @override
  String pdfRefills(Object value) {
    return 'Refills remaining: $value';
  }

  @override
  String pdfNextRefill(Object date) {
    return 'Next refill: $date';
  }

  @override
  String pdfNotes(Object value) {
    return 'Notes: $value';
  }

  @override
  String timelineBreathingDetail(Object rate, Object context) {
    return '$rate breaths/min • $context';
  }

  @override
  String get journalOpenFailedHelp =>
      'Try again or reopen Creaturely. Your journal has not been reset.';

  @override
  String get backupCorruptHelp => 'The file is damaged or incomplete. Choose another backup.';

  @override
  String get backupUnsupportedHelp =>
      'This backup version is not supported by this version of Creaturely.';

  @override
  String get fileUnavailableHelp =>
      'A required file is unavailable or could not be read. Check the selected file and available storage.';

  @override
  String get journalDataUnavailable => 'Unable to load journal data';

  @override
  String get journalDataUnavailableHelp => 'Try again. Your changes on this screen are kept.';

  @override
  String get automaticRecoveryFailed => 'Automatic backup failed. Your local journal is available.';

  @override
  String get temporaryExportCleanupFailed => 'The temporary export file could not be removed.';

  @override
  String countedBreathNoun(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'breaths',
      one: 'breath',
    );
    return '$_temp0';
  }

  @override
  String entryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entries',
      one: '1 entry',
    );
    return '$_temp0';
  }

  @override
  String ageMonthsOld(int months, String qualifier) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months months',
      one: '1 month',
    );
    return '$_temp0 old$qualifier';
  }

  @override
  String ageYearsOld(int years, int months, String qualifier) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years years',
      one: '1 year',
    );
    String _temp1 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: ', $months months',
      one: ', 1 month',
      zero: '',
    );
    return '$_temp0$_temp1 old$qualifier';
  }

  @override
  String get respiratoryRateUnit => 'breaths/min';

  @override
  String get noBreathingDataInRange => 'No breathing data in this range';

  @override
  String get noWeightDataInRange => 'No weight data in this range';

  @override
  String get enterCompleteServiceUrl => 'Enter a complete URL, including https://.';

  @override
  String get feedbackUnavailable =>
      'Tap feedback is unavailable. Your breaths are still being counted.';

  @override
  String get notificationActionFailed => 'Could not complete the reminder action. Try again.';
}
