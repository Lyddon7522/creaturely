import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models.dart';
import '../../l10n/generated/app_localizations.dart';
import '../app_controller.dart';
import '../core/brand.dart';
import '../core/widgets.dart';
import '../features/animals/animal_form_screen.dart';
import '../features/animals/animals_screen.dart';
import '../features/documents/document_form_screen.dart';
import '../features/health/health_record_form_screen.dart';
import '../features/medication/medication_details_screen.dart';
import '../features/medication/medication_form_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/respiratory/respiratory_recording_screen.dart';
import '../features/schedule/respiratory_reminder_form_screen.dart';
import '../features/schedule/schedule_screen.dart';
import '../features/schedule/weight_reminder_form_screen.dart';
import '../features/settings/data_management_screen.dart';
import '../features/settings/legal_screen.dart';
import '../features/settings/recovery_settings_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/timeline/timeline_screen.dart';
import '../features/trends/trends_screen.dart';
import 'top_level_scroll.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const _LaunchGate()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            _NavigationShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/animals',
                pageBuilder: (context, state) => _page(context, state, const AnimalsScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/trends',
                pageBuilder: (context, state) => _page(
                  context,
                  state,
                  TrendsScreen(initialTab: state.uri.queryParameters['tab']),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/timeline',
                pageBuilder: (context, state) => _page(
                  context,
                  state,
                  TimelineScreen(initialFilter: state.uri.queryParameters['filter']),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/schedule',
                pageBuilder: (context, state) => _page(
                  context,
                  state,
                  ScheduleScreen(initialView: state.uri.queryParameters['view']),
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
      GoRoute(path: '/animal/new', builder: (context, state) => const AnimalFormScreen()),
      GoRoute(
        path: '/animal/:id/edit',
        builder: (context, state) => AnimalFormScreen(animalId: state.pathParameters['id']),
      ),
      GoRoute(
        path: '/animal/:id/export',
        builder: (context, state) =>
            DataManagementScreen(initialAnimalId: state.pathParameters['id'], petExportOnly: true),
      ),
      GoRoute(
        path: '/record/breaths/:animalId',
        builder: (context, state) => RespiratoryRecordingScreen(
          animalId: state.pathParameters['animalId']!,
          initialContext: state.uri.queryParameters['context'] == RespiratoryContext.resting.name
              ? RespiratoryContext.resting
              : RespiratoryContext.sleeping,
        ),
      ),
      GoRoute(
        path: '/breathing-reminder/new/:animalId',
        builder: (context, state) =>
            RespiratoryReminderFormScreen(animalId: state.pathParameters['animalId']!),
      ),
      GoRoute(
        path: '/breathing-reminder/:id/edit/:animalId',
        builder: (context, state) => RespiratoryReminderFormScreen(
          reminderId: state.pathParameters['id'],
          animalId: state.pathParameters['animalId']!,
        ),
      ),
      GoRoute(
        path: '/weight-reminder/new/:animalId',
        builder: (context, state) =>
            WeightReminderFormScreen(animalId: state.pathParameters['animalId']!),
      ),
      GoRoute(
        path: '/weight-reminder/:id/edit/:animalId',
        builder: (context, state) => WeightReminderFormScreen(
          reminderId: state.pathParameters['id'],
          animalId: state.pathParameters['animalId']!,
        ),
      ),
      GoRoute(
        path: '/medication/new/:animalId',
        builder: (context, state) =>
            MedicationFormScreen(animalId: state.pathParameters['animalId']!),
      ),
      GoRoute(
        path: '/medication/:id/edit/:animalId',
        builder: (context, state) => MedicationFormScreen(
          medicationId: state.pathParameters['id'],
          animalId: state.pathParameters['animalId']!,
        ),
      ),
      GoRoute(
        path: '/medication/:id/:animalId',
        builder: (context, state) => MedicationDetailsScreen(
          medicationId: state.pathParameters['id']!,
          animalId: state.pathParameters['animalId']!,
        ),
      ),
      GoRoute(
        path: '/health/new/:animalId',
        builder: (context, state) => HealthRecordFormScreen(
          animalId: state.pathParameters['animalId']!,
          initialKind: switch (state.uri.queryParameters['kind']) {
            'allergy' => HealthRecordKind.allergy,
            'condition' => HealthRecordKind.condition,
            'observation' => HealthRecordKind.observation,
            _ => HealthRecordKind.weight,
          },
        ),
      ),
      GoRoute(
        path: '/health/:id/edit/:animalId',
        builder: (context, state) => HealthRecordFormScreen(
          recordId: state.pathParameters['id'],
          animalId: state.pathParameters['animalId']!,
        ),
      ),
      GoRoute(
        path: '/document/new/:animalId',
        builder: (context, state) =>
            DocumentFormScreen(animalId: state.pathParameters['animalId']!),
      ),
      GoRoute(
        path: '/document/:id/edit/:animalId',
        builder: (context, state) => DocumentFormScreen(
          documentId: state.pathParameters['id'],
          animalId: state.pathParameters['animalId']!,
        ),
      ),
      GoRoute(path: '/data', builder: (context, state) => const DataManagementScreen()),
      GoRoute(path: '/data/delete', builder: (context, state) => const DeleteJournalScreen()),
      GoRoute(path: '/recovery', builder: (context, state) => const RecoverySettingsScreen()),
      GoRoute(
        path: '/legal/:page',
        builder: (context, state) => LegalScreen(
          page: switch (state.pathParameters['page']) {
            'privacy' => LegalPage.privacy,
            'terms' => LegalPage.terms,
            'medical' => LegalPage.medical,
            'about' => LegalPage.about,
            _ => LegalPage.about,
          },
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page unavailable')),
      body: EmptyState(
        icon: Icons.explore_off_outlined,
        title: 'This page could not be opened',
        body: state.error?.toString() ?? 'Return to the Animals dashboard.',
        action: FilledButton(
          onPressed: () => context.go('/animals'),
          child: const Text('Go to Animals'),
        ),
      ),
    ),
  );
  ref.onDispose(router.dispose);
  return router;
});

CustomTransitionPage<void> _page(BuildContext context, GoRouterState state, Widget child) =>
    CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 180),
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(opacity: animation, child: child),
    );

class _LaunchGate extends ConsumerStatefulWidget {
  const _LaunchGate();

  @override
  ConsumerState<_LaunchGate> createState() => _LaunchGateState();
}

class _LaunchGateState extends ConsumerState<_LaunchGate> {
  @override
  void initState() {
    super.initState();
    unawaited(_initialize());
  }

  Future<void> _initialize() async {
    final controller = ref.read(appControllerProvider.notifier);
    await controller.initialize();
    if (!mounted) {
      return;
    }
    final settings = ref.read(appControllerProvider).snapshot.settings;
    if (settings.automaticRecoveryEnabled) {
      try {
        final managerFuture = ref.read(recoverySnapshotManagerProvider.future);
        final manager = await managerFuture;
        await manager.createAndPrune();
      } on Object {
        // Recovery failures are surfaced in Settings and never block local use.
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appControllerProvider);
    if (state.loading) {
      return const LoadingPane();
    }
    if (state.error != null) {
      return Scaffold(
        body: EmptyState(
          icon: Icons.storage_outlined,
          title: 'Creaturely could not open the local journal',
          body: state.error.toString(),
          action: FilledButton.icon(
            onPressed: () => ref.read(appControllerProvider.notifier).refresh(),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Try again'),
          ),
        ),
      );
    }
    if (!state.snapshot.settings.onboardingComplete || state.snapshot.animals.isEmpty) {
      return const OnboardingScreen();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        context.go('/animals');
      }
    });
    return const LoadingPane();
  }
}

class _NavigationShell extends ConsumerWidget {
  const _NavigationShell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final destinations = <({IconData icon, IconData selected, String label})>[
      (icon: Icons.pets_outlined, selected: Icons.pets_rounded, label: l10n.animals),
      (icon: Icons.insights_outlined, selected: Icons.insights_rounded, label: l10n.trends),
      (icon: Icons.timeline_outlined, selected: Icons.timeline_rounded, label: l10n.timeline),
      (
        icon: Icons.calendar_month_outlined,
        selected: Icons.calendar_month_rounded,
        label: l10n.schedule,
      ),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final large = constraints.maxWidth >= 840;
        if (large) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: navigationShell.currentIndex,
                  onDestinationSelected: (index) => _goBranch(ref, index),
                  leading: Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 18),
                    child: const CreaturelyMark(size: 44, semanticLabel: 'Creaturely navigation'),
                  ),
                  destinations: [
                    for (final destination in destinations)
                      NavigationRailDestination(
                        icon: Icon(destination.icon),
                        selectedIcon: Icon(destination.selected),
                        label: Text(destination.label),
                      ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(child: navigationShell),
              ],
            ),
          );
        }
        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: (index) => _goBranch(ref, index),
            destinations: [
              for (final destination in destinations)
                NavigationDestination(
                  icon: Icon(destination.icon),
                  selectedIcon: Icon(destination.selected),
                  label: destination.label,
                ),
            ],
          ),
        );
      },
    );
  }

  void _goBranch(WidgetRef ref, int index) {
    if (index == navigationShell.currentIndex) {
      ref.read(topLevelScrollCoordinatorProvider).scrollToTop(TopLevelDestination.values[index]);
      return;
    }
    navigationShell.goBranch(index);
  }
}
