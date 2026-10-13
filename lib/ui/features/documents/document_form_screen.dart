import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/document_storage.dart';
import '../../../domain/models.dart';
import '../../../l10n/app_strings.dart';
import '../../../l10n/model_labels.dart';
import '../../../platform/media_service.dart';
import '../../app_controller.dart';
import '../../core/calendar_date_field.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';

class DocumentFormScreen extends ConsumerStatefulWidget {
  const DocumentFormScreen({required this.animalId, this.documentId, super.key});

  final String animalId;
  final String? documentId;

  @override
  ConsumerState<DocumentFormScreen> createState() => _DocumentFormScreenState();
}

class _DocumentFormScreenState extends ConsumerState<DocumentFormScreen> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _notes;
  CareDocument? _existing;
  StoredAttachment? _attachment;
  DocumentCategory _category = DocumentCategory.other;
  DateTime _documentDate = DateTime.now();
  DateTime? _expiryDate;
  bool _saving = false;
  bool _choosingFile = false;
  AttachmentHealth? _health;

  bool _draftLoaded = false;
  void Function(String?)? _releaseImport;

  void _loadDraft() {
    _draftLoaded = true;
    _existing = ref
        .read(journalViewProvider((feature: JournalFeature.document, animalId: widget.animalId)))
        .documents
        .where((value) => value.id == widget.documentId)
        .firstOrNull;
    final existing = _existing;
    _title = TextEditingController(text: existing?.title);
    _notes = TextEditingController(text: existing?.notes);
    _category = existing?.category ?? DocumentCategory.other;
    _documentDate = existing?.documentDate ?? DateTime.now();
    _expiryDate = existing?.expiryDate;
    if (existing != null) {
      _inspect(existing);
    }
  }

  @override
  void dispose() {
    if (_draftLoaded) {
      _title.dispose();
      _notes.dispose();
    }
    _releaseImport?.call(_attachment?.path);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storage = ref.watch(documentStorageProvider).value;
    final cleanup = ref.read(attachmentCleanupProvider.notifier);
    if (storage != null) {
      _releaseImport = (filePath) {
        if (filePath != null) storage.release(filePath);
        unawaited(cleanup.collect());
      };
    }

    final draft = ref.watch(
      journalViewProvider((feature: JournalFeature.document, animalId: widget.animalId)),
    );
    if (draft.loading || draft.error != null) {
      return QueryPane(error: draft.error, onRetry: () => draft.retry(ref));
    }
    if (!_draftLoaded) _loadDraft();
    final animal = draft.animals.where((value) => value.id == widget.animalId).firstOrNull;
    if (animal == null) {
      return Scaffold(body: Center(child: Text(AppLocalizations.of(context).animalNotFound)));
    }
    final recovered = ref.watch(recoveredMediaProvider).value ?? [];
    final fileReady = _attachment != null || _existing != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _existing == null
              ? AppLocalizations.of(context).addDocument
              : AppLocalizations.of(context).editDocument,
        ),
      ),
      body: AbsorbPointer(
        absorbing: _saving,
        child: Form(
          key: _form,
          child: ListView(
            padding: const EdgeInsets.all(CreaturelySpacing.medium),
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: CreaturelySpacing.maxFormWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PageHeading(
                        title: AppLocalizations.of(context).documentFor(animal.name),
                        subtitle: AppLocalizations.of(context)
                            .imagesAndPDFsAreCopiedIntoCreaturelyManagedStorage,
                      ),
                      const SizedBox(height: 22),
                      for (final image in recovered)
                        OutlinedButton.icon(
                          icon: const Icon(Icons.restore),
                          label: Text(AppLocalizations.of(context).useRecoveredImage),
                          onPressed: _saving || _choosingFile ? null : () => _useRecovered(image),
                        ),
                      if (_health == AttachmentHealth.missing)
                        CalmNotice(
                          icon: Icons.file_present_outlined,
                          text: AppLocalizations.of(context)
                              .theOriginalStoredFileIsMissingSelectAReplacement,
                          tone: NoticeTone.attention,
                        )
                      else if (_health == AttachmentHealth.corrupt)
                        CalmNotice(
                          icon: Icons.warning_amber_rounded,
                          text: AppLocalizations.of(context)
                              .thisStoredFileNoLongerMatchesItsChecksumSelect,
                          tone: NoticeTone.attention,
                        ),
                      if (_health != null && _health != AttachmentHealth.available)
                        const SizedBox(height: 14),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            children: [
                              Icon(
                                fileReady ? Icons.description_rounded : Icons.upload_file_rounded,
                                size: 48,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _attachment != null
                                    ? AppLocalizations.of(context)
                                          .bytes2(_attachment!.mediaType, _attachment!.byteLength)
                                    : _existing != null
                                    ? AppLocalizations.of(context)
                                          .bytes2(_existing!.mediaType, _existing!.byteLength)
                                    : AppLocalizations.of(context).chooseAnImageOrPDF,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 14),
                              Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  OutlinedButton.icon(
                                    key: const ValueKey('pick_document'),
                                    onPressed: _saving || _choosingFile ? null : _pickFile,
                                    icon: const Icon(Icons.folder_open_rounded),
                                    label: Text(AppLocalizations.of(context).browseFiles),
                                  ),
                                  OutlinedButton.icon(
                                    onPressed: _saving || _choosingFile
                                        ? null
                                        : () => _pickImage(ImageSource.gallery),
                                    icon: const Icon(Icons.photo_library_outlined),
                                    label: Text(AppLocalizations.of(context).photoLibrary),
                                  ),
                                  OutlinedButton.icon(
                                    onPressed: _saving || _choosingFile
                                        ? null
                                        : () => _pickImage(ImageSource.camera),
                                    icon: const Icon(Icons.camera_alt_outlined),
                                    label: Text(AppLocalizations.of(context).takePhoto),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        key: const ValueKey('document_title'),
                        controller: _title,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(labelText: AppLocalizations.of(context).title),
                        validator: (value) => value == null || value.trim().isEmpty
                            ? AppLocalizations.of(context).enterATitle
                            : null,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<DocumentCategory>(
                        initialValue: _category,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).category,
                        ),
                        items: DocumentCategory.values
                            .map(
                              (value) => DropdownMenuItem(
                                value: value,
                                child: Text(AppLocalizations.of(context).documentCategory(value)),
                              ),
                            )
                            .toList(growable: false),
                        onChanged: (value) => setState(() => _category = value ?? _category),
                      ),
                      const SizedBox(height: 12),
                      CalendarDateField(
                        label: AppLocalizations.of(context).documentDate,
                        value: _documentDate,
                        onTap: () => _pickDate(_DateTarget.document),
                      ),
                      const SizedBox(height: 12),
                      CalendarDateField(
                        label: AppLocalizations.of(context).expiryDateOptional,
                        value: _expiryDate,
                        emptyLabel: AppLocalizations.of(context).noExpiryDate,
                        onTap: () => _pickDate(_DateTarget.expiry),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _notes,
                        minLines: 3,
                        maxLines: 6,
                        decoration: InputDecoration(labelText: AppLocalizations.of(context).notes),
                      ),
                      const SizedBox(height: 22),
                      FilledButton.icon(
                        key: const ValueKey('save_document'),
                        onPressed: !fileReady || _saving || _choosingFile ? null : _save,
                        icon: _saving
                            ? const SizedBox.square(
                                dimension: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.check_rounded),
                        label: Text(AppLocalizations.of(context).saveDocument),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _useRecovered(StoredAttachment image) async {
    if (_saving || _choosingFile) return;
    final recovered = ref.read(recoveredMediaProvider.notifier);
    final documents = ref.read(documentStorageProvider.future);
    final cleanup = ref.read(attachmentCleanupProvider.notifier);
    setState(() => _choosingFile = true);
    try {
      final storage = await documents;
      if (!mounted) return;
      await recovered.consume(image);
      if (!mounted) {
        storage.release(image.path);
        unawaited(cleanup.collect());
        return;
      }
      final previous = _attachment?.path;
      if (previous != null) storage.release(previous);
      setState(() {
        _attachment = image;
        _health = AttachmentHealth.available;
      });
    } on Object {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).fileOperationFailed)));
      }
    } finally {
      if (mounted) setState(() => _choosingFile = false);
    }
  }

  Future<void> _inspect(CareDocument document) async {
    try {
      final storage = await ref.read(documentStorageProvider.future);
      final value = await storage.inspect(document);
      if (mounted) {
        setState(() => _health = value);
      }
    } on Object {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).fileOperationFailed)));
      }
    }
  }

  Future<void> _pickFile() => _pickAttachment(
    () => ref.read(mediaServiceProvider).pickFile([
      'pdf',
      'jpg',
      'jpeg',
      'png',
      'gif',
      'webp',
      'heic',
    ]),
  );
  Future<void> _pickImage(ImageSource source) =>
      _pickAttachment(() => ref.read(mediaServiceProvider).pickImage(source));

  Future<void> _pickAttachment(Future<File?> Function() pick) async {
    if (_saving || _choosingFile) return;
    final documents = ref.read(documentStorageProvider.future);
    final cleanup = ref.read(attachmentCleanupProvider.notifier);
    setState(() => _choosingFile = true);
    try {
      final storage = await documents;
      if (!mounted) return;
      final file = await pick();
      if (file == null || !mounted) return;
      final attachment = await storage.importFile(file);
      if (!mounted) {
        storage.release(attachment.path);
        unawaited(cleanup.collect());
        return;
      }
      if (_attachment != null) storage.release(_attachment!.path);
      setState(() {
        _attachment = attachment;
        _health = AttachmentHealth.available;
        if (_title.text.trim().isEmpty) _title.text = file.uri.pathSegments.last.split('.').first;
      });
    } on Object {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).fileOperationFailed)));
      }
    } finally {
      if (mounted) setState(() => _choosingFile = false);
    }
  }

  Future<void> _pickDate(_DateTarget target) async {
    final initial = switch (target) {
      _DateTarget.document => _documentDate,
      _DateTarget.expiry => _expiryDate ?? DateTime.now(),
    };
    final value = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      initialDate: initial,
    );
    if (value == null || !mounted) {
      return;
    }
    setState(() {
      switch (target) {
        case _DateTarget.document:
          _documentDate = value;
        case _DateTarget.expiry:
          _expiryDate = value;
      }
    });
  }

  Future<void> _save() async {
    if (_saving || _choosingFile) return;
    if (!_form.currentState!.validate()) {
      return;
    }
    setState(() => _saving = true);
    try {
      final now = DateTime.now().toUtc();
      final existing = _existing;
      final attachment = _attachment;
      final document = CareDocument(
        id: existing?.id ?? ref.read(careControllerProvider.notifier).newId(),
        animalId: widget.animalId,
        createdAt: existing?.createdAt ?? now,
        updatedAt: now,
        documentDate: canonicalCalendarDate(_documentDate),
        title: _title.text.trim(),
        category: _category,
        storedPath: attachment?.path ?? existing!.storedPath,
        mediaType: attachment?.mediaType ?? existing!.mediaType,
        checksumSha256: attachment?.checksumSha256 ?? existing!.checksumSha256,
        byteLength: attachment?.byteLength ?? existing!.byteLength,
        notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
        expiryDate: _expiryDate == null ? null : canonicalCalendarDate(_expiryDate!),
      );
      await ref.read(careControllerProvider.notifier).saveDocument(document);
      if (mounted) {
        context.pop();
      }
    } on Object {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).couldNotSaveYourChangesAreKeptHereTry),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }
}

enum _DateTarget { document, expiry }
