import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../domain/models.dart';
import '../../app_controller.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';

class RespiratoryReminderFormScreen extends ConsumerStatefulWidget {
  const RespiratoryReminderFormScreen({required this.animalId, this.reminderId, super.key});

  final String animalId;
  final String? reminderId;

  @override
  ConsumerState<RespiratoryReminderFormScreen> createState() =>
      _RespiratoryReminderFormScreenState();
}

class _RespiratoryReminderFormScreenState extends ConsumerState<RespiratoryReminderFormScreen> {
  RespiratoryReminder? _existing;
  late RespiratoryContext _context;
  late ReminderRecurrence _recurrence;
  late DateTime _startDate;
  DateTime? _endDate;
  late bool _enabled;
  late List<LocalClockTime> _times;
  late Set<int> _weekdays;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final snapshot = ref.read(appControllerProvider).snapshot;
    _existing = snapshot.respiratoryReminders
        .where((value) => value.id == widget.reminderId)
        .firstOrNull;
    final existing = _existing;
    _context = existing?.context ?? RespiratoryContext.sleeping;
    _recurrence = existing?.recurrence ?? ReminderRecurrence.daily;
    _startDate = existing?.startDate ?? DateTime.now();
    _endDate = existing?.endDate;
    _enabled = existing?.enabled ?? true;
    _times = [...?existing?.times]..sort();
    _weekdays = {...?existing?.weekdays};
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appControllerProvider);
    final animal = state.snapshot.animals.where((value) => value.id == widget.animalId).firstOrNull;
    if (animal == null) {
      return const Scaffold(body: Center(child: Text('Animal not found.')));
    }
    final notificationsOn = state.snapshot.settings.notificationsAllowed;
    return Scaffold(
      appBar: AppBar(
        title: Text(_existing == null ? 'Add breathing reminder' : 'Edit breathing reminder'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(CreaturelySpacing.medium),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: CreaturelySpacing.maxFormWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PageHeading(
                    title: 'Breathing check for ${animal.name}',
                    subtitle: 'Choose when you want a gentle prompt to take a manual reading.',
                  ),
                  if (!notificationsOn) ...[
                    const SizedBox(height: 16),
                    CalmNotice(
                      icon: Icons.notifications_off_outlined,
                      text: 'Notifications are off. This reminder will still appear in Schedule.',
                      tone: NoticeTone.attention,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () =>
                            ref.read(appControllerProvider.notifier).requestNotifications(),
                        icon: const Icon(Icons.notifications_active_outlined),
                        label: const Text('Turn on notifications'),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Text('Observation context', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  SegmentedButton<RespiratoryContext>(
                    segments: const [
                      ButtonSegment(
                        value: RespiratoryContext.sleeping,
                        icon: Icon(Icons.bedtime_outlined),
                        label: Text('Sleeping'),
                      ),
                      ButtonSegment(
                        value: RespiratoryContext.resting,
                        icon: Icon(Icons.self_improvement_outlined),
                        label: Text('Resting'),
                      ),
                    ],
                    selected: {_context},
                    onSelectionChanged: (values) => setState(() => _context = values.first),
                  ),
                  const SizedBox(height: 18),
                  DropdownButtonFormField<ReminderRecurrence>(
                    initialValue: _recurrence,
                    decoration: const InputDecoration(labelText: 'Repeat'),
                    items: const [
                      DropdownMenuItem(value: ReminderRecurrence.daily, child: Text('Every day')),
                      DropdownMenuItem(
                        value: ReminderRecurrence.selectedWeekdays,
                        child: Text('Selected weekdays'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _recurrence = value);
                      }
                    },
                  ),
                  if (_recurrence == ReminderRecurrence.selectedWeekdays) ...[
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (var day = 1; day <= 7; day++)
                          FilterChip(
                            key: ValueKey('rrr_weekday_$day'),
                            label: Text(
                              const <String>['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][day -
                                  1],
                            ),
                            selected: _weekdays.contains(day),
                            onSelected: (selected) => setState(
                              () => selected ? _weekdays.add(day) : _weekdays.remove(day),
                            ),
                          ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 22),
                  SectionHeading(
                    'Reminder times',
                    trailing: TextButton.icon(
                      key: const ValueKey('add_rrr_time'),
                      onPressed: _addTime,
                      icon: const Icon(Icons.add_alarm_rounded),
                      label: const Text('Add time'),
                    ),
                  ),
                  if (_times.isEmpty)
                    Text(
                      'Add at least one time.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final time in _times)
                          InputChip(
                            key: ValueKey('rrr_time_${time.encoded}'),
                            label: Text(_formatTime(context, time)),
                            deleteButtonTooltipMessage: 'Remove ${_formatTime(context, time)}',
                            onDeleted: () => setState(() => _times.remove(time)),
                          ),
                      ],
                    ),
                  const SizedBox(height: 22),
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
                          onClear: _endDate == null ? null : () => setState(() => _endDate = null),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _enabled,
                    onChanged: (value) => setState(() => _enabled = value),
                    title: const Text('Reminder active'),
                    subtitle: const Text('Turn this off without deleting the schedule.'),
                  ),
                  const SizedBox(height: 18),
                  FilledButton.icon(
                    key: const ValueKey('save_rrr_reminder'),
                    onPressed: _saving ? null : _save,
                    icon: _saving
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.check_rounded),
                    label: const Text('Save reminder'),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addTime() async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(context: context, initialTime: now);
    if (picked == null) {
      return;
    }
    final value = LocalClockTime(picked.hour, picked.minute);
    if (!_times.contains(value)) {
      setState(() {
        _times.add(value);
        _times.sort();
      });
    }
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
    if (_times.isEmpty) {
      _message('Add at least one reminder time.');
      return;
    }
    if (_recurrence == ReminderRecurrence.selectedWeekdays && _weekdays.isEmpty) {
      _message('Choose at least one weekday.');
      return;
    }
    if (_endDate != null && compareCalendarDates(_endDate!, _startDate) < 0) {
      _message('The end date must be on or after the start date.');
      return;
    }
    setState(() => _saving = true);
    try {
      final controller = ref.read(appControllerProvider.notifier);
      final now = DateTime.now().toUtc();
      final reminder = RespiratoryReminder(
        id: _existing?.id ?? controller.newId(),
        animalId: widget.animalId,
        createdAt: _existing?.createdAt ?? now,
        updatedAt: now,
        startDate: _startDate,
        endDate: _endDate,
        context: _context,
        recurrence: _recurrence,
        timeZoneId: tz.local.name,
        times: List<LocalClockTime>.unmodifiable(_times),
        weekdays: Set<int>.unmodifiable(_weekdays),
        enabled: _enabled,
      );
      await controller.saveRespiratoryReminder(reminder);
      if (mounted) {
        context.pop();
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  String _formatTime(BuildContext context, LocalClockTime time) => MaterialLocalizations.of(
    context,
  ).formatTimeOfDay(TimeOfDay(hour: time.hour, minute: time.minute));

  void _message(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
    this.emptyLabel = 'Choose date',
    this.onClear,
  });

  final String label;
  final DateTime? value;
  final VoidCallback onTap;
  final String emptyLabel;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) => InputDecorator(
    decoration: InputDecoration(labelText: label),
    child: Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                value == null
                    ? emptyLabel
                    : MaterialLocalizations.of(context).formatMediumDate(value!),
              ),
            ),
          ),
        ),
        if (onClear != null)
          IconButton(
            tooltip: 'Clear end date',
            onPressed: onClear,
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.close_rounded),
          ),
      ],
    ),
  );
}
