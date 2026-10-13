import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../data/document_storage.dart';
import '../../../domain/models.dart';
import '../../../domain/units.dart';
import '../../../l10n/app_strings.dart';
import '../../../platform/media_service.dart';
import '../../app_controller.dart';
import '../../core/commands.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import 'animal_profile_fields.dart';

class AnimalFormScreen extends ConsumerStatefulWidget {
  const AnimalFormScreen({this.animalId, super.key});

  final String? animalId;

  @override
  ConsumerState<AnimalFormScreen> createState() => _AnimalFormScreenState();
}

class _AnimalFormScreenState extends ConsumerState<AnimalFormScreen> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _customSpecies;
  late final TextEditingController _breed;
  late final TextEditingController _sex;
  late final TextEditingController _age;
  late final TextEditingController _color;
  late final TextEditingController _weight;
  late final TextEditingController _notes;
  late final TextEditingController _thresholdMin;
  late final TextEditingController _thresholdTarget;
  late final TextEditingController _thresholdMax;
  Animal? _animal;
  late String _speciesChoice;
  DateTime? _dateOfBirth;
  String? _photoPath;
  String? _importedPhoto;
  late final WeightUnit _weightUnit;
  double? _canonicalWeightDraft;
  bool _archived = false;
  bool _saving = false;
  bool _choosingFile = false;

  bool _draftLoaded = false;
  void Function(String?)? _releaseImport;

  void _loadDraft() {
    _draftLoaded = true;
    final state = ref.read(
      journalViewProvider((feature: JournalFeature.animalForm, animalId: widget.animalId)),
    );
    _animal = state.animals.where((value) => value.id == widget.animalId).firstOrNull;
    final animal = _animal;
    _name = TextEditingController(text: animal?.name);
    final savedSpecies = animal?.species ?? AppLocalizations.of(context).dog;
    _speciesChoice = speciesChoiceFor(savedSpecies);
    _customSpecies = TextEditingController(
      text: _speciesChoice == customSpeciesOption ? savedSpecies : '',
    );
    _breed = TextEditingController(text: animal?.breed);
    _sex = TextEditingController(text: animal?.sexOrStatus);
    _dateOfBirth = animal?.dateOfBirth;
    final ageMonths = _dateOfBirth == null
        ? animal?.approximateAgeMonths
        : completedAgeMonths(_dateOfBirth!, DateTime.now());
    _age = TextEditingController(text: ageMonths?.toString());
    _color = TextEditingController(text: animal?.colorMarkings);
    final settings = state.settings;
    _weightUnit = settings.weightUnit;
    _canonicalWeightDraft = animal?.currentWeightKg;
    _weight = TextEditingController(
      text: animal?.currentWeightKg == null
          ? ''
          : WeightValue.from(
              animal!.currentWeightKg!,
              WeightUnit.kilograms,
            ).inUnit(settings.weightUnit).toStringAsFixed(2),
    );
    _weight.addListener(_updateCanonicalWeightDraft);
    _notes = TextEditingController(text: animal?.notes);
    _thresholdMin = TextEditingController(text: animal?.thresholds.minimum?.toString());
    _thresholdTarget = TextEditingController(text: animal?.thresholds.target?.toString());
    _thresholdMax = TextEditingController(text: animal?.thresholds.maximum?.toString());
    _photoPath = animal?.photoPath;
    _archived = animal?.archived ?? false;
  }

  @override
  void dispose() {
    if (_draftLoaded) {
      for (final controller in <TextEditingController>[
        _name,
        _customSpecies,
        _breed,
        _sex,
        _age,
        _color,
        _weight,
        _notes,
        _thresholdMin,
        _thresholdTarget,
        _thresholdMax,
      ]) {
        controller.dispose();
      }
    }
    _releaseImport?.call(_importedPhoto);
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

    final recovered = ref.watch(recoveredMediaProvider).value ?? [];
    final draft = ref.watch(
      journalViewProvider((feature: JournalFeature.animalForm, animalId: widget.animalId)),
    );
    if (draft.loading || draft.error != null) {
      return QueryPane(error: draft.error, onRetry: () => draft.retry(ref));
    }
    if (!_draftLoaded) _loadDraft();
    final settings = ref
        .watch(journalViewProvider((feature: JournalFeature.animalForm, animalId: widget.animalId)))
        .settings;
    final unitLabel = settings.weightUnit == WeightUnit.kilograms ? 'kg' : 'lb';
    final identifiers = ref
        .watch(journalViewProvider((feature: JournalFeature.animalForm, animalId: widget.animalId)))
        .identifiers
        .where((value) => value.animalId == widget.animalId && !value.archived)
        .toList(growable: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _animal == null
              ? AppLocalizations.of(context).addAnimal
              : AppLocalizations.of(context).edit2(_animal!.name),
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
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 58,
                              foregroundImage: _photoPath == null
                                  ? null
                                  : FileImage(File(_photoPath!)),
                              child: _photoPath == null
                                  ? const Icon(Icons.pets_rounded, size: 46)
                                  : null,
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: IconButton.filled(
                                tooltip: AppLocalizations.of(context).chooseAnimalPhoto,
                                onPressed: _saving || _choosingFile ? null : _pickPhoto,
                                icon: const Icon(Icons.camera_alt_outlined),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        key: const ValueKey('animal_name'),
                        controller: _name,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(labelText: AppLocalizations.of(context).name),
                        validator: _required,
                      ),
                      for (final image in recovered)
                        OutlinedButton.icon(
                          icon: const Icon(Icons.restore),
                          label: Text(AppLocalizations.of(context).useRecoveredImage),
                          onPressed: _saving || _choosingFile ? null : () => _useRecovered(image),
                        ),
                      const SizedBox(height: 14),
                      SpeciesSelector(
                        choice: _speciesChoice,
                        customSpecies: _customSpecies,
                        keyPrefix: 'animal',
                        onChoiceChanged: _changeSpecies,
                      ),
                      const SizedBox(height: 14),
                      BreedAutocompleteField(
                        controller: _breed,
                        species: _speciesChoice,
                        keyPrefix: 'animal',
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                        key: const ValueKey('animal_sex'),
                        initialValue: _sex.text.trim(),
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).sexOptional,
                        ),
                        items:
                            <String>{
                                  '',
                                  AppLocalizations.of(context).male,
                                  AppLocalizations.of(context).female,
                                  AppLocalizations.of(context).other,
                                  if (_sex.text.trim().isNotEmpty) _sex.text.trim(),
                                }
                                .map(
                                  (value) => DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value.isEmpty
                                          ? AppLocalizations.of(context).notSpecified
                                          : value,
                                    ),
                                  ),
                                )
                                .toList(growable: false),
                        onChanged: (value) => _sex.text = value ?? '',
                      ),
                      const SizedBox(height: 14),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: InkWell(
                              key: const ValueKey('animal_birth_date'),
                              onTap: _chooseBirthDate,
                              borderRadius: BorderRadius.circular(14),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context).dateOfBirth,
                                  suffixIcon: _dateOfBirth == null
                                      ? null
                                      : IconButton(
                                          tooltip: AppLocalizations.of(context).clearDateOfBirth,
                                          onPressed: _clearBirthDate,
                                          icon: const Icon(Icons.close_rounded),
                                        ),
                                ),
                                child: Text(
                                  _dateOfBirth == null
                                      ? AppLocalizations.of(context).notSupplied
                                      : MaterialLocalizations.of(context)
                                            .formatMediumDate(_dateOfBirth!),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              key: const ValueKey('animal_age_months'),
                              controller: _age,
                              readOnly: _dateOfBirth != null,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context).ageMonths,
                                helperText: _dateOfBirth == null
                                    ? AppLocalizations.of(context).optionalEstimate
                                    : AppLocalizations.of(context).calculatedFromBirthDate,
                                helperMaxLines: 2,
                              ),
                              validator: _wholeNumber,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _color,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).colorAndMarkings,
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        key: const ValueKey('animal_weight'),
                        controller: _weight,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).currentWeight2(unitLabel),
                        ),
                        validator: _decimal,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _notes,
                        minLines: 3,
                        maxLines: 6,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(labelText: AppLocalizations.of(context).notes),
                      ),
                      const SizedBox(height: 26),
                      RespiratoryThresholdFields(
                        minimum: _thresholdMin,
                        target: _thresholdTarget,
                        maximum: _thresholdMax,
                        keyPrefix: 'animal',
                      ),
                      if (_animal != null) ...[
                        const SizedBox(height: 26),
                        SectionHeading(
                          AppLocalizations.of(context).identifiers,
                          trailing: TextButton.icon(
                            onPressed: () => _editIdentifier(),
                            icon: const Icon(Icons.add_rounded),
                            label: Text(AppLocalizations.of(context).add),
                          ),
                        ),
                        if (identifiers.isEmpty)
                          Text(AppLocalizations.of(context).noIdentifiersSaved)
                        else
                          Card(
                            child: Column(
                              children: [
                                for (var index = 0; index < identifiers.length; index++) ...[
                                  ListTile(
                                    leading: const Icon(Icons.badge_outlined),
                                    title: Text(identifiers[index].value),
                                    subtitle: Text(
                                      '${identifiers[index].type}'
                                      '${identifiers[index].issuer == null ? '' : ' • ${identifiers[index].issuer}'}'
                                      '${identifiers[index].issuedOn == null ? '' : ' • ${DateFormat.yMMMd().format(identifiers[index].issuedOn!)}'}',
                                    ),
                                    trailing: PopupMenuButton<String>(
                                      tooltip: AppLocalizations.of(context).identifierActions,
                                      onSelected: (action) => action == 'edit'
                                          ? _editIdentifier(identifiers[index])
                                          : _deleteIdentifier(identifiers[index]),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          value: 'edit',
                                          child: Text(AppLocalizations.of(context).edit),
                                        ),
                                        PopupMenuItem(
                                          value: 'delete',
                                          child: Text(AppLocalizations.of(context).delete2),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (index < identifiers.length - 1) const Divider(height: 1),
                                ],
                              ],
                            ),
                          ),
                        const SizedBox(height: 20),
                        SwitchListTile(
                          value: _archived,
                          onChanged: (value) => setState(() => _archived = value),
                          contentPadding: EdgeInsets.zero,
                          title: Text(AppLocalizations.of(context).archiveAnimal),
                          subtitle: Text(
                            AppLocalizations.of(context)
                                .hideFromActiveCareWithoutDeletingTheJournal,
                          ),
                        ),
                      ],
                      const SizedBox(height: 28),
                      FilledButton.icon(
                        key: const ValueKey('save_animal'),
                        onPressed: _saving || _choosingFile ? null : _save,
                        icon: _saving
                            ? const SizedBox.square(
                                dimension: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.check_rounded),
                        label: Text(AppLocalizations.of(context).saveAnimal),
                      ),
                      const SizedBox(height: 32),
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
      final previous = _importedPhoto;
      if (previous != null) storage.release(previous);
      setState(() {
        _photoPath = image.path;
        _importedPhoto = image.path;
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

  Future<void> _pickPhoto() async {
    if (_saving || _choosingFile) return;
    setState(() => _choosingFile = true);
    try {
      final source = await showModalBottomSheet<ImageSource>(
        context: context,
        showDragHandle: true,
        builder: (context) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text(AppLocalizations.of(context).chooseFromGallery),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: Text(AppLocalizations.of(context).takeAPhoto),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
            ],
          ),
        ),
      );
      if (source == null || !mounted) {
        return;
      }
      final picked = await ref.read(mediaServiceProvider).pickImage(source);
      if (picked == null || !mounted) {
        return;
      }
      final storage = await ref.read(documentStorageProvider.future);
      if (!mounted) return;
      final stored = await storage.importFile(picked);
      if (!mounted) {
        storage.release(stored.path);
        _releaseImport?.call(null);
        return;
      }
      if (_importedPhoto != null) storage.release(_importedPhoto!);
      _importedPhoto = stored.path;
      if (mounted) {
        setState(() => _photoPath = stored.path);
      }
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

  Future<void> _chooseBirthDate() async {
    final value = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialDate: _dateOfBirth ?? DateTime.now(),
    );
    if (value != null && mounted) {
      setState(() {
        _dateOfBirth = value;
        _age.text = completedAgeMonths(value, DateTime.now()).toString();
      });
    }
  }

  void _clearBirthDate() {
    setState(() {
      _dateOfBirth = null;
      _age.clear();
    });
  }

  void _changeSpecies(String value) {
    if (value == _speciesChoice) {
      return;
    }
    FocusScope.of(context).unfocus();
    _breed.clear();
    setState(() => _speciesChoice = value);
  }

  Future<void> _editIdentifier([AnimalIdentifier? existing]) async {
    final animal = _animal;
    if (animal == null) return;
    final controller = ref.read(animalControllerProvider.notifier);
    final clock = ref.read(wallClockProvider);
    final id = existing?.id ?? controller.newId();
    final created = existing?.createdAt ?? clock().toUtc();
    await showDialog<void>(
      context: context,
      builder: (context) => _IdentifierDialog(
        existing: existing,
        onSave: (draft) => controller.saveIdentifier(
          AnimalIdentifier(
            id: id,
            animalId: animal.id,
            createdAt: created,
            updatedAt: clock().toUtc(),
            type: draft.type,
            value: draft.value,
            issuer: draft.issuer,
            url: draft.url,
            phone: draft.phone,
            issuedOn: draft.issuedOn,
            notes: draft.notes,
          ),
        ),
      ),
    );
  }

  Future<void> _deleteIdentifier(AnimalIdentifier identifier) async {
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              AppLocalizations.of(context).deleteIdentifier(identifier.type.toLowerCase()),
            ),
            content: Text(
              AppLocalizations.of(context).willBeRemovedFromThisLocalJournal(identifier.value),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(AppLocalizations.of(context).cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(AppLocalizations.of(context).delete2),
              ),
            ],
          ),
        ) ??
        false;
    if (confirmed && mounted) {
      await runUiCommand(
        context,
        () => ref.read(animalControllerProvider.notifier).deleteIdentifier(identifier.id),
      );
    }
  }

  Future<void> _save() async {
    if (_saving || _choosingFile) return;
    if (!_form.currentState!.validate()) {
      return;
    }
    final thresholds = thresholdsFromControllers(
      minimum: _thresholdMin,
      target: _thresholdTarget,
      maximum: _thresholdMax,
    );
    if (!thresholds.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).reviewTheRespiratoryRateValuesAndTryAgain),
        ),
      );
      return;
    }
    final enteredWeight = double.tryParse(_weight.text);
    final kilograms = enteredWeight == null
        ? null
        : _canonicalWeightDraft ?? WeightValue.from(enteredWeight, _weightUnit).kilograms;
    setState(() => _saving = true);
    try {
      final now = DateTime.now().toUtc();
      final existing = _animal;
      final animal = Animal(
        id: existing?.id ?? ref.read(animalControllerProvider.notifier).newId(),
        createdAt: existing?.createdAt ?? now,
        updatedAt: now,
        name: _name.text.trim(),
        photoPath: _photoPath,
        species: resolvedSpecies(_speciesChoice, _customSpecies),
        breed: _nullable(_breed.text),
        sexOrStatus: _nullable(_sex.text),
        dateOfBirth: _dateOfBirth,
        approximateAgeMonths: _dateOfBirth == null
            ? int.tryParse(_age.text)
            : completedAgeMonths(_dateOfBirth!, DateTime.now()),
        colorMarkings: _nullable(_color.text),
        currentWeightKg: kilograms,
        notes: _nullable(_notes.text),
        archived: _archived,
        thresholds: thresholds,
      );
      await ref.read(animalControllerProvider.notifier).saveAnimal(animal);
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

  String? _required(String? value) => value == null || value.trim().isEmpty
      ? AppLocalizations.of(context).thisFieldIsRequired
      : null;

  String? _wholeNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final parsed = int.tryParse(value);
    return parsed == null || parsed < 0 ? AppLocalizations.of(context).useAWholeNumber : null;
  }

  String? _decimal(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final parsed = double.tryParse(value);
    return parsed == null || !parsed.isFinite || parsed < 0
        ? AppLocalizations.of(context).useAPositiveNumber
        : null;
  }

  void _updateCanonicalWeightDraft() {
    final entered = double.tryParse(_weight.text);
    _canonicalWeightDraft = entered == null
        ? null
        : WeightValue.from(entered, _weightUnit).kilograms;
  }

  String? _nullable(String value) => value.trim().isEmpty ? null : value.trim();
}

class _IdentifierDialog extends StatefulWidget {
  const _IdentifierDialog({required this.onSave, this.existing});
  final Future<void> Function(_IdentifierDraft) onSave;

  final AnimalIdentifier? existing;

  @override
  State<_IdentifierDialog> createState() => _IdentifierDialogState();
}

class _IdentifierDialogState extends State<_IdentifierDialog> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _value = TextEditingController();
  final TextEditingController _issuer = TextEditingController();
  final TextEditingController _customType = TextEditingController();
  final TextEditingController _url = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _notes = TextEditingController();
  bool _saving = false;
  bool _failed = false;
  String _type = appStrings.microchip;
  DateTime? _issuedOn;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    if (existing == null) {
      return;
    }
    final presets = <String>{
      appStrings.microchip,
      appStrings.tag,
      appStrings.band,
      appStrings.tattoo,
      appStrings.registry,
    };
    _type = presets.contains(existing.type) ? existing.type : appStrings.other;
    if (_type == appStrings.other) {
      _customType.text = existing.type;
    }
    _value.text = existing.value;
    _issuer.text = existing.issuer ?? '';
    _url.text = existing.url ?? '';
    _phone.text = existing.phone ?? '';
    _notes.text = existing.notes ?? '';
    _issuedOn = existing.issuedOn;
  }

  @override
  void dispose() {
    _value.dispose();
    _issuer.dispose();
    _customType.dispose();
    _url.dispose();
    _phone.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(
      widget.existing == null
          ? AppLocalizations.of(context).addIdentifier
          : AppLocalizations.of(context).editIdentifier,
    ),
    content: Form(
      key: _form,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              key: const ValueKey('identifier_type'),
              initialValue: _type,
              decoration: InputDecoration(labelText: AppLocalizations.of(context).type),
              items: <String>[
                AppLocalizations.of(context).microchip,
                AppLocalizations.of(context).tag,
                AppLocalizations.of(context).band,
                AppLocalizations.of(context).tattoo,
                AppLocalizations.of(context).registry,
                AppLocalizations.of(context).other,
              ].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
              onChanged: (value) => setState(() => _type = value ?? _type),
            ),
            if (_type == AppLocalizations.of(context).other) ...[
              const SizedBox(height: 12),
              TextFormField(
                key: const ValueKey('identifier_custom_type'),
                controller: _customType,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(labelText: AppLocalizations.of(context).customType),
                validator: (value) => value == null || value.trim().isEmpty
                    ? AppLocalizations.of(context).enterAnIdentifierType
                    : null,
              ),
            ],
            const SizedBox(height: 12),
            TextFormField(
              controller: _value,
              decoration: InputDecoration(labelText: AppLocalizations.of(context).identifier),
              validator: (value) => value == null || value.trim().isEmpty
                  ? AppLocalizations.of(context).enterTheIdentifier
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _issuer,
              decoration: InputDecoration(labelText: AppLocalizations.of(context).issuerOrService),
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const ValueKey('identifier_url'),
              controller: _url,
              keyboardType: TextInputType.url,
              decoration: InputDecoration(labelText: AppLocalizations.of(context).serviceURL),
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isEmpty) {
                  return null;
                }
                final parsed = Uri.tryParse(text);
                return parsed == null || !parsed.hasScheme || parsed.host.isEmpty
                    ? AppLocalizations.of(context).enterCompleteServiceUrl
                    : null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const ValueKey('identifier_phone'),
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: AppLocalizations.of(context).servicePhone),
            ),
            const SizedBox(height: 12),
            ListTile(
              key: const ValueKey('identifier_issued_on'),
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event_outlined),
              title: Text(AppLocalizations.of(context).implantedOrIssuedDate),
              subtitle: Text(
                _issuedOn == null
                    ? AppLocalizations.of(context).notSupplied
                    : DateFormat.yMMMd().format(_issuedOn!),
              ),
              trailing: _issuedOn == null
                  ? const Icon(Icons.chevron_right_rounded)
                  : IconButton(
                      tooltip: AppLocalizations.of(context).clearDate,
                      onPressed: () => setState(() => _issuedOn = null),
                      icon: const Icon(Icons.close_rounded),
                    ),
              onTap: _pickIssuedDate,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notes,
              decoration: InputDecoration(labelText: AppLocalizations.of(context).notes),
            ),
          ],
        ),
      ),
    ),
    actions: [
      if (_failed)
        Semantics(
          liveRegion: true,
          child: Text(AppLocalizations.of(context).couldNotSaveYourChangesAreKeptHereTry),
        ),
      TextButton(
        onPressed: _saving ? null : () => Navigator.pop(context),
        child: Text(AppLocalizations.of(context).cancel),
      ),
      FilledButton(
        onPressed: _saving ? null : _save,

        child: Text(
          widget.existing == null
              ? AppLocalizations.of(context).add
              : AppLocalizations.of(context).save,
        ),
      ),
    ],
  );

  Future<void> _save() async {
    if (_saving || !_form.currentState!.validate()) return;
    final draft = (
      type: _type == AppLocalizations.of(context).other ? _customType.text.trim() : _type,
      value: _value.text.trim(),
      issuer: _issuer.text.trim().isEmpty ? null : _issuer.text.trim(),
      url: _url.text.trim().isEmpty ? null : _url.text.trim(),
      phone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
      issuedOn: _issuedOn,
      notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
    );
    setState(() {
      _saving = true;
      _failed = false;
    });
    try {
      await widget.onSave(draft);
      if (mounted) Navigator.pop(context);
    } on Object {
      if (mounted) setState(() => _failed = true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _pickIssuedDate() async {
    final value = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialDate: _issuedOn ?? DateTime.now(),
    );
    if (value != null && mounted) {
      setState(() => _issuedOn = value);
    }
  }
}

typedef _IdentifierDraft = ({
  String type,
  String value,
  String? issuer,
  String? url,
  String? phone,
  DateTime? issuedOn,
  String? notes,
});
