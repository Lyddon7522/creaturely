import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/models.dart';
import '../../../domain/units.dart';
import '../../app_controller.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';

class HealthRecordFormScreen extends ConsumerStatefulWidget {
  const HealthRecordFormScreen({required this.animalId, this.recordId, super.key});

  final String animalId;
  final String? recordId;

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

  @override
  void initState() {
    super.initState();
    final state = ref.read(appControllerProvider);
    _existing = state.snapshot.healthRecords
        .where((value) => value.id == widget.recordId)
        .firstOrNull;
    final existing = _existing;
    _kind = existing?.kind ?? HealthRecordKind.weight;
    _weightUnit = existing?.enteredUnit == 'lb'
        ? WeightUnit.pounds
        : state.snapshot.settings.weightUnit;
    _canonicalWeightDraft = existing?.canonicalValue;
    _title = TextEditingController(
      text: existing?.title ?? (_kind == HealthRecordKind.weight ? 'Weigh-in' : ''),
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
    _title.dispose();
    _value.dispose();
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
    return Scaffold(
      appBar: AppBar(title: Text(_existing == null ? 'Add health record' : 'Edit health record')),
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
                      title: 'A note about ${animal.name}',
                      subtitle:
                          'Record what you observed without turning the animal into a condition.',
                    ),
                    const SizedBox(height: 22),
                    DropdownButtonFormField<HealthRecordKind>(
                      key: const ValueKey('health_record_kind'),
                      initialValue: _kind,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'Record type'),
                      items: const [
                        DropdownMenuItem(value: HealthRecordKind.weight, child: Text('Weigh-in')),
                        DropdownMenuItem(
                          value: HealthRecordKind.allergy,
                          child: Text('Allergy or sensitivity'),
                        ),
                        DropdownMenuItem(
                          value: HealthRecordKind.condition,
                          child: Text('Condition or body issue'),
                        ),
                        DropdownMenuItem(
                          value: HealthRecordKind.observation,
                          child: Text('Custom observation'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _kind = value;
                            if (_title.text.trim().isEmpty || _title.text == 'Weigh-in') {
                              _title.text = value == HealthRecordKind.weight ? 'Weigh-in' : '';
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
                            ? 'Label'
                            : 'Name or observation *',
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty ? 'Enter a short label.' : null,
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
                              decoration: const InputDecoration(labelText: 'Weight *'),
                              validator: (value) {
                                final parsed = double.tryParse(value ?? '');
                                return parsed == null || parsed <= 0
                                    ? 'Enter a positive weight.'
                                    : null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 130,
                            child: DropdownButtonFormField<WeightUnit>(
                              initialValue: _weightUnit,
                              decoration: const InputDecoration(labelText: 'Unit'),
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
                        decoration: const InputDecoration(labelText: 'Date'),
                        child: Text(MaterialLocalizations.of(context).formatMediumDate(_date)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _notes,
                      minLines: 3,
                      maxLines: 7,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(labelText: 'Notes'),
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
                      label: const Text('Save record'),
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
    if (value != null) {
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
        id: _existing?.id ?? ref.read(appControllerProvider.notifier).newId(),
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
      await ref.read(appControllerProvider.notifier).saveHealthRecord(record);
      if (mounted) {
        context.pop();
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
