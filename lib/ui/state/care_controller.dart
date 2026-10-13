import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../data/repository.dart';
import '../../domain/models.dart';
import '../../domain/recurrence.dart';
import '../../l10n/app_strings.dart';
import 'command_controller.dart';
import 'dependencies.dart';
import 'media_controller.dart';

final careControllerProvider = AsyncNotifierProvider<CareController, void>(CareController.new);
final reminderSyncProvider = AsyncNotifierProvider<ReminderSyncController, void>(
  ReminderSyncController.new,
);

class CareController extends CommandController {
  String newId() => const Uuid().v4();
  Future<void> saveRespiratorySession(RespiratorySession session) => run(() async {
    await ref.read(repositoryProvider).saveRespiratorySession(session);
  });

  Future<void> saveRespiratoryReminder(RespiratoryReminder reminder) => run(() async {
    if (!reminder.isValid) {
      throw ArgumentError.value(reminder, 'reminder', appStrings.reminderIsIncomplete);
    }
    await ref.read(repositoryProvider).saveRespiratoryReminder(reminder);
    if (ref.mounted) await ref.read(reminderSyncProvider.notifier).synchronize();
  });

  Future<void> saveWeightReminder(WeightCheckReminder reminder) => run(() async {
    if (!reminder.isValid) {
      throw ArgumentError.value(reminder, 'reminder', appStrings.weightReminderIsIncomplete);
    }
    await ref.read(repositoryProvider).saveWeightReminder(reminder);
    if (ref.mounted) await ref.read(reminderSyncProvider.notifier).synchronize();
  });

  Future<void> saveMedication(Medication medication, List<MedicationSchedule> schedules) =>
      run(() async {
        final now = ref.read(wallClockProvider)().toUtc();
        final doses = _buildDoseEntries(medication, schedules, now);
        final repository = ref.read(repositoryProvider);
        await repository.exclusive(() async {
          await repository.database.markOverdue(now);
          await repository.saveMedication(medication, schedules, doses);
        });
        if (ref.mounted) await ref.read(reminderSyncProvider.notifier).synchronize();
      });

  List<DoseLedgerEntry> _buildDoseEntries(
    Medication medication,
    Iterable<MedicationSchedule> schedules,
    DateTime now, {
    DateTime? rangeStart,
  }) {
    if (!medication.active) {
      return const <DoseLedgerEntry>[];
    }
    final doses = <DoseLedgerEntry>[];
    for (final schedule in schedules.where((value) => value.enabled)) {
      final occurrences = const RecurrenceEngine().generate(
        medication: medication,
        schedule: schedule,
        rangeStartUtc: rangeStart ?? now.subtract(const Duration(hours: 2)),
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
    bool clearNote = false,
  }) => run(() async {
    final repository = ref.read(repositoryProvider);
    final at = ref.read(wallClockProvider)().toUtc();
    final changed = await repository.exclusive(() async {
      final current = await repository.database.findDose(id);
      if (current == null) {
        return false;
      }
      if (current.status == status && administeredAt == null && note == null && !clearNote) {
        return false;
      }
      final recordedAt =
          administeredAt ??
          (current.status == DoseStatus.given && status == DoseStatus.given
              ? current.administeredAt
              : null);
      final updated = current.status == DoseStatus.unrecorded || current.status == DoseStatus.missed
          ? current.transition(
              to: status,
              at: at,
              administeredAt: recordedAt,
              note: note,
              clearNote: clearNote,
            )
          : current
                .reopen(at: at)
                .transition(
                  to: status,
                  at: at,
                  administeredAt: recordedAt,
                  note: note,
                  clearNote: clearNote,
                );
      await repository.saveDose(updated);
      return true;
    });
    if (changed && ref.mounted) await ref.read(reminderSyncProvider.notifier).synchronize();
  });

  Future<void> reopenDose(String id, {String? note, bool clearNote = false}) => run(() async {
    final repository = ref.read(repositoryProvider);
    final at = ref.read(wallClockProvider)().toUtc();
    final changed = await repository.exclusive(() async {
      final dose = await repository.database.findDose(id);
      if (dose == null) return false;
      await repository.saveDose(dose.reopen(at: at).copyWith(note: note, clearNote: clearNote));
      return true;
    });
    if (changed && ref.mounted) await ref.read(reminderSyncProvider.notifier).synchronize();
  });

  Future<void> saveHealthRecord(HealthRecord record) => run(() async {
    await ref.read(repositoryProvider).saveHealthRecord(record);
  });

  Future<void> saveDocument(CareDocument document) async {
    final repository = ref.read(repositoryProvider);
    final documents = await ref.read(documentStorageProvider.future);
    if (!ref.mounted) throw StateError('The save was cancelled.');
    await documents.withLease(
      [document.storedPath],
      () => run(() async {
        await documents.exclusiveFiles(() => repository.saveDocument(document));
        if (ref.mounted) unawaited(ref.read(attachmentCleanupProvider.notifier).collect());
      }),
    );
  }

  Future<void> _rebaseSchedulesForTimeZone(
    CreaturelyRepository repository,
    String timeZoneId,
    DateTime now,
  ) async {
    final care = await repository.database.readCareData();
    for (final medication in care.medications) {
      final schedules = care.medicationSchedules
          .where((schedule) => schedule.medicationId == medication.id)
          .toList(growable: false);
      if (schedules.isEmpty || schedules.every((schedule) => schedule.timeZoneId == timeZoneId)) {
        continue;
      }
      final rebased = schedules
          .map((schedule) => schedule.copyWith(updatedAt: now, timeZoneId: timeZoneId))
          .toList(growable: false);
      await repository.saveMedication(
        medication,
        rebased,
        _buildDoseEntries(medication, rebased, now),
      );
    }
    for (final reminder in care.respiratoryReminders) {
      if (reminder.timeZoneId == timeZoneId) {
        continue;
      }
      await repository.saveRespiratoryReminder(
        reminder.copyWith(updatedAt: now, timeZoneId: timeZoneId),
      );
    }
    for (final reminder in care.weightReminders) {
      if (reminder.timeZoneId == timeZoneId) {
        continue;
      }
      await repository.saveWeightReminder(
        reminder.copyWith(updatedAt: now, timeZoneId: timeZoneId),
      );
    }
  }

  Future<void> maintain({String? timeZoneId, bool syncReminders = true}) => run(() async {
    final repository = ref.read(repositoryProvider);
    final now = ref.read(wallClockProvider)().toUtc();
    await repository.exclusive(() async {
      await repository.database.markOverdue(now);
      if (timeZoneId != null) await _rebaseSchedulesForTimeZone(repository, timeZoneId, now);
      final care = await repository.database.readCareData();
      final active = care.animals
          .where((animal) => !animal.archived)
          .map((animal) => animal.id)
          .toSet();
      final generated = <DoseLedgerEntry>[];
      for (final medication in care.medications.where(
        (item) => item.active && active.contains(item.animalId),
      )) {
        final previousEnd = await repository.database.lastPlannedDose(medication.id);
        final recent = now.subtract(const Duration(hours: 2));
        generated.addAll(
          _buildDoseEntries(
            medication,
            care.medicationSchedules.where((schedule) => schedule.medicationId == medication.id),
            now,
            rangeStart: previousEnd != null && previousEnd.isBefore(recent) ? previousEnd : recent,
          ),
        );
      }
      await repository.ensureDoseHorizon(generated, now);
    });
    if (ref.mounted && syncReminders) await ref.read(reminderSyncProvider.notifier).synchronize();
  });

  Future<void> deleteRecord(RecordKind kind, String id) => run(() async {
    await ref.read(repositoryProvider).delete(kind, id);
    if (ref.mounted && kind == RecordKind.document) {
      unawaited(ref.read(attachmentCleanupProvider.notifier).collect());
    }
    if ({
      RecordKind.medication,
      RecordKind.respiratoryReminder,
      RecordKind.weightReminder,
    }.contains(kind)) {
      if (ref.mounted) await ref.read(reminderSyncProvider.notifier).synchronize();
    }
  });
}

class ReminderSyncController extends AsyncNotifier<void> {
  @override
  void build() {}
  Future<void> _tail = Future.value();

  void reportError(Object error, StackTrace stack) {
    if (ref.mounted) state = AsyncError(error, stack);
  }

  Future<void> synchronize() {
    // Read after preceding work completes, so queued requests cannot install an
    // old snapshot over newer settings. Failures are observable, never fatal to a save.
    if (!ref.mounted) return Future.value();
    final work = _tail.then((_) async {
      if (!ref.mounted) return;
      state = const AsyncLoading();
      try {
        final care = await ref.read(repositoryProvider).database.readCareData();
        if (!ref.mounted) return;
        final reminders = ref.read(reminderServiceProvider);
        if (care.settings.notificationsAllowed) {
          await reminders.sync(care, ref.read(wallClockProvider)().toUtc());
        } else {
          await reminders.clear();
        }
        if (ref.mounted) state = const AsyncData(null);
      } on Object catch (error, stack) {
        if (ref.mounted) state = AsyncError(error, stack);
      }
    });
    _tail = work;
    return work;
  }
}
