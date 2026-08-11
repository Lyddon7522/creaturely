import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../domain/models.dart';
import '../../../domain/units.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../app_controller.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../../navigation/top_level_scroll.dart';

class AnimalsScreen extends ConsumerStatefulWidget {
  const AnimalsScreen({super.key});

  @override
  ConsumerState<AnimalsScreen> createState() => _AnimalsScreenState();
}

class _AnimalsScreenState extends ConsumerState<AnimalsScreen> {
  final ScrollController _scrollController = ScrollController();
  late final TopLevelScrollCoordinator _scrollCoordinator;
  late final ScrollToTopCallback _scrollToTop;

  @override
  void initState() {
    super.initState();
    _scrollCoordinator = ref.read(topLevelScrollCoordinatorProvider);
    _scrollToTop = () => animateTopLevelScrollToStart(context, _scrollController);
    _scrollCoordinator.register(TopLevelDestination.animals, _scrollToTop);
  }

  @override
  void dispose() {
    _scrollCoordinator.unregister(TopLevelDestination.animals, _scrollToTop);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appControllerProvider);
    final animals = state.activeAnimals;
    final archived = state.snapshot.animals
        .where((animal) => animal.archived)
        .toList(growable: false);
    if (animals.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: usesCompactVerticalLayout(context) ? 48 : null,
          title: const Text('Animals'),
          actions: [
            IconButton(
              tooltip: 'Add animal',
              onPressed: () => context.push('/animal/new'),
              icon: const Icon(Icons.add_rounded),
            ),
            const SettingsAction(),
          ],
        ),
        body: ConstrainedPage(
          child: ListView(
            controller: _scrollController,
            children: [
              EmptyState(
                icon: Icons.pets_outlined,
                title: archived.isEmpty
                    ? 'Make space for the animal you care for'
                    : 'No active animals',
                body: archived.isEmpty
                    ? 'Creaturely works for any species. Add an animal to begin a private health journal.'
                    : 'Archived journals remain safe below. Add an animal or reopen an archived profile.',
                action: FilledButton.icon(
                  onPressed: () => context.push('/animal/new'),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Add animal'),
                ),
              ),
              if (archived.isNotEmpty) _ArchivedAnimals(animals: archived),
            ],
          ),
        ),
      );
    }
    final selected = state.selectedAnimal ?? animals.first;
    final careOverview = _AnimalCareOverview.from(
      animal: selected,
      snapshot: state.snapshot,
      now: DateTime.now(),
    );
    final otherAnimals = animals
        .where((animal) => animal.id != selected.id)
        .toList(growable: false);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: usesCompactVerticalLayout(context) ? 48 : null,
        title: const AnimalPicker(),
        actions: [
          IconButton(
            tooltip: 'Add animal',
            onPressed: () => context.push('/animal/new'),
            icon: const Icon(Icons.add_rounded),
          ),
          const SettingsAction(),
          const SizedBox(width: 4),
        ],
      ),
      body: ConstrainedPage(
        child: CustomScrollView(
          controller: _scrollController,
          key: const PageStorageKey<String>('animals_home'),
          slivers: [
            SliverToBoxAdapter(child: _QuickActions(animal: selected)),
            const SliverToBoxAdapter(child: SizedBox(height: 18)),
            SliverToBoxAdapter(
              child: _AnimalHero(
                animal: selected,
                overview: careOverview,
                onEdit: () => context.push('/animal/${selected.id}/edit'),
                onExport: () => context.push('/animal/${selected.id}/export'),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 18)),
            SliverToBoxAdapter(
              child: _CareSummary(animal: selected, overview: careOverview),
            ),
            if (otherAnimals.isNotEmpty) ...[
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              SliverToBoxAdapter(
                child: _OtherAnimals(
                  animals: otherAnimals,
                  onSelect: (animal) {
                    ref.read(appControllerProvider.notifier).selectAnimal(animal.id);
                    animateTopLevelScrollToStart(context, _scrollController);
                  },
                  onAdd: () => context.push('/animal/new'),
                ),
              ),
            ],
            if (archived.isNotEmpty) ...[
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              SliverToBoxAdapter(child: _ArchivedAnimals(animals: archived)),
            ],
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}

class _AnimalCareOverview {
  const _AnimalCareOverview({
    required this.latestBreathing,
    required this.activeMedicationCount,
    required this.dosesDueSoon,
    required this.weightUnit,
  });

  factory _AnimalCareOverview.from({
    required Animal animal,
    required CreaturelySnapshot snapshot,
    required DateTime now,
  }) {
    final sessions =
        snapshot.respiratorySessions
            .where((session) => session.animalId == animal.id)
            .toList(growable: false)
          ..sort((first, second) => second.recordedAt.compareTo(first.recordedAt));
    final activeMedicationCount = snapshot.medications
        .where((medication) => medication.animalId == animal.id && medication.active)
        .length;
    final dosesDueSoon = snapshot.doseLedger
        .where(
          (dose) =>
              dose.animalId == animal.id &&
              dose.status == DoseStatus.unrecorded &&
              dose.dueAt.isBefore(now.add(const Duration(hours: 24))) &&
              dose.dueAt.isAfter(now.subtract(const Duration(hours: 2))),
        )
        .length;
    return _AnimalCareOverview(
      latestBreathing: sessions.firstOrNull,
      activeMedicationCount: activeMedicationCount,
      dosesDueSoon: dosesDueSoon,
      weightUnit: snapshot.settings.weightUnit,
    );
  }

  final RespiratorySession? latestBreathing;
  final int activeMedicationCount;
  final int dosesDueSoon;
  final WeightUnit weightUnit;

  String breathingValue(AppLocalizations l10n) => latestBreathing == null
      ? l10n.notRecorded
      : '${formatRespiratoryRate(latestBreathing!.ratePerMinute)}/min';

  String weightValue(Animal animal, AppLocalizations l10n) {
    final weightKg = animal.currentWeightKg;
    if (weightKg == null) {
      return l10n.notRecorded;
    }
    final unitLabel = weightUnit == WeightUnit.kilograms ? 'kg' : 'lb';
    final value = WeightValue.from(weightKg, WeightUnit.kilograms).inUnit(weightUnit);
    return '${value.toStringAsFixed(2)} $unitLabel';
  }
}

class _ArchivedAnimals extends StatelessWidget {
  const _ArchivedAnimals({required this.animals});

  final List<Animal> animals;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SectionHeading('Archived journals'),
      Card(
        child: Column(
          children: [
            for (var index = 0; index < animals.length; index++) ...[
              ListTile(
                minTileHeight: 68,
                leading: AnimalAvatar(animal: animals[index], radius: 24),
                title: Text(animals[index].name),
                subtitle: Text('${animals[index].species} • Hidden from active care'),
                trailing: const Icon(Icons.edit_outlined),
                onTap: () => context.push('/animal/${animals[index].id}/edit'),
              ),
              if (index < animals.length - 1) const Divider(height: 1),
            ],
          ],
        ),
      ),
    ],
  );
}

class _AnimalHero extends StatelessWidget {
  const _AnimalHero({
    required this.animal,
    required this.overview,
    required this.onEdit,
    required this.onExport,
  });

  final Animal animal;
  final _AnimalCareOverview overview;
  final VoidCallback onEdit;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final ageMonths = animal.dateOfBirth == null
        ? animal.approximateAgeMonths
        : completedAgeMonths(animal.dateOfBirth!, DateTime.now());
    final metadata = <String?>[animal.species, animal.breed].whereType<String>().join(' • ');
    final actionStyle = IconButton.styleFrom(
      foregroundColor: CreaturelyColors.white,
      backgroundColor: CreaturelyColors.white.withValues(alpha: 0.12),
      minimumSize: const Size.square(CreaturelySpacing.minTouchTarget),
      shape: CircleBorder(side: BorderSide(color: CreaturelyColors.white.withValues(alpha: 0.2))),
    );
    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          animal.name,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: CreaturelyColors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          metadata,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: CreaturelyColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (ageMonths != null)
          Text(
            _friendlyAge(ageMonths, approximate: animal.dateOfBirth == null),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: CreaturelyColors.white),
          ),
      ],
    );
    final actions = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          key: const ValueKey<String>('animal_edit'),
          tooltip: l10n.editAnimal(animal.name),
          style: actionStyle,
          onPressed: onEdit,
          icon: const Icon(Icons.edit_rounded, size: 21),
        ),
        const SizedBox(width: 8),
        IconButton(
          key: const ValueKey<String>('animal_export'),
          tooltip: l10n.exportAnimal(animal.name),
          style: actionStyle,
          onPressed: onExport,
          icon: const Icon(Icons.ios_share_rounded, size: 21),
        ),
      ],
    );
    final avatar = DecoratedBox(
      decoration: BoxDecoration(
        color: CreaturelyColors.white,
        shape: BoxShape.circle,
        border: Border.all(color: CreaturelyColors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: AnimalAvatar(animal: animal, radius: 30),
      ),
    );
    final metrics = <_HeroMetricData>[
      _HeroMetricData(
        icon: Icons.air_rounded,
        label: l10n.breathing,
        value: overview.breathingValue(l10n),
      ),
      _HeroMetricData(
        icon: Icons.monitor_weight_outlined,
        label: l10n.weight,
        value: overview.weightValue(animal, l10n),
      ),
      _HeroMetricData(
        icon: Icons.medication_outlined,
        label: l10n.medications,
        value: l10n.activeMedicationCount(overview.activeMedicationCount),
      ),
    ];
    return Semantics(
      key: const ValueKey<String>('animal_hero'),
      container: true,
      explicitChildNodes: true,
      label: l10n.animalDashboard(animal.name),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(CreaturelyRadii.feature),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: dark
                ? [CreaturelyColors.teal600, CreaturelyColors.deepTeal]
                : [CreaturelyColors.deepTeal, CreaturelyColors.vitalTeal],
          ),
          border: Border.all(color: CreaturelyColors.white.withValues(alpha: 0.16)),
          boxShadow: [
            BoxShadow(
              color: dark
                  ? Colors.black.withValues(alpha: 0.28)
                  : CreaturelyColors.vitalTeal.withValues(alpha: 0.22),
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -28,
              top: -38,
              child: _DecorativeCircle(
                diameter: 132,
                color: CreaturelyColors.heartCoral.withValues(alpha: dark ? 0.18 : 0.16),
              ),
            ),
            Positioned(
              right: 44,
              bottom: -38,
              child: _DecorativeCircle(
                diameter: 84,
                color: CreaturelyColors.white.withValues(alpha: 0.08),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final textScale = MediaQuery.textScalerOf(context).scale(1);
                  final stackedHeader = constraints.maxWidth < 330 || textScale > 1.3;
                  final header = stackedHeader
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [avatar, const Spacer(), actions]),
                            const SizedBox(height: 12),
                            details,
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            avatar,
                            const SizedBox(width: 14),
                            Expanded(child: details),
                            const SizedBox(width: 8),
                            actions,
                          ],
                        );
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      header,
                      const SizedBox(height: 16),
                      _HeroMetricGrid(metrics: metrics),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _friendlyAge(int months, {required bool approximate}) {
    final qualifier = approximate ? ' (approximate)' : '';
    if (months < 12) {
      return '$months months old$qualifier';
    }
    final years = months ~/ 12;
    final remainder = months % 12;
    return '$years ${years == 1 ? 'year' : 'years'}'
        '${remainder == 0 ? '' : ', $remainder months'} old$qualifier';
  }
}

@immutable
class _HeroMetricData {
  const _HeroMetricData({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;
}

class _HeroMetricGrid extends StatelessWidget {
  const _HeroMetricGrid({required this.metrics});

  final List<_HeroMetricData> metrics;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final labelScale = MediaQuery.textScalerOf(context).scale(12) / 12;
      final stacked = constraints.maxWidth < 310 || labelScale > 1.35;
      if (stacked) {
        return Column(
          children: [
            for (var index = 0; index < metrics.length; index++) ...[
              _HeroMetric(metric: metrics[index], horizontal: true),
              if (index < metrics.length - 1) const SizedBox(height: 8),
            ],
          ],
        );
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var index = 0; index < metrics.length; index++) ...[
            Expanded(child: _HeroMetric(metric: metrics[index])),
            if (index < metrics.length - 1) const SizedBox(width: 8),
          ],
        ],
      );
    },
  );
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({required this.metric, this.horizontal = false});

  final _HeroMetricData metric;
  final bool horizontal;

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: CreaturelyColors.white.withValues(alpha: 0.82),
      fontWeight: FontWeight.w600,
    );
    final valueStyle = Theme.of(
      context,
    ).textTheme.titleMedium?.copyWith(color: CreaturelyColors.white, fontWeight: FontWeight.w800);
    final content = horizontal
        ? Row(
            children: [
              Icon(metric.icon, color: CreaturelyColors.white, size: 19),
              const SizedBox(width: 10),
              Expanded(child: Text(metric.label, style: labelStyle)),
              const SizedBox(width: 8),
              Flexible(
                child: Text(metric.value, textAlign: TextAlign.end, style: valueStyle),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(metric.icon, color: CreaturelyColors.white, size: 17),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      metric.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: labelStyle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(metric.value, maxLines: 2, overflow: TextOverflow.ellipsis, style: valueStyle),
            ],
          );
    return Semantics(
      label: '${metric.label}: ${metric.value}',
      excludeSemantics: true,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: horizontal ? 48 : 76),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: CreaturelyColors.white.withValues(alpha: 0.11),
            borderRadius: BorderRadius.circular(CreaturelyRadii.standard),
            border: Border.all(color: CreaturelyColors.white.withValues(alpha: 0.14)),
          ),
          child: Padding(padding: const EdgeInsets.all(11), child: content),
        ),
      ),
    );
  }
}

class _DecorativeCircle extends StatelessWidget {
  const _DecorativeCircle({required this.diameter, required this.color});

  final double diameter;
  final Color color;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: ExcludeSemantics(
      child: SizedBox.square(
        dimension: diameter,
        child: DecoratedBox(
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
      ),
    ),
  );
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.animal});

  final Animal animal;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final actions = [
      QuickActionItem(
        key: const ValueKey<String>('quick_action_breathing'),
        icon: Icons.air_rounded,
        label: l10n.countBreaths,
        semanticLabel: '${l10n.countBreaths}, ${animal.name}',
        tone: QuickActionTone.primary,
        onTap: () => context.push('/record/breaths/${animal.id}'),
      ),
      QuickActionItem(
        key: const ValueKey<String>('quick_action_weight'),
        icon: Icons.monitor_weight_outlined,
        label: l10n.logWeight,
        semanticLabel: '${l10n.logWeight}, ${animal.name}',
        tone: QuickActionTone.accent,
        onTap: () => context.push('/health/new/${animal.id}?kind=weight'),
      ),
      QuickActionItem(
        key: const ValueKey<String>('quick_action_observation'),
        icon: Icons.visibility_outlined,
        label: l10n.observation,
        semanticLabel: '${l10n.observation}, ${animal.name}',
        tone: QuickActionTone.primaryTonal,
        onTap: () => context.push('/health/new/${animal.id}?kind=observation'),
      ),
      QuickActionItem(
        key: const ValueKey<String>('quick_action_medications'),
        icon: Icons.medication_outlined,
        label: l10n.medications,
        semanticLabel: '${l10n.medications}, ${animal.name}',
        tone: QuickActionTone.secondaryTonal,
        onTap: () => context.go('/schedule'),
      ),
      QuickActionItem(
        key: const ValueKey<String>('quick_action_documents'),
        icon: Icons.description_outlined,
        label: l10n.documents,
        semanticLabel: '${l10n.documents}, ${animal.name}',
        tone: QuickActionTone.neutral,
        onTap: () => context.go('/timeline?filter=document'),
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeading(l10n.quickActions),
        QuickActionRail(actions: actions),
      ],
    );
  }
}

class _CareSummary extends StatelessWidget {
  const _CareSummary({required this.animal, required this.overview});

  final Animal animal;
  final _AnimalCareOverview overview;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final latestBreathing = overview.latestBreathing;
    final cards = <_CareCardData>[
      _CareCardData(
        key: const ValueKey<String>('care_summary_breathing'),
        icon: Icons.air_rounded,
        tone: CreaturelyColors.vitalTeal,
        label: l10n.latestBreathing,
        value: overview.breathingValue(l10n),
        detail: latestBreathing == null
            ? l10n.countBreathsToStartTrend
            : l10n.recordedDate(DateFormat.MMMd().format(latestBreathing.recordedAt.toLocal())),
        onTap: () => context.go('/trends?tab=breathing'),
      ),
      _CareCardData(
        key: const ValueKey<String>('care_summary_weight'),
        icon: Icons.monitor_weight_outlined,
        tone: CreaturelyColors.information,
        label: l10n.currentWeight,
        value: overview.weightValue(animal, l10n),
        detail: animal.currentWeightKg == null
            ? l10n.logWeightToStartTrend
            : l10n.currentRecordedWeight,
        onTap: () => context.go('/trends?tab=weight'),
      ),
      _CareCardData(
        key: const ValueKey<String>('care_summary_medications'),
        icon: Icons.medication_outlined,
        tone: CreaturelyColors.success,
        label: l10n.medicationStatus,
        value: l10n.activeMedicationCount(overview.activeMedicationCount),
        detail: l10n.reviewSchedules,
        onTap: () => context.go('/schedule?view=schedules'),
      ),
      _CareCardData(
        key: const ValueKey<String>('care_summary_doses'),
        icon: Icons.schedule_rounded,
        tone: CreaturelyColors.heartCoral,
        label: l10n.dosesDueSoon,
        value: l10n.shortDoseCount(overview.dosesDueSoon),
        detail: l10n.next24Hours,
        onTap: () => context.go('/schedule'),
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeading(l10n.todayAtAGlance),
        _CareCardGrid(cards: cards),
        if (animal.thresholds.isConfigured) ...[
          const SizedBox(height: 12),
          CalmNotice(
            icon: Icons.tune_rounded,
            text:
                'Breathing range supplied by you or your veterinarian: '
                '${animal.thresholds.minimum?.toStringAsFixed(0) ?? '—'} / '
                '${animal.thresholds.target?.toStringAsFixed(0) ?? '—'} / '
                '${animal.thresholds.maximum?.toStringAsFixed(0) ?? '—'} breaths/min '
                '(min / target / max).',
          ),
        ],
      ],
    );
  }
}

@immutable
class _CareCardData {
  const _CareCardData({
    required this.key,
    required this.icon,
    required this.tone,
    required this.label,
    required this.value,
    required this.detail,
    required this.onTap,
  });

  final Key key;
  final IconData icon;
  final Color tone;
  final String label;
  final String value;
  final String detail;
  final VoidCallback onTap;
}

class _CareCardGrid extends StatelessWidget {
  const _CareCardGrid({required this.cards});

  final List<_CareCardData> cards;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      const spacing = 12.0;
      final textScale = MediaQuery.textScalerOf(context).scale(14) / 14;
      final columns = switch (constraints.maxWidth) {
        >= 760 when textScale <= 1.2 => 4,
        >= 340 when textScale <= 1.3 => 2,
        _ => 1,
      };
      final cardWidth = (constraints.maxWidth - (spacing * (columns - 1))) / columns;
      return Wrap(
        key: const ValueKey<String>('care_summary_grid'),
        spacing: spacing,
        runSpacing: spacing,
        children: [
          for (final card in cards)
            SizedBox(
              width: cardWidth,
              child: _CareSummaryCard(key: card.key, data: card),
            ),
        ],
      );
    },
  );
}

class _CareSummaryCard extends StatefulWidget {
  const _CareSummaryCard({required this.data, super.key});

  final _CareCardData data;

  @override
  State<_CareSummaryCard> createState() => _CareSummaryCardState();
}

class _CareSummaryCardState extends State<_CareSummaryCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final tone = dark
        ? Color.lerp(widget.data.tone, CreaturelyColors.white, 0.32)!
        : widget.data.tone;
    final containerColor = Color.alphaBlend(
      tone.withValues(alpha: dark ? 0.12 : 0.08),
      scheme.surfaceContainerLow,
    );
    final radius = BorderRadius.circular(20);
    final semanticLabel = '${widget.data.label}: ${widget.data.value}. ${widget.data.detail}';
    return Semantics(
      button: true,
      label: semanticLabel,
      onTap: widget.data.onTap,
      excludeSemantics: true,
      child: AnimatedScale(
        scale: _pressed ? 0.985 : 1,
        duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: Card(
          color: containerColor,
          elevation: dark ? 0 : 1.5,
          shadowColor: tone.withValues(alpha: 0.18),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: radius,
            side: BorderSide(color: tone.withValues(alpha: dark ? 0.28 : 0.18)),
          ),
          child: InkWell(
            onTap: widget.data.onTap,
            onHighlightChanged: (value) {
              if (_pressed != value) {
                setState(() => _pressed = value);
              }
            },
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 150),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _CareIcon(icon: widget.data.icon, color: tone),
                        const Spacer(),
                        Icon(Icons.arrow_forward_rounded, color: scheme.onSurfaceVariant, size: 20),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.data.label,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: scheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.data.value,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(widget.data.detail, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CareIcon extends StatelessWidget {
  const _CareIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(color: color.withValues(alpha: 0.13), shape: BoxShape.circle),
    child: SizedBox.square(dimension: 42, child: Icon(icon, color: color, size: 22)),
  );
}

class _OtherAnimals extends StatelessWidget {
  const _OtherAnimals({required this.animals, required this.onSelect, required this.onAdd});

  final List<Animal> animals;
  final ValueChanged<Animal> onSelect;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final itemWidth = textScale > 1.4 ? 126.0 : 96.0;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: scheme.outlineVariant),
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.alphaBlend(scheme.secondary.withValues(alpha: 0.07), scheme.surface),
            Color.alphaBlend(scheme.primary.withValues(alpha: 0.04), scheme.surface),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Other animals', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 14),
            Wrap(
              spacing: 12,
              runSpacing: 14,
              children: [
                for (final animal in animals)
                  _AnimalOrb(animal: animal, width: itemWidth, onTap: () => onSelect(animal)),
                _AddAnimalOrb(width: itemWidth, onTap: onAdd),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimalOrb extends StatelessWidget {
  const _AnimalOrb({required this.animal, required this.width, required this.onTap});

  final Animal animal;
  final double width;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: 'Switch to ${animal.name}, ${animal.species}',
    onTap: onTap,
    child: ExcludeSemantics(
      child: SizedBox(
        width: width,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            key: ValueKey<String>('other_animal_${animal.id}'),
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimalAvatar(animal: animal, radius: 34),
                  const SizedBox(height: 8),
                  Text(
                    animal.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _AddAnimalOrb extends StatelessWidget {
  const _AddAnimalOrb({required this.width, required this.onTap});

  final double width;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      label: 'Add animal',
      onTap: onTap,
      child: ExcludeSemantics(
        child: SizedBox(
          width: width,
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              key: const ValueKey('other_animal_add'),
              onTap: onTap,
              borderRadius: BorderRadius.circular(24),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: scheme.primaryContainer,
                        border: Border.all(color: scheme.primary.withValues(alpha: 0.24)),
                      ),
                      child: Icon(Icons.add_rounded, color: scheme.primary, size: 28),
                    ),
                    const SizedBox(height: 8),
                    Text('Add pet', style: Theme.of(context).textTheme.labelLarge),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
