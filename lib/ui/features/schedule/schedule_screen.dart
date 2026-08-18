import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../domain/care_schedule.dart';
import '../../../domain/models.dart';
import '../../app_controller.dart';
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
    final state = ref.watch(appControllerProvider);
    final animal = state.selectedAnimal;
    final compact = usesCompactVerticalLayout(context);
    if (animal == null) {
      return Scaffold(
        appBar: AppBar(actions: const [SettingsAction()]),
        body: const EmptyState(
          icon: Icons.calendar_month_outlined,
          title: 'No animal selected',
          body: 'Add an animal to create a care schedule.',
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: compact ? 48 : null,
        title: const AnimalPicker(),
        actions: [
          PopupMenuButton<_AddCare>(
            tooltip: 'Add scheduled care',
            icon: const Icon(Icons.add_rounded),
            onSelected: (value) => _add(value, animal.id),
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: _AddCare.breathing,
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.air_rounded),
                  title: Text('Breathing reminder'),
                ),
              ),
              PopupMenuItem(
                value: _AddCare.medication,
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.medication_outlined),
                  title: Text('Medication'),
                ),
              ),
              PopupMenuItem(
                value: _AddCare.weight,
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.monitor_weight_outlined),
                  title: Text('Weight check reminder'),
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
              title: '${animal.name}’s schedule',
              subtitle: 'Medication, breathing checks, and weight checks.',
            ),
            SizedBox(height: compact ? 8 : 16),
            SegmentedButton<_ScheduleView>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(
                  value: _ScheduleView.today,
                  icon: Icon(Icons.today_outlined),
                  label: Text('Today'),
                ),
                ButtonSegment(
                  value: _ScheduleView.sevenDays,
                  icon: Icon(Icons.date_range_outlined),
                  label: Text('7 days'),
                ),
                ButtonSegment(
                  value: _ScheduleView.schedules,
                  icon: Icon(Icons.repeat_rounded),
                  label: Text('Schedules'),
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
            if (!state.snapshot.settings.notificationsAllowed) ...[
              const CalmNotice(
                icon: Icons.notifications_off_outlined,
                text: 'Notifications are off. Your care schedule still works here in Creaturely.',
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

  Widget _occurrences(CreaturelyState state, Animal animal) {
    final now = DateTime.now();
    final startLocal = DateTime(now.year, now.month, now.day);
    final endLocal = _view == _ScheduleView.today
        ? DateTime(now.year, now.month, now.day + 1)
        : DateTime(now.year, now.month, now.day + 7);
    final items = _builder.build(
      snapshot: state.snapshot,
      rangeStartUtc: startLocal.toUtc(),
      rangeEndUtc: endLocal.toUtc(),
      animalId: animal.id,
    );
    if (items.isEmpty) {
      return EmptyState(
        icon: Icons.event_available_outlined,
        title: _view == _ScheduleView.today
            ? 'Nothing scheduled today'
            : 'Nothing scheduled in the next 7 days',
        body: 'Use Add to create a breathing reminder, medication, or weight check.',
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
      children.add(_OccurrenceCard(item: item, onDose: _recordDose, onOpen: _openItem));
      children.add(const SizedBox(height: 10));
    }
    return ListView(controller: _scrollController, children: children);
  }

  Widget _savedSchedules(CreaturelyState state, Animal animal) {
    final reminders = state.snapshot.respiratoryReminders
        .where((value) => value.animalId == animal.id)
        .toList(growable: false);
    final medications = state.snapshot.medications
        .where((value) => value.animalId == animal.id && value.active)
        .toList(growable: false);
    final weightReminders = state.snapshot.weightReminders
        .where((value) => value.animalId == animal.id)
        .toList(growable: false);
    if (reminders.isEmpty && medications.isEmpty && weightReminders.isEmpty) {
      return const EmptyState(
        icon: Icons.event_repeat_outlined,
        title: 'No saved schedules',
        body: 'Use Add to create a breathing reminder, medication, or weight check.',
      );
    }
    return ListView(
      controller: _scrollController,
      children: [
        if (reminders.isNotEmpty) ...[
          const SectionHeading('Breathing reminders'),
          for (final reminder in reminders) ...[
            _RespiratoryScheduleCard(
              reminder: reminder,
              onEdit: () =>
                  context.push('/breathing-reminder/${reminder.id}/edit/${reminder.animalId}'),
              onToggle: (enabled) => ref
                  .read(appControllerProvider.notifier)
                  .saveRespiratoryReminder(
                    reminder.copyWith(updatedAt: DateTime.now().toUtc(), enabled: enabled),
                  ),
              onDelete: () => _deleteReminder(reminder),
            ),
            const SizedBox(height: 10),
          ],
        ],
        if (medications.isNotEmpty) ...[
          const SectionHeading('Medication schedules'),
          for (final medication in medications) ...[
            _MedicationScheduleCard(
              medication: medication,
              schedules: state.snapshot.medicationSchedules
                  .where((value) => value.medicationId == medication.id)
                  .toList(growable: false),
              onTap: () => context.push('/medication/${medication.id}/${medication.animalId}'),
            ),
            const SizedBox(height: 10),
          ],
        ],
        if (weightReminders.isNotEmpty) ...[
          const SectionHeading('Weight check reminders'),
          for (final reminder in weightReminders) ...[
            _WeightScheduleCard(
              reminder: reminder,
              onEdit: () =>
                  context.push('/weight-reminder/${reminder.id}/edit/${reminder.animalId}'),
              onToggle: (enabled) => ref
                  .read(appControllerProvider.notifier)
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

  Future<void> _recordDose(DoseLedgerEntry dose, DoseStatus status) =>
      ref.read(appControllerProvider.notifier).recordDose(dose.id, status);

  void _openItem(CareScheduleItem item) {
    switch (item.source) {
      case RespiratoryReminderOccurrence(:final reminder):
        ref.read(appControllerProvider.notifier).selectAnimal(reminder.animalId);
        context.push('/record/breaths/${reminder.animalId}?context=${reminder.context.name}');
        break;
      case WeightReminderOccurrence(:final reminder):
        ref.read(appControllerProvider.notifier).selectAnimal(reminder.animalId);
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
            title: const Text('Delete breathing reminder?'),
            content: const Text(
              'This removes future prompts. Saved breathing measurements are unchanged.',
            ),
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
      await ref
          .read(appControllerProvider.notifier)
          .deleteRecord('respiratory_reminders', reminder.id);
    }
  }

  Future<void> _deleteWeightReminder(WeightCheckReminder reminder) async {
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete weight check reminder?'),
            content: const Text(
              'This removes future prompts. Saved weight measurements are unchanged.',
            ),
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
      await ref.read(appControllerProvider.notifier).deleteRecord('weight_reminders', reminder.id);
    }
  }

  String _dayLabel(DateTime day) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (day == today) {
      return 'Today';
    }
    if (day == today.add(const Duration(days: 1))) {
      return 'Tomorrow';
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
                  Text(item.title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat.jm().format(item.dueAt.toLocal()),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if (item.detail.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.detail,
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
                          label: const Text('Given'),
                        ),
                        OutlinedButton(
                          onPressed: () => onDose(dose, DoseStatus.skipped),
                          child: const Text('Skip'),
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
                    ? 'Start breathing check'
                    : 'Record weight',
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
    DoseStatus.given => 'Given',
    DoseStatus.skipped => 'Skipped',
    DoseStatus.missed => 'Missed',
    DoseStatus.unrecorded => 'Not recorded',
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
        ? 'Every day'
        : _weekdayLabel(reminder.weekdays);
    final contextLabel = reminder.context == RespiratoryContext.sleeping ? 'Sleeping' : 'Resting';
    return Card(
      child: Column(
        children: [
          ListTile(
            minTileHeight: 76,
            leading: const Icon(Icons.air_rounded),
            title: Text('$contextLabel breathing check'),
            subtitle: Text('$repeat • $times'),
            trailing: PopupMenuButton<String>(
              tooltip: 'Breathing reminder options',
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit();
                } else if (value == 'delete') {
                  onDelete();
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
            onTap: onEdit,
          ),
          const Divider(height: 1),
          SwitchListTile(
            value: reminder.enabled,
            onChanged: onToggle,
            title: Text(reminder.enabled ? 'Active' : 'Paused'),
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
    const labels = <String>['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
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
        ? 'Every day'
        : _RespiratoryScheduleCard._weekdayLabel(reminder.weekdays);
    return Card(
      child: Column(
        children: [
          ListTile(
            minTileHeight: 76,
            leading: const Icon(Icons.monitor_weight_outlined),
            title: const Text('Weight check'),
            subtitle: Text('$repeat • $times'),
            trailing: PopupMenuButton<String>(
              tooltip: 'Weight reminder options',
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit();
                } else if (value == 'delete') {
                  onDelete();
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
            onTap: onEdit,
          ),
          const Divider(height: 1),
          SwitchListTile(
            value: reminder.enabled,
            onChanged: onToggle,
            title: Text(reminder.enabled ? 'Active' : 'Paused'),
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
            ? 'No active times'
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
      ScheduleKind.daily => 'Daily • $times',
      ScheduleKind.selectedWeekdays => 'Selected days • $times',
      ScheduleKind.interval => 'Every ${schedule.intervalHours} hours • starts $times',
    };
  }
}
