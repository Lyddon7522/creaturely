import '../domain/models.dart';
import 'generated/app_localizations.dart';

/// Presentation labels stay separate from the stable enum names in backups and CSV.
extension ModelLabels on AppLocalizations {
  String respiratoryContext(RespiratoryContext value) => switch (value) {
    RespiratoryContext.sleeping => sleeping,
    RespiratoryContext.resting => resting,
  };

  String doseStatus(DoseStatus value) => switch (value) {
    DoseStatus.given => given,
    DoseStatus.skipped => skipped,
    DoseStatus.missed => missed,
    DoseStatus.unrecorded => notRecorded,
  };

  String documentCategory(DocumentCategory value) => switch (value) {
    DocumentCategory.vaccination => categoryVaccination,
    DocumentCategory.laboratory => categoryLaboratory,
    DocumentCategory.imaging => categoryImaging,
    DocumentCategory.prescription => categoryPrescription,
    DocumentCategory.insurance => categoryInsurance,
    DocumentCategory.identification => categoryIdentification,
    DocumentCategory.other => other,
  };

  String healthKind(HealthRecordKind value) => switch (value) {
    HealthRecordKind.weight => weight,
    HealthRecordKind.allergy => healthAllergy,
    HealthRecordKind.condition => healthCondition,
    HealthRecordKind.observation => observation,
  };
}
