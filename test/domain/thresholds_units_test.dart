import 'package:creaturely/domain/models.dart';
import 'package:creaturely/domain/trends.dart';
import 'package:creaturely/domain/units.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('thresholds are owner-configured, ordered, and neutrally described', () {
    const none = RespiratoryThresholds();
    expect(none.describe(200), ThresholdBand.notConfigured);

    const configured = RespiratoryThresholds(minimum: 10, target: 20, maximum: 30);
    expect(configured.isValid, isTrue);
    expect(configured.describe(9.9), ThresholdBand.below);
    expect(configured.describe(20), ThresholdBand.inRange);
    expect(configured.describe(30.1), ThresholdBand.above);
    expect(const RespiratoryThresholds(minimum: 30, target: 20, maximum: 10).isValid, isFalse);
  });

  test('threshold ordering identifies the fields that need correction', () {
    const reversed = RespiratoryThresholds(minimum: 40, target: 20, maximum: 30);
    expect(reversed.isMinimumOrdered, isFalse);
    expect(reversed.isTargetOrdered, isFalse);
    expect(reversed.isMaximumOrdered, isFalse);

    expect(
      const RespiratoryThresholds(minimum: 10, target: 20, maximum: 30).isMinimumOrdered,
      isTrue,
    );
    expect(
      const RespiratoryThresholds(minimum: 10, target: 35, maximum: 30).isTargetOrdered,
      isFalse,
    );
    expect(
      const RespiratoryThresholds(minimum: 20, target: 30, maximum: 10).isMaximumOrdered,
      isFalse,
    );
    expect(const RespiratoryThresholds(target: double.infinity).isValid, isFalse);
  });

  test('weight conversion round-trips without changing canonical kilograms', () {
    final canonical = WeightValue.from(12.3456789, WeightUnit.kilograms);
    final pounds = canonical.inUnit(WeightUnit.pounds);
    final roundTrip = WeightValue.from(pounds, WeightUnit.pounds);
    expect(roundTrip.kilograms, closeTo(canonical.kilograms, 1e-12));
  });

  test('display formatting removes floating-point noise and whole respiratory decimals', () {
    expect(formatDisplayNumber(24.947580350000003), '24.95');
    expect(formatDisplayNumber(55), '55');
    expect(formatDisplayNumber(55.5), '55.5');
    expect(formatRespiratoryRate(40), '40');
    expect(formatRespiratoryRate(40.49), '40');
    expect(formatRespiratoryRate(40.5), '41');
  });

  test('trend chart scale uses stable rounded bounds and intervals', () {
    final scale = TrendAxisScale.fromValues(const <double>[12, 16, 24, 30, 34, 36, 38, 42]);

    expect(scale.minimum, 10);
    expect(scale.maximum, 45);
    expect(scale.interval, 5);

    final sparseScale = TrendAxisScale.fromValues(const <double>[0.264]);
    expect(sparseScale.minimum, closeTo(0.2, 1e-10));
    expect(sparseScale.maximum, closeTo(0.35, 1e-10));
    expect(sparseScale.interval, closeTo(0.05, 1e-10));
  });

  test('trend summary is descriptive only', () {
    final summary = TrendSummary.fromValues(const <double>[18, 21, 19, 23]);
    expect(summary.latest, 23);
    expect(summary.minimum, 18);
    expect(summary.maximum, 23);
    expect(summary.average, 20.25);
    expect(summary.count, 4);
  });

  test('trend average includes every value in the selected period', () {
    final summary = TrendSummary.fromValues(const <double>[34, 24, 30]);
    expect(summary.latest, 30);
    expect(summary.average, closeTo(29.3333333333, 1e-9));
    expect(summary.minimum, 24);
    expect(summary.maximum, 34);
  });

  test('single-value trend average equals its only measurement', () {
    final summary = TrendSummary.fromValues(const <double>[18.5]);
    expect(summary.average, 18.5);
  });
}
