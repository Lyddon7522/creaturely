import 'models.dart';

class MedicationTimelineProjection {
  const MedicationTimelineProjection();

  bool belongsInHistory(DoseLedgerEntry dose, {required DateTime now}) =>
      dose.status != DoseStatus.unrecorded || !dose.dueAt.isAfter(now.toUtc());

  List<DoseLedgerEntry> nextByMedication(
    Iterable<DoseLedgerEntry> entries, {
    required DateTime now,
    int limit = 3,
  }) {
    final upcoming = _futureUnrecorded(entries, now: now);
    final seenMedicationIds = <String>{};
    return upcoming
        .where((dose) => seenMedicationIds.add(dose.medicationId))
        .take(limit)
        .toList(growable: false);
  }

  List<DoseLedgerEntry> upcomingWindow(
    Iterable<DoseLedgerEntry> entries, {
    required DateTime now,
    Duration window = const Duration(days: 7),
  }) {
    final end = now.toUtc().add(window);
    return _futureUnrecorded(
      entries,
      now: now,
    ).where((dose) => !dose.dueAt.isAfter(end)).toList(growable: false);
  }

  List<DoseLedgerEntry> _futureUnrecorded(
    Iterable<DoseLedgerEntry> entries, {
    required DateTime now,
  }) {
    final utcNow = now.toUtc();
    final result =
        entries
            .where((dose) => dose.status == DoseStatus.unrecorded && dose.dueAt.isAfter(utcNow))
            .toList(growable: false)
          ..sort((a, b) => a.dueAt.compareTo(b.dueAt));
    return result;
  }
}
