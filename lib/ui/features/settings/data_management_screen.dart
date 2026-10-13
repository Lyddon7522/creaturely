import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../data/backup_service.dart';
import '../../../data/export_service.dart';
import '../../../domain/models.dart';
import '../../../l10n/app_strings.dart';
import '../../../l10n/model_labels.dart';
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
  late DateTimeRange _range;
  final Set<String> _selectedDocuments = <String>{};
  bool _working = false;

  @override
  void initState() {
    super.initState();
    _animalId = widget.initialAnimalId;
    final now = ref.read(wallClockProvider)();
    _range = DateTimeRange(start: now.subtract(const Duration(days: 30)), end: now);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(journalViewProvider((feature: JournalFeature.data, animalId: null)));
    if (state.loading || state.error != null) {
      return QueryPane(error: state.error, onRetry: () => state.retry(ref));
    }
    final animals = state.activeAnimals;
    if (_animalId == null || !animals.any((value) => value.id == _animalId)) {
      _animalId = state.selectedAnimal?.id ?? animals.firstOrNull?.id;
    }
    final selectedAnimal = animals.where((value) => value.id == _animalId).firstOrNull;
    final documents = state.documents
        .where(
          (value) =>
              value.animalId == _animalId &&
              calendarDateIsWithin(value.documentDate, _range.start, _range.end),
        )
        .toList(growable: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.petExportOnly
              ? AppLocalizations.of(context).petExport
              : AppLocalizations.of(context).backupRestorePetExport,
        ),
      ),
      body: ConstrainedPage(
        maxWidth: 820,
        child: ListView(
          children: [
            PageHeading(
              title: widget.petExportOnly
                  ? selectedAnimal == null
                        ? AppLocalizations.of(context).petExport
                        : AppLocalizations.of(context).exportSHealthHistory(selectedAnimal.name)
                  : AppLocalizations.of(context).copiesYouControl,
              subtitle: widget.petExportOnly
                  ? AppLocalizations.of(context).chooseADateRangeAndCreateAVetFriendly
                  : AppLocalizations.of(context).createAnOpenBackupSafelyRestoreOneOrSave,
            ),
            if (!widget.petExportOnly) ...[
              const SizedBox(height: 18),
              CalmNotice(
                icon: Icons.lock_outline_rounded,
                text: AppLocalizations.of(context).saveFileAndShareActionsOpenOnlyWhenYou,
                tone: NoticeTone.supportive,
              ),
              const SizedBox(height: 22),
              SectionHeading(AppLocalizations.of(context).wholeJournalBackup),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      minTileHeight: 72,
                      leading: const Icon(Icons.archive_outlined),
                      title: Text(AppLocalizations.of(context).createCreaturelyBackup),
                      subtitle: Text(
                        AppLocalizations.of(context)
                            .animalsDocuments(state.animals.length, state.documents.length),
                      ),
                      trailing: const Icon(Icons.save_alt_rounded),
                      onTap: _working ? null : _createBackup,
                    ),
                    const Divider(height: 1),
                    ListTile(
                      minTileHeight: 72,
                      leading: const Icon(Icons.settings_backup_restore_rounded),
                      title: Text(AppLocalizations.of(context).restoreFromCreaturely),
                      subtitle: Text(
                        AppLocalizations.of(context).fullyValidatedBeforeAnAtomicReplacement,
                      ),
                      trailing: const Icon(Icons.folder_open_rounded),
                      onTap: _working ? null : _restoreBackup,
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 22),
            SectionHeading(
              widget.petExportOnly
                  ? AppLocalizations.of(context).exportOptions
                  : AppLocalizations.of(context).petExport,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: _animalId,
                      decoration: InputDecoration(labelText: AppLocalizations.of(context).animal),
                      items: animals
                          .map(
                            (animal) =>
                                DropdownMenuItem(value: animal.id, child: Text(animal.name)),
                          )
                          .toList(growable: false),
                      onChanged: _working
                          ? null
                          : (value) => setState(() {
                              _animalId = value;
                              _selectedDocuments.clear();
                            }),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: _working ? null : _pickRange,
                      borderRadius: BorderRadius.circular(14),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).dateRange,
                        ),
                        child: Text(
                          '${DateFormat.yMMMd().format(_range.start)} – '
                          '${DateFormat.yMMMd().format(_range.end)}',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context).originalDocumentsToInclude,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    if (documents.isEmpty)
                      Text(AppLocalizations.of(context).noDocumentsInThisRange)
                    else
                      Card(
                        color: Theme.of(context).colorScheme.surfaceContainerLow,
                        child: Column(
                          children: [
                            for (final document in documents)
                              CheckboxListTile(
                                value: _selectedDocuments.contains(document.id),
                                onChanged: _working
                                    ? null
                                    : (selected) => setState(
                                        () => selected == true
                                            ? _selectedDocuments.add(document.id)
                                            : _selectedDocuments.remove(document.id),
                                      ),
                                title: Text(document.title),
                                subtitle: Text(
                                  AppLocalizations.of(context).documentCategory(document.category),
                                ),
                              ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      key: const ValueKey('open_pet_export'),
                      onPressed: _working || _animalId == null ? null : _showExportChooser,
                      icon: const Icon(Icons.ios_share_rounded),
                      label: Text(AppLocalizations.of(context).exportOrShare),
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
    if (_working || !mounted) return;
    final strings = AppLocalizations.of(context);
    final backup = ref.read(recoveryControllerProvider.notifier);
    final saver = ref.read(documentSaveServiceProvider);
    final fileName =
        'creaturely-${DateFormat('yyyyMMdd-HHmm').format(ref.read(wallClockProvider)())}.creaturely';
    setState(() => _working = true);
    try {
      final bytes = await backup.createBackup();
      if (!mounted) return;
      final savedAt = await saver.save(
        fileName: fileName,
        dialogTitle: strings.saveCreaturelyBackup,
        bytes: bytes,
        allowedExtensions: const ['creaturely'],
      );
      if (savedAt != null && mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(strings.creaturelyBackupSaved)));
      }
    } on Object catch (error) {
      _showError(strings.backupCouldNotBeCreated, error);
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  Future<void> _restoreBackup() async {
    if (_working || !mounted) return;
    final strings = AppLocalizations.of(context);
    final media = ref.read(mediaServiceProvider);
    final restore = ref.read(recoveryControllerProvider.notifier);
    setState(() => _working = true);
    try {
      final selected = await media.pickFile(['creaturely']);
      if (selected == null || !mounted) return;
      final validated = await _backups.validateAsync(await selected.readAsBytes());
      if (!mounted) return;
      final confirmed =
          await showDialog<bool>(
            context: context,
            builder: (context) => RestoreConfirmationDialog(validated: validated),
          ) ??
          false;
      if (!confirmed || !mounted) return;
      await restore.restore(validated);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(strings.backupRestoredSuccessfully)));
      }
    } on Object catch (error) {
      _showError(strings.restoreStoppedSafely, error);
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  _ExportRequest _captureExport(_ExportChoice choice) {
    final animalId = _animalId!;
    final animal = ref
        .read(journalViewProvider((feature: JournalFeature.data, animalId: null)))
        .animals
        .singleWhere((animal) => animal.id == animalId);
    return (
      format: choice.format,
      animalId: animalId,
      start: _range.start,
      end: _range.end,
      documents: Set<String>.unmodifiable(_selectedDocuments),
      locale: Localizations.localeOf(context).toLanguageTag(),
      fileName:
          'creaturely-${_safeFileName(animal.name)}-${DateFormat('yyyyMMdd').format(ref.read(wallClockProvider)())}.${choice.extension}',
    );
  }

  Future<void> _saveExport(_ExportChoice choice) async {
    if (_working || !mounted) return;
    final strings = AppLocalizations.of(context);
    final saver = ref.read(documentSaveServiceProvider);
    setState(() => _working = true);
    try {
      final request = _captureExport(choice);
      final bytes = await _buildExport(request);
      if (!mounted) return;
      final savedAt = await saver.save(
        fileName: request.fileName,
        dialogTitle: strings.savePetExport(choice.label),
        bytes: bytes,
        allowedExtensions: [choice.extension],
      );
      if (savedAt != null && mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(strings.exportSaved(choice.label))));
      }
    } on Object catch (error) {
      _showError(strings.exportCouldNotBeSaved(choice.label), error);
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  Future<void> _shareExport(_ExportChoice choice) async {
    if (_working || !mounted) return;
    final strings = AppLocalizations.of(context);
    final media = ref.read(mediaServiceProvider);
    setState(() => _working = true);
    TemporaryExportFile? files;
    try {
      final box = context.findRenderObject();
      final origin = box is RenderBox && box.hasSize
          ? box.localToGlobal(Offset.zero) & box.size
          : null;
      final request = _captureExport(choice);
      final bytes = await _buildExport(request);
      if (!mounted) return;
      files = await TemporaryExportFile.write(
        await media.temporaryDirectory(),
        bytes,
        request.format,
      );
      if (!mounted) return;
      await media.share(
        files.file,
        origin: origin,
        mimeType: switch (request.format) {
          PetExportFormat.pdf => 'application/pdf',
          PetExportFormat.csv => 'text/csv',
          PetExportFormat.zip => 'application/zip',
        },
        title: strings.creaturelyPetHealthSummary,
        subject: strings.creaturelyPetHealthExport,
      );
    } on Object catch (error) {
      _showError(strings.exportCouldNotBeShared, error);
    } finally {
      try {
        await files?.cleanup();
      } on Object {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(strings.temporaryExportCleanupFailed)));
        }
      } finally {
        if (mounted) setState(() => _working = false);
      }
    }
  }

  Future<void> _showExportChooser() => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => _ExportChooserSheet(onSave: _saveExport, onShare: _shareExport),
  );

  Future<Uint8List> _buildExport(_ExportRequest request) async {
    final repository = ref.read(repositoryProvider);
    final storage = await ref.read(documentStorageProvider.future);
    return storage.exclusiveFiles(
      () async => _exports.build(
        format: request.format,
        snapshot: await repository.loadSnapshot(),
        animalId: request.animalId,
        startDate: request.start,
        endDate: request.end,
        selectedDocumentIds: request.documents,
        locale: request.locale,
      ),
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
      lastDate: ref.read(wallClockProvider)(),
      initialDateRange: _range,
    );
    if (value != null && mounted) {
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
    final strings = AppLocalizations.of(context);
    final detail = switch (error) {
      CorruptBackupException() => strings.backupCorruptHelp,
      UnsupportedBackupException() => strings.backupUnsupportedHelp,
      FileSystemException() => strings.fileUnavailableHelp,
      _ => strings.operationFailed,
    };
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$title. $detail')));
  }
}

typedef _ExportRequest = ({
  PetExportFormat format,
  String animalId,
  String fileName,
  DateTime start,
  DateTime end,
  Set<String> documents,
  String locale,
});

enum _ExportChoice {
  pdf(PetExportFormat.pdf, Icons.picture_as_pdf_outlined),
  csv(PetExportFormat.csv, Icons.table_view_outlined),
  zip(PetExportFormat.zip, Icons.folder_zip_outlined);

  const _ExportChoice(this.format, this.icon);
  final PetExportFormat format;
  final IconData icon;
  String get label => name.toUpperCase();
  String get extension => name;
  String get title => switch (this) {
    pdf => appStrings.pdfSummary,
    csv => appStrings.csvData,
    zip => appStrings.zipPackage,
  };
  String get description => switch (this) {
    pdf => appStrings.aReadableOverviewOfTheSelectedDates,
    csv => appStrings.rawJournalDataForASpreadsheet,
    zip => appStrings.pdfCSVAndAnySelectedOriginalDocuments,
  };
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
          Text(
            AppLocalizations.of(context).chooseExportFormat,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            AppLocalizations.of(context).selectOneFormatThenSaveItToFilesOr,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
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
                label: Text(AppLocalizations.of(context).saveToFiles),
              ),
              FilledButton.icon(
                key: const ValueKey('share_selected_export'),
                onPressed: () {
                  Navigator.pop(context);
                  widget.onShare(_choice);
                },
                icon: const Icon(Icons.share_outlined),
                label: Text(AppLocalizations.of(context).share),
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
    title: Text(AppLocalizations.of(context).replaceThisLocalJournal),
    content: Text(
      AppLocalizations.of(context)
          .validatedBackupFromAnimalsBreathingSessionsMedicationsAndDocuments(
            DateFormat.yMMMd().add_jm().format(validated.manifest.createdAt.toLocal()),
            validated.snapshot.animals.length,
            validated.snapshot.respiratorySessions.length,
            validated.snapshot.medications.length,
            validated.snapshot.documents.length,
          ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: Text(AppLocalizations.of(context).cancel),
      ),
      FilledButton(
        key: const ValueKey('confirm_restore'),
        onPressed: () => Navigator.pop(context, true),
        child: Text(AppLocalizations.of(context).restore),
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
    appBar: AppBar(title: Text(AppLocalizations.of(context).deleteLocalJournal)),
    body: ConstrainedPage(
      maxWidth: CreaturelySpacing.maxFormWidth,
      child: ListView(
        children: [
          PageHeading(
            title: AppLocalizations.of(context).thisRemovesTheJournalFromThisDevice,
            subtitle: AppLocalizations.of(context)
                .animalRecordsMeasurementsSchedulesDoseHistorySettingsAndApp,
          ),
          const SizedBox(height: 18),
          CalmNotice(
            icon: Icons.warning_amber_rounded,
            text: AppLocalizations.of(context).createACreaturelyBackupFirstIfYouMightWant,
            tone: NoticeTone.attention,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _confirmation,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).typeDELETEToConfirm,
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: _confirmation.text == AppLocalizations.of(context).delete && !_working
                ? _delete
                : null,
            icon: const Icon(Icons.delete_forever_outlined),
            label: Text(AppLocalizations.of(context).deleteEverythingLocal),
          ),
        ],
      ),
    ),
  );

  Future<void> _delete() async {
    setState(() => _working = true);
    try {
      await ref.read(recoveryControllerProvider.notifier).deleteLocalJournal();
      if (mounted) {
        context.go('/');
      }
    } on Object {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).operationFailed)));
      }
    } finally {
      if (mounted) {
        setState(() => _working = false);
      }
    }
  }
}
