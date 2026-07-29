import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../domain/models.dart';
import '../../../domain/units.dart';
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
            SliverToBoxAdapter(
              child: _AnimalHero(
                animal: selected,
                onEdit: () => context.push('/animal/${selected.id}/edit'),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverToBoxAdapter(child: _QuickActions(animal: selected)),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverToBoxAdapter(
              child: _CareSummary(animal: selected, snapshot: state.snapshot),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverToBoxAdapter(
              child: SectionHeading(
                'Your animals',
                trailing: TextButton.icon(
                  onPressed: () => context.push('/animal/new'),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Add'),
                ),
              ),
            ),
            SliverLayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.crossAxisExtent;
                final columns = width >= 760
                    ? 3
                    : width >= 480
                    ? 2
                    : 1;
                return SliverGrid.builder(
                  itemCount: animals.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    mainAxisExtent: 116,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final animal = animals[index];
                    return _AnimalCard(
                      animal: animal,
                      selected: animal.id == selected.id,
                      onTap: () => ref.read(appControllerProvider.notifier).selectAnimal(animal.id),
                    );
                  },
                );
              },
            ),
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
  const _AnimalHero({required this.animal, required this.onEdit});

  final Animal animal;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: '${animal.name} dashboard',
    child: Card(
      color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.6),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Row(
          children: [
            AnimalAvatar(animal: animal, radius: 44),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(animal.name, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 3),
                  Text(
                    <String?>[animal.species, animal.breed].whereType<String>().join(' • '),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if (animal.approximateAgeMonths != null)
                    Text(
                      _friendlyAge(animal.approximateAgeMonths!),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Edit ${animal.name}',
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined),
            ),
          ],
        ),
      ),
    ),
  );

  String _friendlyAge(int months) {
    if (months < 12) {
      return '$months months old (approximate)';
    }
    final years = months ~/ 12;
    final remainder = months % 12;
    return '$years ${years == 1 ? 'year' : 'years'}'
        '${remainder == 0 ? '' : ', $remainder months'} old (approximate)';
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.animal});

  final Animal animal;

  @override
  Widget build(BuildContext context) {
    final actions = <({IconData icon, String label, String route, Color color})>[
      (
        icon: Icons.air_rounded,
        label: 'Count breaths',
        route: '/record/breaths/${animal.id}',
        color: CreaturelyColors.vitalTeal,
      ),
      (
        icon: Icons.medication_outlined,
        label: 'Medication',
        route: '/medication/new/${animal.id}',
        color: CreaturelyColors.success,
      ),
      (
        icon: Icons.monitor_weight_outlined,
        label: 'Health record',
        route: '/health/new/${animal.id}',
        color: CreaturelyColors.information,
      ),
      (
        icon: Icons.description_outlined,
        label: 'Document',
        route: '/document/new/${animal.id}',
        color: CreaturelyColors.warning,
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeading('Quick actions'),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: actions.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 240,
            mainAxisExtent: 92,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final action = actions[index];
            return Semantics(
              button: true,
              label: '${action.label} for ${animal.name}',
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => context.push(action.route),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: action.color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(11),
                            child: Icon(action.icon, color: action.color),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            action.label,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
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
    final rows = <({IconData icon, String label, String value})>[
      (
        icon: Icons.air_rounded,
        label: 'Latest breathing',
        value: sessions.isEmpty
            ? 'Not recorded'
            : '${formatRespiratoryRate(sessions.first.ratePerMinute)}/min • '
                  '${DateFormat.MMMd().format(sessions.first.recordedAt.toLocal())}',
      ),
      (
        icon: Icons.monitor_weight_outlined,
        label: 'Current weight',
        value: animal.currentWeightKg == null
            ? 'Not recorded'
            : '${WeightValue.from(animal.currentWeightKg!, WeightUnit.kilograms).inUnit(weightUnit).toStringAsFixed(2)} $weightLabel',
      ),
      (
        icon: Icons.medication_outlined,
        label: 'Active medication',
        value: '$activeMeds ${activeMeds == 1 ? 'record' : 'records'}',
      ),
      (
        icon: Icons.schedule_rounded,
        label: 'Due in 24 hours',
        value: '$due ${due == 1 ? 'dose' : 'doses'}',
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeading('Current care'),
        Card(
          child: Column(
            children: [
              for (var index = 0; index < rows.length; index++) ...[
                ListTile(
                  minTileHeight: 64,
                  leading: Icon(rows[index].icon),
                  title: Text(rows[index].label),
                  subtitle: Text(
                    rows[index].value,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
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

class _AnimalCard extends StatelessWidget {
  const _AnimalCard({required this.animal, required this.selected, required this.onTap});

  final Animal animal;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    label: 'Open ${animal.name}, ${animal.species}',
    child: Card(
      color: selected ? Theme.of(context).colorScheme.secondaryContainer : null,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              AnimalAvatar(animal: animal, radius: 28),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(animal.name, style: Theme.of(context).textTheme.titleMedium),
                    Text(
                      animal.species,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              if (selected) const Icon(Icons.check_circle_rounded),
            ],
          ),
        ),
      ),
    ),
  );
}
