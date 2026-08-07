import 'models.dart';

String formatDisplayNumber(double value, {int maximumFractionDigits = 2}) {
  if (!value.isFinite) {
    return value.toString();
  }
  if (maximumFractionDigits < 0) {
    throw ArgumentError.value(
      maximumFractionDigits,
      'maximumFractionDigits',
      'Must not be negative.',
    );
  }
  final normalized = value == 0 ? 0.0 : value;
  final fixed = normalized.toStringAsFixed(maximumFractionDigits);
  if (!fixed.contains('.')) {
    return fixed;
  }
  return fixed.replaceFirst(RegExp(r'\.?0+$'), '');
}

String formatRespiratoryRate(double value) => value.round().toString();

class WeightValue {
  const WeightValue._(this.kilograms);

  factory WeightValue.from(double value, WeightUnit unit) {
    if (!value.isFinite || value < 0) {
      throw ArgumentError.value(value, 'value', 'Weight must be a finite non-negative value.');
    }
    return WeightValue._(unit == WeightUnit.kilograms ? value : value / poundsPerKilogram);
  }

  static const double poundsPerKilogram = 2.2046226218487757;

  final double kilograms;

  double inUnit(WeightUnit unit) =>
      unit == WeightUnit.kilograms ? kilograms : kilograms * poundsPerKilogram;

  String unitLabel(WeightUnit unit) => unit == WeightUnit.kilograms ? 'kg' : 'lb';
}

class TrendSummary {
  const TrendSummary({
    required this.latest,
    required this.minimum,
    required this.maximum,
    required this.average,
    required this.count,
  });

  factory TrendSummary.fromValues(Iterable<double> values) {
    final list = values.toList(growable: false);
    if (list.isEmpty) {
      throw ArgumentError.value(values, 'values', 'Cannot summarize an empty series.');
    }
    return TrendSummary(
      latest: list.last,
      minimum: list.reduce((a, b) => a < b ? a : b),
      maximum: list.reduce((a, b) => a > b ? a : b),
      average: list.fold<double>(0, (total, value) => total + value) / list.length,
      count: list.length,
    );
  }

  final double latest;
  final double minimum;
  final double maximum;
  final double average;
  final int count;
}
