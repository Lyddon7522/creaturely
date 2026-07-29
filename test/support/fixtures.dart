import 'dart:typed_data';

import 'package:creaturely/domain/models.dart';
import 'package:crypto/crypto.dart';

final DateTime fixtureTime = DateTime.utc(2026, 3, 7, 12);
final Uint8List fixtureAttachment = Uint8List.fromList(<int>[1, 3, 3, 7, 42]);
final String fixtureChecksum = sha256.convert(fixtureAttachment).toString();

Animal fixtureAnimal({String id = 'animal-1', String name = 'Moss', String species = 'Axolotl'}) =>
    Animal(
      id: id,
      createdAt: fixtureTime,
      updatedAt: fixtureTime,
      name: name,
      species: species,
      breed: 'Leucistic',
      sexOrStatus: 'Unknown',
      approximateAgeMonths: 18,
      colorMarkings: 'Pink with dark eyes',
      currentWeightKg: 0.12,
      notes: 'Likes the shaded hide.',
      thresholds: const RespiratoryThresholds(minimum: 8, target: 16, maximum: 28),
    );

Medication fixtureMedication() => Medication(
  id: 'med-1',
  animalId: 'animal-1',
  createdAt: fixtureTime,
  updatedAt: fixtureTime,
  name: 'Supportive care',
  form: 'Liquid',
  doseAmount: 0.4,
  doseUnit: 'mL',
  instructions: 'Give with food',
  startDate: fixtureTime,
  prescriber: 'Dr. Rivera',
  notes: 'Keeper-entered instruction.',
);

MedicationSchedule fixtureSchedule() => MedicationSchedule(
  id: 'schedule-1',
  medicationId: 'med-1',
  animalId: 'animal-1',
  createdAt: fixtureTime,
  updatedAt: fixtureTime,
  kind: ScheduleKind.daily,
  timeZoneId: 'America/Chicago',
  times: const <LocalClockTime>[LocalClockTime(8, 30)],
);

RespiratoryReminder fixtureRespiratoryReminder() => RespiratoryReminder(
  id: 'respiratory-reminder-1',
  animalId: 'animal-1',
  createdAt: fixtureTime,
  updatedAt: fixtureTime,
  startDate: DateTime.utc(2026, 3, 7),
  context: RespiratoryContext.sleeping,
  recurrence: ReminderRecurrence.daily,
  timeZoneId: 'America/Chicago',
  times: const <LocalClockTime>[LocalClockTime(21, 0)],
);

WeightCheckReminder fixtureWeightReminder() => WeightCheckReminder(
  id: 'weight-reminder-1',
  animalId: 'animal-1',
  createdAt: fixtureTime,
  updatedAt: fixtureTime,
  startDate: DateTime.utc(2026, 3, 7),
  recurrence: ReminderRecurrence.daily,
  timeZoneId: 'America/Chicago',
  times: const <LocalClockTime>[LocalClockTime(10, 0)],
);

DoseLedgerEntry fixtureDose({DoseStatus status = DoseStatus.given}) => DoseLedgerEntry(
  id: 'dose-1',
  medicationId: 'med-1',
  scheduleId: 'schedule-1',
  animalId: 'animal-1',
  createdAt: fixtureTime,
  updatedAt: fixtureTime,
  dueAt: DateTime.utc(2026, 3, 8, 14, 30),
  intendedLocalTime: '2026-03-08T08:30',
  timeZoneId: 'America/Chicago',
  status: status,
  administeredAt: status == DoseStatus.given ? DateTime.utc(2026, 3, 8, 14, 35) : null,
  note: 'Taken calmly.',
);

CreaturelySnapshot fixtureSnapshot({String storedPath = '/managed/rabies.pdf'}) =>
    CreaturelySnapshot(
      schemaVersion: CreaturelySnapshot.currentSchemaVersion,
      exportedAt: fixtureTime,
      animals: <Animal>[fixtureAnimal()],
      identifiers: <AnimalIdentifier>[
        AnimalIdentifier(
          id: 'identifier-1',
          animalId: 'animal-1',
          createdAt: fixtureTime,
          updatedAt: fixtureTime,
          type: 'Band',
          value: 'A-42',
          issuer: 'Local rescue',
          url: 'https://example.invalid/registry/A-42',
          phone: '+1 555 010 0042',
          issuedOn: DateTime.utc(2025, 8, 1),
          notes: 'Generic identifier.',
        ),
      ],
      respiratorySessions: <RespiratorySession>[
        RespiratorySession(
          id: 'breathing-1',
          animalId: 'animal-1',
          createdAt: fixtureTime,
          updatedAt: fixtureTime,
          recordedAt: DateTime.utc(2026, 3, 8, 6),
          durationMilliseconds: 30000,
          breathCount: 10,
          ratePerMinute: 20,
          context: RespiratoryContext.resting,
          note: 'Quiet after lights out.',
          thresholdSnapshot: const RespiratoryThresholds(minimum: 8, target: 16, maximum: 28),
        ),
      ],
      respiratoryReminders: <RespiratoryReminder>[fixtureRespiratoryReminder()],
      weightReminders: <WeightCheckReminder>[fixtureWeightReminder()],
      medications: <Medication>[fixtureMedication()],
      medicationSchedules: <MedicationSchedule>[fixtureSchedule()],
      doseLedger: <DoseLedgerEntry>[fixtureDose()],
      healthRecords: <HealthRecord>[
        HealthRecord(
          id: 'weight-1',
          animalId: 'animal-1',
          createdAt: fixtureTime,
          updatedAt: fixtureTime,
          occurredAt: DateTime.utc(2026, 3, 8, 7),
          kind: HealthRecordKind.weight,
          title: 'Weigh-in',
          canonicalValue: 0.12,
          canonicalUnit: 'kg',
          enteredUnit: 'lb',
          note: 'Before breakfast.',
        ),
      ],
      documents: <CareDocument>[
        CareDocument(
          id: 'document-1',
          animalId: 'animal-1',
          createdAt: fixtureTime,
          updatedAt: fixtureTime,
          documentDate: DateTime.utc(2026, 3, 8),
          title: 'Rabies certificate',
          category: DocumentCategory.vaccination,
          storedPath: storedPath,
          mediaType: 'application/pdf',
          checksumSha256: fixtureChecksum,
          byteLength: fixtureAttachment.length,
          notes: 'Original supplied by clinic.',
          expiryDate: DateTime.utc(2027, 3, 8),
        ),
      ],
      settings: const AppSettings(
        onboardingComplete: true,
        weightUnit: WeightUnit.pounds,
        notificationsAllowed: true,
      ),
    );
