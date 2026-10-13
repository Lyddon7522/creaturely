import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'domain/models.dart';
import 'l10n/app_strings.dart';
import 'ui/app_controller.dart';
import 'ui/core/theme.dart';
import 'ui/navigation/app_router.dart';

class CreaturelyApp extends ConsumerStatefulWidget {
  const CreaturelyApp({super.key});

  @override
  ConsumerState<CreaturelyApp> createState() => _CreaturelyAppState();
}

class _CreaturelyAppState extends ConsumerState<CreaturelyApp> with WidgetsBindingObserver {
  final _messenger = GlobalKey<ScaffoldMessengerState>();

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
    final theme = ref.watch(
      settingsProvider.select((value) => value.value?.theme ?? AppThemePreference.system),
    );
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
    ref.listen(reminderSyncProvider, (previous, next) {
      if (next.hasError && !identical(previous?.error, next.error)) {
        _messenger.currentState?.showSnackBar(
          SnackBar(
            content: Text(appStrings.remindersCouldNotBeUpdatedYourJournalIsSaved),
            action: SnackBarAction(
              label: appStrings.retry,
              onPressed: () => ref.read(appControllerProvider.notifier).retryReminders(),
            ),
          ),
        );
      }
    });
    ref.listen(appControllerProvider.select((status) => status.recoveryError), (previous, next) {
      if (next != null && !identical(previous, next)) {
        _messenger.currentState?.showSnackBar(
          SnackBar(
            content: Text(appStrings.automaticRecoveryFailed),
            action: SnackBarAction(
              label: appStrings.settings,
              onPressed: () => ref.read(routerProvider).push('/recovery'),
            ),
          ),
        );
      }
    });
    ref.listen(appControllerProvider.select((status) => status.notificationActionError), (
      previous,
      next,
    ) {
      if (next != null && !identical(previous, next)) {
        _messenger.currentState?.showSnackBar(
          SnackBar(
            content: Text(appStrings.notificationActionFailed),
            action: SnackBarAction(
              label: appStrings.retry,
              onPressed: () => ref.read(appControllerProvider.notifier).retryNotificationAction(),
            ),
          ),
        );
      }
    });
    ref.listen(recoveredMediaProvider, (previous, next) {
      if (next.hasError && !identical(previous?.error, next.error)) {
        _messenger.currentState?.showSnackBar(
          SnackBar(
            content: Text(appStrings.fileOperationFailed),
            action: SnackBarAction(
              label: appStrings.retry,
              onPressed: () => ref.invalidate(recoveredMediaProvider),
            ),
          ),
        );
      }
      if (next.hasValue) {
        ref.read(attachmentCleanupProvider.notifier).collect();
        if (next.value!.isNotEmpty && previous?.value == null) {
          _messenger.currentState?.showSnackBar(
            SnackBar(content: Text(appStrings.recoveredImageNotice)),
          );
        }
      }
    });
    ref.listen(attachmentCleanupProvider, (previous, next) {
      if (next.hasError && !identical(previous?.error, next.error)) {
        _messenger.currentState?.showSnackBar(
          SnackBar(
            content: Text(appStrings.attachmentCleanupFailed),
            action: SnackBarAction(
              label: appStrings.retry,
              onPressed: () => ref.read(attachmentCleanupProvider.notifier).collect(),
            ),
          ),
        );
      }
    });
    final themeMode = switch (theme) {
      AppThemePreference.system => ThemeMode.system,
      AppThemePreference.light => ThemeMode.light,
      AppThemePreference.dark => ThemeMode.dark,
    };
    return MaterialApp.router(
      scaffoldMessengerKey: _messenger,
      title: appStrings.appName,
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
