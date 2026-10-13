import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../data/document_storage.dart';
import '../../../domain/models.dart';
import '../../../domain/timeline.dart';
import '../../../domain/units.dart';
import '../../../l10n/app_strings.dart';
import '../../../l10n/model_labels.dart';
import '../../app_controller.dart';
import '../../core/commands.dart';
import '../../core/theme.dart';
import '../../core/timeline_projection.dart';
import '../../core/widgets.dart';
import '../../navigation/top_level_scroll.dart';

class TimelineScreen extends ConsumerStatefulWidget {
  const TimelineScreen({this.initialFilter, super.key});

  final String? initialFilter;

  @override
  ConsumerState<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends ConsumerState<TimelineScreen> {
  static const MedicationTimelineProjection _medicationProjection = MedicationTimelineProjection();
  final Set<String> _filters = <String>{};
  final ScrollController _scrollController = ScrollController();
  late final TopLevelScrollCoordinator _scrollCoordinator;
  late final ScrollToTopCallback _scrollToTop;
  DateTimeRange? _range;

  @override
  void initState() {
    super.initState();
    if (widget.initialFilter != null) {
      _filters.add(widget.initialFilter!);
    }
    _scrollCoordinator = ref.read(topLevelScrollCoordinatorProvider);
    _scrollToTop = () => animateTopLevelScrollToStart(context, _scrollController);
    _scrollCoordinator.register(TopLevelDestination.timeline, _scrollToTop);
  }

  @override
  void didUpdateWidget(covariant TimelineScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialFilter != oldWidget.initialFilter) {
      _filters.clear();
      if (widget.initialFilter != null) {
        _filters.add(widget.initialFilter!);
      }
    }
  }

  @override
  void dispose() {
    _scrollCoordinator.unregister(TopLevelDestination.timeline, _scrollToTop);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      journalViewProvider((feature: JournalFeature.timeline, animalId: null)),
    );
    if (state.loading || state.error != null) {
      return QueryPane(error: state.error, onRetry: () => state.retry(ref));
    }
    final animal = state.selectedAnimal;
    if (animal == null) {
      return Scaffold(
        body: EmptyState(
          icon: Icons.timeline_rounded,
          title: AppLocalizations.of(context).noAnimalSelected,
          body: AppLocalizations.of(context).addAnAnimalToBeginATimeline,
        ),
      );
    }
    final effectiveKinds = <String>{
      for (final filter in _filters)
        ...switch (filter) {
          'medication' => <String>{'medication', 'dose'},
          'health' => <String>{'weight', 'allergy', 'condition', 'observation'},
          _ => <String>{filter},
        },
    };
    final now = ref.read(wallClockProvider)().toUtc();
    final allItems = TimelineProjection(AppLocalizations.of(context)).timeline(
      ref.read(journalViewProvider((feature: JournalFeature.timeline, animalId: null))),
      animalId: animal.id,
      kinds: effectiveKinds,
      start: _range?.start,
      end: _range == null
          ? null
          : DateTime(_range!.end.year, _range!.end.month, _range!.end.day, 23, 59, 59, 999),
    );
    final items = allItems
        .where(
          (item) =>
              item.source is! DoseLedgerEntry ||
              _medicationProjection.belongsInHistory(item.source as DoseLedgerEntry, now: now),
        )
        .toList(growable: false);
    final compact = usesCompactVerticalLayout(context);
    final documentsOnly = _filters.length == 1 && _filters.contains('document');
    final leadingWidgets = <Widget>[
      PageHeading(
        title: AppLocalizations.of(context).sTimeline(animal.name),
        subtitle: _range == null
            ? AppLocalizations.of(context).everyCareMomentNewestFirst
            : '${DateFormat.yMMMd().format(_range!.start)} – '
                  '${DateFormat.yMMMd().format(_range!.end)}',
      ),
      SizedBox(height: compact ? 6 : 14),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _filterChip('breathing', AppLocalizations.of(context).breathing, Icons.air_rounded),
            const SizedBox(width: 8),
            _filterChip(
              'medication',
              AppLocalizations.of(context).medications,
              Icons.medication_outlined,
            ),
            const SizedBox(width: 8),
            _filterChip(
              'health',
              AppLocalizations.of(context).health,
              Icons.monitor_heart_outlined,
            ),
            const SizedBox(width: 8),
            _filterChip(
              'document',
              AppLocalizations.of(context).documents,
              Icons.description_outlined,
            ),
          ],
        ),
      ),
      SizedBox(height: compact ? 8 : 14),
    ];
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: compact ? 48 : null,
        title: const AnimalPicker(),
        actions: [
          if (documentsOnly)
            IconButton(
              tooltip: AppLocalizations.of(context).addDocument,
              onPressed: () => context.push('/document/new/${animal.id}'),
              icon: const Icon(Icons.add_rounded),
            ),
          IconButton(
            tooltip: AppLocalizations.of(context).chooseDateRange,
            onPressed: _pickRange,
            icon: Icon(_range == null ? Icons.date_range_outlined : Icons.event_available_rounded),
          ),
          if (_range != null)
            IconButton(
              tooltip: AppLocalizations.of(context).clearDateRange,
              onPressed: () => setState(() => _range = null),
              icon: const Icon(Icons.filter_alt_off_outlined),
            ),
          const SettingsAction(),
          const SizedBox(width: 4),
        ],
      ),
      body: ConstrainedPage(
        padding: EdgeInsets.fromLTRB(16, compact ? 4 : 8, 16, compact ? 12 : 20),
        child: ListView.builder(
          controller: _scrollController,
          key: const PageStorageKey<String>('timeline_list'),
          itemCount: leadingWidgets.length + (items.isEmpty ? 1 : items.length),
          itemBuilder: (context, index) {
            if (index < leadingWidgets.length) {
              return leadingWidgets[index];
            }
            if (items.isEmpty) {
              return EmptyState(
                icon: Icons.history_toggle_off_rounded,
                title: AppLocalizations.of(context).nothingRecordedHereYet,
                body: _filters.isEmpty && _range == null
                    ? AppLocalizations.of(context).useAQuickActionFromSDashboardToAdd(animal.name)
                    : AppLocalizations.of(context).tryClearingAFilterOrChoosingAWiderDate,
              );
            }
            final item = items[index - leadingWidgets.length];
            return _TimelineTile(
              key: ValueKey('timeline_${item.kind}_${item.id}'),
              item: item,
              onOpen: item.source is RespiratorySession
                  ? () => _showRespiratoryDetails(item)
                  : null,
              onEdit: () => runUiCommand(context, () => _edit(item)),
              onDelete: () => runUiCommand(context, () => _delete(item)),
              onDose: (status) => runUiCommand(
                context,
                () => ref.read(careControllerProvider.notifier).recordDose(item.id, status),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _filterChip(String value, String label, IconData icon) => FilterChip(
    selected: _filters.contains(value),
    avatar: Icon(icon, size: 18),
    label: Text(label),
    onSelected: (selected) =>
        setState(() => selected ? _filters.add(value) : _filters.remove(value)),
  );

  Future<void> _showRespiratoryDetails(TimelineItem item) async {
    final session = item.source;
    if (session is! RespiratorySession) {
      return;
    }
    final edit = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => _RespiratoryDetailsSheet(session: session),
    );
    if (edit == true && mounted) {
      await runUiCommand(context, () => _edit(item));
    }
  }

  Future<void> _pickRange() async {
    final value = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _range,
    );
    if (value != null && mounted) {
      setState(() => _range = value);
    }
  }

  Future<void> _edit(TimelineItem item) async {
    final source = item.source;
    switch (source) {
      case RespiratorySession():
        final note = TextEditingController(text: source.note);
        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context).editBreathingNote),
            content: TextField(
              controller: note,
              minLines: 2,
              maxLines: 5,
              decoration: InputDecoration(labelText: AppLocalizations.of(context).note),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context).cancel),
              ),
              FilledButton(
                onPressed: () => runUiCommand(context, () async {
                  final updated = RespiratorySession(
                    id: source.id,
                    animalId: source.animalId,
                    createdAt: source.createdAt,
                    updatedAt: ref.read(wallClockProvider)().toUtc(),
                    recordedAt: source.recordedAt,
                    durationMilliseconds: source.durationMilliseconds,
                    breathCount: source.breathCount,
                    ratePerMinute: source.ratePerMinute,
                    context: source.context,
                    note: note.text.trim().isEmpty ? null : note.text.trim(),
                    thresholdSnapshot: source.thresholdSnapshot,
                  );
                  await ref.read(careControllerProvider.notifier).saveRespiratorySession(updated);
                  if (context.mounted) Navigator.pop(context);
                }),
                child: Text(AppLocalizations.of(context).save),
              ),
            ],
          ),
        );
        note.dispose();
      case Medication():
        await context.push('/medication/${source.id}/edit/${source.animalId}');
      case HealthRecord():
        await context.push('/health/${source.id}/edit/${source.animalId}');
      case CareDocument():
        await context.push('/document/${source.id}/edit/${source.animalId}');
      case DoseLedgerEntry():
        await _editDose(source);
      default:
        break;
    }
  }

  Future<void> _editDose(DoseLedgerEntry dose) async {
    final value = await showDialog<_DoseEditResult>(
      context: context,
      builder: (context) => _DoseEditDialog(dose: dose),
    );
    if (value == null || !mounted) {
      return;
    }
    if (value.status == DoseStatus.unrecorded) {
      await ref
          .read(careControllerProvider.notifier)
          .reopenDose(dose.id, note: value.note, clearNote: value.note == null);
    } else {
      await ref
          .read(careControllerProvider.notifier)
          .recordDose(
            dose.id,
            value.status,
            administeredAt: value.administeredAt?.toUtc(),
            note: value.note,
            clearNote: value.note == null,
          );
    }
  }

  Future<void> _delete(TimelineItem item) async {
    final source = item.source;
    final kind = switch (source) {
      RespiratorySession() => RecordKind.respiratorySession,
      Medication() => RecordKind.medication,
      HealthRecord() => RecordKind.healthRecord,
      CareDocument() => RecordKind.document,
      _ => null,
    };
    if (kind == null) {
      return;
    }
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context).delete3(item.title)),
            content: Text(
              source is Medication
                  ? AppLocalizations.of(context).thisAlsoRemovesFutureRemindersPastExportedCopiesAre
                  : AppLocalizations.of(context).thisRecordWillBeRemovedFromTheLocalJournal,
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
    if (confirmed && mounted) {
      await ref.read(careControllerProvider.notifier).deleteRecord(kind, item.id);
    }
  }
}

class _RespiratoryDetailsSheet extends StatelessWidget {
  const _RespiratoryDetailsSheet({required this.session});

  final RespiratorySession session;

  @override
  Widget build(BuildContext context) {
    final thresholds = session.thresholdSnapshot;
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24, 4, 24, 24 + MediaQuery.viewInsetsOf(context).bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppLocalizations.of(context).breathingSession,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 18),
            Text(
              AppLocalizations.of(context).breathsMin(formatRespiratoryRate(session.ratePerMinute)),
              style: Theme.of(context).textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            _DetailRow(
              label: AppLocalizations.of(context).recorded,
              value: DateFormat.yMMMd().add_jm().format(session.recordedAt.toLocal()),
            ),
            _DetailRow(
              label: AppLocalizations.of(context).context,
              value: AppLocalizations.of(context).respiratoryContext(session.context),
            ),
            _DetailRow(
              label: AppLocalizations.of(context).counted,
              value: AppLocalizations.of(context).breathsInSeconds(
                session.breathCount,
                (session.durationMilliseconds / 1000).toStringAsFixed(1),
              ),
            ),
            if (thresholds.isConfigured)
              _DetailRow(
                label: AppLocalizations.of(context).savedRange,
                value: [
                  if (thresholds.minimum != null)
                    AppLocalizations.of(context).min(thresholds.minimum.toString()),
                  if (thresholds.target != null)
                    AppLocalizations.of(context).target2(thresholds.target.toString()),
                  if (thresholds.maximum != null)
                    AppLocalizations.of(context).max(thresholds.maximum.toString()),
                ].join(' • '),
              ),
            const SizedBox(height: 18),
            Text(AppLocalizations.of(context).note, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Text(session.note ?? AppLocalizations.of(context).noNoteAdded),
              ),
            ),
            const SizedBox(height: 18),
            FilledButton.tonalIcon(
              key: const ValueKey('edit_breathing_note_from_details'),
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.edit_note_rounded),
              label: Text(AppLocalizations.of(context).editNote),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 92,
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge
                ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ),
        Expanded(child: Text(value)),
      ],
    ),
  );
}

typedef _DoseEditResult = ({DoseStatus status, DateTime? administeredAt, String? note});

class _DoseEditDialog extends StatefulWidget {
  const _DoseEditDialog({required this.dose});

  final DoseLedgerEntry dose;

  @override
  State<_DoseEditDialog> createState() => _DoseEditDialogState();
}

class _DoseEditDialogState extends State<_DoseEditDialog> {
  late DoseStatus _status;
  late DateTime _administeredAt;
  late final TextEditingController _note;

  @override
  void initState() {
    super.initState();
    _status = widget.dose.status;
    _administeredAt = widget.dose.administeredAt?.toLocal() ?? DateTime.now();
    _note = TextEditingController(text: widget.dose.note);
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(AppLocalizations.of(context).updateDose),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<DoseStatus>(
            initialValue: _status,
            decoration: InputDecoration(labelText: AppLocalizations.of(context).status),
            items: [
              DropdownMenuItem(
                value: DoseStatus.given,
                child: Text(AppLocalizations.of(context).given),
              ),
              DropdownMenuItem(
                value: DoseStatus.skipped,
                child: Text(AppLocalizations.of(context).skipped),
              ),
              DropdownMenuItem(
                value: DoseStatus.missed,
                child: Text(AppLocalizations.of(context).missed),
              ),
              DropdownMenuItem(
                value: DoseStatus.unrecorded,
                child: Text(AppLocalizations.of(context).notRecordedYet),
              ),
            ],
            onChanged: (value) {
              if (value != null && mounted) {
                setState(() => _status = value);
              }
            },
          ),
          if (_status == DoseStatus.given) ...[
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.schedule_rounded),
              title: Text(AppLocalizations.of(context).actuallyAdministered),
              subtitle: Text(DateFormat.yMMMd().add_jm().format(_administeredAt)),
              trailing: const Icon(Icons.edit_calendar_outlined),
              onTap: _pickAdministeredAt,
            ),
          ],
          const SizedBox(height: 12),
          TextField(
            controller: _note,
            minLines: 2,
            maxLines: 4,
            decoration: InputDecoration(labelText: AppLocalizations.of(context).doseNoteOptional),
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(AppLocalizations.of(context).cancel),
      ),
      FilledButton(
        key: const ValueKey('save_dose_edit'),
        onPressed: () => Navigator.pop(context, (
          status: _status,
          administeredAt: _status == DoseStatus.given ? _administeredAt : null,
          note: _note.text.trim().isEmpty ? null : _note.text.trim(),
        )),
        child: Text(AppLocalizations.of(context).save),
      ),
    ],
  );

  Future<void> _pickAdministeredAt() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      initialDate: _administeredAt,
    );
    if (date == null || !mounted) {
      return;
    }
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_administeredAt),
    );
    if (time != null) {
      setState(
        () => _administeredAt = DateTime(date.year, date.month, date.day, time.hour, time.minute),
      );
    }
  }
}

class _TimelineTile extends ConsumerWidget {
  const _TimelineTile({
    super.key,
    required this.item,
    required this.onOpen,
    required this.onEdit,
    required this.onDelete,
    required this.onDose,
  });

  final TimelineItem item;
  final VoidCallback? onOpen;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<DoseStatus> onDose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (icon, color) = switch (item.kind) {
      'breathing' => (Icons.air_rounded, CreaturelyColors.vitalTeal),
      'medication' || 'dose' => (Icons.medication_outlined, CreaturelyColors.success),
      'weight' => (Icons.monitor_weight_outlined, CreaturelyColors.information),
      'document' => (Icons.description_outlined, CreaturelyColors.warning),
      _ => (Icons.favorite_outline_rounded, CreaturelyColors.heartCoral),
    };
    final dose = item.source is DoseLedgerEntry ? item.source as DoseLedgerEntry : null;
    if (dose != null) {
      return _DoseHistoryTile(item: item, dose: dose, color: color, onEdit: onEdit, onDose: onDose);
    }
    final respiratory = item.source is RespiratorySession
        ? item.source as RespiratorySession
        : null;
    final document = item.source is CareDocument ? item.source as CareDocument : null;
    final formattedAt = document == null
        ? DateFormat.yMMMd().add_jm().format(item.at.toLocal())
        : DateFormat.yMMMd().format(item.at);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Semantics(
        container: true,
        button: onOpen != null,
        label:
            '${item.title}. ${item.detail}. $formattedAt'
            '${respiratory?.note == null ? '' : '. Note: ${respiratory!.note}'}',
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onOpen,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
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
                          item.detail,
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 5),
                        Text(formattedAt, style: Theme.of(context).textTheme.bodySmall),
                        if (respiratory?.note case final note?) ...[
                          const SizedBox(height: 9),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.notes_rounded, size: 17),
                                  const SizedBox(width: 7),
                                  Expanded(child: Text(note)),
                                ],
                              ),
                            ),
                          ),
                        ],
                        if (document != null)
                          FutureBuilder<AttachmentHealth>(
                            future: ref
                                .read(documentStorageProvider.future)
                                .then((storage) => storage.inspect(document)),
                            builder: (context, snapshot) {
                              final health = snapshot.data;
                              if (health == null || health == AttachmentHealth.available) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(top: 7),
                                child: Text(
                                  health == AttachmentHealth.missing
                                      ? AppLocalizations.of(context).storedFileMissing
                                      : AppLocalizations.of(context).storedFileChangedOrCorrupt,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    tooltip: AppLocalizations.of(context).entryActions,
                    onSelected: (value) => value == 'edit' ? onEdit() : onDelete(),
                    itemBuilder: (context) => [
                      PopupMenuItem(value: 'edit', child: Text(AppLocalizations.of(context).edit)),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text(AppLocalizations.of(context).delete2),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DoseHistoryTile extends StatelessWidget {
  const _DoseHistoryTile({
    required this.item,
    required this.dose,
    required this.color,
    required this.onEdit,
    required this.onDose,
  });

  final TimelineItem item;
  final DoseLedgerEntry dose;
  final Color color;
  final VoidCallback onEdit;
  final ValueChanged<DoseStatus> onDose;

  @override
  Widget build(BuildContext context) {
    final statusLabel = switch (dose.status) {
      DoseStatus.given => AppLocalizations.of(context).given,
      DoseStatus.skipped => AppLocalizations.of(context).skipped,
      DoseStatus.missed => AppLocalizations.of(context).missed,
      DoseStatus.unrecorded => AppLocalizations.of(context).pending,
    };
    final statusIcon = switch (dose.status) {
      DoseStatus.given => Icons.check_circle_outline_rounded,
      DoseStatus.skipped => Icons.fast_forward_rounded,
      DoseStatus.missed => Icons.event_busy_outlined,
      DoseStatus.unrecorded => Icons.schedule_rounded,
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        child: ListTile(
          contentPadding: const EdgeInsets.fromLTRB(14, 5, 6, 5),
          leading: DecoratedBox(
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(statusIcon, color: color),
            ),
          ),
          title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text(
            '$statusLabel • ${DateFormat.yMMMd().add_jm().format(dose.dueAt.toLocal())}'
            '${dose.note == null ? '' : '\n${dose.note}'}',
          ),
          isThreeLine: dose.note != null,
          trailing: dose.status == DoseStatus.unrecorded
              ? Wrap(
                  spacing: 2,
                  children: [
                    IconButton(
                      tooltip: AppLocalizations.of(context).markGiven,
                      onPressed: () => onDose(DoseStatus.given),
                      icon: const Icon(Icons.check_rounded),
                    ),
                    IconButton(
                      tooltip: AppLocalizations.of(context).skipDose,
                      onPressed: () => onDose(DoseStatus.skipped),
                      icon: const Icon(Icons.fast_forward_rounded),
                    ),
                  ],
                )
              : IconButton(
                  tooltip: AppLocalizations.of(context).editDose,
                  onPressed: onEdit,
                  icon: const Icon(Icons.more_vert_rounded),
                ),
          onTap: onEdit,
        ),
      ),
    );
  }
}
