import '../../domain/models.dart';
import '../../domain/units.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../l10n/model_labels.dart';
import '../state/query_providers.dart';

class TimelineProjection {
  const TimelineProjection(this.strings);

  final AppLocalizations strings;
  List<TimelineItem> timeline(
    JournalView journal, {
    String? animalId,
    Set<String>? kinds,
    DateTime? start,
    DateTime? end,
  }) {
    final id = animalId;
    if (id == null) {
      return const <TimelineItem>[];
    }
    final items = <TimelineItem>[
      ...journal.respiratorySessions
          .where((value) => value.animalId == id)
          .map(
            (value) => TimelineItem(
              id: value.id,
              animalId: id,
              at: value.recordedAt,
              kind: 'breathing',
              title: strings.respiratoryRate,
              detail: strings.timelineBreathingDetail(
                formatRespiratoryRate(value.ratePerMinute),
                strings.respiratoryContext(value.context),
              ),
              source: value,
            ),
          ),
      ...journal.medications
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
      ...journal.doseLedger.where((value) => value.animalId == id).map((value) {
        final name = journal.medications
            .where((medication) => medication.id == value.medicationId)
            .firstOrNull
            ?.name;
        return TimelineItem(
          id: value.id,
          animalId: id,
          at: value.dueAt,
          kind: 'dose',
          title: name ?? strings.medicationDose,
          detail: strings.doseStatus(value.status),
          source: value,
        );
      }),
      ...journal.healthRecords
          .where((value) => value.animalId == id && !value.archived)
          .map(
            (value) => TimelineItem(
              id: value.id,
              animalId: id,
              at: value.occurredAt,
              kind: value.kind.name,
              title: value.title,
              detail: _healthRecordDetail(value, journal.settings.weightUnit),
              source: value,
            ),
          ),
      ...journal.documents
          .where((value) => value.animalId == id && !value.archived)
          .map(
            (value) => TimelineItem(
              id: value.id,
              animalId: id,
              at: value.documentDate,
              kind: 'document',
              title: value.title,
              detail: strings.documentCategory(value.category),
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
      return value.note ?? strings.healthKind(value.kind);
    }
    if (value.kind == HealthRecordKind.weight) {
      final weight = WeightValue.from(canonicalValue, WeightUnit.kilograms);
      return '${formatDisplayNumber(weight.inUnit(displayWeightUnit))} '
          '${weight.unitLabel(displayWeightUnit)}';
    }
    return '${formatDisplayNumber(canonicalValue)} ${value.canonicalUnit ?? ''}'.trim();
  }
}
