import 'dart:convert';

enum RespiratoryContext { sleeping, resting }

enum ThresholdBand { below, inRange, above, notConfigured }

enum ScheduleKind { interval, daily, selectedWeekdays }

enum ReminderRecurrence { daily, selectedWeekdays }

enum DoseStatus { given, skipped, missed, unrecorded }

enum HealthRecordKind { weight, allergy, condition, observation }

enum DocumentCategory {
  vaccination,
  laboratory,
  imaging,
  prescription,
  insurance,
  identification,
  other,
}

enum WeightUnit { kilograms, pounds }

enum AppThemePreference { system, light, dark }

enum CloudProvider { none, cloudKit, googleDriveAppData }

DateTime _requiredDate(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is String) {
    return DateTime.parse(value);
  }
  throw FormatException('$key must be an ISO-8601 string.');
}

DateTime? _optionalDate(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value == null) {
    return null;
  }
  if (value is String) {
    return DateTime.parse(value);
  }
  throw FormatException('$key must be an ISO-8601 string or null.');
}

/// Returns the canonical representation for a calendar-only value.
///
/// Creaturely uses UTC midnight as a timezone-neutral container for dates that
/// have no time-of-day semantics. Callers must format these values directly
/// rather than converting them to local time.
DateTime canonicalCalendarDate(DateTime value) => DateTime.utc(value.year, value.month, value.day);

String calendarDateToIso8601(DateTime value) {
  final date = canonicalCalendarDate(value);
  return '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}

int compareCalendarDates(DateTime left, DateTime right) =>
    canonicalCalendarDate(left).compareTo(canonicalCalendarDate(right));

bool calendarDateIsWithin(DateTime value, DateTime start, DateTime end) =>
    compareCalendarDates(value, start) >= 0 && compareCalendarDates(value, end) <= 0;

DateTime _requiredCalendarDate(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! String || value.length < 10) {
    throw FormatException('$key must be an ISO-8601 calendar date.');
  }
  final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})(?:$|T)').firstMatch(value);
  if (match == null || DateTime.tryParse(value) == null) {
    throw FormatException('$key must be an ISO-8601 calendar date.');
  }
  final year = int.parse(match.group(1)!);
  final month = int.parse(match.group(2)!);
  final day = int.parse(match.group(3)!);
  final result = DateTime.utc(year, month, day);
  if (result.year != year || result.month != month || result.day != day) {
    throw FormatException('$key must be a valid calendar date.');
  }
  return result;
}

DateTime? _optionalCalendarDate(Map<String, Object?> json, String key) {
  if (json[key] == null) {
    return null;
  }
  return _requiredCalendarDate(json, key);
}

double? _optionalDouble(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value == null) {
    return null;
  }
  if (value is num) {
    return value.toDouble();
  }
  throw FormatException('$key must be numeric or null.');
}

int? _optionalInt(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value == null) {
    return null;
  }
  if (value is int) {
    return value;
  }
  throw FormatException('$key must be an integer or null.');
}

T _enumValue<T extends Enum>(Iterable<T> values, Object? raw, String key) {
  if (raw is String) {
    for (final value in values) {
      if (value.name == raw) {
        return value;
      }
    }
  }
  throw FormatException('$key has an unsupported value.');
}

List<Map<String, Object?>> _objectList(Map<String, Object?> json, String key) {
  final raw = json[key];
  if (raw is! List<Object?>) {
    throw FormatException('$key must be a list.');
  }
  return raw
      .map((item) {
        if (item is Map<String, Object?>) {
          return item;
        }
        throw FormatException('$key contains a non-object value.');
      })
      .toList(growable: false);
}

List<Map<String, Object?>> _optionalObjectList(Map<String, Object?> json, String key) {
  if (!json.containsKey(key)) {
    return const <Map<String, Object?>>[];
  }
  return _objectList(json, key);
}

class RespiratoryThresholds {
  const RespiratoryThresholds({this.minimum, this.target, this.maximum});

  factory RespiratoryThresholds.fromJson(Map<String, Object?> json) => RespiratoryThresholds(
    minimum: _optionalDouble(json, 'minimum'),
    target: _optionalDouble(json, 'target'),
    maximum: _optionalDouble(json, 'maximum'),
  );

  final double? minimum;
  final double? target;
  final double? maximum;

  bool get isConfigured => minimum != null || target != null || maximum != null;

  bool get isMinimumOrdered =>
      minimum == null ||
      ((target == null || minimum! <= target!) && (maximum == null || minimum! <= maximum!));

  bool get isTargetOrdered =>
      target == null ||
      ((minimum == null || target! >= minimum!) && (maximum == null || target! <= maximum!));

  bool get isMaximumOrdered =>
      maximum == null ||
      ((minimum == null || maximum! >= minimum!) && (target == null || maximum! >= target!));

  bool get isValid =>
      isMinimumOrdered &&
      isTargetOrdered &&
      isMaximumOrdered &&
      [minimum, target, maximum].whereType<double>().every((value) => value.isFinite && value >= 0);

  ThresholdBand describe(double value) {
    if (!isConfigured) {
      return ThresholdBand.notConfigured;
    }
    if (minimum != null && value < minimum!) {
      return ThresholdBand.below;
    }
    if (maximum != null && value > maximum!) {
      return ThresholdBand.above;
    }
    return ThresholdBand.inRange;
  }

  Map<String, Object?> toJson() => {'minimum': minimum, 'target': target, 'maximum': maximum};
}

class Animal {
  const Animal({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.species,
    this.photoPath,
    this.breed,
    this.sexOrStatus,
    this.dateOfBirth,
    this.approximateAgeMonths,
    this.colorMarkings,
    this.currentWeightKg,
    this.notes,
    this.archived = false,
    this.thresholds = const RespiratoryThresholds(),
  });

  factory Animal.fromJson(Map<String, Object?> json) {
    final thresholds = json['respiratoryThresholds'];
    return Animal(
      id: json['id'] as String,
      createdAt: _requiredDate(json, 'createdAt'),
      updatedAt: _requiredDate(json, 'updatedAt'),
      name: json['name'] as String,
      photoPath: json['photoPath'] as String?,
      species: json['species'] as String,
      breed: json['breed'] as String?,
      sexOrStatus: json['sexOrStatus'] as String?,
      dateOfBirth: _optionalCalendarDate(json, 'dateOfBirth'),
      approximateAgeMonths: _optionalInt(json, 'approximateAgeMonths'),
      colorMarkings: json['colorMarkings'] as String?,
      currentWeightKg: _optionalDouble(json, 'currentWeightKg'),
      notes: json['notes'] as String?,
      archived: json['archived'] as bool? ?? false,
      thresholds: thresholds is Map<String, Object?>
          ? RespiratoryThresholds.fromJson(thresholds)
          : const RespiratoryThresholds(),
    );
  }

  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String name;
  final String? photoPath;
  final String species;
  final String? breed;
  final String? sexOrStatus;
  final DateTime? dateOfBirth;
  final int? approximateAgeMonths;
  final String? colorMarkings;
  final double? currentWeightKg;
  final String? notes;
  final bool archived;
  final RespiratoryThresholds thresholds;

  Animal copyWith({
    String? name,
    String? photoPath,
    bool clearPhotoPath = false,
    String? species,
    String? breed,
    String? sexOrStatus,
    DateTime? dateOfBirth,
    int? approximateAgeMonths,
    String? colorMarkings,
    double? currentWeightKg,
    String? notes,
    bool? archived,
    RespiratoryThresholds? thresholds,
    DateTime? updatedAt,
  }) => Animal(
    id: id,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    name: name ?? this.name,
    photoPath: clearPhotoPath ? null : photoPath ?? this.photoPath,
    species: species ?? this.species,
    breed: breed ?? this.breed,
    sexOrStatus: sexOrStatus ?? this.sexOrStatus,
    dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    approximateAgeMonths: approximateAgeMonths ?? this.approximateAgeMonths,
    colorMarkings: colorMarkings ?? this.colorMarkings,
    currentWeightKg: currentWeightKg ?? this.currentWeightKg,
    notes: notes ?? this.notes,
    archived: archived ?? this.archived,
    thresholds: thresholds ?? this.thresholds,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'createdAt': createdAt.toUtc().toIso8601String(),
    'updatedAt': updatedAt.toUtc().toIso8601String(),
    'name': name,
    'photoPath': photoPath,
    'species': species,
    'breed': breed,
    'sexOrStatus': sexOrStatus,
    'dateOfBirth': dateOfBirth == null ? null : calendarDateToIso8601(dateOfBirth!),
    'approximateAgeMonths': approximateAgeMonths,
    'colorMarkings': colorMarkings,
    'currentWeightKg': currentWeightKg,
    'notes': notes,
    'archived': archived,
    'respiratoryThresholds': thresholds.toJson(),
  };
}

class AnimalIdentifier {
  const AnimalIdentifier({
    required this.id,
    required this.animalId,
    required this.createdAt,
    required this.updatedAt,
    required this.type,
    required this.value,
    this.issuer,
    this.url,
    this.phone,
    this.issuedOn,
    this.notes,
    this.archived = false,
  });

  factory AnimalIdentifier.fromJson(Map<String, Object?> json) => AnimalIdentifier(
    id: json['id'] as String,
    animalId: json['animalId'] as String,
    createdAt: _requiredDate(json, 'createdAt'),
    updatedAt: _requiredDate(json, 'updatedAt'),
    type: json['type'] as String,
    value: json['value'] as String,
    issuer: json['issuer'] as String?,
    url: json['url'] as String?,
    phone: json['phone'] as String?,
    issuedOn: _optionalCalendarDate(json, 'issuedOn'),
    notes: json['notes'] as String?,
    archived: json['archived'] as bool? ?? false,
  );

  final String id;
  final String animalId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String type;
  final String value;
  final String? issuer;
  final String? url;
  final String? phone;
  final DateTime? issuedOn;
  final String? notes;
  final bool archived;

  Map<String, Object?> toJson() => {
    'id': id,
    'animalId': animalId,
    'createdAt': createdAt.toUtc().toIso8601String(),
    'updatedAt': updatedAt.toUtc().toIso8601String(),
    'type': type,
    'value': value,
    'issuer': issuer,
    'url': url,
    'phone': phone,
    'issuedOn': issuedOn == null ? null : calendarDateToIso8601(issuedOn!),
    'notes': notes,
    'archived': archived,
  };
}

class RespiratorySession {
  const RespiratorySession({
    required this.id,
    required this.animalId,
    required this.createdAt,
    required this.updatedAt,
    required this.recordedAt,
    required this.durationMilliseconds,
    required this.breathCount,
    required this.ratePerMinute,
    required this.context,
    required this.thresholdSnapshot,
    this.note,
  });

  factory RespiratorySession.fromJson(Map<String, Object?> json) => RespiratorySession(
    id: json['id'] as String,
    animalId: json['animalId'] as String,
    createdAt: _requiredDate(json, 'createdAt'),
    updatedAt: _requiredDate(json, 'updatedAt'),
    recordedAt: _requiredDate(json, 'recordedAt'),
    durationMilliseconds: json['durationMilliseconds'] as int,
    breathCount: json['breathCount'] as int,
    ratePerMinute: (json['ratePerMinute'] as num).toDouble(),
    context: _enumValue(RespiratoryContext.values, json['context'], 'context'),
    note: json['note'] as String?,
    thresholdSnapshot: RespiratoryThresholds.fromJson(
      json['thresholdSnapshot'] as Map<String, Object?>,
    ),
  );

  final String id;
  final String animalId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime recordedAt;
  final int durationMilliseconds;
  final int breathCount;
  final double ratePerMinute;
  final RespiratoryContext context;
  final String? note;
  final RespiratoryThresholds thresholdSnapshot;

  Map<String, Object?> toJson() => {
    'id': id,
    'animalId': animalId,
    'createdAt': createdAt.toUtc().toIso8601String(),
    'updatedAt': updatedAt.toUtc().toIso8601String(),
    'recordedAt': recordedAt.toUtc().toIso8601String(),
    'durationMilliseconds': durationMilliseconds,
    'breathCount': breathCount,
    'ratePerMinute': ratePerMinute,
    'context': context.name,
    'note': note,
    'thresholdSnapshot': thresholdSnapshot.toJson(),
  };
}

class LocalClockTime implements Comparable<LocalClockTime> {
  const LocalClockTime(this.hour, this.minute)
    : assert(hour >= 0 && hour <= 23),
      assert(minute >= 0 && minute <= 59);

  factory LocalClockTime.fromJson(Map<String, Object?> json) =>
      LocalClockTime(json['hour'] as int, json['minute'] as int);

  factory LocalClockTime.parse(String value) {
    final parts = value.split(':');
    if (parts.length != 2) {
      throw const FormatException('Local time must use HH:mm.');
    }
    return LocalClockTime(int.parse(parts[0]), int.parse(parts[1]));
  }

  final int hour;
  final int minute;

  String get encoded => '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  @override
  int compareTo(LocalClockTime other) =>
      (hour * 60 + minute).compareTo(other.hour * 60 + other.minute);

  Map<String, Object?> toJson() => {'hour': hour, 'minute': minute};

  @override
  bool operator ==(Object other) =>
      other is LocalClockTime && other.hour == hour && other.minute == minute;

  @override
  int get hashCode => Object.hash(hour, minute);
}

class Medication {
  const Medication({
    required this.id,
    required this.animalId,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.form,
    required this.doseAmount,
    required this.doseUnit,
    required this.instructions,
    required this.startDate,
    this.endDate,
    this.prescriber,
    this.notes,
    this.active = true,
  });

  factory Medication.fromJson(Map<String, Object?> json) => Medication(
    id: json['id'] as String,
    animalId: json['animalId'] as String,
    createdAt: _requiredDate(json, 'createdAt'),
    updatedAt: _requiredDate(json, 'updatedAt'),
    name: json['name'] as String,
    form: json['form'] as String,
    doseAmount: (json['doseAmount'] as num).toDouble(),
    doseUnit: json['doseUnit'] as String,
    instructions: json['instructions'] as String,
    startDate: _requiredCalendarDate(json, 'startDate'),
    endDate: _optionalCalendarDate(json, 'endDate'),
    prescriber: json['prescriber'] as String?,
    notes: json['notes'] as String?,
    active: json['active'] as bool? ?? true,
  );

  final String id;
  final String animalId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String name;
  final String form;
  final double doseAmount;
  final String doseUnit;
  final String instructions;
  final DateTime startDate;
  final DateTime? endDate;
  final String? prescriber;
  final String? notes;
  final bool active;

  Medication copyWith({
    String? name,
    String? form,
    double? doseAmount,
    String? doseUnit,
    String? instructions,
    DateTime? startDate,
    DateTime? endDate,
    String? prescriber,
    String? notes,
    bool? active,
    DateTime? updatedAt,
  }) => Medication(
    id: id,
    animalId: animalId,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    name: name ?? this.name,
    form: form ?? this.form,
    doseAmount: doseAmount ?? this.doseAmount,
    doseUnit: doseUnit ?? this.doseUnit,
    instructions: instructions ?? this.instructions,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    prescriber: prescriber ?? this.prescriber,
    notes: notes ?? this.notes,
    active: active ?? this.active,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'animalId': animalId,
    'createdAt': createdAt.toUtc().toIso8601String(),
    'updatedAt': updatedAt.toUtc().toIso8601String(),
    'name': name,
    'form': form,
    'doseAmount': doseAmount,
    'doseUnit': doseUnit,
    'instructions': instructions,
    'startDate': calendarDateToIso8601(startDate),
    'endDate': endDate == null ? null : calendarDateToIso8601(endDate!),
    'prescriber': prescriber,
    'notes': notes,
    'active': active,
  };
}

class MedicationSchedule {
  const MedicationSchedule({
    required this.id,
    required this.medicationId,
    required this.animalId,
    required this.createdAt,
    required this.updatedAt,
    required this.kind,
    required this.timeZoneId,
    this.intervalHours,
    this.times = const <LocalClockTime>[],
    this.weekdays = const <int>{},
    this.enabled = true,
  });

  factory MedicationSchedule.fromJson(Map<String, Object?> json) {
    final rawTimes = json['times'];
    final rawWeekdays = json['weekdays'];
    if (rawTimes is! List<Object?> || rawWeekdays is! List<Object?>) {
      throw const FormatException('Schedule times and weekdays must be lists.');
    }
    return MedicationSchedule(
      id: json['id'] as String,
      medicationId: json['medicationId'] as String,
      animalId: json['animalId'] as String,
      createdAt: _requiredDate(json, 'createdAt'),
      updatedAt: _requiredDate(json, 'updatedAt'),
      kind: _enumValue(ScheduleKind.values, json['kind'], 'kind'),
      timeZoneId: json['timeZoneId'] as String,
      intervalHours: _optionalInt(json, 'intervalHours'),
      times: rawTimes
          .map((item) => LocalClockTime.fromJson(item as Map<String, Object?>))
          .toList(growable: false),
      weekdays: rawWeekdays.map((item) => item as int).toSet(),
      enabled: json['enabled'] as bool? ?? true,
    );
  }

  final String id;
  final String medicationId;
  final String animalId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ScheduleKind kind;
  final String timeZoneId;
  final int? intervalHours;
  final List<LocalClockTime> times;
  final Set<int> weekdays;
  final bool enabled;

  bool get _timesAreValid =>
      times.isNotEmpty &&
      times.toSet().length == times.length &&
      times.every(
        (time) => time.hour >= 0 && time.hour <= 23 && time.minute >= 0 && time.minute <= 59,
      );

  bool get isValid => switch (kind) {
    ScheduleKind.interval =>
      intervalHours != null && intervalHours! > 0 && times.length == 1 && _timesAreValid,
    ScheduleKind.daily => _timesAreValid,
    ScheduleKind.selectedWeekdays =>
      _timesAreValid && weekdays.isNotEmpty && weekdays.every((day) => day >= 1 && day <= 7),
  };

  MedicationSchedule copyWith({DateTime? updatedAt, String? timeZoneId, bool? enabled}) =>
      MedicationSchedule(
        id: id,
        medicationId: medicationId,
        animalId: animalId,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        kind: kind,
        timeZoneId: timeZoneId ?? this.timeZoneId,
        intervalHours: intervalHours,
        times: times,
        weekdays: weekdays,
        enabled: enabled ?? this.enabled,
      );

  Map<String, Object?> toJson() => {
    'id': id,
    'medicationId': medicationId,
    'animalId': animalId,
    'createdAt': createdAt.toUtc().toIso8601String(),
    'updatedAt': updatedAt.toUtc().toIso8601String(),
    'kind': kind.name,
    'timeZoneId': timeZoneId,
    'intervalHours': intervalHours,
    'times': times.map((time) => time.toJson()).toList(growable: false),
    'weekdays': weekdays.toList(growable: false)..sort(),
    'enabled': enabled,
  };
}

class RespiratoryReminder {
  const RespiratoryReminder({
    required this.id,
    required this.animalId,
    required this.createdAt,
    required this.updatedAt,
    required this.startDate,
    required this.context,
    required this.recurrence,
    required this.timeZoneId,
    this.endDate,
    this.times = const <LocalClockTime>[],
    this.weekdays = const <int>{},
    this.enabled = true,
  });

  factory RespiratoryReminder.fromJson(Map<String, Object?> json) {
    final rawTimes = json['times'];
    final rawWeekdays = json['weekdays'];
    if (rawTimes is! List<Object?> || rawWeekdays is! List<Object?>) {
      throw const FormatException('Reminder times and weekdays must be lists.');
    }
    return RespiratoryReminder(
      id: json['id'] as String,
      animalId: json['animalId'] as String,
      createdAt: _requiredDate(json, 'createdAt'),
      updatedAt: _requiredDate(json, 'updatedAt'),
      startDate: _requiredCalendarDate(json, 'startDate'),
      endDate: _optionalCalendarDate(json, 'endDate'),
      context: _enumValue(RespiratoryContext.values, json['context'], 'context'),
      recurrence: _enumValue(ReminderRecurrence.values, json['recurrence'], 'recurrence'),
      timeZoneId: json['timeZoneId'] as String,
      times: rawTimes
          .map((item) => LocalClockTime.fromJson(item as Map<String, Object?>))
          .toList(growable: false),
      weekdays: rawWeekdays.map((item) => item as int).toSet(),
      enabled: json['enabled'] as bool? ?? true,
    );
  }

  final String id;
  final String animalId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime startDate;
  final DateTime? endDate;
  final RespiratoryContext context;
  final ReminderRecurrence recurrence;
  final String timeZoneId;
  final List<LocalClockTime> times;
  final Set<int> weekdays;
  final bool enabled;

  bool get _timesAreValid =>
      times.isNotEmpty &&
      times.toSet().length == times.length &&
      times.every(
        (time) => time.hour >= 0 && time.hour <= 23 && time.minute >= 0 && time.minute <= 59,
      );

  bool get isValid =>
      timeZoneId.trim().isNotEmpty &&
      _timesAreValid &&
      (endDate == null || compareCalendarDates(endDate!, startDate) >= 0) &&
      switch (recurrence) {
        ReminderRecurrence.daily => true,
        ReminderRecurrence.selectedWeekdays =>
          weekdays.isNotEmpty && weekdays.every((day) => day >= 1 && day <= 7),
      };

  RespiratoryReminder copyWith({
    DateTime? updatedAt,
    DateTime? startDate,
    DateTime? endDate,
    bool clearEndDate = false,
    RespiratoryContext? context,
    ReminderRecurrence? recurrence,
    String? timeZoneId,
    List<LocalClockTime>? times,
    Set<int>? weekdays,
    bool? enabled,
  }) => RespiratoryReminder(
    id: id,
    animalId: animalId,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    startDate: startDate ?? this.startDate,
    endDate: clearEndDate ? null : endDate ?? this.endDate,
    context: context ?? this.context,
    recurrence: recurrence ?? this.recurrence,
    timeZoneId: timeZoneId ?? this.timeZoneId,
    times: times ?? this.times,
    weekdays: weekdays ?? this.weekdays,
    enabled: enabled ?? this.enabled,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'animalId': animalId,
    'createdAt': createdAt.toUtc().toIso8601String(),
    'updatedAt': updatedAt.toUtc().toIso8601String(),
    'startDate': calendarDateToIso8601(startDate),
    'endDate': endDate == null ? null : calendarDateToIso8601(endDate!),
    'context': context.name,
    'recurrence': recurrence.name,
    'timeZoneId': timeZoneId,
    'times': times.map((time) => time.toJson()).toList(growable: false),
    'weekdays': weekdays.toList(growable: false)..sort(),
    'enabled': enabled,
  };
}

class WeightCheckReminder {
  const WeightCheckReminder({
    required this.id,
    required this.animalId,
    required this.createdAt,
    required this.updatedAt,
    required this.startDate,
    required this.recurrence,
    required this.timeZoneId,
    this.endDate,
    this.times = const <LocalClockTime>[],
    this.weekdays = const <int>{},
    this.enabled = true,
  });

  factory WeightCheckReminder.fromJson(Map<String, Object?> json) {
    final rawTimes = json['times'];
    final rawWeekdays = json['weekdays'];
    if (rawTimes is! List<Object?> || rawWeekdays is! List<Object?>) {
      throw const FormatException('Weight reminder times and weekdays must be lists.');
    }
    return WeightCheckReminder(
      id: json['id'] as String,
      animalId: json['animalId'] as String,
      createdAt: _requiredDate(json, 'createdAt'),
      updatedAt: _requiredDate(json, 'updatedAt'),
      startDate: _requiredCalendarDate(json, 'startDate'),
      endDate: _optionalCalendarDate(json, 'endDate'),
      recurrence: _enumValue(ReminderRecurrence.values, json['recurrence'], 'recurrence'),
      timeZoneId: json['timeZoneId'] as String,
      times: rawTimes
          .map((item) => LocalClockTime.fromJson(item as Map<String, Object?>))
          .toList(growable: false),
      weekdays: rawWeekdays.map((item) => item as int).toSet(),
      enabled: json['enabled'] as bool? ?? true,
    );
  }

  final String id;
  final String animalId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime startDate;
  final DateTime? endDate;
  final ReminderRecurrence recurrence;
  final String timeZoneId;
  final List<LocalClockTime> times;
  final Set<int> weekdays;
  final bool enabled;

  bool get _timesAreValid =>
      times.isNotEmpty &&
      times.toSet().length == times.length &&
      times.every(
        (time) => time.hour >= 0 && time.hour <= 23 && time.minute >= 0 && time.minute <= 59,
      );

  bool get isValid =>
      timeZoneId.trim().isNotEmpty &&
      _timesAreValid &&
      (endDate == null || compareCalendarDates(endDate!, startDate) >= 0) &&
      switch (recurrence) {
        ReminderRecurrence.daily => true,
        ReminderRecurrence.selectedWeekdays =>
          weekdays.isNotEmpty && weekdays.every((day) => day >= 1 && day <= 7),
      };

  WeightCheckReminder copyWith({
    DateTime? updatedAt,
    DateTime? startDate,
    DateTime? endDate,
    bool clearEndDate = false,
    ReminderRecurrence? recurrence,
    String? timeZoneId,
    List<LocalClockTime>? times,
    Set<int>? weekdays,
    bool? enabled,
  }) => WeightCheckReminder(
    id: id,
    animalId: animalId,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    startDate: startDate ?? this.startDate,
    endDate: clearEndDate ? null : endDate ?? this.endDate,
    recurrence: recurrence ?? this.recurrence,
    timeZoneId: timeZoneId ?? this.timeZoneId,
    times: times ?? this.times,
    weekdays: weekdays ?? this.weekdays,
    enabled: enabled ?? this.enabled,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'animalId': animalId,
    'createdAt': createdAt.toUtc().toIso8601String(),
    'updatedAt': updatedAt.toUtc().toIso8601String(),
    'startDate': calendarDateToIso8601(startDate),
    'endDate': endDate == null ? null : calendarDateToIso8601(endDate!),
    'recurrence': recurrence.name,
    'timeZoneId': timeZoneId,
    'times': times.map((time) => time.toJson()).toList(growable: false),
    'weekdays': weekdays.toList(growable: false)..sort(),
    'enabled': enabled,
  };
}

class DoseLedgerEntry {
  const DoseLedgerEntry({
    required this.id,
    required this.medicationId,
    required this.animalId,
    required this.createdAt,
    required this.updatedAt,
    required this.dueAt,
    required this.intendedLocalTime,
    required this.timeZoneId,
    required this.status,
    this.scheduleId,
    this.administeredAt,
    this.note,
  });

  factory DoseLedgerEntry.fromJson(Map<String, Object?> json) => DoseLedgerEntry(
    id: json['id'] as String,
    medicationId: json['medicationId'] as String,
    scheduleId: json['scheduleId'] as String?,
    animalId: json['animalId'] as String,
    createdAt: _requiredDate(json, 'createdAt'),
    updatedAt: _requiredDate(json, 'updatedAt'),
    dueAt: _requiredDate(json, 'dueAt'),
    intendedLocalTime: json['intendedLocalTime'] as String,
    timeZoneId: json['timeZoneId'] as String,
    status: _enumValue(DoseStatus.values, json['status'], 'status'),
    administeredAt: _optionalDate(json, 'administeredAt'),
    note: json['note'] as String?,
  );

  final String id;
  final String medicationId;
  final String? scheduleId;
  final String animalId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime dueAt;
  final String intendedLocalTime;
  final String timeZoneId;
  final DoseStatus status;
  final DateTime? administeredAt;
  final String? note;

  DoseLedgerEntry transition({
    required DoseStatus to,
    required DateTime at,
    DateTime? administeredAt,
    String? note,
  }) {
    if (status == DoseStatus.given || status == DoseStatus.skipped) {
      throw StateError('A completed dose cannot be changed without reopening it first.');
    }
    if (to == DoseStatus.unrecorded) {
      throw ArgumentError.value(to, 'to', 'Use reopen() to return to unrecorded.');
    }
    return copyWith(
      status: to,
      updatedAt: at,
      administeredAt: to == DoseStatus.given ? administeredAt ?? at : null,
      note: note,
      clearAdministeredAt: to != DoseStatus.given,
    );
  }

  DoseLedgerEntry reopen({required DateTime at}) =>
      copyWith(status: DoseStatus.unrecorded, updatedAt: at, clearAdministeredAt: true);

  DoseLedgerEntry copyWith({
    DoseStatus? status,
    DateTime? updatedAt,
    DateTime? administeredAt,
    bool clearAdministeredAt = false,
    String? note,
  }) => DoseLedgerEntry(
    id: id,
    medicationId: medicationId,
    scheduleId: scheduleId,
    animalId: animalId,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    dueAt: dueAt,
    intendedLocalTime: intendedLocalTime,
    timeZoneId: timeZoneId,
    status: status ?? this.status,
    administeredAt: clearAdministeredAt ? null : administeredAt ?? this.administeredAt,
    note: note ?? this.note,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'medicationId': medicationId,
    'scheduleId': scheduleId,
    'animalId': animalId,
    'createdAt': createdAt.toUtc().toIso8601String(),
    'updatedAt': updatedAt.toUtc().toIso8601String(),
    'dueAt': dueAt.toUtc().toIso8601String(),
    'intendedLocalTime': intendedLocalTime,
    'timeZoneId': timeZoneId,
    'status': status.name,
    'administeredAt': administeredAt?.toUtc().toIso8601String(),
    'note': note,
  };
}

class HealthRecord {
  const HealthRecord({
    required this.id,
    required this.animalId,
    required this.createdAt,
    required this.updatedAt,
    required this.occurredAt,
    required this.kind,
    required this.title,
    this.canonicalValue,
    this.canonicalUnit,
    this.enteredUnit,
    this.note,
    this.archived = false,
  });

  factory HealthRecord.fromJson(Map<String, Object?> json) => HealthRecord(
    id: json['id'] as String,
    animalId: json['animalId'] as String,
    createdAt: _requiredDate(json, 'createdAt'),
    updatedAt: _requiredDate(json, 'updatedAt'),
    occurredAt: _requiredDate(json, 'occurredAt'),
    kind: _enumValue(HealthRecordKind.values, json['kind'], 'kind'),
    title: json['title'] as String,
    canonicalValue: _optionalDouble(json, 'canonicalValue'),
    canonicalUnit: json['canonicalUnit'] as String?,
    enteredUnit: json['enteredUnit'] as String?,
    note: json['note'] as String?,
    archived: json['archived'] as bool? ?? false,
  );

  final String id;
  final String animalId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime occurredAt;
  final HealthRecordKind kind;
  final String title;
  final double? canonicalValue;
  final String? canonicalUnit;
  final String? enteredUnit;
  final String? note;
  final bool archived;

  Map<String, Object?> toJson() => {
    'id': id,
    'animalId': animalId,
    'createdAt': createdAt.toUtc().toIso8601String(),
    'updatedAt': updatedAt.toUtc().toIso8601String(),
    'occurredAt': occurredAt.toUtc().toIso8601String(),
    'kind': kind.name,
    'title': title,
    'canonicalValue': canonicalValue,
    'canonicalUnit': canonicalUnit,
    'enteredUnit': enteredUnit,
    'note': note,
    'archived': archived,
  };
}

class CareDocument {
  const CareDocument({
    required this.id,
    required this.animalId,
    required this.createdAt,
    required this.updatedAt,
    required this.documentDate,
    required this.title,
    required this.category,
    required this.storedPath,
    required this.mediaType,
    required this.checksumSha256,
    required this.byteLength,
    this.notes,
    this.expiryDate,
    this.archived = false,
  });

  factory CareDocument.fromJson(Map<String, Object?> json) => CareDocument(
    id: json['id'] as String,
    animalId: json['animalId'] as String,
    createdAt: _requiredDate(json, 'createdAt'),
    updatedAt: _requiredDate(json, 'updatedAt'),
    documentDate: _requiredCalendarDate(json, 'documentDate'),
    title: json['title'] as String,
    category: _enumValue(DocumentCategory.values, json['category'], 'category'),
    storedPath: json['storedPath'] as String,
    mediaType: json['mediaType'] as String,
    checksumSha256: json['checksumSha256'] as String,
    byteLength: json['byteLength'] as int,
    notes: json['notes'] as String?,
    expiryDate: _optionalCalendarDate(json, 'expiryDate'),
    archived: json['archived'] as bool? ?? false,
  );

  final String id;
  final String animalId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime documentDate;
  final String title;
  final DocumentCategory category;
  final String storedPath;
  final String mediaType;
  final String checksumSha256;
  final int byteLength;
  final String? notes;
  final DateTime? expiryDate;
  final bool archived;

  CareDocument copyWith({
    String? storedPath,
    String? title,
    String? notes,
    DateTime? expiryDate,
    DateTime? updatedAt,
    bool? archived,
  }) => CareDocument(
    id: id,
    animalId: animalId,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    documentDate: documentDate,
    title: title ?? this.title,
    category: category,
    storedPath: storedPath ?? this.storedPath,
    mediaType: mediaType,
    checksumSha256: checksumSha256,
    byteLength: byteLength,
    notes: notes ?? this.notes,
    expiryDate: expiryDate ?? this.expiryDate,
    archived: archived ?? this.archived,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'animalId': animalId,
    'createdAt': createdAt.toUtc().toIso8601String(),
    'updatedAt': updatedAt.toUtc().toIso8601String(),
    'documentDate': calendarDateToIso8601(documentDate),
    'title': title,
    'category': category.name,
    'storedPath': storedPath,
    'mediaType': mediaType,
    'checksumSha256': checksumSha256,
    'byteLength': byteLength,
    'notes': notes,
    'expiryDate': expiryDate == null ? null : calendarDateToIso8601(expiryDate!),
    'archived': archived,
  };
}

class AppSettings {
  const AppSettings({
    this.onboardingComplete = false,
    this.theme = AppThemePreference.system,
    this.weightUnit = WeightUnit.kilograms,
    this.defaultTimerSeconds = 30,
    this.hapticsEnabled = true,
    this.soundEnabled = false,
    this.notificationPermissionAsked = false,
    this.notificationsAllowed = false,
    this.automaticRecoveryEnabled = false,
    this.cloudProvider = CloudProvider.none,
  });

  factory AppSettings.fromJson(Map<String, Object?> json) => AppSettings(
    onboardingComplete: json['onboardingComplete'] as bool? ?? false,
    theme: _enumValue(
      AppThemePreference.values,
      json['theme'] ?? AppThemePreference.system.name,
      'theme',
    ),
    weightUnit: _enumValue(
      WeightUnit.values,
      json['weightUnit'] ?? WeightUnit.kilograms.name,
      'weightUnit',
    ),
    defaultTimerSeconds: json['defaultTimerSeconds'] as int? ?? 30,
    hapticsEnabled: json['hapticsEnabled'] as bool? ?? true,
    soundEnabled: json['soundEnabled'] as bool? ?? false,
    notificationPermissionAsked: json['notificationPermissionAsked'] as bool? ?? false,
    notificationsAllowed: json['notificationsAllowed'] as bool? ?? false,
    automaticRecoveryEnabled: json['automaticRecoveryEnabled'] as bool? ?? false,
    cloudProvider: _enumValue(
      CloudProvider.values,
      json['cloudProvider'] ?? CloudProvider.none.name,
      'cloudProvider',
    ),
  );

  final bool onboardingComplete;
  final AppThemePreference theme;
  final WeightUnit weightUnit;
  final int defaultTimerSeconds;
  final bool hapticsEnabled;
  final bool soundEnabled;
  final bool notificationPermissionAsked;
  final bool notificationsAllowed;
  final bool automaticRecoveryEnabled;
  final CloudProvider cloudProvider;

  AppSettings copyWith({
    bool? onboardingComplete,
    AppThemePreference? theme,
    WeightUnit? weightUnit,
    int? defaultTimerSeconds,
    bool? hapticsEnabled,
    bool? soundEnabled,
    bool? notificationPermissionAsked,
    bool? notificationsAllowed,
    bool? automaticRecoveryEnabled,
    CloudProvider? cloudProvider,
  }) => AppSettings(
    onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    theme: theme ?? this.theme,
    weightUnit: weightUnit ?? this.weightUnit,
    defaultTimerSeconds: defaultTimerSeconds ?? this.defaultTimerSeconds,
    hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
    soundEnabled: soundEnabled ?? this.soundEnabled,
    notificationPermissionAsked: notificationPermissionAsked ?? this.notificationPermissionAsked,
    notificationsAllowed: notificationsAllowed ?? this.notificationsAllowed,
    automaticRecoveryEnabled: automaticRecoveryEnabled ?? this.automaticRecoveryEnabled,
    cloudProvider: cloudProvider ?? this.cloudProvider,
  );

  Map<String, Object?> toJson() => {
    'onboardingComplete': onboardingComplete,
    'theme': theme.name,
    'weightUnit': weightUnit.name,
    'defaultTimerSeconds': defaultTimerSeconds,
    'hapticsEnabled': hapticsEnabled,
    'soundEnabled': soundEnabled,
    'notificationPermissionAsked': notificationPermissionAsked,
    'notificationsAllowed': notificationsAllowed,
    'automaticRecoveryEnabled': automaticRecoveryEnabled,
    'cloudProvider': cloudProvider.name,
  };
}

class CreaturelySnapshot {
  const CreaturelySnapshot({
    required this.schemaVersion,
    required this.exportedAt,
    required this.animals,
    required this.identifiers,
    required this.respiratorySessions,
    this.respiratoryReminders = const <RespiratoryReminder>[],
    this.weightReminders = const <WeightCheckReminder>[],
    required this.medications,
    required this.medicationSchedules,
    required this.doseLedger,
    required this.healthRecords,
    required this.documents,
    required this.settings,
  });

  factory CreaturelySnapshot.empty({DateTime? at}) => CreaturelySnapshot(
    schemaVersion: currentSchemaVersion,
    exportedAt: at ?? DateTime.now().toUtc(),
    animals: const <Animal>[],
    identifiers: const <AnimalIdentifier>[],
    respiratorySessions: const <RespiratorySession>[],
    respiratoryReminders: const <RespiratoryReminder>[],
    weightReminders: const <WeightCheckReminder>[],
    medications: const <Medication>[],
    medicationSchedules: const <MedicationSchedule>[],
    doseLedger: const <DoseLedgerEntry>[],
    healthRecords: const <HealthRecord>[],
    documents: const <CareDocument>[],
    settings: const AppSettings(),
  );

  factory CreaturelySnapshot.fromJson(Map<String, Object?> json) => CreaturelySnapshot(
    schemaVersion: json['schemaVersion'] as int,
    exportedAt: _requiredDate(json, 'exportedAt'),
    animals: _objectList(json, 'animals').map(Animal.fromJson).toList(growable: false),
    identifiers: _objectList(
      json,
      'identifiers',
    ).map(AnimalIdentifier.fromJson).toList(growable: false),
    respiratorySessions: _objectList(
      json,
      'respiratorySessions',
    ).map(RespiratorySession.fromJson).toList(growable: false),
    respiratoryReminders: _optionalObjectList(
      json,
      'respiratoryReminders',
    ).map(RespiratoryReminder.fromJson).toList(growable: false),
    weightReminders: _optionalObjectList(
      json,
      'weightReminders',
    ).map(WeightCheckReminder.fromJson).toList(growable: false),
    medications: _objectList(json, 'medications').map(Medication.fromJson).toList(growable: false),
    medicationSchedules: _objectList(
      json,
      'medicationSchedules',
    ).map(MedicationSchedule.fromJson).toList(growable: false),
    doseLedger: _objectList(
      json,
      'doseLedger',
    ).map(DoseLedgerEntry.fromJson).toList(growable: false),
    healthRecords: _objectList(
      json,
      'healthRecords',
    ).map(HealthRecord.fromJson).toList(growable: false),
    documents: _objectList(json, 'documents').map(CareDocument.fromJson).toList(growable: false),
    settings: AppSettings.fromJson(json['settings'] as Map<String, Object?>),
  );

  static const int currentSchemaVersion = 4;

  final int schemaVersion;
  final DateTime exportedAt;
  final List<Animal> animals;
  final List<AnimalIdentifier> identifiers;
  final List<RespiratorySession> respiratorySessions;
  final List<RespiratoryReminder> respiratoryReminders;
  final List<WeightCheckReminder> weightReminders;
  final List<Medication> medications;
  final List<MedicationSchedule> medicationSchedules;
  final List<DoseLedgerEntry> doseLedger;
  final List<HealthRecord> healthRecords;
  final List<CareDocument> documents;
  final AppSettings settings;

  Map<String, Object?> toJson() => {
    'schemaVersion': schemaVersion,
    'exportedAt': exportedAt.toUtc().toIso8601String(),
    'animals': animals.map((value) => value.toJson()).toList(growable: false),
    'identifiers': identifiers.map((value) => value.toJson()).toList(growable: false),
    'respiratorySessions': respiratorySessions
        .map((value) => value.toJson())
        .toList(growable: false),
    'respiratoryReminders': respiratoryReminders
        .map((value) => value.toJson())
        .toList(growable: false),
    'weightReminders': weightReminders.map((value) => value.toJson()).toList(growable: false),
    'medications': medications.map((value) => value.toJson()).toList(growable: false),
    'medicationSchedules': medicationSchedules
        .map((value) => value.toJson())
        .toList(growable: false),
    'doseLedger': doseLedger.map((value) => value.toJson()).toList(growable: false),
    'healthRecords': healthRecords.map((value) => value.toJson()).toList(growable: false),
    'documents': documents.map((value) => value.toJson()).toList(growable: false),
    'settings': settings.toJson(),
  };

  String toCanonicalJson() {
    final value = toJson();
    for (final key in const <String>[
      'animals',
      'identifiers',
      'respiratorySessions',
      'respiratoryReminders',
      'weightReminders',
      'medications',
      'medicationSchedules',
      'doseLedger',
      'healthRecords',
      'documents',
    ]) {
      final records = value[key]! as List<Object?>;
      records.sort(
        (first, second) => (first! as Map<String, Object?>)['id']!.toString().compareTo(
          (second! as Map<String, Object?>)['id']!.toString(),
        ),
      );
    }
    return jsonEncode(value);
  }

  static CreaturelySnapshot decode(String value) {
    final decoded = jsonDecode(value);
    if (decoded is! Map<String, Object?>) {
      throw const FormatException('Creaturely data must be a JSON object.');
    }
    return CreaturelySnapshot.fromJson(decoded);
  }
}

class TimelineItem {
  const TimelineItem({
    required this.id,
    required this.animalId,
    required this.at,
    required this.kind,
    required this.title,
    required this.detail,
    required this.source,
  });

  final String id;
  final String animalId;
  final DateTime at;
  final String kind;
  final String title;
  final String detail;
  final Object source;
}
