import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../data/backup_service.dart';
import '../../../data/export_service.dart';
import '../../../domain/models.dart';
import '../../app_controller.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';

class DataManagementScreen extends ConsumerStatefulWidget {
  const DataManagementScreen({this.initialAnimalId, this.petExportOnly = false, super.key});

  final String? initialAnimalId;
  final bool petExportOnly;

  @override
  ConsumerState<DataManagementScreen> createState() => _DataManagementScreenState();
}

class _DataManagementScreenState extends ConsumerState<DataManagementScreen> {
  static const CreaturelyBackupService _backups = CreaturelyBackupService();
  static const PetExportService _exports = PetExportService();

  String? _animalId;
  DateTimeRange _range = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)),
    end: DateTime.now(),
  );
  final Set<String> _selectedDocuments = <String>{};
  bool _working = false;

  @override
  void initState() {
    super.initState();
    _animalId = widget.initialAnimalId;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appControllerProvider);
    final animals = state.activeAnimals;
    if (_animalId == null || !animals.any((value) => value.id == _animalId)) {
      _animalId = state.selectedAnimal?.id ?? animals.firstOrNull?.id;
    }
    final selectedAnimal = animals.where((value) => value.id == _animalId).firstOrNull;
    final documents = state.snapshot.documents
        .where(
          (value) =>
              value.animalId == _animalId &&
              calendarDateIsWithin(value.documentDate, _range.start, _range.end),
        )
        .toList(growable: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.petExportOnly ? 'Pet export' : 'Backup, restore & pet export'),
      ),
      body: ConstrainedPage(
        maxWidth: 820,
        child: ListView(
          children: [
            PageHeading(
              title: widget.petExportOnly
                  ? 'Export ${selectedAnimal?.name ?? 'pet'}’s health history'
                  : 'Copies you control',
              subtitle: widget.petExportOnly
                  ? 'Choose a date range and create a vet-friendly PDF, CSV, or document package.'
                  : 'Create an open backup, safely restore one, or save and share a focused pet '
                        'health summary.',
            ),
            if (!widget.petExportOnly) ...[
              const SizedBox(height: 18),
              const CalmNotice(
                icon: Icons.lock_outline_rounded,
                text:
                    'Save-file and share actions open only when you choose them. Creaturely performs '
                    'no upload on its own during normal journaling.',
                tone: NoticeTone.supportive,
              ),
              const SizedBox(height: 22),
              const SectionHeading('Whole-journal backup'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      minTileHeight: 72,
                      leading: const Icon(Icons.archive_outlined),
                      title: const Text('Create .creaturely backup'),
                      subtitle: Text(
                        '${state.snapshot.animals.length} animals • '
                        '${state.snapshot.documents.length} documents',
                      ),
                      trailing: const Icon(Icons.save_alt_rounded),
                      onTap: _working ? null : _createBackup,
                    ),
                    const Divider(height: 1),
                    ListTile(
                      minTileHeight: 72,
                      leading: const Icon(Icons.settings_backup_restore_rounded),
                      title: const Text('Restore from .creaturely'),
                      subtitle: const Text('Fully validated before an atomic replacement.'),
                      trailing: const Icon(Icons.folder_open_rounded),
                      onTap: _working ? null : _restoreBackup,
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 22),
            SectionHeading(widget.petExportOnly ? 'Export options' : 'Pet export'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: _animalId,
                      decoration: const InputDecoration(labelText: 'Animal'),
                      items: animals
                          .map(
                            (animal) =>
                                DropdownMenuItem(value: animal.id, child: Text(animal.name)),
                          )
                          .toList(growable: false),
                      onChanged: (value) => setState(() {
                        _animalId = value;
                        _selectedDocuments.clear();
                      }),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: _pickRange,
                      borderRadius: BorderRadius.circular(14),
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: 'Date range'),
                        child: Text(
                          '${DateFormat.yMMMd().format(_range.start)} – '
                          '${DateFormat.yMMMd().format(_range.end)}',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Original documents to include',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    if (documents.isEmpty)
                      const Text('No documents in this range.')
                    else
                      Card(
                        color: Theme.of(context).colorScheme.surfaceContainerLow,
                        child: Column(
                          children: [
                            for (final document in documents)
                              CheckboxListTile(
                                value: _selectedDocuments.contains(document.id),
                                onChanged: (selected) => setState(
                                  () => selected == true
                                      ? _selectedDocuments.add(document.id)
                                      : _selectedDocuments.remove(document.id),
                                ),
                                title: Text(document.title),
                                subtitle: Text(document.category.name),
                              ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      key: const ValueKey('open_pet_export'),
                      onPressed: _working || _animalId == null ? null : _showExportChooser,
                      icon: const Icon(Icons.ios_share_rounded),
                      label: const Text('Export or share'),
                    ),
                  ],
                ),
              ),
            ),
            if (_working) ...[
              const SizedBox(height: 20),
              const Center(child: CircularProgressIndicator()),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Future<void> _createBackup() async {
    setState(() => _working = true);
    try {
      final snapshot = ref.read(appControllerProvider).snapshot;
      final storage = await ref.read(documentStorageProvider.future);
      final attachments = await storage.readAttachments(snapshot.documents);
      final animalPhotos = await storage.readAnimalPhotos(snapshot.animals);
      final bytes = _backups.create(
        snapshot: snapshot,
        attachments: attachments,
        animalPhotos: animalPhotos,
      );
      final fileName =
          'creaturely-${DateFormat('yyyyMMdd-HHmm').format(DateTime.now())}.creaturely';
      final savedAt = await ref
          .read(documentSaveServiceProvider)
          .save(
            fileName: fileName,
            dialogTitle: 'Save Creaturely backup',
            bytes: bytes,
            allowedExtensions: const <String>['creaturely'],
          );
      if (savedAt != null && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Creaturely backup saved.')));
      }
    } on Object catch (error) {
      _showError('Backup could not be created', error);
    } finally {
      if (mounted) {
        setState(() => _working = false);
      }
    }
  }

  Future<void> _restoreBackup() async {
    final selectedFile = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: <String>['creaturely', 'zip'],
    );
    final selectedPath = selectedFile?.path;
    if (selectedPath == null) {
      return;
    }
    setState(() => _working = true);
    try {
      final bytes = await File(selectedPath).readAsBytes();
      final validated = _backups.validate(bytes);
      if (!mounted) {
        return;
      }
      final confirmed =
          await showDialog<bool>(
            context: context,
            builder: (context) => RestoreConfirmationDialog(validated: validated),
          ) ??
          false;
      if (!confirmed) {
        return;
      }
      final documents = await ref.read(documentStorageProvider.future);
      final appDirectory = await getApplicationDocumentsDirectory();
      final coordinator = AtomicRestoreCoordinator(
        backups: _backups,
        store: ref.read(repositoryProvider),
        documents: documents,
        safetyWriter: DirectorySafetySnapshotWriter(
          Directory(path.join(appDirectory.path, 'recovery')),
        ),
      );
      await coordinator.restore(bytes);
      await ref.read(appControllerProvider.notifier).refresh(syncReminders: true);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Backup restored successfully.')));
      }
    } on Object catch (error) {
      _showError('Restore stopped safely', error);
    } finally {
      if (mounted) {
        setState(() => _working = false);
      }
    }
  }

  Future<void> _shareExport(_ExportChoice choice) async {
    setState(() => _working = true);
    TemporaryExportFiles? files;
    try {
      final bundle = await _buildExport();
      files = await TemporaryExportFiles.write(await getTemporaryDirectory(), bundle);
      final (file, mime) = switch (choice) {
        _ExportChoice.pdf => (files.pdf, 'application/pdf'),
        _ExportChoice.csv => (files.csv, 'text/csv'),
        _ExportChoice.zip => (files.zip, 'application/zip'),
      };
      await SharePlus.instance.share(
        ShareParams(
          title: 'Creaturely pet health summary',
          subject: 'Creaturely pet health export',
          files: <XFile>[XFile(file.path, mimeType: mime)],
        ),
      );
    } on Object catch (error) {
      _showError('Export could not be shared', error);
    } finally {
      await files?.cleanup();
      if (mounted) {
        setState(() => _working = false);
      }
    }
  }

  Future<void> _showExportChooser() => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => _ExportChooserSheet(onSave: _saveExport, onShare: _shareExport),
  );

  Future<void> _saveExport(_ExportChoice choice) async {
    setState(() => _working = true);
    try {
      final bundle = await _buildExport();
      final bytes = switch (choice) {
        _ExportChoice.pdf => bundle.pdf,
        _ExportChoice.csv => bundle.csv,
        _ExportChoice.zip => bundle.zip,
      };
      final animal = ref
          .read(appControllerProvider)
          .snapshot
          .animals
          .where((value) => value.id == _animalId)
          .firstOrNull;
      final animalName = _safeFileName(animal?.name ?? 'pet');
      final fileName =
          'creaturely-$animalName-${DateFormat('yyyyMMdd').format(DateTime.now())}.${choice.extension}';
      final savedAt = await ref
          .read(documentSaveServiceProvider)
          .save(
            fileName: fileName,
            dialogTitle: 'Save ${choice.label} pet export',
            bytes: bytes,
            allowedExtensions: <String>[choice.extension],
          );
      if (savedAt != null && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${choice.label} export saved.')));
      }
    } on Object catch (error) {
      _showError('${choice.label} export could not be saved', error);
    } finally {
      if (mounted) {
        setState(() => _working = false);
      }
    }
  }

  Future<PetExportBundle> _buildExport() async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final snapshot = ref.read(appControllerProvider).snapshot;
    final storage = await ref.read(documentStorageProvider.future);
    final selectedDocuments = snapshot.documents.where(
      (document) => _selectedDocuments.contains(document.id),
    );
    final attachments = await storage.readAttachments(selectedDocuments);
    return _exports.build(
      snapshot: snapshot,
      animalId: _animalId!,
      startDate: _range.start,
      endDate: _range.end,
      selectedDocumentIds: _selectedDocuments,
      attachmentBytes: attachments,
      locale: locale,
    );
  }

  String _safeFileName(String value) {
    final sanitized = value.trim().replaceAll(RegExp(r'[\\/:*?"<>|]'), '-');
    return sanitized.isEmpty ? 'pet' : sanitized;
  }

  Future<void> _pickRange() async {
    final value = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: _range,
    );
    if (value != null) {
      setState(() {
        _range = value;
        _selectedDocuments.clear();
      });
    }
  }

  void _showError(String title, Object error) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$title: $error')));
  }
}

enum _ExportChoice {
  pdf(
    label: 'PDF',
    title: 'PDF summary',
    description: 'A readable overview of the selected dates.',
    extension: 'pdf',
    icon: Icons.picture_as_pdf_outlined,
  ),
  csv(
    label: 'CSV',
    title: 'CSV data',
    description: 'Raw journal data for a spreadsheet.',
    extension: 'csv',
    icon: Icons.table_view_outlined,
  ),
  zip(
    label: 'ZIP',
    title: 'ZIP package',
    description: 'PDF, CSV, and any selected original documents.',
    extension: 'zip',
    icon: Icons.folder_zip_outlined,
  );

  const _ExportChoice({
    required this.label,
    required this.title,
    required this.description,
    required this.extension,
    required this.icon,
  });

  final String label;
  final String title;
  final String description;
  final String extension;
  final IconData icon;
}

class _ExportChooserSheet extends StatefulWidget {
  const _ExportChooserSheet({required this.onSave, required this.onShare});

  final ValueChanged<_ExportChoice> onSave;
  final ValueChanged<_ExportChoice> onShare;

  @override
  State<_ExportChooserSheet> createState() => _ExportChooserSheetState();
}

class _ExportChooserSheetState extends State<_ExportChooserSheet> {
  _ExportChoice _choice = _ExportChoice.pdf;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Choose export format', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(
            'Select one format, then save it to Files or share it with another app.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          SegmentedButton<_ExportChoice>(
            segments: [
              for (final choice in _ExportChoice.values)
                ButtonSegment<_ExportChoice>(
                  value: choice,
                  icon: Icon(choice.icon),
                  label: Text(choice.label, key: ValueKey('export_format_${choice.name}')),
                ),
            ],
            selected: <_ExportChoice>{_choice},
            onSelectionChanged: (selection) => setState(() => _choice = selection.single),
          ),
          const SizedBox(height: 14),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(_choice.icon),
            title: Text(_choice.title),
            subtitle: Text(_choice.description),
          ),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: 10,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                key: const ValueKey('save_selected_export'),
                onPressed: () {
                  Navigator.pop(context);
                  widget.onSave(_choice);
                },
                icon: const Icon(Icons.save_alt_rounded),
                label: const Text('Save to Files'),
              ),
              FilledButton.icon(
                key: const ValueKey('share_selected_export'),
                onPressed: () {
                  Navigator.pop(context);
                  widget.onShare(_choice);
                },
                icon: const Icon(Icons.share_outlined),
                label: const Text('Share'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class RestoreConfirmationDialog extends StatelessWidget {
  const RestoreConfirmationDialog({required this.validated, super.key});

  final ValidatedBackup validated;

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Replace this local journal?'),
    content: Text(
      'Validated backup from '
      '${DateFormat.yMMMd().add_jm().format(validated.manifest.createdAt.toLocal())}.\n\n'
      '${validated.snapshot.animals.length} animals, '
      '${validated.snapshot.respiratorySessions.length} breathing sessions, '
      '${validated.snapshot.medications.length} medications, and '
      '${validated.snapshot.documents.length} documents.\n\n'
      'Creaturely will create a safety snapshot first. Nothing is partially imported.',
    ),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
      FilledButton(
        key: const ValueKey('confirm_restore'),
        onPressed: () => Navigator.pop(context, true),
        child: const Text('Restore'),
      ),
    ],
  );
}

class DeleteJournalScreen extends ConsumerStatefulWidget {
  const DeleteJournalScreen({super.key});

  @override
  ConsumerState<DeleteJournalScreen> createState() => _DeleteJournalScreenState();
}

class _DeleteJournalScreenState extends ConsumerState<DeleteJournalScreen> {
  final TextEditingController _confirmation = TextEditingController();
  bool _working = false;

  @override
  void dispose() {
    _confirmation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Delete local journal')),
    body: ConstrainedPage(
      maxWidth: CreaturelySpacing.maxFormWidth,
      child: ListView(
        children: [
          const PageHeading(
            title: 'This removes the journal from this device',
            subtitle:
                'Animal records, measurements, schedules, dose history, settings, and app-managed '
                'attachments will be deleted. Backups you already saved are not affected.',
          ),
          const SizedBox(height: 18),
          const CalmNotice(
            icon: Icons.warning_amber_rounded,
            text: 'Create a .creaturely backup first if you might want this journal again.',
            tone: NoticeTone.attention,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _confirmation,
            decoration: const InputDecoration(labelText: 'Type DELETE to confirm'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: _confirmation.text == 'DELETE' && !_working ? _delete : null,
            icon: const Icon(Icons.delete_forever_outlined),
            label: const Text('Delete everything local'),
          ),
        ],
      ),
    ),
  );

  Future<void> _delete() async {
    setState(() => _working = true);
    try {
      final storage = await ref.read(documentStorageProvider.future);
      await ref.read(appControllerProvider.notifier).replaceSnapshot(CreaturelySnapshot.empty());
      await storage.deleteJournalArtifacts();
      if (mounted) {
        context.go('/');
      }
    } finally {
      if (mounted) {
        setState(() => _working = false);
      }
    }
  }
}
