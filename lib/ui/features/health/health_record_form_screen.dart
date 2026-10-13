import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/models.dart';
import '../../../domain/units.dart';
import '../../../l10n/app_strings.dart';
import '../../app_controller.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';

class HealthRecordFormScreen extends ConsumerStatefulWidget {
  const HealthRecordFormScreen({
    required this.animalId,
    this.recordId,
    this.initialKind,
    super.key,
  });

  final String animalId;
  final String? recordId;
  final HealthRecordKind? initialKind;

  @override
  ConsumerState<HealthRecordFormScreen> createState() => _HealthRecordFormScreenState();
}

class _HealthRecordFormScreenState extends ConsumerState<HealthRecordFormScreen> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _value;
  late final TextEditingController _notes;
  HealthRecord? _existing;
  HealthRecordKind _kind = HealthRecordKind.weight;
  late WeightUnit _weightUnit;
  double? _canonicalWeightDraft;
  bool _updatingWeightText = false;
  DateTime _date = DateTime.now();
  bool _saving = false;

  bool _draftLoaded = false;

  void _loadDraft() {
    _draftLoaded = true;
    final state = ref.read(
      journalViewProvider((feature: JournalFeature.health, animalId: widget.animalId)),
    );
    _existing = state.healthRecords.where((value) => value.id == widget.recordId).firstOrNull;
    final existing = _existing;
    _kind = existing?.kind ?? widget.initialKind ?? HealthRecordKind.weight;
    _weightUnit = existing?.enteredUnit == 'lb' ? WeightUnit.pounds : state.settings.weightUnit;
    _canonicalWeightDraft = existing?.canonicalValue;
    _title = TextEditingController(
      text:
          existing?.title ??
          (_kind == HealthRecordKind.weight ? AppLocalizations.of(context).weighIn : ''),
    );
    _value = TextEditingController(
      text: existing?.canonicalValue == null
          ? ''
          : WeightValue.from(
              existing!.canonicalValue!,
              WeightUnit.kilograms,
            ).inUnit(_weightUnit).toStringAsFixed(2),
    );
    _value.addListener(_updateCanonicalWeightDraft);
    _notes = TextEditingController(text: existing?.note);
    _date = existing?.occurredAt.toLocal() ?? DateTime.now();
  }

  @override
  void dispose() {
    if (_draftLoaded) {
      _title.dispose();
      _value.dispose();
      _notes.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(
      journalViewProvider((feature: JournalFeature.health, animalId: widget.animalId)),
    );
    if (draft.loading || draft.error != null) {
      return QueryPane(error: draft.error, onRetry: () => draft.retry(ref));
    }
    if (!_draftLoaded) _loadDraft();
    final animal = ref
        .watch(journalViewProvider((feature: JournalFeature.health, animalId: widget.animalId)))
        .animals
        .where((value) => value.id == widget.animalId)
        .firstOrNull;
    if (animal == null) {
      return Scaffold(body: Center(child: Text(AppLocalizations.of(context).animalNotFound)));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _existing == null
              ? AppLocalizations.of(context).addHealthRecord
              : AppLocalizations.of(context).editHealthRecord,
        ),
      ),
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
                      title: AppLocalizations.of(context).aNoteAbout(animal.name),
                      subtitle: AppLocalizations.of(context)
                          .recordWhatYouObservedWithoutTurningTheAnimalInto,
                    ),
                    const SizedBox(height: 22),
                    DropdownButtonFormField<HealthRecordKind>(
                      key: const ValueKey('health_record_kind'),
                      initialValue: _kind,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).recordType,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: HealthRecordKind.weight,
                          child: Text(AppLocalizations.of(context).weighIn),
                        ),
                        DropdownMenuItem(
                          value: HealthRecordKind.allergy,
                          child: Text(AppLocalizations.of(context).allergyOrSensitivity),
                        ),
                        DropdownMenuItem(
                          value: HealthRecordKind.condition,
                          child: Text(AppLocalizations.of(context).conditionOrBodyIssue),
                        ),
                        DropdownMenuItem(
                          value: HealthRecordKind.observation,
                          child: Text(AppLocalizations.of(context).customObservation),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null && mounted) {
                          setState(() {
                            _kind = value;
                            if (_title.text.trim().isEmpty ||
                                _title.text == AppLocalizations.of(context).weighIn) {
                              _title.text = value == HealthRecordKind.weight
                                  ? AppLocalizations.of(context).weighIn
                                  : '';
                            }
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      key: const ValueKey('health_record_title'),
                      controller: _title,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: _kind == HealthRecordKind.weight
                            ? AppLocalizations.of(context).label
                            : AppLocalizations.of(context).nameOrObservation,
                      ),
                      validator: (value) => value == null || value.trim().isEmpty
                          ? AppLocalizations.of(context).enterAShortLabel
                          : null,
                    ),
                    if (_kind == HealthRecordKind.weight) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              key: const ValueKey('health_weight_value'),
                              controller: _value,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context).weight2,
                              ),
                              validator: (value) {
                                final parsed = double.tryParse(value ?? '');
                                return parsed == null || parsed <= 0
                                    ? AppLocalizations.of(context).enterAPositiveWeight
                                    : null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 130,
                            child: DropdownButtonFormField<WeightUnit>(
                              initialValue: _weightUnit,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context).unit,
                              ),
                              items: const [
                                DropdownMenuItem(value: WeightUnit.kilograms, child: Text('kg')),
                                DropdownMenuItem(value: WeightUnit.pounds, child: Text('lb')),
                              ],
                              onChanged: (value) {
                                if (value != null && value != _weightUnit) {
                                  final canonical = _canonicalWeightDraft;
                                  setState(() {
                                    _weightUnit = value;
                                    if (canonical != null) {
                                      _updatingWeightText = true;
                                      _value.text = WeightValue.from(
                                        canonical,
                                        WeightUnit.kilograms,
                                      ).inUnit(value).toStringAsFixed(2);
                                      _updatingWeightText = false;
                                      _canonicalWeightDraft = canonical;
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: _pickDate,
                      borderRadius: BorderRadius.circular(14),
                      child: InputDecorator(
                        decoration: InputDecoration(labelText: AppLocalizations.of(context).date),
                        child: Text(MaterialLocalizations.of(context).formatMediumDate(_date)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _notes,
                      minLines: 3,
                      maxLines: 7,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(labelText: AppLocalizations.of(context).notes),
                    ),
                    const SizedBox(height: 22),
                    FilledButton.icon(
                      key: const ValueKey('save_health_record'),
                      onPressed: _saving ? null : _save,
                      icon: _saving
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.check_rounded),
                      label: Text(AppLocalizations.of(context).saveRecord),
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

  Future<void> _pickDate() async {
    final value = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      initialDate: _date,
    );
    if (value != null && mounted) {
      setState(() => _date = value);
    }
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) {
      return;
    }
    setState(() => _saving = true);
    try {
      final now = DateTime.now().toUtc();
      final entered = _kind == HealthRecordKind.weight ? double.parse(_value.text) : null;
      final canonical = entered == null
          ? null
          : _canonicalWeightDraft ?? WeightValue.from(entered, _weightUnit).kilograms;
      final record = HealthRecord(
        id: _existing?.id ?? ref.read(careControllerProvider.notifier).newId(),
        animalId: widget.animalId,
        createdAt: _existing?.createdAt ?? now,
        updatedAt: now,
        occurredAt: _date.toUtc(),
        kind: _kind,
        title: _title.text.trim(),
        canonicalValue: canonical,
        canonicalUnit: canonical == null ? null : 'kg',
        enteredUnit: canonical == null
            ? null
            : _weightUnit == WeightUnit.kilograms
            ? 'kg'
            : 'lb',
        note: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
      );
      await ref.read(careControllerProvider.notifier).saveHealthRecord(record);
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

  void _updateCanonicalWeightDraft() {
    if (_updatingWeightText) {
      return;
    }
    final entered = double.tryParse(_value.text);
    _canonicalWeightDraft = entered == null
        ? null
        : WeightValue.from(entered, _weightUnit).kilograms;
  }
}
