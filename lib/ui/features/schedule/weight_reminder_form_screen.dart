import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../domain/models.dart';
import '../../../l10n/app_strings.dart';
import '../../app_controller.dart';
import '../../core/calendar_date_field.dart';
import '../../core/commands.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import 'reminder_schedule_fields.dart';

class WeightReminderFormScreen extends ConsumerStatefulWidget {
  const WeightReminderFormScreen({required this.animalId, this.reminderId, super.key});

  final String animalId;
  final String? reminderId;

  @override
  ConsumerState<WeightReminderFormScreen> createState() => _WeightReminderFormScreenState();
}

class _WeightReminderFormScreenState extends ConsumerState<WeightReminderFormScreen> {
  WeightCheckReminder? _existing;
  late ReminderRecurrence _recurrence;
  late DateTime _startDate;
  DateTime? _endDate;
  late bool _enabled;
  late List<LocalClockTime> _times;
  late Set<int> _weekdays;
  bool _saving = false;

  bool _draftLoaded = false;

  void _loadDraft() {
    _draftLoaded = true;
    final snapshot = ref.read(
      journalViewProvider((feature: JournalFeature.weightReminder, animalId: widget.animalId)),
    );
    _existing = snapshot.weightReminders
        .where((value) => value.id == widget.reminderId)
        .firstOrNull;
    final existing = _existing;
    _recurrence = existing?.recurrence ?? ReminderRecurrence.selectedWeekdays;
    _startDate = existing?.startDate ?? DateTime.now();
    _endDate = existing?.endDate;
    _enabled = existing?.enabled ?? true;
    _times = [...?existing?.times]..sort();
    _weekdays = existing == null ? <int>{DateTime.now().weekday} : {...existing.weekdays};
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(
      journalViewProvider((feature: JournalFeature.weightReminder, animalId: widget.animalId)),
    );
    if (draft.loading || draft.error != null) {
      return QueryPane(error: draft.error, onRetry: () => draft.retry(ref));
    }
    if (!_draftLoaded) _loadDraft();
    final state = ref.watch(
      journalViewProvider((feature: JournalFeature.weightReminder, animalId: widget.animalId)),
    );
    final animal = state.animals.where((value) => value.id == widget.animalId).firstOrNull;
    if (animal == null) {
      return Scaffold(body: Center(child: Text(AppLocalizations.of(context).animalNotFound)));
    }
    final notificationsOn = state.settings.notificationsAllowed;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _existing == null
              ? AppLocalizations.of(context).addWeightReminder
              : AppLocalizations.of(context).editWeightReminder,
        ),
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
                    title: AppLocalizations.of(context).weightCheckFor(animal.name),
                    subtitle: AppLocalizations.of(context).chooseWhenYouWantAGentlePromptToRecord,
                  ),
                  if (!notificationsOn) ...[
                    const SizedBox(height: 16),
                    CalmNotice(
                      icon: Icons.notifications_off_outlined,
                      text: AppLocalizations.of(context)
                          .notificationsAreOffThisReminderWillStillAppearIn,
                      tone: NoticeTone.attention,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () => runUiCommand(context, () async {
                          await ref
                              .read(settingsControllerProvider.notifier)
                              .requestNotifications();
                        }),
                        icon: const Icon(Icons.notifications_active_outlined),
                        label: Text(AppLocalizations.of(context).turnOnNotifications),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  ReminderScheduleFields(
                    recurrence: _recurrence,
                    weekdays: _weekdays,
                    times: _times,
                    keyPrefix: 'weight',
                    onRecurrence: (value) => setState(() => _recurrence = value),
                    onWeekday: (day, selected) =>
                        setState(() => selected ? _weekdays.add(day) : _weekdays.remove(day)),
                    onAddTime: _addTime,
                    onRemoveTime: (time) => setState(() => _times.remove(time)),
                  ),
                  const SizedBox(height: 22),
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
                    title: Text(AppLocalizations.of(context).reminderActive),
                    subtitle: Text(
                      AppLocalizations.of(context).turnThisOffWithoutDeletingTheSchedule,
                    ),
                  ),
                  const SizedBox(height: 18),
                  FilledButton.icon(
                    key: const ValueKey('save_weight_reminder'),
                    onPressed: _saving ? null : _save,
                    icon: _saving
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.check_rounded),
                    label: Text(AppLocalizations.of(context).saveReminder),
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
    final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
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
    if (value == null || !mounted) {
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
      _message(AppLocalizations.of(context).addAtLeastOneReminderTime);
      return;
    }
    if (_recurrence == ReminderRecurrence.selectedWeekdays && _weekdays.isEmpty) {
      _message(AppLocalizations.of(context).chooseAtLeastOneWeekday);
      return;
    }
    if (_endDate != null && compareCalendarDates(_endDate!, _startDate) < 0) {
      _message(AppLocalizations.of(context).theEndDateMustBeOnOrAfterThe);
      return;
    }
    setState(() => _saving = true);
    try {
      final controller = ref.read(careControllerProvider.notifier);
      final now = DateTime.now().toUtc();
      final reminder = WeightCheckReminder(
        id: _existing?.id ?? controller.newId(),
        animalId: widget.animalId,
        createdAt: _existing?.createdAt ?? now,
        updatedAt: now,
        startDate: canonicalCalendarDate(_startDate),
        endDate: _endDate == null ? null : canonicalCalendarDate(_endDate!),
        recurrence: _recurrence,
        timeZoneId: tz.local.name,
        times: List<LocalClockTime>.unmodifiable(_times),
        weekdays: Set<int>.unmodifiable(_weekdays),
        enabled: _enabled,
      );
      await controller.saveWeightReminder(reminder);
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

  void _message(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }
}
