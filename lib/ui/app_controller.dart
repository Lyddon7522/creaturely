import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../data/backup_service.dart';
import '../data/database.dart';
import '../data/document_storage.dart';
import '../data/recovery_snapshot_manager.dart';
import '../data/repository.dart';
import '../domain/models.dart';
import '../domain/recurrence.dart';
import '../domain/units.dart';
import '../platform/cloud_recovery_bridge.dart';
import '../platform/document_save_service.dart';
import '../platform/external_link_service.dart';
import '../platform/feedback_service.dart';
import '../platform/notification_service.dart';
import '../platform/time_zone_service.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final repositoryProvider = Provider<CreaturelyRepository>(
  (ref) => CreaturelyRepository(ref.watch(databaseProvider)),
);

final documentStorageProvider = FutureProvider<DocumentStorage>(
  (ref) => DocumentStorage.openDefault(),
);

final reminderServiceProvider = Provider<ReminderService>((ref) => LocalReminderService());

final timeZoneServiceProvider = Provider<TimeZoneService>((ref) => DeviceTimeZoneService());

final recordingFeedbackProvider = Provider<RecordingFeedback>(
  (ref) => const SystemRecordingFeedback(),
);

final cloudRecoveryBridgeProvider = Provider<CloudRecoveryBridge>(
  (ref) => const MethodChannelCloudRecoveryBridge(),
);

final documentSaveServiceProvider = Provider<DocumentSaveService>(
  (ref) => const SystemDocumentSaveService(),
);

final externalLinkServiceProvider = Provider<ExternalLinkService>(
  (ref) => const SystemExternalLinkService(),
);

final recoverySnapshotManagerProvider = FutureProvider<RecoverySnapshotManager>((ref) async {
  final documents = await ref.watch(documentStorageProvider.future);
  return RecoverySnapshotManager(
    store: ref.watch(repositoryProvider),
    documents: documents,
    backups: const CreaturelyBackupService(),
    cloud: ref.watch(cloudRecoveryBridgeProvider),
  );
});

final appControllerProvider = StateNotifierProvider<AppController, CreaturelyState>(
  (ref) => AppController(
    repository: ref.watch(repositoryProvider),
    reminders: ref.watch(reminderServiceProvider),
    timeZones: ref.watch(timeZoneServiceProvider),
  ),
);

class CreaturelyState {
  const CreaturelyState({
    required this.loading,
    required this.snapshot,
    this.selectedAnimalId,
    this.error,
    this.pendingRoute,
  });

  factory CreaturelyState.initial() =>
      CreaturelyState(loading: true, snapshot: CreaturelySnapshot.empty());

  final bool loading;
  final CreaturelySnapshot snapshot;
  final String? selectedAnimalId;
  final Object? error;
  final String? pendingRoute;

  List<Animal> get activeAnimals =>
      snapshot.animals.where((animal) => !animal.archived).toList(growable: false);

  Animal? get selectedAnimal {
    final id = selectedAnimalId;
    if (id == null) {
      return activeAnimals.firstOrNull;
    }
    return activeAnimals.where((animal) => animal.id == id).firstOrNull;
  }

  CreaturelyState copyWith({
    bool? loading,
    CreaturelySnapshot? snapshot,
    String? selectedAnimalId,
    bool clearSelectedAnimal = false,
    Object? error,
    bool clearError = false,
    String? pendingRoute,
    bool clearPendingRoute = false,
  }) => CreaturelyState(
    loading: loading ?? this.loading,
    snapshot: snapshot ?? this.snapshot,
    selectedAnimalId: clearSelectedAnimal ? null : selectedAnimalId ?? this.selectedAnimalId,
    error: clearError ? null : error ?? this.error,
    pendingRoute: clearPendingRoute ? null : pendingRoute ?? this.pendingRoute,
  );
}

class AppController extends StateNotifier<CreaturelyState> {
  AppController({
    required CreaturelyRepository repository,
    required ReminderService reminders,
    required TimeZoneService timeZones,
    Uuid uuid = const Uuid(),
    RecurrenceEngine recurrence = const RecurrenceEngine(),
    MedicationLedger ledger = const MedicationLedger(),
    DateTime Function()? clock,
  }) : _repository = repository,
       _reminders = reminders,
       _timeZones = timeZones,
       _uuid = uuid,
       _recurrence = recurrence,
       _ledger = ledger,
       _clock = clock ?? DateTime.now,
       super(CreaturelyState.initial());

  final CreaturelyRepository _repository;
  final ReminderService _reminders;
  final TimeZoneService _timeZones;
  final Uuid _uuid;
  final RecurrenceEngine _recurrence;
  final MedicationLedger _ledger;
  final DateTime Function() _clock;
  bool _initialized = false;
  bool _initializationComplete = false;
  bool _handlingResume = false;

  String newId() => _uuid.v4();

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    _initialized = true;
    try {
      final resolvedTimeZone = await _timeZones.configure();
      try {
        await _reminders.initialize((action) {
          switch (action.kind) {
            case NotificationActionKind.doseStatus:
              unawaited(recordDose(action.id, action.status!));
              break;
            case NotificationActionKind.openRespiratory:
              final animalId = action.animalId;
              final context = action.context;
              if (animalId != null && context != null) {
                state = state.copyWith(
                  pendingRoute: '/record/breaths/$animalId?context=${context.name}',
                );
              }
              break;
            case NotificationActionKind.openWeight:
              final animalId = action.animalId;
              if (animalId != null) {
                state = state.copyWith(pendingRoute: '/health/new/$animalId');
              }
              break;
          }
        });
      } on Object {
        // Platform reminder services are optional. A missing capability or
        // denied permission must never prevent the local journal from opening.
      }
      await _reload();
      if (resolvedTimeZone != null) {
        final changed = await _rebaseSchedulesForTimeZone(resolvedTimeZone);
        if (changed) {
          await _reload();
        }
      }
      await _synchronizeReminders(state.snapshot);
    } on Object catch (error) {
      state = state.copyWith(loading: false, error: error);
    } finally {
      _initializationComplete = true;
    }
  }

  void selectAnimal(String id) {
    if (state.snapshot.animals.any((animal) => animal.id == id)) {
      state = state.copyWith(selectedAnimalId: id);
    }
  }

  void consumePendingRoute() {
    if (state.pendingRoute != null) {
      state = state.copyWith(clearPendingRoute: true);
    }
  }

  Future<void> handleAppResumed() async {
    if (!_initializationComplete || _handlingResume) {
      return;
    }
    _handlingResume = true;
    try {
      final resolvedTimeZone = await _timeZones.configure();
      if (resolvedTimeZone != null) {
        await _rebaseSchedulesForTimeZone(resolvedTimeZone);
      }
      await _reload(syncReminders: true);
    } on Object {
      // Resume maintenance is best effort and must not block the local journal.
    } finally {
      _handlingResume = false;
    }
  }

  Future<void> saveAnimal(Animal animal) async {
    await _repository.saveAnimal(animal);
    await _reload(selectedAnimalId: animal.id);
  }

  Future<Animal> createAnimal({
    required String name,
    required String species,
    String? breed,
    String? sexOrStatus,
    DateTime? dateOfBirth,
    int? approximateAgeMonths,
    String? colorMarkings,
    double? currentWeightKg,
    String? photoPath,
    String? notes,
    RespiratoryThresholds thresholds = const RespiratoryThresholds(),
    bool completeOnboarding = false,
  }) async {
    final now = _clock().toUtc();
    final animal = Animal(
      id: newId(),
      createdAt: now,
      updatedAt: now,
      name: name.trim(),
      photoPath: photoPath,
      species: species.trim(),
      breed: _emptyToNull(breed),
      sexOrStatus: _emptyToNull(sexOrStatus),
      dateOfBirth: dateOfBirth,
      approximateAgeMonths: approximateAgeMonths,
      colorMarkings: _emptyToNull(colorMarkings),
      currentWeightKg: currentWeightKg,
      notes: _emptyToNull(notes),
      thresholds: thresholds,
    );
    await _repository.saveAnimal(animal);
    if (completeOnboarding) {
      await _repository.saveSettings(state.snapshot.settings.copyWith(onboardingComplete: true));
    }
    await _reload(selectedAnimalId: animal.id);
    return animal;
  }

  Future<void> saveIdentifier(AnimalIdentifier identifier) async {
    await _repository.saveIdentifier(identifier);
    await _reload();
  }

  Future<void> saveRespiratorySession(RespiratorySession session) async {
    await _repository.saveRespiratorySession(session);
    await _reload();
  }

  Future<void> saveRespiratoryReminder(RespiratoryReminder reminder) async {
    if (!reminder.isValid) {
      throw ArgumentError.value(reminder, 'reminder', 'Reminder is incomplete.');
    }
    await _repository.saveRespiratoryReminder(reminder);
    await _reload(syncReminders: true);
  }

  Future<void> saveWeightReminder(WeightCheckReminder reminder) async {
    if (!reminder.isValid) {
      throw ArgumentError.value(reminder, 'reminder', 'Weight reminder is incomplete.');
    }
    await _repository.saveWeightReminder(reminder);
    await _reload(syncReminders: true);
  }

  Future<void> saveMedication(Medication medication, List<MedicationSchedule> schedules) async {
    final now = _clock().toUtc();
    final doses = _buildDoseEntries(medication, schedules, now);
    await _repository.saveMedication(medication, schedules, doses);
    await _reload(syncReminders: true);
  }

  List<DoseLedgerEntry> _buildDoseEntries(
    Medication medication,
    Iterable<MedicationSchedule> schedules,
    DateTime now,
  ) {
    if (!medication.active) {
      return const <DoseLedgerEntry>[];
    }
    final doses = <DoseLedgerEntry>[];
    for (final schedule in schedules.where((value) => value.enabled)) {
      final occurrences = _recurrence.generate(
        medication: medication,
        schedule: schedule,
        rangeStartUtc: now.subtract(const Duration(hours: 2)),
        rangeEndUtc: now.add(const Duration(days: 90)),
      );
      for (final occurrence in occurrences) {
        doses.add(
          DoseLedgerEntry(
            id: newId(),
            medicationId: medication.id,
            scheduleId: schedule.id,
            animalId: medication.animalId,
            createdAt: now,
            updatedAt: now,
            dueAt: occurrence.dueAtUtc,
            intendedLocalTime: occurrence.intendedLocalTime,
            timeZoneId: occurrence.timeZoneId,
            status: DoseStatus.unrecorded,
          ),
        );
      }
    }
    return doses;
  }

  Future<void> recordDose(
    String id,
    DoseStatus status, {
    DateTime? administeredAt,
    String? note,
  }) async {
    final current = state.snapshot.doseLedger.where((dose) => dose.id == id).firstOrNull;
    if (current == null) {
      return;
    }
    final at = _clock().toUtc();
    final updated = current.status == DoseStatus.unrecorded || current.status == DoseStatus.missed
        ? current.transition(to: status, at: at, administeredAt: administeredAt, note: note)
        : current
              .reopen(at: at)
              .transition(to: status, at: at, administeredAt: administeredAt, note: note);
    await _repository.saveDose(updated);
    await _reload(syncReminders: true);
  }

  Future<void> saveHealthRecord(HealthRecord record) async {
    await _repository.saveHealthRecord(record);
    await _reload();
  }

  Future<void> saveDocument(CareDocument document) async {
    await _repository.saveDocument(document);
    await _reload();
  }

  Future<NotificationPermissionState> requestNotifications() async {
    var permission = NotificationPermissionState.denied;
    try {
      permission = await _reminders.requestPermission();
    } on Object {
      // Treat an unavailable platform permission surface like a denial. The
      // due-dose ledger remains fully usable in-app.
    }
    await saveSettings(
      state.snapshot.settings.copyWith(
        notificationPermissionAsked: true,
        notificationsAllowed: permission == NotificationPermissionState.allowed,
      ),
      syncReminders: permission == NotificationPermissionState.allowed,
    );
    return permission;
  }

  Future<void> saveSettings(AppSettings settings, {bool syncReminders = false}) async {
    if (!const <int>[15, 20, 30, 60].contains(settings.defaultTimerSeconds)) {
      throw ArgumentError.value(
        settings.defaultTimerSeconds,
        'defaultTimerSeconds',
        'Unsupported timer choice.',
      );
    }
    final notificationSettingChanged =
        settings.notificationsAllowed != state.snapshot.settings.notificationsAllowed;
    await _repository.saveSettings(settings);
    await _reload(syncReminders: syncReminders || notificationSettingChanged);
  }

  Future<void> replaceSnapshot(CreaturelySnapshot snapshot) async {
    await _repository.replaceSnapshot(snapshot);
    await _reload(syncReminders: true);
  }

  Future<void> refresh({bool syncReminders = false}) => _reload(syncReminders: syncReminders);

  Future<void> deleteRecord(String kind, String id) async {
    await _repository.delete(kind, id);
    await _reload(syncReminders: true);
  }

  Future<bool> _rebaseSchedulesForTimeZone(String timeZoneId) async {
    final snapshot = state.snapshot;
    final now = _clock().toUtc();
    var changed = false;
    for (final medication in snapshot.medications) {
      final schedules = snapshot.medicationSchedules
          .where((schedule) => schedule.medicationId == medication.id)
          .toList(growable: false);
      if (schedules.isEmpty || schedules.every((schedule) => schedule.timeZoneId == timeZoneId)) {
        continue;
      }
      changed = true;
      final rebased = schedules
          .map((schedule) => schedule.copyWith(updatedAt: now, timeZoneId: timeZoneId))
          .toList(growable: false);
      await _repository.saveMedication(
        medication,
        rebased,
        _buildDoseEntries(medication, rebased, now),
      );
    }
    for (final reminder in snapshot.respiratoryReminders) {
      if (reminder.timeZoneId == timeZoneId) {
        continue;
      }
      changed = true;
      await _repository.saveRespiratoryReminder(
        reminder.copyWith(updatedAt: now, timeZoneId: timeZoneId),
      );
    }
    for (final reminder in snapshot.weightReminders) {
      if (reminder.timeZoneId == timeZoneId) {
        continue;
      }
      changed = true;
      await _repository.saveWeightReminder(
        reminder.copyWith(updatedAt: now, timeZoneId: timeZoneId),
      );
    }
    return changed;
  }

  List<TimelineItem> timeline({
    String? animalId,
    Set<String>? kinds,
    DateTime? start,
    DateTime? end,
  }) {
    final id = animalId ?? state.selectedAnimal?.id;
    if (id == null) {
      return const <TimelineItem>[];
    }
    final items = <TimelineItem>[
      ...state.snapshot.respiratorySessions
          .where((value) => value.animalId == id)
          .map(
            (value) => TimelineItem(
              id: value.id,
              animalId: id,
              at: value.recordedAt,
              kind: 'breathing',
              title: 'Resting breathing',
              detail:
                  '${formatRespiratoryRate(value.ratePerMinute)} breaths/min • '
                  '${value.context.name}',
              source: value,
            ),
          ),
      ...state.snapshot.medications
          .where((value) => value.animalId == id)
          .map(
            (value) => TimelineItem(
              id: value.id,
              animalId: id,
              at: value.createdAt,
              kind: 'medication',
              title: value.name,
              detail: '${value.doseAmount} ${value.doseUnit} • ${value.instructions}',
              source: value,
            ),
          ),
      ...state.snapshot.doseLedger.where((value) => value.animalId == id).map((value) {
        final name = state.snapshot.medications
            .where((medication) => medication.id == value.medicationId)
            .firstOrNull
            ?.name;
        return TimelineItem(
          id: value.id,
          animalId: id,
          at: value.dueAt,
          kind: 'dose',
          title: name ?? 'Medication dose',
          detail: value.status.name,
          source: value,
        );
      }),
      ...state.snapshot.healthRecords
          .where((value) => value.animalId == id && !value.archived)
          .map(
            (value) => TimelineItem(
              id: value.id,
              animalId: id,
              at: value.occurredAt,
              kind: value.kind.name,
              title: value.title,
              detail: _healthRecordDetail(value, state.snapshot.settings.weightUnit),
              source: value,
            ),
          ),
      ...state.snapshot.documents
          .where((value) => value.animalId == id && !value.archived)
          .map(
            (value) => TimelineItem(
              id: value.id,
              animalId: id,
              at: value.documentDate,
              kind: 'document',
              title: value.title,
              detail: value.category.name,
              source: value,
            ),
          ),
    ];
    items.removeWhere((item) {
      if (kinds != null && kinds.isNotEmpty && !kinds.contains(item.kind)) {
        return true;
      }
      if (item.source is CareDocument) {
        return (start != null && compareCalendarDates(item.at, start) < 0) ||
            (end != null && compareCalendarDates(item.at, end) > 0);
      }
      return (start != null && item.at.isBefore(start)) || (end != null && item.at.isAfter(end));
    });
    items.sort((a, b) => b.at.compareTo(a.at));
    return items;
  }

  String _healthRecordDetail(HealthRecord value, WeightUnit displayWeightUnit) {
    final canonicalValue = value.canonicalValue;
    if (canonicalValue == null) {
      return value.note ?? value.kind.name;
    }
    if (value.kind == HealthRecordKind.weight) {
      final weight = WeightValue.from(canonicalValue, WeightUnit.kilograms);
      return '${formatDisplayNumber(weight.inUnit(displayWeightUnit))} '
          '${weight.unitLabel(displayWeightUnit)}';
    }
    return '${formatDisplayNumber(canonicalValue)} ${value.canonicalUnit ?? ''}'.trim();
  }

  Future<void> _reload({String? selectedAnimalId, bool syncReminders = false}) async {
    var snapshot = await _repository.loadSnapshot();
    final maintained = _ledger.markOverdue(snapshot.doseLedger, now: _clock().toUtc());
    var ledgerChanged = false;
    for (var index = 0; index < maintained.length; index++) {
      if (maintained[index].status != snapshot.doseLedger[index].status) {
        ledgerChanged = true;
        await _repository.saveDose(maintained[index]);
      }
    }
    if (ledgerChanged) {
      snapshot = await _repository.loadSnapshot();
    }
    final preferred = selectedAnimalId ?? state.selectedAnimalId;
    final selected = snapshot.animals.any((animal) => animal.id == preferred && !animal.archived)
        ? preferred
        : snapshot.animals.where((animal) => !animal.archived).firstOrNull?.id;
    state = CreaturelyState(
      loading: false,
      snapshot: snapshot,
      selectedAnimalId: selected,
      pendingRoute: state.pendingRoute,
    );
    if (syncReminders) {
      await _synchronizeReminders(snapshot);
    }
  }

  Future<void> _synchronizeReminders(CreaturelySnapshot snapshot) async {
    try {
      if (snapshot.settings.notificationsAllowed) {
        await _reminders.sync(snapshot, _clock().toUtc());
      } else {
        await _reminders.clear();
      }
    } on Object {
      // OS scheduling can be unavailable, revoked, or transiently fail. Local
      // medication data is authoritative and must remain accessible.
    }
  }

  String? _emptyToNull(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
