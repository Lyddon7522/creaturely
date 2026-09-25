// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $AnimalRowsTable extends AnimalRows with TableInfo<$AnimalRowsTable, AnimalEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnimalRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta('photoPath');
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _speciesMeta = const VerificationMeta('species');
  @override
  late final GeneratedColumn<String> species = GeneratedColumn<String>(
    'species',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _breedMeta = const VerificationMeta('breed');
  @override
  late final GeneratedColumn<String> breed = GeneratedColumn<String>(
    'breed',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sexOrStatusMeta = const VerificationMeta('sexOrStatus');
  @override
  late final GeneratedColumn<String> sexOrStatus = GeneratedColumn<String>(
    'sex_or_status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateOfBirthMeta = const VerificationMeta('dateOfBirth');
  @override
  late final GeneratedColumn<DateTime> dateOfBirth = GeneratedColumn<DateTime>(
    'date_of_birth',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _approximateAgeMonthsMeta = const VerificationMeta(
    'approximateAgeMonths',
  );
  @override
  late final GeneratedColumn<int> approximateAgeMonths = GeneratedColumn<int>(
    'approximate_age_months',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorMarkingsMeta = const VerificationMeta('colorMarkings');
  @override
  late final GeneratedColumn<String> colorMarkings = GeneratedColumn<String>(
    'color_markings',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentWeightKgMeta = const VerificationMeta('currentWeightKg');
  @override
  late final GeneratedColumn<double> currentWeightKg = GeneratedColumn<double>(
    'current_weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta('archived');
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("archived" IN (0, 1))'),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _thresholdMinimumMeta = const VerificationMeta('thresholdMinimum');
  @override
  late final GeneratedColumn<double> thresholdMinimum = GeneratedColumn<double>(
    'threshold_minimum',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _thresholdTargetMeta = const VerificationMeta('thresholdTarget');
  @override
  late final GeneratedColumn<double> thresholdTarget = GeneratedColumn<double>(
    'threshold_target',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _thresholdMaximumMeta = const VerificationMeta('thresholdMaximum');
  @override
  late final GeneratedColumn<double> thresholdMaximum = GeneratedColumn<double>(
    'threshold_maximum',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    name,
    photoPath,
    species,
    breed,
    sexOrStatus,
    dateOfBirth,
    approximateAgeMonths,
    colorMarkings,
    currentWeightKg,
    notes,
    archived,
    thresholdMinimum,
    thresholdTarget,
    thresholdMaximum,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'animal_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<AnimalEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('species')) {
      context.handle(_speciesMeta, species.isAcceptableOrUnknown(data['species']!, _speciesMeta));
    } else if (isInserting) {
      context.missing(_speciesMeta);
    }
    if (data.containsKey('breed')) {
      context.handle(_breedMeta, breed.isAcceptableOrUnknown(data['breed']!, _breedMeta));
    }
    if (data.containsKey('sex_or_status')) {
      context.handle(
        _sexOrStatusMeta,
        sexOrStatus.isAcceptableOrUnknown(data['sex_or_status']!, _sexOrStatusMeta),
      );
    }
    if (data.containsKey('date_of_birth')) {
      context.handle(
        _dateOfBirthMeta,
        dateOfBirth.isAcceptableOrUnknown(data['date_of_birth']!, _dateOfBirthMeta),
      );
    }
    if (data.containsKey('approximate_age_months')) {
      context.handle(
        _approximateAgeMonthsMeta,
        approximateAgeMonths.isAcceptableOrUnknown(
          data['approximate_age_months']!,
          _approximateAgeMonthsMeta,
        ),
      );
    }
    if (data.containsKey('color_markings')) {
      context.handle(
        _colorMarkingsMeta,
        colorMarkings.isAcceptableOrUnknown(data['color_markings']!, _colorMarkingsMeta),
      );
    }
    if (data.containsKey('current_weight_kg')) {
      context.handle(
        _currentWeightKgMeta,
        currentWeightKg.isAcceptableOrUnknown(data['current_weight_kg']!, _currentWeightKgMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(_notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    if (data.containsKey('threshold_minimum')) {
      context.handle(
        _thresholdMinimumMeta,
        thresholdMinimum.isAcceptableOrUnknown(data['threshold_minimum']!, _thresholdMinimumMeta),
      );
    }
    if (data.containsKey('threshold_target')) {
      context.handle(
        _thresholdTargetMeta,
        thresholdTarget.isAcceptableOrUnknown(data['threshold_target']!, _thresholdTargetMeta),
      );
    }
    if (data.containsKey('threshold_maximum')) {
      context.handle(
        _thresholdMaximumMeta,
        thresholdMaximum.isAcceptableOrUnknown(data['threshold_maximum']!, _thresholdMaximumMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AnimalEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AnimalEntity(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      species: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}species'],
      )!,
      breed: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}breed'],
      ),
      sexOrStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sex_or_status'],
      ),
      dateOfBirth: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_of_birth'],
      ),
      approximateAgeMonths: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}approximate_age_months'],
      ),
      colorMarkings: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_markings'],
      ),
      currentWeightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}current_weight_kg'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
      thresholdMinimum: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}threshold_minimum'],
      ),
      thresholdTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}threshold_target'],
      ),
      thresholdMaximum: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}threshold_maximum'],
      ),
    );
  }

  @override
  $AnimalRowsTable createAlias(String alias) {
    return $AnimalRowsTable(attachedDatabase, alias);
  }
}

class AnimalEntity extends DataClass implements Insertable<AnimalEntity> {
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
  final double? thresholdMinimum;
  final double? thresholdTarget;
  final double? thresholdMaximum;
  const AnimalEntity({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    this.photoPath,
    required this.species,
    this.breed,
    this.sexOrStatus,
    this.dateOfBirth,
    this.approximateAgeMonths,
    this.colorMarkings,
    this.currentWeightKg,
    this.notes,
    required this.archived,
    this.thresholdMinimum,
    this.thresholdTarget,
    this.thresholdMaximum,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    map['species'] = Variable<String>(species);
    if (!nullToAbsent || breed != null) {
      map['breed'] = Variable<String>(breed);
    }
    if (!nullToAbsent || sexOrStatus != null) {
      map['sex_or_status'] = Variable<String>(sexOrStatus);
    }
    if (!nullToAbsent || dateOfBirth != null) {
      map['date_of_birth'] = Variable<DateTime>(dateOfBirth);
    }
    if (!nullToAbsent || approximateAgeMonths != null) {
      map['approximate_age_months'] = Variable<int>(approximateAgeMonths);
    }
    if (!nullToAbsent || colorMarkings != null) {
      map['color_markings'] = Variable<String>(colorMarkings);
    }
    if (!nullToAbsent || currentWeightKg != null) {
      map['current_weight_kg'] = Variable<double>(currentWeightKg);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['archived'] = Variable<bool>(archived);
    if (!nullToAbsent || thresholdMinimum != null) {
      map['threshold_minimum'] = Variable<double>(thresholdMinimum);
    }
    if (!nullToAbsent || thresholdTarget != null) {
      map['threshold_target'] = Variable<double>(thresholdTarget);
    }
    if (!nullToAbsent || thresholdMaximum != null) {
      map['threshold_maximum'] = Variable<double>(thresholdMaximum);
    }
    return map;
  }

  AnimalRowsCompanion toCompanion(bool nullToAbsent) {
    return AnimalRowsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      name: Value(name),
      photoPath: photoPath == null && nullToAbsent ? const Value.absent() : Value(photoPath),
      species: Value(species),
      breed: breed == null && nullToAbsent ? const Value.absent() : Value(breed),
      sexOrStatus: sexOrStatus == null && nullToAbsent ? const Value.absent() : Value(sexOrStatus),
      dateOfBirth: dateOfBirth == null && nullToAbsent ? const Value.absent() : Value(dateOfBirth),
      approximateAgeMonths: approximateAgeMonths == null && nullToAbsent
          ? const Value.absent()
          : Value(approximateAgeMonths),
      colorMarkings: colorMarkings == null && nullToAbsent
          ? const Value.absent()
          : Value(colorMarkings),
      currentWeightKg: currentWeightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(currentWeightKg),
      notes: notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      archived: Value(archived),
      thresholdMinimum: thresholdMinimum == null && nullToAbsent
          ? const Value.absent()
          : Value(thresholdMinimum),
      thresholdTarget: thresholdTarget == null && nullToAbsent
          ? const Value.absent()
          : Value(thresholdTarget),
      thresholdMaximum: thresholdMaximum == null && nullToAbsent
          ? const Value.absent()
          : Value(thresholdMaximum),
    );
  }

  factory AnimalEntity.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AnimalEntity(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      name: serializer.fromJson<String>(json['name']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      species: serializer.fromJson<String>(json['species']),
      breed: serializer.fromJson<String?>(json['breed']),
      sexOrStatus: serializer.fromJson<String?>(json['sexOrStatus']),
      dateOfBirth: serializer.fromJson<DateTime?>(json['dateOfBirth']),
      approximateAgeMonths: serializer.fromJson<int?>(json['approximateAgeMonths']),
      colorMarkings: serializer.fromJson<String?>(json['colorMarkings']),
      currentWeightKg: serializer.fromJson<double?>(json['currentWeightKg']),
      notes: serializer.fromJson<String?>(json['notes']),
      archived: serializer.fromJson<bool>(json['archived']),
      thresholdMinimum: serializer.fromJson<double?>(json['thresholdMinimum']),
      thresholdTarget: serializer.fromJson<double?>(json['thresholdTarget']),
      thresholdMaximum: serializer.fromJson<double?>(json['thresholdMaximum']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'name': serializer.toJson<String>(name),
      'photoPath': serializer.toJson<String?>(photoPath),
      'species': serializer.toJson<String>(species),
      'breed': serializer.toJson<String?>(breed),
      'sexOrStatus': serializer.toJson<String?>(sexOrStatus),
      'dateOfBirth': serializer.toJson<DateTime?>(dateOfBirth),
      'approximateAgeMonths': serializer.toJson<int?>(approximateAgeMonths),
      'colorMarkings': serializer.toJson<String?>(colorMarkings),
      'currentWeightKg': serializer.toJson<double?>(currentWeightKg),
      'notes': serializer.toJson<String?>(notes),
      'archived': serializer.toJson<bool>(archived),
      'thresholdMinimum': serializer.toJson<double?>(thresholdMinimum),
      'thresholdTarget': serializer.toJson<double?>(thresholdTarget),
      'thresholdMaximum': serializer.toJson<double?>(thresholdMaximum),
    };
  }

  AnimalEntity copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? name,
    Value<String?> photoPath = const Value.absent(),
    String? species,
    Value<String?> breed = const Value.absent(),
    Value<String?> sexOrStatus = const Value.absent(),
    Value<DateTime?> dateOfBirth = const Value.absent(),
    Value<int?> approximateAgeMonths = const Value.absent(),
    Value<String?> colorMarkings = const Value.absent(),
    Value<double?> currentWeightKg = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    bool? archived,
    Value<double?> thresholdMinimum = const Value.absent(),
    Value<double?> thresholdTarget = const Value.absent(),
    Value<double?> thresholdMaximum = const Value.absent(),
  }) => AnimalEntity(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    name: name ?? this.name,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    species: species ?? this.species,
    breed: breed.present ? breed.value : this.breed,
    sexOrStatus: sexOrStatus.present ? sexOrStatus.value : this.sexOrStatus,
    dateOfBirth: dateOfBirth.present ? dateOfBirth.value : this.dateOfBirth,
    approximateAgeMonths: approximateAgeMonths.present
        ? approximateAgeMonths.value
        : this.approximateAgeMonths,
    colorMarkings: colorMarkings.present ? colorMarkings.value : this.colorMarkings,
    currentWeightKg: currentWeightKg.present ? currentWeightKg.value : this.currentWeightKg,
    notes: notes.present ? notes.value : this.notes,
    archived: archived ?? this.archived,
    thresholdMinimum: thresholdMinimum.present ? thresholdMinimum.value : this.thresholdMinimum,
    thresholdTarget: thresholdTarget.present ? thresholdTarget.value : this.thresholdTarget,
    thresholdMaximum: thresholdMaximum.present ? thresholdMaximum.value : this.thresholdMaximum,
  );
  AnimalEntity copyWithCompanion(AnimalRowsCompanion data) {
    return AnimalEntity(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      name: data.name.present ? data.name.value : this.name,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      species: data.species.present ? data.species.value : this.species,
      breed: data.breed.present ? data.breed.value : this.breed,
      sexOrStatus: data.sexOrStatus.present ? data.sexOrStatus.value : this.sexOrStatus,
      dateOfBirth: data.dateOfBirth.present ? data.dateOfBirth.value : this.dateOfBirth,
      approximateAgeMonths: data.approximateAgeMonths.present
          ? data.approximateAgeMonths.value
          : this.approximateAgeMonths,
      colorMarkings: data.colorMarkings.present ? data.colorMarkings.value : this.colorMarkings,
      currentWeightKg: data.currentWeightKg.present
          ? data.currentWeightKg.value
          : this.currentWeightKg,
      notes: data.notes.present ? data.notes.value : this.notes,
      archived: data.archived.present ? data.archived.value : this.archived,
      thresholdMinimum: data.thresholdMinimum.present
          ? data.thresholdMinimum.value
          : this.thresholdMinimum,
      thresholdTarget: data.thresholdTarget.present
          ? data.thresholdTarget.value
          : this.thresholdTarget,
      thresholdMaximum: data.thresholdMaximum.present
          ? data.thresholdMaximum.value
          : this.thresholdMaximum,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AnimalEntity(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('name: $name, ')
          ..write('photoPath: $photoPath, ')
          ..write('species: $species, ')
          ..write('breed: $breed, ')
          ..write('sexOrStatus: $sexOrStatus, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('approximateAgeMonths: $approximateAgeMonths, ')
          ..write('colorMarkings: $colorMarkings, ')
          ..write('currentWeightKg: $currentWeightKg, ')
          ..write('notes: $notes, ')
          ..write('archived: $archived, ')
          ..write('thresholdMinimum: $thresholdMinimum, ')
          ..write('thresholdTarget: $thresholdTarget, ')
          ..write('thresholdMaximum: $thresholdMaximum')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    name,
    photoPath,
    species,
    breed,
    sexOrStatus,
    dateOfBirth,
    approximateAgeMonths,
    colorMarkings,
    currentWeightKg,
    notes,
    archived,
    thresholdMinimum,
    thresholdTarget,
    thresholdMaximum,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AnimalEntity &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.name == this.name &&
          other.photoPath == this.photoPath &&
          other.species == this.species &&
          other.breed == this.breed &&
          other.sexOrStatus == this.sexOrStatus &&
          other.dateOfBirth == this.dateOfBirth &&
          other.approximateAgeMonths == this.approximateAgeMonths &&
          other.colorMarkings == this.colorMarkings &&
          other.currentWeightKg == this.currentWeightKg &&
          other.notes == this.notes &&
          other.archived == this.archived &&
          other.thresholdMinimum == this.thresholdMinimum &&
          other.thresholdTarget == this.thresholdTarget &&
          other.thresholdMaximum == this.thresholdMaximum);
}

class AnimalRowsCompanion extends UpdateCompanion<AnimalEntity> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> name;
  final Value<String?> photoPath;
  final Value<String> species;
  final Value<String?> breed;
  final Value<String?> sexOrStatus;
  final Value<DateTime?> dateOfBirth;
  final Value<int?> approximateAgeMonths;
  final Value<String?> colorMarkings;
  final Value<double?> currentWeightKg;
  final Value<String?> notes;
  final Value<bool> archived;
  final Value<double?> thresholdMinimum;
  final Value<double?> thresholdTarget;
  final Value<double?> thresholdMaximum;
  final Value<int> rowid;
  const AnimalRowsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.species = const Value.absent(),
    this.breed = const Value.absent(),
    this.sexOrStatus = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.approximateAgeMonths = const Value.absent(),
    this.colorMarkings = const Value.absent(),
    this.currentWeightKg = const Value.absent(),
    this.notes = const Value.absent(),
    this.archived = const Value.absent(),
    this.thresholdMinimum = const Value.absent(),
    this.thresholdTarget = const Value.absent(),
    this.thresholdMaximum = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AnimalRowsCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String name,
    this.photoPath = const Value.absent(),
    required String species,
    this.breed = const Value.absent(),
    this.sexOrStatus = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.approximateAgeMonths = const Value.absent(),
    this.colorMarkings = const Value.absent(),
    this.currentWeightKg = const Value.absent(),
    this.notes = const Value.absent(),
    this.archived = const Value.absent(),
    this.thresholdMinimum = const Value.absent(),
    this.thresholdTarget = const Value.absent(),
    this.thresholdMaximum = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       name = Value(name),
       species = Value(species);
  static Insertable<AnimalEntity> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? name,
    Expression<String>? photoPath,
    Expression<String>? species,
    Expression<String>? breed,
    Expression<String>? sexOrStatus,
    Expression<DateTime>? dateOfBirth,
    Expression<int>? approximateAgeMonths,
    Expression<String>? colorMarkings,
    Expression<double>? currentWeightKg,
    Expression<String>? notes,
    Expression<bool>? archived,
    Expression<double>? thresholdMinimum,
    Expression<double>? thresholdTarget,
    Expression<double>? thresholdMaximum,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (name != null) 'name': name,
      if (photoPath != null) 'photo_path': photoPath,
      if (species != null) 'species': species,
      if (breed != null) 'breed': breed,
      if (sexOrStatus != null) 'sex_or_status': sexOrStatus,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      if (approximateAgeMonths != null) 'approximate_age_months': approximateAgeMonths,
      if (colorMarkings != null) 'color_markings': colorMarkings,
      if (currentWeightKg != null) 'current_weight_kg': currentWeightKg,
      if (notes != null) 'notes': notes,
      if (archived != null) 'archived': archived,
      if (thresholdMinimum != null) 'threshold_minimum': thresholdMinimum,
      if (thresholdTarget != null) 'threshold_target': thresholdTarget,
      if (thresholdMaximum != null) 'threshold_maximum': thresholdMaximum,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AnimalRowsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? name,
    Value<String?>? photoPath,
    Value<String>? species,
    Value<String?>? breed,
    Value<String?>? sexOrStatus,
    Value<DateTime?>? dateOfBirth,
    Value<int?>? approximateAgeMonths,
    Value<String?>? colorMarkings,
    Value<double?>? currentWeightKg,
    Value<String?>? notes,
    Value<bool>? archived,
    Value<double?>? thresholdMinimum,
    Value<double?>? thresholdTarget,
    Value<double?>? thresholdMaximum,
    Value<int>? rowid,
  }) {
    return AnimalRowsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      name: name ?? this.name,
      photoPath: photoPath ?? this.photoPath,
      species: species ?? this.species,
      breed: breed ?? this.breed,
      sexOrStatus: sexOrStatus ?? this.sexOrStatus,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      approximateAgeMonths: approximateAgeMonths ?? this.approximateAgeMonths,
      colorMarkings: colorMarkings ?? this.colorMarkings,
      currentWeightKg: currentWeightKg ?? this.currentWeightKg,
      notes: notes ?? this.notes,
      archived: archived ?? this.archived,
      thresholdMinimum: thresholdMinimum ?? this.thresholdMinimum,
      thresholdTarget: thresholdTarget ?? this.thresholdTarget,
      thresholdMaximum: thresholdMaximum ?? this.thresholdMaximum,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (species.present) {
      map['species'] = Variable<String>(species.value);
    }
    if (breed.present) {
      map['breed'] = Variable<String>(breed.value);
    }
    if (sexOrStatus.present) {
      map['sex_or_status'] = Variable<String>(sexOrStatus.value);
    }
    if (dateOfBirth.present) {
      map['date_of_birth'] = Variable<DateTime>(dateOfBirth.value);
    }
    if (approximateAgeMonths.present) {
      map['approximate_age_months'] = Variable<int>(approximateAgeMonths.value);
    }
    if (colorMarkings.present) {
      map['color_markings'] = Variable<String>(colorMarkings.value);
    }
    if (currentWeightKg.present) {
      map['current_weight_kg'] = Variable<double>(currentWeightKg.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (thresholdMinimum.present) {
      map['threshold_minimum'] = Variable<double>(thresholdMinimum.value);
    }
    if (thresholdTarget.present) {
      map['threshold_target'] = Variable<double>(thresholdTarget.value);
    }
    if (thresholdMaximum.present) {
      map['threshold_maximum'] = Variable<double>(thresholdMaximum.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnimalRowsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('name: $name, ')
          ..write('photoPath: $photoPath, ')
          ..write('species: $species, ')
          ..write('breed: $breed, ')
          ..write('sexOrStatus: $sexOrStatus, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('approximateAgeMonths: $approximateAgeMonths, ')
          ..write('colorMarkings: $colorMarkings, ')
          ..write('currentWeightKg: $currentWeightKg, ')
          ..write('notes: $notes, ')
          ..write('archived: $archived, ')
          ..write('thresholdMinimum: $thresholdMinimum, ')
          ..write('thresholdTarget: $thresholdTarget, ')
          ..write('thresholdMaximum: $thresholdMaximum, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IdentifierRowsTable extends IdentifierRows
    with TableInfo<$IdentifierRowsTable, IdentifierEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IdentifierRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _animalIdMeta = const VerificationMeta('animalId');
  @override
  late final GeneratedColumn<String> animalId = GeneratedColumn<String>(
    'animal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES animal_rows (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _issuerMeta = const VerificationMeta('issuer');
  @override
  late final GeneratedColumn<String> issuer = GeneratedColumn<String>(
    'issuer',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _issuedOnMeta = const VerificationMeta('issuedOn');
  @override
  late final GeneratedColumn<DateTime> issuedOn = GeneratedColumn<DateTime>(
    'issued_on',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta('archived');
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("archived" IN (0, 1))'),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    animalId,
    createdAt,
    updatedAt,
    type,
    value,
    issuer,
    url,
    phone,
    issuedOn,
    notes,
    archived,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'identifier_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<IdentifierEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('animal_id')) {
      context.handle(
        _animalIdMeta,
        animalId.isAcceptableOrUnknown(data['animal_id']!, _animalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_animalIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('type')) {
      context.handle(_typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('value')) {
      context.handle(_valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('issuer')) {
      context.handle(_issuerMeta, issuer.isAcceptableOrUnknown(data['issuer']!, _issuerMeta));
    }
    if (data.containsKey('url')) {
      context.handle(_urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(_phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('issued_on')) {
      context.handle(
        _issuedOnMeta,
        issuedOn.isAcceptableOrUnknown(data['issued_on']!, _issuedOnMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(_notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IdentifierEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IdentifierEntity(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      animalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}animal_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      type: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      issuer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}issuer'],
      ),
      url: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}url']),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      issuedOn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}issued_on'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
    );
  }

  @override
  $IdentifierRowsTable createAlias(String alias) {
    return $IdentifierRowsTable(attachedDatabase, alias);
  }
}

class IdentifierEntity extends DataClass implements Insertable<IdentifierEntity> {
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
  const IdentifierEntity({
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
    required this.archived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['animal_id'] = Variable<String>(animalId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['type'] = Variable<String>(type);
    map['value'] = Variable<String>(value);
    if (!nullToAbsent || issuer != null) {
      map['issuer'] = Variable<String>(issuer);
    }
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String>(url);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || issuedOn != null) {
      map['issued_on'] = Variable<DateTime>(issuedOn);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['archived'] = Variable<bool>(archived);
    return map;
  }

  IdentifierRowsCompanion toCompanion(bool nullToAbsent) {
    return IdentifierRowsCompanion(
      id: Value(id),
      animalId: Value(animalId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      type: Value(type),
      value: Value(value),
      issuer: issuer == null && nullToAbsent ? const Value.absent() : Value(issuer),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      phone: phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      issuedOn: issuedOn == null && nullToAbsent ? const Value.absent() : Value(issuedOn),
      notes: notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      archived: Value(archived),
    );
  }

  factory IdentifierEntity.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IdentifierEntity(
      id: serializer.fromJson<String>(json['id']),
      animalId: serializer.fromJson<String>(json['animalId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      type: serializer.fromJson<String>(json['type']),
      value: serializer.fromJson<String>(json['value']),
      issuer: serializer.fromJson<String?>(json['issuer']),
      url: serializer.fromJson<String?>(json['url']),
      phone: serializer.fromJson<String?>(json['phone']),
      issuedOn: serializer.fromJson<DateTime?>(json['issuedOn']),
      notes: serializer.fromJson<String?>(json['notes']),
      archived: serializer.fromJson<bool>(json['archived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'animalId': serializer.toJson<String>(animalId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'type': serializer.toJson<String>(type),
      'value': serializer.toJson<String>(value),
      'issuer': serializer.toJson<String?>(issuer),
      'url': serializer.toJson<String?>(url),
      'phone': serializer.toJson<String?>(phone),
      'issuedOn': serializer.toJson<DateTime?>(issuedOn),
      'notes': serializer.toJson<String?>(notes),
      'archived': serializer.toJson<bool>(archived),
    };
  }

  IdentifierEntity copyWith({
    String? id,
    String? animalId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? type,
    String? value,
    Value<String?> issuer = const Value.absent(),
    Value<String?> url = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<DateTime?> issuedOn = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    bool? archived,
  }) => IdentifierEntity(
    id: id ?? this.id,
    animalId: animalId ?? this.animalId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    type: type ?? this.type,
    value: value ?? this.value,
    issuer: issuer.present ? issuer.value : this.issuer,
    url: url.present ? url.value : this.url,
    phone: phone.present ? phone.value : this.phone,
    issuedOn: issuedOn.present ? issuedOn.value : this.issuedOn,
    notes: notes.present ? notes.value : this.notes,
    archived: archived ?? this.archived,
  );
  IdentifierEntity copyWithCompanion(IdentifierRowsCompanion data) {
    return IdentifierEntity(
      id: data.id.present ? data.id.value : this.id,
      animalId: data.animalId.present ? data.animalId.value : this.animalId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      type: data.type.present ? data.type.value : this.type,
      value: data.value.present ? data.value.value : this.value,
      issuer: data.issuer.present ? data.issuer.value : this.issuer,
      url: data.url.present ? data.url.value : this.url,
      phone: data.phone.present ? data.phone.value : this.phone,
      issuedOn: data.issuedOn.present ? data.issuedOn.value : this.issuedOn,
      notes: data.notes.present ? data.notes.value : this.notes,
      archived: data.archived.present ? data.archived.value : this.archived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IdentifierEntity(')
          ..write('id: $id, ')
          ..write('animalId: $animalId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('type: $type, ')
          ..write('value: $value, ')
          ..write('issuer: $issuer, ')
          ..write('url: $url, ')
          ..write('phone: $phone, ')
          ..write('issuedOn: $issuedOn, ')
          ..write('notes: $notes, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    animalId,
    createdAt,
    updatedAt,
    type,
    value,
    issuer,
    url,
    phone,
    issuedOn,
    notes,
    archived,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IdentifierEntity &&
          other.id == this.id &&
          other.animalId == this.animalId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.type == this.type &&
          other.value == this.value &&
          other.issuer == this.issuer &&
          other.url == this.url &&
          other.phone == this.phone &&
          other.issuedOn == this.issuedOn &&
          other.notes == this.notes &&
          other.archived == this.archived);
}

class IdentifierRowsCompanion extends UpdateCompanion<IdentifierEntity> {
  final Value<String> id;
  final Value<String> animalId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> type;
  final Value<String> value;
  final Value<String?> issuer;
  final Value<String?> url;
  final Value<String?> phone;
  final Value<DateTime?> issuedOn;
  final Value<String?> notes;
  final Value<bool> archived;
  final Value<int> rowid;
  const IdentifierRowsCompanion({
    this.id = const Value.absent(),
    this.animalId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.type = const Value.absent(),
    this.value = const Value.absent(),
    this.issuer = const Value.absent(),
    this.url = const Value.absent(),
    this.phone = const Value.absent(),
    this.issuedOn = const Value.absent(),
    this.notes = const Value.absent(),
    this.archived = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IdentifierRowsCompanion.insert({
    required String id,
    required String animalId,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String type,
    required String value,
    this.issuer = const Value.absent(),
    this.url = const Value.absent(),
    this.phone = const Value.absent(),
    this.issuedOn = const Value.absent(),
    this.notes = const Value.absent(),
    this.archived = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       animalId = Value(animalId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       type = Value(type),
       value = Value(value);
  static Insertable<IdentifierEntity> custom({
    Expression<String>? id,
    Expression<String>? animalId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? type,
    Expression<String>? value,
    Expression<String>? issuer,
    Expression<String>? url,
    Expression<String>? phone,
    Expression<DateTime>? issuedOn,
    Expression<String>? notes,
    Expression<bool>? archived,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (animalId != null) 'animal_id': animalId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (type != null) 'type': type,
      if (value != null) 'value': value,
      if (issuer != null) 'issuer': issuer,
      if (url != null) 'url': url,
      if (phone != null) 'phone': phone,
      if (issuedOn != null) 'issued_on': issuedOn,
      if (notes != null) 'notes': notes,
      if (archived != null) 'archived': archived,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IdentifierRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? animalId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? type,
    Value<String>? value,
    Value<String?>? issuer,
    Value<String?>? url,
    Value<String?>? phone,
    Value<DateTime?>? issuedOn,
    Value<String?>? notes,
    Value<bool>? archived,
    Value<int>? rowid,
  }) {
    return IdentifierRowsCompanion(
      id: id ?? this.id,
      animalId: animalId ?? this.animalId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      type: type ?? this.type,
      value: value ?? this.value,
      issuer: issuer ?? this.issuer,
      url: url ?? this.url,
      phone: phone ?? this.phone,
      issuedOn: issuedOn ?? this.issuedOn,
      notes: notes ?? this.notes,
      archived: archived ?? this.archived,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (animalId.present) {
      map['animal_id'] = Variable<String>(animalId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (issuer.present) {
      map['issuer'] = Variable<String>(issuer.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (issuedOn.present) {
      map['issued_on'] = Variable<DateTime>(issuedOn.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IdentifierRowsCompanion(')
          ..write('id: $id, ')
          ..write('animalId: $animalId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('type: $type, ')
          ..write('value: $value, ')
          ..write('issuer: $issuer, ')
          ..write('url: $url, ')
          ..write('phone: $phone, ')
          ..write('issuedOn: $issuedOn, ')
          ..write('notes: $notes, ')
          ..write('archived: $archived, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RespiratorySessionRowsTable extends RespiratorySessionRows
    with TableInfo<$RespiratorySessionRowsTable, RespiratorySessionEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RespiratorySessionRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _animalIdMeta = const VerificationMeta('animalId');
  @override
  late final GeneratedColumn<String> animalId = GeneratedColumn<String>(
    'animal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES animal_rows (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta('recordedAt');
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMillisecondsMeta = const VerificationMeta(
    'durationMilliseconds',
  );
  @override
  late final GeneratedColumn<int> durationMilliseconds = GeneratedColumn<int>(
    'duration_milliseconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _breathCountMeta = const VerificationMeta('breathCount');
  @override
  late final GeneratedColumn<int> breathCount = GeneratedColumn<int>(
    'breath_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ratePerMinuteMeta = const VerificationMeta('ratePerMinute');
  @override
  late final GeneratedColumn<double> ratePerMinute = GeneratedColumn<double>(
    'rate_per_minute',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contextMeta = const VerificationMeta('context');
  @override
  late final GeneratedColumn<String> context = GeneratedColumn<String>(
    'context',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _thresholdMinimumMeta = const VerificationMeta('thresholdMinimum');
  @override
  late final GeneratedColumn<double> thresholdMinimum = GeneratedColumn<double>(
    'threshold_minimum',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _thresholdTargetMeta = const VerificationMeta('thresholdTarget');
  @override
  late final GeneratedColumn<double> thresholdTarget = GeneratedColumn<double>(
    'threshold_target',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _thresholdMaximumMeta = const VerificationMeta('thresholdMaximum');
  @override
  late final GeneratedColumn<double> thresholdMaximum = GeneratedColumn<double>(
    'threshold_maximum',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    animalId,
    createdAt,
    updatedAt,
    recordedAt,
    durationMilliseconds,
    breathCount,
    ratePerMinute,
    context,
    note,
    thresholdMinimum,
    thresholdTarget,
    thresholdMaximum,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'respiratory_session_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<RespiratorySessionEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('animal_id')) {
      context.handle(
        _animalIdMeta,
        animalId.isAcceptableOrUnknown(data['animal_id']!, _animalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_animalIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('duration_milliseconds')) {
      context.handle(
        _durationMillisecondsMeta,
        durationMilliseconds.isAcceptableOrUnknown(
          data['duration_milliseconds']!,
          _durationMillisecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMillisecondsMeta);
    }
    if (data.containsKey('breath_count')) {
      context.handle(
        _breathCountMeta,
        breathCount.isAcceptableOrUnknown(data['breath_count']!, _breathCountMeta),
      );
    } else if (isInserting) {
      context.missing(_breathCountMeta);
    }
    if (data.containsKey('rate_per_minute')) {
      context.handle(
        _ratePerMinuteMeta,
        ratePerMinute.isAcceptableOrUnknown(data['rate_per_minute']!, _ratePerMinuteMeta),
      );
    } else if (isInserting) {
      context.missing(_ratePerMinuteMeta);
    }
    if (data.containsKey('context')) {
      context.handle(
        _contextMeta,
        this.context.isAcceptableOrUnknown(data['context']!, _contextMeta),
      );
    } else if (isInserting) {
      context.missing(_contextMeta);
    }
    if (data.containsKey('note')) {
      context.handle(_noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('threshold_minimum')) {
      context.handle(
        _thresholdMinimumMeta,
        thresholdMinimum.isAcceptableOrUnknown(data['threshold_minimum']!, _thresholdMinimumMeta),
      );
    }
    if (data.containsKey('threshold_target')) {
      context.handle(
        _thresholdTargetMeta,
        thresholdTarget.isAcceptableOrUnknown(data['threshold_target']!, _thresholdTargetMeta),
      );
    }
    if (data.containsKey('threshold_maximum')) {
      context.handle(
        _thresholdMaximumMeta,
        thresholdMaximum.isAcceptableOrUnknown(data['threshold_maximum']!, _thresholdMaximumMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RespiratorySessionEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RespiratorySessionEntity(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      animalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}animal_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recorded_at'],
      )!,
      durationMilliseconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_milliseconds'],
      )!,
      breathCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}breath_count'],
      )!,
      ratePerMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rate_per_minute'],
      )!,
      context: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}context'],
      )!,
      note: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}note']),
      thresholdMinimum: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}threshold_minimum'],
      ),
      thresholdTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}threshold_target'],
      ),
      thresholdMaximum: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}threshold_maximum'],
      ),
    );
  }

  @override
  $RespiratorySessionRowsTable createAlias(String alias) {
    return $RespiratorySessionRowsTable(attachedDatabase, alias);
  }
}

class RespiratorySessionEntity extends DataClass implements Insertable<RespiratorySessionEntity> {
  final String id;
  final String animalId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime recordedAt;
  final int durationMilliseconds;
  final int breathCount;
  final double ratePerMinute;
  final String context;
  final String? note;
  final double? thresholdMinimum;
  final double? thresholdTarget;
  final double? thresholdMaximum;
  const RespiratorySessionEntity({
    required this.id,
    required this.animalId,
    required this.createdAt,
    required this.updatedAt,
    required this.recordedAt,
    required this.durationMilliseconds,
    required this.breathCount,
    required this.ratePerMinute,
    required this.context,
    this.note,
    this.thresholdMinimum,
    this.thresholdTarget,
    this.thresholdMaximum,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['animal_id'] = Variable<String>(animalId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    map['duration_milliseconds'] = Variable<int>(durationMilliseconds);
    map['breath_count'] = Variable<int>(breathCount);
    map['rate_per_minute'] = Variable<double>(ratePerMinute);
    map['context'] = Variable<String>(context);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || thresholdMinimum != null) {
      map['threshold_minimum'] = Variable<double>(thresholdMinimum);
    }
    if (!nullToAbsent || thresholdTarget != null) {
      map['threshold_target'] = Variable<double>(thresholdTarget);
    }
    if (!nullToAbsent || thresholdMaximum != null) {
      map['threshold_maximum'] = Variable<double>(thresholdMaximum);
    }
    return map;
  }

  RespiratorySessionRowsCompanion toCompanion(bool nullToAbsent) {
    return RespiratorySessionRowsCompanion(
      id: Value(id),
      animalId: Value(animalId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      recordedAt: Value(recordedAt),
      durationMilliseconds: Value(durationMilliseconds),
      breathCount: Value(breathCount),
      ratePerMinute: Value(ratePerMinute),
      context: Value(context),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      thresholdMinimum: thresholdMinimum == null && nullToAbsent
          ? const Value.absent()
          : Value(thresholdMinimum),
      thresholdTarget: thresholdTarget == null && nullToAbsent
          ? const Value.absent()
          : Value(thresholdTarget),
      thresholdMaximum: thresholdMaximum == null && nullToAbsent
          ? const Value.absent()
          : Value(thresholdMaximum),
    );
  }

  factory RespiratorySessionEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RespiratorySessionEntity(
      id: serializer.fromJson<String>(json['id']),
      animalId: serializer.fromJson<String>(json['animalId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      durationMilliseconds: serializer.fromJson<int>(json['durationMilliseconds']),
      breathCount: serializer.fromJson<int>(json['breathCount']),
      ratePerMinute: serializer.fromJson<double>(json['ratePerMinute']),
      context: serializer.fromJson<String>(json['context']),
      note: serializer.fromJson<String?>(json['note']),
      thresholdMinimum: serializer.fromJson<double?>(json['thresholdMinimum']),
      thresholdTarget: serializer.fromJson<double?>(json['thresholdTarget']),
      thresholdMaximum: serializer.fromJson<double?>(json['thresholdMaximum']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'animalId': serializer.toJson<String>(animalId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'durationMilliseconds': serializer.toJson<int>(durationMilliseconds),
      'breathCount': serializer.toJson<int>(breathCount),
      'ratePerMinute': serializer.toJson<double>(ratePerMinute),
      'context': serializer.toJson<String>(context),
      'note': serializer.toJson<String?>(note),
      'thresholdMinimum': serializer.toJson<double?>(thresholdMinimum),
      'thresholdTarget': serializer.toJson<double?>(thresholdTarget),
      'thresholdMaximum': serializer.toJson<double?>(thresholdMaximum),
    };
  }

  RespiratorySessionEntity copyWith({
    String? id,
    String? animalId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? recordedAt,
    int? durationMilliseconds,
    int? breathCount,
    double? ratePerMinute,
    String? context,
    Value<String?> note = const Value.absent(),
    Value<double?> thresholdMinimum = const Value.absent(),
    Value<double?> thresholdTarget = const Value.absent(),
    Value<double?> thresholdMaximum = const Value.absent(),
  }) => RespiratorySessionEntity(
    id: id ?? this.id,
    animalId: animalId ?? this.animalId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    recordedAt: recordedAt ?? this.recordedAt,
    durationMilliseconds: durationMilliseconds ?? this.durationMilliseconds,
    breathCount: breathCount ?? this.breathCount,
    ratePerMinute: ratePerMinute ?? this.ratePerMinute,
    context: context ?? this.context,
    note: note.present ? note.value : this.note,
    thresholdMinimum: thresholdMinimum.present ? thresholdMinimum.value : this.thresholdMinimum,
    thresholdTarget: thresholdTarget.present ? thresholdTarget.value : this.thresholdTarget,
    thresholdMaximum: thresholdMaximum.present ? thresholdMaximum.value : this.thresholdMaximum,
  );
  RespiratorySessionEntity copyWithCompanion(RespiratorySessionRowsCompanion data) {
    return RespiratorySessionEntity(
      id: data.id.present ? data.id.value : this.id,
      animalId: data.animalId.present ? data.animalId.value : this.animalId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      recordedAt: data.recordedAt.present ? data.recordedAt.value : this.recordedAt,
      durationMilliseconds: data.durationMilliseconds.present
          ? data.durationMilliseconds.value
          : this.durationMilliseconds,
      breathCount: data.breathCount.present ? data.breathCount.value : this.breathCount,
      ratePerMinute: data.ratePerMinute.present ? data.ratePerMinute.value : this.ratePerMinute,
      context: data.context.present ? data.context.value : this.context,
      note: data.note.present ? data.note.value : this.note,
      thresholdMinimum: data.thresholdMinimum.present
          ? data.thresholdMinimum.value
          : this.thresholdMinimum,
      thresholdTarget: data.thresholdTarget.present
          ? data.thresholdTarget.value
          : this.thresholdTarget,
      thresholdMaximum: data.thresholdMaximum.present
          ? data.thresholdMaximum.value
          : this.thresholdMaximum,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RespiratorySessionEntity(')
          ..write('id: $id, ')
          ..write('animalId: $animalId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('durationMilliseconds: $durationMilliseconds, ')
          ..write('breathCount: $breathCount, ')
          ..write('ratePerMinute: $ratePerMinute, ')
          ..write('context: $context, ')
          ..write('note: $note, ')
          ..write('thresholdMinimum: $thresholdMinimum, ')
          ..write('thresholdTarget: $thresholdTarget, ')
          ..write('thresholdMaximum: $thresholdMaximum')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    animalId,
    createdAt,
    updatedAt,
    recordedAt,
    durationMilliseconds,
    breathCount,
    ratePerMinute,
    context,
    note,
    thresholdMinimum,
    thresholdTarget,
    thresholdMaximum,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RespiratorySessionEntity &&
          other.id == this.id &&
          other.animalId == this.animalId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.recordedAt == this.recordedAt &&
          other.durationMilliseconds == this.durationMilliseconds &&
          other.breathCount == this.breathCount &&
          other.ratePerMinute == this.ratePerMinute &&
          other.context == this.context &&
          other.note == this.note &&
          other.thresholdMinimum == this.thresholdMinimum &&
          other.thresholdTarget == this.thresholdTarget &&
          other.thresholdMaximum == this.thresholdMaximum);
}

class RespiratorySessionRowsCompanion extends UpdateCompanion<RespiratorySessionEntity> {
  final Value<String> id;
  final Value<String> animalId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime> recordedAt;
  final Value<int> durationMilliseconds;
  final Value<int> breathCount;
  final Value<double> ratePerMinute;
  final Value<String> context;
  final Value<String?> note;
  final Value<double?> thresholdMinimum;
  final Value<double?> thresholdTarget;
  final Value<double?> thresholdMaximum;
  final Value<int> rowid;
  const RespiratorySessionRowsCompanion({
    this.id = const Value.absent(),
    this.animalId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.durationMilliseconds = const Value.absent(),
    this.breathCount = const Value.absent(),
    this.ratePerMinute = const Value.absent(),
    this.context = const Value.absent(),
    this.note = const Value.absent(),
    this.thresholdMinimum = const Value.absent(),
    this.thresholdTarget = const Value.absent(),
    this.thresholdMaximum = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RespiratorySessionRowsCompanion.insert({
    required String id,
    required String animalId,
    required DateTime createdAt,
    required DateTime updatedAt,
    required DateTime recordedAt,
    required int durationMilliseconds,
    required int breathCount,
    required double ratePerMinute,
    required String context,
    this.note = const Value.absent(),
    this.thresholdMinimum = const Value.absent(),
    this.thresholdTarget = const Value.absent(),
    this.thresholdMaximum = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       animalId = Value(animalId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       recordedAt = Value(recordedAt),
       durationMilliseconds = Value(durationMilliseconds),
       breathCount = Value(breathCount),
       ratePerMinute = Value(ratePerMinute),
       context = Value(context);
  static Insertable<RespiratorySessionEntity> custom({
    Expression<String>? id,
    Expression<String>? animalId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? recordedAt,
    Expression<int>? durationMilliseconds,
    Expression<int>? breathCount,
    Expression<double>? ratePerMinute,
    Expression<String>? context,
    Expression<String>? note,
    Expression<double>? thresholdMinimum,
    Expression<double>? thresholdTarget,
    Expression<double>? thresholdMaximum,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (animalId != null) 'animal_id': animalId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (durationMilliseconds != null) 'duration_milliseconds': durationMilliseconds,
      if (breathCount != null) 'breath_count': breathCount,
      if (ratePerMinute != null) 'rate_per_minute': ratePerMinute,
      if (context != null) 'context': context,
      if (note != null) 'note': note,
      if (thresholdMinimum != null) 'threshold_minimum': thresholdMinimum,
      if (thresholdTarget != null) 'threshold_target': thresholdTarget,
      if (thresholdMaximum != null) 'threshold_maximum': thresholdMaximum,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RespiratorySessionRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? animalId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime>? recordedAt,
    Value<int>? durationMilliseconds,
    Value<int>? breathCount,
    Value<double>? ratePerMinute,
    Value<String>? context,
    Value<String?>? note,
    Value<double?>? thresholdMinimum,
    Value<double?>? thresholdTarget,
    Value<double?>? thresholdMaximum,
    Value<int>? rowid,
  }) {
    return RespiratorySessionRowsCompanion(
      id: id ?? this.id,
      animalId: animalId ?? this.animalId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      recordedAt: recordedAt ?? this.recordedAt,
      durationMilliseconds: durationMilliseconds ?? this.durationMilliseconds,
      breathCount: breathCount ?? this.breathCount,
      ratePerMinute: ratePerMinute ?? this.ratePerMinute,
      context: context ?? this.context,
      note: note ?? this.note,
      thresholdMinimum: thresholdMinimum ?? this.thresholdMinimum,
      thresholdTarget: thresholdTarget ?? this.thresholdTarget,
      thresholdMaximum: thresholdMaximum ?? this.thresholdMaximum,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (animalId.present) {
      map['animal_id'] = Variable<String>(animalId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (durationMilliseconds.present) {
      map['duration_milliseconds'] = Variable<int>(durationMilliseconds.value);
    }
    if (breathCount.present) {
      map['breath_count'] = Variable<int>(breathCount.value);
    }
    if (ratePerMinute.present) {
      map['rate_per_minute'] = Variable<double>(ratePerMinute.value);
    }
    if (context.present) {
      map['context'] = Variable<String>(context.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (thresholdMinimum.present) {
      map['threshold_minimum'] = Variable<double>(thresholdMinimum.value);
    }
    if (thresholdTarget.present) {
      map['threshold_target'] = Variable<double>(thresholdTarget.value);
    }
    if (thresholdMaximum.present) {
      map['threshold_maximum'] = Variable<double>(thresholdMaximum.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RespiratorySessionRowsCompanion(')
          ..write('id: $id, ')
          ..write('animalId: $animalId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('durationMilliseconds: $durationMilliseconds, ')
          ..write('breathCount: $breathCount, ')
          ..write('ratePerMinute: $ratePerMinute, ')
          ..write('context: $context, ')
          ..write('note: $note, ')
          ..write('thresholdMinimum: $thresholdMinimum, ')
          ..write('thresholdTarget: $thresholdTarget, ')
          ..write('thresholdMaximum: $thresholdMaximum, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RespiratoryReminderRowsTable extends RespiratoryReminderRows
    with TableInfo<$RespiratoryReminderRowsTable, RespiratoryReminderEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RespiratoryReminderRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _animalIdMeta = const VerificationMeta('animalId');
  @override
  late final GeneratedColumn<String> animalId = GeneratedColumn<String>(
    'animal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES animal_rows (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contextMeta = const VerificationMeta('context');
  @override
  late final GeneratedColumn<String> context = GeneratedColumn<String>(
    'context',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recurrenceMeta = const VerificationMeta('recurrence');
  @override
  late final GeneratedColumn<String> recurrence = GeneratedColumn<String>(
    'recurrence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeZoneIdMeta = const VerificationMeta('timeZoneId');
  @override
  late final GeneratedColumn<String> timeZoneId = GeneratedColumn<String>(
    'time_zone_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timesJsonMeta = const VerificationMeta('timesJson');
  @override
  late final GeneratedColumn<String> timesJson = GeneratedColumn<String>(
    'times_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _weekdaysJsonMeta = const VerificationMeta('weekdaysJson');
  @override
  late final GeneratedColumn<String> weekdaysJson = GeneratedColumn<String>(
    'weekdays_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta('enabled');
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("enabled" IN (0, 1))'),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    animalId,
    createdAt,
    updatedAt,
    startDate,
    endDate,
    context,
    recurrence,
    timeZoneId,
    timesJson,
    weekdaysJson,
    enabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'respiratory_reminder_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<RespiratoryReminderEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('animal_id')) {
      context.handle(
        _animalIdMeta,
        animalId.isAcceptableOrUnknown(data['animal_id']!, _animalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_animalIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta, endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    }
    if (data.containsKey('context')) {
      context.handle(
        _contextMeta,
        this.context.isAcceptableOrUnknown(data['context']!, _contextMeta),
      );
    } else if (isInserting) {
      context.missing(_contextMeta);
    }
    if (data.containsKey('recurrence')) {
      context.handle(
        _recurrenceMeta,
        recurrence.isAcceptableOrUnknown(data['recurrence']!, _recurrenceMeta),
      );
    } else if (isInserting) {
      context.missing(_recurrenceMeta);
    }
    if (data.containsKey('time_zone_id')) {
      context.handle(
        _timeZoneIdMeta,
        timeZoneId.isAcceptableOrUnknown(data['time_zone_id']!, _timeZoneIdMeta),
      );
    } else if (isInserting) {
      context.missing(_timeZoneIdMeta);
    }
    if (data.containsKey('times_json')) {
      context.handle(
        _timesJsonMeta,
        timesJson.isAcceptableOrUnknown(data['times_json']!, _timesJsonMeta),
      );
    }
    if (data.containsKey('weekdays_json')) {
      context.handle(
        _weekdaysJsonMeta,
        weekdaysJson.isAcceptableOrUnknown(data['weekdays_json']!, _weekdaysJsonMeta),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(_enabledMeta, enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RespiratoryReminderEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RespiratoryReminderEntity(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      animalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}animal_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      ),
      context: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}context'],
      )!,
      recurrence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recurrence'],
      )!,
      timeZoneId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_zone_id'],
      )!,
      timesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}times_json'],
      )!,
      weekdaysJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weekdays_json'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
    );
  }

  @override
  $RespiratoryReminderRowsTable createAlias(String alias) {
    return $RespiratoryReminderRowsTable(attachedDatabase, alias);
  }
}

class RespiratoryReminderEntity extends DataClass implements Insertable<RespiratoryReminderEntity> {
  final String id;
  final String animalId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime startDate;
  final DateTime? endDate;
  final String context;
  final String recurrence;
  final String timeZoneId;
  final String timesJson;
  final String weekdaysJson;
  final bool enabled;
  const RespiratoryReminderEntity({
    required this.id,
    required this.animalId,
    required this.createdAt,
    required this.updatedAt,
    required this.startDate,
    this.endDate,
    required this.context,
    required this.recurrence,
    required this.timeZoneId,
    required this.timesJson,
    required this.weekdaysJson,
    required this.enabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['animal_id'] = Variable<String>(animalId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    map['context'] = Variable<String>(context);
    map['recurrence'] = Variable<String>(recurrence);
    map['time_zone_id'] = Variable<String>(timeZoneId);
    map['times_json'] = Variable<String>(timesJson);
    map['weekdays_json'] = Variable<String>(weekdaysJson);
    map['enabled'] = Variable<bool>(enabled);
    return map;
  }

  RespiratoryReminderRowsCompanion toCompanion(bool nullToAbsent) {
    return RespiratoryReminderRowsCompanion(
      id: Value(id),
      animalId: Value(animalId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent ? const Value.absent() : Value(endDate),
      context: Value(context),
      recurrence: Value(recurrence),
      timeZoneId: Value(timeZoneId),
      timesJson: Value(timesJson),
      weekdaysJson: Value(weekdaysJson),
      enabled: Value(enabled),
    );
  }

  factory RespiratoryReminderEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RespiratoryReminderEntity(
      id: serializer.fromJson<String>(json['id']),
      animalId: serializer.fromJson<String>(json['animalId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      context: serializer.fromJson<String>(json['context']),
      recurrence: serializer.fromJson<String>(json['recurrence']),
      timeZoneId: serializer.fromJson<String>(json['timeZoneId']),
      timesJson: serializer.fromJson<String>(json['timesJson']),
      weekdaysJson: serializer.fromJson<String>(json['weekdaysJson']),
      enabled: serializer.fromJson<bool>(json['enabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'animalId': serializer.toJson<String>(animalId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'context': serializer.toJson<String>(context),
      'recurrence': serializer.toJson<String>(recurrence),
      'timeZoneId': serializer.toJson<String>(timeZoneId),
      'timesJson': serializer.toJson<String>(timesJson),
      'weekdaysJson': serializer.toJson<String>(weekdaysJson),
      'enabled': serializer.toJson<bool>(enabled),
    };
  }

  RespiratoryReminderEntity copyWith({
    String? id,
    String? animalId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? startDate,
    Value<DateTime?> endDate = const Value.absent(),
    String? context,
    String? recurrence,
    String? timeZoneId,
    String? timesJson,
    String? weekdaysJson,
    bool? enabled,
  }) => RespiratoryReminderEntity(
    id: id ?? this.id,
    animalId: animalId ?? this.animalId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    context: context ?? this.context,
    recurrence: recurrence ?? this.recurrence,
    timeZoneId: timeZoneId ?? this.timeZoneId,
    timesJson: timesJson ?? this.timesJson,
    weekdaysJson: weekdaysJson ?? this.weekdaysJson,
    enabled: enabled ?? this.enabled,
  );
  RespiratoryReminderEntity copyWithCompanion(RespiratoryReminderRowsCompanion data) {
    return RespiratoryReminderEntity(
      id: data.id.present ? data.id.value : this.id,
      animalId: data.animalId.present ? data.animalId.value : this.animalId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      context: data.context.present ? data.context.value : this.context,
      recurrence: data.recurrence.present ? data.recurrence.value : this.recurrence,
      timeZoneId: data.timeZoneId.present ? data.timeZoneId.value : this.timeZoneId,
      timesJson: data.timesJson.present ? data.timesJson.value : this.timesJson,
      weekdaysJson: data.weekdaysJson.present ? data.weekdaysJson.value : this.weekdaysJson,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RespiratoryReminderEntity(')
          ..write('id: $id, ')
          ..write('animalId: $animalId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('context: $context, ')
          ..write('recurrence: $recurrence, ')
          ..write('timeZoneId: $timeZoneId, ')
          ..write('timesJson: $timesJson, ')
          ..write('weekdaysJson: $weekdaysJson, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    animalId,
    createdAt,
    updatedAt,
    startDate,
    endDate,
    context,
    recurrence,
    timeZoneId,
    timesJson,
    weekdaysJson,
    enabled,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RespiratoryReminderEntity &&
          other.id == this.id &&
          other.animalId == this.animalId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.context == this.context &&
          other.recurrence == this.recurrence &&
          other.timeZoneId == this.timeZoneId &&
          other.timesJson == this.timesJson &&
          other.weekdaysJson == this.weekdaysJson &&
          other.enabled == this.enabled);
}

class RespiratoryReminderRowsCompanion extends UpdateCompanion<RespiratoryReminderEntity> {
  final Value<String> id;
  final Value<String> animalId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<String> context;
  final Value<String> recurrence;
  final Value<String> timeZoneId;
  final Value<String> timesJson;
  final Value<String> weekdaysJson;
  final Value<bool> enabled;
  final Value<int> rowid;
  const RespiratoryReminderRowsCompanion({
    this.id = const Value.absent(),
    this.animalId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.context = const Value.absent(),
    this.recurrence = const Value.absent(),
    this.timeZoneId = const Value.absent(),
    this.timesJson = const Value.absent(),
    this.weekdaysJson = const Value.absent(),
    this.enabled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RespiratoryReminderRowsCompanion.insert({
    required String id,
    required String animalId,
    required DateTime createdAt,
    required DateTime updatedAt,
    required DateTime startDate,
    this.endDate = const Value.absent(),
    required String context,
    required String recurrence,
    required String timeZoneId,
    this.timesJson = const Value.absent(),
    this.weekdaysJson = const Value.absent(),
    this.enabled = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       animalId = Value(animalId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       startDate = Value(startDate),
       context = Value(context),
       recurrence = Value(recurrence),
       timeZoneId = Value(timeZoneId);
  static Insertable<RespiratoryReminderEntity> custom({
    Expression<String>? id,
    Expression<String>? animalId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? context,
    Expression<String>? recurrence,
    Expression<String>? timeZoneId,
    Expression<String>? timesJson,
    Expression<String>? weekdaysJson,
    Expression<bool>? enabled,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (animalId != null) 'animal_id': animalId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (context != null) 'context': context,
      if (recurrence != null) 'recurrence': recurrence,
      if (timeZoneId != null) 'time_zone_id': timeZoneId,
      if (timesJson != null) 'times_json': timesJson,
      if (weekdaysJson != null) 'weekdays_json': weekdaysJson,
      if (enabled != null) 'enabled': enabled,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RespiratoryReminderRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? animalId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime>? startDate,
    Value<DateTime?>? endDate,
    Value<String>? context,
    Value<String>? recurrence,
    Value<String>? timeZoneId,
    Value<String>? timesJson,
    Value<String>? weekdaysJson,
    Value<bool>? enabled,
    Value<int>? rowid,
  }) {
    return RespiratoryReminderRowsCompanion(
      id: id ?? this.id,
      animalId: animalId ?? this.animalId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      context: context ?? this.context,
      recurrence: recurrence ?? this.recurrence,
      timeZoneId: timeZoneId ?? this.timeZoneId,
      timesJson: timesJson ?? this.timesJson,
      weekdaysJson: weekdaysJson ?? this.weekdaysJson,
      enabled: enabled ?? this.enabled,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (animalId.present) {
      map['animal_id'] = Variable<String>(animalId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (context.present) {
      map['context'] = Variable<String>(context.value);
    }
    if (recurrence.present) {
      map['recurrence'] = Variable<String>(recurrence.value);
    }
    if (timeZoneId.present) {
      map['time_zone_id'] = Variable<String>(timeZoneId.value);
    }
    if (timesJson.present) {
      map['times_json'] = Variable<String>(timesJson.value);
    }
    if (weekdaysJson.present) {
      map['weekdays_json'] = Variable<String>(weekdaysJson.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RespiratoryReminderRowsCompanion(')
          ..write('id: $id, ')
          ..write('animalId: $animalId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('context: $context, ')
          ..write('recurrence: $recurrence, ')
          ..write('timeZoneId: $timeZoneId, ')
          ..write('timesJson: $timesJson, ')
          ..write('weekdaysJson: $weekdaysJson, ')
          ..write('enabled: $enabled, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeightReminderRowsTable extends WeightReminderRows
    with TableInfo<$WeightReminderRowsTable, WeightReminderEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeightReminderRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _animalIdMeta = const VerificationMeta('animalId');
  @override
  late final GeneratedColumn<String> animalId = GeneratedColumn<String>(
    'animal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES animal_rows (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recurrenceMeta = const VerificationMeta('recurrence');
  @override
  late final GeneratedColumn<String> recurrence = GeneratedColumn<String>(
    'recurrence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeZoneIdMeta = const VerificationMeta('timeZoneId');
  @override
  late final GeneratedColumn<String> timeZoneId = GeneratedColumn<String>(
    'time_zone_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timesJsonMeta = const VerificationMeta('timesJson');
  @override
  late final GeneratedColumn<String> timesJson = GeneratedColumn<String>(
    'times_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _weekdaysJsonMeta = const VerificationMeta('weekdaysJson');
  @override
  late final GeneratedColumn<String> weekdaysJson = GeneratedColumn<String>(
    'weekdays_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta('enabled');
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("enabled" IN (0, 1))'),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    animalId,
    createdAt,
    updatedAt,
    startDate,
    endDate,
    recurrence,
    timeZoneId,
    timesJson,
    weekdaysJson,
    enabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weight_reminder_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeightReminderEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('animal_id')) {
      context.handle(
        _animalIdMeta,
        animalId.isAcceptableOrUnknown(data['animal_id']!, _animalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_animalIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta, endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    }
    if (data.containsKey('recurrence')) {
      context.handle(
        _recurrenceMeta,
        recurrence.isAcceptableOrUnknown(data['recurrence']!, _recurrenceMeta),
      );
    } else if (isInserting) {
      context.missing(_recurrenceMeta);
    }
    if (data.containsKey('time_zone_id')) {
      context.handle(
        _timeZoneIdMeta,
        timeZoneId.isAcceptableOrUnknown(data['time_zone_id']!, _timeZoneIdMeta),
      );
    } else if (isInserting) {
      context.missing(_timeZoneIdMeta);
    }
    if (data.containsKey('times_json')) {
      context.handle(
        _timesJsonMeta,
        timesJson.isAcceptableOrUnknown(data['times_json']!, _timesJsonMeta),
      );
    }
    if (data.containsKey('weekdays_json')) {
      context.handle(
        _weekdaysJsonMeta,
        weekdaysJson.isAcceptableOrUnknown(data['weekdays_json']!, _weekdaysJsonMeta),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(_enabledMeta, enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeightReminderEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeightReminderEntity(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      animalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}animal_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      ),
      recurrence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recurrence'],
      )!,
      timeZoneId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_zone_id'],
      )!,
      timesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}times_json'],
      )!,
      weekdaysJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weekdays_json'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
    );
  }

  @override
  $WeightReminderRowsTable createAlias(String alias) {
    return $WeightReminderRowsTable(attachedDatabase, alias);
  }
}

class WeightReminderEntity extends DataClass implements Insertable<WeightReminderEntity> {
  final String id;
  final String animalId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime startDate;
  final DateTime? endDate;
  final String recurrence;
  final String timeZoneId;
  final String timesJson;
  final String weekdaysJson;
  final bool enabled;
  const WeightReminderEntity({
    required this.id,
    required this.animalId,
    required this.createdAt,
    required this.updatedAt,
    required this.startDate,
    this.endDate,
    required this.recurrence,
    required this.timeZoneId,
    required this.timesJson,
    required this.weekdaysJson,
    required this.enabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['animal_id'] = Variable<String>(animalId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    map['recurrence'] = Variable<String>(recurrence);
    map['time_zone_id'] = Variable<String>(timeZoneId);
    map['times_json'] = Variable<String>(timesJson);
    map['weekdays_json'] = Variable<String>(weekdaysJson);
    map['enabled'] = Variable<bool>(enabled);
    return map;
  }

  WeightReminderRowsCompanion toCompanion(bool nullToAbsent) {
    return WeightReminderRowsCompanion(
      id: Value(id),
      animalId: Value(animalId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent ? const Value.absent() : Value(endDate),
      recurrence: Value(recurrence),
      timeZoneId: Value(timeZoneId),
      timesJson: Value(timesJson),
      weekdaysJson: Value(weekdaysJson),
      enabled: Value(enabled),
    );
  }

  factory WeightReminderEntity.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeightReminderEntity(
      id: serializer.fromJson<String>(json['id']),
      animalId: serializer.fromJson<String>(json['animalId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      recurrence: serializer.fromJson<String>(json['recurrence']),
      timeZoneId: serializer.fromJson<String>(json['timeZoneId']),
      timesJson: serializer.fromJson<String>(json['timesJson']),
      weekdaysJson: serializer.fromJson<String>(json['weekdaysJson']),
      enabled: serializer.fromJson<bool>(json['enabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'animalId': serializer.toJson<String>(animalId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'recurrence': serializer.toJson<String>(recurrence),
      'timeZoneId': serializer.toJson<String>(timeZoneId),
      'timesJson': serializer.toJson<String>(timesJson),
      'weekdaysJson': serializer.toJson<String>(weekdaysJson),
      'enabled': serializer.toJson<bool>(enabled),
    };
  }

  WeightReminderEntity copyWith({
    String? id,
    String? animalId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? startDate,
    Value<DateTime?> endDate = const Value.absent(),
    String? recurrence,
    String? timeZoneId,
    String? timesJson,
    String? weekdaysJson,
    bool? enabled,
  }) => WeightReminderEntity(
    id: id ?? this.id,
    animalId: animalId ?? this.animalId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    recurrence: recurrence ?? this.recurrence,
    timeZoneId: timeZoneId ?? this.timeZoneId,
    timesJson: timesJson ?? this.timesJson,
    weekdaysJson: weekdaysJson ?? this.weekdaysJson,
    enabled: enabled ?? this.enabled,
  );
  WeightReminderEntity copyWithCompanion(WeightReminderRowsCompanion data) {
    return WeightReminderEntity(
      id: data.id.present ? data.id.value : this.id,
      animalId: data.animalId.present ? data.animalId.value : this.animalId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      recurrence: data.recurrence.present ? data.recurrence.value : this.recurrence,
      timeZoneId: data.timeZoneId.present ? data.timeZoneId.value : this.timeZoneId,
      timesJson: data.timesJson.present ? data.timesJson.value : this.timesJson,
      weekdaysJson: data.weekdaysJson.present ? data.weekdaysJson.value : this.weekdaysJson,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeightReminderEntity(')
          ..write('id: $id, ')
          ..write('animalId: $animalId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('recurrence: $recurrence, ')
          ..write('timeZoneId: $timeZoneId, ')
          ..write('timesJson: $timesJson, ')
          ..write('weekdaysJson: $weekdaysJson, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    animalId,
    createdAt,
    updatedAt,
    startDate,
    endDate,
    recurrence,
    timeZoneId,
    timesJson,
    weekdaysJson,
    enabled,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeightReminderEntity &&
          other.id == this.id &&
          other.animalId == this.animalId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.recurrence == this.recurrence &&
          other.timeZoneId == this.timeZoneId &&
          other.timesJson == this.timesJson &&
          other.weekdaysJson == this.weekdaysJson &&
          other.enabled == this.enabled);
}

class WeightReminderRowsCompanion extends UpdateCompanion<WeightReminderEntity> {
  final Value<String> id;
  final Value<String> animalId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<String> recurrence;
  final Value<String> timeZoneId;
  final Value<String> timesJson;
  final Value<String> weekdaysJson;
  final Value<bool> enabled;
  final Value<int> rowid;
  const WeightReminderRowsCompanion({
    this.id = const Value.absent(),
    this.animalId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.recurrence = const Value.absent(),
    this.timeZoneId = const Value.absent(),
    this.timesJson = const Value.absent(),
    this.weekdaysJson = const Value.absent(),
    this.enabled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeightReminderRowsCompanion.insert({
    required String id,
    required String animalId,
    required DateTime createdAt,
    required DateTime updatedAt,
    required DateTime startDate,
    this.endDate = const Value.absent(),
    required String recurrence,
    required String timeZoneId,
    this.timesJson = const Value.absent(),
    this.weekdaysJson = const Value.absent(),
    this.enabled = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       animalId = Value(animalId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       startDate = Value(startDate),
       recurrence = Value(recurrence),
       timeZoneId = Value(timeZoneId);
  static Insertable<WeightReminderEntity> custom({
    Expression<String>? id,
    Expression<String>? animalId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? recurrence,
    Expression<String>? timeZoneId,
    Expression<String>? timesJson,
    Expression<String>? weekdaysJson,
    Expression<bool>? enabled,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (animalId != null) 'animal_id': animalId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (recurrence != null) 'recurrence': recurrence,
      if (timeZoneId != null) 'time_zone_id': timeZoneId,
      if (timesJson != null) 'times_json': timesJson,
      if (weekdaysJson != null) 'weekdays_json': weekdaysJson,
      if (enabled != null) 'enabled': enabled,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeightReminderRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? animalId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime>? startDate,
    Value<DateTime?>? endDate,
    Value<String>? recurrence,
    Value<String>? timeZoneId,
    Value<String>? timesJson,
    Value<String>? weekdaysJson,
    Value<bool>? enabled,
    Value<int>? rowid,
  }) {
    return WeightReminderRowsCompanion(
      id: id ?? this.id,
      animalId: animalId ?? this.animalId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      recurrence: recurrence ?? this.recurrence,
      timeZoneId: timeZoneId ?? this.timeZoneId,
      timesJson: timesJson ?? this.timesJson,
      weekdaysJson: weekdaysJson ?? this.weekdaysJson,
      enabled: enabled ?? this.enabled,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (animalId.present) {
      map['animal_id'] = Variable<String>(animalId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (recurrence.present) {
      map['recurrence'] = Variable<String>(recurrence.value);
    }
    if (timeZoneId.present) {
      map['time_zone_id'] = Variable<String>(timeZoneId.value);
    }
    if (timesJson.present) {
      map['times_json'] = Variable<String>(timesJson.value);
    }
    if (weekdaysJson.present) {
      map['weekdays_json'] = Variable<String>(weekdaysJson.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeightReminderRowsCompanion(')
          ..write('id: $id, ')
          ..write('animalId: $animalId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('recurrence: $recurrence, ')
          ..write('timeZoneId: $timeZoneId, ')
          ..write('timesJson: $timesJson, ')
          ..write('weekdaysJson: $weekdaysJson, ')
          ..write('enabled: $enabled, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicationRowsTable extends MedicationRows
    with TableInfo<$MedicationRowsTable, MedicationEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _animalIdMeta = const VerificationMeta('animalId');
  @override
  late final GeneratedColumn<String> animalId = GeneratedColumn<String>(
    'animal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES animal_rows (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _formMeta = const VerificationMeta('form');
  @override
  late final GeneratedColumn<String> form = GeneratedColumn<String>(
    'form',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doseAmountMeta = const VerificationMeta('doseAmount');
  @override
  late final GeneratedColumn<double> doseAmount = GeneratedColumn<double>(
    'dose_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doseUnitMeta = const VerificationMeta('doseUnit');
  @override
  late final GeneratedColumn<String> doseUnit = GeneratedColumn<String>(
    'dose_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _instructionsMeta = const VerificationMeta('instructions');
  @override
  late final GeneratedColumn<String> instructions = GeneratedColumn<String>(
    'instructions',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _strengthMeta = const VerificationMeta('strength');
  @override
  late final GeneratedColumn<String> strength = GeneratedColumn<String>(
    'strength',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _prescriberMeta = const VerificationMeta('prescriber');
  @override
  late final GeneratedColumn<String> prescriber = GeneratedColumn<String>(
    'prescriber',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pharmacyMeta = const VerificationMeta('pharmacy');
  @override
  late final GeneratedColumn<String> pharmacy = GeneratedColumn<String>(
    'pharmacy',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _prescriptionNumberMeta = const VerificationMeta(
    'prescriptionNumber',
  );
  @override
  late final GeneratedColumn<String> prescriptionNumber = GeneratedColumn<String>(
    'prescription_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _refillsRemainingMeta = const VerificationMeta('refillsRemaining');
  @override
  late final GeneratedColumn<int> refillsRemaining = GeneratedColumn<int>(
    'refills_remaining',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nextRefillDateMeta = const VerificationMeta('nextRefillDate');
  @override
  late final GeneratedColumn<DateTime> nextRefillDate = GeneratedColumn<DateTime>(
    'next_refill_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("active" IN (0, 1))'),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    animalId,
    createdAt,
    updatedAt,
    name,
    form,
    doseAmount,
    doseUnit,
    instructions,
    startDate,
    endDate,
    strength,
    prescriber,
    pharmacy,
    prescriptionNumber,
    refillsRemaining,
    nextRefillDate,
    notes,
    active,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medication_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicationEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('animal_id')) {
      context.handle(
        _animalIdMeta,
        animalId.isAcceptableOrUnknown(data['animal_id']!, _animalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_animalIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('form')) {
      context.handle(_formMeta, form.isAcceptableOrUnknown(data['form']!, _formMeta));
    } else if (isInserting) {
      context.missing(_formMeta);
    }
    if (data.containsKey('dose_amount')) {
      context.handle(
        _doseAmountMeta,
        doseAmount.isAcceptableOrUnknown(data['dose_amount']!, _doseAmountMeta),
      );
    } else if (isInserting) {
      context.missing(_doseAmountMeta);
    }
    if (data.containsKey('dose_unit')) {
      context.handle(
        _doseUnitMeta,
        doseUnit.isAcceptableOrUnknown(data['dose_unit']!, _doseUnitMeta),
      );
    } else if (isInserting) {
      context.missing(_doseUnitMeta);
    }
    if (data.containsKey('instructions')) {
      context.handle(
        _instructionsMeta,
        instructions.isAcceptableOrUnknown(data['instructions']!, _instructionsMeta),
      );
    } else if (isInserting) {
      context.missing(_instructionsMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta, endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    }
    if (data.containsKey('strength')) {
      context.handle(
        _strengthMeta,
        strength.isAcceptableOrUnknown(data['strength']!, _strengthMeta),
      );
    }
    if (data.containsKey('prescriber')) {
      context.handle(
        _prescriberMeta,
        prescriber.isAcceptableOrUnknown(data['prescriber']!, _prescriberMeta),
      );
    }
    if (data.containsKey('pharmacy')) {
      context.handle(
        _pharmacyMeta,
        pharmacy.isAcceptableOrUnknown(data['pharmacy']!, _pharmacyMeta),
      );
    }
    if (data.containsKey('prescription_number')) {
      context.handle(
        _prescriptionNumberMeta,
        prescriptionNumber.isAcceptableOrUnknown(
          data['prescription_number']!,
          _prescriptionNumberMeta,
        ),
      );
    }
    if (data.containsKey('refills_remaining')) {
      context.handle(
        _refillsRemainingMeta,
        refillsRemaining.isAcceptableOrUnknown(data['refills_remaining']!, _refillsRemainingMeta),
      );
    }
    if (data.containsKey('next_refill_date')) {
      context.handle(
        _nextRefillDateMeta,
        nextRefillDate.isAcceptableOrUnknown(data['next_refill_date']!, _nextRefillDateMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(_notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('active')) {
      context.handle(_activeMeta, active.isAcceptableOrUnknown(data['active']!, _activeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicationEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicationEntity(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      animalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}animal_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      form: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}form'])!,
      doseAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}dose_amount'],
      )!,
      doseUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dose_unit'],
      )!,
      instructions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instructions'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      ),
      strength: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}strength'],
      ),
      prescriber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prescriber'],
      ),
      pharmacy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pharmacy'],
      ),
      prescriptionNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prescription_number'],
      ),
      refillsRemaining: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}refills_remaining'],
      ),
      nextRefillDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_refill_date'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $MedicationRowsTable createAlias(String alias) {
    return $MedicationRowsTable(attachedDatabase, alias);
  }
}

class MedicationEntity extends DataClass implements Insertable<MedicationEntity> {
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
  final String? strength;
  final String? prescriber;
  final String? pharmacy;
  final String? prescriptionNumber;
  final int? refillsRemaining;
  final DateTime? nextRefillDate;
  final String? notes;
  final bool active;
  const MedicationEntity({
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
    this.strength,
    this.prescriber,
    this.pharmacy,
    this.prescriptionNumber,
    this.refillsRemaining,
    this.nextRefillDate,
    this.notes,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['animal_id'] = Variable<String>(animalId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['name'] = Variable<String>(name);
    map['form'] = Variable<String>(form);
    map['dose_amount'] = Variable<double>(doseAmount);
    map['dose_unit'] = Variable<String>(doseUnit);
    map['instructions'] = Variable<String>(instructions);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    if (!nullToAbsent || strength != null) {
      map['strength'] = Variable<String>(strength);
    }
    if (!nullToAbsent || prescriber != null) {
      map['prescriber'] = Variable<String>(prescriber);
    }
    if (!nullToAbsent || pharmacy != null) {
      map['pharmacy'] = Variable<String>(pharmacy);
    }
    if (!nullToAbsent || prescriptionNumber != null) {
      map['prescription_number'] = Variable<String>(prescriptionNumber);
    }
    if (!nullToAbsent || refillsRemaining != null) {
      map['refills_remaining'] = Variable<int>(refillsRemaining);
    }
    if (!nullToAbsent || nextRefillDate != null) {
      map['next_refill_date'] = Variable<DateTime>(nextRefillDate);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['active'] = Variable<bool>(active);
    return map;
  }

  MedicationRowsCompanion toCompanion(bool nullToAbsent) {
    return MedicationRowsCompanion(
      id: Value(id),
      animalId: Value(animalId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      name: Value(name),
      form: Value(form),
      doseAmount: Value(doseAmount),
      doseUnit: Value(doseUnit),
      instructions: Value(instructions),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent ? const Value.absent() : Value(endDate),
      strength: strength == null && nullToAbsent ? const Value.absent() : Value(strength),
      prescriber: prescriber == null && nullToAbsent ? const Value.absent() : Value(prescriber),
      pharmacy: pharmacy == null && nullToAbsent ? const Value.absent() : Value(pharmacy),
      prescriptionNumber: prescriptionNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(prescriptionNumber),
      refillsRemaining: refillsRemaining == null && nullToAbsent
          ? const Value.absent()
          : Value(refillsRemaining),
      nextRefillDate: nextRefillDate == null && nullToAbsent
          ? const Value.absent()
          : Value(nextRefillDate),
      notes: notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      active: Value(active),
    );
  }

  factory MedicationEntity.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicationEntity(
      id: serializer.fromJson<String>(json['id']),
      animalId: serializer.fromJson<String>(json['animalId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      name: serializer.fromJson<String>(json['name']),
      form: serializer.fromJson<String>(json['form']),
      doseAmount: serializer.fromJson<double>(json['doseAmount']),
      doseUnit: serializer.fromJson<String>(json['doseUnit']),
      instructions: serializer.fromJson<String>(json['instructions']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      strength: serializer.fromJson<String?>(json['strength']),
      prescriber: serializer.fromJson<String?>(json['prescriber']),
      pharmacy: serializer.fromJson<String?>(json['pharmacy']),
      prescriptionNumber: serializer.fromJson<String?>(json['prescriptionNumber']),
      refillsRemaining: serializer.fromJson<int?>(json['refillsRemaining']),
      nextRefillDate: serializer.fromJson<DateTime?>(json['nextRefillDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'animalId': serializer.toJson<String>(animalId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'name': serializer.toJson<String>(name),
      'form': serializer.toJson<String>(form),
      'doseAmount': serializer.toJson<double>(doseAmount),
      'doseUnit': serializer.toJson<String>(doseUnit),
      'instructions': serializer.toJson<String>(instructions),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'strength': serializer.toJson<String?>(strength),
      'prescriber': serializer.toJson<String?>(prescriber),
      'pharmacy': serializer.toJson<String?>(pharmacy),
      'prescriptionNumber': serializer.toJson<String?>(prescriptionNumber),
      'refillsRemaining': serializer.toJson<int?>(refillsRemaining),
      'nextRefillDate': serializer.toJson<DateTime?>(nextRefillDate),
      'notes': serializer.toJson<String?>(notes),
      'active': serializer.toJson<bool>(active),
    };
  }

  MedicationEntity copyWith({
    String? id,
    String? animalId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? name,
    String? form,
    double? doseAmount,
    String? doseUnit,
    String? instructions,
    DateTime? startDate,
    Value<DateTime?> endDate = const Value.absent(),
    Value<String?> strength = const Value.absent(),
    Value<String?> prescriber = const Value.absent(),
    Value<String?> pharmacy = const Value.absent(),
    Value<String?> prescriptionNumber = const Value.absent(),
    Value<int?> refillsRemaining = const Value.absent(),
    Value<DateTime?> nextRefillDate = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    bool? active,
  }) => MedicationEntity(
    id: id ?? this.id,
    animalId: animalId ?? this.animalId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    name: name ?? this.name,
    form: form ?? this.form,
    doseAmount: doseAmount ?? this.doseAmount,
    doseUnit: doseUnit ?? this.doseUnit,
    instructions: instructions ?? this.instructions,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    strength: strength.present ? strength.value : this.strength,
    prescriber: prescriber.present ? prescriber.value : this.prescriber,
    pharmacy: pharmacy.present ? pharmacy.value : this.pharmacy,
    prescriptionNumber: prescriptionNumber.present
        ? prescriptionNumber.value
        : this.prescriptionNumber,
    refillsRemaining: refillsRemaining.present ? refillsRemaining.value : this.refillsRemaining,
    nextRefillDate: nextRefillDate.present ? nextRefillDate.value : this.nextRefillDate,
    notes: notes.present ? notes.value : this.notes,
    active: active ?? this.active,
  );
  MedicationEntity copyWithCompanion(MedicationRowsCompanion data) {
    return MedicationEntity(
      id: data.id.present ? data.id.value : this.id,
      animalId: data.animalId.present ? data.animalId.value : this.animalId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      name: data.name.present ? data.name.value : this.name,
      form: data.form.present ? data.form.value : this.form,
      doseAmount: data.doseAmount.present ? data.doseAmount.value : this.doseAmount,
      doseUnit: data.doseUnit.present ? data.doseUnit.value : this.doseUnit,
      instructions: data.instructions.present ? data.instructions.value : this.instructions,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      strength: data.strength.present ? data.strength.value : this.strength,
      prescriber: data.prescriber.present ? data.prescriber.value : this.prescriber,
      pharmacy: data.pharmacy.present ? data.pharmacy.value : this.pharmacy,
      prescriptionNumber: data.prescriptionNumber.present
          ? data.prescriptionNumber.value
          : this.prescriptionNumber,
      refillsRemaining: data.refillsRemaining.present
          ? data.refillsRemaining.value
          : this.refillsRemaining,
      nextRefillDate: data.nextRefillDate.present ? data.nextRefillDate.value : this.nextRefillDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicationEntity(')
          ..write('id: $id, ')
          ..write('animalId: $animalId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('name: $name, ')
          ..write('form: $form, ')
          ..write('doseAmount: $doseAmount, ')
          ..write('doseUnit: $doseUnit, ')
          ..write('instructions: $instructions, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('strength: $strength, ')
          ..write('prescriber: $prescriber, ')
          ..write('pharmacy: $pharmacy, ')
          ..write('prescriptionNumber: $prescriptionNumber, ')
          ..write('refillsRemaining: $refillsRemaining, ')
          ..write('nextRefillDate: $nextRefillDate, ')
          ..write('notes: $notes, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    animalId,
    createdAt,
    updatedAt,
    name,
    form,
    doseAmount,
    doseUnit,
    instructions,
    startDate,
    endDate,
    strength,
    prescriber,
    pharmacy,
    prescriptionNumber,
    refillsRemaining,
    nextRefillDate,
    notes,
    active,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicationEntity &&
          other.id == this.id &&
          other.animalId == this.animalId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.name == this.name &&
          other.form == this.form &&
          other.doseAmount == this.doseAmount &&
          other.doseUnit == this.doseUnit &&
          other.instructions == this.instructions &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.strength == this.strength &&
          other.prescriber == this.prescriber &&
          other.pharmacy == this.pharmacy &&
          other.prescriptionNumber == this.prescriptionNumber &&
          other.refillsRemaining == this.refillsRemaining &&
          other.nextRefillDate == this.nextRefillDate &&
          other.notes == this.notes &&
          other.active == this.active);
}

class MedicationRowsCompanion extends UpdateCompanion<MedicationEntity> {
  final Value<String> id;
  final Value<String> animalId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> name;
  final Value<String> form;
  final Value<double> doseAmount;
  final Value<String> doseUnit;
  final Value<String> instructions;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<String?> strength;
  final Value<String?> prescriber;
  final Value<String?> pharmacy;
  final Value<String?> prescriptionNumber;
  final Value<int?> refillsRemaining;
  final Value<DateTime?> nextRefillDate;
  final Value<String?> notes;
  final Value<bool> active;
  final Value<int> rowid;
  const MedicationRowsCompanion({
    this.id = const Value.absent(),
    this.animalId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.form = const Value.absent(),
    this.doseAmount = const Value.absent(),
    this.doseUnit = const Value.absent(),
    this.instructions = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.strength = const Value.absent(),
    this.prescriber = const Value.absent(),
    this.pharmacy = const Value.absent(),
    this.prescriptionNumber = const Value.absent(),
    this.refillsRemaining = const Value.absent(),
    this.nextRefillDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicationRowsCompanion.insert({
    required String id,
    required String animalId,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String name,
    required String form,
    required double doseAmount,
    required String doseUnit,
    required String instructions,
    required DateTime startDate,
    this.endDate = const Value.absent(),
    this.strength = const Value.absent(),
    this.prescriber = const Value.absent(),
    this.pharmacy = const Value.absent(),
    this.prescriptionNumber = const Value.absent(),
    this.refillsRemaining = const Value.absent(),
    this.nextRefillDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       animalId = Value(animalId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       name = Value(name),
       form = Value(form),
       doseAmount = Value(doseAmount),
       doseUnit = Value(doseUnit),
       instructions = Value(instructions),
       startDate = Value(startDate);
  static Insertable<MedicationEntity> custom({
    Expression<String>? id,
    Expression<String>? animalId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? name,
    Expression<String>? form,
    Expression<double>? doseAmount,
    Expression<String>? doseUnit,
    Expression<String>? instructions,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? strength,
    Expression<String>? prescriber,
    Expression<String>? pharmacy,
    Expression<String>? prescriptionNumber,
    Expression<int>? refillsRemaining,
    Expression<DateTime>? nextRefillDate,
    Expression<String>? notes,
    Expression<bool>? active,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (animalId != null) 'animal_id': animalId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (name != null) 'name': name,
      if (form != null) 'form': form,
      if (doseAmount != null) 'dose_amount': doseAmount,
      if (doseUnit != null) 'dose_unit': doseUnit,
      if (instructions != null) 'instructions': instructions,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (strength != null) 'strength': strength,
      if (prescriber != null) 'prescriber': prescriber,
      if (pharmacy != null) 'pharmacy': pharmacy,
      if (prescriptionNumber != null) 'prescription_number': prescriptionNumber,
      if (refillsRemaining != null) 'refills_remaining': refillsRemaining,
      if (nextRefillDate != null) 'next_refill_date': nextRefillDate,
      if (notes != null) 'notes': notes,
      if (active != null) 'active': active,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicationRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? animalId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? name,
    Value<String>? form,
    Value<double>? doseAmount,
    Value<String>? doseUnit,
    Value<String>? instructions,
    Value<DateTime>? startDate,
    Value<DateTime?>? endDate,
    Value<String?>? strength,
    Value<String?>? prescriber,
    Value<String?>? pharmacy,
    Value<String?>? prescriptionNumber,
    Value<int?>? refillsRemaining,
    Value<DateTime?>? nextRefillDate,
    Value<String?>? notes,
    Value<bool>? active,
    Value<int>? rowid,
  }) {
    return MedicationRowsCompanion(
      id: id ?? this.id,
      animalId: animalId ?? this.animalId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      name: name ?? this.name,
      form: form ?? this.form,
      doseAmount: doseAmount ?? this.doseAmount,
      doseUnit: doseUnit ?? this.doseUnit,
      instructions: instructions ?? this.instructions,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      strength: strength ?? this.strength,
      prescriber: prescriber ?? this.prescriber,
      pharmacy: pharmacy ?? this.pharmacy,
      prescriptionNumber: prescriptionNumber ?? this.prescriptionNumber,
      refillsRemaining: refillsRemaining ?? this.refillsRemaining,
      nextRefillDate: nextRefillDate ?? this.nextRefillDate,
      notes: notes ?? this.notes,
      active: active ?? this.active,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (animalId.present) {
      map['animal_id'] = Variable<String>(animalId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (form.present) {
      map['form'] = Variable<String>(form.value);
    }
    if (doseAmount.present) {
      map['dose_amount'] = Variable<double>(doseAmount.value);
    }
    if (doseUnit.present) {
      map['dose_unit'] = Variable<String>(doseUnit.value);
    }
    if (instructions.present) {
      map['instructions'] = Variable<String>(instructions.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (strength.present) {
      map['strength'] = Variable<String>(strength.value);
    }
    if (prescriber.present) {
      map['prescriber'] = Variable<String>(prescriber.value);
    }
    if (pharmacy.present) {
      map['pharmacy'] = Variable<String>(pharmacy.value);
    }
    if (prescriptionNumber.present) {
      map['prescription_number'] = Variable<String>(prescriptionNumber.value);
    }
    if (refillsRemaining.present) {
      map['refills_remaining'] = Variable<int>(refillsRemaining.value);
    }
    if (nextRefillDate.present) {
      map['next_refill_date'] = Variable<DateTime>(nextRefillDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationRowsCompanion(')
          ..write('id: $id, ')
          ..write('animalId: $animalId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('name: $name, ')
          ..write('form: $form, ')
          ..write('doseAmount: $doseAmount, ')
          ..write('doseUnit: $doseUnit, ')
          ..write('instructions: $instructions, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('strength: $strength, ')
          ..write('prescriber: $prescriber, ')
          ..write('pharmacy: $pharmacy, ')
          ..write('prescriptionNumber: $prescriptionNumber, ')
          ..write('refillsRemaining: $refillsRemaining, ')
          ..write('nextRefillDate: $nextRefillDate, ')
          ..write('notes: $notes, ')
          ..write('active: $active, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicationScheduleRowsTable extends MedicationScheduleRows
    with TableInfo<$MedicationScheduleRowsTable, MedicationScheduleEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationScheduleRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _medicationIdMeta = const VerificationMeta('medicationId');
  @override
  late final GeneratedColumn<String> medicationId = GeneratedColumn<String>(
    'medication_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medication_rows (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _animalIdMeta = const VerificationMeta('animalId');
  @override
  late final GeneratedColumn<String> animalId = GeneratedColumn<String>(
    'animal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES animal_rows (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intervalHoursMeta = const VerificationMeta('intervalHours');
  @override
  late final GeneratedColumn<int> intervalHours = GeneratedColumn<int>(
    'interval_hours',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timesJsonMeta = const VerificationMeta('timesJson');
  @override
  late final GeneratedColumn<String> timesJson = GeneratedColumn<String>(
    'times_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _weekdaysJsonMeta = const VerificationMeta('weekdaysJson');
  @override
  late final GeneratedColumn<String> weekdaysJson = GeneratedColumn<String>(
    'weekdays_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _timeZoneIdMeta = const VerificationMeta('timeZoneId');
  @override
  late final GeneratedColumn<String> timeZoneId = GeneratedColumn<String>(
    'time_zone_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Etc/UTC'),
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta('enabled');
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("enabled" IN (0, 1))'),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    medicationId,
    animalId,
    createdAt,
    updatedAt,
    kind,
    intervalHours,
    timesJson,
    weekdaysJson,
    timeZoneId,
    enabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medication_schedule_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicationScheduleEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('medication_id')) {
      context.handle(
        _medicationIdMeta,
        medicationId.isAcceptableOrUnknown(data['medication_id']!, _medicationIdMeta),
      );
    } else if (isInserting) {
      context.missing(_medicationIdMeta);
    }
    if (data.containsKey('animal_id')) {
      context.handle(
        _animalIdMeta,
        animalId.isAcceptableOrUnknown(data['animal_id']!, _animalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_animalIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(_kindMeta, kind.isAcceptableOrUnknown(data['kind']!, _kindMeta));
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('interval_hours')) {
      context.handle(
        _intervalHoursMeta,
        intervalHours.isAcceptableOrUnknown(data['interval_hours']!, _intervalHoursMeta),
      );
    }
    if (data.containsKey('times_json')) {
      context.handle(
        _timesJsonMeta,
        timesJson.isAcceptableOrUnknown(data['times_json']!, _timesJsonMeta),
      );
    }
    if (data.containsKey('weekdays_json')) {
      context.handle(
        _weekdaysJsonMeta,
        weekdaysJson.isAcceptableOrUnknown(data['weekdays_json']!, _weekdaysJsonMeta),
      );
    }
    if (data.containsKey('time_zone_id')) {
      context.handle(
        _timeZoneIdMeta,
        timeZoneId.isAcceptableOrUnknown(data['time_zone_id']!, _timeZoneIdMeta),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(_enabledMeta, enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicationScheduleEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicationScheduleEntity(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      medicationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medication_id'],
      )!,
      animalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}animal_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      kind: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}kind'])!,
      intervalHours: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval_hours'],
      ),
      timesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}times_json'],
      )!,
      weekdaysJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weekdays_json'],
      )!,
      timeZoneId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_zone_id'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
    );
  }

  @override
  $MedicationScheduleRowsTable createAlias(String alias) {
    return $MedicationScheduleRowsTable(attachedDatabase, alias);
  }
}

class MedicationScheduleEntity extends DataClass implements Insertable<MedicationScheduleEntity> {
  final String id;
  final String medicationId;
  final String animalId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String kind;
  final int? intervalHours;
  final String timesJson;
  final String weekdaysJson;
  final String timeZoneId;
  final bool enabled;
  const MedicationScheduleEntity({
    required this.id,
    required this.medicationId,
    required this.animalId,
    required this.createdAt,
    required this.updatedAt,
    required this.kind,
    this.intervalHours,
    required this.timesJson,
    required this.weekdaysJson,
    required this.timeZoneId,
    required this.enabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['medication_id'] = Variable<String>(medicationId);
    map['animal_id'] = Variable<String>(animalId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || intervalHours != null) {
      map['interval_hours'] = Variable<int>(intervalHours);
    }
    map['times_json'] = Variable<String>(timesJson);
    map['weekdays_json'] = Variable<String>(weekdaysJson);
    map['time_zone_id'] = Variable<String>(timeZoneId);
    map['enabled'] = Variable<bool>(enabled);
    return map;
  }

  MedicationScheduleRowsCompanion toCompanion(bool nullToAbsent) {
    return MedicationScheduleRowsCompanion(
      id: Value(id),
      medicationId: Value(medicationId),
      animalId: Value(animalId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      kind: Value(kind),
      intervalHours: intervalHours == null && nullToAbsent
          ? const Value.absent()
          : Value(intervalHours),
      timesJson: Value(timesJson),
      weekdaysJson: Value(weekdaysJson),
      timeZoneId: Value(timeZoneId),
      enabled: Value(enabled),
    );
  }

  factory MedicationScheduleEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicationScheduleEntity(
      id: serializer.fromJson<String>(json['id']),
      medicationId: serializer.fromJson<String>(json['medicationId']),
      animalId: serializer.fromJson<String>(json['animalId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      kind: serializer.fromJson<String>(json['kind']),
      intervalHours: serializer.fromJson<int?>(json['intervalHours']),
      timesJson: serializer.fromJson<String>(json['timesJson']),
      weekdaysJson: serializer.fromJson<String>(json['weekdaysJson']),
      timeZoneId: serializer.fromJson<String>(json['timeZoneId']),
      enabled: serializer.fromJson<bool>(json['enabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'medicationId': serializer.toJson<String>(medicationId),
      'animalId': serializer.toJson<String>(animalId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'kind': serializer.toJson<String>(kind),
      'intervalHours': serializer.toJson<int?>(intervalHours),
      'timesJson': serializer.toJson<String>(timesJson),
      'weekdaysJson': serializer.toJson<String>(weekdaysJson),
      'timeZoneId': serializer.toJson<String>(timeZoneId),
      'enabled': serializer.toJson<bool>(enabled),
    };
  }

  MedicationScheduleEntity copyWith({
    String? id,
    String? medicationId,
    String? animalId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? kind,
    Value<int?> intervalHours = const Value.absent(),
    String? timesJson,
    String? weekdaysJson,
    String? timeZoneId,
    bool? enabled,
  }) => MedicationScheduleEntity(
    id: id ?? this.id,
    medicationId: medicationId ?? this.medicationId,
    animalId: animalId ?? this.animalId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    kind: kind ?? this.kind,
    intervalHours: intervalHours.present ? intervalHours.value : this.intervalHours,
    timesJson: timesJson ?? this.timesJson,
    weekdaysJson: weekdaysJson ?? this.weekdaysJson,
    timeZoneId: timeZoneId ?? this.timeZoneId,
    enabled: enabled ?? this.enabled,
  );
  MedicationScheduleEntity copyWithCompanion(MedicationScheduleRowsCompanion data) {
    return MedicationScheduleEntity(
      id: data.id.present ? data.id.value : this.id,
      medicationId: data.medicationId.present ? data.medicationId.value : this.medicationId,
      animalId: data.animalId.present ? data.animalId.value : this.animalId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      kind: data.kind.present ? data.kind.value : this.kind,
      intervalHours: data.intervalHours.present ? data.intervalHours.value : this.intervalHours,
      timesJson: data.timesJson.present ? data.timesJson.value : this.timesJson,
      weekdaysJson: data.weekdaysJson.present ? data.weekdaysJson.value : this.weekdaysJson,
      timeZoneId: data.timeZoneId.present ? data.timeZoneId.value : this.timeZoneId,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicationScheduleEntity(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('animalId: $animalId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('kind: $kind, ')
          ..write('intervalHours: $intervalHours, ')
          ..write('timesJson: $timesJson, ')
          ..write('weekdaysJson: $weekdaysJson, ')
          ..write('timeZoneId: $timeZoneId, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    medicationId,
    animalId,
    createdAt,
    updatedAt,
    kind,
    intervalHours,
    timesJson,
    weekdaysJson,
    timeZoneId,
    enabled,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicationScheduleEntity &&
          other.id == this.id &&
          other.medicationId == this.medicationId &&
          other.animalId == this.animalId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.kind == this.kind &&
          other.intervalHours == this.intervalHours &&
          other.timesJson == this.timesJson &&
          other.weekdaysJson == this.weekdaysJson &&
          other.timeZoneId == this.timeZoneId &&
          other.enabled == this.enabled);
}

class MedicationScheduleRowsCompanion extends UpdateCompanion<MedicationScheduleEntity> {
  final Value<String> id;
  final Value<String> medicationId;
  final Value<String> animalId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> kind;
  final Value<int?> intervalHours;
  final Value<String> timesJson;
  final Value<String> weekdaysJson;
  final Value<String> timeZoneId;
  final Value<bool> enabled;
  final Value<int> rowid;
  const MedicationScheduleRowsCompanion({
    this.id = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.animalId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.kind = const Value.absent(),
    this.intervalHours = const Value.absent(),
    this.timesJson = const Value.absent(),
    this.weekdaysJson = const Value.absent(),
    this.timeZoneId = const Value.absent(),
    this.enabled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicationScheduleRowsCompanion.insert({
    required String id,
    required String medicationId,
    required String animalId,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String kind,
    this.intervalHours = const Value.absent(),
    this.timesJson = const Value.absent(),
    this.weekdaysJson = const Value.absent(),
    this.timeZoneId = const Value.absent(),
    this.enabled = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       medicationId = Value(medicationId),
       animalId = Value(animalId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       kind = Value(kind);
  static Insertable<MedicationScheduleEntity> custom({
    Expression<String>? id,
    Expression<String>? medicationId,
    Expression<String>? animalId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? kind,
    Expression<int>? intervalHours,
    Expression<String>? timesJson,
    Expression<String>? weekdaysJson,
    Expression<String>? timeZoneId,
    Expression<bool>? enabled,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicationId != null) 'medication_id': medicationId,
      if (animalId != null) 'animal_id': animalId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (kind != null) 'kind': kind,
      if (intervalHours != null) 'interval_hours': intervalHours,
      if (timesJson != null) 'times_json': timesJson,
      if (weekdaysJson != null) 'weekdays_json': weekdaysJson,
      if (timeZoneId != null) 'time_zone_id': timeZoneId,
      if (enabled != null) 'enabled': enabled,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicationScheduleRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? medicationId,
    Value<String>? animalId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? kind,
    Value<int?>? intervalHours,
    Value<String>? timesJson,
    Value<String>? weekdaysJson,
    Value<String>? timeZoneId,
    Value<bool>? enabled,
    Value<int>? rowid,
  }) {
    return MedicationScheduleRowsCompanion(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      animalId: animalId ?? this.animalId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      kind: kind ?? this.kind,
      intervalHours: intervalHours ?? this.intervalHours,
      timesJson: timesJson ?? this.timesJson,
      weekdaysJson: weekdaysJson ?? this.weekdaysJson,
      timeZoneId: timeZoneId ?? this.timeZoneId,
      enabled: enabled ?? this.enabled,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (medicationId.present) {
      map['medication_id'] = Variable<String>(medicationId.value);
    }
    if (animalId.present) {
      map['animal_id'] = Variable<String>(animalId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (intervalHours.present) {
      map['interval_hours'] = Variable<int>(intervalHours.value);
    }
    if (timesJson.present) {
      map['times_json'] = Variable<String>(timesJson.value);
    }
    if (weekdaysJson.present) {
      map['weekdays_json'] = Variable<String>(weekdaysJson.value);
    }
    if (timeZoneId.present) {
      map['time_zone_id'] = Variable<String>(timeZoneId.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationScheduleRowsCompanion(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('animalId: $animalId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('kind: $kind, ')
          ..write('intervalHours: $intervalHours, ')
          ..write('timesJson: $timesJson, ')
          ..write('weekdaysJson: $weekdaysJson, ')
          ..write('timeZoneId: $timeZoneId, ')
          ..write('enabled: $enabled, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DoseLedgerRowsTable extends DoseLedgerRows
    with TableInfo<$DoseLedgerRowsTable, DoseLedgerEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DoseLedgerRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _medicationIdMeta = const VerificationMeta('medicationId');
  @override
  late final GeneratedColumn<String> medicationId = GeneratedColumn<String>(
    'medication_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medication_rows (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _scheduleIdMeta = const VerificationMeta('scheduleId');
  @override
  late final GeneratedColumn<String> scheduleId = GeneratedColumn<String>(
    'schedule_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medication_schedule_rows (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _animalIdMeta = const VerificationMeta('animalId');
  @override
  late final GeneratedColumn<String> animalId = GeneratedColumn<String>(
    'animal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES animal_rows (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<DateTime> dueAt = GeneratedColumn<DateTime>(
    'due_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intendedLocalTimeMeta = const VerificationMeta(
    'intendedLocalTime',
  );
  @override
  late final GeneratedColumn<String> intendedLocalTime = GeneratedColumn<String>(
    'intended_local_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeZoneIdMeta = const VerificationMeta('timeZoneId');
  @override
  late final GeneratedColumn<String> timeZoneId = GeneratedColumn<String>(
    'time_zone_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _administeredAtMeta = const VerificationMeta('administeredAt');
  @override
  late final GeneratedColumn<DateTime> administeredAt = GeneratedColumn<DateTime>(
    'administered_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    medicationId,
    scheduleId,
    animalId,
    createdAt,
    updatedAt,
    dueAt,
    intendedLocalTime,
    timeZoneId,
    status,
    administeredAt,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dose_ledger_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<DoseLedgerEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('medication_id')) {
      context.handle(
        _medicationIdMeta,
        medicationId.isAcceptableOrUnknown(data['medication_id']!, _medicationIdMeta),
      );
    } else if (isInserting) {
      context.missing(_medicationIdMeta);
    }
    if (data.containsKey('schedule_id')) {
      context.handle(
        _scheduleIdMeta,
        scheduleId.isAcceptableOrUnknown(data['schedule_id']!, _scheduleIdMeta),
      );
    }
    if (data.containsKey('animal_id')) {
      context.handle(
        _animalIdMeta,
        animalId.isAcceptableOrUnknown(data['animal_id']!, _animalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_animalIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('due_at')) {
      context.handle(_dueAtMeta, dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta));
    } else if (isInserting) {
      context.missing(_dueAtMeta);
    }
    if (data.containsKey('intended_local_time')) {
      context.handle(
        _intendedLocalTimeMeta,
        intendedLocalTime.isAcceptableOrUnknown(
          data['intended_local_time']!,
          _intendedLocalTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_intendedLocalTimeMeta);
    }
    if (data.containsKey('time_zone_id')) {
      context.handle(
        _timeZoneIdMeta,
        timeZoneId.isAcceptableOrUnknown(data['time_zone_id']!, _timeZoneIdMeta),
      );
    } else if (isInserting) {
      context.missing(_timeZoneIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta, status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('administered_at')) {
      context.handle(
        _administeredAtMeta,
        administeredAt.isAcceptableOrUnknown(data['administered_at']!, _administeredAtMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(_noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DoseLedgerEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DoseLedgerEntity(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      medicationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medication_id'],
      )!,
      scheduleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}schedule_id'],
      ),
      animalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}animal_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      dueAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_at'],
      )!,
      intendedLocalTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}intended_local_time'],
      )!,
      timeZoneId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_zone_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      administeredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}administered_at'],
      ),
      note: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}note']),
    );
  }

  @override
  $DoseLedgerRowsTable createAlias(String alias) {
    return $DoseLedgerRowsTable(attachedDatabase, alias);
  }
}

class DoseLedgerEntity extends DataClass implements Insertable<DoseLedgerEntity> {
  final String id;
  final String medicationId;
  final String? scheduleId;
  final String animalId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime dueAt;
  final String intendedLocalTime;
  final String timeZoneId;
  final String status;
  final DateTime? administeredAt;
  final String? note;
  const DoseLedgerEntity({
    required this.id,
    required this.medicationId,
    this.scheduleId,
    required this.animalId,
    required this.createdAt,
    required this.updatedAt,
    required this.dueAt,
    required this.intendedLocalTime,
    required this.timeZoneId,
    required this.status,
    this.administeredAt,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['medication_id'] = Variable<String>(medicationId);
    if (!nullToAbsent || scheduleId != null) {
      map['schedule_id'] = Variable<String>(scheduleId);
    }
    map['animal_id'] = Variable<String>(animalId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['due_at'] = Variable<DateTime>(dueAt);
    map['intended_local_time'] = Variable<String>(intendedLocalTime);
    map['time_zone_id'] = Variable<String>(timeZoneId);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || administeredAt != null) {
      map['administered_at'] = Variable<DateTime>(administeredAt);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  DoseLedgerRowsCompanion toCompanion(bool nullToAbsent) {
    return DoseLedgerRowsCompanion(
      id: Value(id),
      medicationId: Value(medicationId),
      scheduleId: scheduleId == null && nullToAbsent ? const Value.absent() : Value(scheduleId),
      animalId: Value(animalId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      dueAt: Value(dueAt),
      intendedLocalTime: Value(intendedLocalTime),
      timeZoneId: Value(timeZoneId),
      status: Value(status),
      administeredAt: administeredAt == null && nullToAbsent
          ? const Value.absent()
          : Value(administeredAt),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory DoseLedgerEntity.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DoseLedgerEntity(
      id: serializer.fromJson<String>(json['id']),
      medicationId: serializer.fromJson<String>(json['medicationId']),
      scheduleId: serializer.fromJson<String?>(json['scheduleId']),
      animalId: serializer.fromJson<String>(json['animalId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      dueAt: serializer.fromJson<DateTime>(json['dueAt']),
      intendedLocalTime: serializer.fromJson<String>(json['intendedLocalTime']),
      timeZoneId: serializer.fromJson<String>(json['timeZoneId']),
      status: serializer.fromJson<String>(json['status']),
      administeredAt: serializer.fromJson<DateTime?>(json['administeredAt']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'medicationId': serializer.toJson<String>(medicationId),
      'scheduleId': serializer.toJson<String?>(scheduleId),
      'animalId': serializer.toJson<String>(animalId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'dueAt': serializer.toJson<DateTime>(dueAt),
      'intendedLocalTime': serializer.toJson<String>(intendedLocalTime),
      'timeZoneId': serializer.toJson<String>(timeZoneId),
      'status': serializer.toJson<String>(status),
      'administeredAt': serializer.toJson<DateTime?>(administeredAt),
      'note': serializer.toJson<String?>(note),
    };
  }

  DoseLedgerEntity copyWith({
    String? id,
    String? medicationId,
    Value<String?> scheduleId = const Value.absent(),
    String? animalId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? dueAt,
    String? intendedLocalTime,
    String? timeZoneId,
    String? status,
    Value<DateTime?> administeredAt = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => DoseLedgerEntity(
    id: id ?? this.id,
    medicationId: medicationId ?? this.medicationId,
    scheduleId: scheduleId.present ? scheduleId.value : this.scheduleId,
    animalId: animalId ?? this.animalId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    dueAt: dueAt ?? this.dueAt,
    intendedLocalTime: intendedLocalTime ?? this.intendedLocalTime,
    timeZoneId: timeZoneId ?? this.timeZoneId,
    status: status ?? this.status,
    administeredAt: administeredAt.present ? administeredAt.value : this.administeredAt,
    note: note.present ? note.value : this.note,
  );
  DoseLedgerEntity copyWithCompanion(DoseLedgerRowsCompanion data) {
    return DoseLedgerEntity(
      id: data.id.present ? data.id.value : this.id,
      medicationId: data.medicationId.present ? data.medicationId.value : this.medicationId,
      scheduleId: data.scheduleId.present ? data.scheduleId.value : this.scheduleId,
      animalId: data.animalId.present ? data.animalId.value : this.animalId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      intendedLocalTime: data.intendedLocalTime.present
          ? data.intendedLocalTime.value
          : this.intendedLocalTime,
      timeZoneId: data.timeZoneId.present ? data.timeZoneId.value : this.timeZoneId,
      status: data.status.present ? data.status.value : this.status,
      administeredAt: data.administeredAt.present ? data.administeredAt.value : this.administeredAt,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DoseLedgerEntity(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('scheduleId: $scheduleId, ')
          ..write('animalId: $animalId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('dueAt: $dueAt, ')
          ..write('intendedLocalTime: $intendedLocalTime, ')
          ..write('timeZoneId: $timeZoneId, ')
          ..write('status: $status, ')
          ..write('administeredAt: $administeredAt, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    medicationId,
    scheduleId,
    animalId,
    createdAt,
    updatedAt,
    dueAt,
    intendedLocalTime,
    timeZoneId,
    status,
    administeredAt,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DoseLedgerEntity &&
          other.id == this.id &&
          other.medicationId == this.medicationId &&
          other.scheduleId == this.scheduleId &&
          other.animalId == this.animalId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.dueAt == this.dueAt &&
          other.intendedLocalTime == this.intendedLocalTime &&
          other.timeZoneId == this.timeZoneId &&
          other.status == this.status &&
          other.administeredAt == this.administeredAt &&
          other.note == this.note);
}

class DoseLedgerRowsCompanion extends UpdateCompanion<DoseLedgerEntity> {
  final Value<String> id;
  final Value<String> medicationId;
  final Value<String?> scheduleId;
  final Value<String> animalId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime> dueAt;
  final Value<String> intendedLocalTime;
  final Value<String> timeZoneId;
  final Value<String> status;
  final Value<DateTime?> administeredAt;
  final Value<String?> note;
  final Value<int> rowid;
  const DoseLedgerRowsCompanion({
    this.id = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.scheduleId = const Value.absent(),
    this.animalId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.intendedLocalTime = const Value.absent(),
    this.timeZoneId = const Value.absent(),
    this.status = const Value.absent(),
    this.administeredAt = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DoseLedgerRowsCompanion.insert({
    required String id,
    required String medicationId,
    this.scheduleId = const Value.absent(),
    required String animalId,
    required DateTime createdAt,
    required DateTime updatedAt,
    required DateTime dueAt,
    required String intendedLocalTime,
    required String timeZoneId,
    required String status,
    this.administeredAt = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       medicationId = Value(medicationId),
       animalId = Value(animalId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       dueAt = Value(dueAt),
       intendedLocalTime = Value(intendedLocalTime),
       timeZoneId = Value(timeZoneId),
       status = Value(status);
  static Insertable<DoseLedgerEntity> custom({
    Expression<String>? id,
    Expression<String>? medicationId,
    Expression<String>? scheduleId,
    Expression<String>? animalId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? dueAt,
    Expression<String>? intendedLocalTime,
    Expression<String>? timeZoneId,
    Expression<String>? status,
    Expression<DateTime>? administeredAt,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicationId != null) 'medication_id': medicationId,
      if (scheduleId != null) 'schedule_id': scheduleId,
      if (animalId != null) 'animal_id': animalId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (dueAt != null) 'due_at': dueAt,
      if (intendedLocalTime != null) 'intended_local_time': intendedLocalTime,
      if (timeZoneId != null) 'time_zone_id': timeZoneId,
      if (status != null) 'status': status,
      if (administeredAt != null) 'administered_at': administeredAt,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DoseLedgerRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? medicationId,
    Value<String?>? scheduleId,
    Value<String>? animalId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime>? dueAt,
    Value<String>? intendedLocalTime,
    Value<String>? timeZoneId,
    Value<String>? status,
    Value<DateTime?>? administeredAt,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return DoseLedgerRowsCompanion(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      scheduleId: scheduleId ?? this.scheduleId,
      animalId: animalId ?? this.animalId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dueAt: dueAt ?? this.dueAt,
      intendedLocalTime: intendedLocalTime ?? this.intendedLocalTime,
      timeZoneId: timeZoneId ?? this.timeZoneId,
      status: status ?? this.status,
      administeredAt: administeredAt ?? this.administeredAt,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (medicationId.present) {
      map['medication_id'] = Variable<String>(medicationId.value);
    }
    if (scheduleId.present) {
      map['schedule_id'] = Variable<String>(scheduleId.value);
    }
    if (animalId.present) {
      map['animal_id'] = Variable<String>(animalId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<DateTime>(dueAt.value);
    }
    if (intendedLocalTime.present) {
      map['intended_local_time'] = Variable<String>(intendedLocalTime.value);
    }
    if (timeZoneId.present) {
      map['time_zone_id'] = Variable<String>(timeZoneId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (administeredAt.present) {
      map['administered_at'] = Variable<DateTime>(administeredAt.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DoseLedgerRowsCompanion(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('scheduleId: $scheduleId, ')
          ..write('animalId: $animalId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('dueAt: $dueAt, ')
          ..write('intendedLocalTime: $intendedLocalTime, ')
          ..write('timeZoneId: $timeZoneId, ')
          ..write('status: $status, ')
          ..write('administeredAt: $administeredAt, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HealthRecordRowsTable extends HealthRecordRows
    with TableInfo<$HealthRecordRowsTable, HealthRecordEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HealthRecordRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _animalIdMeta = const VerificationMeta('animalId');
  @override
  late final GeneratedColumn<String> animalId = GeneratedColumn<String>(
    'animal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES animal_rows (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta('occurredAt');
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _canonicalValueMeta = const VerificationMeta('canonicalValue');
  @override
  late final GeneratedColumn<double> canonicalValue = GeneratedColumn<double>(
    'canonical_value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _canonicalUnitMeta = const VerificationMeta('canonicalUnit');
  @override
  late final GeneratedColumn<String> canonicalUnit = GeneratedColumn<String>(
    'canonical_unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _enteredUnitMeta = const VerificationMeta('enteredUnit');
  @override
  late final GeneratedColumn<String> enteredUnit = GeneratedColumn<String>(
    'entered_unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta('archived');
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("archived" IN (0, 1))'),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    animalId,
    createdAt,
    updatedAt,
    occurredAt,
    kind,
    title,
    canonicalValue,
    canonicalUnit,
    enteredUnit,
    note,
    archived,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'health_record_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<HealthRecordEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('animal_id')) {
      context.handle(
        _animalIdMeta,
        animalId.isAcceptableOrUnknown(data['animal_id']!, _animalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_animalIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(_kindMeta, kind.isAcceptableOrUnknown(data['kind']!, _kindMeta));
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('title')) {
      context.handle(_titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('canonical_value')) {
      context.handle(
        _canonicalValueMeta,
        canonicalValue.isAcceptableOrUnknown(data['canonical_value']!, _canonicalValueMeta),
      );
    }
    if (data.containsKey('canonical_unit')) {
      context.handle(
        _canonicalUnitMeta,
        canonicalUnit.isAcceptableOrUnknown(data['canonical_unit']!, _canonicalUnitMeta),
      );
    }
    if (data.containsKey('entered_unit')) {
      context.handle(
        _enteredUnitMeta,
        enteredUnit.isAcceptableOrUnknown(data['entered_unit']!, _enteredUnitMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(_noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HealthRecordEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HealthRecordEntity(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      animalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}animal_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      kind: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}kind'])!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      canonicalValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}canonical_value'],
      ),
      canonicalUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}canonical_unit'],
      ),
      enteredUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entered_unit'],
      ),
      note: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}note']),
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
    );
  }

  @override
  $HealthRecordRowsTable createAlias(String alias) {
    return $HealthRecordRowsTable(attachedDatabase, alias);
  }
}

class HealthRecordEntity extends DataClass implements Insertable<HealthRecordEntity> {
  final String id;
  final String animalId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime occurredAt;
  final String kind;
  final String title;
  final double? canonicalValue;
  final String? canonicalUnit;
  final String? enteredUnit;
  final String? note;
  final bool archived;
  const HealthRecordEntity({
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
    required this.archived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['animal_id'] = Variable<String>(animalId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['kind'] = Variable<String>(kind);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || canonicalValue != null) {
      map['canonical_value'] = Variable<double>(canonicalValue);
    }
    if (!nullToAbsent || canonicalUnit != null) {
      map['canonical_unit'] = Variable<String>(canonicalUnit);
    }
    if (!nullToAbsent || enteredUnit != null) {
      map['entered_unit'] = Variable<String>(enteredUnit);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['archived'] = Variable<bool>(archived);
    return map;
  }

  HealthRecordRowsCompanion toCompanion(bool nullToAbsent) {
    return HealthRecordRowsCompanion(
      id: Value(id),
      animalId: Value(animalId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      occurredAt: Value(occurredAt),
      kind: Value(kind),
      title: Value(title),
      canonicalValue: canonicalValue == null && nullToAbsent
          ? const Value.absent()
          : Value(canonicalValue),
      canonicalUnit: canonicalUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(canonicalUnit),
      enteredUnit: enteredUnit == null && nullToAbsent ? const Value.absent() : Value(enteredUnit),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      archived: Value(archived),
    );
  }

  factory HealthRecordEntity.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HealthRecordEntity(
      id: serializer.fromJson<String>(json['id']),
      animalId: serializer.fromJson<String>(json['animalId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      kind: serializer.fromJson<String>(json['kind']),
      title: serializer.fromJson<String>(json['title']),
      canonicalValue: serializer.fromJson<double?>(json['canonicalValue']),
      canonicalUnit: serializer.fromJson<String?>(json['canonicalUnit']),
      enteredUnit: serializer.fromJson<String?>(json['enteredUnit']),
      note: serializer.fromJson<String?>(json['note']),
      archived: serializer.fromJson<bool>(json['archived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'animalId': serializer.toJson<String>(animalId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'kind': serializer.toJson<String>(kind),
      'title': serializer.toJson<String>(title),
      'canonicalValue': serializer.toJson<double?>(canonicalValue),
      'canonicalUnit': serializer.toJson<String?>(canonicalUnit),
      'enteredUnit': serializer.toJson<String?>(enteredUnit),
      'note': serializer.toJson<String?>(note),
      'archived': serializer.toJson<bool>(archived),
    };
  }

  HealthRecordEntity copyWith({
    String? id,
    String? animalId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? occurredAt,
    String? kind,
    String? title,
    Value<double?> canonicalValue = const Value.absent(),
    Value<String?> canonicalUnit = const Value.absent(),
    Value<String?> enteredUnit = const Value.absent(),
    Value<String?> note = const Value.absent(),
    bool? archived,
  }) => HealthRecordEntity(
    id: id ?? this.id,
    animalId: animalId ?? this.animalId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    occurredAt: occurredAt ?? this.occurredAt,
    kind: kind ?? this.kind,
    title: title ?? this.title,
    canonicalValue: canonicalValue.present ? canonicalValue.value : this.canonicalValue,
    canonicalUnit: canonicalUnit.present ? canonicalUnit.value : this.canonicalUnit,
    enteredUnit: enteredUnit.present ? enteredUnit.value : this.enteredUnit,
    note: note.present ? note.value : this.note,
    archived: archived ?? this.archived,
  );
  HealthRecordEntity copyWithCompanion(HealthRecordRowsCompanion data) {
    return HealthRecordEntity(
      id: data.id.present ? data.id.value : this.id,
      animalId: data.animalId.present ? data.animalId.value : this.animalId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      occurredAt: data.occurredAt.present ? data.occurredAt.value : this.occurredAt,
      kind: data.kind.present ? data.kind.value : this.kind,
      title: data.title.present ? data.title.value : this.title,
      canonicalValue: data.canonicalValue.present ? data.canonicalValue.value : this.canonicalValue,
      canonicalUnit: data.canonicalUnit.present ? data.canonicalUnit.value : this.canonicalUnit,
      enteredUnit: data.enteredUnit.present ? data.enteredUnit.value : this.enteredUnit,
      note: data.note.present ? data.note.value : this.note,
      archived: data.archived.present ? data.archived.value : this.archived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HealthRecordEntity(')
          ..write('id: $id, ')
          ..write('animalId: $animalId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('kind: $kind, ')
          ..write('title: $title, ')
          ..write('canonicalValue: $canonicalValue, ')
          ..write('canonicalUnit: $canonicalUnit, ')
          ..write('enteredUnit: $enteredUnit, ')
          ..write('note: $note, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    animalId,
    createdAt,
    updatedAt,
    occurredAt,
    kind,
    title,
    canonicalValue,
    canonicalUnit,
    enteredUnit,
    note,
    archived,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HealthRecordEntity &&
          other.id == this.id &&
          other.animalId == this.animalId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.occurredAt == this.occurredAt &&
          other.kind == this.kind &&
          other.title == this.title &&
          other.canonicalValue == this.canonicalValue &&
          other.canonicalUnit == this.canonicalUnit &&
          other.enteredUnit == this.enteredUnit &&
          other.note == this.note &&
          other.archived == this.archived);
}

class HealthRecordRowsCompanion extends UpdateCompanion<HealthRecordEntity> {
  final Value<String> id;
  final Value<String> animalId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime> occurredAt;
  final Value<String> kind;
  final Value<String> title;
  final Value<double?> canonicalValue;
  final Value<String?> canonicalUnit;
  final Value<String?> enteredUnit;
  final Value<String?> note;
  final Value<bool> archived;
  final Value<int> rowid;
  const HealthRecordRowsCompanion({
    this.id = const Value.absent(),
    this.animalId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.kind = const Value.absent(),
    this.title = const Value.absent(),
    this.canonicalValue = const Value.absent(),
    this.canonicalUnit = const Value.absent(),
    this.enteredUnit = const Value.absent(),
    this.note = const Value.absent(),
    this.archived = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HealthRecordRowsCompanion.insert({
    required String id,
    required String animalId,
    required DateTime createdAt,
    required DateTime updatedAt,
    required DateTime occurredAt,
    required String kind,
    required String title,
    this.canonicalValue = const Value.absent(),
    this.canonicalUnit = const Value.absent(),
    this.enteredUnit = const Value.absent(),
    this.note = const Value.absent(),
    this.archived = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       animalId = Value(animalId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       occurredAt = Value(occurredAt),
       kind = Value(kind),
       title = Value(title);
  static Insertable<HealthRecordEntity> custom({
    Expression<String>? id,
    Expression<String>? animalId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? occurredAt,
    Expression<String>? kind,
    Expression<String>? title,
    Expression<double>? canonicalValue,
    Expression<String>? canonicalUnit,
    Expression<String>? enteredUnit,
    Expression<String>? note,
    Expression<bool>? archived,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (animalId != null) 'animal_id': animalId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (kind != null) 'kind': kind,
      if (title != null) 'title': title,
      if (canonicalValue != null) 'canonical_value': canonicalValue,
      if (canonicalUnit != null) 'canonical_unit': canonicalUnit,
      if (enteredUnit != null) 'entered_unit': enteredUnit,
      if (note != null) 'note': note,
      if (archived != null) 'archived': archived,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HealthRecordRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? animalId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime>? occurredAt,
    Value<String>? kind,
    Value<String>? title,
    Value<double?>? canonicalValue,
    Value<String?>? canonicalUnit,
    Value<String?>? enteredUnit,
    Value<String?>? note,
    Value<bool>? archived,
    Value<int>? rowid,
  }) {
    return HealthRecordRowsCompanion(
      id: id ?? this.id,
      animalId: animalId ?? this.animalId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      occurredAt: occurredAt ?? this.occurredAt,
      kind: kind ?? this.kind,
      title: title ?? this.title,
      canonicalValue: canonicalValue ?? this.canonicalValue,
      canonicalUnit: canonicalUnit ?? this.canonicalUnit,
      enteredUnit: enteredUnit ?? this.enteredUnit,
      note: note ?? this.note,
      archived: archived ?? this.archived,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (animalId.present) {
      map['animal_id'] = Variable<String>(animalId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (canonicalValue.present) {
      map['canonical_value'] = Variable<double>(canonicalValue.value);
    }
    if (canonicalUnit.present) {
      map['canonical_unit'] = Variable<String>(canonicalUnit.value);
    }
    if (enteredUnit.present) {
      map['entered_unit'] = Variable<String>(enteredUnit.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HealthRecordRowsCompanion(')
          ..write('id: $id, ')
          ..write('animalId: $animalId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('kind: $kind, ')
          ..write('title: $title, ')
          ..write('canonicalValue: $canonicalValue, ')
          ..write('canonicalUnit: $canonicalUnit, ')
          ..write('enteredUnit: $enteredUnit, ')
          ..write('note: $note, ')
          ..write('archived: $archived, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CareDocumentRowsTable extends CareDocumentRows
    with TableInfo<$CareDocumentRowsTable, CareDocumentEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CareDocumentRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _animalIdMeta = const VerificationMeta('animalId');
  @override
  late final GeneratedColumn<String> animalId = GeneratedColumn<String>(
    'animal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES animal_rows (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _documentDateMeta = const VerificationMeta('documentDate');
  @override
  late final GeneratedColumn<DateTime> documentDate = GeneratedColumn<DateTime>(
    'document_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storedPathMeta = const VerificationMeta('storedPath');
  @override
  late final GeneratedColumn<String> storedPath = GeneratedColumn<String>(
    'stored_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mediaTypeMeta = const VerificationMeta('mediaType');
  @override
  late final GeneratedColumn<String> mediaType = GeneratedColumn<String>(
    'media_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _checksumSha256Meta = const VerificationMeta('checksumSha256');
  @override
  late final GeneratedColumn<String> checksumSha256 = GeneratedColumn<String>(
    'checksum_sha256',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _byteLengthMeta = const VerificationMeta('byteLength');
  @override
  late final GeneratedColumn<int> byteLength = GeneratedColumn<int>(
    'byte_length',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expiryDateMeta = const VerificationMeta('expiryDate');
  @override
  late final GeneratedColumn<DateTime> expiryDate = GeneratedColumn<DateTime>(
    'expiry_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reminderAtMeta = const VerificationMeta('reminderAt');
  @override
  late final GeneratedColumn<DateTime> reminderAt = GeneratedColumn<DateTime>(
    'reminder_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta('archived');
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("archived" IN (0, 1))'),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    animalId,
    createdAt,
    updatedAt,
    documentDate,
    title,
    category,
    storedPath,
    mediaType,
    checksumSha256,
    byteLength,
    notes,
    expiryDate,
    reminderAt,
    archived,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'care_document_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<CareDocumentEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('animal_id')) {
      context.handle(
        _animalIdMeta,
        animalId.isAcceptableOrUnknown(data['animal_id']!, _animalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_animalIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('document_date')) {
      context.handle(
        _documentDateMeta,
        documentDate.isAcceptableOrUnknown(data['document_date']!, _documentDateMeta),
      );
    } else if (isInserting) {
      context.missing(_documentDateMeta);
    }
    if (data.containsKey('title')) {
      context.handle(_titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('stored_path')) {
      context.handle(
        _storedPathMeta,
        storedPath.isAcceptableOrUnknown(data['stored_path']!, _storedPathMeta),
      );
    } else if (isInserting) {
      context.missing(_storedPathMeta);
    }
    if (data.containsKey('media_type')) {
      context.handle(
        _mediaTypeMeta,
        mediaType.isAcceptableOrUnknown(data['media_type']!, _mediaTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mediaTypeMeta);
    }
    if (data.containsKey('checksum_sha256')) {
      context.handle(
        _checksumSha256Meta,
        checksumSha256.isAcceptableOrUnknown(data['checksum_sha256']!, _checksumSha256Meta),
      );
    } else if (isInserting) {
      context.missing(_checksumSha256Meta);
    }
    if (data.containsKey('byte_length')) {
      context.handle(
        _byteLengthMeta,
        byteLength.isAcceptableOrUnknown(data['byte_length']!, _byteLengthMeta),
      );
    } else if (isInserting) {
      context.missing(_byteLengthMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(_notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('expiry_date')) {
      context.handle(
        _expiryDateMeta,
        expiryDate.isAcceptableOrUnknown(data['expiry_date']!, _expiryDateMeta),
      );
    }
    if (data.containsKey('reminder_at')) {
      context.handle(
        _reminderAtMeta,
        reminderAt.isAcceptableOrUnknown(data['reminder_at']!, _reminderAtMeta),
      );
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CareDocumentEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CareDocumentEntity(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      animalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}animal_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      documentDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}document_date'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      storedPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stored_path'],
      )!,
      mediaType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_type'],
      )!,
      checksumSha256: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}checksum_sha256'],
      )!,
      byteLength: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}byte_length'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      expiryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expiry_date'],
      ),
      reminderAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reminder_at'],
      ),
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
    );
  }

  @override
  $CareDocumentRowsTable createAlias(String alias) {
    return $CareDocumentRowsTable(attachedDatabase, alias);
  }
}

class CareDocumentEntity extends DataClass implements Insertable<CareDocumentEntity> {
  final String id;
  final String animalId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime documentDate;
  final String title;
  final String category;
  final String storedPath;
  final String mediaType;
  final String checksumSha256;
  final int byteLength;
  final String? notes;
  final DateTime? expiryDate;
  final DateTime? reminderAt;
  final bool archived;
  const CareDocumentEntity({
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
    this.reminderAt,
    required this.archived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['animal_id'] = Variable<String>(animalId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['document_date'] = Variable<DateTime>(documentDate);
    map['title'] = Variable<String>(title);
    map['category'] = Variable<String>(category);
    map['stored_path'] = Variable<String>(storedPath);
    map['media_type'] = Variable<String>(mediaType);
    map['checksum_sha256'] = Variable<String>(checksumSha256);
    map['byte_length'] = Variable<int>(byteLength);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || expiryDate != null) {
      map['expiry_date'] = Variable<DateTime>(expiryDate);
    }
    if (!nullToAbsent || reminderAt != null) {
      map['reminder_at'] = Variable<DateTime>(reminderAt);
    }
    map['archived'] = Variable<bool>(archived);
    return map;
  }

  CareDocumentRowsCompanion toCompanion(bool nullToAbsent) {
    return CareDocumentRowsCompanion(
      id: Value(id),
      animalId: Value(animalId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      documentDate: Value(documentDate),
      title: Value(title),
      category: Value(category),
      storedPath: Value(storedPath),
      mediaType: Value(mediaType),
      checksumSha256: Value(checksumSha256),
      byteLength: Value(byteLength),
      notes: notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      expiryDate: expiryDate == null && nullToAbsent ? const Value.absent() : Value(expiryDate),
      reminderAt: reminderAt == null && nullToAbsent ? const Value.absent() : Value(reminderAt),
      archived: Value(archived),
    );
  }

  factory CareDocumentEntity.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CareDocumentEntity(
      id: serializer.fromJson<String>(json['id']),
      animalId: serializer.fromJson<String>(json['animalId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      documentDate: serializer.fromJson<DateTime>(json['documentDate']),
      title: serializer.fromJson<String>(json['title']),
      category: serializer.fromJson<String>(json['category']),
      storedPath: serializer.fromJson<String>(json['storedPath']),
      mediaType: serializer.fromJson<String>(json['mediaType']),
      checksumSha256: serializer.fromJson<String>(json['checksumSha256']),
      byteLength: serializer.fromJson<int>(json['byteLength']),
      notes: serializer.fromJson<String?>(json['notes']),
      expiryDate: serializer.fromJson<DateTime?>(json['expiryDate']),
      reminderAt: serializer.fromJson<DateTime?>(json['reminderAt']),
      archived: serializer.fromJson<bool>(json['archived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'animalId': serializer.toJson<String>(animalId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'documentDate': serializer.toJson<DateTime>(documentDate),
      'title': serializer.toJson<String>(title),
      'category': serializer.toJson<String>(category),
      'storedPath': serializer.toJson<String>(storedPath),
      'mediaType': serializer.toJson<String>(mediaType),
      'checksumSha256': serializer.toJson<String>(checksumSha256),
      'byteLength': serializer.toJson<int>(byteLength),
      'notes': serializer.toJson<String?>(notes),
      'expiryDate': serializer.toJson<DateTime?>(expiryDate),
      'reminderAt': serializer.toJson<DateTime?>(reminderAt),
      'archived': serializer.toJson<bool>(archived),
    };
  }

  CareDocumentEntity copyWith({
    String? id,
    String? animalId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? documentDate,
    String? title,
    String? category,
    String? storedPath,
    String? mediaType,
    String? checksumSha256,
    int? byteLength,
    Value<String?> notes = const Value.absent(),
    Value<DateTime?> expiryDate = const Value.absent(),
    Value<DateTime?> reminderAt = const Value.absent(),
    bool? archived,
  }) => CareDocumentEntity(
    id: id ?? this.id,
    animalId: animalId ?? this.animalId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    documentDate: documentDate ?? this.documentDate,
    title: title ?? this.title,
    category: category ?? this.category,
    storedPath: storedPath ?? this.storedPath,
    mediaType: mediaType ?? this.mediaType,
    checksumSha256: checksumSha256 ?? this.checksumSha256,
    byteLength: byteLength ?? this.byteLength,
    notes: notes.present ? notes.value : this.notes,
    expiryDate: expiryDate.present ? expiryDate.value : this.expiryDate,
    reminderAt: reminderAt.present ? reminderAt.value : this.reminderAt,
    archived: archived ?? this.archived,
  );
  CareDocumentEntity copyWithCompanion(CareDocumentRowsCompanion data) {
    return CareDocumentEntity(
      id: data.id.present ? data.id.value : this.id,
      animalId: data.animalId.present ? data.animalId.value : this.animalId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      documentDate: data.documentDate.present ? data.documentDate.value : this.documentDate,
      title: data.title.present ? data.title.value : this.title,
      category: data.category.present ? data.category.value : this.category,
      storedPath: data.storedPath.present ? data.storedPath.value : this.storedPath,
      mediaType: data.mediaType.present ? data.mediaType.value : this.mediaType,
      checksumSha256: data.checksumSha256.present ? data.checksumSha256.value : this.checksumSha256,
      byteLength: data.byteLength.present ? data.byteLength.value : this.byteLength,
      notes: data.notes.present ? data.notes.value : this.notes,
      expiryDate: data.expiryDate.present ? data.expiryDate.value : this.expiryDate,
      reminderAt: data.reminderAt.present ? data.reminderAt.value : this.reminderAt,
      archived: data.archived.present ? data.archived.value : this.archived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CareDocumentEntity(')
          ..write('id: $id, ')
          ..write('animalId: $animalId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('documentDate: $documentDate, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('storedPath: $storedPath, ')
          ..write('mediaType: $mediaType, ')
          ..write('checksumSha256: $checksumSha256, ')
          ..write('byteLength: $byteLength, ')
          ..write('notes: $notes, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('reminderAt: $reminderAt, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    animalId,
    createdAt,
    updatedAt,
    documentDate,
    title,
    category,
    storedPath,
    mediaType,
    checksumSha256,
    byteLength,
    notes,
    expiryDate,
    reminderAt,
    archived,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CareDocumentEntity &&
          other.id == this.id &&
          other.animalId == this.animalId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.documentDate == this.documentDate &&
          other.title == this.title &&
          other.category == this.category &&
          other.storedPath == this.storedPath &&
          other.mediaType == this.mediaType &&
          other.checksumSha256 == this.checksumSha256 &&
          other.byteLength == this.byteLength &&
          other.notes == this.notes &&
          other.expiryDate == this.expiryDate &&
          other.reminderAt == this.reminderAt &&
          other.archived == this.archived);
}

class CareDocumentRowsCompanion extends UpdateCompanion<CareDocumentEntity> {
  final Value<String> id;
  final Value<String> animalId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime> documentDate;
  final Value<String> title;
  final Value<String> category;
  final Value<String> storedPath;
  final Value<String> mediaType;
  final Value<String> checksumSha256;
  final Value<int> byteLength;
  final Value<String?> notes;
  final Value<DateTime?> expiryDate;
  final Value<DateTime?> reminderAt;
  final Value<bool> archived;
  final Value<int> rowid;
  const CareDocumentRowsCompanion({
    this.id = const Value.absent(),
    this.animalId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.documentDate = const Value.absent(),
    this.title = const Value.absent(),
    this.category = const Value.absent(),
    this.storedPath = const Value.absent(),
    this.mediaType = const Value.absent(),
    this.checksumSha256 = const Value.absent(),
    this.byteLength = const Value.absent(),
    this.notes = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.reminderAt = const Value.absent(),
    this.archived = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CareDocumentRowsCompanion.insert({
    required String id,
    required String animalId,
    required DateTime createdAt,
    required DateTime updatedAt,
    required DateTime documentDate,
    required String title,
    required String category,
    required String storedPath,
    required String mediaType,
    required String checksumSha256,
    required int byteLength,
    this.notes = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.reminderAt = const Value.absent(),
    this.archived = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       animalId = Value(animalId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       documentDate = Value(documentDate),
       title = Value(title),
       category = Value(category),
       storedPath = Value(storedPath),
       mediaType = Value(mediaType),
       checksumSha256 = Value(checksumSha256),
       byteLength = Value(byteLength);
  static Insertable<CareDocumentEntity> custom({
    Expression<String>? id,
    Expression<String>? animalId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? documentDate,
    Expression<String>? title,
    Expression<String>? category,
    Expression<String>? storedPath,
    Expression<String>? mediaType,
    Expression<String>? checksumSha256,
    Expression<int>? byteLength,
    Expression<String>? notes,
    Expression<DateTime>? expiryDate,
    Expression<DateTime>? reminderAt,
    Expression<bool>? archived,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (animalId != null) 'animal_id': animalId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (documentDate != null) 'document_date': documentDate,
      if (title != null) 'title': title,
      if (category != null) 'category': category,
      if (storedPath != null) 'stored_path': storedPath,
      if (mediaType != null) 'media_type': mediaType,
      if (checksumSha256 != null) 'checksum_sha256': checksumSha256,
      if (byteLength != null) 'byte_length': byteLength,
      if (notes != null) 'notes': notes,
      if (expiryDate != null) 'expiry_date': expiryDate,
      if (reminderAt != null) 'reminder_at': reminderAt,
      if (archived != null) 'archived': archived,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CareDocumentRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? animalId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime>? documentDate,
    Value<String>? title,
    Value<String>? category,
    Value<String>? storedPath,
    Value<String>? mediaType,
    Value<String>? checksumSha256,
    Value<int>? byteLength,
    Value<String?>? notes,
    Value<DateTime?>? expiryDate,
    Value<DateTime?>? reminderAt,
    Value<bool>? archived,
    Value<int>? rowid,
  }) {
    return CareDocumentRowsCompanion(
      id: id ?? this.id,
      animalId: animalId ?? this.animalId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      documentDate: documentDate ?? this.documentDate,
      title: title ?? this.title,
      category: category ?? this.category,
      storedPath: storedPath ?? this.storedPath,
      mediaType: mediaType ?? this.mediaType,
      checksumSha256: checksumSha256 ?? this.checksumSha256,
      byteLength: byteLength ?? this.byteLength,
      notes: notes ?? this.notes,
      expiryDate: expiryDate ?? this.expiryDate,
      reminderAt: reminderAt ?? this.reminderAt,
      archived: archived ?? this.archived,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (animalId.present) {
      map['animal_id'] = Variable<String>(animalId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (documentDate.present) {
      map['document_date'] = Variable<DateTime>(documentDate.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (storedPath.present) {
      map['stored_path'] = Variable<String>(storedPath.value);
    }
    if (mediaType.present) {
      map['media_type'] = Variable<String>(mediaType.value);
    }
    if (checksumSha256.present) {
      map['checksum_sha256'] = Variable<String>(checksumSha256.value);
    }
    if (byteLength.present) {
      map['byte_length'] = Variable<int>(byteLength.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (expiryDate.present) {
      map['expiry_date'] = Variable<DateTime>(expiryDate.value);
    }
    if (reminderAt.present) {
      map['reminder_at'] = Variable<DateTime>(reminderAt.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CareDocumentRowsCompanion(')
          ..write('id: $id, ')
          ..write('animalId: $animalId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('documentDate: $documentDate, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('storedPath: $storedPath, ')
          ..write('mediaType: $mediaType, ')
          ..write('checksumSha256: $checksumSha256, ')
          ..write('byteLength: $byteLength, ')
          ..write('notes: $notes, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('reminderAt: $reminderAt, ')
          ..write('archived: $archived, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingRowsTable extends SettingRows with TableInfo<$SettingRowsTable, SettingEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jsonValueMeta = const VerificationMeta('jsonValue');
  @override
  late final GeneratedColumn<String> jsonValue = GeneratedColumn<String>(
    'json_value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, jsonValue];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'setting_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(_keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('json_value')) {
      context.handle(
        _jsonValueMeta,
        jsonValue.isAcceptableOrUnknown(data['json_value']!, _jsonValueMeta),
      );
    } else if (isInserting) {
      context.missing(_jsonValueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SettingEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingEntity(
      key: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      jsonValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}json_value'],
      )!,
    );
  }

  @override
  $SettingRowsTable createAlias(String alias) {
    return $SettingRowsTable(attachedDatabase, alias);
  }
}

class SettingEntity extends DataClass implements Insertable<SettingEntity> {
  final String key;
  final String jsonValue;
  const SettingEntity({required this.key, required this.jsonValue});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['json_value'] = Variable<String>(jsonValue);
    return map;
  }

  SettingRowsCompanion toCompanion(bool nullToAbsent) {
    return SettingRowsCompanion(key: Value(key), jsonValue: Value(jsonValue));
  }

  factory SettingEntity.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingEntity(
      key: serializer.fromJson<String>(json['key']),
      jsonValue: serializer.fromJson<String>(json['jsonValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'jsonValue': serializer.toJson<String>(jsonValue),
    };
  }

  SettingEntity copyWith({String? key, String? jsonValue}) =>
      SettingEntity(key: key ?? this.key, jsonValue: jsonValue ?? this.jsonValue);
  SettingEntity copyWithCompanion(SettingRowsCompanion data) {
    return SettingEntity(
      key: data.key.present ? data.key.value : this.key,
      jsonValue: data.jsonValue.present ? data.jsonValue.value : this.jsonValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingEntity(')
          ..write('key: $key, ')
          ..write('jsonValue: $jsonValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, jsonValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingEntity && other.key == this.key && other.jsonValue == this.jsonValue);
}

class SettingRowsCompanion extends UpdateCompanion<SettingEntity> {
  final Value<String> key;
  final Value<String> jsonValue;
  final Value<int> rowid;
  const SettingRowsCompanion({
    this.key = const Value.absent(),
    this.jsonValue = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingRowsCompanion.insert({
    required String key,
    required String jsonValue,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       jsonValue = Value(jsonValue);
  static Insertable<SettingEntity> custom({
    Expression<String>? key,
    Expression<String>? jsonValue,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (jsonValue != null) 'json_value': jsonValue,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingRowsCompanion copyWith({Value<String>? key, Value<String>? jsonValue, Value<int>? rowid}) {
    return SettingRowsCompanion(
      key: key ?? this.key,
      jsonValue: jsonValue ?? this.jsonValue,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (jsonValue.present) {
      map['json_value'] = Variable<String>(jsonValue.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingRowsCompanion(')
          ..write('key: $key, ')
          ..write('jsonValue: $jsonValue, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AnimalRowsTable animalRows = $AnimalRowsTable(this);
  late final $IdentifierRowsTable identifierRows = $IdentifierRowsTable(this);
  late final $RespiratorySessionRowsTable respiratorySessionRows = $RespiratorySessionRowsTable(
    this,
  );
  late final $RespiratoryReminderRowsTable respiratoryReminderRows = $RespiratoryReminderRowsTable(
    this,
  );
  late final $WeightReminderRowsTable weightReminderRows = $WeightReminderRowsTable(this);
  late final $MedicationRowsTable medicationRows = $MedicationRowsTable(this);
  late final $MedicationScheduleRowsTable medicationScheduleRows = $MedicationScheduleRowsTable(
    this,
  );
  late final $DoseLedgerRowsTable doseLedgerRows = $DoseLedgerRowsTable(this);
  late final $HealthRecordRowsTable healthRecordRows = $HealthRecordRowsTable(this);
  late final $CareDocumentRowsTable careDocumentRows = $CareDocumentRowsTable(this);
  late final $SettingRowsTable settingRows = $SettingRowsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    animalRows,
    identifierRows,
    respiratorySessionRows,
    respiratoryReminderRows,
    weightReminderRows,
    medicationRows,
    medicationScheduleRows,
    doseLedgerRows,
    healthRecordRows,
    careDocumentRows,
    settingRows,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName('animal_rows', limitUpdateKind: UpdateKind.delete),
      result: [TableUpdate('identifier_rows', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName('animal_rows', limitUpdateKind: UpdateKind.delete),
      result: [TableUpdate('respiratory_session_rows', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName('animal_rows', limitUpdateKind: UpdateKind.delete),
      result: [TableUpdate('respiratory_reminder_rows', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName('animal_rows', limitUpdateKind: UpdateKind.delete),
      result: [TableUpdate('weight_reminder_rows', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName('animal_rows', limitUpdateKind: UpdateKind.delete),
      result: [TableUpdate('medication_rows', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName('medication_rows', limitUpdateKind: UpdateKind.delete),
      result: [TableUpdate('medication_schedule_rows', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName('animal_rows', limitUpdateKind: UpdateKind.delete),
      result: [TableUpdate('medication_schedule_rows', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName('medication_rows', limitUpdateKind: UpdateKind.delete),
      result: [TableUpdate('dose_ledger_rows', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'medication_schedule_rows',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('dose_ledger_rows', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName('animal_rows', limitUpdateKind: UpdateKind.delete),
      result: [TableUpdate('dose_ledger_rows', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName('animal_rows', limitUpdateKind: UpdateKind.delete),
      result: [TableUpdate('health_record_rows', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName('animal_rows', limitUpdateKind: UpdateKind.delete),
      result: [TableUpdate('care_document_rows', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$AnimalRowsTableCreateCompanionBuilder = AnimalRowsCompanion Function({
  required String id,
  required DateTime createdAt,
  required DateTime updatedAt,
  required String name,
  Value<String?> photoPath,
  required String species,
  Value<String?> breed,
  Value<String?> sexOrStatus,
  Value<DateTime?> dateOfBirth,
  Value<int?> approximateAgeMonths,
  Value<String?> colorMarkings,
  Value<double?> currentWeightKg,
  Value<String?> notes,
  Value<bool> archived,
  Value<double?> thresholdMinimum,
  Value<double?> thresholdTarget,
  Value<double?> thresholdMaximum,
  Value<int> rowid,
});
typedef $$AnimalRowsTableUpdateCompanionBuilder = AnimalRowsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String> name,
  Value<String?> photoPath,
  Value<String> species,
  Value<String?> breed,
  Value<String?> sexOrStatus,
  Value<DateTime?> dateOfBirth,
  Value<int?> approximateAgeMonths,
  Value<String?> colorMarkings,
  Value<double?> currentWeightKg,
  Value<String?> notes,
  Value<bool> archived,
  Value<double?> thresholdMinimum,
  Value<double?> thresholdTarget,
  Value<double?> thresholdMaximum,
  Value<int> rowid,
});

final class $$AnimalRowsTableReferences
    extends BaseReferences<_$AppDatabase, $AnimalRowsTable, AnimalEntity> {
  $$AnimalRowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$IdentifierRowsTable, List<IdentifierEntity>> _identifierRowsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.identifierRows,
    aliasName: 'animal_rows__id__identifier_rows__animal_id',
  );

  $$IdentifierRowsTableProcessedTableManager get identifierRowsRefs {
    final manager = $$IdentifierRowsTableTableManager(
      $_db,
      $_db.identifierRows,
    ).filter((f) => f.animalId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_identifierRowsRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$RespiratorySessionRowsTable, List<RespiratorySessionEntity>>
  _respiratorySessionRowsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.respiratorySessionRows,
    aliasName: 'animal_rows__id__respiratory_session_rows__animal_id',
  );

  $$RespiratorySessionRowsTableProcessedTableManager get respiratorySessionRowsRefs {
    final manager = $$RespiratorySessionRowsTableTableManager(
      $_db,
      $_db.respiratorySessionRows,
    ).filter((f) => f.animalId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_respiratorySessionRowsRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$RespiratoryReminderRowsTable, List<RespiratoryReminderEntity>>
  _respiratoryReminderRowsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.respiratoryReminderRows,
    aliasName: 'animal_rows__id__respiratory_reminder_rows__animal_id',
  );

  $$RespiratoryReminderRowsTableProcessedTableManager get respiratoryReminderRowsRefs {
    final manager = $$RespiratoryReminderRowsTableTableManager(
      $_db,
      $_db.respiratoryReminderRows,
    ).filter((f) => f.animalId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_respiratoryReminderRowsRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$WeightReminderRowsTable, List<WeightReminderEntity>>
  _weightReminderRowsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.weightReminderRows,
    aliasName: 'animal_rows__id__weight_reminder_rows__animal_id',
  );

  $$WeightReminderRowsTableProcessedTableManager get weightReminderRowsRefs {
    final manager = $$WeightReminderRowsTableTableManager(
      $_db,
      $_db.weightReminderRows,
    ).filter((f) => f.animalId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_weightReminderRowsRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MedicationRowsTable, List<MedicationEntity>> _medicationRowsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.medicationRows,
    aliasName: 'animal_rows__id__medication_rows__animal_id',
  );

  $$MedicationRowsTableProcessedTableManager get medicationRowsRefs {
    final manager = $$MedicationRowsTableTableManager(
      $_db,
      $_db.medicationRows,
    ).filter((f) => f.animalId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_medicationRowsRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MedicationScheduleRowsTable, List<MedicationScheduleEntity>>
  _medicationScheduleRowsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.medicationScheduleRows,
    aliasName: 'animal_rows__id__medication_schedule_rows__animal_id',
  );

  $$MedicationScheduleRowsTableProcessedTableManager get medicationScheduleRowsRefs {
    final manager = $$MedicationScheduleRowsTableTableManager(
      $_db,
      $_db.medicationScheduleRows,
    ).filter((f) => f.animalId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_medicationScheduleRowsRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DoseLedgerRowsTable, List<DoseLedgerEntity>> _doseLedgerRowsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.doseLedgerRows,
    aliasName: 'animal_rows__id__dose_ledger_rows__animal_id',
  );

  $$DoseLedgerRowsTableProcessedTableManager get doseLedgerRowsRefs {
    final manager = $$DoseLedgerRowsTableTableManager(
      $_db,
      $_db.doseLedgerRows,
    ).filter((f) => f.animalId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_doseLedgerRowsRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$HealthRecordRowsTable, List<HealthRecordEntity>>
  _healthRecordRowsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.healthRecordRows,
    aliasName: 'animal_rows__id__health_record_rows__animal_id',
  );

  $$HealthRecordRowsTableProcessedTableManager get healthRecordRowsRefs {
    final manager = $$HealthRecordRowsTableTableManager(
      $_db,
      $_db.healthRecordRows,
    ).filter((f) => f.animalId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_healthRecordRowsRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$CareDocumentRowsTable, List<CareDocumentEntity>>
  _careDocumentRowsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.careDocumentRows,
    aliasName: 'animal_rows__id__care_document_rows__animal_id',
  );

  $$CareDocumentRowsTableProcessedTableManager get careDocumentRowsRefs {
    final manager = $$CareDocumentRowsTableTableManager(
      $_db,
      $_db.careDocumentRows,
    ).filter((f) => f.animalId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_careDocumentRowsRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$AnimalRowsTableFilterComposer extends Composer<_$AppDatabase, $AnimalRowsTable> {
  $$AnimalRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get species =>
      $composableBuilder(column: $table.species, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get breed =>
      $composableBuilder(column: $table.breed, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sexOrStatus =>
      $composableBuilder(column: $table.sexOrStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateOfBirth =>
      $composableBuilder(column: $table.dateOfBirth, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get approximateAgeMonths => $composableBuilder(
    column: $table.approximateAgeMonths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorMarkings =>
      $composableBuilder(column: $table.colorMarkings, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get currentWeightKg => $composableBuilder(
    column: $table.currentWeightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get thresholdMinimum => $composableBuilder(
    column: $table.thresholdMinimum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get thresholdTarget => $composableBuilder(
    column: $table.thresholdTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get thresholdMaximum => $composableBuilder(
    column: $table.thresholdMaximum,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> identifierRowsRefs(
    Expression<bool> Function($$IdentifierRowsTableFilterComposer f) f,
  ) {
    final $$IdentifierRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.identifierRows,
      getReferencedColumn: (t) => t.animalId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$IdentifierRowsTableFilterComposer(
            $db: $db,
            $table: $db.identifierRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> respiratorySessionRowsRefs(
    Expression<bool> Function($$RespiratorySessionRowsTableFilterComposer f) f,
  ) {
    final $$RespiratorySessionRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.respiratorySessionRows,
      getReferencedColumn: (t) => t.animalId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$RespiratorySessionRowsTableFilterComposer(
            $db: $db,
            $table: $db.respiratorySessionRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> respiratoryReminderRowsRefs(
    Expression<bool> Function($$RespiratoryReminderRowsTableFilterComposer f) f,
  ) {
    final $$RespiratoryReminderRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.respiratoryReminderRows,
      getReferencedColumn: (t) => t.animalId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$RespiratoryReminderRowsTableFilterComposer(
            $db: $db,
            $table: $db.respiratoryReminderRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> weightReminderRowsRefs(
    Expression<bool> Function($$WeightReminderRowsTableFilterComposer f) f,
  ) {
    final $$WeightReminderRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weightReminderRows,
      getReferencedColumn: (t) => t.animalId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$WeightReminderRowsTableFilterComposer(
            $db: $db,
            $table: $db.weightReminderRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> medicationRowsRefs(
    Expression<bool> Function($$MedicationRowsTableFilterComposer f) f,
  ) {
    final $$MedicationRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medicationRows,
      getReferencedColumn: (t) => t.animalId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$MedicationRowsTableFilterComposer(
            $db: $db,
            $table: $db.medicationRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> medicationScheduleRowsRefs(
    Expression<bool> Function($$MedicationScheduleRowsTableFilterComposer f) f,
  ) {
    final $$MedicationScheduleRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medicationScheduleRows,
      getReferencedColumn: (t) => t.animalId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$MedicationScheduleRowsTableFilterComposer(
            $db: $db,
            $table: $db.medicationScheduleRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> doseLedgerRowsRefs(
    Expression<bool> Function($$DoseLedgerRowsTableFilterComposer f) f,
  ) {
    final $$DoseLedgerRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.doseLedgerRows,
      getReferencedColumn: (t) => t.animalId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$DoseLedgerRowsTableFilterComposer(
            $db: $db,
            $table: $db.doseLedgerRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> healthRecordRowsRefs(
    Expression<bool> Function($$HealthRecordRowsTableFilterComposer f) f,
  ) {
    final $$HealthRecordRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.healthRecordRows,
      getReferencedColumn: (t) => t.animalId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$HealthRecordRowsTableFilterComposer(
            $db: $db,
            $table: $db.healthRecordRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> careDocumentRowsRefs(
    Expression<bool> Function($$CareDocumentRowsTableFilterComposer f) f,
  ) {
    final $$CareDocumentRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.careDocumentRows,
      getReferencedColumn: (t) => t.animalId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$CareDocumentRowsTableFilterComposer(
            $db: $db,
            $table: $db.careDocumentRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AnimalRowsTableOrderingComposer extends Composer<_$AppDatabase, $AnimalRowsTable> {
  $$AnimalRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get species =>
      $composableBuilder(column: $table.species, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get breed =>
      $composableBuilder(column: $table.breed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sexOrStatus =>
      $composableBuilder(column: $table.sexOrStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateOfBirth =>
      $composableBuilder(column: $table.dateOfBirth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get approximateAgeMonths => $composableBuilder(
    column: $table.approximateAgeMonths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorMarkings => $composableBuilder(
    column: $table.colorMarkings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get currentWeightKg => $composableBuilder(
    column: $table.currentWeightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get thresholdMinimum => $composableBuilder(
    column: $table.thresholdMinimum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get thresholdTarget => $composableBuilder(
    column: $table.thresholdTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get thresholdMaximum => $composableBuilder(
    column: $table.thresholdMaximum,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AnimalRowsTableAnnotationComposer extends Composer<_$AppDatabase, $AnimalRowsTable> {
  $$AnimalRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get species =>
      $composableBuilder(column: $table.species, builder: (column) => column);

  GeneratedColumn<String> get breed =>
      $composableBuilder(column: $table.breed, builder: (column) => column);

  GeneratedColumn<String> get sexOrStatus =>
      $composableBuilder(column: $table.sexOrStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get dateOfBirth =>
      $composableBuilder(column: $table.dateOfBirth, builder: (column) => column);

  GeneratedColumn<int> get approximateAgeMonths =>
      $composableBuilder(column: $table.approximateAgeMonths, builder: (column) => column);

  GeneratedColumn<String> get colorMarkings =>
      $composableBuilder(column: $table.colorMarkings, builder: (column) => column);

  GeneratedColumn<double> get currentWeightKg =>
      $composableBuilder(column: $table.currentWeightKg, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<double> get thresholdMinimum =>
      $composableBuilder(column: $table.thresholdMinimum, builder: (column) => column);

  GeneratedColumn<double> get thresholdTarget =>
      $composableBuilder(column: $table.thresholdTarget, builder: (column) => column);

  GeneratedColumn<double> get thresholdMaximum =>
      $composableBuilder(column: $table.thresholdMaximum, builder: (column) => column);

  Expression<T> identifierRowsRefs<T extends Object>(
    Expression<T> Function($$IdentifierRowsTableAnnotationComposer a) f,
  ) {
    final $$IdentifierRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.identifierRows,
      getReferencedColumn: (t) => t.animalId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$IdentifierRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.identifierRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> respiratorySessionRowsRefs<T extends Object>(
    Expression<T> Function($$RespiratorySessionRowsTableAnnotationComposer a) f,
  ) {
    final $$RespiratorySessionRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.respiratorySessionRows,
      getReferencedColumn: (t) => t.animalId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$RespiratorySessionRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.respiratorySessionRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> respiratoryReminderRowsRefs<T extends Object>(
    Expression<T> Function($$RespiratoryReminderRowsTableAnnotationComposer a) f,
  ) {
    final $$RespiratoryReminderRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.respiratoryReminderRows,
      getReferencedColumn: (t) => t.animalId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$RespiratoryReminderRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.respiratoryReminderRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> weightReminderRowsRefs<T extends Object>(
    Expression<T> Function($$WeightReminderRowsTableAnnotationComposer a) f,
  ) {
    final $$WeightReminderRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weightReminderRows,
      getReferencedColumn: (t) => t.animalId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$WeightReminderRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.weightReminderRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> medicationRowsRefs<T extends Object>(
    Expression<T> Function($$MedicationRowsTableAnnotationComposer a) f,
  ) {
    final $$MedicationRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medicationRows,
      getReferencedColumn: (t) => t.animalId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$MedicationRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.medicationRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> medicationScheduleRowsRefs<T extends Object>(
    Expression<T> Function($$MedicationScheduleRowsTableAnnotationComposer a) f,
  ) {
    final $$MedicationScheduleRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medicationScheduleRows,
      getReferencedColumn: (t) => t.animalId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$MedicationScheduleRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.medicationScheduleRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> doseLedgerRowsRefs<T extends Object>(
    Expression<T> Function($$DoseLedgerRowsTableAnnotationComposer a) f,
  ) {
    final $$DoseLedgerRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.doseLedgerRows,
      getReferencedColumn: (t) => t.animalId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$DoseLedgerRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.doseLedgerRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> healthRecordRowsRefs<T extends Object>(
    Expression<T> Function($$HealthRecordRowsTableAnnotationComposer a) f,
  ) {
    final $$HealthRecordRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.healthRecordRows,
      getReferencedColumn: (t) => t.animalId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$HealthRecordRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.healthRecordRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> careDocumentRowsRefs<T extends Object>(
    Expression<T> Function($$CareDocumentRowsTableAnnotationComposer a) f,
  ) {
    final $$CareDocumentRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.careDocumentRows,
      getReferencedColumn: (t) => t.animalId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$CareDocumentRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.careDocumentRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AnimalRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AnimalRowsTable,
          AnimalEntity,
          $$AnimalRowsTableFilterComposer,
          $$AnimalRowsTableOrderingComposer,
          $$AnimalRowsTableAnnotationComposer,
          $$AnimalRowsTableCreateCompanionBuilder,
          $$AnimalRowsTableUpdateCompanionBuilder,
          (AnimalEntity, $$AnimalRowsTableReferences),
          AnimalEntity,
          PrefetchHooks Function({
            bool identifierRowsRefs,
            bool respiratorySessionRowsRefs,
            bool respiratoryReminderRowsRefs,
            bool weightReminderRowsRefs,
            bool medicationRowsRefs,
            bool medicationScheduleRowsRefs,
            bool doseLedgerRowsRefs,
            bool healthRecordRowsRefs,
            bool careDocumentRowsRefs,
          })
        > {
  $$AnimalRowsTableTableManager(_$AppDatabase db, $AnimalRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$AnimalRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$AnimalRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AnimalRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<String> species = const Value.absent(),
                Value<String?> breed = const Value.absent(),
                Value<String?> sexOrStatus = const Value.absent(),
                Value<DateTime?> dateOfBirth = const Value.absent(),
                Value<int?> approximateAgeMonths = const Value.absent(),
                Value<String?> colorMarkings = const Value.absent(),
                Value<double?> currentWeightKg = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<double?> thresholdMinimum = const Value.absent(),
                Value<double?> thresholdTarget = const Value.absent(),
                Value<double?> thresholdMaximum = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AnimalRowsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                name: name,
                photoPath: photoPath,
                species: species,
                breed: breed,
                sexOrStatus: sexOrStatus,
                dateOfBirth: dateOfBirth,
                approximateAgeMonths: approximateAgeMonths,
                colorMarkings: colorMarkings,
                currentWeightKg: currentWeightKg,
                notes: notes,
                archived: archived,
                thresholdMinimum: thresholdMinimum,
                thresholdTarget: thresholdTarget,
                thresholdMaximum: thresholdMaximum,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                required String name,
                Value<String?> photoPath = const Value.absent(),
                required String species,
                Value<String?> breed = const Value.absent(),
                Value<String?> sexOrStatus = const Value.absent(),
                Value<DateTime?> dateOfBirth = const Value.absent(),
                Value<int?> approximateAgeMonths = const Value.absent(),
                Value<String?> colorMarkings = const Value.absent(),
                Value<double?> currentWeightKg = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<double?> thresholdMinimum = const Value.absent(),
                Value<double?> thresholdTarget = const Value.absent(),
                Value<double?> thresholdMaximum = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AnimalRowsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                name: name,
                photoPath: photoPath,
                species: species,
                breed: breed,
                sexOrStatus: sexOrStatus,
                dateOfBirth: dateOfBirth,
                approximateAgeMonths: approximateAgeMonths,
                colorMarkings: colorMarkings,
                currentWeightKg: currentWeightKg,
                notes: notes,
                archived: archived,
                thresholdMinimum: thresholdMinimum,
                thresholdTarget: thresholdTarget,
                thresholdMaximum: thresholdMaximum,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AnimalRowsTable, AnimalEntity>(table),
                  $$AnimalRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                identifierRowsRefs = false,
                respiratorySessionRowsRefs = false,
                respiratoryReminderRowsRefs = false,
                weightReminderRowsRefs = false,
                medicationRowsRefs = false,
                medicationScheduleRowsRefs = false,
                doseLedgerRowsRefs = false,
                healthRecordRowsRefs = false,
                careDocumentRowsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (identifierRowsRefs) db.identifierRows,
                    if (respiratorySessionRowsRefs) db.respiratorySessionRows,
                    if (respiratoryReminderRowsRefs) db.respiratoryReminderRows,
                    if (weightReminderRowsRefs) db.weightReminderRows,
                    if (medicationRowsRefs) db.medicationRows,
                    if (medicationScheduleRowsRefs) db.medicationScheduleRows,
                    if (doseLedgerRowsRefs) db.doseLedgerRows,
                    if (healthRecordRowsRefs) db.healthRecordRows,
                    if (careDocumentRowsRefs) db.careDocumentRows,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (identifierRowsRefs)
                        await $_getPrefetchedData<AnimalEntity, $AnimalRowsTable, IdentifierEntity>(
                          currentTable: table,
                          referencedTable: $$AnimalRowsTableReferences._identifierRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AnimalRowsTableReferences(db, table, p0).identifierRowsRefs,
                          referencedItemsForCurrentItem: (item, referencedItems) =>
                              referencedItems.where((e) => e.animalId == item.id),
                          typedResults: items,
                        ),
                      if (respiratorySessionRowsRefs)
                        await $_getPrefetchedData<
                          AnimalEntity,
                          $AnimalRowsTable,
                          RespiratorySessionEntity
                        >(
                          currentTable: table,
                          referencedTable: $$AnimalRowsTableReferences
                              ._respiratorySessionRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AnimalRowsTableReferences(db, table, p0).respiratorySessionRowsRefs,
                          referencedItemsForCurrentItem: (item, referencedItems) =>
                              referencedItems.where((e) => e.animalId == item.id),
                          typedResults: items,
                        ),
                      if (respiratoryReminderRowsRefs)
                        await $_getPrefetchedData<
                          AnimalEntity,
                          $AnimalRowsTable,
                          RespiratoryReminderEntity
                        >(
                          currentTable: table,
                          referencedTable: $$AnimalRowsTableReferences
                              ._respiratoryReminderRowsRefsTable(db),
                          managerFromTypedResult: (p0) => $$AnimalRowsTableReferences(
                            db,
                            table,
                            p0,
                          ).respiratoryReminderRowsRefs,
                          referencedItemsForCurrentItem: (item, referencedItems) =>
                              referencedItems.where((e) => e.animalId == item.id),
                          typedResults: items,
                        ),
                      if (weightReminderRowsRefs)
                        await $_getPrefetchedData<
                          AnimalEntity,
                          $AnimalRowsTable,
                          WeightReminderEntity
                        >(
                          currentTable: table,
                          referencedTable: $$AnimalRowsTableReferences._weightReminderRowsRefsTable(
                            db,
                          ),
                          managerFromTypedResult: (p0) =>
                              $$AnimalRowsTableReferences(db, table, p0).weightReminderRowsRefs,
                          referencedItemsForCurrentItem: (item, referencedItems) =>
                              referencedItems.where((e) => e.animalId == item.id),
                          typedResults: items,
                        ),
                      if (medicationRowsRefs)
                        await $_getPrefetchedData<AnimalEntity, $AnimalRowsTable, MedicationEntity>(
                          currentTable: table,
                          referencedTable: $$AnimalRowsTableReferences._medicationRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AnimalRowsTableReferences(db, table, p0).medicationRowsRefs,
                          referencedItemsForCurrentItem: (item, referencedItems) =>
                              referencedItems.where((e) => e.animalId == item.id),
                          typedResults: items,
                        ),
                      if (medicationScheduleRowsRefs)
                        await $_getPrefetchedData<
                          AnimalEntity,
                          $AnimalRowsTable,
                          MedicationScheduleEntity
                        >(
                          currentTable: table,
                          referencedTable: $$AnimalRowsTableReferences
                              ._medicationScheduleRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AnimalRowsTableReferences(db, table, p0).medicationScheduleRowsRefs,
                          referencedItemsForCurrentItem: (item, referencedItems) =>
                              referencedItems.where((e) => e.animalId == item.id),
                          typedResults: items,
                        ),
                      if (doseLedgerRowsRefs)
                        await $_getPrefetchedData<AnimalEntity, $AnimalRowsTable, DoseLedgerEntity>(
                          currentTable: table,
                          referencedTable: $$AnimalRowsTableReferences._doseLedgerRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AnimalRowsTableReferences(db, table, p0).doseLedgerRowsRefs,
                          referencedItemsForCurrentItem: (item, referencedItems) =>
                              referencedItems.where((e) => e.animalId == item.id),
                          typedResults: items,
                        ),
                      if (healthRecordRowsRefs)
                        await $_getPrefetchedData<
                          AnimalEntity,
                          $AnimalRowsTable,
                          HealthRecordEntity
                        >(
                          currentTable: table,
                          referencedTable: $$AnimalRowsTableReferences._healthRecordRowsRefsTable(
                            db,
                          ),
                          managerFromTypedResult: (p0) =>
                              $$AnimalRowsTableReferences(db, table, p0).healthRecordRowsRefs,
                          referencedItemsForCurrentItem: (item, referencedItems) =>
                              referencedItems.where((e) => e.animalId == item.id),
                          typedResults: items,
                        ),
                      if (careDocumentRowsRefs)
                        await $_getPrefetchedData<
                          AnimalEntity,
                          $AnimalRowsTable,
                          CareDocumentEntity
                        >(
                          currentTable: table,
                          referencedTable: $$AnimalRowsTableReferences._careDocumentRowsRefsTable(
                            db,
                          ),
                          managerFromTypedResult: (p0) =>
                              $$AnimalRowsTableReferences(db, table, p0).careDocumentRowsRefs,
                          referencedItemsForCurrentItem: (item, referencedItems) =>
                              referencedItems.where((e) => e.animalId == item.id),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$AnimalRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AnimalRowsTable,
      AnimalEntity,
      $$AnimalRowsTableFilterComposer,
      $$AnimalRowsTableOrderingComposer,
      $$AnimalRowsTableAnnotationComposer,
      $$AnimalRowsTableCreateCompanionBuilder,
      $$AnimalRowsTableUpdateCompanionBuilder,
      (AnimalEntity, $$AnimalRowsTableReferences),
      AnimalEntity,
      PrefetchHooks Function({
        bool identifierRowsRefs,
        bool respiratorySessionRowsRefs,
        bool respiratoryReminderRowsRefs,
        bool weightReminderRowsRefs,
        bool medicationRowsRefs,
        bool medicationScheduleRowsRefs,
        bool doseLedgerRowsRefs,
        bool healthRecordRowsRefs,
        bool careDocumentRowsRefs,
      })
    >;
typedef $$IdentifierRowsTableCreateCompanionBuilder = IdentifierRowsCompanion Function({
  required String id,
  required String animalId,
  required DateTime createdAt,
  required DateTime updatedAt,
  required String type,
  required String value,
  Value<String?> issuer,
  Value<String?> url,
  Value<String?> phone,
  Value<DateTime?> issuedOn,
  Value<String?> notes,
  Value<bool> archived,
  Value<int> rowid,
});
typedef $$IdentifierRowsTableUpdateCompanionBuilder = IdentifierRowsCompanion Function({
  Value<String> id,
  Value<String> animalId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String> type,
  Value<String> value,
  Value<String?> issuer,
  Value<String?> url,
  Value<String?> phone,
  Value<DateTime?> issuedOn,
  Value<String?> notes,
  Value<bool> archived,
  Value<int> rowid,
});

final class $$IdentifierRowsTableReferences
    extends BaseReferences<_$AppDatabase, $IdentifierRowsTable, IdentifierEntity> {
  $$IdentifierRowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AnimalRowsTable _animalIdTable(_$AppDatabase db) =>
      db.animalRows.createAlias('identifier_rows__animal_id__animal_rows__id');

  $$AnimalRowsTableProcessedTableManager get animalId {
    final $_column = $_itemColumn<String>('animal_id')!;

    final manager = $$AnimalRowsTableTableManager(
      $_db,
      $_db.animalRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_animalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$IdentifierRowsTableFilterComposer extends Composer<_$AppDatabase, $IdentifierRowsTable> {
  $$IdentifierRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get issuer =>
      $composableBuilder(column: $table.issuer, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get issuedOn =>
      $composableBuilder(column: $table.issuedOn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => ColumnFilters(column));

  $$AnimalRowsTableFilterComposer get animalId {
    final $$AnimalRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.animalId,
      referencedTable: $db.animalRows,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AnimalRowsTableFilterComposer(
            $db: $db,
            $table: $db.animalRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IdentifierRowsTableOrderingComposer extends Composer<_$AppDatabase, $IdentifierRowsTable> {
  $$IdentifierRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get issuer =>
      $composableBuilder(column: $table.issuer, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get issuedOn =>
      $composableBuilder(column: $table.issuedOn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => ColumnOrderings(column));

  $$AnimalRowsTableOrderingComposer get animalId {
    final $$AnimalRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.animalId,
      referencedTable: $db.animalRows,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AnimalRowsTableOrderingComposer(
            $db: $db,
            $table: $db.animalRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IdentifierRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IdentifierRowsTable> {
  $$IdentifierRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get issuer =>
      $composableBuilder(column: $table.issuer, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<DateTime> get issuedOn =>
      $composableBuilder(column: $table.issuedOn, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  $$AnimalRowsTableAnnotationComposer get animalId {
    final $$AnimalRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.animalId,
      referencedTable: $db.animalRows,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AnimalRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.animalRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IdentifierRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IdentifierRowsTable,
          IdentifierEntity,
          $$IdentifierRowsTableFilterComposer,
          $$IdentifierRowsTableOrderingComposer,
          $$IdentifierRowsTableAnnotationComposer,
          $$IdentifierRowsTableCreateCompanionBuilder,
          $$IdentifierRowsTableUpdateCompanionBuilder,
          (IdentifierEntity, $$IdentifierRowsTableReferences),
          IdentifierEntity,
          PrefetchHooks Function({bool animalId})
        > {
  $$IdentifierRowsTableTableManager(_$AppDatabase db, $IdentifierRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IdentifierRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IdentifierRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IdentifierRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> animalId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<String?> issuer = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<DateTime?> issuedOn = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IdentifierRowsCompanion(
                id: id,
                animalId: animalId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                type: type,
                value: value,
                issuer: issuer,
                url: url,
                phone: phone,
                issuedOn: issuedOn,
                notes: notes,
                archived: archived,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String animalId,
                required DateTime createdAt,
                required DateTime updatedAt,
                required String type,
                required String value,
                Value<String?> issuer = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<DateTime?> issuedOn = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IdentifierRowsCompanion.insert(
                id: id,
                animalId: animalId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                type: type,
                value: value,
                issuer: issuer,
                url: url,
                phone: phone,
                issuedOn: issuedOn,
                notes: notes,
                archived: archived,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$IdentifierRowsTable, IdentifierEntity>(table),
                  $$IdentifierRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({animalId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (animalId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.animalId,
                        referencedTable: $$IdentifierRowsTableReferences._animalIdTable(db),
                        referencedColumn: $$IdentifierRowsTableReferences._animalIdTable(db).id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$IdentifierRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IdentifierRowsTable,
      IdentifierEntity,
      $$IdentifierRowsTableFilterComposer,
      $$IdentifierRowsTableOrderingComposer,
      $$IdentifierRowsTableAnnotationComposer,
      $$IdentifierRowsTableCreateCompanionBuilder,
      $$IdentifierRowsTableUpdateCompanionBuilder,
      (IdentifierEntity, $$IdentifierRowsTableReferences),
      IdentifierEntity,
      PrefetchHooks Function({bool animalId})
    >;
typedef $$RespiratorySessionRowsTableCreateCompanionBuilder =
    RespiratorySessionRowsCompanion Function({
      required String id,
      required String animalId,
      required DateTime createdAt,
      required DateTime updatedAt,
      required DateTime recordedAt,
      required int durationMilliseconds,
      required int breathCount,
      required double ratePerMinute,
      required String context,
      Value<String?> note,
      Value<double?> thresholdMinimum,
      Value<double?> thresholdTarget,
      Value<double?> thresholdMaximum,
      Value<int> rowid,
    });
typedef $$RespiratorySessionRowsTableUpdateCompanionBuilder =
    RespiratorySessionRowsCompanion Function({
      Value<String> id,
      Value<String> animalId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime> recordedAt,
      Value<int> durationMilliseconds,
      Value<int> breathCount,
      Value<double> ratePerMinute,
      Value<String> context,
      Value<String?> note,
      Value<double?> thresholdMinimum,
      Value<double?> thresholdTarget,
      Value<double?> thresholdMaximum,
      Value<int> rowid,
    });

final class $$RespiratorySessionRowsTableReferences
    extends BaseReferences<_$AppDatabase, $RespiratorySessionRowsTable, RespiratorySessionEntity> {
  $$RespiratorySessionRowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AnimalRowsTable _animalIdTable(_$AppDatabase db) =>
      db.animalRows.createAlias('respiratory_session_rows__animal_id__animal_rows__id');

  $$AnimalRowsTableProcessedTableManager get animalId {
    final $_column = $_itemColumn<String>('animal_id')!;

    final manager = $$AnimalRowsTableTableManager(
      $_db,
      $_db.animalRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_animalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$RespiratorySessionRowsTableFilterComposer
    extends Composer<_$AppDatabase, $RespiratorySessionRowsTable> {
  $$RespiratorySessionRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get recordedAt =>
      $composableBuilder(column: $table.recordedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationMilliseconds => $composableBuilder(
    column: $table.durationMilliseconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get breathCount =>
      $composableBuilder(column: $table.breathCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get ratePerMinute =>
      $composableBuilder(column: $table.ratePerMinute, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get context =>
      $composableBuilder(column: $table.context, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get thresholdMinimum => $composableBuilder(
    column: $table.thresholdMinimum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get thresholdTarget => $composableBuilder(
    column: $table.thresholdTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get thresholdMaximum => $composableBuilder(
    column: $table.thresholdMaximum,
    builder: (column) => ColumnFilters(column),
  );

  $$AnimalRowsTableFilterComposer get animalId {
    final $$AnimalRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.animalId,
      referencedTable: $db.animalRows,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AnimalRowsTableFilterComposer(
            $db: $db,
            $table: $db.animalRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RespiratorySessionRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $RespiratorySessionRowsTable> {
  $$RespiratorySessionRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get recordedAt =>
      $composableBuilder(column: $table.recordedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationMilliseconds => $composableBuilder(
    column: $table.durationMilliseconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get breathCount =>
      $composableBuilder(column: $table.breathCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get ratePerMinute => $composableBuilder(
    column: $table.ratePerMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get context =>
      $composableBuilder(column: $table.context, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get thresholdMinimum => $composableBuilder(
    column: $table.thresholdMinimum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get thresholdTarget => $composableBuilder(
    column: $table.thresholdTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get thresholdMaximum => $composableBuilder(
    column: $table.thresholdMaximum,
    builder: (column) => ColumnOrderings(column),
  );

  $$AnimalRowsTableOrderingComposer get animalId {
    final $$AnimalRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.animalId,
      referencedTable: $db.animalRows,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AnimalRowsTableOrderingComposer(
            $db: $db,
            $table: $db.animalRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RespiratorySessionRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RespiratorySessionRowsTable> {
  $$RespiratorySessionRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt =>
      $composableBuilder(column: $table.recordedAt, builder: (column) => column);

  GeneratedColumn<int> get durationMilliseconds =>
      $composableBuilder(column: $table.durationMilliseconds, builder: (column) => column);

  GeneratedColumn<int> get breathCount =>
      $composableBuilder(column: $table.breathCount, builder: (column) => column);

  GeneratedColumn<double> get ratePerMinute =>
      $composableBuilder(column: $table.ratePerMinute, builder: (column) => column);

  GeneratedColumn<String> get context =>
      $composableBuilder(column: $table.context, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<double> get thresholdMinimum =>
      $composableBuilder(column: $table.thresholdMinimum, builder: (column) => column);

  GeneratedColumn<double> get thresholdTarget =>
      $composableBuilder(column: $table.thresholdTarget, builder: (column) => column);

  GeneratedColumn<double> get thresholdMaximum =>
      $composableBuilder(column: $table.thresholdMaximum, builder: (column) => column);

  $$AnimalRowsTableAnnotationComposer get animalId {
    final $$AnimalRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.animalId,
      referencedTable: $db.animalRows,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AnimalRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.animalRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RespiratorySessionRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RespiratorySessionRowsTable,
          RespiratorySessionEntity,
          $$RespiratorySessionRowsTableFilterComposer,
          $$RespiratorySessionRowsTableOrderingComposer,
          $$RespiratorySessionRowsTableAnnotationComposer,
          $$RespiratorySessionRowsTableCreateCompanionBuilder,
          $$RespiratorySessionRowsTableUpdateCompanionBuilder,
          (RespiratorySessionEntity, $$RespiratorySessionRowsTableReferences),
          RespiratorySessionEntity,
          PrefetchHooks Function({bool animalId})
        > {
  $$RespiratorySessionRowsTableTableManager(_$AppDatabase db, $RespiratorySessionRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RespiratorySessionRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RespiratorySessionRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RespiratorySessionRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> animalId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
                Value<int> durationMilliseconds = const Value.absent(),
                Value<int> breathCount = const Value.absent(),
                Value<double> ratePerMinute = const Value.absent(),
                Value<String> context = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<double?> thresholdMinimum = const Value.absent(),
                Value<double?> thresholdTarget = const Value.absent(),
                Value<double?> thresholdMaximum = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RespiratorySessionRowsCompanion(
                id: id,
                animalId: animalId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                recordedAt: recordedAt,
                durationMilliseconds: durationMilliseconds,
                breathCount: breathCount,
                ratePerMinute: ratePerMinute,
                context: context,
                note: note,
                thresholdMinimum: thresholdMinimum,
                thresholdTarget: thresholdTarget,
                thresholdMaximum: thresholdMaximum,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String animalId,
                required DateTime createdAt,
                required DateTime updatedAt,
                required DateTime recordedAt,
                required int durationMilliseconds,
                required int breathCount,
                required double ratePerMinute,
                required String context,
                Value<String?> note = const Value.absent(),
                Value<double?> thresholdMinimum = const Value.absent(),
                Value<double?> thresholdTarget = const Value.absent(),
                Value<double?> thresholdMaximum = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RespiratorySessionRowsCompanion.insert(
                id: id,
                animalId: animalId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                recordedAt: recordedAt,
                durationMilliseconds: durationMilliseconds,
                breathCount: breathCount,
                ratePerMinute: ratePerMinute,
                context: context,
                note: note,
                thresholdMinimum: thresholdMinimum,
                thresholdTarget: thresholdTarget,
                thresholdMaximum: thresholdMaximum,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RespiratorySessionRowsTable, RespiratorySessionEntity>(table),
                  $$RespiratorySessionRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({animalId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (animalId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.animalId,
                        referencedTable: $$RespiratorySessionRowsTableReferences._animalIdTable(db),
                        referencedColumn: $$RespiratorySessionRowsTableReferences
                            ._animalIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RespiratorySessionRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RespiratorySessionRowsTable,
      RespiratorySessionEntity,
      $$RespiratorySessionRowsTableFilterComposer,
      $$RespiratorySessionRowsTableOrderingComposer,
      $$RespiratorySessionRowsTableAnnotationComposer,
      $$RespiratorySessionRowsTableCreateCompanionBuilder,
      $$RespiratorySessionRowsTableUpdateCompanionBuilder,
      (RespiratorySessionEntity, $$RespiratorySessionRowsTableReferences),
      RespiratorySessionEntity,
      PrefetchHooks Function({bool animalId})
    >;
typedef $$RespiratoryReminderRowsTableCreateCompanionBuilder =
    RespiratoryReminderRowsCompanion Function({
      required String id,
      required String animalId,
      required DateTime createdAt,
      required DateTime updatedAt,
      required DateTime startDate,
      Value<DateTime?> endDate,
      required String context,
      required String recurrence,
      required String timeZoneId,
      Value<String> timesJson,
      Value<String> weekdaysJson,
      Value<bool> enabled,
      Value<int> rowid,
    });
typedef $$RespiratoryReminderRowsTableUpdateCompanionBuilder =
    RespiratoryReminderRowsCompanion Function({
      Value<String> id,
      Value<String> animalId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime> startDate,
      Value<DateTime?> endDate,
      Value<String> context,
      Value<String> recurrence,
      Value<String> timeZoneId,
      Value<String> timesJson,
      Value<String> weekdaysJson,
      Value<bool> enabled,
      Value<int> rowid,
    });

final class $$RespiratoryReminderRowsTableReferences
    extends
        BaseReferences<_$AppDatabase, $RespiratoryReminderRowsTable, RespiratoryReminderEntity> {
  $$RespiratoryReminderRowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AnimalRowsTable _animalIdTable(_$AppDatabase db) =>
      db.animalRows.createAlias('respiratory_reminder_rows__animal_id__animal_rows__id');

  $$AnimalRowsTableProcessedTableManager get animalId {
    final $_column = $_itemColumn<String>('animal_id')!;

    final manager = $$AnimalRowsTableTableManager(
      $_db,
      $_db.animalRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_animalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$RespiratoryReminderRowsTableFilterComposer
    extends Composer<_$AppDatabase, $RespiratoryReminderRowsTable> {
  $$RespiratoryReminderRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get context =>
      $composableBuilder(column: $table.context, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recurrence =>
      $composableBuilder(column: $table.recurrence, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get timeZoneId =>
      $composableBuilder(column: $table.timeZoneId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get timesJson =>
      $composableBuilder(column: $table.timesJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get weekdaysJson =>
      $composableBuilder(column: $table.weekdaysJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => ColumnFilters(column));

  $$AnimalRowsTableFilterComposer get animalId {
    final $$AnimalRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.animalId,
      referencedTable: $db.animalRows,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AnimalRowsTableFilterComposer(
            $db: $db,
            $table: $db.animalRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RespiratoryReminderRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $RespiratoryReminderRowsTable> {
  $$RespiratoryReminderRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get context =>
      $composableBuilder(column: $table.context, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recurrence =>
      $composableBuilder(column: $table.recurrence, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get timeZoneId =>
      $composableBuilder(column: $table.timeZoneId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get timesJson =>
      $composableBuilder(column: $table.timesJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get weekdaysJson =>
      $composableBuilder(column: $table.weekdaysJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => ColumnOrderings(column));

  $$AnimalRowsTableOrderingComposer get animalId {
    final $$AnimalRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.animalId,
      referencedTable: $db.animalRows,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AnimalRowsTableOrderingComposer(
            $db: $db,
            $table: $db.animalRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RespiratoryReminderRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RespiratoryReminderRowsTable> {
  $$RespiratoryReminderRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get context =>
      $composableBuilder(column: $table.context, builder: (column) => column);

  GeneratedColumn<String> get recurrence =>
      $composableBuilder(column: $table.recurrence, builder: (column) => column);

  GeneratedColumn<String> get timeZoneId =>
      $composableBuilder(column: $table.timeZoneId, builder: (column) => column);

  GeneratedColumn<String> get timesJson =>
      $composableBuilder(column: $table.timesJson, builder: (column) => column);

  GeneratedColumn<String> get weekdaysJson =>
      $composableBuilder(column: $table.weekdaysJson, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  $$AnimalRowsTableAnnotationComposer get animalId {
    final $$AnimalRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.animalId,
      referencedTable: $db.animalRows,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AnimalRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.animalRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RespiratoryReminderRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RespiratoryReminderRowsTable,
          RespiratoryReminderEntity,
          $$RespiratoryReminderRowsTableFilterComposer,
          $$RespiratoryReminderRowsTableOrderingComposer,
          $$RespiratoryReminderRowsTableAnnotationComposer,
          $$RespiratoryReminderRowsTableCreateCompanionBuilder,
          $$RespiratoryReminderRowsTableUpdateCompanionBuilder,
          (RespiratoryReminderEntity, $$RespiratoryReminderRowsTableReferences),
          RespiratoryReminderEntity,
          PrefetchHooks Function({bool animalId})
        > {
  $$RespiratoryReminderRowsTableTableManager(_$AppDatabase db, $RespiratoryReminderRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RespiratoryReminderRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RespiratoryReminderRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RespiratoryReminderRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> animalId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<String> context = const Value.absent(),
                Value<String> recurrence = const Value.absent(),
                Value<String> timeZoneId = const Value.absent(),
                Value<String> timesJson = const Value.absent(),
                Value<String> weekdaysJson = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RespiratoryReminderRowsCompanion(
                id: id,
                animalId: animalId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                startDate: startDate,
                endDate: endDate,
                context: context,
                recurrence: recurrence,
                timeZoneId: timeZoneId,
                timesJson: timesJson,
                weekdaysJson: weekdaysJson,
                enabled: enabled,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String animalId,
                required DateTime createdAt,
                required DateTime updatedAt,
                required DateTime startDate,
                Value<DateTime?> endDate = const Value.absent(),
                required String context,
                required String recurrence,
                required String timeZoneId,
                Value<String> timesJson = const Value.absent(),
                Value<String> weekdaysJson = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RespiratoryReminderRowsCompanion.insert(
                id: id,
                animalId: animalId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                startDate: startDate,
                endDate: endDate,
                context: context,
                recurrence: recurrence,
                timeZoneId: timeZoneId,
                timesJson: timesJson,
                weekdaysJson: weekdaysJson,
                enabled: enabled,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RespiratoryReminderRowsTable, RespiratoryReminderEntity>(table),
                  $$RespiratoryReminderRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({animalId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (animalId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.animalId,
                        referencedTable: $$RespiratoryReminderRowsTableReferences._animalIdTable(
                          db,
                        ),
                        referencedColumn: $$RespiratoryReminderRowsTableReferences
                            ._animalIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RespiratoryReminderRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RespiratoryReminderRowsTable,
      RespiratoryReminderEntity,
      $$RespiratoryReminderRowsTableFilterComposer,
      $$RespiratoryReminderRowsTableOrderingComposer,
      $$RespiratoryReminderRowsTableAnnotationComposer,
      $$RespiratoryReminderRowsTableCreateCompanionBuilder,
      $$RespiratoryReminderRowsTableUpdateCompanionBuilder,
      (RespiratoryReminderEntity, $$RespiratoryReminderRowsTableReferences),
      RespiratoryReminderEntity,
      PrefetchHooks Function({bool animalId})
    >;
typedef $$WeightReminderRowsTableCreateCompanionBuilder = WeightReminderRowsCompanion Function({
  required String id,
  required String animalId,
  required DateTime createdAt,
  required DateTime updatedAt,
  required DateTime startDate,
  Value<DateTime?> endDate,
  required String recurrence,
  required String timeZoneId,
  Value<String> timesJson,
  Value<String> weekdaysJson,
  Value<bool> enabled,
  Value<int> rowid,
});
typedef $$WeightReminderRowsTableUpdateCompanionBuilder = WeightReminderRowsCompanion Function({
  Value<String> id,
  Value<String> animalId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime> startDate,
  Value<DateTime?> endDate,
  Value<String> recurrence,
  Value<String> timeZoneId,
  Value<String> timesJson,
  Value<String> weekdaysJson,
  Value<bool> enabled,
  Value<int> rowid,
});

final class $$WeightReminderRowsTableReferences
    extends BaseReferences<_$AppDatabase, $WeightReminderRowsTable, WeightReminderEntity> {
  $$WeightReminderRowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AnimalRowsTable _animalIdTable(_$AppDatabase db) =>
      db.animalRows.createAlias('weight_reminder_rows__animal_id__animal_rows__id');

  $$AnimalRowsTableProcessedTableManager get animalId {
    final $_column = $_itemColumn<String>('animal_id')!;

    final manager = $$AnimalRowsTableTableManager(
      $_db,
      $_db.animalRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_animalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$WeightReminderRowsTableFilterComposer
    extends Composer<_$AppDatabase, $WeightReminderRowsTable> {
  $$WeightReminderRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recurrence =>
      $composableBuilder(column: $table.recurrence, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get timeZoneId =>
      $composableBuilder(column: $table.timeZoneId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get timesJson =>
      $composableBuilder(column: $table.timesJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get weekdaysJson =>
      $composableBuilder(column: $table.weekdaysJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => ColumnFilters(column));

  $$AnimalRowsTableFilterComposer get animalId {
    final $$AnimalRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.animalId,
      referencedTable: $db.animalRows,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AnimalRowsTableFilterComposer(
            $db: $db,
            $table: $db.animalRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeightReminderRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeightReminderRowsTable> {
  $$WeightReminderRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recurrence =>
      $composableBuilder(column: $table.recurrence, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get timeZoneId =>
      $composableBuilder(column: $table.timeZoneId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get timesJson =>
      $composableBuilder(column: $table.timesJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get weekdaysJson =>
      $composableBuilder(column: $table.weekdaysJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => ColumnOrderings(column));

  $$AnimalRowsTableOrderingComposer get animalId {
    final $$AnimalRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.animalId,
      referencedTable: $db.animalRows,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AnimalRowsTableOrderingComposer(
            $db: $db,
            $table: $db.animalRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeightReminderRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeightReminderRowsTable> {
  $$WeightReminderRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get recurrence =>
      $composableBuilder(column: $table.recurrence, builder: (column) => column);

  GeneratedColumn<String> get timeZoneId =>
      $composableBuilder(column: $table.timeZoneId, builder: (column) => column);

  GeneratedColumn<String> get timesJson =>
      $composableBuilder(column: $table.timesJson, builder: (column) => column);

  GeneratedColumn<String> get weekdaysJson =>
      $composableBuilder(column: $table.weekdaysJson, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  $$AnimalRowsTableAnnotationComposer get animalId {
    final $$AnimalRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.animalId,
      referencedTable: $db.animalRows,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AnimalRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.animalRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeightReminderRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeightReminderRowsTable,
          WeightReminderEntity,
          $$WeightReminderRowsTableFilterComposer,
          $$WeightReminderRowsTableOrderingComposer,
          $$WeightReminderRowsTableAnnotationComposer,
          $$WeightReminderRowsTableCreateCompanionBuilder,
          $$WeightReminderRowsTableUpdateCompanionBuilder,
          (WeightReminderEntity, $$WeightReminderRowsTableReferences),
          WeightReminderEntity,
          PrefetchHooks Function({bool animalId})
        > {
  $$WeightReminderRowsTableTableManager(_$AppDatabase db, $WeightReminderRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeightReminderRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeightReminderRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeightReminderRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> animalId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<String> recurrence = const Value.absent(),
                Value<String> timeZoneId = const Value.absent(),
                Value<String> timesJson = const Value.absent(),
                Value<String> weekdaysJson = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeightReminderRowsCompanion(
                id: id,
                animalId: animalId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                startDate: startDate,
                endDate: endDate,
                recurrence: recurrence,
                timeZoneId: timeZoneId,
                timesJson: timesJson,
                weekdaysJson: weekdaysJson,
                enabled: enabled,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String animalId,
                required DateTime createdAt,
                required DateTime updatedAt,
                required DateTime startDate,
                Value<DateTime?> endDate = const Value.absent(),
                required String recurrence,
                required String timeZoneId,
                Value<String> timesJson = const Value.absent(),
                Value<String> weekdaysJson = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeightReminderRowsCompanion.insert(
                id: id,
                animalId: animalId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                startDate: startDate,
                endDate: endDate,
                recurrence: recurrence,
                timeZoneId: timeZoneId,
                timesJson: timesJson,
                weekdaysJson: weekdaysJson,
                enabled: enabled,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WeightReminderRowsTable, WeightReminderEntity>(table),
                  $$WeightReminderRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({animalId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (animalId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.animalId,
                        referencedTable: $$WeightReminderRowsTableReferences._animalIdTable(db),
                        referencedColumn: $$WeightReminderRowsTableReferences._animalIdTable(db).id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WeightReminderRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeightReminderRowsTable,
      WeightReminderEntity,
      $$WeightReminderRowsTableFilterComposer,
      $$WeightReminderRowsTableOrderingComposer,
      $$WeightReminderRowsTableAnnotationComposer,
      $$WeightReminderRowsTableCreateCompanionBuilder,
      $$WeightReminderRowsTableUpdateCompanionBuilder,
      (WeightReminderEntity, $$WeightReminderRowsTableReferences),
      WeightReminderEntity,
      PrefetchHooks Function({bool animalId})
    >;
typedef $$MedicationRowsTableCreateCompanionBuilder = MedicationRowsCompanion Function({
  required String id,
  required String animalId,
  required DateTime createdAt,
  required DateTime updatedAt,
  required String name,
  required String form,
  required double doseAmount,
  required String doseUnit,
  required String instructions,
  required DateTime startDate,
  Value<DateTime?> endDate,
  Value<String?> strength,
  Value<String?> prescriber,
  Value<String?> pharmacy,
  Value<String?> prescriptionNumber,
  Value<int?> refillsRemaining,
  Value<DateTime?> nextRefillDate,
  Value<String?> notes,
  Value<bool> active,
  Value<int> rowid,
});
typedef $$MedicationRowsTableUpdateCompanionBuilder = MedicationRowsCompanion Function({
  Value<String> id,
  Value<String> animalId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String> name,
  Value<String> form,
  Value<double> doseAmount,
  Value<String> doseUnit,
  Value<String> instructions,
  Value<DateTime> startDate,
  Value<DateTime?> endDate,
  Value<String?> strength,
  Value<String?> prescriber,
  Value<String?> pharmacy,
  Value<String?> prescriptionNumber,
  Value<int?> refillsRemaining,
  Value<DateTime?> nextRefillDate,
  Value<String?> notes,
  Value<bool> active,
  Value<int> rowid,
});

final class $$MedicationRowsTableReferences
    extends BaseReferences<_$AppDatabase, $MedicationRowsTable, MedicationEntity> {
  $$MedicationRowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AnimalRowsTable _animalIdTable(_$AppDatabase db) =>
      db.animalRows.createAlias('medication_rows__animal_id__animal_rows__id');

  $$AnimalRowsTableProcessedTableManager get animalId {
    final $_column = $_itemColumn<String>('animal_id')!;

    final manager = $$AnimalRowsTableTableManager(
      $_db,
      $_db.animalRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_animalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$MedicationScheduleRowsTable, List<MedicationScheduleEntity>>
  _medicationScheduleRowsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.medicationScheduleRows,
    aliasName: 'medication_rows__id__medication_schedule_rows__medication_id',
  );

  $$MedicationScheduleRowsTableProcessedTableManager get medicationScheduleRowsRefs {
    final manager = $$MedicationScheduleRowsTableTableManager(
      $_db,
      $_db.medicationScheduleRows,
    ).filter((f) => f.medicationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_medicationScheduleRowsRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DoseLedgerRowsTable, List<DoseLedgerEntity>> _doseLedgerRowsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.doseLedgerRows,
    aliasName: 'medication_rows__id__dose_ledger_rows__medication_id',
  );

  $$DoseLedgerRowsTableProcessedTableManager get doseLedgerRowsRefs {
    final manager = $$DoseLedgerRowsTableTableManager(
      $_db,
      $_db.doseLedgerRows,
    ).filter((f) => f.medicationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_doseLedgerRowsRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MedicationRowsTableFilterComposer extends Composer<_$AppDatabase, $MedicationRowsTable> {
  $$MedicationRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get form =>
      $composableBuilder(column: $table.form, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get doseAmount =>
      $composableBuilder(column: $table.doseAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get doseUnit =>
      $composableBuilder(column: $table.doseUnit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get instructions =>
      $composableBuilder(column: $table.instructions, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get strength =>
      $composableBuilder(column: $table.strength, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get prescriber =>
      $composableBuilder(column: $table.prescriber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pharmacy =>
      $composableBuilder(column: $table.pharmacy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get prescriptionNumber => $composableBuilder(
    column: $table.prescriptionNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get refillsRemaining => $composableBuilder(
    column: $table.refillsRemaining,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextRefillDate =>
      $composableBuilder(column: $table.nextRefillDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => ColumnFilters(column));

  $$AnimalRowsTableFilterComposer get animalId {
    final $$AnimalRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.animalId,
      referencedTable: $db.animalRows,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AnimalRowsTableFilterComposer(
            $db: $db,
            $table: $db.animalRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> medicationScheduleRowsRefs(
    Expression<bool> Function($$MedicationScheduleRowsTableFilterComposer f) f,
  ) {
    final $$MedicationScheduleRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medicationScheduleRows,
      getReferencedColumn: (t) => t.medicationId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$MedicationScheduleRowsTableFilterComposer(
            $db: $db,
            $table: $db.medicationScheduleRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> doseLedgerRowsRefs(
    Expression<bool> Function($$DoseLedgerRowsTableFilterComposer f) f,
  ) {
    final $$DoseLedgerRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.doseLedgerRows,
      getReferencedColumn: (t) => t.medicationId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$DoseLedgerRowsTableFilterComposer(
            $db: $db,
            $table: $db.doseLedgerRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MedicationRowsTableOrderingComposer extends Composer<_$AppDatabase, $MedicationRowsTable> {
  $$MedicationRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get form =>
      $composableBuilder(column: $table.form, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get doseAmount =>
      $composableBuilder(column: $table.doseAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get doseUnit =>
      $composableBuilder(column: $table.doseUnit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get instructions =>
      $composableBuilder(column: $table.instructions, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get strength =>
      $composableBuilder(column: $table.strength, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get prescriber =>
      $composableBuilder(column: $table.prescriber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pharmacy =>
      $composableBuilder(column: $table.pharmacy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get prescriptionNumber => $composableBuilder(
    column: $table.prescriptionNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get refillsRemaining => $composableBuilder(
    column: $table.refillsRemaining,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextRefillDate => $composableBuilder(
    column: $table.nextRefillDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => ColumnOrderings(column));

  $$AnimalRowsTableOrderingComposer get animalId {
    final $$AnimalRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.animalId,
      referencedTable: $db.animalRows,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AnimalRowsTableOrderingComposer(
            $db: $db,
            $table: $db.animalRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicationRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationRowsTable> {
  $$MedicationRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get form =>
      $composableBuilder(column: $table.form, builder: (column) => column);

  GeneratedColumn<double> get doseAmount =>
      $composableBuilder(column: $table.doseAmount, builder: (column) => column);

  GeneratedColumn<String> get doseUnit =>
      $composableBuilder(column: $table.doseUnit, builder: (column) => column);

  GeneratedColumn<String> get instructions =>
      $composableBuilder(column: $table.instructions, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get strength =>
      $composableBuilder(column: $table.strength, builder: (column) => column);

  GeneratedColumn<String> get prescriber =>
      $composableBuilder(column: $table.prescriber, builder: (column) => column);

  GeneratedColumn<String> get pharmacy =>
      $composableBuilder(column: $table.pharmacy, builder: (column) => column);

  GeneratedColumn<String> get prescriptionNumber =>
      $composableBuilder(column: $table.prescriptionNumber, builder: (column) => column);

  GeneratedColumn<int> get refillsRemaining =>
      $composableBuilder(column: $table.refillsRemaining, builder: (column) => column);

  GeneratedColumn<DateTime> get nextRefillDate =>
      $composableBuilder(column: $table.nextRefillDate, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  $$AnimalRowsTableAnnotationComposer get animalId {
    final $$AnimalRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.animalId,
      referencedTable: $db.animalRows,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AnimalRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.animalRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> medicationScheduleRowsRefs<T extends Object>(
    Expression<T> Function($$MedicationScheduleRowsTableAnnotationComposer a) f,
  ) {
    final $$MedicationScheduleRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medicationScheduleRows,
      getReferencedColumn: (t) => t.medicationId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$MedicationScheduleRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.medicationScheduleRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> doseLedgerRowsRefs<T extends Object>(
    Expression<T> Function($$DoseLedgerRowsTableAnnotationComposer a) f,
  ) {
    final $$DoseLedgerRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.doseLedgerRows,
      getReferencedColumn: (t) => t.medicationId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$DoseLedgerRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.doseLedgerRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MedicationRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicationRowsTable,
          MedicationEntity,
          $$MedicationRowsTableFilterComposer,
          $$MedicationRowsTableOrderingComposer,
          $$MedicationRowsTableAnnotationComposer,
          $$MedicationRowsTableCreateCompanionBuilder,
          $$MedicationRowsTableUpdateCompanionBuilder,
          (MedicationEntity, $$MedicationRowsTableReferences),
          MedicationEntity,
          PrefetchHooks Function({
            bool animalId,
            bool medicationScheduleRowsRefs,
            bool doseLedgerRowsRefs,
          })
        > {
  $$MedicationRowsTableTableManager(_$AppDatabase db, $MedicationRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicationRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicationRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicationRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> animalId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> form = const Value.absent(),
                Value<double> doseAmount = const Value.absent(),
                Value<String> doseUnit = const Value.absent(),
                Value<String> instructions = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<String?> strength = const Value.absent(),
                Value<String?> prescriber = const Value.absent(),
                Value<String?> pharmacy = const Value.absent(),
                Value<String?> prescriptionNumber = const Value.absent(),
                Value<int?> refillsRemaining = const Value.absent(),
                Value<DateTime?> nextRefillDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicationRowsCompanion(
                id: id,
                animalId: animalId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                name: name,
                form: form,
                doseAmount: doseAmount,
                doseUnit: doseUnit,
                instructions: instructions,
                startDate: startDate,
                endDate: endDate,
                strength: strength,
                prescriber: prescriber,
                pharmacy: pharmacy,
                prescriptionNumber: prescriptionNumber,
                refillsRemaining: refillsRemaining,
                nextRefillDate: nextRefillDate,
                notes: notes,
                active: active,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String animalId,
                required DateTime createdAt,
                required DateTime updatedAt,
                required String name,
                required String form,
                required double doseAmount,
                required String doseUnit,
                required String instructions,
                required DateTime startDate,
                Value<DateTime?> endDate = const Value.absent(),
                Value<String?> strength = const Value.absent(),
                Value<String?> prescriber = const Value.absent(),
                Value<String?> pharmacy = const Value.absent(),
                Value<String?> prescriptionNumber = const Value.absent(),
                Value<int?> refillsRemaining = const Value.absent(),
                Value<DateTime?> nextRefillDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicationRowsCompanion.insert(
                id: id,
                animalId: animalId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                name: name,
                form: form,
                doseAmount: doseAmount,
                doseUnit: doseUnit,
                instructions: instructions,
                startDate: startDate,
                endDate: endDate,
                strength: strength,
                prescriber: prescriber,
                pharmacy: pharmacy,
                prescriptionNumber: prescriptionNumber,
                refillsRemaining: refillsRemaining,
                nextRefillDate: nextRefillDate,
                notes: notes,
                active: active,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MedicationRowsTable, MedicationEntity>(table),
                  $$MedicationRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({animalId = false, medicationScheduleRowsRefs = false, doseLedgerRowsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (medicationScheduleRowsRefs) db.medicationScheduleRows,
                    if (doseLedgerRowsRefs) db.doseLedgerRows,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (animalId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.animalId,
                            referencedTable: $$MedicationRowsTableReferences._animalIdTable(db),
                            referencedColumn: $$MedicationRowsTableReferences._animalIdTable(db).id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (medicationScheduleRowsRefs)
                        await $_getPrefetchedData<
                          MedicationEntity,
                          $MedicationRowsTable,
                          MedicationScheduleEntity
                        >(
                          currentTable: table,
                          referencedTable: $$MedicationRowsTableReferences
                              ._medicationScheduleRowsRefsTable(db),
                          managerFromTypedResult: (p0) => $$MedicationRowsTableReferences(
                            db,
                            table,
                            p0,
                          ).medicationScheduleRowsRefs,
                          referencedItemsForCurrentItem: (item, referencedItems) =>
                              referencedItems.where((e) => e.medicationId == item.id),
                          typedResults: items,
                        ),
                      if (doseLedgerRowsRefs)
                        await $_getPrefetchedData<
                          MedicationEntity,
                          $MedicationRowsTable,
                          DoseLedgerEntity
                        >(
                          currentTable: table,
                          referencedTable: $$MedicationRowsTableReferences._doseLedgerRowsRefsTable(
                            db,
                          ),
                          managerFromTypedResult: (p0) =>
                              $$MedicationRowsTableReferences(db, table, p0).doseLedgerRowsRefs,
                          referencedItemsForCurrentItem: (item, referencedItems) =>
                              referencedItems.where((e) => e.medicationId == item.id),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MedicationRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicationRowsTable,
      MedicationEntity,
      $$MedicationRowsTableFilterComposer,
      $$MedicationRowsTableOrderingComposer,
      $$MedicationRowsTableAnnotationComposer,
      $$MedicationRowsTableCreateCompanionBuilder,
      $$MedicationRowsTableUpdateCompanionBuilder,
      (MedicationEntity, $$MedicationRowsTableReferences),
      MedicationEntity,
      PrefetchHooks Function({
        bool animalId,
        bool medicationScheduleRowsRefs,
        bool doseLedgerRowsRefs,
      })
    >;
typedef $$MedicationScheduleRowsTableCreateCompanionBuilder =
    MedicationScheduleRowsCompanion Function({
      required String id,
      required String medicationId,
      required String animalId,
      required DateTime createdAt,
      required DateTime updatedAt,
      required String kind,
      Value<int?> intervalHours,
      Value<String> timesJson,
      Value<String> weekdaysJson,
      Value<String> timeZoneId,
      Value<bool> enabled,
      Value<int> rowid,
    });
typedef $$MedicationScheduleRowsTableUpdateCompanionBuilder =
    MedicationScheduleRowsCompanion Function({
      Value<String> id,
      Value<String> medicationId,
      Value<String> animalId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> kind,
      Value<int?> intervalHours,
      Value<String> timesJson,
      Value<String> weekdaysJson,
      Value<String> timeZoneId,
      Value<bool> enabled,
      Value<int> rowid,
    });

final class $$MedicationScheduleRowsTableReferences
    extends BaseReferences<_$AppDatabase, $MedicationScheduleRowsTable, MedicationScheduleEntity> {
  $$MedicationScheduleRowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MedicationRowsTable _medicationIdTable(_$AppDatabase db) =>
      db.medicationRows.createAlias('medication_schedule_rows__medication_id__medication_rows__id');

  $$MedicationRowsTableProcessedTableManager get medicationId {
    final $_column = $_itemColumn<String>('medication_id')!;

    final manager = $$MedicationRowsTableTableManager(
      $_db,
      $_db.medicationRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }

  static $AnimalRowsTable _animalIdTable(_$AppDatabase db) =>
      db.animalRows.createAlias('medication_schedule_rows__animal_id__animal_rows__id');

  $$AnimalRowsTableProcessedTableManager get animalId {
    final $_column = $_itemColumn<String>('animal_id')!;

    final manager = $$AnimalRowsTableTableManager(
      $_db,
      $_db.animalRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_animalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$DoseLedgerRowsTable, List<DoseLedgerEntity>> _doseLedgerRowsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.doseLedgerRows,
    aliasName: 'medication_schedule_rows__id__dose_ledger_rows__schedule_id',
  );

  $$DoseLedgerRowsTableProcessedTableManager get doseLedgerRowsRefs {
    final manager = $$DoseLedgerRowsTableTableManager(
      $_db,
      $_db.doseLedgerRows,
    ).filter((f) => f.scheduleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_doseLedgerRowsRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MedicationScheduleRowsTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationScheduleRowsTable> {
  $$MedicationScheduleRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get intervalHours =>
      $composableBuilder(column: $table.intervalHours, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get timesJson =>
      $composableBuilder(column: $table.timesJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get weekdaysJson =>
      $composableBuilder(column: $table.weekdaysJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get timeZoneId =>
      $composableBuilder(column: $table.timeZoneId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => ColumnFilters(column));

  $$MedicationRowsTableFilterComposer get medicationId {
    final $$MedicationRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medicationRows,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$MedicationRowsTableFilterComposer(
            $db: $db,
            $table: $db.medicationRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AnimalRowsTableFilterComposer get animalId {
    final $$AnimalRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.animalId,
      referencedTable: $db.animalRows,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AnimalRowsTableFilterComposer(
            $db: $db,
            $table: $db.animalRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> doseLedgerRowsRefs(
    Expression<bool> Function($$DoseLedgerRowsTableFilterComposer f) f,
  ) {
    final $$DoseLedgerRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.doseLedgerRows,
      getReferencedColumn: (t) => t.scheduleId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$DoseLedgerRowsTableFilterComposer(
            $db: $db,
            $table: $db.doseLedgerRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MedicationScheduleRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicationScheduleRowsTable> {
  $$MedicationScheduleRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get intervalHours => $composableBuilder(
    column: $table.intervalHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timesJson =>
      $composableBuilder(column: $table.timesJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get weekdaysJson =>
      $composableBuilder(column: $table.weekdaysJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get timeZoneId =>
      $composableBuilder(column: $table.timeZoneId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => ColumnOrderings(column));

  $$MedicationRowsTableOrderingComposer get medicationId {
    final $$MedicationRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medicationRows,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$MedicationRowsTableOrderingComposer(
            $db: $db,
            $table: $db.medicationRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AnimalRowsTableOrderingComposer get animalId {
    final $$AnimalRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.animalId,
      referencedTable: $db.animalRows,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AnimalRowsTableOrderingComposer(
            $db: $db,
            $table: $db.animalRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicationScheduleRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationScheduleRowsTable> {
  $$MedicationScheduleRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get intervalHours =>
      $composableBuilder(column: $table.intervalHours, builder: (column) => column);

  GeneratedColumn<String> get timesJson =>
      $composableBuilder(column: $table.timesJson, builder: (column) => column);

  GeneratedColumn<String> get weekdaysJson =>
      $composableBuilder(column: $table.weekdaysJson, builder: (column) => column);

  GeneratedColumn<String> get timeZoneId =>
      $composableBuilder(column: $table.timeZoneId, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  $$MedicationRowsTableAnnotationComposer get medicationId {
    final $$MedicationRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medicationRows,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$MedicationRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.medicationRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AnimalRowsTableAnnotationComposer get animalId {
    final $$AnimalRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.animalId,
      referencedTable: $db.animalRows,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AnimalRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.animalRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> doseLedgerRowsRefs<T extends Object>(
    Expression<T> Function($$DoseLedgerRowsTableAnnotationComposer a) f,
  ) {
    final $$DoseLedgerRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.doseLedgerRows,
      getReferencedColumn: (t) => t.scheduleId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$DoseLedgerRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.doseLedgerRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MedicationScheduleRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicationScheduleRowsTable,
          MedicationScheduleEntity,
          $$MedicationScheduleRowsTableFilterComposer,
          $$MedicationScheduleRowsTableOrderingComposer,
          $$MedicationScheduleRowsTableAnnotationComposer,
          $$MedicationScheduleRowsTableCreateCompanionBuilder,
          $$MedicationScheduleRowsTableUpdateCompanionBuilder,
          (MedicationScheduleEntity, $$MedicationScheduleRowsTableReferences),
          MedicationScheduleEntity,
          PrefetchHooks Function({bool medicationId, bool animalId, bool doseLedgerRowsRefs})
        > {
  $$MedicationScheduleRowsTableTableManager(_$AppDatabase db, $MedicationScheduleRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicationScheduleRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicationScheduleRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicationScheduleRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> medicationId = const Value.absent(),
                Value<String> animalId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int?> intervalHours = const Value.absent(),
                Value<String> timesJson = const Value.absent(),
                Value<String> weekdaysJson = const Value.absent(),
                Value<String> timeZoneId = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicationScheduleRowsCompanion(
                id: id,
                medicationId: medicationId,
                animalId: animalId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                kind: kind,
                intervalHours: intervalHours,
                timesJson: timesJson,
                weekdaysJson: weekdaysJson,
                timeZoneId: timeZoneId,
                enabled: enabled,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String medicationId,
                required String animalId,
                required DateTime createdAt,
                required DateTime updatedAt,
                required String kind,
                Value<int?> intervalHours = const Value.absent(),
                Value<String> timesJson = const Value.absent(),
                Value<String> weekdaysJson = const Value.absent(),
                Value<String> timeZoneId = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicationScheduleRowsCompanion.insert(
                id: id,
                medicationId: medicationId,
                animalId: animalId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                kind: kind,
                intervalHours: intervalHours,
                timesJson: timesJson,
                weekdaysJson: weekdaysJson,
                timeZoneId: timeZoneId,
                enabled: enabled,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MedicationScheduleRowsTable, MedicationScheduleEntity>(table),
                  $$MedicationScheduleRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({medicationId = false, animalId = false, doseLedgerRowsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (doseLedgerRowsRefs) db.doseLedgerRows],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (medicationId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.medicationId,
                            referencedTable: $$MedicationScheduleRowsTableReferences
                                ._medicationIdTable(db),
                            referencedColumn: $$MedicationScheduleRowsTableReferences
                                ._medicationIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (animalId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.animalId,
                            referencedTable: $$MedicationScheduleRowsTableReferences._animalIdTable(
                              db,
                            ),
                            referencedColumn: $$MedicationScheduleRowsTableReferences
                                ._animalIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (doseLedgerRowsRefs)
                        await $_getPrefetchedData<
                          MedicationScheduleEntity,
                          $MedicationScheduleRowsTable,
                          DoseLedgerEntity
                        >(
                          currentTable: table,
                          referencedTable: $$MedicationScheduleRowsTableReferences
                              ._doseLedgerRowsRefsTable(db),
                          managerFromTypedResult: (p0) => $$MedicationScheduleRowsTableReferences(
                            db,
                            table,
                            p0,
                          ).doseLedgerRowsRefs,
                          referencedItemsForCurrentItem: (item, referencedItems) =>
                              referencedItems.where((e) => e.scheduleId == item.id),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MedicationScheduleRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicationScheduleRowsTable,
      MedicationScheduleEntity,
      $$MedicationScheduleRowsTableFilterComposer,
      $$MedicationScheduleRowsTableOrderingComposer,
      $$MedicationScheduleRowsTableAnnotationComposer,
      $$MedicationScheduleRowsTableCreateCompanionBuilder,
      $$MedicationScheduleRowsTableUpdateCompanionBuilder,
      (MedicationScheduleEntity, $$MedicationScheduleRowsTableReferences),
      MedicationScheduleEntity,
      PrefetchHooks Function({bool medicationId, bool animalId, bool doseLedgerRowsRefs})
    >;
typedef $$DoseLedgerRowsTableCreateCompanionBuilder = DoseLedgerRowsCompanion Function({
  required String id,
  required String medicationId,
  Value<String?> scheduleId,
  required String animalId,
  required DateTime createdAt,
  required DateTime updatedAt,
  required DateTime dueAt,
  required String intendedLocalTime,
  required String timeZoneId,
  required String status,
  Value<DateTime?> administeredAt,
  Value<String?> note,
  Value<int> rowid,
});
typedef $$DoseLedgerRowsTableUpdateCompanionBuilder = DoseLedgerRowsCompanion Function({
  Value<String> id,
  Value<String> medicationId,
  Value<String?> scheduleId,
  Value<String> animalId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime> dueAt,
  Value<String> intendedLocalTime,
  Value<String> timeZoneId,
  Value<String> status,
  Value<DateTime?> administeredAt,
  Value<String?> note,
  Value<int> rowid,
});

final class $$DoseLedgerRowsTableReferences
    extends BaseReferences<_$AppDatabase, $DoseLedgerRowsTable, DoseLedgerEntity> {
  $$DoseLedgerRowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MedicationRowsTable _medicationIdTable(_$AppDatabase db) =>
      db.medicationRows.createAlias('dose_ledger_rows__medication_id__medication_rows__id');

  $$MedicationRowsTableProcessedTableManager get medicationId {
    final $_column = $_itemColumn<String>('medication_id')!;

    final manager = $$MedicationRowsTableTableManager(
      $_db,
      $_db.medicationRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }

  static $MedicationScheduleRowsTable _scheduleIdTable(_$AppDatabase db) => db
      .medicationScheduleRows
      .createAlias('dose_ledger_rows__schedule_id__medication_schedule_rows__id');

  $$MedicationScheduleRowsTableProcessedTableManager? get scheduleId {
    final $_column = $_itemColumn<String>('schedule_id');
    if ($_column == null) return null;
    final manager = $$MedicationScheduleRowsTableTableManager(
      $_db,
      $_db.medicationScheduleRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_scheduleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }

  static $AnimalRowsTable _animalIdTable(_$AppDatabase db) =>
      db.animalRows.createAlias('dose_ledger_rows__animal_id__animal_rows__id');

  $$AnimalRowsTableProcessedTableManager get animalId {
    final $_column = $_itemColumn<String>('animal_id')!;

    final manager = $$AnimalRowsTableTableManager(
      $_db,
      $_db.animalRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_animalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DoseLedgerRowsTableFilterComposer extends Composer<_$AppDatabase, $DoseLedgerRowsTable> {
  $$DoseLedgerRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get intendedLocalTime => $composableBuilder(
    column: $table.intendedLocalTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timeZoneId =>
      $composableBuilder(column: $table.timeZoneId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get administeredAt =>
      $composableBuilder(column: $table.administeredAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => ColumnFilters(column));

  $$MedicationRowsTableFilterComposer get medicationId {
    final $$MedicationRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medicationRows,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$MedicationRowsTableFilterComposer(
            $db: $db,
            $table: $db.medicationRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MedicationScheduleRowsTableFilterComposer get scheduleId {
    final $$MedicationScheduleRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scheduleId,
      referencedTable: $db.medicationScheduleRows,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$MedicationScheduleRowsTableFilterComposer(
            $db: $db,
            $table: $db.medicationScheduleRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AnimalRowsTableFilterComposer get animalId {
    final $$AnimalRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.animalId,
      referencedTable: $db.animalRows,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AnimalRowsTableFilterComposer(
            $db: $db,
            $table: $db.animalRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DoseLedgerRowsTableOrderingComposer extends Composer<_$AppDatabase, $DoseLedgerRowsTable> {
  $$DoseLedgerRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get intendedLocalTime => $composableBuilder(
    column: $table.intendedLocalTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeZoneId =>
      $composableBuilder(column: $table.timeZoneId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get administeredAt => $composableBuilder(
    column: $table.administeredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => ColumnOrderings(column));

  $$MedicationRowsTableOrderingComposer get medicationId {
    final $$MedicationRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medicationRows,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$MedicationRowsTableOrderingComposer(
            $db: $db,
            $table: $db.medicationRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MedicationScheduleRowsTableOrderingComposer get scheduleId {
    final $$MedicationScheduleRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scheduleId,
      referencedTable: $db.medicationScheduleRows,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$MedicationScheduleRowsTableOrderingComposer(
            $db: $db,
            $table: $db.medicationScheduleRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AnimalRowsTableOrderingComposer get animalId {
    final $$AnimalRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.animalId,
      referencedTable: $db.animalRows,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AnimalRowsTableOrderingComposer(
            $db: $db,
            $table: $db.animalRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DoseLedgerRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DoseLedgerRowsTable> {
  $$DoseLedgerRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<String> get intendedLocalTime =>
      $composableBuilder(column: $table.intendedLocalTime, builder: (column) => column);

  GeneratedColumn<String> get timeZoneId =>
      $composableBuilder(column: $table.timeZoneId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get administeredAt =>
      $composableBuilder(column: $table.administeredAt, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$MedicationRowsTableAnnotationComposer get medicationId {
    final $$MedicationRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medicationRows,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$MedicationRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.medicationRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MedicationScheduleRowsTableAnnotationComposer get scheduleId {
    final $$MedicationScheduleRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scheduleId,
      referencedTable: $db.medicationScheduleRows,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$MedicationScheduleRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.medicationScheduleRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AnimalRowsTableAnnotationComposer get animalId {
    final $$AnimalRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.animalId,
      referencedTable: $db.animalRows,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AnimalRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.animalRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DoseLedgerRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DoseLedgerRowsTable,
          DoseLedgerEntity,
          $$DoseLedgerRowsTableFilterComposer,
          $$DoseLedgerRowsTableOrderingComposer,
          $$DoseLedgerRowsTableAnnotationComposer,
          $$DoseLedgerRowsTableCreateCompanionBuilder,
          $$DoseLedgerRowsTableUpdateCompanionBuilder,
          (DoseLedgerEntity, $$DoseLedgerRowsTableReferences),
          DoseLedgerEntity,
          PrefetchHooks Function({bool medicationId, bool scheduleId, bool animalId})
        > {
  $$DoseLedgerRowsTableTableManager(_$AppDatabase db, $DoseLedgerRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DoseLedgerRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DoseLedgerRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DoseLedgerRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> medicationId = const Value.absent(),
                Value<String?> scheduleId = const Value.absent(),
                Value<String> animalId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> dueAt = const Value.absent(),
                Value<String> intendedLocalTime = const Value.absent(),
                Value<String> timeZoneId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> administeredAt = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DoseLedgerRowsCompanion(
                id: id,
                medicationId: medicationId,
                scheduleId: scheduleId,
                animalId: animalId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                dueAt: dueAt,
                intendedLocalTime: intendedLocalTime,
                timeZoneId: timeZoneId,
                status: status,
                administeredAt: administeredAt,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String medicationId,
                Value<String?> scheduleId = const Value.absent(),
                required String animalId,
                required DateTime createdAt,
                required DateTime updatedAt,
                required DateTime dueAt,
                required String intendedLocalTime,
                required String timeZoneId,
                required String status,
                Value<DateTime?> administeredAt = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DoseLedgerRowsCompanion.insert(
                id: id,
                medicationId: medicationId,
                scheduleId: scheduleId,
                animalId: animalId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                dueAt: dueAt,
                intendedLocalTime: intendedLocalTime,
                timeZoneId: timeZoneId,
                status: status,
                administeredAt: administeredAt,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DoseLedgerRowsTable, DoseLedgerEntity>(table),
                  $$DoseLedgerRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({medicationId = false, scheduleId = false, animalId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (medicationId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.medicationId,
                        referencedTable: $$DoseLedgerRowsTableReferences._medicationIdTable(db),
                        referencedColumn: $$DoseLedgerRowsTableReferences._medicationIdTable(db).id,
                      ) as T;
                    }
                    if (scheduleId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.scheduleId,
                        referencedTable: $$DoseLedgerRowsTableReferences._scheduleIdTable(db),
                        referencedColumn: $$DoseLedgerRowsTableReferences._scheduleIdTable(db).id,
                      ) as T;
                    }
                    if (animalId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.animalId,
                        referencedTable: $$DoseLedgerRowsTableReferences._animalIdTable(db),
                        referencedColumn: $$DoseLedgerRowsTableReferences._animalIdTable(db).id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DoseLedgerRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DoseLedgerRowsTable,
      DoseLedgerEntity,
      $$DoseLedgerRowsTableFilterComposer,
      $$DoseLedgerRowsTableOrderingComposer,
      $$DoseLedgerRowsTableAnnotationComposer,
      $$DoseLedgerRowsTableCreateCompanionBuilder,
      $$DoseLedgerRowsTableUpdateCompanionBuilder,
      (DoseLedgerEntity, $$DoseLedgerRowsTableReferences),
      DoseLedgerEntity,
      PrefetchHooks Function({bool medicationId, bool scheduleId, bool animalId})
    >;
typedef $$HealthRecordRowsTableCreateCompanionBuilder = HealthRecordRowsCompanion Function({
  required String id,
  required String animalId,
  required DateTime createdAt,
  required DateTime updatedAt,
  required DateTime occurredAt,
  required String kind,
  required String title,
  Value<double?> canonicalValue,
  Value<String?> canonicalUnit,
  Value<String?> enteredUnit,
  Value<String?> note,
  Value<bool> archived,
  Value<int> rowid,
});
typedef $$HealthRecordRowsTableUpdateCompanionBuilder = HealthRecordRowsCompanion Function({
  Value<String> id,
  Value<String> animalId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime> occurredAt,
  Value<String> kind,
  Value<String> title,
  Value<double?> canonicalValue,
  Value<String?> canonicalUnit,
  Value<String?> enteredUnit,
  Value<String?> note,
  Value<bool> archived,
  Value<int> rowid,
});

final class $$HealthRecordRowsTableReferences
    extends BaseReferences<_$AppDatabase, $HealthRecordRowsTable, HealthRecordEntity> {
  $$HealthRecordRowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AnimalRowsTable _animalIdTable(_$AppDatabase db) =>
      db.animalRows.createAlias('health_record_rows__animal_id__animal_rows__id');

  $$AnimalRowsTableProcessedTableManager get animalId {
    final $_column = $_itemColumn<String>('animal_id')!;

    final manager = $$AnimalRowsTableTableManager(
      $_db,
      $_db.animalRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_animalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$HealthRecordRowsTableFilterComposer
    extends Composer<_$AppDatabase, $HealthRecordRowsTable> {
  $$HealthRecordRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get occurredAt =>
      $composableBuilder(column: $table.occurredAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get canonicalValue =>
      $composableBuilder(column: $table.canonicalValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get canonicalUnit =>
      $composableBuilder(column: $table.canonicalUnit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get enteredUnit =>
      $composableBuilder(column: $table.enteredUnit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => ColumnFilters(column));

  $$AnimalRowsTableFilterComposer get animalId {
    final $$AnimalRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.animalId,
      referencedTable: $db.animalRows,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AnimalRowsTableFilterComposer(
            $db: $db,
            $table: $db.animalRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HealthRecordRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $HealthRecordRowsTable> {
  $$HealthRecordRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get occurredAt =>
      $composableBuilder(column: $table.occurredAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get canonicalValue => $composableBuilder(
    column: $table.canonicalValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get canonicalUnit => $composableBuilder(
    column: $table.canonicalUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get enteredUnit =>
      $composableBuilder(column: $table.enteredUnit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => ColumnOrderings(column));

  $$AnimalRowsTableOrderingComposer get animalId {
    final $$AnimalRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.animalId,
      referencedTable: $db.animalRows,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AnimalRowsTableOrderingComposer(
            $db: $db,
            $table: $db.animalRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HealthRecordRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HealthRecordRowsTable> {
  $$HealthRecordRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt =>
      $composableBuilder(column: $table.occurredAt, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<double> get canonicalValue =>
      $composableBuilder(column: $table.canonicalValue, builder: (column) => column);

  GeneratedColumn<String> get canonicalUnit =>
      $composableBuilder(column: $table.canonicalUnit, builder: (column) => column);

  GeneratedColumn<String> get enteredUnit =>
      $composableBuilder(column: $table.enteredUnit, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  $$AnimalRowsTableAnnotationComposer get animalId {
    final $$AnimalRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.animalId,
      referencedTable: $db.animalRows,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AnimalRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.animalRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HealthRecordRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HealthRecordRowsTable,
          HealthRecordEntity,
          $$HealthRecordRowsTableFilterComposer,
          $$HealthRecordRowsTableOrderingComposer,
          $$HealthRecordRowsTableAnnotationComposer,
          $$HealthRecordRowsTableCreateCompanionBuilder,
          $$HealthRecordRowsTableUpdateCompanionBuilder,
          (HealthRecordEntity, $$HealthRecordRowsTableReferences),
          HealthRecordEntity,
          PrefetchHooks Function({bool animalId})
        > {
  $$HealthRecordRowsTableTableManager(_$AppDatabase db, $HealthRecordRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HealthRecordRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HealthRecordRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HealthRecordRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> animalId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<double?> canonicalValue = const Value.absent(),
                Value<String?> canonicalUnit = const Value.absent(),
                Value<String?> enteredUnit = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HealthRecordRowsCompanion(
                id: id,
                animalId: animalId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                occurredAt: occurredAt,
                kind: kind,
                title: title,
                canonicalValue: canonicalValue,
                canonicalUnit: canonicalUnit,
                enteredUnit: enteredUnit,
                note: note,
                archived: archived,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String animalId,
                required DateTime createdAt,
                required DateTime updatedAt,
                required DateTime occurredAt,
                required String kind,
                required String title,
                Value<double?> canonicalValue = const Value.absent(),
                Value<String?> canonicalUnit = const Value.absent(),
                Value<String?> enteredUnit = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HealthRecordRowsCompanion.insert(
                id: id,
                animalId: animalId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                occurredAt: occurredAt,
                kind: kind,
                title: title,
                canonicalValue: canonicalValue,
                canonicalUnit: canonicalUnit,
                enteredUnit: enteredUnit,
                note: note,
                archived: archived,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$HealthRecordRowsTable, HealthRecordEntity>(table),
                  $$HealthRecordRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({animalId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (animalId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.animalId,
                        referencedTable: $$HealthRecordRowsTableReferences._animalIdTable(db),
                        referencedColumn: $$HealthRecordRowsTableReferences._animalIdTable(db).id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$HealthRecordRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HealthRecordRowsTable,
      HealthRecordEntity,
      $$HealthRecordRowsTableFilterComposer,
      $$HealthRecordRowsTableOrderingComposer,
      $$HealthRecordRowsTableAnnotationComposer,
      $$HealthRecordRowsTableCreateCompanionBuilder,
      $$HealthRecordRowsTableUpdateCompanionBuilder,
      (HealthRecordEntity, $$HealthRecordRowsTableReferences),
      HealthRecordEntity,
      PrefetchHooks Function({bool animalId})
    >;
typedef $$CareDocumentRowsTableCreateCompanionBuilder = CareDocumentRowsCompanion Function({
  required String id,
  required String animalId,
  required DateTime createdAt,
  required DateTime updatedAt,
  required DateTime documentDate,
  required String title,
  required String category,
  required String storedPath,
  required String mediaType,
  required String checksumSha256,
  required int byteLength,
  Value<String?> notes,
  Value<DateTime?> expiryDate,
  Value<DateTime?> reminderAt,
  Value<bool> archived,
  Value<int> rowid,
});
typedef $$CareDocumentRowsTableUpdateCompanionBuilder = CareDocumentRowsCompanion Function({
  Value<String> id,
  Value<String> animalId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime> documentDate,
  Value<String> title,
  Value<String> category,
  Value<String> storedPath,
  Value<String> mediaType,
  Value<String> checksumSha256,
  Value<int> byteLength,
  Value<String?> notes,
  Value<DateTime?> expiryDate,
  Value<DateTime?> reminderAt,
  Value<bool> archived,
  Value<int> rowid,
});

final class $$CareDocumentRowsTableReferences
    extends BaseReferences<_$AppDatabase, $CareDocumentRowsTable, CareDocumentEntity> {
  $$CareDocumentRowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AnimalRowsTable _animalIdTable(_$AppDatabase db) =>
      db.animalRows.createAlias('care_document_rows__animal_id__animal_rows__id');

  $$AnimalRowsTableProcessedTableManager get animalId {
    final $_column = $_itemColumn<String>('animal_id')!;

    final manager = $$AnimalRowsTableTableManager(
      $_db,
      $_db.animalRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_animalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$CareDocumentRowsTableFilterComposer
    extends Composer<_$AppDatabase, $CareDocumentRowsTable> {
  $$CareDocumentRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get documentDate =>
      $composableBuilder(column: $table.documentDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get storedPath =>
      $composableBuilder(column: $table.storedPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mediaType =>
      $composableBuilder(column: $table.mediaType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get checksumSha256 =>
      $composableBuilder(column: $table.checksumSha256, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get byteLength =>
      $composableBuilder(column: $table.byteLength, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expiryDate =>
      $composableBuilder(column: $table.expiryDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get reminderAt =>
      $composableBuilder(column: $table.reminderAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => ColumnFilters(column));

  $$AnimalRowsTableFilterComposer get animalId {
    final $$AnimalRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.animalId,
      referencedTable: $db.animalRows,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AnimalRowsTableFilterComposer(
            $db: $db,
            $table: $db.animalRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CareDocumentRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $CareDocumentRowsTable> {
  $$CareDocumentRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get documentDate =>
      $composableBuilder(column: $table.documentDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get storedPath =>
      $composableBuilder(column: $table.storedPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mediaType =>
      $composableBuilder(column: $table.mediaType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get checksumSha256 => $composableBuilder(
    column: $table.checksumSha256,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get byteLength =>
      $composableBuilder(column: $table.byteLength, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expiryDate =>
      $composableBuilder(column: $table.expiryDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get reminderAt =>
      $composableBuilder(column: $table.reminderAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => ColumnOrderings(column));

  $$AnimalRowsTableOrderingComposer get animalId {
    final $$AnimalRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.animalId,
      referencedTable: $db.animalRows,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AnimalRowsTableOrderingComposer(
            $db: $db,
            $table: $db.animalRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CareDocumentRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CareDocumentRowsTable> {
  $$CareDocumentRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get documentDate =>
      $composableBuilder(column: $table.documentDate, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get storedPath =>
      $composableBuilder(column: $table.storedPath, builder: (column) => column);

  GeneratedColumn<String> get mediaType =>
      $composableBuilder(column: $table.mediaType, builder: (column) => column);

  GeneratedColumn<String> get checksumSha256 =>
      $composableBuilder(column: $table.checksumSha256, builder: (column) => column);

  GeneratedColumn<int> get byteLength =>
      $composableBuilder(column: $table.byteLength, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get expiryDate =>
      $composableBuilder(column: $table.expiryDate, builder: (column) => column);

  GeneratedColumn<DateTime> get reminderAt =>
      $composableBuilder(column: $table.reminderAt, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  $$AnimalRowsTableAnnotationComposer get animalId {
    final $$AnimalRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.animalId,
      referencedTable: $db.animalRows,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AnimalRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.animalRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CareDocumentRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CareDocumentRowsTable,
          CareDocumentEntity,
          $$CareDocumentRowsTableFilterComposer,
          $$CareDocumentRowsTableOrderingComposer,
          $$CareDocumentRowsTableAnnotationComposer,
          $$CareDocumentRowsTableCreateCompanionBuilder,
          $$CareDocumentRowsTableUpdateCompanionBuilder,
          (CareDocumentEntity, $$CareDocumentRowsTableReferences),
          CareDocumentEntity,
          PrefetchHooks Function({bool animalId})
        > {
  $$CareDocumentRowsTableTableManager(_$AppDatabase db, $CareDocumentRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CareDocumentRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CareDocumentRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CareDocumentRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> animalId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> documentDate = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> storedPath = const Value.absent(),
                Value<String> mediaType = const Value.absent(),
                Value<String> checksumSha256 = const Value.absent(),
                Value<int> byteLength = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> expiryDate = const Value.absent(),
                Value<DateTime?> reminderAt = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CareDocumentRowsCompanion(
                id: id,
                animalId: animalId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                documentDate: documentDate,
                title: title,
                category: category,
                storedPath: storedPath,
                mediaType: mediaType,
                checksumSha256: checksumSha256,
                byteLength: byteLength,
                notes: notes,
                expiryDate: expiryDate,
                reminderAt: reminderAt,
                archived: archived,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String animalId,
                required DateTime createdAt,
                required DateTime updatedAt,
                required DateTime documentDate,
                required String title,
                required String category,
                required String storedPath,
                required String mediaType,
                required String checksumSha256,
                required int byteLength,
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> expiryDate = const Value.absent(),
                Value<DateTime?> reminderAt = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CareDocumentRowsCompanion.insert(
                id: id,
                animalId: animalId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                documentDate: documentDate,
                title: title,
                category: category,
                storedPath: storedPath,
                mediaType: mediaType,
                checksumSha256: checksumSha256,
                byteLength: byteLength,
                notes: notes,
                expiryDate: expiryDate,
                reminderAt: reminderAt,
                archived: archived,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CareDocumentRowsTable, CareDocumentEntity>(table),
                  $$CareDocumentRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({animalId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (animalId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.animalId,
                        referencedTable: $$CareDocumentRowsTableReferences._animalIdTable(db),
                        referencedColumn: $$CareDocumentRowsTableReferences._animalIdTable(db).id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CareDocumentRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CareDocumentRowsTable,
      CareDocumentEntity,
      $$CareDocumentRowsTableFilterComposer,
      $$CareDocumentRowsTableOrderingComposer,
      $$CareDocumentRowsTableAnnotationComposer,
      $$CareDocumentRowsTableCreateCompanionBuilder,
      $$CareDocumentRowsTableUpdateCompanionBuilder,
      (CareDocumentEntity, $$CareDocumentRowsTableReferences),
      CareDocumentEntity,
      PrefetchHooks Function({bool animalId})
    >;
typedef $$SettingRowsTableCreateCompanionBuilder = SettingRowsCompanion Function({
  required String key,
  required String jsonValue,
  Value<int> rowid,
});
typedef $$SettingRowsTableUpdateCompanionBuilder = SettingRowsCompanion Function({
  Value<String> key,
  Value<String> jsonValue,
  Value<int> rowid,
});

class $$SettingRowsTableFilterComposer extends Composer<_$AppDatabase, $SettingRowsTable> {
  $$SettingRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get jsonValue =>
      $composableBuilder(column: $table.jsonValue, builder: (column) => ColumnFilters(column));
}

class $$SettingRowsTableOrderingComposer extends Composer<_$AppDatabase, $SettingRowsTable> {
  $$SettingRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get jsonValue =>
      $composableBuilder(column: $table.jsonValue, builder: (column) => ColumnOrderings(column));
}

class $$SettingRowsTableAnnotationComposer extends Composer<_$AppDatabase, $SettingRowsTable> {
  $$SettingRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get jsonValue =>
      $composableBuilder(column: $table.jsonValue, builder: (column) => column);
}

class $$SettingRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingRowsTable,
          SettingEntity,
          $$SettingRowsTableFilterComposer,
          $$SettingRowsTableOrderingComposer,
          $$SettingRowsTableAnnotationComposer,
          $$SettingRowsTableCreateCompanionBuilder,
          $$SettingRowsTableUpdateCompanionBuilder,
          (SettingEntity, BaseReferences<_$AppDatabase, $SettingRowsTable, SettingEntity>),
          SettingEntity,
          PrefetchHooks Function()
        > {
  $$SettingRowsTableTableManager(_$AppDatabase db, $SettingRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$SettingRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$SettingRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> jsonValue = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => SettingRowsCompanion(key: key, jsonValue: jsonValue, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String jsonValue,
            Value<int> rowid = const Value.absent(),
          }) => SettingRowsCompanion.insert(key: key, jsonValue: jsonValue, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingRowsTable, SettingEntity>(table),
                  BaseReferences<_$AppDatabase, $SettingRowsTable, SettingEntity>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingRowsTable,
      SettingEntity,
      $$SettingRowsTableFilterComposer,
      $$SettingRowsTableOrderingComposer,
      $$SettingRowsTableAnnotationComposer,
      $$SettingRowsTableCreateCompanionBuilder,
      $$SettingRowsTableUpdateCompanionBuilder,
      (SettingEntity, BaseReferences<_$AppDatabase, $SettingRowsTable, SettingEntity>),
      SettingEntity,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AnimalRowsTableTableManager get animalRows =>
      $$AnimalRowsTableTableManager(_db, _db.animalRows);
  $$IdentifierRowsTableTableManager get identifierRows =>
      $$IdentifierRowsTableTableManager(_db, _db.identifierRows);
  $$RespiratorySessionRowsTableTableManager get respiratorySessionRows =>
      $$RespiratorySessionRowsTableTableManager(_db, _db.respiratorySessionRows);
  $$RespiratoryReminderRowsTableTableManager get respiratoryReminderRows =>
      $$RespiratoryReminderRowsTableTableManager(_db, _db.respiratoryReminderRows);
  $$WeightReminderRowsTableTableManager get weightReminderRows =>
      $$WeightReminderRowsTableTableManager(_db, _db.weightReminderRows);
  $$MedicationRowsTableTableManager get medicationRows =>
      $$MedicationRowsTableTableManager(_db, _db.medicationRows);
  $$MedicationScheduleRowsTableTableManager get medicationScheduleRows =>
      $$MedicationScheduleRowsTableTableManager(_db, _db.medicationScheduleRows);
  $$DoseLedgerRowsTableTableManager get doseLedgerRows =>
      $$DoseLedgerRowsTableTableManager(_db, _db.doseLedgerRows);
  $$HealthRecordRowsTableTableManager get healthRecordRows =>
      $$HealthRecordRowsTableTableManager(_db, _db.healthRecordRows);
  $$CareDocumentRowsTableTableManager get careDocumentRows =>
      $$CareDocumentRowsTableTableManager(_db, _db.careDocumentRows);
  $$SettingRowsTableTableManager get settingRows =>
      $$SettingRowsTableTableManager(_db, _db.settingRows);
}
