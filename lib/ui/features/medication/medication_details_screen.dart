import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../domain/models.dart';
import '../../../domain/units.dart';
import '../../../l10n/app_strings.dart';
import '../../app_controller.dart';
import '../../core/commands.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';

class MedicationDetailsScreen extends ConsumerWidget {
  const MedicationDetailsScreen({required this.medicationId, required this.animalId, super.key});

  final String medicationId;
  final String animalId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(
      journalViewProvider((feature: JournalFeature.medication, animalId: animalId)),
    );
    if (state.loading || state.error != null) {
      return QueryPane(error: state.error, onRetry: () => state.retry(ref));
    }
    final l10n = AppLocalizations.of(context);
    final medication = state.medications
        .where((value) => value.id == medicationId && value.animalId == animalId)
        .firstOrNull;
    final animal = state.animals.where((value) => value.id == animalId).firstOrNull;
    if (medication == null || animal == null) {
      return Scaffold(
        body: EmptyState(
          icon: Icons.medication_outlined,
          title: AppLocalizations.of(context).medicationNotFound,
          body: AppLocalizations.of(context).thisMedicationMayHaveBeenRemovedFromTheJournal,
        ),
      );
    }

    final schedules = state.medicationSchedules
        .where((value) => value.medicationId == medication.id)
        .toList(growable: false);
    final doses =
        state.doseLedger
            .where((value) => value.medicationId == medication.id)
            .toList(growable: false)
          ..sort((left, right) => right.dueAt.compareTo(left.dueAt));
    final now = ref.read(wallClockProvider)().toUtc();
    final upcoming =
        doses
            .where((value) => value.status == DoseStatus.unrecorded && value.dueAt.isAfter(now))
            .toList(growable: false)
          ..sort((left, right) => left.dueAt.compareTo(right.dueAt));
    final outcomes = doses
        .where((value) => value.status != DoseStatus.unrecorded)
        .toList(growable: false);
    final recentStart = now.subtract(const Duration(days: 30));
    final recent = outcomes.where((value) => !value.dueAt.isBefore(recentStart)).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).medications),
        actions: [
          IconButton(
            tooltip: AppLocalizations.of(context).edit2(medication.name),
            onPressed: () =>
                context.push('/medication/${medication.id}/edit/${medication.animalId}'),
            icon: const Icon(Icons.edit_outlined),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ConstrainedPage(
        maxWidth: 760,
        child: ListView(
          key: const ValueKey('medication_details'),
          children: [
            PageHeading(
              title: medication.name,
              subtitle:
                  '${formatDisplayNumber(medication.doseAmount)} ${medication.doseUnit} • ${medication.form}',
              action: _StatusPill(active: medication.active),
            ),
            const SizedBox(height: 16),
            Card(
              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.62),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.76),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(Icons.medication_outlined, size: 28),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).directions,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            medication.instructions,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            SectionHeading(AppLocalizations.of(context).nextDose),
            if (!medication.active)
              CalmNotice(
                icon: Icons.pause_circle_outline_rounded,
                text: AppLocalizations.of(context)
                    .thisMedicationIsInactiveItsPastDoseHistoryRemains,
              )
            else if (upcoming.isEmpty)
              Card(
                child: ListTile(
                  minTileHeight: 72,
                  leading: const Icon(Icons.event_available_outlined),
                  title: Text(AppLocalizations.of(context).noUpcomingDose),
                  subtitle: Text(AppLocalizations.of(context).reviewTheSavedScheduleOrAddADoseTime),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () =>
                      context.push('/medication/${medication.id}/edit/${medication.animalId}'),
                ),
              )
            else
              _NextDoseCard(
                dose: upcoming.first,
                onGiven: () => runUiCommand(
                  context,
                  () => ref
                      .read(careControllerProvider.notifier)
                      .recordDose(upcoming.first.id, DoseStatus.given),
                ),
                onSkipped: () => runUiCommand(
                  context,
                  () => ref
                      .read(careControllerProvider.notifier)
                      .recordDose(upcoming.first.id, DoseStatus.skipped),
                ),
              ),
            const SizedBox(height: 18),
            SectionHeading(
              AppLocalizations.of(context).schedule,
              trailing: TextButton(
                onPressed: () =>
                    context.push('/medication/${medication.id}/edit/${medication.animalId}'),
                child: Text(AppLocalizations.of(context).edit),
              ),
            ),
            Card(
              child: schedules.isEmpty
                  ? ListTile(
                      minTileHeight: 72,
                      leading: const Icon(Icons.event_busy_outlined),
                      title: Text(AppLocalizations.of(context).noSavedDoseTimes),
                    )
                  : Column(
                      children: [
                        for (var index = 0; index < schedules.length; index++) ...[
                          ListTile(
                            minTileHeight: 68,
                            leading: Icon(
                              schedules[index].enabled
                                  ? Icons.notifications_active_outlined
                                  : Icons.notifications_paused_outlined,
                            ),
                            title: Text(_scheduleSummary(context, schedules[index])),
                            subtitle: Text(
                              schedules[index].enabled
                                  ? AppLocalizations.of(context).remindersActive
                                  : AppLocalizations.of(context).remindersPaused,
                            ),
                          ),
                          if (index < schedules.length - 1) const Divider(height: 1),
                        ],
                      ],
                    ),
            ),
            if (_hasPrescriptionDetails(medication)) ...[
              const SizedBox(height: 18),
              SectionHeading(l10n.medicationPrescriptionDetails),
              _MedicationPrescriptionDetails(medication: medication, l10n: l10n),
            ],
            const SizedBox(height: 18),
            SectionHeading(AppLocalizations.of(context).last30Days),
            _DoseSummary(doses: recent),
            const SizedBox(height: 18),
            SectionHeading(AppLocalizations.of(context).doseHistory),
            if (outcomes.isEmpty)
              Card(
                child: ListTile(
                  minTileHeight: 76,
                  leading: const Icon(Icons.history_rounded),
                  title: Text(AppLocalizations.of(context).noCompletedDosesYet),
                  subtitle: Text(
                    AppLocalizations.of(context).givenSkippedAndMissedDosesWillAppearHere,
                  ),
                ),
              )
            else
              Card(
                child: Column(
                  children: [
                    for (var index = 0; index < outcomes.take(20).length; index++) ...[
                      _DoseHistoryTile(dose: outcomes[index]),
                      if (index < outcomes.take(20).length - 1) const Divider(height: 1),
                    ],
                  ],
                ),
              ),
            if (medication.notes != null) ...[
              const SizedBox(height: 18),
              SectionHeading(AppLocalizations.of(context).notes),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Text(medication.notes!, style: Theme.of(context).textTheme.bodyLarge),
                ),
              ),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  static String _scheduleSummary(BuildContext context, MedicationSchedule schedule) {
    final times = schedule.times
        .map(
          (time) =>
              MaterialLocalizations.of(context)
                  .formatTimeOfDay(TimeOfDay(hour: time.hour, minute: time.minute)),
        )
        .join(', ');
    return switch (schedule.kind) {
      ScheduleKind.daily => AppLocalizations.of(context).daily(times),
      ScheduleKind.selectedWeekdays => '${_weekdaySummary(schedule.weekdays)} • $times',
      ScheduleKind.interval => AppLocalizations.of(
        context,
      ).everyHoursStarts(schedule.intervalHours.toString(), times),
    };
  }

  static String _weekdaySummary(Set<int> weekdays) {
    final labels = <int, String>{
      DateTime.monday: appStrings.mon,
      DateTime.tuesday: appStrings.tue,
      DateTime.wednesday: appStrings.wed,
      DateTime.thursday: appStrings.thu,
      DateTime.friday: appStrings.fri,
      DateTime.saturday: appStrings.sat,
      DateTime.sunday: appStrings.sun,
    };
    final values = weekdays.toList()..sort();
    return values.map((value) => labels[value]).whereType<String>().join(', ');
  }

  static bool _hasPrescriptionDetails(Medication medication) =>
      medication.strength != null ||
      medication.prescriber != null ||
      medication.pharmacy != null ||
      medication.prescriptionNumber != null ||
      medication.refillsRemaining != null ||
      medication.nextRefillDate != null;
}

class _MedicationPrescriptionDetails extends StatelessWidget {
  const _MedicationPrescriptionDetails({required this.medication, required this.l10n});

  final Medication medication;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final details = <({IconData icon, String label, String value})>[
      if (medication.strength != null)
        (
          icon: Icons.science_outlined,
          label: l10n.medicationStrengthLabel,
          value: medication.strength!,
        ),
      if (medication.prescriber != null)
        (
          icon: Icons.medical_services_outlined,
          label: l10n.medicationPrescriberLabel,
          value: medication.prescriber!,
        ),
      if (medication.pharmacy != null)
        (
          icon: Icons.local_pharmacy_outlined,
          label: l10n.medicationPharmacyLabel,
          value: medication.pharmacy!,
        ),
      if (medication.prescriptionNumber != null)
        (
          icon: Icons.receipt_long_outlined,
          label: l10n.medicationPrescriptionNumberLabel,
          value: medication.prescriptionNumber!,
        ),
      if (medication.refillsRemaining != null)
        (
          icon: Icons.repeat_rounded,
          label: l10n.medicationRefillsRemainingLabel,
          value: medication.refillsRemaining!.toString(),
        ),
      if (medication.nextRefillDate != null)
        (
          icon: Icons.event_repeat_outlined,
          label: l10n.medicationNextRefillDateLabel,
          value: MaterialLocalizations.of(context).formatMediumDate(medication.nextRefillDate!),
        ),
    ];
    return Card(
      key: const ValueKey('medication_prescription_details'),
      child: Column(
        children: [
          for (var index = 0; index < details.length; index++) ...[
            ListTile(
              minTileHeight: 68,
              leading: Icon(details[index].icon),
              title: Text(details[index].label),
              subtitle: Text(details[index].value),
            ),
            if (index < details.length - 1) const Divider(height: 1),
          ],
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) => Chip(
    avatar: Icon(active ? Icons.check_circle_outline_rounded : Icons.pause_circle_outline_rounded),
    label: Text(
      active ? AppLocalizations.of(context).active : AppLocalizations.of(context).inactive,
    ),
    backgroundColor: active
        ? Theme.of(context).colorScheme.primaryContainer
        : Theme.of(context).colorScheme.surfaceContainerHighest,
  );
}

class _NextDoseCard extends StatelessWidget {
  const _NextDoseCard({required this.dose, required this.onGiven, required this.onSkipped});

  final DoseLedgerEntry dose;
  final VoidCallback onGiven;
  final VoidCallback onSkipped;

  @override
  Widget build(BuildContext context) => Card(
    key: const ValueKey('medication_next_dose'),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.schedule_rounded),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat.EEEE().add_MMMd().format(dose.dueAt.toLocal()),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      DateFormat.jm().format(dose.dueAt.toLocal()),
                      style: Theme.of(context).textTheme.bodyLarge
                          ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FilledButton.tonalIcon(
                key: const ValueKey('record_next_dose_given'),
                onPressed: onGiven,
                icon: const Icon(Icons.check_rounded),
                label: Text(AppLocalizations.of(context).markGiven),
              ),
              OutlinedButton.icon(
                key: const ValueKey('record_next_dose_skipped'),
                onPressed: onSkipped,
                icon: const Icon(Icons.fast_forward_rounded),
                label: Text(AppLocalizations.of(context).skipDose),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _DoseSummary extends StatelessWidget {
  const _DoseSummary({required this.doses});

  final List<DoseLedgerEntry> doses;

  @override
  Widget build(BuildContext context) {
    final metrics = <({String label, int count, IconData icon, Color color})>[
      (
        label: AppLocalizations.of(context).given,
        count: doses.where((value) => value.status == DoseStatus.given).length,
        icon: Icons.check_circle_outline_rounded,
        color: CreaturelyColors.success,
      ),
      (
        label: AppLocalizations.of(context).skipped,
        count: doses.where((value) => value.status == DoseStatus.skipped).length,
        icon: Icons.fast_forward_rounded,
        color: CreaturelyColors.warning,
      ),
      (
        label: AppLocalizations.of(context).missed,
        count: doses.where((value) => value.status == DoseStatus.missed).length,
        icon: Icons.event_busy_outlined,
        color: Theme.of(context).colorScheme.error,
      ),
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 360 ? 3 : 1;
            const gap = 10.0;
            final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final metric in metrics)
                  SizedBox(
                    width: width,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: metric.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(metric.icon, color: metric.color, size: 21),
                            const SizedBox(height: 8),
                            Text(
                              '${metric.count}',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            Text(metric.label, style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DoseHistoryTile extends StatelessWidget {
  const _DoseHistoryTile({required this.dose});

  final DoseLedgerEntry dose;

  @override
  Widget build(BuildContext context) {
    final (label, icon, color) = switch (dose.status) {
      DoseStatus.given => (
        AppLocalizations.of(context).given,
        Icons.check_circle_outline_rounded,
        CreaturelyColors.success,
      ),
      DoseStatus.skipped => (
        AppLocalizations.of(context).skipped,
        Icons.fast_forward_rounded,
        CreaturelyColors.warning,
      ),
      DoseStatus.missed => (
        AppLocalizations.of(context).missed,
        Icons.event_busy_outlined,
        Theme.of(context).colorScheme.error,
      ),
      DoseStatus.unrecorded => (
        AppLocalizations.of(context).pending,
        Icons.schedule_rounded,
        Theme.of(context).colorScheme.primary,
      ),
    };
    return ListTile(
      minTileHeight: 68,
      leading: Icon(icon, color: color),
      title: Text(label),
      subtitle: Text(
        '${DateFormat.yMMMd().add_jm().format(dose.dueAt.toLocal())}'
        '${dose.note == null ? '' : '\n${dose.note}'}',
      ),
      isThreeLine: dose.note != null,
    );
  }
}
