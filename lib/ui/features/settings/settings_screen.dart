import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/models.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../app_controller.dart';
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
    final settings = ref.watch(appControllerProvider).snapshot.settings;
    final controller = ref.read(appControllerProvider.notifier);
    final compact = usesCompactVerticalLayout(context);
    return Scaffold(
      appBar: AppBar(toolbarHeight: compact ? 48 : null, title: const Text('Settings')),
      body: ConstrainedPage(
        child: ListView(
          controller: _scrollController,
          children: [
            const PageHeading(
              title: 'Creaturely, your way',
              subtitle: 'Comfort, reminders, privacy, and your own copies.',
            ),
            SizedBox(height: compact ? 8 : 20),
            const SectionHeading('Appearance & units'),
            Card(
              child: Column(
                children: [
                  ListTile(
                    minTileHeight: 66,
                    leading: const Icon(Icons.contrast_rounded),
                    title: const Text('Theme'),
                    trailing: DropdownButton<AppThemePreference>(
                      value: settings.theme,
                      underline: const SizedBox.shrink(),
                      items: const [
                        DropdownMenuItem(value: AppThemePreference.system, child: Text('System')),
                        DropdownMenuItem(value: AppThemePreference.light, child: Text('Light')),
                        DropdownMenuItem(value: AppThemePreference.dark, child: Text('Dark')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          controller.saveSettings(settings.copyWith(theme: value));
                        }
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    minTileHeight: 66,
                    leading: const Icon(Icons.straighten_rounded),
                    title: const Text('Weight display'),
                    trailing: SegmentedButton<WeightUnit>(
                      segments: const [
                        ButtonSegment(value: WeightUnit.kilograms, label: Text('kg')),
                        ButtonSegment(value: WeightUnit.pounds, label: Text('lb')),
                      ],
                      selected: {settings.weightUnit},
                      showSelectedIcon: false,
                      onSelectionChanged: (values) =>
                          controller.saveSettings(settings.copyWith(weightUnit: values.first)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const SectionHeading('Recording feedback'),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    value: settings.hapticsEnabled,
                    onChanged: (value) =>
                        controller.saveSettings(settings.copyWith(hapticsEnabled: value)),
                    secondary: const Icon(Icons.vibration_rounded),
                    title: const Text('Haptic tap'),
                    subtitle: const Text('On by default for each recorded breath.'),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    value: settings.soundEnabled,
                    onChanged: (value) =>
                        controller.saveSettings(settings.copyWith(soundEnabled: value)),
                    secondary: const Icon(Icons.volume_up_outlined),
                    title: const Text('Tap sound'),
                    subtitle: const Text('Off by default.'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.timer_outlined),
                    title: const Text('Default breathing timer'),
                    trailing: DropdownButton<int>(
                      value: settings.defaultTimerSeconds,
                      underline: const SizedBox.shrink(),
                      items: const <int>[15, 20, 30, 60]
                          .map((value) => DropdownMenuItem(value: value, child: Text('$value s')))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          controller.saveSettings(settings.copyWith(defaultTimerSeconds: value));
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const SectionHeading('Reminders & recovery'),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    value: settings.notificationsAllowed,
                    onChanged: (value) async {
                      if (value) {
                        await controller.requestNotifications();
                      } else {
                        await controller.saveSettings(
                          settings.copyWith(notificationsAllowed: false),
                        );
                      }
                    },
                    secondary: const Icon(Icons.notifications_none_rounded),
                    title: const Text('Notifications'),
                    subtitle: Text(
                      settings.notificationsAllowed
                          ? 'Medication, breathing, and weight reminders can be scheduled.'
                          : 'Due care remains visible in the app.',
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    minTileHeight: 66,
                    leading: const Icon(Icons.cloud_sync_outlined),
                    title: const Text('Automatic recovery snapshots'),
                    subtitle: Text(
                      settings.automaticRecoveryEnabled
                          ? _providerName(settings.cloudProvider)
                          : 'Off • local data remains the source of truth',
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/recovery'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const SectionHeading('Your data'),
            Card(
              child: Column(
                children: [
                  ListTile(
                    minTileHeight: 66,
                    leading: const Icon(Icons.save_alt_rounded),
                    title: const Text('Backup, restore & pet export'),
                    subtitle: const Text('Save backups and save or share pet health summaries.'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/data'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    minTileHeight: 66,
                    leading: const Icon(Icons.delete_outline_rounded),
                    title: const Text('Delete local journal'),
                    subtitle: const Text('Remove records and app-managed attachments.'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/data/delete'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const SectionHeading('Help & feedback'),
            Card(
              child: Column(
                children: [
                  ListTile(
                    minTileHeight: 66,
                    leading: const Icon(Icons.bug_report_outlined),
                    title: const Text('Report a bug'),
                    subtitle: const Text('Open a private-data-safe GitHub issue form.'),
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
                    title: const Text('View Creaturely source'),
                    subtitle: const Text('github.com/Lyddon7522/creaturely'),
                    trailing: const Icon(Icons.open_in_new_rounded),
                    onTap: () => _openExternal(Uri.https('github.com', '/Lyddon7522/creaturely')),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    minTileHeight: 66,
                    leading: const Icon(Icons.content_copy_rounded),
                    title: const Text('Copy technical details'),
                    subtitle: const Text('App, platform, and locale only—never journal data.'),
                    trailing: const Icon(Icons.copy_rounded),
                    onTap: _copyTechnicalDetails,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const SectionHeading('Trust & transparency'),
            Card(
              child: Column(
                children: [
                  _legalTile(
                    context,
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy',
                    route: '/legal/privacy',
                  ),
                  const Divider(height: 1),
                  _legalTile(
                    context,
                    icon: Icons.gavel_outlined,
                    title: 'Terms',
                    route: '/legal/terms',
                  ),
                  const Divider(height: 1),
                  _legalTile(
                    context,
                    icon: Icons.medical_information_outlined,
                    title: 'Medical disclaimer',
                    route: '/legal/medical',
                  ),
                  const Divider(height: 1),
                  _legalTile(
                    context,
                    icon: Icons.code_rounded,
                    title: 'About & open-source licenses',
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

  Future<void> _openExternal(Uri uri) async {
    final opened = await ref.read(externalLinkServiceProvider).open(uri);
    if (!opened && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Could not open the link on this device.')));
    }
  }

  Future<void> _copyTechnicalDetails() async {
    final locale = Localizations.localeOf(context);
    final details =
        'Creaturely 1.0.0 (1)\n'
        'Platform: ${Platform.operatingSystem}\n'
        'OS version: ${Platform.operatingSystemVersion}\n'
        'Locale: ${locale.toLanguageTag()}';
    await Clipboard.setData(ClipboardData(text: details));
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Technical details copied.')));
    }
  }

  static String _providerName(CloudProvider provider) => switch (provider) {
    CloudProvider.cloudKit => 'Private CloudKit recovery',
    CloudProvider.googleDriveAppData => 'Google Drive appData recovery',
    CloudProvider.none => 'Provider not selected',
  };
}
