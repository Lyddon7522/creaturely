import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/document_storage.dart';
import '../../../domain/models.dart';
import '../../app_controller.dart';
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
  AttachmentHealth? _health;

  @override
  void initState() {
    super.initState();
    _existing = ref
        .read(appControllerProvider)
        .snapshot
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
    _title.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animal = ref
        .watch(appControllerProvider)
        .snapshot
        .animals
        .where((value) => value.id == widget.animalId)
        .firstOrNull;
    if (animal == null) {
      return const Scaffold(body: Center(child: Text('Animal not found.')));
    }
    final fileReady = _attachment != null || _existing != null;
    return Scaffold(
      appBar: AppBar(title: Text(_existing == null ? 'Add document' : 'Edit document')),
      body: Form(
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
                      title: 'Document for ${animal.name}',
                      subtitle: 'Images and PDFs are copied into Creaturely-managed storage.',
                    ),
                    const SizedBox(height: 22),
                    if (_health == AttachmentHealth.missing)
                      const CalmNotice(
                        icon: Icons.file_present_outlined,
                        text:
                            'The original stored file is missing. Select a replacement before '
                            'saving, or keep the visible record in the timeline.',
                        tone: NoticeTone.attention,
                      )
                    else if (_health == AttachmentHealth.corrupt)
                      const CalmNotice(
                        icon: Icons.warning_amber_rounded,
                        text:
                            'This stored file no longer matches its checksum. Select a clean '
                            'replacement before sharing or backing it up.',
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
                                  ? '${_attachment!.mediaType} • ${_attachment!.byteLength} bytes'
                                  : _existing != null
                                  ? '${_existing!.mediaType} • ${_existing!.byteLength} bytes'
                                  : 'Choose an image or PDF',
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
                                  onPressed: _pickFile,
                                  icon: const Icon(Icons.folder_open_rounded),
                                  label: const Text('Browse Files'),
                                ),
                                OutlinedButton.icon(
                                  onPressed: () => _pickImage(ImageSource.gallery),
                                  icon: const Icon(Icons.photo_library_outlined),
                                  label: const Text('Photo library'),
                                ),
                                OutlinedButton.icon(
                                  onPressed: () => _pickImage(ImageSource.camera),
                                  icon: const Icon(Icons.camera_alt_outlined),
                                  label: const Text('Take photo'),
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
                      decoration: const InputDecoration(labelText: 'Title *'),
                      validator: (value) =>
                          value == null || value.trim().isEmpty ? 'Enter a title.' : null,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<DocumentCategory>(
                      initialValue: _category,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: DocumentCategory.values
                          .map(
                            (value) =>
                                DropdownMenuItem(value: value, child: Text(_friendly(value.name))),
                          )
                          .toList(growable: false),
                      onChanged: (value) => setState(() => _category = value ?? _category),
                    ),
                    const SizedBox(height: 12),
                    _DateField(
                      label: 'Document date',
                      value: _documentDate,
                      onTap: () => _pickDate(_DateTarget.document),
                    ),
                    const SizedBox(height: 12),
                    _DateField(
                      label: 'Expiry date (optional)',
                      value: _expiryDate,
                      emptyLabel: 'No expiry date',
                      onTap: () => _pickDate(_DateTarget.expiry),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _notes,
                      minLines: 3,
                      maxLines: 6,
                      decoration: const InputDecoration(labelText: 'Notes'),
                    ),
                    const SizedBox(height: 22),
                    FilledButton.icon(
                      key: const ValueKey('save_document'),
                      onPressed: !fileReady || _saving ? null : _save,
                      icon: _saving
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.check_rounded),
                      label: const Text('Save document'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _inspect(CareDocument document) async {
    final storage = await ref.read(documentStorageProvider.future);
    final value = await storage.inspect(document);
    if (mounted) {
      setState(() => _health = value);
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: <String>['pdf', 'jpg', 'jpeg', 'png', 'gif', 'webp', 'heic'],
      allowMultiple: false,
      withData: false,
    );
    final selectedPath = result?.files.single.path;
    if (selectedPath == null) {
      return;
    }
    await _import(File(selectedPath));
  }

  Future<void> _pickImage(ImageSource source) async {
    final result = await ImagePicker().pickImage(source: source, imageQuality: 90);
    if (result != null) {
      await _import(File(result.path));
    }
  }

  Future<void> _import(File file) async {
    final storage = await ref.read(documentStorageProvider.future);
    final attachment = await storage.importFile(file);
    if (mounted) {
      setState(() {
        _attachment = attachment;
        _health = AttachmentHealth.available;
        if (_title.text.trim().isEmpty) {
          _title.text = file.uri.pathSegments.last.split('.').first;
        }
      });
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
    if (value == null) {
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
    if (!_form.currentState!.validate()) {
      return;
    }
    setState(() => _saving = true);
    try {
      final now = DateTime.now().toUtc();
      final existing = _existing;
      final attachment = _attachment;
      final document = CareDocument(
        id: existing?.id ?? ref.read(appControllerProvider.notifier).newId(),
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
      await ref.read(appControllerProvider.notifier).saveDocument(document);
      if (mounted) {
        context.pop();
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  String _friendly(String value) =>
      '${value[0].toUpperCase()}${value.substring(1).replaceAllMapped(RegExp('[A-Z]'), (match) => ' ${match.group(0)}')}';
}

enum _DateTarget { document, expiry }

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
    this.emptyLabel = 'Choose date',
  });

  final String label;
  final DateTime? value;
  final VoidCallback onTap;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(14),
    child: InputDecorator(
      decoration: InputDecoration(labelText: label),
      child: Text(
        value == null ? emptyLabel : MaterialLocalizations.of(context).formatMediumDate(value!),
      ),
    ),
  );
}
