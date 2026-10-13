import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/models.dart';
import '../../../l10n/app_strings.dart';
import '../../app_controller.dart';
import '../../core/commands.dart';
import '../../core/widgets.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final preferences = ref.watch(settingsProvider);
    if (preferences.isLoading || preferences.hasError) {
      return QueryPane(error: preferences.error, onRetry: () => ref.invalidate(settingsProvider));
    }
    final settings = preferences.requireValue;
    final controller = ref.read(settingsControllerProvider.notifier);
    final compact = usesCompactVerticalLayout(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: compact ? 48 : null,
        title: Text(AppLocalizations.of(context).settings),
      ),
      body: ConstrainedPage(
        child: ListView(
          controller: _scrollController,
          children: [
            PageHeading(
              title: AppLocalizations.of(context).creaturelyYourWay,
              subtitle: AppLocalizations.of(context).comfortRemindersPrivacyAndYourOwnCopies,
            ),
            SizedBox(height: compact ? 8 : 20),
            SectionHeading(AppLocalizations.of(context).appearanceUnits),
            Card(
              child: Column(
                children: [
                  ListTile(
                    minTileHeight: 66,
                    leading: const Icon(Icons.contrast_rounded),
                    title: Text(AppLocalizations.of(context).theme),
                    trailing: DropdownButton<AppThemePreference>(
                      value: settings.theme,
                      underline: const SizedBox.shrink(),
                      items: [
                        DropdownMenuItem(
                          value: AppThemePreference.system,
                          child: Text(AppLocalizations.of(context).system),
                        ),
                        DropdownMenuItem(
                          value: AppThemePreference.light,
                          child: Text(AppLocalizations.of(context).light),
                        ),
                        DropdownMenuItem(
                          value: AppThemePreference.dark,
                          child: Text(AppLocalizations.of(context).dark),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          _updateSettings((current) => current.copyWith(theme: value));
                        }
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    minTileHeight: 66,
                    leading: const Icon(Icons.straighten_rounded),
                    title: Text(AppLocalizations.of(context).weightDisplay),
                    trailing: SegmentedButton<WeightUnit>(
                      segments: const [
                        ButtonSegment(value: WeightUnit.kilograms, label: Text('kg')),
                        ButtonSegment(value: WeightUnit.pounds, label: Text('lb')),
                      ],
                      selected: {settings.weightUnit},
                      showSelectedIcon: false,
                      onSelectionChanged: (values) =>
                          _updateSettings((current) => current.copyWith(weightUnit: values.first)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SectionHeading(AppLocalizations.of(context).recordingFeedback),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    value: settings.hapticsEnabled,
                    onChanged: (value) =>
                        _updateSettings((current) => current.copyWith(hapticsEnabled: value)),
                    secondary: const Icon(Icons.vibration_rounded),
                    title: Text(AppLocalizations.of(context).hapticTap),
                    subtitle: Text(AppLocalizations.of(context).onByDefaultForEachRecordedBreath),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    value: settings.soundEnabled,
                    onChanged: (value) =>
                        _updateSettings((current) => current.copyWith(soundEnabled: value)),
                    secondary: const Icon(Icons.volume_up_outlined),
                    title: Text(AppLocalizations.of(context).tapSound),
                    subtitle: Text(AppLocalizations.of(context).offByDefault),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.timer_outlined),
                    title: Text(AppLocalizations.of(context).defaultBreathingTimer),
                    trailing: DropdownButton<int>(
                      value: settings.defaultTimerSeconds,
                      underline: const SizedBox.shrink(),
                      items: const <int>[15, 20, 30, 60]
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(AppLocalizations.of(context).s(value)),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          _updateSettings(
                            (current) => current.copyWith(defaultTimerSeconds: value),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SectionHeading(AppLocalizations.of(context).remindersRecovery),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    value: settings.notificationsAllowed,
                    onChanged: (value) async {
                      if (value) {
                        await runUiCommand(context, () async {
                          await controller.requestNotifications();
                        });
                      } else {
                        await _updateSettings(
                          (current) => current.copyWith(notificationsAllowed: false),
                        );
                      }
                    },
                    secondary: const Icon(Icons.notifications_none_rounded),
                    title: Text(AppLocalizations.of(context).notifications),
                    subtitle: Text(
                      settings.notificationsAllowed
                          ? AppLocalizations.of(context)
                                .medicationBreathingAndWeightRemindersCanBeScheduled
                          : AppLocalizations.of(context).dueCareRemainsVisibleInTheApp,
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    minTileHeight: 66,
                    leading: const Icon(Icons.cloud_sync_outlined),
                    title: Text(AppLocalizations.of(context).automaticRecoverySnapshots),
                    subtitle: Text(
                      settings.automaticRecoveryEnabled
                          ? _providerName(settings.cloudProvider)
                          : AppLocalizations.of(context).offLocalDataRemainsTheSourceOfTruth,
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/recovery'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SectionHeading(AppLocalizations.of(context).yourData),
            Card(
              child: Column(
                children: [
                  ListTile(
                    minTileHeight: 66,
                    leading: const Icon(Icons.save_alt_rounded),
                    title: Text(AppLocalizations.of(context).backupRestorePetExport),
                    subtitle: Text(
                      AppLocalizations.of(context).saveBackupsAndSaveOrSharePetHealthSummaries,
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/data'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    minTileHeight: 66,
                    leading: const Icon(Icons.delete_outline_rounded),
                    title: Text(AppLocalizations.of(context).deleteLocalJournal),
                    subtitle: Text(
                      AppLocalizations.of(context).removeRecordsAndAppManagedAttachments,
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/data/delete'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SectionHeading(AppLocalizations.of(context).helpFeedback),
            Card(
              child: Column(
                children: [
                  ListTile(
                    minTileHeight: 66,
                    leading: const Icon(Icons.bug_report_outlined),
                    title: Text(AppLocalizations.of(context).reportABug),
                    subtitle: Text(
                      AppLocalizations.of(context).openAPrivateDataSafeGitHubIssueForm,
                    ),
                    trailing: const Icon(Icons.open_in_new_rounded),
                    onTap: () => _openExternal(
                      Uri.https('github.com', '/Lyddon7522/creaturely/issues/new', <String, String>{
                        'template': 'bug_report.yml',
                      }),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    minTileHeight: 66,
                    leading: const Icon(Icons.code_rounded),
                    title: Text(AppLocalizations.of(context).viewCreaturelySource),
                    subtitle: const Text('github.com/Lyddon7522/creaturely'),
                    trailing: const Icon(Icons.open_in_new_rounded),
                    onTap: () => _openExternal(Uri.https('github.com', '/Lyddon7522/creaturely')),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    minTileHeight: 66,
                    leading: const Icon(Icons.content_copy_rounded),
                    title: Text(AppLocalizations.of(context).copyTechnicalDetails),
                    subtitle: Text(
                      AppLocalizations.of(context).appPlatformAndLocaleOnlyNeverJournalData,
                    ),
                    trailing: const Icon(Icons.copy_rounded),
                    onTap: _copyTechnicalDetails,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SectionHeading(AppLocalizations.of(context).trustTransparency),
            Card(
              child: Column(
                children: [
                  _legalTile(
                    context,
                    icon: Icons.privacy_tip_outlined,
                    title: AppLocalizations.of(context).privacy,
                    route: '/legal/privacy',
                  ),
                  const Divider(height: 1),
                  _legalTile(
                    context,
                    icon: Icons.gavel_outlined,
                    title: AppLocalizations.of(context).terms,
                    route: '/legal/terms',
                  ),
                  const Divider(height: 1),
                  _legalTile(
                    context,
                    icon: Icons.medical_information_outlined,
                    title: AppLocalizations.of(context).medicalDisclaimer2,
                    route: '/legal/medical',
                  ),
                  const Divider(height: 1),
                  _legalTile(
                    context,
                    icon: Icons.code_rounded,
                    title: AppLocalizations.of(context).aboutOpenSourceLicenses,
                    route: '/legal/about',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Text(
              AppLocalizations.of(context).privacySummary,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _legalTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
  }) => ListTile(
    minTileHeight: 62,
    leading: Icon(icon),
    title: Text(title),
    trailing: const Icon(Icons.chevron_right_rounded),
    onTap: () => context.push(route),
  );

  Future<void> _openExternal(Uri uri) => runUiCommand(context, () async {
    final opened = await ref.read(externalLinkServiceProvider).open(uri);
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).couldNotOpenTheLinkOnThisDevice)),
      );
    }
  });

  Future<void> _copyTechnicalDetails() => runUiCommand(context, () async {
    final locale = Localizations.localeOf(context);
    final details = AppLocalizations.of(context).creaturely1001PlatformOSVersionLocale(
      Platform.operatingSystem,
      Platform.operatingSystemVersion,
      locale.toLanguageTag(),
    );
    await ref.read(mediaServiceProvider).copyText(details);
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).technicalDetailsCopied)));
    }
  });

  Future<void> _updateSettings(AppSettings Function(AppSettings) update) => runUiCommand(
    context,
    () => ref.read(settingsControllerProvider.notifier).updateSettings(update),
  );

  static String _providerName(CloudProvider provider) => switch (provider) {
    CloudProvider.cloudKit => appStrings.privateCloudKitRecovery,
    CloudProvider.googleDriveAppData => appStrings.googleDriveAppDataRecovery,
    CloudProvider.none => appStrings.providerNotSelected,
  };
}
