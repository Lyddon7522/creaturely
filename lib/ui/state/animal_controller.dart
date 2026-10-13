import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models.dart';
import 'care_controller.dart';
import 'command_controller.dart';
import 'dependencies.dart';
import 'media_controller.dart';
import 'query_providers.dart';

final animalControllerProvider = AsyncNotifierProvider<AnimalController, void>(
  AnimalController.new,
);

class AnimalController extends CommandController {
  String newId() => const Uuid().v4();

  Future<void> saveAnimal(Animal animal) => _save(animal);

  Future<void> _save(Animal animal, {bool completeOnboarding = false}) async {
    final repository = ref.read(repositoryProvider);
    final documents = animal.photoPath == null
        ? null
        : await ref.read(documentStorageProvider.future);
    if (!ref.mounted) throw StateError('The save was cancelled.');
    Future<void> persist() => repository.exclusive(() async {
      await repository.saveAnimal(animal);
      if (completeOnboarding) {
        await repository.saveSettings(
          (await repository.database.readSettings()).copyWith(onboardingComplete: true),
        );
      }
    });
    Future<void> command() => run(() async {
      if (documents == null) {
        await persist();
      } else {
        await documents.exclusiveFiles(persist);
      }
      if (!ref.mounted) return;
      if (ref.exists(documentStorageProvider)) {
        unawaited(ref.read(attachmentCleanupProvider.notifier).collect());
      }
      ref.read(selectedAnimalProvider.notifier).selectAnimal(animal.id);
      await ref.read(reminderSyncProvider.notifier).synchronize();
    });
    if (documents == null) {
      await command();
    } else {
      await documents.withLease([animal.photoPath!], command);
    }
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
    final now = ref.read(wallClockProvider)().toUtc();
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
    await _save(animal, completeOnboarding: completeOnboarding);
    return animal;
  }

  Future<void> saveIdentifier(AnimalIdentifier identifier) =>
      run(() => ref.read(repositoryProvider).saveIdentifier(identifier));
  Future<void> deleteIdentifier(String id) =>
      run(() => ref.read(repositoryProvider).delete(RecordKind.identifier, id));

  String? _emptyToNull(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
