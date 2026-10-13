import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../data/backup_service.dart';
import '../../../domain/models.dart';
import '../../../l10n/app_strings.dart';
import '../../../platform/cloud_recovery_bridge.dart';
import '../../app_controller.dart';
import '../../core/widgets.dart';
import 'data_management_screen.dart' show RestoreConfirmationDialog;

class RecoverySettingsScreen extends ConsumerStatefulWidget {
  const RecoverySettingsScreen({super.key});

  @override
  ConsumerState<RecoverySettingsScreen> createState() => _RecoverySettingsScreenState();
}

class _RecoverySettingsScreenState extends ConsumerState<RecoverySettingsScreen> {
  CloudRecoveryState? _status;
  List<CloudSnapshotInfo> _snapshots = const <CloudSnapshotInfo>[];
  bool _working = false;
  String? _message;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final preferences = ref.watch(settingsProvider);
    if (preferences.isLoading || preferences.hasError) {
      return QueryPane(error: preferences.error, onRetry: () => ref.invalidate(settingsProvider));
    }
    final settings = preferences.requireValue;
    final platformProvider = Theme.of(context).platform == TargetPlatform.iOS
        ? CloudProvider.cloudKit
        : CloudProvider.googleDriveAppData;
    final provider = settings.cloudProvider == CloudProvider.none
        ? platformProvider
        : settings.cloudProvider;
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).recoverySnapshots)),
      body: ConstrainedPage(
        maxWidth: 760,
        child: ListView(
          children: [
            PageHeading(
              title: AppLocalizations.of(context).optionalRecoveryNotSync,
              subtitle: AppLocalizations.of(context)
                  .localDataAlwaysWinsDuringNormalUsePrivateProvider,
            ),
            const SizedBox(height: 18),
            CalmNotice(
              icon: _status == CloudRecoveryState.available
                  ? Icons.cloud_done_outlined
                  : Icons.cloud_off_outlined,
              text: _statusText(_status, provider),
              tone: _status == CloudRecoveryState.available
                  ? NoticeTone.supportive
                  : NoticeTone.attention,
            ),
            if (_message != null) ...[
              const SizedBox(height: 10),
              Text(_message!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ],
            const SizedBox(height: 18),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    value: settings.automaticRecoveryEnabled,
                    onChanged: _working ? null : (value) => _toggle(value, provider),
                    secondary: const Icon(Icons.cloud_sync_outlined),
                    title: Text(AppLocalizations.of(context).automaticRecoverySnapshots),
                    subtitle: Text(
                      AppLocalizations.of(context).atMostOnceADay(_providerName(provider)),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.security_outlined),
                    title: Text(AppLocalizations.of(context).providerManagedEncryption),
                    subtitle: Text(
                      AppLocalizations.of(context)
                          .creaturelyDoesNotInventAnAccountOrCustomEncryption,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: _working || _status != CloudRecoveryState.available
                      ? null
                      : _createSnapshot,
                  icon: const Icon(Icons.backup_outlined),
                  label: Text(AppLocalizations.of(context).backUpNow),
                ),
                OutlinedButton.icon(
                  onPressed: _working ? null : _authorize,
                  icon: const Icon(Icons.login_rounded),
                  label: Text(AppLocalizations.of(context).checkAccountAccess),
                ),
                IconButton(
                  tooltip: AppLocalizations.of(context).refreshRecoveryList,
                  onPressed: _working ? null : _refresh,
                  icon: const Icon(Icons.refresh_rounded),
                ),
              ],
            ),
            const SizedBox(height: 22),
            SectionHeading(AppLocalizations.of(context).recoveryPoints),
            if (_snapshots.isEmpty)
              EmptyState(
                icon: Icons.cloud_queue_rounded,
                title: AppLocalizations.of(context).noRecoverySnapshots,
                body: AppLocalizations.of(context).createOneWhenTheProviderIsAvailable,
              )
            else
              Card(
                child: Column(
                  children: [
                    for (var index = 0; index < _snapshots.length; index++) ...[
                      ListTile(
                        leading: const Icon(Icons.restore_page_outlined),
                        title: Text(
                          DateFormat.yMMMd().add_jm().format(_snapshots[index].createdAt.toLocal()),
                        ),
                        subtitle: Text(
                          AppLocalizations.of(context).bytes(_snapshots[index].byteLength),
                        ),
                        trailing: TextButton(
                          onPressed: _working ? null : () => _restore(_snapshots[index]),
                          child: Text(AppLocalizations.of(context).restore),
                        ),
                      ),
                      if (index < _snapshots.length - 1) const Divider(height: 1),
                    ],
                  ],
                ),
              ),
            const SizedBox(height: 18),
            CalmNotice(
              icon: Icons.auto_delete_outlined,
              text: AppLocalizations.of(context).creaturelyKeepsTheNewestRecoveryPointPlusUpTo,
            ),
            if (_working) ...[
              const SizedBox(height: 18),
              const Center(child: CircularProgressIndicator()),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _run(Future<void> Function() action) async {
    if (_working) return;
    setState(() {
      _working = true;
      _message = null;
    });
    try {
      await action();
    } on MissingPluginException {
      if (mounted) setState(() => _status = CloudRecoveryState.notConfigured);
    } on CloudRecoveryException catch (error) {
      if (mounted) {
        setState(() {
          _status = error.state;
          _message = _statusText(error.state, CloudProvider.none);
        });
      }
    } on Object {
      if (mounted) setState(() => _message = AppLocalizations.of(context).operationFailed);
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  Future<void> _loadSnapshots() async {
    if (!mounted) return;
    final bridge = ref.read(cloudRecoveryBridgeProvider);
    final status = await bridge.status();
    final snapshots = List<CloudSnapshotInfo>.of(
      status == CloudRecoveryState.available ? await bridge.list() : const [],
    )..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    if (mounted) {
      setState(() {
        _status = status;
        _snapshots = snapshots;
      });
    }
  }

  Future<void> _refresh() => _run(_loadSnapshots);
  Future<void> _authorize() => _run(() async {
    final bridge = ref.read(cloudRecoveryBridgeProvider);
    final status = await bridge.authorize();
    if (!mounted) return;
    setState(() => _status = status);
    await _loadSnapshots();
  });

  Future<void> _toggle(bool enabled, CloudProvider provider) => _run(() async {
    final settings = ref.read(settingsControllerProvider.notifier);
    final bridge = ref.read(cloudRecoveryBridgeProvider);
    if (enabled && _status != CloudRecoveryState.available) {
      final status = await bridge.authorize();
      if (!mounted) return;
      setState(() => _status = status);
      if (status != CloudRecoveryState.available) return;
    }
    await settings.updateSettings(
      (current) => current.copyWith(automaticRecoveryEnabled: enabled, cloudProvider: provider),
    );
    if (enabled && mounted) await _createAndReload();
  });

  Future<void> _createAndReload() async {
    if (!mounted) return;
    final manager = await ref.read(recoverySnapshotManagerProvider.future);
    if (!mounted) return;
    await manager.createAndPrune(force: true);
    if (mounted) await _loadSnapshots();
  }

  Future<void> _createSnapshot() => _run(_createAndReload);

  Future<void> _restore(CloudSnapshotInfo snapshot) => _run(() async {
    final bridge = ref.read(cloudRecoveryBridgeProvider);
    final restore = ref.read(recoveryControllerProvider.notifier);
    final bytes = await bridge.download(snapshot.id);
    final validated = await const CreaturelyBackupService().validateAsync(bytes);
    if (!mounted) return;
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) => RestoreConfirmationDialog(validated: validated),
        ) ??
        false;
    if (confirmed && mounted) await restore.restore(validated);
  });

  String _statusText(CloudRecoveryState? state, CloudProvider provider) {
    if (state == null) {
      return AppLocalizations.of(context).checking(_providerName(provider));
    }
    return switch (state) {
      CloudRecoveryState.available => AppLocalizations.of(
        context,
      ).isAvailable(_providerName(provider)),
      CloudRecoveryState.signedOut => AppLocalizations.of(
        context,
      ).thePlatformCloudAccountIsSignedOutLocalJournaling,
      CloudRecoveryState.offline => AppLocalizations.of(
        context,
      ).theCloudProviderIsOfflineLocalJournalingRemainsAvailable,
      CloudRecoveryState.quotaExceeded => AppLocalizations.of(
        context,
      ).cloudStorageIsFullExistingLocalDataIsSafe,
      CloudRecoveryState.conflict => AppLocalizations.of(
        context,
      ).theCloudProviderReportedAConflictExistingLocalData,
      CloudRecoveryState.notConfigured => AppLocalizations.of(
        context,
      ).thisBuildIsMissingThePlatformRecoveryCapabilityOr,
      CloudRecoveryState.permissionDenied => AppLocalizations.of(
        context,
      ).cloudRecoveryAccessWasDeclinedLocalUseIsUnaffected,
      CloudRecoveryState.unknownError => AppLocalizations.of(
        context,
      ).theCloudProviderReturnedAnErrorLocalUseIs,
    };
  }

  String _providerName(CloudProvider provider) => switch (provider) {
    CloudProvider.cloudKit => AppLocalizations.of(context).privateCloudKit,
    CloudProvider.googleDriveAppData => AppLocalizations.of(context).googleDriveAppData,
    CloudProvider.none => AppLocalizations.of(context).platformRecovery,
  };
}
