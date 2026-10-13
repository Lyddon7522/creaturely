import 'models.dart';

class MedicationTimelineProjection {
  const MedicationTimelineProjection();

  bool belongsInHistory(DoseLedgerEntry dose, {required DateTime now}) =>
      dose.status != DoseStatus.unrecorded || !dose.dueAt.isAfter(now.toUtc());
}
