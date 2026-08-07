import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../domain/models.dart';
import '../../app_controller.dart';
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
  late final TextEditingController _prescriber;
  late final TextEditingController _notes;
  Medication? _existing;
  late DateTime _startDate;
  DateTime? _endDate;
  bool _active = true;
  bool _saving = false;
  final List<_ScheduleDraft> _schedules = <_ScheduleDraft>[];

  @override
  void initState() {
    super.initState();
    final snapshot = ref.read(appControllerProvider).snapshot;
    _existing = snapshot.medications.where((value) => value.id == widget.medicationId).firstOrNull;
    final existing = _existing;
    _name = TextEditingController(text: existing?.name);
    _formName = TextEditingController(text: existing?.form);
    _dose = TextEditingController(text: existing?.doseAmount.toString());
    _unit = TextEditingController(text: existing?.doseUnit);
    _instructions = TextEditingController(text: existing?.instructions);
    _prescriber = TextEditingController(text: existing?.prescriber);
    _notes = TextEditingController(text: existing?.notes);
    _startDate = existing?.startDate ?? DateTime.now();
    _endDate = existing?.endDate;
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
    for (final controller in <TextEditingController>[
      _name,
      _formName,
      _dose,
      _unit,
      _instructions,
      _prescriber,
      _notes,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appControllerProvider);
    final animal = state.snapshot.animals.where((value) => value.id == widget.animalId).firstOrNull;
    if (animal == null) {
      return const Scaffold(body: Center(child: Text('Animal not found.')));
    }
    return Scaffold(
      appBar: AppBar(title: Text(_existing == null ? 'Add medication' : 'Edit medication')),
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
                      title: _existing == null ? 'Medication for ${animal.name}' : _existing!.name,
                      subtitle: 'Add directions and dose times for ${animal.name}.',
                    ),
                    if (state.snapshot.settings.notificationPermissionAsked &&
                        !state.snapshot.settings.notificationsAllowed) ...[
                      const SizedBox(height: 16),
                      const CalmNotice(
                        icon: Icons.notifications_off_outlined,
                        text:
                            'Notifications are off. Due doses remain visible in Creaturely, '
                            'and the schedule can still be saved.',
                        tone: NoticeTone.attention,
                      ),
                    ],
                    const SizedBox(height: 22),
                    TextFormField(
                      key: const ValueKey('medication_name'),
                      controller: _name,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(labelText: 'Medication name *'),
                      validator: _required,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _formName,
                      decoration: const InputDecoration(
                        labelText: 'Form *',
                        hintText: 'Tablet, liquid, drops, injection…',
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
                            decoration: const InputDecoration(labelText: 'Dose amount *'),
                            validator: _positiveDecimal,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _unit,
                            decoration: const InputDecoration(
                              labelText: 'Dose unit *',
                              hintText: 'mg, mL, tablet',
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
                      decoration: const InputDecoration(labelText: 'Instructions *'),
                      validator: _required,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _DateField(
                            label: 'Start date',
                            value: _startDate,
                            onTap: () => _pickDate(start: true),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _DateField(
                            label: 'End date',
                            value: _endDate,
                            emptyLabel: 'No end date',
                            onTap: () => _pickDate(start: false),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _prescriber,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(labelText: 'Prescriber'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _notes,
                      minLines: 2,
                      maxLines: 4,
                      decoration: const InputDecoration(labelText: 'Notes'),
                    ),
                    const SizedBox(height: 26),
                    SectionHeading(
                      'Schedules',
                      trailing: TextButton.icon(
                        onPressed: _addSchedule,
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Add'),
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
                      title: const Text('Active medication'),
                      subtitle: const Text('Inactive records remain in the timeline.'),
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
                      label: const Text('Save medication'),
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

  Future<void> _save() async {
    if (!_form.currentState!.validate()) {
      return;
    }
    if (_endDate != null && _endDate!.isBefore(_startDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('The end date must be on or after the start date.')),
      );
      return;
    }
    if (_schedules.any((draft) => !draft.isValid)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Complete every schedule before saving.')));
      return;
    }
    setState(() => _saving = true);
    try {
      final controller = ref.read(appControllerProvider.notifier);
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
        prescriber: _nullable(_prescriber.text),
        notes: _nullable(_notes.text),
        active: _active,
      );
      final existingSchedules = ref
          .read(appControllerProvider)
          .snapshot
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
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'This field is required.' : null;

  String? _positiveDecimal(String? value) {
    final parsed = double.tryParse(value ?? '');
    return parsed == null || !parsed.isFinite || parsed <= 0 ? 'Use a positive number.' : null;
  }

  String? _nullable(String value) => value.trim().isEmpty ? null : value.trim();
}

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
                  decoration: const InputDecoration(labelText: 'Schedule type'),
                  items: const [
                    DropdownMenuItem(value: ScheduleKind.daily, child: Text('Every day')),
                    DropdownMenuItem(
                      value: ScheduleKind.selectedWeekdays,
                      child: Text('Selected weekdays'),
                    ),
                    DropdownMenuItem(
                      value: ScheduleKind.interval,
                      child: Text('Repeating interval'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
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
                  tooltip: 'Remove schedule',
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline_rounded),
                ),
            ],
          ),
          if (draft.kind == ScheduleKind.interval) ...[
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              initialValue: draft.intervalHours,
              decoration: const InputDecoration(labelText: 'Every'),
              items: const <int>[4, 6, 8, 12, 24, 48]
                  .map((value) => DropdownMenuItem(value: value, child: Text('$value hours')))
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
                      const <String>['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][day - 1],
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
                    MaterialLocalizations.of(
                      context,
                    ).formatTimeOfDay(TimeOfDay(hour: time.hour, minute: time.minute)),
                  ),
                  deleteButtonTooltipMessage:
                      'Remove ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay(hour: time.hour, minute: time.minute))}',
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
                            ? 'Set start time'
                            : 'Change start time'
                      : 'Add time',
                ),
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: draft.times.isEmpty
                        ? const TimeOfDay(hour: 8, minute: 0)
                        : TimeOfDay(hour: draft.times.first.hour, minute: draft.times.first.minute),
                  );
                  if (picked != null) {
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
