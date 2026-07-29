import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../domain/models.dart';
import '../../../domain/units.dart';
import '../../app_controller.dart';
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
  late final WeightUnit _weightUnit;
  double? _canonicalWeightDraft;
  bool _archived = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final state = ref.read(appControllerProvider);
    _animal = state.snapshot.animals.where((value) => value.id == widget.animalId).firstOrNull;
    final animal = _animal;
    _name = TextEditingController(text: animal?.name);
    final savedSpecies = animal?.species ?? 'Dog';
    _speciesChoice = speciesChoiceFor(savedSpecies);
    _customSpecies = TextEditingController(
      text: _speciesChoice == customSpeciesOption ? savedSpecies : '',
    );
    _breed = TextEditingController(text: animal?.breed);
    _sex = TextEditingController(text: animal?.sexOrStatus);
    _age = TextEditingController(text: animal?.approximateAgeMonths?.toString());
    _color = TextEditingController(text: animal?.colorMarkings);
    final settings = state.snapshot.settings;
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
    _dateOfBirth = animal?.dateOfBirth;
    _photoPath = animal?.photoPath;
    _archived = animal?.archived ?? false;
  }

  @override
  void dispose() {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(appControllerProvider).snapshot.settings;
    final unitLabel = settings.weightUnit == WeightUnit.kilograms ? 'kg' : 'lb';
    final identifiers = ref
        .watch(appControllerProvider)
        .snapshot
        .identifiers
        .where((value) => value.animalId == widget.animalId && !value.archived)
        .toList(growable: false);
    return Scaffold(
      appBar: AppBar(title: Text(_animal == null ? 'Add animal' : 'Edit ${_animal!.name}')),
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
                              tooltip: 'Choose animal photo',
                              onPressed: _pickPhoto,
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
                      decoration: const InputDecoration(labelText: 'Name *'),
                      validator: _required,
                    ),
                    const SizedBox(height: 14),
                    SpeciesSelector(
                      choice: _speciesChoice,
                      customSpecies: _customSpecies,
                      keyPrefix: 'animal',
                      onChoiceChanged: (value) => setState(() => _speciesChoice = value),
                    ),
                    const SizedBox(height: 14),
                    BreedAutocompleteField(
                      controller: _breed,
                      species: _speciesChoice,
                      keyPrefix: 'animal',
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _sex,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(labelText: 'Sex or status (if supplied)'),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: _chooseBirthDate,
                            borderRadius: BorderRadius.circular(14),
                            child: InputDecorator(
                              decoration: const InputDecoration(labelText: 'Date of birth'),
                              child: Text(
                                _dateOfBirth == null
                                    ? 'Not supplied'
                                    : MaterialLocalizations.of(
                                        context,
                                      ).formatMediumDate(_dateOfBirth!),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _age,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Approx. age (months)'),
                            validator: _wholeNumber,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _color,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(labelText: 'Color and markings'),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      key: const ValueKey('animal_weight'),
                      controller: _weight,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(labelText: 'Current weight ($unitLabel)'),
                      validator: _decimal,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _notes,
                      minLines: 3,
                      maxLines: 6,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(labelText: 'Notes'),
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
                        'Identifiers',
                        trailing: TextButton.icon(
                          onPressed: () => _editIdentifier(),
                          icon: const Icon(Icons.add_rounded),
                          label: const Text('Add'),
                        ),
                      ),
                      if (identifiers.isEmpty)
                        const Text('No identifiers saved.')
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
                                    tooltip: 'Identifier actions',
                                    onSelected: (action) => action == 'edit'
                                        ? _editIdentifier(identifiers[index])
                                        : _deleteIdentifier(identifiers[index]),
                                    itemBuilder: (context) => const [
                                      PopupMenuItem(value: 'edit', child: Text('Edit')),
                                      PopupMenuItem(value: 'delete', child: Text('Delete')),
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
                        title: const Text('Archive animal'),
                        subtitle: const Text('Hide from active care without deleting the journal.'),
                      ),
                    ],
                    const SizedBox(height: 28),
                    FilledButton.icon(
                      key: const ValueKey('save_animal'),
                      onPressed: _saving ? null : _save,
                      icon: _saving
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.check_rounded),
                      label: const Text('Save animal'),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickPhoto() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take a photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source == null) {
      return;
    }
    final picked = await ImagePicker().pickImage(source: source, imageQuality: 88);
    if (picked == null) {
      return;
    }
    final storage = await ref.read(documentStorageProvider.future);
    final stored = await storage.importFile(File(picked.path));
    if (mounted) {
      setState(() => _photoPath = stored.path);
    }
  }

  Future<void> _chooseBirthDate() async {
    final value = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialDate: _dateOfBirth ?? DateTime.now(),
    );
    if (value != null) {
      setState(() => _dateOfBirth = value);
    }
  }

  Future<void> _editIdentifier([AnimalIdentifier? existing]) async {
    final animal = _animal;
    if (animal == null) {
      return;
    }
    final result = await showDialog<_IdentifierDraft>(
      context: context,
      builder: (context) => _IdentifierDialog(existing: existing),
    );
    if (result == null) {
      return;
    }
    final now = DateTime.now().toUtc();
    await ref
        .read(appControllerProvider.notifier)
        .saveIdentifier(
          AnimalIdentifier(
            id: existing?.id ?? ref.read(appControllerProvider.notifier).newId(),
            animalId: animal.id,
            createdAt: existing?.createdAt ?? now,
            updatedAt: now,
            type: result.type,
            value: result.value,
            issuer: result.issuer,
            url: result.url,
            phone: result.phone,
            issuedOn: result.issuedOn,
            notes: result.notes,
          ),
        );
  }

  Future<void> _deleteIdentifier(AnimalIdentifier identifier) async {
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Delete ${identifier.type.toLowerCase()} identifier?'),
            content: Text('${identifier.value} will be removed from this local journal.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
    if (confirmed) {
      await ref.read(appControllerProvider.notifier).deleteRecord('identifiers', identifier.id);
    }
  }

  Future<void> _save() async {
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
        const SnackBar(content: Text('Review the breathing-range values and try again.')),
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
        id: existing?.id ?? ref.read(appControllerProvider.notifier).newId(),
        createdAt: existing?.createdAt ?? now,
        updatedAt: now,
        name: _name.text.trim(),
        photoPath: _photoPath,
        species: resolvedSpecies(_speciesChoice, _customSpecies),
        breed: _nullable(_breed.text),
        sexOrStatus: _nullable(_sex.text),
        dateOfBirth: _dateOfBirth,
        approximateAgeMonths: int.tryParse(_age.text),
        colorMarkings: _nullable(_color.text),
        currentWeightKg: kilograms,
        notes: _nullable(_notes.text),
        archived: _archived,
        thresholds: thresholds,
      );
      await ref.read(appControllerProvider.notifier).saveAnimal(animal);
      if (mounted) {
        context.pop();
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'This field is required.' : null;

  String? _wholeNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final parsed = int.tryParse(value);
    return parsed == null || parsed < 0 ? 'Use a whole number.' : null;
  }

  String? _decimal(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final parsed = double.tryParse(value);
    return parsed == null || !parsed.isFinite || parsed < 0 ? 'Use a positive number.' : null;
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
  const _IdentifierDialog({this.existing});

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
  String _type = 'Microchip';
  DateTime? _issuedOn;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    if (existing == null) {
      return;
    }
    const presets = <String>{'Microchip', 'Tag', 'Band', 'Tattoo', 'Registry'};
    _type = presets.contains(existing.type) ? existing.type : 'Other';
    if (_type == 'Other') {
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
    title: Text(widget.existing == null ? 'Add identifier' : 'Edit identifier'),
    content: Form(
      key: _form,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              key: const ValueKey('identifier_type'),
              initialValue: _type,
              decoration: const InputDecoration(labelText: 'Type'),
              items: const <String>[
                'Microchip',
                'Tag',
                'Band',
                'Tattoo',
                'Registry',
                'Other',
              ].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
              onChanged: (value) => setState(() => _type = value ?? _type),
            ),
            if (_type == 'Other') ...[
              const SizedBox(height: 12),
              TextFormField(
                key: const ValueKey('identifier_custom_type'),
                controller: _customType,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Custom type *'),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Enter an identifier type.' : null,
              ),
            ],
            const SizedBox(height: 12),
            TextFormField(
              controller: _value,
              decoration: const InputDecoration(labelText: 'Identifier *'),
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Enter the identifier.' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _issuer,
              decoration: const InputDecoration(labelText: 'Issuer or service'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const ValueKey('identifier_url'),
              controller: _url,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(labelText: 'Service URL'),
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isEmpty) {
                  return null;
                }
                final parsed = Uri.tryParse(text);
                return parsed == null || !parsed.hasScheme || parsed.host.isEmpty
                    ? 'Enter a complete URL, including https://.'
                    : null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const ValueKey('identifier_phone'),
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Service phone'),
            ),
            const SizedBox(height: 12),
            ListTile(
              key: const ValueKey('identifier_issued_on'),
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event_outlined),
              title: const Text('Implanted or issued date'),
              subtitle: Text(
                _issuedOn == null ? 'Not supplied' : DateFormat.yMMMd().format(_issuedOn!),
              ),
              trailing: _issuedOn == null
                  ? const Icon(Icons.chevron_right_rounded)
                  : IconButton(
                      tooltip: 'Clear date',
                      onPressed: () => setState(() => _issuedOn = null),
                      icon: const Icon(Icons.close_rounded),
                    ),
              onTap: _pickIssuedDate,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notes,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
      FilledButton(
        onPressed: () {
          if (_form.currentState!.validate()) {
            Navigator.pop(context, (
              type: _type == 'Other' ? _customType.text.trim() : _type,
              value: _value.text.trim(),
              issuer: _issuer.text.trim().isEmpty ? null : _issuer.text.trim(),
              url: _url.text.trim().isEmpty ? null : _url.text.trim(),
              phone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
              issuedOn: _issuedOn,
              notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
            ));
          }
        },
        child: Text(widget.existing == null ? 'Add' : 'Save'),
      ),
    ],
  );

  Future<void> _pickIssuedDate() async {
    final value = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialDate: _issuedOn ?? DateTime.now(),
    );
    if (value != null) {
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
