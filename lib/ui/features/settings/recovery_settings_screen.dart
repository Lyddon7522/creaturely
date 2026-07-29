import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../../data/backup_service.dart';
import '../../../domain/models.dart';
import '../../../platform/cloud_recovery_bridge.dart';
import '../../app_controller.dart';
import '../../core/widgets.dart';

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
    final settings = ref.watch(appControllerProvider).snapshot.settings;
    final platformProvider = Theme.of(context).platform == TargetPlatform.iOS
        ? CloudProvider.cloudKit
        : CloudProvider.googleDriveAppData;
    final provider = settings.cloudProvider == CloudProvider.none
        ? platformProvider
        : settings.cloudProvider;
    return Scaffold(
      appBar: AppBar(title: const Text('Recovery snapshots')),
      body: ConstrainedPage(
        maxWidth: 760,
        child: ListView(
          children: [
            const PageHeading(
              title: 'Optional recovery, not sync',
              subtitle:
                  'Local data always wins during normal use. Private provider storage is used '
                  'only after you opt in.',
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
                    onChanged: _working ? null : (value) => _toggle(value, provider, settings),
                    secondary: const Icon(Icons.cloud_sync_outlined),
                    title: const Text('Automatic recovery snapshots'),
                    subtitle: Text(_providerName(provider)),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.security_outlined),
                    title: const Text('Provider-managed encryption'),
                    subtitle: const Text(
                      'Creaturely does not invent an account or custom encryption scheme.',
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
                  label: const Text('Back up now'),
                ),
                OutlinedButton.icon(
                  onPressed: _working ? null : _authorize,
                  icon: const Icon(Icons.login_rounded),
                  label: const Text('Check account access'),
                ),
                IconButton(
                  tooltip: 'Refresh recovery list',
                  onPressed: _working ? null : _refresh,
                  icon: const Icon(Icons.refresh_rounded),
                ),
              ],
            ),
            const SizedBox(height: 22),
            const SectionHeading('Recovery points'),
            if (_snapshots.isEmpty)
              const EmptyState(
                icon: Icons.cloud_queue_rounded,
                title: 'No recovery snapshots',
                body: 'Create one when the provider is available.',
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
                        subtitle: Text('${_snapshots[index].byteLength} bytes'),
                        trailing: TextButton(
                          onPressed: _working ? null : () => _restore(_snapshots[index]),
                          child: const Text('Restore'),
                        ),
                      ),
                      if (index < _snapshots.length - 1) const Divider(height: 1),
                    ],
                  ],
                ),
              ),
            const SizedBox(height: 18),
            const CalmNotice(
              icon: Icons.auto_delete_outlined,
              text:
                  'Retention keeps the latest snapshot plus 7 daily, 4 weekly, and 6 monthly '
                  'points. Attachment blobs are deduplicated by SHA-256 inside each open backup.',
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

  Future<void> _refresh() async {
    setState(() {
      _working = true;
      _message = null;
    });
    try {
      final bridge = ref.read(cloudRecoveryBridgeProvider);
      final status = await bridge.status();
      final snapshots = List<CloudSnapshotInfo>.of(
        status == CloudRecoveryState.available ? await bridge.list() : const <CloudSnapshotInfo>[],
      );
      snapshots.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      if (mounted) {
        setState(() {
          _status = status;
          _snapshots = snapshots;
        });
      }
    } on MissingPluginException {
      if (mounted) {
        setState(() => _status = CloudRecoveryState.notConfigured);
      }
    } on CloudRecoveryException catch (error) {
      if (mounted) {
        setState(() {
          _status = error.state;
          _message = error.message;
        });
      }
    } on Object catch (error) {
      if (mounted) {
        setState(() {
          _status = CloudRecoveryState.unknownError;
          _message = error.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() => _working = false);
      }
    }
  }

  Future<void> _authorize() async {
    setState(() => _working = true);
    try {
      final value = await ref.read(cloudRecoveryBridgeProvider).authorize();
      if (mounted) {
        setState(() => _status = value);
      }
      await _refresh();
    } on CloudRecoveryException catch (error) {
      if (mounted) {
        setState(() {
          _status = error.state;
          _message = error.message;
        });
      }
    } on Object catch (error) {
      if (mounted) {
        setState(() => _message = error.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _working = false);
      }
    }
  }

  Future<void> _toggle(bool enabled, CloudProvider provider, AppSettings settings) async {
    if (enabled && _status != CloudRecoveryState.available) {
      await _authorize();
      if (_status != CloudRecoveryState.available) {
        return;
      }
    }
    await ref
        .read(appControllerProvider.notifier)
        .saveSettings(
          settings.copyWith(automaticRecoveryEnabled: enabled, cloudProvider: provider),
        );
    if (enabled) {
      await _createSnapshot();
    }
  }

  Future<void> _createSnapshot() async {
    setState(() {
      _working = true;
      _message = null;
    });
    try {
      final manager = await ref.read(recoverySnapshotManagerProvider.future);
      await manager.createAndPrune();
      await _refresh();
    } on CloudRecoveryException catch (error) {
      if (mounted) {
        setState(() {
          _status = error.state;
          _message = error.message;
        });
      }
    } on Object catch (error) {
      if (mounted) {
        setState(() => _message = error.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _working = false);
      }
    }
  }

  Future<void> _restore(CloudSnapshotInfo snapshot) async {
    setState(() => _working = true);
    try {
      final bytes = await ref.read(cloudRecoveryBridgeProvider).download(snapshot.id);
      const backups = CreaturelyBackupService();
      final validated = backups.validate(bytes);
      if (!mounted) {
        return;
      }
      final confirmed =
          await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Restore this recovery point?'),
              content: Text(
                '${validated.snapshot.animals.length} animals and '
                '${validated.snapshot.documents.length} documents were fully validated. '
                'The current journal will be safety-backed up first.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Restore'),
                ),
              ],
            ),
          ) ??
          false;
      if (!confirmed) {
        return;
      }
      final storage = await ref.read(documentStorageProvider.future);
      final application = await getApplicationDocumentsDirectory();
      await AtomicRestoreCoordinator(
        backups: backups,
        store: ref.read(repositoryProvider),
        documents: storage,
        safetyWriter: DirectorySafetySnapshotWriter(
          Directory(path.join(application.path, 'recovery')),
        ),
      ).restore(bytes);
      await ref.read(appControllerProvider.notifier).refresh(syncReminders: true);
    } on CloudRecoveryException catch (error) {
      if (mounted) {
        setState(() {
          _status = error.state;
          _message = error.message;
        });
      }
    } on Object catch (error) {
      if (mounted) {
        setState(() => _message = error.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _working = false);
      }
    }
  }

  String _statusText(CloudRecoveryState? state, CloudProvider provider) {
    if (state == null) {
      return 'Checking ${_providerName(provider)}…';
    }
    return switch (state) {
      CloudRecoveryState.available => '${_providerName(provider)} is available.',
      CloudRecoveryState.signedOut =>
        'The platform cloud account is signed out. Local journaling remains available.',
      CloudRecoveryState.offline =>
        'The cloud provider is offline. Local journaling remains available.',
      CloudRecoveryState.quotaExceeded => 'Cloud storage is full. Existing local data is safe.',
      CloudRecoveryState.conflict =>
        'The cloud provider reported a conflict. Existing local data was not changed.',
      CloudRecoveryState.notConfigured =>
        'This build is missing the platform recovery capability or release configuration.',
      CloudRecoveryState.permissionDenied =>
        'Cloud recovery access was declined. Local use is unaffected.',
      CloudRecoveryState.unknownError =>
        'The cloud provider returned an error. Local use is unaffected.',
    };
  }

  String _providerName(CloudProvider provider) => switch (provider) {
    CloudProvider.cloudKit => 'private CloudKit',
    CloudProvider.googleDriveAppData => 'Google Drive appData',
    CloudProvider.none => 'platform recovery',
  };
}
