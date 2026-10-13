import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../domain/models.dart';
import '../../../l10n/app_strings.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../app_controller.dart';
import '../../core/calendar_date_field.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';

class MedicationFormScreen extends ConsumerStatefulWidget {
  const MedicationFormScreen({required this.animalId, this.medicationId, super.key});

  final String animalId;
  final String? medicationId;

  @override
  ConsumerState<MedicationFormScreen> createState() => _MedicationFormScreenState();
}

class _MedicationFormScreenState extends ConsumerState<MedicationFormScreen> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _formName;
  late final TextEditingController _dose;
  late final TextEditingController _unit;
  late final TextEditingController _instructions;
  late final TextEditingController _strength;
  late final TextEditingController _prescriber;
  late final TextEditingController _pharmacy;
  late final TextEditingController _prescriptionNumber;
  late final TextEditingController _refillsRemaining;
  late final TextEditingController _notes;
  Medication? _existing;
  late DateTime _startDate;
  DateTime? _endDate;
  DateTime? _nextRefillDate;
  bool _active = true;
  bool _saving = false;
  final List<_ScheduleDraft> _schedules = <_ScheduleDraft>[];

  bool _draftLoaded = false;

  void _loadDraft() {
    _draftLoaded = true;
    final snapshot = ref.read(
      journalViewProvider((feature: JournalFeature.medication, animalId: widget.animalId)),
    );
    _existing = snapshot.medications.where((value) => value.id == widget.medicationId).firstOrNull;
    final existing = _existing;
    _name = TextEditingController(text: existing?.name);
    _formName = TextEditingController(text: existing?.form);
    _dose = TextEditingController(text: existing?.doseAmount.toString());
    _unit = TextEditingController(text: existing?.doseUnit);
    _instructions = TextEditingController(text: existing?.instructions);
    _strength = TextEditingController(text: existing?.strength);
    _prescriber = TextEditingController(text: existing?.prescriber);
    _pharmacy = TextEditingController(text: existing?.pharmacy);
    _prescriptionNumber = TextEditingController(text: existing?.prescriptionNumber);
    _refillsRemaining = TextEditingController(text: existing?.refillsRemaining?.toString());
    _notes = TextEditingController(text: existing?.notes);
    _startDate = existing?.startDate ?? DateTime.now();
    _endDate = existing?.endDate;
    _nextRefillDate = existing?.nextRefillDate;
    _active = existing?.active ?? true;
    final savedSchedules = snapshot.medicationSchedules
        .where((value) => value.medicationId == widget.medicationId)
        .toList(growable: false);
    if (savedSchedules.isEmpty) {
      _schedules.add(
        _ScheduleDraft(
          kind: ScheduleKind.daily,
          times: <LocalClockTime>[],
          weekdays: <int>{},
          intervalHours: 12,
        ),
      );
    } else {
      _schedules.addAll(savedSchedules.map(_ScheduleDraft.fromSchedule));
    }
  }

  @override
  void dispose() {
    if (_draftLoaded) {
      for (final controller in <TextEditingController>[
        _name,
        _formName,
        _dose,
        _unit,
        _instructions,
        _strength,
        _prescriber,
        _pharmacy,
        _prescriptionNumber,
        _refillsRemaining,
        _notes,
      ]) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(
      journalViewProvider((feature: JournalFeature.medication, animalId: widget.animalId)),
    );
    if (draft.loading || draft.error != null) {
      return QueryPane(error: draft.error, onRetry: () => draft.retry(ref));
    }
    if (!_draftLoaded) _loadDraft();
    final state = ref.watch(
      journalViewProvider((feature: JournalFeature.medication, animalId: widget.animalId)),
    );
    final l10n = AppLocalizations.of(context);
    final animal = state.animals.where((value) => value.id == widget.animalId).firstOrNull;
    if (animal == null) {
      return Scaffold(body: Center(child: Text(AppLocalizations.of(context).animalNotFound)));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _existing == null
              ? AppLocalizations.of(context).addMedication
              : AppLocalizations.of(context).editMedication,
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
                      title: _existing == null
                          ? AppLocalizations.of(context).medicationFor(animal.name)
                          : _existing!.name,
                      subtitle: AppLocalizations.of(context)
                          .addDirectionsAndDoseTimesFor(animal.name),
                    ),
                    if (state.settings.notificationPermissionAsked &&
                        !state.settings.notificationsAllowed) ...[
                      const SizedBox(height: 16),
                      CalmNotice(
                        icon: Icons.notifications_off_outlined,
                        text: AppLocalizations.of(context)
                            .notificationsAreOffDueDosesRemainVisibleInCreaturely,
                        tone: NoticeTone.attention,
                      ),
                    ],
                    const SizedBox(height: 22),
                    TextFormField(
                      key: const ValueKey('medication_name'),
                      controller: _name,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).medicationName,
                      ),
                      validator: _required,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _formName,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).form,
                        hintText: AppLocalizations.of(context).tabletLiquidDropsInjection,
                      ),
                      validator: _required,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _dose,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context).doseAmount,
                            ),
                            validator: _positiveDecimal,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _unit,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context).doseUnit,
                              hintText: AppLocalizations.of(context).mgMLTablet,
                            ),
                            validator: _required,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      key: const ValueKey('medication_instructions'),
                      controller: _instructions,
                      minLines: 2,
                      maxLines: 4,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).instructions,
                      ),
                      validator: _required,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: CalendarDateField(
                            label: AppLocalizations.of(context).startDate,
                            value: _startDate,
                            onTap: () => _pickDate(start: true),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CalendarDateField(
                            label: AppLocalizations.of(context).endDate,
                            value: _endDate,
                            emptyLabel: AppLocalizations.of(context).noEndDate,
                            onTap: () => _pickDate(start: false),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Card(
                      clipBehavior: Clip.antiAlias,
                      child: ExpansionTile(
                        key: const ValueKey('medication_optional_details'),
                        initiallyExpanded: _hasOptionalDetails,
                        leading: const Icon(Icons.medical_information_outlined),
                        title: Text(l10n.medicationPrescriptionDetails),
                        subtitle: Text(l10n.medicationPrescriptionDetailsHint),
                        childrenPadding: const EdgeInsets.fromLTRB(16, 4, 16, 18),
                        children: [
                          TextFormField(
                            key: const ValueKey('medication_strength'),
                            controller: _strength,
                            decoration: InputDecoration(
                              labelText: l10n.medicationStrengthLabel,
                              hintText: l10n.medicationStrengthHint,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            key: const ValueKey('medication_prescriber'),
                            controller: _prescriber,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(labelText: l10n.medicationPrescriberLabel),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            key: const ValueKey('medication_pharmacy'),
                            controller: _pharmacy,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(labelText: l10n.medicationPharmacyLabel),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            key: const ValueKey('medication_prescription_number'),
                            controller: _prescriptionNumber,
                            decoration: InputDecoration(
                              labelText: l10n.medicationPrescriptionNumberLabel,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
                                key: const ValueKey('medication_refills_remaining'),
                                controller: _refillsRemaining,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: l10n.medicationRefillsRemainingLabel,
                                ),
                                validator: _nonNegativeInteger,
                              ),
                              const SizedBox(height: 12),
                              CalendarDateField(
                                key: const ValueKey('medication_next_refill_date'),
                                label: l10n.medicationNextRefillDateLabel,
                                value: _nextRefillDate,
                                emptyLabel: l10n.medicationNoRefillDate,
                                clearTooltip: l10n.medicationClearNextRefillDate,
                                onClear: _nextRefillDate == null
                                    ? null
                                    : () => setState(() => _nextRefillDate = null),
                                onTap: _pickNextRefillDate,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _notes,
                            minLines: 2,
                            maxLines: 4,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context).notes,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 26),
                    SectionHeading(
                      AppLocalizations.of(context).schedules,
                      trailing: TextButton.icon(
                        onPressed: _addSchedule,
                        icon: const Icon(Icons.add_rounded),
                        label: Text(AppLocalizations.of(context).add),
                      ),
                    ),
                    for (var index = 0; index < _schedules.length; index++) ...[
                      _ScheduleEditor(
                        key: ValueKey('schedule_$index'),
                        draft: _schedules[index],
                        canRemove: _schedules.length > 1,
                        onChanged: () => setState(() {}),
                        onRemove: () => setState(() => _schedules.removeAt(index)),
                      ),
                      const SizedBox(height: 12),
                    ],
                    SwitchListTile(
                      value: _active,
                      onChanged: (value) => setState(() => _active = value),
                      contentPadding: EdgeInsets.zero,
                      title: Text(AppLocalizations.of(context).activeMedication),
                      subtitle: Text(
                        AppLocalizations.of(context).inactiveRecordsRemainInTheTimeline,
                      ),
                    ),
                    const SizedBox(height: 22),
                    FilledButton.icon(
                      key: const ValueKey('save_medication'),
                      onPressed: _saving ? null : _save,
                      icon: _saving
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.check_rounded),
                      label: Text(AppLocalizations.of(context).saveMedication),
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

  bool get _hasOptionalDetails =>
      _existing?.strength != null ||
      _existing?.prescriber != null ||
      _existing?.pharmacy != null ||
      _existing?.prescriptionNumber != null ||
      _existing?.refillsRemaining != null ||
      _existing?.nextRefillDate != null ||
      _existing?.notes != null;

  void _addSchedule() {
    setState(() {
      _schedules.add(
        _ScheduleDraft(
          kind: ScheduleKind.daily,
          times: <LocalClockTime>[],
          weekdays: <int>{},
          intervalHours: 12,
        ),
      );
    });
  }

  Future<void> _pickDate({required bool start}) async {
    final value = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      initialDate: start ? _startDate : _endDate ?? _startDate,
    );
    if (value == null) {
      return;
    }
    setState(() {
      if (start) {
        _startDate = value;
      } else {
        _endDate = value;
      }
    });
  }

  Future<void> _pickNextRefillDate() async {
    final value = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      initialDate: _nextRefillDate ?? DateTime.now(),
    );
    if (value != null && mounted) {
      setState(() => _nextRefillDate = value);
    }
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) {
      return;
    }
    if (_endDate != null && _endDate!.isBefore(_startDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).theEndDateMustBeOnOrAfterThe)),
      );
      return;
    }
    if (_schedules.any((draft) => !draft.isValid)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).completeEveryScheduleBeforeSaving)),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final controller = ref.read(careControllerProvider.notifier);
      final now = DateTime.now().toUtc();
      final id = _existing?.id ?? controller.newId();
      final medication = Medication(
        id: id,
        animalId: widget.animalId,
        createdAt: _existing?.createdAt ?? now,
        updatedAt: now,
        name: _name.text.trim(),
        form: _formName.text.trim(),
        doseAmount: double.parse(_dose.text),
        doseUnit: _unit.text.trim(),
        instructions: _instructions.text.trim(),
        startDate: _startDate,
        endDate: _endDate,
        strength: _nullable(_strength.text),
        prescriber: _nullable(_prescriber.text),
        pharmacy: _nullable(_pharmacy.text),
        prescriptionNumber: _nullable(_prescriptionNumber.text),
        refillsRemaining: _nullableInteger(_refillsRemaining.text),
        nextRefillDate: _nextRefillDate,
        notes: _nullable(_notes.text),
        active: _active,
      );
      final existingSchedules = ref
          .read(
            journalViewProvider((feature: JournalFeature.medication, animalId: widget.animalId)),
          )
          .medicationSchedules
          .where((value) => value.medicationId == id)
          .toList(growable: false);
      final schedules = <MedicationSchedule>[
        for (var index = 0; index < _schedules.length; index++)
          MedicationSchedule(
            id: index < existingSchedules.length ? existingSchedules[index].id : controller.newId(),
            medicationId: id,
            animalId: widget.animalId,
            createdAt: index < existingSchedules.length ? existingSchedules[index].createdAt : now,
            updatedAt: now,
            kind: _schedules[index].kind,
            timeZoneId: tz.local.name,
            intervalHours: _schedules[index].kind == ScheduleKind.interval
                ? _schedules[index].intervalHours
                : null,
            times: _schedules[index].times,
            weekdays: _schedules[index].weekdays,
          ),
      ];
      await controller.saveMedication(medication, schedules);
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

  String? _positiveDecimal(String? value) {
    final parsed = double.tryParse(value ?? '');
    return parsed == null || !parsed.isFinite || parsed <= 0
        ? AppLocalizations.of(context).useAPositiveNumber
        : null;
  }

  String? _nonNegativeInteger(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final parsed = int.tryParse(value.trim());
    return parsed == null || parsed < 0
        ? AppLocalizations.of(context).medicationRefillsValidation
        : null;
  }

  String? _nullable(String value) => value.trim().isEmpty ? null : value.trim();

  int? _nullableInteger(String value) => value.trim().isEmpty ? null : int.parse(value.trim());
}

class _ScheduleDraft {
  _ScheduleDraft({
    required this.kind,
    required this.times,
    required this.weekdays,
    required this.intervalHours,
  });

  factory _ScheduleDraft.fromSchedule(MedicationSchedule schedule) => _ScheduleDraft(
    kind: schedule.kind,
    times: [...schedule.times],
    weekdays: {...schedule.weekdays},
    intervalHours: schedule.intervalHours ?? 12,
  );

  ScheduleKind kind;
  List<LocalClockTime> times;
  Set<int> weekdays;
  int intervalHours;

  bool get isValid => switch (kind) {
    ScheduleKind.interval => intervalHours > 0 && times.isNotEmpty,
    ScheduleKind.daily => times.isNotEmpty,
    ScheduleKind.selectedWeekdays => times.isNotEmpty && weekdays.isNotEmpty,
  };
}

class _ScheduleEditor extends StatelessWidget {
  const _ScheduleEditor({
    required this.draft,
    required this.canRemove,
    required this.onChanged,
    required this.onRemove,
    super.key,
  });

  final _ScheduleDraft draft;
  final bool canRemove;
  final VoidCallback onChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<ScheduleKind>(
                  initialValue: draft.kind,
                  isExpanded: true,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context).scheduleType),
                  items: [
                    DropdownMenuItem(
                      value: ScheduleKind.daily,
                      child: Text(AppLocalizations.of(context).everyDay),
                    ),
                    DropdownMenuItem(
                      value: ScheduleKind.selectedWeekdays,
                      child: Text(AppLocalizations.of(context).selectedWeekdays),
                    ),
                    DropdownMenuItem(
                      value: ScheduleKind.interval,
                      child: Text(AppLocalizations.of(context).repeatingInterval),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null && context.mounted) {
                      draft.kind = value;
                      if (value == ScheduleKind.interval && draft.times.length > 1) {
                        draft.times = <LocalClockTime>[draft.times.first];
                      }
                      onChanged();
                    }
                  },
                ),
              ),
              if (canRemove)
                IconButton(
                  tooltip: AppLocalizations.of(context).removeSchedule,
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline_rounded),
                ),
            ],
          ),
          if (draft.kind == ScheduleKind.interval) ...[
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              initialValue: draft.intervalHours,
              decoration: InputDecoration(labelText: AppLocalizations.of(context).every),
              items: const <int>[4, 6, 8, 12, 24, 48]
                  .map(
                    (value) => DropdownMenuItem(
                      value: value,
                      child: Text(AppLocalizations.of(context).hours(value)),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                draft.intervalHours = value ?? draft.intervalHours;
                onChanged();
              },
            ),
          ],
          if (draft.kind == ScheduleKind.selectedWeekdays) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (var day = 1; day <= 7; day++)
                  FilterChip(
                    label: Text(
                      <String>[
                        AppLocalizations.of(context).mon,
                        AppLocalizations.of(context).tue,
                        AppLocalizations.of(context).wed,
                        AppLocalizations.of(context).thu,
                        AppLocalizations.of(context).fri,
                        AppLocalizations.of(context).sat,
                        AppLocalizations.of(context).sun,
                      ][day - 1],
                    ),
                    selected: draft.weekdays.contains(day),
                    onSelected: (selected) {
                      selected ? draft.weekdays.add(day) : draft.weekdays.remove(day);
                      onChanged();
                    },
                  ),
              ],
            ),
          ],
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final time in draft.times)
                InputChip(
                  key: ValueKey('schedule_time_${time.encoded}'),
                  label: Text(
                    MaterialLocalizations.of(context)
                        .formatTimeOfDay(TimeOfDay(hour: time.hour, minute: time.minute)),
                  ),
                  deleteButtonTooltipMessage: AppLocalizations.of(context).remove(
                    MaterialLocalizations.of(context)
                        .formatTimeOfDay(TimeOfDay(hour: time.hour, minute: time.minute)),
                  ),
                  onDeleted: () {
                    draft.times.remove(time);
                    onChanged();
                  },
                ),
              ActionChip(
                avatar: Icon(
                  draft.kind == ScheduleKind.interval
                      ? Icons.edit_calendar_outlined
                      : Icons.add_alarm_rounded,
                  size: 18,
                ),
                label: Text(
                  draft.kind == ScheduleKind.interval
                      ? draft.times.isEmpty
                            ? AppLocalizations.of(context).setStartTime
                            : AppLocalizations.of(context).changeStartTime
                      : AppLocalizations.of(context).addTime,
                ),
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: draft.times.isEmpty
                        ? const TimeOfDay(hour: 8, minute: 0)
                        : TimeOfDay(hour: draft.times.first.hour, minute: draft.times.first.minute),
                  );
                  if (picked != null && context.mounted) {
                    final value = LocalClockTime(picked.hour, picked.minute);
                    if (draft.kind == ScheduleKind.interval) {
                      draft.times = <LocalClockTime>[value];
                      onChanged();
                    } else if (!draft.times.contains(value)) {
                      draft.times.add(value);
                      draft.times.sort();
                      onChanged();
                    }
                  }
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
