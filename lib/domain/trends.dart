import 'dart:math' as math;

import 'models.dart';
import 'units.dart';

enum TrendRange { sevenDays, thirtyDays, ninetyDays, oneYear, custom, allTime }

class TrendPoint {
  const TrendPoint({
    required this.id,
    required this.at,
    required this.value,
    required this.rawValue,
    required this.rawUnit,
  });

  final String id;
  final DateTime at;
  final double value;
  final double rawValue;
  final String rawUnit;
}

class TrendAxisScale {
  const TrendAxisScale({required this.minimum, required this.maximum, required this.interval});

  factory TrendAxisScale.fromValues(Iterable<double> values, {int targetIntervals = 6}) {
    if (targetIntervals < 2) {
      throw ArgumentError.value(targetIntervals, 'targetIntervals', 'Must be at least 2.');
    }
    final finiteValues = values.where((value) => value.isFinite).toList(growable: false);
    if (finiteValues.isEmpty) {
      throw ArgumentError.value(values, 'values', 'At least one finite value is required.');
    }
    final dataMinimum = finiteValues.reduce(math.min);
    final dataMaximum = finiteValues.reduce(math.max);
    if (dataMinimum == dataMaximum) {
      final roughInterval = dataMaximum == 0 ? 1.0 : dataMaximum.abs() / targetIntervals;
      final interval = _niceInterval(roughInterval);
      final minimum = math.max(
        0.0,
        ((dataMinimum - interval) / interval).floorToDouble() * interval,
      );
      var maximum = ((dataMaximum + interval) / interval).ceilToDouble() * interval;
      if (maximum <= minimum) {
        maximum = minimum + interval * 2;
      }
      return TrendAxisScale(minimum: minimum, maximum: maximum, interval: interval);
    }

    final interval = _niceInterval((dataMaximum - dataMinimum) / targetIntervals);
    var minimum = (dataMinimum / interval).floorToDouble() * interval;
    var maximum = (dataMaximum / interval).ceilToDouble() * interval;
    if ((minimum - dataMinimum).abs() < 1e-9 && minimum > 0) {
      minimum -= interval;
    }
    if ((maximum - dataMaximum).abs() < 1e-9) {
      maximum += interval;
    }
    minimum = math.max(0.0, minimum);
    if (maximum <= minimum) {
      maximum = minimum + interval * 2;
    }
    return TrendAxisScale(minimum: minimum, maximum: maximum, interval: interval);
  }

  final double minimum;
  final double maximum;
  final double interval;

  static double _niceInterval(double roughInterval) {
    if (!roughInterval.isFinite || roughInterval <= 0) {
      return 1;
    }
    final exponent = (math.log(roughInterval) / math.ln10).floor();
    final magnitude = math.pow(10, exponent).toDouble();
    final fraction = roughInterval / magnitude;
    final niceFraction = switch (fraction) {
      <= 1 => 1.0,
      <= 2 => 2.0,
      <= 5 => 5.0,
      _ => 10.0,
    };
    return niceFraction * magnitude;
  }
}

class TrendDataBuilder {
  const TrendDataBuilder();

  List<TrendPoint> respiratory(
    CreaturelySnapshot snapshot,
    String animalId, {
    DateTime? start,
    DateTime? end,
  }) {
    final result = snapshot.respiratorySessions
        .where(
          (value) =>
              value.animalId == animalId &&
              (start == null || !value.recordedAt.isBefore(start)) &&
              (end == null || !value.recordedAt.isAfter(end)),
        )
        .map(
          (value) => TrendPoint(
            id: value.id,
            at: value.recordedAt,
            value: value.ratePerMinute,
            rawValue: value.breathCount.toDouble(),
            rawUnit: 'breaths in ${formatDisplayNumber(value.durationMilliseconds / 1000)} seconds',
          ),
        )
        .toList(growable: false);
    result.sort((a, b) => a.at.compareTo(b.at));
    return result;
  }

  List<TrendPoint> weight(
    CreaturelySnapshot snapshot,
    String animalId,
    WeightUnit displayUnit, {
    DateTime? start,
    DateTime? end,
  }) {
    final result = snapshot.healthRecords
        .where(
          (value) =>
              value.animalId == animalId &&
              value.kind == HealthRecordKind.weight &&
              value.canonicalValue != null &&
              (start == null || !value.occurredAt.isBefore(start)) &&
              (end == null || !value.occurredAt.isAfter(end)),
        )
        .map((value) {
          final enteredUnit = value.enteredUnit == 'lb' ? WeightUnit.pounds : WeightUnit.kilograms;
          final weight = WeightValue.from(value.canonicalValue!, WeightUnit.kilograms);
          return TrendPoint(
            id: value.id,
            at: value.occurredAt,
            value: weight.inUnit(displayUnit),
            rawValue: weight.inUnit(enteredUnit),
            rawUnit: enteredUnit == WeightUnit.kilograms ? 'kg' : 'lb',
          );
        })
        .toList(growable: false);
    result.sort((a, b) => a.at.compareTo(b.at));
    return result;
  }

  DateTime? startFor(TrendRange range, DateTime now, {DateTime? customStart}) => switch (range) {
    TrendRange.sevenDays => now.subtract(const Duration(days: 7)),
    TrendRange.thirtyDays => now.subtract(const Duration(days: 30)),
    TrendRange.ninetyDays => now.subtract(const Duration(days: 90)),
    TrendRange.oneYear => DateTime(now.year - 1, now.month, now.day),
    TrendRange.custom => customStart,
    TrendRange.allTime => null,
  };
}
