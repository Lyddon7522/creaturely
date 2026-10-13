import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderOrFamily;

import '../../domain/models.dart';
import 'dependencies.dart';

final selectedAnimalProvider = NotifierProvider<SelectedAnimalController, String?>(
  SelectedAnimalController.new,
);

class SelectedAnimalController extends Notifier<String?> {
  @override
  String? build() => null;
  void selectAnimal(String id) => state = id;
}

final settingsProvider = StreamProvider<AppSettings>(
  (ref) => ref.watch(repositoryProvider).database.watchSettings(),
  retry: (retryCount, error) => null,
);
final animalsProvider = StreamProvider.autoDispose.family<List<Animal>, String?>(
  (ref, animalId) => ref.watch(repositoryProvider).database.watchAnimals(animalId: animalId),
  retry: (retryCount, error) => null,
);
final identifiersProvider = StreamProvider.autoDispose.family<List<AnimalIdentifier>, String?>(
  (ref, animalId) => ref.watch(repositoryProvider).database.watchIdentifiers(animalId: animalId),
  retry: (retryCount, error) => null,
);
final sessionsProvider = StreamProvider.autoDispose.family<List<RespiratorySession>, String?>(
  (ref, animalId) => ref.watch(repositoryProvider).database.watchSessions(animalId: animalId),
  retry: (retryCount, error) => null,
);
final latestSessionProvider = StreamProvider.autoDispose.family<List<RespiratorySession>, String?>(
  (ref, animalId) =>
      ref.watch(repositoryProvider).database.watchSessions(animalId: animalId, limit: 1),
  retry: (retryCount, error) => null,
);
final respiratoryRemindersProvider = StreamProvider.autoDispose
    .family<List<RespiratoryReminder>, String?>(
      (ref, animalId) =>
          ref.watch(repositoryProvider).database.watchRespiratoryReminders(animalId: animalId),
      retry: (retryCount, error) => null,
    );
final weightRemindersProvider = StreamProvider.autoDispose
    .family<List<WeightCheckReminder>, String?>(
      (ref, animalId) =>
          ref.watch(repositoryProvider).database.watchWeightReminders(animalId: animalId),
      retry: (retryCount, error) => null,
    );
final medicationsProvider = StreamProvider.autoDispose.family<List<Medication>, String?>(
  (ref, animalId) => ref.watch(repositoryProvider).database.watchMedications(animalId: animalId),
  retry: (retryCount, error) => null,
);
final schedulesProvider = StreamProvider.autoDispose.family<List<MedicationSchedule>, String?>(
  (ref, animalId) => ref.watch(repositoryProvider).database.watchSchedules(animalId: animalId),
  retry: (retryCount, error) => null,
);
final dosesProvider = StreamProvider.autoDispose.family<List<DoseLedgerEntry>, String?>(
  (ref, animalId) => ref.watch(repositoryProvider).database.watchDoses(animalId: animalId),
  retry: (retryCount, error) => null,
);
final healthRecordsProvider = StreamProvider.autoDispose.family<List<HealthRecord>, String?>(
  (ref, animalId) => ref.watch(repositoryProvider).database.watchHealthRecords(animalId: animalId),
  retry: (retryCount, error) => null,
);
final documentsProvider = StreamProvider.autoDispose.family<List<CareDocument>, String?>(
  (ref, animalId) => ref.watch(repositoryProvider).database.watchDocuments(animalId: animalId),
  retry: (retryCount, error) => null,
);

enum JournalFeature {
  animals,
  animalForm,
  timeline,
  trends,
  schedule,
  medication,
  health,
  document,
  respiratory,
  respiratoryReminder,
  weightReminder,
  data,
}

typedef JournalQuery = ({JournalFeature feature, String? animalId});

final journalViewProvider = Provider.autoDispose.family<JournalView, JournalQuery>((ref, query) {
  final animalQuery = animalsProvider(query.animalId);
  final animals = ref.watch(animalQuery);
  final selectedId = query.animalId ?? ref.watch(selectedAnimalProvider);
  final selected =
      animals.value
          ?.where(
            (animal) => animal.id == selectedId && (query.animalId != null || !animal.archived),
          )
          .firstOrNull ??
      animals.value?.where((animal) => !animal.archived).firstOrNull;
  final scope = query.animalId ?? selected?.id;
  var loading = animals.isLoading;
  Object? error = animals.error;
  final failed = <ProviderOrFamily>[if (animals.hasError) animalQuery];
  var settings = const AppSettings();
  if (query.feature != JournalFeature.document && query.feature != JournalFeature.data) {
    final preferences = ref.watch(settingsProvider);
    loading = loading || preferences.isLoading;
    error ??= preferences.error;
    if (preferences.hasError) failed.add(settingsProvider);
    settings = preferences.value ?? settings;
  }
  List<T> read<T>(
    StreamProvider<List<T>> provider,
    Set<JournalFeature> features, {
    bool requireAnimal = true,
  }) {
    if (!features.contains(query.feature) || (requireAnimal && scope == null)) return const [];
    final value = ref.watch(provider);
    loading = loading || value.isLoading;
    error ??= value.error;
    if (value.hasError) failed.add(provider);
    return value.value ?? const [];
  }

  final identifiers = query.animalId == null
      ? const <AnimalIdentifier>[]
      : read(identifiersProvider(scope), {JournalFeature.animalForm});
  final sessions = read(
    query.feature == JournalFeature.animals
        ? latestSessionProvider(scope)
        : sessionsProvider(scope),
    {JournalFeature.animals, JournalFeature.timeline, JournalFeature.trends},
  );
  final respiratoryReminders = read(respiratoryRemindersProvider(scope), {
    JournalFeature.schedule,
    JournalFeature.respiratoryReminder,
  });
  final weightReminders = read(weightRemindersProvider(scope), {
    JournalFeature.schedule,
    JournalFeature.weightReminder,
  });
  final medications = read(medicationsProvider(scope), {
    JournalFeature.animals,
    JournalFeature.timeline,
    JournalFeature.trends,
    JournalFeature.schedule,
    JournalFeature.medication,
  });
  final schedules = read(schedulesProvider(scope), {
    JournalFeature.schedule,
    JournalFeature.medication,
  });
  final doses = read(dosesProvider(scope), {
    JournalFeature.animals,
    JournalFeature.timeline,
    JournalFeature.trends,
    JournalFeature.schedule,
    JournalFeature.medication,
  });
  final healthRecords = read(healthRecordsProvider(scope), {
    JournalFeature.timeline,
    JournalFeature.trends,
    JournalFeature.health,
  });
  final documents = read(documentsProvider(query.feature == JournalFeature.data ? null : scope), {
    JournalFeature.timeline,
    JournalFeature.document,
    JournalFeature.data,
  }, requireAnimal: query.feature != JournalFeature.data);
  return JournalView(
    loading: loading,
    error: error,
    failedQueries: failed,
    selectedAnimalId: selected?.id,
    animals: animals.value ?? const [],
    settings: settings,
    identifiers: identifiers,
    respiratorySessions: sessions,
    respiratoryReminders: respiratoryReminders,
    weightReminders: weightReminders,
    medications: medications,
    medicationSchedules: schedules,
    doseLedger: doses,
    healthRecords: healthRecords,
    documents: documents,
  );
});

/// A render-only model. It cannot be serialized or mistaken for a complete backup.
class JournalView {
  JournalView({
    required this.loading,
    required List<Animal> animals,
    required this.settings,
    required List<AnimalIdentifier> identifiers,
    required List<RespiratorySession> respiratorySessions,
    required List<RespiratoryReminder> respiratoryReminders,
    required List<WeightCheckReminder> weightReminders,
    required List<Medication> medications,
    required List<MedicationSchedule> medicationSchedules,
    required List<DoseLedgerEntry> doseLedger,
    required List<HealthRecord> healthRecords,
    required List<CareDocument> documents,
    required List<ProviderOrFamily> failedQueries,
    this.selectedAnimalId,
    this.error,
  }) : _failedQueries = List.unmodifiable(failedQueries),
       animals = List.unmodifiable(animals),
       identifiers = List.unmodifiable(identifiers),
       respiratorySessions = List.unmodifiable(respiratorySessions),
       respiratoryReminders = List.unmodifiable(respiratoryReminders),
       weightReminders = List.unmodifiable(weightReminders),
       medications = List.unmodifiable(medications),
       medicationSchedules = List.unmodifiable(medicationSchedules),
       doseLedger = List.unmodifiable(doseLedger),
       healthRecords = List.unmodifiable(healthRecords),
       documents = List.unmodifiable(documents);

  final bool loading;
  final Object? error;
  final String? selectedAnimalId;
  final List<Animal> animals;
  final AppSettings settings;
  final List<AnimalIdentifier> identifiers;
  final List<RespiratorySession> respiratorySessions;
  final List<RespiratoryReminder> respiratoryReminders;
  final List<WeightCheckReminder> weightReminders;
  final List<Medication> medications;
  final List<MedicationSchedule> medicationSchedules;
  final List<DoseLedgerEntry> doseLedger;
  final List<HealthRecord> healthRecords;
  final List<CareDocument> documents;
  final List<ProviderOrFamily> _failedQueries;

  void retry(WidgetRef ref) {
    for (final query in _failedQueries) {
      ref.invalidate(query);
    }
  }

  List<Animal> get activeAnimals => List.unmodifiable(animals.where((animal) => !animal.archived));
  Animal? get selectedAnimal =>
      animals.where((animal) => animal.id == selectedAnimalId).firstOrNull;
}
