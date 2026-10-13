import 'dart:async';

import 'package:creaturely/data/database.dart';
import 'package:creaturely/data/repository.dart';
import 'package:creaturely/domain/models.dart';
import 'package:creaturely/platform/notification_service.dart';
import 'package:creaturely/platform/time_zone_service.dart';
import 'package:creaturely/ui/app_controller.dart';
import 'package:drift/drift.dart' show QueryInterceptor, QueryExecutor, ApplyInterceptor;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fixtures.dart';

void main() {
  late AppDatabase database;
  late CreaturelyRepository repository;
  late ProviderContainer container;
  late DateTime now;
  late _QueryLog queries;
  setUp(() async {
    now = fixtureTime;
    queries = _QueryLog();
    database = AppDatabase.forTesting(NativeDatabase.memory().interceptWith(queries));
    repository = CreaturelyRepository(database);
    await repository.replaceSnapshot(fixtureSnapshot());
    container = ProviderContainer(
      overrides: [
        repositoryProvider.overrideWithValue(repository),
        reminderServiceProvider.overrideWithValue(const NoopReminderService()),
        wallClockProvider.overrideWithValue(() => now),
      ],
    );
  });
  tearDown(() async {
    container.dispose();
    await database.close();
  });

  test('rolling horizon is idempotent, survives 100 days, and preserves history and IDs', () async {
    final care = container.read(careControllerProvider.notifier);
    await care.maintain(timeZoneId: 'UTC');
    final before = await repository.loadSnapshot();
    final ids = {for (final dose in before.doseLedger) dose.dueAt: dose.id};
    await Future.wait([care.maintain(timeZoneId: 'UTC'), care.maintain(timeZoneId: 'UTC')]);
    final repeated = await repository.loadSnapshot();
    expect({for (final dose in repeated.doseLedger) dose.dueAt: dose.id}, ids);
    now = now.add(const Duration(days: 100));
    await care.maintain(timeZoneId: 'UTC');
    final after = await repository.loadSnapshot();
    expect(
      after.doseLedger.any((dose) => dose.dueAt.isAfter(now.add(const Duration(days: 80)))),
      isTrue,
    );
    for (final dose in before.doseLedger) {
      expect(after.doseLedger.singleWhere((value) => value.id == dose.id).dueAt, dose.dueAt);
    }
    expect(after.doseLedger.where((dose) => dose.status == DoseStatus.given), hasLength(1));
    final missingWindow = after.doseLedger.where(
      (dose) =>
          dose.dueAt.isAfter(now.subtract(const Duration(days: 9))) && dose.dueAt.isBefore(now),
    );
    expect(missingWindow.length, greaterThanOrEqualTo(8));
    expect(missingWindow.every((dose) => dose.status == DoseStatus.missed), isTrue);
  });

  test(
    'a breathing save does not re-query settings or medication history in a large journal',
    () async {
      final json = fixtureSnapshot().toJson();
      json['respiratorySessions'] = [
        for (var i = 0; i < 5000; i++)
          {...fixtureSnapshot().respiratorySessions.first.toJson(), 'id': 'synthetic-$i'},
      ];
      await repository.replaceSnapshot(CreaturelySnapshot.fromJson(json));
      var settingsEmissions = 0;
      var medicationEmissions = 0;
      container.listen(settingsProvider, (_, next) {
        if (next.hasValue) settingsEmissions++;
      });
      container.listen(medicationsProvider('animal-1'), (_, next) {
        if (next.hasValue) medicationEmissions++;
      });
      await container.read(settingsProvider.future);
      await container.read(medicationsProvider('animal-1').future);
      final initialSettings = settingsEmissions;
      final initialMedication = medicationEmissions;
      final session = RespiratorySession.fromJson({
        ...fixtureSnapshot().respiratorySessions.first.toJson(),
        'id': 'new-record',
      });
      queries.statements.clear();
      await container.read(careControllerProvider.notifier).saveRespiratorySession(session);
      await Future<void>.delayed(Duration.zero);
      expect(
        queries.statements.where(
          (sql) =>
              sql.contains('setting_rows') ||
              sql.contains('medication_rows') ||
              sql.contains('dose_ledger_rows'),
        ),
        isEmpty,
      );
      expect(settingsEmissions, initialSettings);
      expect(medicationEmissions, initialMedication);
      expect((await database.watchSessions(animalId: 'animal-1').first).length, 5001);
    },
  );

  test('opening data management reads only animals and document metadata', () async {
    queries.statements.clear();
    final ready = Completer<void>();
    container.listen(journalViewProvider((feature: JournalFeature.data, animalId: null)), (
      _,
      view,
    ) {
      if (!view.loading && !ready.isCompleted) ready.complete();
    });
    await ready.future;
    expect(queries.statements.any((sql) => sql.contains('care_document_rows')), isTrue);
    expect(
      queries.statements.where(
        (sql) =>
            sql.contains('setting_rows') ||
            sql.contains('respiratory_session_rows') ||
            sql.contains('medication_rows') ||
            sql.contains('dose_ledger_rows'),
      ),
      isEmpty,
    );
  });

  test('animal-scoped forms ignore global selection and use only their animal query', () async {
    queries.statements.clear();
    const query = (feature: JournalFeature.animalForm, animalId: 'animal-1');
    final ready = Completer<void>();
    var emissions = 0;
    container.listen(journalViewProvider(query), (_, view) {
      emissions++;
      if (!view.loading && !ready.isCompleted) ready.complete();
    });
    await ready.future;
    final before = emissions;
    container.read(selectedAnimalProvider.notifier).selectAnimal('some-other-animal');
    await Future<void>.delayed(Duration.zero);
    expect(emissions, before);
    final animalReads = queries.statements.where((sql) => sql.contains('animal_rows'));
    expect(animalReads, isNotEmpty);
    expect(animalReads.every((sql) => sql.contains('WHERE')), isTrue);
  });

  test(
    'an archived global selection falls back to active care but is editable explicitly',
    () async {
      final json = fixtureSnapshot().toJson();
      json['animals'] = [
        fixtureAnimal().copyWith(archived: true).toJson(),
        fixtureAnimal(id: 'active', name: 'Active synthetic animal').toJson(),
      ];
      await repository.replaceSnapshot(CreaturelySnapshot.fromJson(json));
      container.read(selectedAnimalProvider.notifier).selectAnimal('animal-1');
      Future<JournalView> ready(JournalQuery query) {
        final result = Completer<JournalView>();
        container.listen(journalViewProvider(query), (_, view) {
          if (!view.loading && !result.isCompleted) result.complete(view);
        }, fireImmediately: true);
        return result.future;
      }

      final global = await ready((feature: JournalFeature.animals, animalId: null));
      expect(global.selectedAnimal?.id, 'active');
      final scoped = await ready((feature: JournalFeature.animalForm, animalId: 'animal-1'));
      expect(scoped.selectedAnimal?.id, 'animal-1');
    },
  );

  test(
    'the dashboard requests only the latest breathing measurement, not the journal history',
    () async {
      final json = fixtureSnapshot().toJson();
      json['respiratorySessions'] = [
        for (var i = 0; i < 5000; i++)
          {
            ...fixtureSnapshot().respiratorySessions.single.toJson(),
            'id': 'synthetic-$i',
            'recordedAt': fixtureTime.add(Duration(minutes: i)).toIso8601String(),
          },
      ];
      await repository.replaceSnapshot(CreaturelySnapshot.fromJson(json));
      queries.statements.clear();
      final ready = Completer<JournalView>();
      container.listen(journalViewProvider((feature: JournalFeature.animals, animalId: null)), (
        _,
        view,
      ) {
        if (!view.loading && !ready.isCompleted) ready.complete(view);
      });
      final view = await ready.future;
      expect(view.respiratorySessions.single.id, 'synthetic-4999');
      final reads = queries.statements.where((sql) => sql.contains('respiratory_session_rows'));
      expect(reads, isNotEmpty);
      expect(reads.every((sql) => sql.contains('WHERE') && sql.contains('LIMIT')), isTrue);
    },
  );

  test('cold launch waits for navigation and consumes a dose action once', () async {
    container.dispose();
    container = ProviderContainer(
      overrides: [
        repositoryProvider.overrideWithValue(repository),
        reminderServiceProvider.overrideWithValue(
          _StartupReminders(NotificationAction.dose('dose-1', DoseStatus.skipped)),
        ),
        timeZoneServiceProvider.overrideWithValue(
          DeviceTimeZoneService(lookupIdentifier: () async => 'UTC'),
        ),
        wallClockProvider.overrideWithValue(() => now),
      ],
    );
    final app = container.read(appControllerProvider.notifier);
    await app.initialize();
    expect((await database.findDose('dose-1'))!.status, DoseStatus.given);
    final consumed = database
        .watchDoses(animalId: 'animal-1')
        .firstWhere(
          (doses) => doses.any((dose) => dose.id == 'dose-1' && dose.status == DoseStatus.skipped),
        );
    app.navigationReady();
    await consumed;
    final saved = await database.findDose('dose-1');
    now = now.add(const Duration(minutes: 1));
    app.navigationReady();
    await Future<void>.delayed(Duration.zero);
    expect((await database.findDose('dose-1'))!.updatedAt, saved!.updatedAt);
  });

  test('concurrent settings edits preserve both changed fields', () async {
    final settings = container.read(settingsControllerProvider.notifier);
    await Future.wait([
      settings.updateSettings((current) => current.copyWith(defaultTimerSeconds: 60)),
      settings.updateSettings((current) => current.copyWith(weightUnit: WeightUnit.pounds)),
    ]);
    final saved = await database.readSettings();
    expect(saved.defaultTimerSeconds, 60);
    expect(saved.weightUnit, WeightUnit.pounds);
  });

  test('settings streams surface save failures without replacing journal state', () async {
    container.listen(settingsControllerProvider, (_, _) {});
    await expectLater(
      container
          .read(settingsControllerProvider.notifier)
          .updateSettings((current) => current.copyWith(defaultTimerSeconds: 17)),
      throwsArgumentError,
    );
    expect(container.read(settingsControllerProvider).hasError, isTrue);
    expect((await repository.loadSnapshot()).animals.single.name, 'Moss');
  });
}

class _StartupReminders extends NoopReminderService {
  const _StartupReminders(this.action);
  final NotificationAction action;
  @override
  Future<void> initialize(void Function(NotificationAction) onAction) async => onAction(action);
}

class _QueryLog extends QueryInterceptor {
  final List<String> statements = [];
  @override
  Future<List<Map<String, Object?>>> runSelect(
    QueryExecutor executor,
    String statement,
    List<Object?> args,
  ) {
    statements.add(statement);
    return executor.runSelect(statement, args);
  }
}
