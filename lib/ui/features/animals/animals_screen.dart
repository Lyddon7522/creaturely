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
                onEdit: () => context.push('/animal/${selected.id}/edit'),
                onExport: () => context.push('/animal/${selected.id}/export'),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 18)),
            SliverToBoxAdapter(
              child: _CareSummary(animal: selected, snapshot: state.snapshot),
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
  const _AnimalHero({required this.animal, required this.onEdit, required this.onExport});

  final Animal animal;
  final VoidCallback onEdit;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final ageMonths = animal.dateOfBirth == null
        ? animal.approximateAgeMonths
        : completedAgeMonths(animal.dateOfBirth!, DateTime.now());
    final metadata = <String?>[animal.species, animal.breed].whereType<String>().join(' • ');
    final buttonStyle = TextButton.styleFrom(
      foregroundColor: CreaturelyColors.white,
      backgroundColor: CreaturelyColors.white.withValues(alpha: 0.12),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(CreaturelyRadii.standard),
        side: BorderSide(color: CreaturelyColors.white.withValues(alpha: 0.18)),
      ),
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
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            TextButton.icon(
              style: buttonStyle,
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined, size: 19),
              label: const Text('Edit'),
            ),
            TextButton.icon(
              key: const ValueKey('animal_export'),
              style: buttonStyle,
              onPressed: onExport,
              icon: const Icon(Icons.ios_share_rounded, size: 19),
              label: const Text('Export'),
            ),
          ],
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
        child: AnimalAvatar(animal: animal, radius: 36),
      ),
    );
    return Semantics(
      key: const ValueKey<String>('animal_hero'),
      container: true,
      explicitChildNodes: true,
      label: '${animal.name} dashboard',
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
              padding: const EdgeInsets.all(20),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final textScale = MediaQuery.textScalerOf(context).scale(1);
                  final stacked = constraints.maxWidth < 360 || textScale > 1.5;
                  if (stacked) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [avatar, const SizedBox(height: 16), details],
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      avatar,
                      const SizedBox(width: 16),
                      Expanded(child: details),
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
  const _CareSummary({required this.animal, required this.snapshot});

  final Animal animal;
  final CreaturelySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final sessions =
        snapshot.respiratorySessions
            .where((value) => value.animalId == animal.id)
            .toList(growable: false)
          ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
    final activeMeds = snapshot.medications
        .where((value) => value.animalId == animal.id && value.active)
        .length;
    final now = DateTime.now();
    final due = snapshot.doseLedger
        .where(
          (value) =>
              value.animalId == animal.id &&
              value.status == DoseStatus.unrecorded &&
              value.dueAt.isBefore(now.add(const Duration(hours: 24))) &&
              value.dueAt.isAfter(now.subtract(const Duration(hours: 2))),
        )
        .length;
    final weightUnit = snapshot.settings.weightUnit;
    final weightLabel = weightUnit == WeightUnit.kilograms ? 'kg' : 'lb';
    final rows = <({IconData icon, Color color, String label, String value, VoidCallback onTap})>[
      (
        icon: Icons.air_rounded,
        color: CreaturelyColors.vitalTeal,
        label: 'Latest breathing',
        value: sessions.isEmpty
            ? 'Not recorded'
            : '${formatRespiratoryRate(sessions.first.ratePerMinute)}/min • '
                  '${DateFormat.MMMd().format(sessions.first.recordedAt.toLocal())}',
        onTap: () => context.go('/trends?tab=breathing'),
      ),
      (
        icon: Icons.monitor_weight_outlined,
        color: CreaturelyColors.information,
        label: 'Current weight',
        value: animal.currentWeightKg == null
            ? 'Not recorded'
            : '${WeightValue.from(animal.currentWeightKg!, WeightUnit.kilograms).inUnit(weightUnit).toStringAsFixed(2)} $weightLabel',
        onTap: () => context.go('/trends?tab=weight'),
      ),
      (
        icon: Icons.medication_outlined,
        color: CreaturelyColors.success,
        label: 'Medications',
        value: '$activeMeds active',
        onTap: () => context.go('/schedule?view=schedules'),
      ),
      (
        icon: Icons.schedule_rounded,
        color: CreaturelyColors.heartCoral,
        label: 'Doses due soon',
        value: '$due ${due == 1 ? 'dose' : 'doses'} in the next 24 hours',
        onTap: () => context.go('/schedule'),
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeading('Today at a glance'),
        Card(
          child: Column(
            children: [
              for (var index = 0; index < rows.length; index++) ...[
                ListTile(
                  minTileHeight: 64,
                  leading: _CareIcon(icon: rows[index].icon, color: rows[index].color),
                  title: Text(rows[index].label),
                  subtitle: Text(
                    rows[index].value,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: rows[index].onTap,
                ),
                if (index < rows.length - 1) const Divider(height: 1),
              ],
            ],
          ),
        ),
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

class _CareIcon extends StatelessWidget {
  const _CareIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.13),
      borderRadius: BorderRadius.circular(12),
    ),
    child: SizedBox.square(dimension: 40, child: Icon(icon, color: color, size: 21)),
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
