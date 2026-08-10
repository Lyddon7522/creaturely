import 'package:creaturely/domain/models.dart';
import 'package:creaturely/domain/trends.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fixtures.dart';

void main() {
  test('canonical JSON round-trip preserves every v1 record and raw value', () {
    final source = fixtureSnapshot();
    final restored = CreaturelySnapshot.decode(source.toCanonicalJson());

    expect(restored.toJson(), source.toJson());
    expect(restored.animals.single.species, 'Axolotl');
    expect(restored.respiratorySessions.single.breathCount, 10);
    expect(restored.respiratorySessions.single.durationMilliseconds, 30000);
    expect(restored.healthRecords.single.canonicalValue, 0.12);
    expect(restored.medicationSchedules.single.timeZoneId, 'America/Chicago');
    expect(restored.medications.single.strength, '20 mg/mL');
    expect(restored.medications.single.pharmacy, 'Lakeside Veterinary Pharmacy');
    expect(restored.medications.single.prescriptionNumber, 'RX-042');
    expect(restored.medications.single.refillsRemaining, 2);
    expect(restored.medications.single.nextRefillDate, DateTime.utc(2026, 4, 1));
    expect(restored.respiratoryReminders.single.context, RespiratoryContext.sleeping);
    expect(restored.weightReminders.single.recurrence, ReminderRecurrence.daily);
  });

  test('chart points and accessible table source share the same ordered data', () {
    final snapshot = fixtureSnapshot();
    final builder = const TrendDataBuilder();
    final respiratory = builder.respiratory(snapshot, 'animal-1');
    final weight = builder.weight(snapshot, 'animal-1', WeightUnit.pounds);

    expect(respiratory.single.id, 'breathing-1');
    expect(respiratory.single.rawValue, 10);
    expect(respiratory.single.rawUnit, 'breaths in 30 seconds');
    expect(weight.single.id, 'weight-1');
    expect(weight.single.rawValue, closeTo(0.2645547, 0.0000001));
    expect(weight.single.rawUnit, 'lb');
  });

  test('invalid typed JSON is rejected instead of silently coerced', () {
    final json = fixtureSnapshot().toJson();
    json['schemaVersion'] = 'two';
    expect(() => CreaturelySnapshot.fromJson(json), throwsA(isA<TypeError>()));
  });

  test('calendar-only fields serialize without a timezone or date shift', () {
    final json = fixtureSnapshot().toJson();

    expect((json['identifiers'] as List<Object?>).single, isA<Map<String, Object?>>());
    expect(
      ((json['identifiers'] as List<Object?>).single as Map<String, Object?>)['issuedOn'],
      '2025-08-01',
    );
    expect(
      ((json['medications'] as List<Object?>).single as Map<String, Object?>)['startDate'],
      '2026-03-07',
    );
    expect(
      ((json['medications'] as List<Object?>).single as Map<String, Object?>)['nextRefillDate'],
      '2026-04-01',
    );
    final document = (json['documents'] as List<Object?>).single as Map<String, Object?>;
    expect(document['documentDate'], '2026-03-08');
    expect(document['expiryDate'], '2027-03-08');
    expect(document, isNot(contains('reminderAt')));

    final restored = CreaturelySnapshot.fromJson(json);
    expect(restored.identifiers.single.issuedOn, DateTime.utc(2025, 8, 1));
    expect(restored.documents.single.documentDate, DateTime.utc(2026, 3, 8));
    expect(
      calendarDateIsWithin(
        restored.documents.single.documentDate,
        DateTime(2026, 3, 8, 23),
        DateTime(2026, 3, 8),
      ),
      isTrue,
    );
  });

  test('invalid calendar-only values are rejected', () {
    final json = fixtureSnapshot().toJson();
    final documents = json['documents'] as List<Object?>;
    (documents.single as Map<String, Object?>)['documentDate'] = '2026-02-31';

    expect(() => CreaturelySnapshot.fromJson(json), throwsA(isA<FormatException>()));
  });
}
