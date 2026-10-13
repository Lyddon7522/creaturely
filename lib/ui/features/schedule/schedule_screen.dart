import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../domain/care_schedule.dart';
import '../../../domain/models.dart';
import '../../../l10n/app_strings.dart';
import '../../app_controller.dart';
import '../../core/commands.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../../navigation/top_level_scroll.dart';

enum _ScheduleView { today, sevenDays, schedules }

enum _AddCare { breathing, medication, weight }

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({this.initialView, super.key});

  final String? initialView;

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  static const CareScheduleBuilder _builder = CareScheduleBuilder();
  final ScrollController _scrollController = ScrollController();
  late final TopLevelScrollCoordinator _scrollCoordinator;
  late final ScrollToTopCallback _scrollToTop;
  late _ScheduleView _view;

  @override
  void initState() {
    super.initState();
    _view = _viewFrom(widget.initialView);
    _scrollCoordinator = ref.read(topLevelScrollCoordinatorProvider);
    _scrollToTop = () => animateTopLevelScrollToStart(context, _scrollController);
    _scrollCoordinator.register(TopLevelDestination.schedule, _scrollToTop);
  }

  @override
  void didUpdateWidget(covariant ScheduleScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialView != oldWidget.initialView) {
      _view = _viewFrom(widget.initialView);
    }
  }

  @override
  void dispose() {
    _scrollCoordinator.unregister(TopLevelDestination.schedule, _scrollToTop);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      journalViewProvider((feature: JournalFeature.schedule, animalId: null)),
    );
    if (state.loading || state.error != null) {
      return QueryPane(error: state.error, onRetry: () => state.retry(ref));
    }
    final animal = state.selectedAnimal;
    final compact = usesCompactVerticalLayout(context);
    if (animal == null) {
      return Scaffold(
        appBar: AppBar(actions: const [SettingsAction()]),
        body: EmptyState(
          icon: Icons.calendar_month_outlined,
          title: AppLocalizations.of(context).noAnimalSelected,
          body: AppLocalizations.of(context).addAnAnimalToCreateACareSchedule,
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: compact ? 48 : null,
        title: const AnimalPicker(),
        actions: [
          PopupMenuButton<_AddCare>(
            tooltip: AppLocalizations.of(context).addScheduledCare,
            icon: const Icon(Icons.add_rounded),
            onSelected: (value) => _add(value, animal.id),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: _AddCare.breathing,
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.air_rounded),
                  title: Text(AppLocalizations.of(context).breathingReminder),
                ),
              ),
              PopupMenuItem(
                value: _AddCare.medication,
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.medication_outlined),
                  title: Text(AppLocalizations.of(context).medications),
                ),
              ),
              PopupMenuItem(
                value: _AddCare.weight,
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.monitor_weight_outlined),
                  title: Text(AppLocalizations.of(context).weightCheckReminder),
                ),
              ),
            ],
          ),
          const SettingsAction(),
          const SizedBox(width: 4),
        ],
      ),
      body: ConstrainedPage(
        padding: EdgeInsets.fromLTRB(16, compact ? 4 : 12, 16, compact ? 12 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PageHeading(
              title: AppLocalizations.of(context).sSchedule(animal.name),
              subtitle: AppLocalizations.of(context).medicationBreathingChecksAndWeightChecks,
            ),
            SizedBox(height: compact ? 8 : 16),
            SegmentedButton<_ScheduleView>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                  value: _ScheduleView.today,
                  icon: const Icon(Icons.today_outlined),
                  label: Text(AppLocalizations.of(context).today),
                ),
                ButtonSegment(
                  value: _ScheduleView.sevenDays,
                  icon: const Icon(Icons.date_range_outlined),
                  label: Text(AppLocalizations.of(context).label7Days),
                ),
                ButtonSegment(
                  value: _ScheduleView.schedules,
                  icon: const Icon(Icons.repeat_rounded),
                  label: Text(AppLocalizations.of(context).schedules),
                ),
              ],
              selected: {_view},
              onSelectionChanged: (values) {
                setState(() => _view = values.first);
                if (_scrollController.hasClients) {
                  _scrollController.jumpTo(0);
                }
              },
            ),
            SizedBox(height: compact ? 8 : 14),
            if (!state.settings.notificationsAllowed) ...[
              CalmNotice(
                icon: Icons.notifications_off_outlined,
                text: AppLocalizations.of(context)
                    .notificationsAreOffYourCareScheduleStillWorksHere,
                tone: NoticeTone.attention,
              ),
              const SizedBox(height: 10),
            ],
            Expanded(
              child: _view == _ScheduleView.schedules
                  ? _savedSchedules(state, animal)
                  : _occurrences(state, animal),
            ),
          ],
        ),
      ),
    );
  }

  Widget _occurrences(JournalView state, Animal animal) {
    final now = ref.read(wallClockProvider)();
    final startLocal = DateTime(now.year, now.month, now.day);
    final endLocal = _view == _ScheduleView.today
        ? DateTime(now.year, now.month, now.day + 1)
        : DateTime(now.year, now.month, now.day + 7);
    final items = _builder.build(
      animals: state.animals,
      medications: state.medications,
      doses: state.doseLedger,
      respiratoryReminders: state.respiratoryReminders,
      weightReminders: state.weightReminders,
      rangeStartUtc: startLocal.toUtc(),
      rangeEndUtc: endLocal.toUtc(),
      animalId: animal.id,
    );
    if (items.isEmpty) {
      return EmptyState(
        icon: Icons.event_available_outlined,
        title: _view == _ScheduleView.today
            ? AppLocalizations.of(context).nothingScheduledToday
            : AppLocalizations.of(context).nothingScheduledInTheNext7Days,
        body: AppLocalizations.of(context).useAddToCreateABreathingReminderMedicationOr,
      );
    }
    final children = <Widget>[];
    DateTime? previousDay;
    for (final item in items) {
      final local = item.dueAt.toLocal();
      final day = DateTime(local.year, local.month, local.day);
      if (previousDay != day) {
        children.add(
          Padding(
            padding: EdgeInsets.only(top: children.isEmpty ? 4 : 18, bottom: 8),
            child: Text(_dayLabel(day), style: Theme.of(context).textTheme.titleMedium),
          ),
        );
        previousDay = day;
      }
      children.add(
        KeyedSubtree(
          key: ValueKey('schedule_${item.id}'),
          child: _OccurrenceCard(item: item, onDose: _recordDose, onOpen: _openItem),
        ),
      );
      children.add(const SizedBox(height: 10));
    }
    return ListView(controller: _scrollController, children: children);
  }

  Widget _savedSchedules(JournalView state, Animal animal) {
    final reminders = state.respiratoryReminders
        .where((value) => value.animalId == animal.id)
        .toList(growable: false);
    final medications = state.medications
        .where((value) => value.animalId == animal.id && value.active)
        .toList(growable: false);
    final weightReminders = state.weightReminders
        .where((value) => value.animalId == animal.id)
        .toList(growable: false);
    if (reminders.isEmpty && medications.isEmpty && weightReminders.isEmpty) {
      return EmptyState(
        icon: Icons.event_repeat_outlined,
        title: AppLocalizations.of(context).noSavedSchedules,
        body: AppLocalizations.of(context).useAddToCreateABreathingReminderMedicationOr,
      );
    }
    return ListView(
      controller: _scrollController,
      children: [
        if (reminders.isNotEmpty) ...[
          SectionHeading(AppLocalizations.of(context).breathingReminders),
          for (final reminder in reminders) ...[
            _RespiratoryScheduleCard(
              reminder: reminder,
              onEdit: () =>
                  context.push('/breathing-reminder/${reminder.id}/edit/${reminder.animalId}'),
              onToggle: (enabled) => ref
                  .read(careControllerProvider.notifier)
                  .saveRespiratoryReminder(
                    reminder.copyWith(updatedAt: DateTime.now().toUtc(), enabled: enabled),
                  ),
              onDelete: () => _deleteReminder(reminder),
            ),
            const SizedBox(height: 10),
          ],
        ],
        if (medications.isNotEmpty) ...[
          SectionHeading(AppLocalizations.of(context).medicationSchedules),
          for (final medication in medications) ...[
            _MedicationScheduleCard(
              medication: medication,
              schedules: state.medicationSchedules
                  .where((value) => value.medicationId == medication.id)
                  .toList(growable: false),
              onTap: () => context.push('/medication/${medication.id}/${medication.animalId}'),
            ),
            const SizedBox(height: 10),
          ],
        ],
        if (weightReminders.isNotEmpty) ...[
          SectionHeading(AppLocalizations.of(context).weightCheckReminders),
          for (final reminder in weightReminders) ...[
            _WeightScheduleCard(
              reminder: reminder,
              onEdit: () =>
                  context.push('/weight-reminder/${reminder.id}/edit/${reminder.animalId}'),
              onToggle: (enabled) => ref
                  .read(careControllerProvider.notifier)
                  .saveWeightReminder(
                    reminder.copyWith(updatedAt: DateTime.now().toUtc(), enabled: enabled),
                  ),
              onDelete: () => _deleteWeightReminder(reminder),
            ),
            const SizedBox(height: 10),
          ],
        ],
        const SizedBox(height: 24),
      ],
    );
  }

  Future<void> _recordDose(DoseLedgerEntry dose, DoseStatus status) => runUiCommand(
    context,
    () => ref.read(careControllerProvider.notifier).recordDose(dose.id, status),
  );

  void _openItem(CareScheduleItem item) {
    switch (item.source) {
      case RespiratoryReminderOccurrence(:final reminder):
        ref.read(selectedAnimalProvider.notifier).selectAnimal(reminder.animalId);
        context.push('/record/breaths/${reminder.animalId}?context=${reminder.context.name}');
        break;
      case WeightReminderOccurrence(:final reminder):
        ref.read(selectedAnimalProvider.notifier).selectAnimal(reminder.animalId);
        context.push('/health/new/${reminder.animalId}');
        break;
      case DoseLedgerEntry():
        break;
      default:
        break;
    }
  }

  void _add(_AddCare value, String animalId) {
    switch (value) {
      case _AddCare.breathing:
        context.push('/breathing-reminder/new/$animalId');
        break;
      case _AddCare.medication:
        context.push('/medication/new/$animalId');
        break;
      case _AddCare.weight:
        context.push('/weight-reminder/new/$animalId');
        break;
    }
  }

  Future<void> _deleteReminder(RespiratoryReminder reminder) async {
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context).deleteBreathingReminder),
            content: Text(
              AppLocalizations.of(context)
                  .thisRemovesFuturePromptsSavedBreathingMeasurementsAreUnchanged,
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
    if (confirmed) {
      await ref
          .read(careControllerProvider.notifier)
          .deleteRecord(RecordKind.respiratoryReminder, reminder.id);
    }
  }

  Future<void> _deleteWeightReminder(WeightCheckReminder reminder) async {
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context).deleteWeightCheckReminder),
            content: Text(
              AppLocalizations.of(context)
                  .thisRemovesFuturePromptsSavedWeightMeasurementsAreUnchanged,
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
    if (confirmed) {
      await ref
          .read(careControllerProvider.notifier)
          .deleteRecord(RecordKind.weightReminder, reminder.id);
    }
  }

  String _dayLabel(DateTime day) {
    final now = ref.read(wallClockProvider)();
    final today = DateTime(now.year, now.month, now.day);
    if (day == today) {
      return AppLocalizations.of(context).today;
    }
    if (day == today.add(const Duration(days: 1))) {
      return AppLocalizations.of(context).tomorrow;
    }
    return DateFormat.EEEE().add_MMMd().format(day);
  }

  static _ScheduleView _viewFrom(String? value) => switch (value) {
    'week' => _ScheduleView.sevenDays,
    'schedules' => _ScheduleView.schedules,
    _ => _ScheduleView.today,
  };
}

class _OccurrenceCard extends StatelessWidget {
  const _OccurrenceCard({required this.item, required this.onDose, required this.onOpen});

  final CareScheduleItem item;
  final Future<void> Function(DoseLedgerEntry dose, DoseStatus status) onDose;
  final ValueChanged<CareScheduleItem> onOpen;

  String _title(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return switch (item.kind) {
      CareScheduleItemKind.medication => item.medication!.name,
      CareScheduleItemKind.respiratory =>
        (item.source as RespiratoryReminderOccurrence).reminder.context ==
                RespiratoryContext.sleeping
            ? strings.sleepingBreathingCheck
            : strings.restingBreathingCheck,
      CareScheduleItemKind.weight => strings.weightCheck,
    };
  }

  String _detail(BuildContext context) {
    final medication = item.medication;
    return switch (item.kind) {
      CareScheduleItemKind.medication =>
        '${medication!.doseAmount} ${medication.doseUnit} • ${medication.instructions}',
      CareScheduleItemKind.respiratory => AppLocalizations.of(
        context,
      ).manualRespiratoryRateReminder,
      CareScheduleItemKind.weight => AppLocalizations.of(context).recordAWeighIn,
    };
  }

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (item.kind) {
      CareScheduleItemKind.medication => (Icons.medication_outlined, CreaturelyColors.success),
      CareScheduleItemKind.respiratory => (Icons.air_rounded, CreaturelyColors.vitalTeal),
      CareScheduleItemKind.weight => (Icons.monitor_weight_outlined, CreaturelyColors.information),
    };
    final dose = item.source is DoseLedgerEntry ? item.source as DoseLedgerEntry : null;
    final actionableDose =
        dose != null && (dose.status == DoseStatus.unrecorded || dose.status == DoseStatus.missed);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(11),
                child: Icon(icon, color: color),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_title(context), style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat.jm().format(item.dueAt.toLocal()),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if (_detail(context).isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      _detail(context),
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ],
                  if (dose != null && !actionableDose) ...[
                    const SizedBox(height: 5),
                    Text(
                      _statusLabel(dose.status),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                  if (actionableDose) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilledButton.tonalIcon(
                          onPressed: () => onDose(dose, DoseStatus.given),
                          icon: const Icon(Icons.check_rounded),
                          label: Text(AppLocalizations.of(context).given),
                        ),
                        OutlinedButton(
                          onPressed: () => onDose(dose, DoseStatus.skipped),
                          child: Text(AppLocalizations.of(context).skip),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (item.kind != CareScheduleItemKind.medication)
              IconButton(
                tooltip: item.kind == CareScheduleItemKind.respiratory
                    ? AppLocalizations.of(context).startBreathingCheck
                    : AppLocalizations.of(context).recordWeight,
                onPressed: () => onOpen(item),
                icon: Icon(
                  item.kind == CareScheduleItemKind.respiratory
                      ? Icons.play_arrow_rounded
                      : Icons.add_rounded,
                ),
              ),
          ],
        ),
      ),
    );
  }

  static String _statusLabel(DoseStatus status) => switch (status) {
    DoseStatus.given => appStrings.given,
    DoseStatus.skipped => appStrings.skipped,
    DoseStatus.missed => appStrings.missed,
    DoseStatus.unrecorded => appStrings.notRecorded,
  };
}

class _RespiratoryScheduleCard extends StatelessWidget {
  const _RespiratoryScheduleCard({
    required this.reminder,
    required this.onEdit,
    required this.onToggle,
    required this.onDelete,
  });

  final RespiratoryReminder reminder;
  final VoidCallback onEdit;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final times = reminder.times
        .map(
          (time) =>
              MaterialLocalizations.of(context)
                  .formatTimeOfDay(TimeOfDay(hour: time.hour, minute: time.minute)),
        )
        .join(', ');
    final repeat = reminder.recurrence == ReminderRecurrence.daily
        ? AppLocalizations.of(context).everyDay
        : _weekdayLabel(reminder.weekdays);
    final contextLabel = reminder.context == RespiratoryContext.sleeping
        ? AppLocalizations.of(context).sleeping
        : AppLocalizations.of(context).resting;
    return Card(
      child: Column(
        children: [
          ListTile(
            minTileHeight: 76,
            leading: const Icon(Icons.air_rounded),
            title: Text(AppLocalizations.of(context).breathingCheck(contextLabel)),
            subtitle: Text('$repeat • $times'),
            trailing: PopupMenuButton<String>(
              tooltip: AppLocalizations.of(context).breathingReminderOptions,
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit();
                } else if (value == 'delete') {
                  onDelete();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(value: 'edit', child: Text(AppLocalizations.of(context).edit)),
                PopupMenuItem(value: 'delete', child: Text(AppLocalizations.of(context).delete2)),
              ],
            ),
            onTap: onEdit,
          ),
          const Divider(height: 1),
          SwitchListTile(
            value: reminder.enabled,
            onChanged: onToggle,
            title: Text(
              reminder.enabled
                  ? AppLocalizations.of(context).active
                  : AppLocalizations.of(context).paused,
            ),
            secondary: Icon(
              reminder.enabled
                  ? Icons.notifications_active_outlined
                  : Icons.notifications_paused_outlined,
            ),
          ),
        ],
      ),
    );
  }

  static String _weekdayLabel(Set<int> days) {
    final labels = <String>[
      appStrings.mon,
      appStrings.tue,
      appStrings.wed,
      appStrings.thu,
      appStrings.fri,
      appStrings.sat,
      appStrings.sun,
    ];
    final sorted = days.toList()..sort();
    return sorted.map((day) => labels[day - 1]).join(', ');
  }
}

class _WeightScheduleCard extends StatelessWidget {
  const _WeightScheduleCard({
    required this.reminder,
    required this.onEdit,
    required this.onToggle,
    required this.onDelete,
  });

  final WeightCheckReminder reminder;
  final VoidCallback onEdit;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final times = reminder.times
        .map(
          (time) =>
              MaterialLocalizations.of(context)
                  .formatTimeOfDay(TimeOfDay(hour: time.hour, minute: time.minute)),
        )
        .join(', ');
    final repeat = reminder.recurrence == ReminderRecurrence.daily
        ? AppLocalizations.of(context).everyDay
        : _RespiratoryScheduleCard._weekdayLabel(reminder.weekdays);
    return Card(
      child: Column(
        children: [
          ListTile(
            minTileHeight: 76,
            leading: const Icon(Icons.monitor_weight_outlined),
            title: Text(AppLocalizations.of(context).weightCheck),
            subtitle: Text('$repeat • $times'),
            trailing: PopupMenuButton<String>(
              tooltip: AppLocalizations.of(context).weightReminderOptions,
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit();
                } else if (value == 'delete') {
                  onDelete();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(value: 'edit', child: Text(AppLocalizations.of(context).edit)),
                PopupMenuItem(value: 'delete', child: Text(AppLocalizations.of(context).delete2)),
              ],
            ),
            onTap: onEdit,
          ),
          const Divider(height: 1),
          SwitchListTile(
            value: reminder.enabled,
            onChanged: onToggle,
            title: Text(
              reminder.enabled
                  ? AppLocalizations.of(context).active
                  : AppLocalizations.of(context).paused,
            ),
            secondary: Icon(
              reminder.enabled
                  ? Icons.notifications_active_outlined
                  : Icons.notifications_paused_outlined,
            ),
          ),
        ],
      ),
    );
  }
}

class _MedicationScheduleCard extends StatelessWidget {
  const _MedicationScheduleCard({
    required this.medication,
    required this.schedules,
    required this.onTap,
  });

  final Medication medication;
  final List<MedicationSchedule> schedules;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      minTileHeight: 76,
      leading: const Icon(Icons.medication_outlined),
      title: Text(medication.name),
      subtitle: Text(
        schedules.isEmpty
            ? AppLocalizations.of(context).noActiveTimes
            : schedules.map((schedule) => _summary(context, schedule)).join('\n'),
      ),
      isThreeLine: schedules.length > 1,
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    ),
  );

  static String _summary(BuildContext context, MedicationSchedule schedule) {
    final times = schedule.times
        .map(
          (time) =>
              MaterialLocalizations.of(context)
                  .formatTimeOfDay(TimeOfDay(hour: time.hour, minute: time.minute)),
        )
        .join(', ');
    return switch (schedule.kind) {
      ScheduleKind.daily => AppLocalizations.of(context).daily(times),
      ScheduleKind.selectedWeekdays => AppLocalizations.of(context).selectedDays(times),
      ScheduleKind.interval => AppLocalizations.of(
        context,
      ).everyHoursStarts(schedule.intervalHours.toString(), times),
    };
  }
}
