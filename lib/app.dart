import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'domain/models.dart';
import 'l10n/generated/app_localizations.dart';
import 'ui/app_controller.dart';
import 'ui/core/theme.dart';
import 'ui/navigation/app_router.dart';

class CreaturelyApp extends ConsumerStatefulWidget {
  const CreaturelyApp({super.key});

  @override
  ConsumerState<CreaturelyApp> createState() => _CreaturelyAppState();
}

class _CreaturelyAppState extends ConsumerState<CreaturelyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(ref.read(appControllerProvider.notifier).handleAppResumed());
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(appControllerProvider).snapshot.settings;
    ref.listen<String?>(appControllerProvider.select((state) => state.pendingRoute), (
      previous,
      next,
    ) {
      if (next == null || next == previous) {
        return;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        ref.read(routerProvider).push(next);
        ref.read(appControllerProvider.notifier).consumePendingRoute();
      });
    });
    final themeMode = switch (settings.theme) {
      AppThemePreference.system => ThemeMode.system,
      AppThemePreference.light => ThemeMode.light,
      AppThemePreference.dark => ThemeMode.dark,
    };
    return MaterialApp.router(
      title: 'Creaturely',
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'creaturely',
      theme: CreaturelyTheme.light,
      darkTheme: CreaturelyTheme.dark,
      themeMode: themeMode,
      routerConfig: ref.watch(routerProvider),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
