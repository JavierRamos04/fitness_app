// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _birthDateMeta = const VerificationMeta(
    'birthDate',
  );
  @override
  late final GeneratedColumn<DateTime> birthDate = GeneratedColumn<DateTime>(
    'birth_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightCmMeta = const VerificationMeta(
    'heightCm',
  );
  @override
  late final GeneratedColumn<double> heightCm = GeneratedColumn<double>(
    'height_cm',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentWeightKgMeta = const VerificationMeta(
    'currentWeightKg',
  );
  @override
  late final GeneratedColumn<double> currentWeightKg = GeneratedColumn<double>(
    'current_weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fitnessLevelMeta = const VerificationMeta(
    'fitnessLevel',
  );
  @override
  late final GeneratedColumn<String> fitnessLevel = GeneratedColumn<String>(
    'fitness_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trainingLocationMeta = const VerificationMeta(
    'trainingLocation',
  );
  @override
  late final GeneratedColumn<String> trainingLocation = GeneratedColumn<String>(
    'training_location',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weeklyFrequencyMeta = const VerificationMeta(
    'weeklyFrequency',
  );
  @override
  late final GeneratedColumn<int> weeklyFrequency = GeneratedColumn<int>(
    'weekly_frequency',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _availableMinutesMeta = const VerificationMeta(
    'availableMinutes',
  );
  @override
  late final GeneratedColumn<int> availableMinutes = GeneratedColumn<int>(
    'available_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    birthDate,
    heightCm,
    currentWeightKg,
    fitnessLevel,
    trainingLocation,
    weeklyFrequency,
    availableMinutes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('birth_date')) {
      context.handle(
        _birthDateMeta,
        birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta),
      );
    } else if (isInserting) {
      context.missing(_birthDateMeta);
    }
    if (data.containsKey('height_cm')) {
      context.handle(
        _heightCmMeta,
        heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta),
      );
    } else if (isInserting) {
      context.missing(_heightCmMeta);
    }
    if (data.containsKey('current_weight_kg')) {
      context.handle(
        _currentWeightKgMeta,
        currentWeightKg.isAcceptableOrUnknown(
          data['current_weight_kg']!,
          _currentWeightKgMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentWeightKgMeta);
    }
    if (data.containsKey('fitness_level')) {
      context.handle(
        _fitnessLevelMeta,
        fitnessLevel.isAcceptableOrUnknown(
          data['fitness_level']!,
          _fitnessLevelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fitnessLevelMeta);
    }
    if (data.containsKey('training_location')) {
      context.handle(
        _trainingLocationMeta,
        trainingLocation.isAcceptableOrUnknown(
          data['training_location']!,
          _trainingLocationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_trainingLocationMeta);
    }
    if (data.containsKey('weekly_frequency')) {
      context.handle(
        _weeklyFrequencyMeta,
        weeklyFrequency.isAcceptableOrUnknown(
          data['weekly_frequency']!,
          _weeklyFrequencyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_weeklyFrequencyMeta);
    }
    if (data.containsKey('available_minutes')) {
      context.handle(
        _availableMinutesMeta,
        availableMinutes.isAcceptableOrUnknown(
          data['available_minutes']!,
          _availableMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_availableMinutesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      birthDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}birth_date'],
      )!,
      heightCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height_cm'],
      )!,
      currentWeightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}current_weight_kg'],
      )!,
      fitnessLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fitness_level'],
      )!,
      trainingLocation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}training_location'],
      )!,
      weeklyFrequency: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekly_frequency'],
      )!,
      availableMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}available_minutes'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final DateTime birthDate;
  final double heightCm;
  final double currentWeightKg;
  final String fitnessLevel;
  final String trainingLocation;
  final int weeklyFrequency;
  final int availableMinutes;
  const User({
    required this.id,
    required this.birthDate,
    required this.heightCm,
    required this.currentWeightKg,
    required this.fitnessLevel,
    required this.trainingLocation,
    required this.weeklyFrequency,
    required this.availableMinutes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['birth_date'] = Variable<DateTime>(birthDate);
    map['height_cm'] = Variable<double>(heightCm);
    map['current_weight_kg'] = Variable<double>(currentWeightKg);
    map['fitness_level'] = Variable<String>(fitnessLevel);
    map['training_location'] = Variable<String>(trainingLocation);
    map['weekly_frequency'] = Variable<int>(weeklyFrequency);
    map['available_minutes'] = Variable<int>(availableMinutes);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      birthDate: Value(birthDate),
      heightCm: Value(heightCm),
      currentWeightKg: Value(currentWeightKg),
      fitnessLevel: Value(fitnessLevel),
      trainingLocation: Value(trainingLocation),
      weeklyFrequency: Value(weeklyFrequency),
      availableMinutes: Value(availableMinutes),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      birthDate: serializer.fromJson<DateTime>(json['birthDate']),
      heightCm: serializer.fromJson<double>(json['heightCm']),
      currentWeightKg: serializer.fromJson<double>(json['currentWeightKg']),
      fitnessLevel: serializer.fromJson<String>(json['fitnessLevel']),
      trainingLocation: serializer.fromJson<String>(json['trainingLocation']),
      weeklyFrequency: serializer.fromJson<int>(json['weeklyFrequency']),
      availableMinutes: serializer.fromJson<int>(json['availableMinutes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'birthDate': serializer.toJson<DateTime>(birthDate),
      'heightCm': serializer.toJson<double>(heightCm),
      'currentWeightKg': serializer.toJson<double>(currentWeightKg),
      'fitnessLevel': serializer.toJson<String>(fitnessLevel),
      'trainingLocation': serializer.toJson<String>(trainingLocation),
      'weeklyFrequency': serializer.toJson<int>(weeklyFrequency),
      'availableMinutes': serializer.toJson<int>(availableMinutes),
    };
  }

  User copyWith({
    int? id,
    DateTime? birthDate,
    double? heightCm,
    double? currentWeightKg,
    String? fitnessLevel,
    String? trainingLocation,
    int? weeklyFrequency,
    int? availableMinutes,
  }) => User(
    id: id ?? this.id,
    birthDate: birthDate ?? this.birthDate,
    heightCm: heightCm ?? this.heightCm,
    currentWeightKg: currentWeightKg ?? this.currentWeightKg,
    fitnessLevel: fitnessLevel ?? this.fitnessLevel,
    trainingLocation: trainingLocation ?? this.trainingLocation,
    weeklyFrequency: weeklyFrequency ?? this.weeklyFrequency,
    availableMinutes: availableMinutes ?? this.availableMinutes,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      currentWeightKg: data.currentWeightKg.present
          ? data.currentWeightKg.value
          : this.currentWeightKg,
      fitnessLevel: data.fitnessLevel.present
          ? data.fitnessLevel.value
          : this.fitnessLevel,
      trainingLocation: data.trainingLocation.present
          ? data.trainingLocation.value
          : this.trainingLocation,
      weeklyFrequency: data.weeklyFrequency.present
          ? data.weeklyFrequency.value
          : this.weeklyFrequency,
      availableMinutes: data.availableMinutes.present
          ? data.availableMinutes.value
          : this.availableMinutes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('birthDate: $birthDate, ')
          ..write('heightCm: $heightCm, ')
          ..write('currentWeightKg: $currentWeightKg, ')
          ..write('fitnessLevel: $fitnessLevel, ')
          ..write('trainingLocation: $trainingLocation, ')
          ..write('weeklyFrequency: $weeklyFrequency, ')
          ..write('availableMinutes: $availableMinutes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    birthDate,
    heightCm,
    currentWeightKg,
    fitnessLevel,
    trainingLocation,
    weeklyFrequency,
    availableMinutes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.birthDate == this.birthDate &&
          other.heightCm == this.heightCm &&
          other.currentWeightKg == this.currentWeightKg &&
          other.fitnessLevel == this.fitnessLevel &&
          other.trainingLocation == this.trainingLocation &&
          other.weeklyFrequency == this.weeklyFrequency &&
          other.availableMinutes == this.availableMinutes);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<DateTime> birthDate;
  final Value<double> heightCm;
  final Value<double> currentWeightKg;
  final Value<String> fitnessLevel;
  final Value<String> trainingLocation;
  final Value<int> weeklyFrequency;
  final Value<int> availableMinutes;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.currentWeightKg = const Value.absent(),
    this.fitnessLevel = const Value.absent(),
    this.trainingLocation = const Value.absent(),
    this.weeklyFrequency = const Value.absent(),
    this.availableMinutes = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required DateTime birthDate,
    required double heightCm,
    required double currentWeightKg,
    required String fitnessLevel,
    required String trainingLocation,
    required int weeklyFrequency,
    required int availableMinutes,
  }) : birthDate = Value(birthDate),
       heightCm = Value(heightCm),
       currentWeightKg = Value(currentWeightKg),
       fitnessLevel = Value(fitnessLevel),
       trainingLocation = Value(trainingLocation),
       weeklyFrequency = Value(weeklyFrequency),
       availableMinutes = Value(availableMinutes);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<DateTime>? birthDate,
    Expression<double>? heightCm,
    Expression<double>? currentWeightKg,
    Expression<String>? fitnessLevel,
    Expression<String>? trainingLocation,
    Expression<int>? weeklyFrequency,
    Expression<int>? availableMinutes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (birthDate != null) 'birth_date': birthDate,
      if (heightCm != null) 'height_cm': heightCm,
      if (currentWeightKg != null) 'current_weight_kg': currentWeightKg,
      if (fitnessLevel != null) 'fitness_level': fitnessLevel,
      if (trainingLocation != null) 'training_location': trainingLocation,
      if (weeklyFrequency != null) 'weekly_frequency': weeklyFrequency,
      if (availableMinutes != null) 'available_minutes': availableMinutes,
    });
  }

  UsersCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? birthDate,
    Value<double>? heightCm,
    Value<double>? currentWeightKg,
    Value<String>? fitnessLevel,
    Value<String>? trainingLocation,
    Value<int>? weeklyFrequency,
    Value<int>? availableMinutes,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      birthDate: birthDate ?? this.birthDate,
      heightCm: heightCm ?? this.heightCm,
      currentWeightKg: currentWeightKg ?? this.currentWeightKg,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      trainingLocation: trainingLocation ?? this.trainingLocation,
      weeklyFrequency: weeklyFrequency ?? this.weeklyFrequency,
      availableMinutes: availableMinutes ?? this.availableMinutes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<DateTime>(birthDate.value);
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<double>(heightCm.value);
    }
    if (currentWeightKg.present) {
      map['current_weight_kg'] = Variable<double>(currentWeightKg.value);
    }
    if (fitnessLevel.present) {
      map['fitness_level'] = Variable<String>(fitnessLevel.value);
    }
    if (trainingLocation.present) {
      map['training_location'] = Variable<String>(trainingLocation.value);
    }
    if (weeklyFrequency.present) {
      map['weekly_frequency'] = Variable<int>(weeklyFrequency.value);
    }
    if (availableMinutes.present) {
      map['available_minutes'] = Variable<int>(availableMinutes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('birthDate: $birthDate, ')
          ..write('heightCm: $heightCm, ')
          ..write('currentWeightKg: $currentWeightKg, ')
          ..write('fitnessLevel: $fitnessLevel, ')
          ..write('trainingLocation: $trainingLocation, ')
          ..write('weeklyFrequency: $weeklyFrequency, ')
          ..write('availableMinutes: $availableMinutes')
          ..write(')'))
        .toString();
  }
}

class $WeightEntriesTable extends WeightEntries
    with TableInfo<$WeightEntriesTable, WeightEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeightEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, userId, recordedAt, weightKg];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weight_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeightEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeightEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeightEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recorded_at'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
    );
  }

  @override
  $WeightEntriesTable createAlias(String alias) {
    return $WeightEntriesTable(attachedDatabase, alias);
  }
}

class WeightEntry extends DataClass implements Insertable<WeightEntry> {
  final int id;
  final int userId;
  final DateTime recordedAt;
  final double weightKg;
  const WeightEntry({
    required this.id,
    required this.userId,
    required this.recordedAt,
    required this.weightKg,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    map['weight_kg'] = Variable<double>(weightKg);
    return map;
  }

  WeightEntriesCompanion toCompanion(bool nullToAbsent) {
    return WeightEntriesCompanion(
      id: Value(id),
      userId: Value(userId),
      recordedAt: Value(recordedAt),
      weightKg: Value(weightKg),
    );
  }

  factory WeightEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeightEntry(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'weightKg': serializer.toJson<double>(weightKg),
    };
  }

  WeightEntry copyWith({
    int? id,
    int? userId,
    DateTime? recordedAt,
    double? weightKg,
  }) => WeightEntry(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    recordedAt: recordedAt ?? this.recordedAt,
    weightKg: weightKg ?? this.weightKg,
  );
  WeightEntry copyWithCompanion(WeightEntriesCompanion data) {
    return WeightEntry(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeightEntry(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('weightKg: $weightKg')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, recordedAt, weightKg);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeightEntry &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.recordedAt == this.recordedAt &&
          other.weightKg == this.weightKg);
}

class WeightEntriesCompanion extends UpdateCompanion<WeightEntry> {
  final Value<int> id;
  final Value<int> userId;
  final Value<DateTime> recordedAt;
  final Value<double> weightKg;
  const WeightEntriesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.weightKg = const Value.absent(),
  });
  WeightEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required DateTime recordedAt,
    required double weightKg,
  }) : userId = Value(userId),
       recordedAt = Value(recordedAt),
       weightKg = Value(weightKg);
  static Insertable<WeightEntry> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<DateTime>? recordedAt,
    Expression<double>? weightKg,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (weightKg != null) 'weight_kg': weightKg,
    });
  }

  WeightEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<DateTime>? recordedAt,
    Value<double>? weightKg,
  }) {
    return WeightEntriesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      recordedAt: recordedAt ?? this.recordedAt,
      weightKg: weightKg ?? this.weightKg,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeightEntriesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('weightKg: $weightKg')
          ..write(')'))
        .toString();
  }
}

class $GoalsTable extends Goals with TableInfo<$GoalsTable, Goal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetValueMeta = const VerificationMeta(
    'targetValue',
  );
  @override
  late final GeneratedColumn<double> targetValue = GeneratedColumn<double>(
    'target_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetDateMeta = const VerificationMeta(
    'targetDate',
  );
  @override
  late final GeneratedColumn<DateTime> targetDate = GeneratedColumn<DateTime>(
    'target_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    type,
    name,
    targetValue,
    unit,
    startDate,
    targetDate,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<Goal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('target_value')) {
      context.handle(
        _targetValueMeta,
        targetValue.isAcceptableOrUnknown(
          data['target_value']!,
          _targetValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetValueMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('target_date')) {
      context.handle(
        _targetDateMeta,
        targetDate.isAcceptableOrUnknown(data['target_date']!, _targetDateMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Goal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Goal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      targetValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_value'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      targetDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}target_date'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $GoalsTable createAlias(String alias) {
    return $GoalsTable(attachedDatabase, alias);
  }
}

class Goal extends DataClass implements Insertable<Goal> {
  final int id;
  final int userId;
  final String type;
  final String name;
  final double targetValue;
  final String unit;
  final DateTime startDate;
  final DateTime? targetDate;
  final String status;
  const Goal({
    required this.id,
    required this.userId,
    required this.type,
    required this.name,
    required this.targetValue,
    required this.unit,
    required this.startDate,
    this.targetDate,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['type'] = Variable<String>(type);
    map['name'] = Variable<String>(name);
    map['target_value'] = Variable<double>(targetValue);
    map['unit'] = Variable<String>(unit);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || targetDate != null) {
      map['target_date'] = Variable<DateTime>(targetDate);
    }
    map['status'] = Variable<String>(status);
    return map;
  }

  GoalsCompanion toCompanion(bool nullToAbsent) {
    return GoalsCompanion(
      id: Value(id),
      userId: Value(userId),
      type: Value(type),
      name: Value(name),
      targetValue: Value(targetValue),
      unit: Value(unit),
      startDate: Value(startDate),
      targetDate: targetDate == null && nullToAbsent
          ? const Value.absent()
          : Value(targetDate),
      status: Value(status),
    );
  }

  factory Goal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Goal(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      type: serializer.fromJson<String>(json['type']),
      name: serializer.fromJson<String>(json['name']),
      targetValue: serializer.fromJson<double>(json['targetValue']),
      unit: serializer.fromJson<String>(json['unit']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      targetDate: serializer.fromJson<DateTime?>(json['targetDate']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'type': serializer.toJson<String>(type),
      'name': serializer.toJson<String>(name),
      'targetValue': serializer.toJson<double>(targetValue),
      'unit': serializer.toJson<String>(unit),
      'startDate': serializer.toJson<DateTime>(startDate),
      'targetDate': serializer.toJson<DateTime?>(targetDate),
      'status': serializer.toJson<String>(status),
    };
  }

  Goal copyWith({
    int? id,
    int? userId,
    String? type,
    String? name,
    double? targetValue,
    String? unit,
    DateTime? startDate,
    Value<DateTime?> targetDate = const Value.absent(),
    String? status,
  }) => Goal(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    type: type ?? this.type,
    name: name ?? this.name,
    targetValue: targetValue ?? this.targetValue,
    unit: unit ?? this.unit,
    startDate: startDate ?? this.startDate,
    targetDate: targetDate.present ? targetDate.value : this.targetDate,
    status: status ?? this.status,
  );
  Goal copyWithCompanion(GoalsCompanion data) {
    return Goal(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      type: data.type.present ? data.type.value : this.type,
      name: data.name.present ? data.name.value : this.name,
      targetValue: data.targetValue.present
          ? data.targetValue.value
          : this.targetValue,
      unit: data.unit.present ? data.unit.value : this.unit,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      targetDate: data.targetDate.present
          ? data.targetDate.value
          : this.targetDate,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Goal(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('targetValue: $targetValue, ')
          ..write('unit: $unit, ')
          ..write('startDate: $startDate, ')
          ..write('targetDate: $targetDate, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    type,
    name,
    targetValue,
    unit,
    startDate,
    targetDate,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Goal &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.type == this.type &&
          other.name == this.name &&
          other.targetValue == this.targetValue &&
          other.unit == this.unit &&
          other.startDate == this.startDate &&
          other.targetDate == this.targetDate &&
          other.status == this.status);
}

class GoalsCompanion extends UpdateCompanion<Goal> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> type;
  final Value<String> name;
  final Value<double> targetValue;
  final Value<String> unit;
  final Value<DateTime> startDate;
  final Value<DateTime?> targetDate;
  final Value<String> status;
  const GoalsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.type = const Value.absent(),
    this.name = const Value.absent(),
    this.targetValue = const Value.absent(),
    this.unit = const Value.absent(),
    this.startDate = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.status = const Value.absent(),
  });
  GoalsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required String type,
    required String name,
    required double targetValue,
    required String unit,
    required DateTime startDate,
    this.targetDate = const Value.absent(),
    required String status,
  }) : userId = Value(userId),
       type = Value(type),
       name = Value(name),
       targetValue = Value(targetValue),
       unit = Value(unit),
       startDate = Value(startDate),
       status = Value(status);
  static Insertable<Goal> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? type,
    Expression<String>? name,
    Expression<double>? targetValue,
    Expression<String>? unit,
    Expression<DateTime>? startDate,
    Expression<DateTime>? targetDate,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (type != null) 'type': type,
      if (name != null) 'name': name,
      if (targetValue != null) 'target_value': targetValue,
      if (unit != null) 'unit': unit,
      if (startDate != null) 'start_date': startDate,
      if (targetDate != null) 'target_date': targetDate,
      if (status != null) 'status': status,
    });
  }

  GoalsCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<String>? type,
    Value<String>? name,
    Value<double>? targetValue,
    Value<String>? unit,
    Value<DateTime>? startDate,
    Value<DateTime?>? targetDate,
    Value<String>? status,
  }) {
    return GoalsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      name: name ?? this.name,
      targetValue: targetValue ?? this.targetValue,
      unit: unit ?? this.unit,
      startDate: startDate ?? this.startDate,
      targetDate: targetDate ?? this.targetDate,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (targetValue.present) {
      map['target_value'] = Variable<double>(targetValue.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (targetDate.present) {
      map['target_date'] = Variable<DateTime>(targetDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('targetValue: $targetValue, ')
          ..write('unit: $unit, ')
          ..write('startDate: $startDate, ')
          ..write('targetDate: $targetDate, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $EquipmentTable extends Equipment
    with TableInfo<$EquipmentTable, EquipmentData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EquipmentTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
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
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [id, code, name, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'equipment';
  @override
  VerificationContext validateIntegrity(
    Insertable<EquipmentData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EquipmentData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EquipmentData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $EquipmentTable createAlias(String alias) {
    return $EquipmentTable(attachedDatabase, alias);
  }
}

class EquipmentData extends DataClass implements Insertable<EquipmentData> {
  final int id;
  final String code;
  final String name;
  final bool isActive;
  const EquipmentData({
    required this.id,
    required this.code,
    required this.name,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  EquipmentCompanion toCompanion(bool nullToAbsent) {
    return EquipmentCompanion(
      id: Value(id),
      code: Value(code),
      name: Value(name),
      isActive: Value(isActive),
    );
  }

  factory EquipmentData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EquipmentData(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  EquipmentData copyWith({
    int? id,
    String? code,
    String? name,
    bool? isActive,
  }) => EquipmentData(
    id: id ?? this.id,
    code: code ?? this.code,
    name: name ?? this.name,
    isActive: isActive ?? this.isActive,
  );
  EquipmentData copyWithCompanion(EquipmentCompanion data) {
    return EquipmentData(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EquipmentData(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, code, name, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EquipmentData &&
          other.id == this.id &&
          other.code == this.code &&
          other.name == this.name &&
          other.isActive == this.isActive);
}

class EquipmentCompanion extends UpdateCompanion<EquipmentData> {
  final Value<int> id;
  final Value<String> code;
  final Value<String> name;
  final Value<bool> isActive;
  const EquipmentCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  EquipmentCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    required String name,
    this.isActive = const Value.absent(),
  }) : code = Value(code),
       name = Value(name);
  static Insertable<EquipmentData> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? name,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (isActive != null) 'is_active': isActive,
    });
  }

  EquipmentCompanion copyWith({
    Value<int>? id,
    Value<String>? code,
    Value<String>? name,
    Value<bool>? isActive,
  }) {
    return EquipmentCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EquipmentCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $ExercisesTable extends Exercises
    with TableInfo<$ExercisesTable, Exercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
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
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _primaryMuscleMeta = const VerificationMeta(
    'primaryMuscle',
  );
  @override
  late final GeneratedColumn<String> primaryMuscle = GeneratedColumn<String>(
    'primary_muscle',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _movementPatternMeta = const VerificationMeta(
    'movementPattern',
  );
  @override
  late final GeneratedColumn<String> movementPattern = GeneratedColumn<String>(
    'movement_pattern',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseTypeMeta = const VerificationMeta(
    'exerciseType',
  );
  @override
  late final GeneratedColumn<String> exerciseType = GeneratedColumn<String>(
    'exercise_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _techniqueMeta = const VerificationMeta(
    'technique',
  );
  @override
  late final GeneratedColumn<String> technique = GeneratedColumn<String>(
    'technique',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _commonMistakesMeta = const VerificationMeta(
    'commonMistakes',
  );
  @override
  late final GeneratedColumn<String> commonMistakes = GeneratedColumn<String>(
    'common_mistakes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _considerationsMeta = const VerificationMeta(
    'considerations',
  );
  @override
  late final GeneratedColumn<String> considerations = GeneratedColumn<String>(
    'considerations',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _instructionsMeta = const VerificationMeta(
    'instructions',
  );
  @override
  late final GeneratedColumn<String> instructions = GeneratedColumn<String>(
    'instructions',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    primaryMuscle,
    difficulty,
    movementPattern,
    exerciseType,
    technique,
    commonMistakes,
    considerations,
    instructions,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<Exercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('primary_muscle')) {
      context.handle(
        _primaryMuscleMeta,
        primaryMuscle.isAcceptableOrUnknown(
          data['primary_muscle']!,
          _primaryMuscleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_primaryMuscleMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    } else if (isInserting) {
      context.missing(_difficultyMeta);
    }
    if (data.containsKey('movement_pattern')) {
      context.handle(
        _movementPatternMeta,
        movementPattern.isAcceptableOrUnknown(
          data['movement_pattern']!,
          _movementPatternMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_movementPatternMeta);
    }
    if (data.containsKey('exercise_type')) {
      context.handle(
        _exerciseTypeMeta,
        exerciseType.isAcceptableOrUnknown(
          data['exercise_type']!,
          _exerciseTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseTypeMeta);
    }
    if (data.containsKey('technique')) {
      context.handle(
        _techniqueMeta,
        technique.isAcceptableOrUnknown(data['technique']!, _techniqueMeta),
      );
    } else if (isInserting) {
      context.missing(_techniqueMeta);
    }
    if (data.containsKey('common_mistakes')) {
      context.handle(
        _commonMistakesMeta,
        commonMistakes.isAcceptableOrUnknown(
          data['common_mistakes']!,
          _commonMistakesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_commonMistakesMeta);
    }
    if (data.containsKey('considerations')) {
      context.handle(
        _considerationsMeta,
        considerations.isAcceptableOrUnknown(
          data['considerations']!,
          _considerationsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_considerationsMeta);
    }
    if (data.containsKey('instructions')) {
      context.handle(
        _instructionsMeta,
        instructions.isAcceptableOrUnknown(
          data['instructions']!,
          _instructionsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_instructionsMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Exercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Exercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      primaryMuscle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_muscle'],
      )!,
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}difficulty'],
      )!,
      movementPattern: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}movement_pattern'],
      )!,
      exerciseType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_type'],
      )!,
      technique: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}technique'],
      )!,
      commonMistakes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}common_mistakes'],
      )!,
      considerations: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}considerations'],
      )!,
      instructions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instructions'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $ExercisesTable createAlias(String alias) {
    return $ExercisesTable(attachedDatabase, alias);
  }
}

class Exercise extends DataClass implements Insertable<Exercise> {
  final int id;
  final String name;
  final String description;
  final String primaryMuscle;
  final String difficulty;
  final String movementPattern;
  final String exerciseType;
  final String technique;
  final String commonMistakes;
  final String considerations;
  final String instructions;
  final bool isActive;
  const Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.primaryMuscle,
    required this.difficulty,
    required this.movementPattern,
    required this.exerciseType,
    required this.technique,
    required this.commonMistakes,
    required this.considerations,
    required this.instructions,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['primary_muscle'] = Variable<String>(primaryMuscle);
    map['difficulty'] = Variable<String>(difficulty);
    map['movement_pattern'] = Variable<String>(movementPattern);
    map['exercise_type'] = Variable<String>(exerciseType);
    map['technique'] = Variable<String>(technique);
    map['common_mistakes'] = Variable<String>(commonMistakes);
    map['considerations'] = Variable<String>(considerations);
    map['instructions'] = Variable<String>(instructions);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  ExercisesCompanion toCompanion(bool nullToAbsent) {
    return ExercisesCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      primaryMuscle: Value(primaryMuscle),
      difficulty: Value(difficulty),
      movementPattern: Value(movementPattern),
      exerciseType: Value(exerciseType),
      technique: Value(technique),
      commonMistakes: Value(commonMistakes),
      considerations: Value(considerations),
      instructions: Value(instructions),
      isActive: Value(isActive),
    );
  }

  factory Exercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Exercise(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      primaryMuscle: serializer.fromJson<String>(json['primaryMuscle']),
      difficulty: serializer.fromJson<String>(json['difficulty']),
      movementPattern: serializer.fromJson<String>(json['movementPattern']),
      exerciseType: serializer.fromJson<String>(json['exerciseType']),
      technique: serializer.fromJson<String>(json['technique']),
      commonMistakes: serializer.fromJson<String>(json['commonMistakes']),
      considerations: serializer.fromJson<String>(json['considerations']),
      instructions: serializer.fromJson<String>(json['instructions']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'primaryMuscle': serializer.toJson<String>(primaryMuscle),
      'difficulty': serializer.toJson<String>(difficulty),
      'movementPattern': serializer.toJson<String>(movementPattern),
      'exerciseType': serializer.toJson<String>(exerciseType),
      'technique': serializer.toJson<String>(technique),
      'commonMistakes': serializer.toJson<String>(commonMistakes),
      'considerations': serializer.toJson<String>(considerations),
      'instructions': serializer.toJson<String>(instructions),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Exercise copyWith({
    int? id,
    String? name,
    String? description,
    String? primaryMuscle,
    String? difficulty,
    String? movementPattern,
    String? exerciseType,
    String? technique,
    String? commonMistakes,
    String? considerations,
    String? instructions,
    bool? isActive,
  }) => Exercise(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    primaryMuscle: primaryMuscle ?? this.primaryMuscle,
    difficulty: difficulty ?? this.difficulty,
    movementPattern: movementPattern ?? this.movementPattern,
    exerciseType: exerciseType ?? this.exerciseType,
    technique: technique ?? this.technique,
    commonMistakes: commonMistakes ?? this.commonMistakes,
    considerations: considerations ?? this.considerations,
    instructions: instructions ?? this.instructions,
    isActive: isActive ?? this.isActive,
  );
  Exercise copyWithCompanion(ExercisesCompanion data) {
    return Exercise(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      primaryMuscle: data.primaryMuscle.present
          ? data.primaryMuscle.value
          : this.primaryMuscle,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      movementPattern: data.movementPattern.present
          ? data.movementPattern.value
          : this.movementPattern,
      exerciseType: data.exerciseType.present
          ? data.exerciseType.value
          : this.exerciseType,
      technique: data.technique.present ? data.technique.value : this.technique,
      commonMistakes: data.commonMistakes.present
          ? data.commonMistakes.value
          : this.commonMistakes,
      considerations: data.considerations.present
          ? data.considerations.value
          : this.considerations,
      instructions: data.instructions.present
          ? data.instructions.value
          : this.instructions,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Exercise(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('primaryMuscle: $primaryMuscle, ')
          ..write('difficulty: $difficulty, ')
          ..write('movementPattern: $movementPattern, ')
          ..write('exerciseType: $exerciseType, ')
          ..write('technique: $technique, ')
          ..write('commonMistakes: $commonMistakes, ')
          ..write('considerations: $considerations, ')
          ..write('instructions: $instructions, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    primaryMuscle,
    difficulty,
    movementPattern,
    exerciseType,
    technique,
    commonMistakes,
    considerations,
    instructions,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Exercise &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.primaryMuscle == this.primaryMuscle &&
          other.difficulty == this.difficulty &&
          other.movementPattern == this.movementPattern &&
          other.exerciseType == this.exerciseType &&
          other.technique == this.technique &&
          other.commonMistakes == this.commonMistakes &&
          other.considerations == this.considerations &&
          other.instructions == this.instructions &&
          other.isActive == this.isActive);
}

class ExercisesCompanion extends UpdateCompanion<Exercise> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> description;
  final Value<String> primaryMuscle;
  final Value<String> difficulty;
  final Value<String> movementPattern;
  final Value<String> exerciseType;
  final Value<String> technique;
  final Value<String> commonMistakes;
  final Value<String> considerations;
  final Value<String> instructions;
  final Value<bool> isActive;
  const ExercisesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.primaryMuscle = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.movementPattern = const Value.absent(),
    this.exerciseType = const Value.absent(),
    this.technique = const Value.absent(),
    this.commonMistakes = const Value.absent(),
    this.considerations = const Value.absent(),
    this.instructions = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  ExercisesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String description,
    required String primaryMuscle,
    required String difficulty,
    required String movementPattern,
    required String exerciseType,
    required String technique,
    required String commonMistakes,
    required String considerations,
    required String instructions,
    this.isActive = const Value.absent(),
  }) : name = Value(name),
       description = Value(description),
       primaryMuscle = Value(primaryMuscle),
       difficulty = Value(difficulty),
       movementPattern = Value(movementPattern),
       exerciseType = Value(exerciseType),
       technique = Value(technique),
       commonMistakes = Value(commonMistakes),
       considerations = Value(considerations),
       instructions = Value(instructions);
  static Insertable<Exercise> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? primaryMuscle,
    Expression<String>? difficulty,
    Expression<String>? movementPattern,
    Expression<String>? exerciseType,
    Expression<String>? technique,
    Expression<String>? commonMistakes,
    Expression<String>? considerations,
    Expression<String>? instructions,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (primaryMuscle != null) 'primary_muscle': primaryMuscle,
      if (difficulty != null) 'difficulty': difficulty,
      if (movementPattern != null) 'movement_pattern': movementPattern,
      if (exerciseType != null) 'exercise_type': exerciseType,
      if (technique != null) 'technique': technique,
      if (commonMistakes != null) 'common_mistakes': commonMistakes,
      if (considerations != null) 'considerations': considerations,
      if (instructions != null) 'instructions': instructions,
      if (isActive != null) 'is_active': isActive,
    });
  }

  ExercisesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? description,
    Value<String>? primaryMuscle,
    Value<String>? difficulty,
    Value<String>? movementPattern,
    Value<String>? exerciseType,
    Value<String>? technique,
    Value<String>? commonMistakes,
    Value<String>? considerations,
    Value<String>? instructions,
    Value<bool>? isActive,
  }) {
    return ExercisesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      primaryMuscle: primaryMuscle ?? this.primaryMuscle,
      difficulty: difficulty ?? this.difficulty,
      movementPattern: movementPattern ?? this.movementPattern,
      exerciseType: exerciseType ?? this.exerciseType,
      technique: technique ?? this.technique,
      commonMistakes: commonMistakes ?? this.commonMistakes,
      considerations: considerations ?? this.considerations,
      instructions: instructions ?? this.instructions,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (primaryMuscle.present) {
      map['primary_muscle'] = Variable<String>(primaryMuscle.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    if (movementPattern.present) {
      map['movement_pattern'] = Variable<String>(movementPattern.value);
    }
    if (exerciseType.present) {
      map['exercise_type'] = Variable<String>(exerciseType.value);
    }
    if (technique.present) {
      map['technique'] = Variable<String>(technique.value);
    }
    if (commonMistakes.present) {
      map['common_mistakes'] = Variable<String>(commonMistakes.value);
    }
    if (considerations.present) {
      map['considerations'] = Variable<String>(considerations.value);
    }
    if (instructions.present) {
      map['instructions'] = Variable<String>(instructions.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('primaryMuscle: $primaryMuscle, ')
          ..write('difficulty: $difficulty, ')
          ..write('movementPattern: $movementPattern, ')
          ..write('exerciseType: $exerciseType, ')
          ..write('technique: $technique, ')
          ..write('commonMistakes: $commonMistakes, ')
          ..write('considerations: $considerations, ')
          ..write('instructions: $instructions, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $ExerciseEquipmentTable extends ExerciseEquipment
    with TableInfo<$ExerciseEquipmentTable, ExerciseEquipmentData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExerciseEquipmentTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<int> exerciseId = GeneratedColumn<int>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercises (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _equipmentIdMeta = const VerificationMeta(
    'equipmentId',
  );
  @override
  late final GeneratedColumn<int> equipmentId = GeneratedColumn<int>(
    'equipment_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES equipment (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, exerciseId, equipmentId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercise_equipment';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExerciseEquipmentData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('equipment_id')) {
      context.handle(
        _equipmentIdMeta,
        equipmentId.isAcceptableOrUnknown(
          data['equipment_id']!,
          _equipmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_equipmentIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {exerciseId, equipmentId},
  ];
  @override
  ExerciseEquipmentData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseEquipmentData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercise_id'],
      )!,
      equipmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}equipment_id'],
      )!,
    );
  }

  @override
  $ExerciseEquipmentTable createAlias(String alias) {
    return $ExerciseEquipmentTable(attachedDatabase, alias);
  }
}

class ExerciseEquipmentData extends DataClass
    implements Insertable<ExerciseEquipmentData> {
  final int id;
  final int exerciseId;
  final int equipmentId;
  const ExerciseEquipmentData({
    required this.id,
    required this.exerciseId,
    required this.equipmentId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['exercise_id'] = Variable<int>(exerciseId);
    map['equipment_id'] = Variable<int>(equipmentId);
    return map;
  }

  ExerciseEquipmentCompanion toCompanion(bool nullToAbsent) {
    return ExerciseEquipmentCompanion(
      id: Value(id),
      exerciseId: Value(exerciseId),
      equipmentId: Value(equipmentId),
    );
  }

  factory ExerciseEquipmentData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseEquipmentData(
      id: serializer.fromJson<int>(json['id']),
      exerciseId: serializer.fromJson<int>(json['exerciseId']),
      equipmentId: serializer.fromJson<int>(json['equipmentId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'exerciseId': serializer.toJson<int>(exerciseId),
      'equipmentId': serializer.toJson<int>(equipmentId),
    };
  }

  ExerciseEquipmentData copyWith({
    int? id,
    int? exerciseId,
    int? equipmentId,
  }) => ExerciseEquipmentData(
    id: id ?? this.id,
    exerciseId: exerciseId ?? this.exerciseId,
    equipmentId: equipmentId ?? this.equipmentId,
  );
  ExerciseEquipmentData copyWithCompanion(ExerciseEquipmentCompanion data) {
    return ExerciseEquipmentData(
      id: data.id.present ? data.id.value : this.id,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      equipmentId: data.equipmentId.present
          ? data.equipmentId.value
          : this.equipmentId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseEquipmentData(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('equipmentId: $equipmentId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, exerciseId, equipmentId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseEquipmentData &&
          other.id == this.id &&
          other.exerciseId == this.exerciseId &&
          other.equipmentId == this.equipmentId);
}

class ExerciseEquipmentCompanion
    extends UpdateCompanion<ExerciseEquipmentData> {
  final Value<int> id;
  final Value<int> exerciseId;
  final Value<int> equipmentId;
  const ExerciseEquipmentCompanion({
    this.id = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.equipmentId = const Value.absent(),
  });
  ExerciseEquipmentCompanion.insert({
    this.id = const Value.absent(),
    required int exerciseId,
    required int equipmentId,
  }) : exerciseId = Value(exerciseId),
       equipmentId = Value(equipmentId);
  static Insertable<ExerciseEquipmentData> custom({
    Expression<int>? id,
    Expression<int>? exerciseId,
    Expression<int>? equipmentId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (equipmentId != null) 'equipment_id': equipmentId,
    });
  }

  ExerciseEquipmentCompanion copyWith({
    Value<int>? id,
    Value<int>? exerciseId,
    Value<int>? equipmentId,
  }) {
    return ExerciseEquipmentCompanion(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      equipmentId: equipmentId ?? this.equipmentId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<int>(exerciseId.value);
    }
    if (equipmentId.present) {
      map['equipment_id'] = Variable<int>(equipmentId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseEquipmentCompanion(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('equipmentId: $equipmentId')
          ..write(')'))
        .toString();
  }
}

class $ExerciseRelationshipsTable extends ExerciseRelationships
    with TableInfo<$ExerciseRelationshipsTable, ExerciseRelationship> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExerciseRelationshipsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<int> exerciseId = GeneratedColumn<int>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercises (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _relatedExerciseIdMeta = const VerificationMeta(
    'relatedExerciseId',
  );
  @override
  late final GeneratedColumn<int> relatedExerciseId = GeneratedColumn<int>(
    'related_exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercises (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _relationshipTypeMeta = const VerificationMeta(
    'relationshipType',
  );
  @override
  late final GeneratedColumn<String> relationshipType = GeneratedColumn<String>(
    'relationship_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    exerciseId,
    relatedExerciseId,
    relationshipType,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercise_relationships';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExerciseRelationship> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('related_exercise_id')) {
      context.handle(
        _relatedExerciseIdMeta,
        relatedExerciseId.isAcceptableOrUnknown(
          data['related_exercise_id']!,
          _relatedExerciseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_relatedExerciseIdMeta);
    }
    if (data.containsKey('relationship_type')) {
      context.handle(
        _relationshipTypeMeta,
        relationshipType.isAcceptableOrUnknown(
          data['relationship_type']!,
          _relationshipTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_relationshipTypeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {exerciseId, relatedExerciseId, relationshipType},
  ];
  @override
  ExerciseRelationship map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseRelationship(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercise_id'],
      )!,
      relatedExerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}related_exercise_id'],
      )!,
      relationshipType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relationship_type'],
      )!,
    );
  }

  @override
  $ExerciseRelationshipsTable createAlias(String alias) {
    return $ExerciseRelationshipsTable(attachedDatabase, alias);
  }
}

class ExerciseRelationship extends DataClass
    implements Insertable<ExerciseRelationship> {
  final int id;
  final int exerciseId;
  final int relatedExerciseId;
  final String relationshipType;
  const ExerciseRelationship({
    required this.id,
    required this.exerciseId,
    required this.relatedExerciseId,
    required this.relationshipType,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['exercise_id'] = Variable<int>(exerciseId);
    map['related_exercise_id'] = Variable<int>(relatedExerciseId);
    map['relationship_type'] = Variable<String>(relationshipType);
    return map;
  }

  ExerciseRelationshipsCompanion toCompanion(bool nullToAbsent) {
    return ExerciseRelationshipsCompanion(
      id: Value(id),
      exerciseId: Value(exerciseId),
      relatedExerciseId: Value(relatedExerciseId),
      relationshipType: Value(relationshipType),
    );
  }

  factory ExerciseRelationship.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseRelationship(
      id: serializer.fromJson<int>(json['id']),
      exerciseId: serializer.fromJson<int>(json['exerciseId']),
      relatedExerciseId: serializer.fromJson<int>(json['relatedExerciseId']),
      relationshipType: serializer.fromJson<String>(json['relationshipType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'exerciseId': serializer.toJson<int>(exerciseId),
      'relatedExerciseId': serializer.toJson<int>(relatedExerciseId),
      'relationshipType': serializer.toJson<String>(relationshipType),
    };
  }

  ExerciseRelationship copyWith({
    int? id,
    int? exerciseId,
    int? relatedExerciseId,
    String? relationshipType,
  }) => ExerciseRelationship(
    id: id ?? this.id,
    exerciseId: exerciseId ?? this.exerciseId,
    relatedExerciseId: relatedExerciseId ?? this.relatedExerciseId,
    relationshipType: relationshipType ?? this.relationshipType,
  );
  ExerciseRelationship copyWithCompanion(ExerciseRelationshipsCompanion data) {
    return ExerciseRelationship(
      id: data.id.present ? data.id.value : this.id,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      relatedExerciseId: data.relatedExerciseId.present
          ? data.relatedExerciseId.value
          : this.relatedExerciseId,
      relationshipType: data.relationshipType.present
          ? data.relationshipType.value
          : this.relationshipType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseRelationship(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('relatedExerciseId: $relatedExerciseId, ')
          ..write('relationshipType: $relationshipType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, exerciseId, relatedExerciseId, relationshipType);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseRelationship &&
          other.id == this.id &&
          other.exerciseId == this.exerciseId &&
          other.relatedExerciseId == this.relatedExerciseId &&
          other.relationshipType == this.relationshipType);
}

class ExerciseRelationshipsCompanion
    extends UpdateCompanion<ExerciseRelationship> {
  final Value<int> id;
  final Value<int> exerciseId;
  final Value<int> relatedExerciseId;
  final Value<String> relationshipType;
  const ExerciseRelationshipsCompanion({
    this.id = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.relatedExerciseId = const Value.absent(),
    this.relationshipType = const Value.absent(),
  });
  ExerciseRelationshipsCompanion.insert({
    this.id = const Value.absent(),
    required int exerciseId,
    required int relatedExerciseId,
    required String relationshipType,
  }) : exerciseId = Value(exerciseId),
       relatedExerciseId = Value(relatedExerciseId),
       relationshipType = Value(relationshipType);
  static Insertable<ExerciseRelationship> custom({
    Expression<int>? id,
    Expression<int>? exerciseId,
    Expression<int>? relatedExerciseId,
    Expression<String>? relationshipType,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (relatedExerciseId != null) 'related_exercise_id': relatedExerciseId,
      if (relationshipType != null) 'relationship_type': relationshipType,
    });
  }

  ExerciseRelationshipsCompanion copyWith({
    Value<int>? id,
    Value<int>? exerciseId,
    Value<int>? relatedExerciseId,
    Value<String>? relationshipType,
  }) {
    return ExerciseRelationshipsCompanion(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      relatedExerciseId: relatedExerciseId ?? this.relatedExerciseId,
      relationshipType: relationshipType ?? this.relationshipType,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<int>(exerciseId.value);
    }
    if (relatedExerciseId.present) {
      map['related_exercise_id'] = Variable<int>(relatedExerciseId.value);
    }
    if (relationshipType.present) {
      map['relationship_type'] = Variable<String>(relationshipType.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseRelationshipsCompanion(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('relatedExerciseId: $relatedExerciseId, ')
          ..write('relationshipType: $relationshipType')
          ..write(')'))
        .toString();
  }
}

class $WorkoutsTable extends Workouts with TableInfo<$WorkoutsTable, Workout> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id) ON DELETE CASCADE',
    ),
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
  static const VerificationMeta _goalMeta = const VerificationMeta('goal');
  @override
  late final GeneratedColumn<String> goal = GeneratedColumn<String>(
    'goal',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _daysPerWeekMeta = const VerificationMeta(
    'daysPerWeek',
  );
  @override
  late final GeneratedColumn<int> daysPerWeek = GeneratedColumn<int>(
    'days_per_week',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estimatedDurationMinutesMeta =
      const VerificationMeta('estimatedDurationMinutes');
  @override
  late final GeneratedColumn<int> estimatedDurationMinutes =
      GeneratedColumn<int>(
        'estimated_duration_minutes',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    name,
    goal,
    difficulty,
    daysPerWeek,
    estimatedDurationMinutes,
    isActive,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workouts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Workout> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('goal')) {
      context.handle(
        _goalMeta,
        goal.isAcceptableOrUnknown(data['goal']!, _goalMeta),
      );
    } else if (isInserting) {
      context.missing(_goalMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    } else if (isInserting) {
      context.missing(_difficultyMeta);
    }
    if (data.containsKey('days_per_week')) {
      context.handle(
        _daysPerWeekMeta,
        daysPerWeek.isAcceptableOrUnknown(
          data['days_per_week']!,
          _daysPerWeekMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_daysPerWeekMeta);
    }
    if (data.containsKey('estimated_duration_minutes')) {
      context.handle(
        _estimatedDurationMinutesMeta,
        estimatedDurationMinutes.isAcceptableOrUnknown(
          data['estimated_duration_minutes']!,
          _estimatedDurationMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_estimatedDurationMinutesMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Workout map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Workout(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      goal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal'],
      )!,
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}difficulty'],
      )!,
      daysPerWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}days_per_week'],
      )!,
      estimatedDurationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_duration_minutes'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WorkoutsTable createAlias(String alias) {
    return $WorkoutsTable(attachedDatabase, alias);
  }
}

class Workout extends DataClass implements Insertable<Workout> {
  final int id;
  final int userId;
  final String name;
  final String goal;
  final String difficulty;
  final int daysPerWeek;
  final int estimatedDurationMinutes;
  final bool isActive;
  final DateTime createdAt;
  const Workout({
    required this.id,
    required this.userId,
    required this.name,
    required this.goal,
    required this.difficulty,
    required this.daysPerWeek,
    required this.estimatedDurationMinutes,
    required this.isActive,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['name'] = Variable<String>(name);
    map['goal'] = Variable<String>(goal);
    map['difficulty'] = Variable<String>(difficulty);
    map['days_per_week'] = Variable<int>(daysPerWeek);
    map['estimated_duration_minutes'] = Variable<int>(estimatedDurationMinutes);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  WorkoutsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutsCompanion(
      id: Value(id),
      userId: Value(userId),
      name: Value(name),
      goal: Value(goal),
      difficulty: Value(difficulty),
      daysPerWeek: Value(daysPerWeek),
      estimatedDurationMinutes: Value(estimatedDurationMinutes),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory Workout.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Workout(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      goal: serializer.fromJson<String>(json['goal']),
      difficulty: serializer.fromJson<String>(json['difficulty']),
      daysPerWeek: serializer.fromJson<int>(json['daysPerWeek']),
      estimatedDurationMinutes: serializer.fromJson<int>(
        json['estimatedDurationMinutes'],
      ),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'name': serializer.toJson<String>(name),
      'goal': serializer.toJson<String>(goal),
      'difficulty': serializer.toJson<String>(difficulty),
      'daysPerWeek': serializer.toJson<int>(daysPerWeek),
      'estimatedDurationMinutes': serializer.toJson<int>(
        estimatedDurationMinutes,
      ),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Workout copyWith({
    int? id,
    int? userId,
    String? name,
    String? goal,
    String? difficulty,
    int? daysPerWeek,
    int? estimatedDurationMinutes,
    bool? isActive,
    DateTime? createdAt,
  }) => Workout(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    name: name ?? this.name,
    goal: goal ?? this.goal,
    difficulty: difficulty ?? this.difficulty,
    daysPerWeek: daysPerWeek ?? this.daysPerWeek,
    estimatedDurationMinutes:
        estimatedDurationMinutes ?? this.estimatedDurationMinutes,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );
  Workout copyWithCompanion(WorkoutsCompanion data) {
    return Workout(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      goal: data.goal.present ? data.goal.value : this.goal,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      daysPerWeek: data.daysPerWeek.present
          ? data.daysPerWeek.value
          : this.daysPerWeek,
      estimatedDurationMinutes: data.estimatedDurationMinutes.present
          ? data.estimatedDurationMinutes.value
          : this.estimatedDurationMinutes,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Workout(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('goal: $goal, ')
          ..write('difficulty: $difficulty, ')
          ..write('daysPerWeek: $daysPerWeek, ')
          ..write('estimatedDurationMinutes: $estimatedDurationMinutes, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    name,
    goal,
    difficulty,
    daysPerWeek,
    estimatedDurationMinutes,
    isActive,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Workout &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.goal == this.goal &&
          other.difficulty == this.difficulty &&
          other.daysPerWeek == this.daysPerWeek &&
          other.estimatedDurationMinutes == this.estimatedDurationMinutes &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class WorkoutsCompanion extends UpdateCompanion<Workout> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> name;
  final Value<String> goal;
  final Value<String> difficulty;
  final Value<int> daysPerWeek;
  final Value<int> estimatedDurationMinutes;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  const WorkoutsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.goal = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.daysPerWeek = const Value.absent(),
    this.estimatedDurationMinutes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  WorkoutsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required String name,
    required String goal,
    required String difficulty,
    required int daysPerWeek,
    required int estimatedDurationMinutes,
    this.isActive = const Value.absent(),
    required DateTime createdAt,
  }) : userId = Value(userId),
       name = Value(name),
       goal = Value(goal),
       difficulty = Value(difficulty),
       daysPerWeek = Value(daysPerWeek),
       estimatedDurationMinutes = Value(estimatedDurationMinutes),
       createdAt = Value(createdAt);
  static Insertable<Workout> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? name,
    Expression<String>? goal,
    Expression<String>? difficulty,
    Expression<int>? daysPerWeek,
    Expression<int>? estimatedDurationMinutes,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (goal != null) 'goal': goal,
      if (difficulty != null) 'difficulty': difficulty,
      if (daysPerWeek != null) 'days_per_week': daysPerWeek,
      if (estimatedDurationMinutes != null)
        'estimated_duration_minutes': estimatedDurationMinutes,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  WorkoutsCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<String>? name,
    Value<String>? goal,
    Value<String>? difficulty,
    Value<int>? daysPerWeek,
    Value<int>? estimatedDurationMinutes,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
  }) {
    return WorkoutsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      goal: goal ?? this.goal,
      difficulty: difficulty ?? this.difficulty,
      daysPerWeek: daysPerWeek ?? this.daysPerWeek,
      estimatedDurationMinutes:
          estimatedDurationMinutes ?? this.estimatedDurationMinutes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (goal.present) {
      map['goal'] = Variable<String>(goal.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    if (daysPerWeek.present) {
      map['days_per_week'] = Variable<int>(daysPerWeek.value);
    }
    if (estimatedDurationMinutes.present) {
      map['estimated_duration_minutes'] = Variable<int>(
        estimatedDurationMinutes.value,
      );
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('goal: $goal, ')
          ..write('difficulty: $difficulty, ')
          ..write('daysPerWeek: $daysPerWeek, ')
          ..write('estimatedDurationMinutes: $estimatedDurationMinutes, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $WorkoutExercisesTable extends WorkoutExercises
    with TableInfo<$WorkoutExercisesTable, WorkoutExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _workoutIdMeta = const VerificationMeta(
    'workoutId',
  );
  @override
  late final GeneratedColumn<int> workoutId = GeneratedColumn<int>(
    'workout_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workouts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<int> exerciseId = GeneratedColumn<int>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercises (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _setsMeta = const VerificationMeta('sets');
  @override
  late final GeneratedColumn<int> sets = GeneratedColumn<int>(
    'sets',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minRepsMeta = const VerificationMeta(
    'minReps',
  );
  @override
  late final GeneratedColumn<int> minReps = GeneratedColumn<int>(
    'min_reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maxRepsMeta = const VerificationMeta(
    'maxReps',
  );
  @override
  late final GeneratedColumn<int> maxReps = GeneratedColumn<int>(
    'max_reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _restSecondsMeta = const VerificationMeta(
    'restSeconds',
  );
  @override
  late final GeneratedColumn<int> restSeconds = GeneratedColumn<int>(
    'rest_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _setTypeMeta = const VerificationMeta(
    'setType',
  );
  @override
  late final GeneratedColumn<String> setType = GeneratedColumn<String>(
    'set_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workoutId,
    exerciseId,
    orderIndex,
    sets,
    minReps,
    maxReps,
    restSeconds,
    setType,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutExercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('workout_id')) {
      context.handle(
        _workoutIdMeta,
        workoutId.isAcceptableOrUnknown(data['workout_id']!, _workoutIdMeta),
      );
    } else if (isInserting) {
      context.missing(_workoutIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('sets')) {
      context.handle(
        _setsMeta,
        sets.isAcceptableOrUnknown(data['sets']!, _setsMeta),
      );
    } else if (isInserting) {
      context.missing(_setsMeta);
    }
    if (data.containsKey('min_reps')) {
      context.handle(
        _minRepsMeta,
        minReps.isAcceptableOrUnknown(data['min_reps']!, _minRepsMeta),
      );
    } else if (isInserting) {
      context.missing(_minRepsMeta);
    }
    if (data.containsKey('max_reps')) {
      context.handle(
        _maxRepsMeta,
        maxReps.isAcceptableOrUnknown(data['max_reps']!, _maxRepsMeta),
      );
    } else if (isInserting) {
      context.missing(_maxRepsMeta);
    }
    if (data.containsKey('rest_seconds')) {
      context.handle(
        _restSecondsMeta,
        restSeconds.isAcceptableOrUnknown(
          data['rest_seconds']!,
          _restSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_restSecondsMeta);
    }
    if (data.containsKey('set_type')) {
      context.handle(
        _setTypeMeta,
        setType.isAcceptableOrUnknown(data['set_type']!, _setTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_setTypeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {workoutId, orderIndex},
  ];
  @override
  WorkoutExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutExercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      workoutId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}workout_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercise_id'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      sets: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sets'],
      )!,
      minReps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_reps'],
      )!,
      maxReps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_reps'],
      )!,
      restSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_seconds'],
      )!,
      setType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}set_type'],
      )!,
    );
  }

  @override
  $WorkoutExercisesTable createAlias(String alias) {
    return $WorkoutExercisesTable(attachedDatabase, alias);
  }
}

class WorkoutExercise extends DataClass implements Insertable<WorkoutExercise> {
  final int id;
  final int workoutId;
  final int exerciseId;
  final int orderIndex;
  final int sets;
  final int minReps;
  final int maxReps;
  final int restSeconds;
  final String setType;
  const WorkoutExercise({
    required this.id,
    required this.workoutId,
    required this.exerciseId,
    required this.orderIndex,
    required this.sets,
    required this.minReps,
    required this.maxReps,
    required this.restSeconds,
    required this.setType,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['workout_id'] = Variable<int>(workoutId);
    map['exercise_id'] = Variable<int>(exerciseId);
    map['order_index'] = Variable<int>(orderIndex);
    map['sets'] = Variable<int>(sets);
    map['min_reps'] = Variable<int>(minReps);
    map['max_reps'] = Variable<int>(maxReps);
    map['rest_seconds'] = Variable<int>(restSeconds);
    map['set_type'] = Variable<String>(setType);
    return map;
  }

  WorkoutExercisesCompanion toCompanion(bool nullToAbsent) {
    return WorkoutExercisesCompanion(
      id: Value(id),
      workoutId: Value(workoutId),
      exerciseId: Value(exerciseId),
      orderIndex: Value(orderIndex),
      sets: Value(sets),
      minReps: Value(minReps),
      maxReps: Value(maxReps),
      restSeconds: Value(restSeconds),
      setType: Value(setType),
    );
  }

  factory WorkoutExercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutExercise(
      id: serializer.fromJson<int>(json['id']),
      workoutId: serializer.fromJson<int>(json['workoutId']),
      exerciseId: serializer.fromJson<int>(json['exerciseId']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      sets: serializer.fromJson<int>(json['sets']),
      minReps: serializer.fromJson<int>(json['minReps']),
      maxReps: serializer.fromJson<int>(json['maxReps']),
      restSeconds: serializer.fromJson<int>(json['restSeconds']),
      setType: serializer.fromJson<String>(json['setType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'workoutId': serializer.toJson<int>(workoutId),
      'exerciseId': serializer.toJson<int>(exerciseId),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'sets': serializer.toJson<int>(sets),
      'minReps': serializer.toJson<int>(minReps),
      'maxReps': serializer.toJson<int>(maxReps),
      'restSeconds': serializer.toJson<int>(restSeconds),
      'setType': serializer.toJson<String>(setType),
    };
  }

  WorkoutExercise copyWith({
    int? id,
    int? workoutId,
    int? exerciseId,
    int? orderIndex,
    int? sets,
    int? minReps,
    int? maxReps,
    int? restSeconds,
    String? setType,
  }) => WorkoutExercise(
    id: id ?? this.id,
    workoutId: workoutId ?? this.workoutId,
    exerciseId: exerciseId ?? this.exerciseId,
    orderIndex: orderIndex ?? this.orderIndex,
    sets: sets ?? this.sets,
    minReps: minReps ?? this.minReps,
    maxReps: maxReps ?? this.maxReps,
    restSeconds: restSeconds ?? this.restSeconds,
    setType: setType ?? this.setType,
  );
  WorkoutExercise copyWithCompanion(WorkoutExercisesCompanion data) {
    return WorkoutExercise(
      id: data.id.present ? data.id.value : this.id,
      workoutId: data.workoutId.present ? data.workoutId.value : this.workoutId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      sets: data.sets.present ? data.sets.value : this.sets,
      minReps: data.minReps.present ? data.minReps.value : this.minReps,
      maxReps: data.maxReps.present ? data.maxReps.value : this.maxReps,
      restSeconds: data.restSeconds.present
          ? data.restSeconds.value
          : this.restSeconds,
      setType: data.setType.present ? data.setType.value : this.setType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutExercise(')
          ..write('id: $id, ')
          ..write('workoutId: $workoutId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('sets: $sets, ')
          ..write('minReps: $minReps, ')
          ..write('maxReps: $maxReps, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('setType: $setType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workoutId,
    exerciseId,
    orderIndex,
    sets,
    minReps,
    maxReps,
    restSeconds,
    setType,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutExercise &&
          other.id == this.id &&
          other.workoutId == this.workoutId &&
          other.exerciseId == this.exerciseId &&
          other.orderIndex == this.orderIndex &&
          other.sets == this.sets &&
          other.minReps == this.minReps &&
          other.maxReps == this.maxReps &&
          other.restSeconds == this.restSeconds &&
          other.setType == this.setType);
}

class WorkoutExercisesCompanion extends UpdateCompanion<WorkoutExercise> {
  final Value<int> id;
  final Value<int> workoutId;
  final Value<int> exerciseId;
  final Value<int> orderIndex;
  final Value<int> sets;
  final Value<int> minReps;
  final Value<int> maxReps;
  final Value<int> restSeconds;
  final Value<String> setType;
  const WorkoutExercisesCompanion({
    this.id = const Value.absent(),
    this.workoutId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.sets = const Value.absent(),
    this.minReps = const Value.absent(),
    this.maxReps = const Value.absent(),
    this.restSeconds = const Value.absent(),
    this.setType = const Value.absent(),
  });
  WorkoutExercisesCompanion.insert({
    this.id = const Value.absent(),
    required int workoutId,
    required int exerciseId,
    required int orderIndex,
    required int sets,
    required int minReps,
    required int maxReps,
    required int restSeconds,
    required String setType,
  }) : workoutId = Value(workoutId),
       exerciseId = Value(exerciseId),
       orderIndex = Value(orderIndex),
       sets = Value(sets),
       minReps = Value(minReps),
       maxReps = Value(maxReps),
       restSeconds = Value(restSeconds),
       setType = Value(setType);
  static Insertable<WorkoutExercise> custom({
    Expression<int>? id,
    Expression<int>? workoutId,
    Expression<int>? exerciseId,
    Expression<int>? orderIndex,
    Expression<int>? sets,
    Expression<int>? minReps,
    Expression<int>? maxReps,
    Expression<int>? restSeconds,
    Expression<String>? setType,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workoutId != null) 'workout_id': workoutId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (orderIndex != null) 'order_index': orderIndex,
      if (sets != null) 'sets': sets,
      if (minReps != null) 'min_reps': minReps,
      if (maxReps != null) 'max_reps': maxReps,
      if (restSeconds != null) 'rest_seconds': restSeconds,
      if (setType != null) 'set_type': setType,
    });
  }

  WorkoutExercisesCompanion copyWith({
    Value<int>? id,
    Value<int>? workoutId,
    Value<int>? exerciseId,
    Value<int>? orderIndex,
    Value<int>? sets,
    Value<int>? minReps,
    Value<int>? maxReps,
    Value<int>? restSeconds,
    Value<String>? setType,
  }) {
    return WorkoutExercisesCompanion(
      id: id ?? this.id,
      workoutId: workoutId ?? this.workoutId,
      exerciseId: exerciseId ?? this.exerciseId,
      orderIndex: orderIndex ?? this.orderIndex,
      sets: sets ?? this.sets,
      minReps: minReps ?? this.minReps,
      maxReps: maxReps ?? this.maxReps,
      restSeconds: restSeconds ?? this.restSeconds,
      setType: setType ?? this.setType,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (workoutId.present) {
      map['workout_id'] = Variable<int>(workoutId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<int>(exerciseId.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (sets.present) {
      map['sets'] = Variable<int>(sets.value);
    }
    if (minReps.present) {
      map['min_reps'] = Variable<int>(minReps.value);
    }
    if (maxReps.present) {
      map['max_reps'] = Variable<int>(maxReps.value);
    }
    if (restSeconds.present) {
      map['rest_seconds'] = Variable<int>(restSeconds.value);
    }
    if (setType.present) {
      map['set_type'] = Variable<String>(setType.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutExercisesCompanion(')
          ..write('id: $id, ')
          ..write('workoutId: $workoutId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('sets: $sets, ')
          ..write('minReps: $minReps, ')
          ..write('maxReps: $maxReps, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('setType: $setType')
          ..write(')'))
        .toString();
  }
}

class $SessionsTable extends Sessions with TableInfo<$SessionsTable, Session> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _workoutIdMeta = const VerificationMeta(
    'workoutId',
  );
  @override
  late final GeneratedColumn<int> workoutId = GeneratedColumn<int>(
    'workout_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workouts (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    workoutId,
    startedAt,
    completedAt,
    durationSeconds,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Session> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('workout_id')) {
      context.handle(
        _workoutIdMeta,
        workoutId.isAcceptableOrUnknown(data['workout_id']!, _workoutIdMeta),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Session(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      workoutId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}workout_id'],
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class Session extends DataClass implements Insertable<Session> {
  final int id;
  final int userId;
  final int? workoutId;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int? durationSeconds;
  final String status;
  const Session({
    required this.id,
    required this.userId,
    this.workoutId,
    required this.startedAt,
    this.completedAt,
    this.durationSeconds,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    if (!nullToAbsent || workoutId != null) {
      map['workout_id'] = Variable<int>(workoutId);
    }
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || durationSeconds != null) {
      map['duration_seconds'] = Variable<int>(durationSeconds);
    }
    map['status'] = Variable<String>(status);
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      userId: Value(userId),
      workoutId: workoutId == null && nullToAbsent
          ? const Value.absent()
          : Value(workoutId),
      startedAt: Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      durationSeconds: durationSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSeconds),
      status: Value(status),
    );
  }

  factory Session.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Session(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      workoutId: serializer.fromJson<int?>(json['workoutId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      durationSeconds: serializer.fromJson<int?>(json['durationSeconds']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'workoutId': serializer.toJson<int?>(workoutId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'durationSeconds': serializer.toJson<int?>(durationSeconds),
      'status': serializer.toJson<String>(status),
    };
  }

  Session copyWith({
    int? id,
    int? userId,
    Value<int?> workoutId = const Value.absent(),
    DateTime? startedAt,
    Value<DateTime?> completedAt = const Value.absent(),
    Value<int?> durationSeconds = const Value.absent(),
    String? status,
  }) => Session(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    workoutId: workoutId.present ? workoutId.value : this.workoutId,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    durationSeconds: durationSeconds.present
        ? durationSeconds.value
        : this.durationSeconds,
    status: status ?? this.status,
  );
  Session copyWithCompanion(SessionsCompanion data) {
    return Session(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      workoutId: data.workoutId.present ? data.workoutId.value : this.workoutId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('workoutId: $workoutId, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    workoutId,
    startedAt,
    completedAt,
    durationSeconds,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.workoutId == this.workoutId &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.durationSeconds == this.durationSeconds &&
          other.status == this.status);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<int> id;
  final Value<int> userId;
  final Value<int?> workoutId;
  final Value<DateTime> startedAt;
  final Value<DateTime?> completedAt;
  final Value<int?> durationSeconds;
  final Value<String> status;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.workoutId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.status = const Value.absent(),
  });
  SessionsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    this.workoutId = const Value.absent(),
    required DateTime startedAt,
    this.completedAt = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    required String status,
  }) : userId = Value(userId),
       startedAt = Value(startedAt),
       status = Value(status);
  static Insertable<Session> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<int>? workoutId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<int>? durationSeconds,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (workoutId != null) 'workout_id': workoutId,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (status != null) 'status': status,
    });
  }

  SessionsCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<int?>? workoutId,
    Value<DateTime>? startedAt,
    Value<DateTime?>? completedAt,
    Value<int?>? durationSeconds,
    Value<String>? status,
  }) {
    return SessionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      workoutId: workoutId ?? this.workoutId,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (workoutId.present) {
      map['workout_id'] = Variable<int>(workoutId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('workoutId: $workoutId, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $SessionExercisesTable extends SessionExercises
    with TableInfo<$SessionExercisesTable, SessionExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sessions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<int> exerciseId = GeneratedColumn<int>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercises (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, sessionId, exerciseId, orderIndex];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionExercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {sessionId, orderIndex},
  ];
  @override
  SessionExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionExercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercise_id'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
    );
  }

  @override
  $SessionExercisesTable createAlias(String alias) {
    return $SessionExercisesTable(attachedDatabase, alias);
  }
}

class SessionExercise extends DataClass implements Insertable<SessionExercise> {
  final int id;
  final int sessionId;
  final int exerciseId;
  final int orderIndex;
  const SessionExercise({
    required this.id,
    required this.sessionId,
    required this.exerciseId,
    required this.orderIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['exercise_id'] = Variable<int>(exerciseId);
    map['order_index'] = Variable<int>(orderIndex);
    return map;
  }

  SessionExercisesCompanion toCompanion(bool nullToAbsent) {
    return SessionExercisesCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      exerciseId: Value(exerciseId),
      orderIndex: Value(orderIndex),
    );
  }

  factory SessionExercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionExercise(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      exerciseId: serializer.fromJson<int>(json['exerciseId']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'exerciseId': serializer.toJson<int>(exerciseId),
      'orderIndex': serializer.toJson<int>(orderIndex),
    };
  }

  SessionExercise copyWith({
    int? id,
    int? sessionId,
    int? exerciseId,
    int? orderIndex,
  }) => SessionExercise(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    exerciseId: exerciseId ?? this.exerciseId,
    orderIndex: orderIndex ?? this.orderIndex,
  );
  SessionExercise copyWithCompanion(SessionExercisesCompanion data) {
    return SessionExercise(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionExercise(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sessionId, exerciseId, orderIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionExercise &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.exerciseId == this.exerciseId &&
          other.orderIndex == this.orderIndex);
}

class SessionExercisesCompanion extends UpdateCompanion<SessionExercise> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<int> exerciseId;
  final Value<int> orderIndex;
  const SessionExercisesCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.orderIndex = const Value.absent(),
  });
  SessionExercisesCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required int exerciseId,
    required int orderIndex,
  }) : sessionId = Value(sessionId),
       exerciseId = Value(exerciseId),
       orderIndex = Value(orderIndex);
  static Insertable<SessionExercise> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<int>? exerciseId,
    Expression<int>? orderIndex,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (orderIndex != null) 'order_index': orderIndex,
    });
  }

  SessionExercisesCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionId,
    Value<int>? exerciseId,
    Value<int>? orderIndex,
  }) {
    return SessionExercisesCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      exerciseId: exerciseId ?? this.exerciseId,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<int>(exerciseId.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionExercisesCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSetsTable extends WorkoutSets
    with TableInfo<$WorkoutSetsTable, WorkoutSet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sessionExerciseIdMeta = const VerificationMeta(
    'sessionExerciseId',
  );
  @override
  late final GeneratedColumn<int> sessionExerciseId = GeneratedColumn<int>(
    'session_exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES session_exercises (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _setIndexMeta = const VerificationMeta(
    'setIndex',
  );
  @override
  late final GeneratedColumn<int> setIndex = GeneratedColumn<int>(
    'set_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repetitionsMeta = const VerificationMeta(
    'repetitions',
  );
  @override
  late final GeneratedColumn<int> repetitions = GeneratedColumn<int>(
    'repetitions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _setTypeMeta = const VerificationMeta(
    'setType',
  );
  @override
  late final GeneratedColumn<String> setType = GeneratedColumn<String>(
    'set_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionExerciseId,
    setIndex,
    weightKg,
    repetitions,
    setType,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sets';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSet> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_exercise_id')) {
      context.handle(
        _sessionExerciseIdMeta,
        sessionExerciseId.isAcceptableOrUnknown(
          data['session_exercise_id']!,
          _sessionExerciseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sessionExerciseIdMeta);
    }
    if (data.containsKey('set_index')) {
      context.handle(
        _setIndexMeta,
        setIndex.isAcceptableOrUnknown(data['set_index']!, _setIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_setIndexMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    }
    if (data.containsKey('repetitions')) {
      context.handle(
        _repetitionsMeta,
        repetitions.isAcceptableOrUnknown(
          data['repetitions']!,
          _repetitionsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_repetitionsMeta);
    }
    if (data.containsKey('set_type')) {
      context.handle(
        _setTypeMeta,
        setType.isAcceptableOrUnknown(data['set_type']!, _setTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_setTypeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {sessionExerciseId, setIndex},
  ];
  @override
  WorkoutSet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSet(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionExerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_exercise_id'],
      )!,
      setIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}set_index'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      ),
      repetitions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repetitions'],
      )!,
      setType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}set_type'],
      )!,
    );
  }

  @override
  $WorkoutSetsTable createAlias(String alias) {
    return $WorkoutSetsTable(attachedDatabase, alias);
  }
}

class WorkoutSet extends DataClass implements Insertable<WorkoutSet> {
  final int id;
  final int sessionExerciseId;
  final int setIndex;
  final double? weightKg;
  final int repetitions;
  final String setType;
  const WorkoutSet({
    required this.id,
    required this.sessionExerciseId,
    required this.setIndex,
    this.weightKg,
    required this.repetitions,
    required this.setType,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_exercise_id'] = Variable<int>(sessionExerciseId);
    map['set_index'] = Variable<int>(setIndex);
    if (!nullToAbsent || weightKg != null) {
      map['weight_kg'] = Variable<double>(weightKg);
    }
    map['repetitions'] = Variable<int>(repetitions);
    map['set_type'] = Variable<String>(setType);
    return map;
  }

  WorkoutSetsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSetsCompanion(
      id: Value(id),
      sessionExerciseId: Value(sessionExerciseId),
      setIndex: Value(setIndex),
      weightKg: weightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(weightKg),
      repetitions: Value(repetitions),
      setType: Value(setType),
    );
  }

  factory WorkoutSet.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSet(
      id: serializer.fromJson<int>(json['id']),
      sessionExerciseId: serializer.fromJson<int>(json['sessionExerciseId']),
      setIndex: serializer.fromJson<int>(json['setIndex']),
      weightKg: serializer.fromJson<double?>(json['weightKg']),
      repetitions: serializer.fromJson<int>(json['repetitions']),
      setType: serializer.fromJson<String>(json['setType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionExerciseId': serializer.toJson<int>(sessionExerciseId),
      'setIndex': serializer.toJson<int>(setIndex),
      'weightKg': serializer.toJson<double?>(weightKg),
      'repetitions': serializer.toJson<int>(repetitions),
      'setType': serializer.toJson<String>(setType),
    };
  }

  WorkoutSet copyWith({
    int? id,
    int? sessionExerciseId,
    int? setIndex,
    Value<double?> weightKg = const Value.absent(),
    int? repetitions,
    String? setType,
  }) => WorkoutSet(
    id: id ?? this.id,
    sessionExerciseId: sessionExerciseId ?? this.sessionExerciseId,
    setIndex: setIndex ?? this.setIndex,
    weightKg: weightKg.present ? weightKg.value : this.weightKg,
    repetitions: repetitions ?? this.repetitions,
    setType: setType ?? this.setType,
  );
  WorkoutSet copyWithCompanion(WorkoutSetsCompanion data) {
    return WorkoutSet(
      id: data.id.present ? data.id.value : this.id,
      sessionExerciseId: data.sessionExerciseId.present
          ? data.sessionExerciseId.value
          : this.sessionExerciseId,
      setIndex: data.setIndex.present ? data.setIndex.value : this.setIndex,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      repetitions: data.repetitions.present
          ? data.repetitions.value
          : this.repetitions,
      setType: data.setType.present ? data.setType.value : this.setType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSet(')
          ..write('id: $id, ')
          ..write('sessionExerciseId: $sessionExerciseId, ')
          ..write('setIndex: $setIndex, ')
          ..write('weightKg: $weightKg, ')
          ..write('repetitions: $repetitions, ')
          ..write('setType: $setType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionExerciseId,
    setIndex,
    weightKg,
    repetitions,
    setType,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSet &&
          other.id == this.id &&
          other.sessionExerciseId == this.sessionExerciseId &&
          other.setIndex == this.setIndex &&
          other.weightKg == this.weightKg &&
          other.repetitions == this.repetitions &&
          other.setType == this.setType);
}

class WorkoutSetsCompanion extends UpdateCompanion<WorkoutSet> {
  final Value<int> id;
  final Value<int> sessionExerciseId;
  final Value<int> setIndex;
  final Value<double?> weightKg;
  final Value<int> repetitions;
  final Value<String> setType;
  const WorkoutSetsCompanion({
    this.id = const Value.absent(),
    this.sessionExerciseId = const Value.absent(),
    this.setIndex = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.setType = const Value.absent(),
  });
  WorkoutSetsCompanion.insert({
    this.id = const Value.absent(),
    required int sessionExerciseId,
    required int setIndex,
    this.weightKg = const Value.absent(),
    required int repetitions,
    required String setType,
  }) : sessionExerciseId = Value(sessionExerciseId),
       setIndex = Value(setIndex),
       repetitions = Value(repetitions),
       setType = Value(setType);
  static Insertable<WorkoutSet> custom({
    Expression<int>? id,
    Expression<int>? sessionExerciseId,
    Expression<int>? setIndex,
    Expression<double>? weightKg,
    Expression<int>? repetitions,
    Expression<String>? setType,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionExerciseId != null) 'session_exercise_id': sessionExerciseId,
      if (setIndex != null) 'set_index': setIndex,
      if (weightKg != null) 'weight_kg': weightKg,
      if (repetitions != null) 'repetitions': repetitions,
      if (setType != null) 'set_type': setType,
    });
  }

  WorkoutSetsCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionExerciseId,
    Value<int>? setIndex,
    Value<double?>? weightKg,
    Value<int>? repetitions,
    Value<String>? setType,
  }) {
    return WorkoutSetsCompanion(
      id: id ?? this.id,
      sessionExerciseId: sessionExerciseId ?? this.sessionExerciseId,
      setIndex: setIndex ?? this.setIndex,
      weightKg: weightKg ?? this.weightKg,
      repetitions: repetitions ?? this.repetitions,
      setType: setType ?? this.setType,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionExerciseId.present) {
      map['session_exercise_id'] = Variable<int>(sessionExerciseId.value);
    }
    if (setIndex.present) {
      map['set_index'] = Variable<int>(setIndex.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (repetitions.present) {
      map['repetitions'] = Variable<int>(repetitions.value);
    }
    if (setType.present) {
      map['set_type'] = Variable<String>(setType.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSetsCompanion(')
          ..write('id: $id, ')
          ..write('sessionExerciseId: $sessionExerciseId, ')
          ..write('setIndex: $setIndex, ')
          ..write('weightKg: $weightKg, ')
          ..write('repetitions: $repetitions, ')
          ..write('setType: $setType')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $WeightEntriesTable weightEntries = $WeightEntriesTable(this);
  late final $GoalsTable goals = $GoalsTable(this);
  late final $EquipmentTable equipment = $EquipmentTable(this);
  late final $ExercisesTable exercises = $ExercisesTable(this);
  late final $ExerciseEquipmentTable exerciseEquipment =
      $ExerciseEquipmentTable(this);
  late final $ExerciseRelationshipsTable exerciseRelationships =
      $ExerciseRelationshipsTable(this);
  late final $WorkoutsTable workouts = $WorkoutsTable(this);
  late final $WorkoutExercisesTable workoutExercises = $WorkoutExercisesTable(
    this,
  );
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $SessionExercisesTable sessionExercises = $SessionExercisesTable(
    this,
  );
  late final $WorkoutSetsTable workoutSets = $WorkoutSetsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    weightEntries,
    goals,
    equipment,
    exercises,
    exerciseEquipment,
    exerciseRelationships,
    workouts,
    workoutExercises,
    sessions,
    sessionExercises,
    workoutSets,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'exercises',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('exercise_equipment', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'equipment',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('exercise_equipment', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'exercises',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('exercise_relationships', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'exercises',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('exercise_relationships', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'users',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('workouts', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'workouts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('workout_exercises', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'users',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('sessions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'workouts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('sessions', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('session_exercises', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'session_exercises',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('workout_sets', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  required DateTime birthDate,
  required double heightCm,
  required double currentWeightKg,
  required String fitnessLevel,
  required String trainingLocation,
  required int weeklyFrequency,
  required int availableMinutes,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  Value<DateTime> birthDate,
  Value<double> heightCm,
  Value<double> currentWeightKg,
  Value<String> fitnessLevel,
  Value<String> trainingLocation,
  Value<int> weeklyFrequency,
  Value<int> availableMinutes,
});

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$WorkoutsTable, List<Workout>> _workoutsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.workouts,
    aliasName: 'users__id__workouts__user_id',
  );

  $$WorkoutsTableProcessedTableManager get workoutsRefs {
    final manager = $$WorkoutsTableTableManager(
      $_db,
      $_db.workouts,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_workoutsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SessionsTable, List<Session>> _sessionsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.sessions,
    aliasName: 'users__id__sessions__user_id',
  );

  $$SessionsTableProcessedTableManager get sessionsRefs {
    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_sessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get currentWeightKg => $composableBuilder(
    column: $table.currentWeightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fitnessLevel => $composableBuilder(
    column: $table.fitnessLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trainingLocation => $composableBuilder(
    column: $table.trainingLocation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weeklyFrequency => $composableBuilder(
    column: $table.weeklyFrequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get availableMinutes => $composableBuilder(
    column: $table.availableMinutes,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> workoutsRefs(
    Expression<bool> Function($$WorkoutsTableFilterComposer f) f,
  ) {
    final $$WorkoutsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableFilterComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sessionsRefs(
    Expression<bool> Function($$SessionsTableFilterComposer f) f,
  ) {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get currentWeightKg => $composableBuilder(
    column: $table.currentWeightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fitnessLevel => $composableBuilder(
    column: $table.fitnessLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trainingLocation => $composableBuilder(
    column: $table.trainingLocation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weeklyFrequency => $composableBuilder(
    column: $table.weeklyFrequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get availableMinutes => $composableBuilder(
    column: $table.availableMinutes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumn<double> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<double> get currentWeightKg => $composableBuilder(
    column: $table.currentWeightKg,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fitnessLevel => $composableBuilder(
    column: $table.fitnessLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get trainingLocation => $composableBuilder(
    column: $table.trainingLocation,
    builder: (column) => column,
  );

  GeneratedColumn<int> get weeklyFrequency => $composableBuilder(
    column: $table.weeklyFrequency,
    builder: (column) => column,
  );

  GeneratedColumn<int> get availableMinutes => $composableBuilder(
    column: $table.availableMinutes,
    builder: (column) => column,
  );

  Expression<T> workoutsRefs<T extends Object>(
    Expression<T> Function($$WorkoutsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableAnnotationComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> sessionsRefs<T extends Object>(
    Expression<T> Function($$SessionsTableAnnotationComposer a) f,
  ) {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, $$UsersTableReferences),
          User,
          PrefetchHooks Function({bool workoutsRefs, bool sessionsRefs})
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> birthDate = const Value.absent(),
                Value<double> heightCm = const Value.absent(),
                Value<double> currentWeightKg = const Value.absent(),
                Value<String> fitnessLevel = const Value.absent(),
                Value<String> trainingLocation = const Value.absent(),
                Value<int> weeklyFrequency = const Value.absent(),
                Value<int> availableMinutes = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                birthDate: birthDate,
                heightCm: heightCm,
                currentWeightKg: currentWeightKg,
                fitnessLevel: fitnessLevel,
                trainingLocation: trainingLocation,
                weeklyFrequency: weeklyFrequency,
                availableMinutes: availableMinutes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime birthDate,
                required double heightCm,
                required double currentWeightKg,
                required String fitnessLevel,
                required String trainingLocation,
                required int weeklyFrequency,
                required int availableMinutes,
              }) => UsersCompanion.insert(
                id: id,
                birthDate: birthDate,
                heightCm: heightCm,
                currentWeightKg: currentWeightKg,
                fitnessLevel: fitnessLevel,
                trainingLocation: trainingLocation,
                weeklyFrequency: weeklyFrequency,
                availableMinutes: availableMinutes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UsersTable, User>(table),
                  $$UsersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({workoutsRefs = false, sessionsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (workoutsRefs) db.workouts,
                    if (sessionsRefs) db.sessions,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (workoutsRefs)
                        await $_getPrefetchedData<User, $UsersTable, Workout>(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._workoutsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (sessionsRefs)
                        await $_getPrefetchedData<User, $UsersTable, Session>(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._sessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).sessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, $$UsersTableReferences),
      User,
      PrefetchHooks Function({bool workoutsRefs, bool sessionsRefs})
    >;
typedef $$WeightEntriesTableCreateCompanionBuilder =
    WeightEntriesCompanion Function({
      Value<int> id,
      required int userId,
      required DateTime recordedAt,
      required double weightKg,
    });
typedef $$WeightEntriesTableUpdateCompanionBuilder =
    WeightEntriesCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<DateTime> recordedAt,
      Value<double> weightKg,
    });

class $$WeightEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $WeightEntriesTable> {
  $$WeightEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeightEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $WeightEntriesTable> {
  $$WeightEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeightEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeightEntriesTable> {
  $$WeightEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);
}

class $$WeightEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeightEntriesTable,
          WeightEntry,
          $$WeightEntriesTableFilterComposer,
          $$WeightEntriesTableOrderingComposer,
          $$WeightEntriesTableAnnotationComposer,
          $$WeightEntriesTableCreateCompanionBuilder,
          $$WeightEntriesTableUpdateCompanionBuilder,
          (
            WeightEntry,
            BaseReferences<_$AppDatabase, $WeightEntriesTable, WeightEntry>,
          ),
          WeightEntry,
          PrefetchHooks Function()
        > {
  $$WeightEntriesTableTableManager(_$AppDatabase db, $WeightEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeightEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeightEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeightEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
              }) => WeightEntriesCompanion(
                id: id,
                userId: userId,
                recordedAt: recordedAt,
                weightKg: weightKg,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                required DateTime recordedAt,
                required double weightKg,
              }) => WeightEntriesCompanion.insert(
                id: id,
                userId: userId,
                recordedAt: recordedAt,
                weightKg: weightKg,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WeightEntriesTable, WeightEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $WeightEntriesTable,
                    WeightEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeightEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeightEntriesTable,
      WeightEntry,
      $$WeightEntriesTableFilterComposer,
      $$WeightEntriesTableOrderingComposer,
      $$WeightEntriesTableAnnotationComposer,
      $$WeightEntriesTableCreateCompanionBuilder,
      $$WeightEntriesTableUpdateCompanionBuilder,
      (
        WeightEntry,
        BaseReferences<_$AppDatabase, $WeightEntriesTable, WeightEntry>,
      ),
      WeightEntry,
      PrefetchHooks Function()
    >;
typedef $$GoalsTableCreateCompanionBuilder = GoalsCompanion Function({
  Value<int> id,
  required int userId,
  required String type,
  required String name,
  required double targetValue,
  required String unit,
  required DateTime startDate,
  Value<DateTime?> targetDate,
  required String status,
});
typedef $$GoalsTableUpdateCompanionBuilder = GoalsCompanion Function({
  Value<int> id,
  Value<int> userId,
  Value<String> type,
  Value<String> name,
  Value<double> targetValue,
  Value<String> unit,
  Value<DateTime> startDate,
  Value<DateTime?> targetDate,
  Value<String> status,
});

class $$GoalsTableFilterComposer extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$GoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GoalsTable,
          Goal,
          $$GoalsTableFilterComposer,
          $$GoalsTableOrderingComposer,
          $$GoalsTableAnnotationComposer,
          $$GoalsTableCreateCompanionBuilder,
          $$GoalsTableUpdateCompanionBuilder,
          (Goal, BaseReferences<_$AppDatabase, $GoalsTable, Goal>),
          Goal,
          PrefetchHooks Function()
        > {
  $$GoalsTableTableManager(_$AppDatabase db, $GoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> targetValue = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime?> targetDate = const Value.absent(),
                Value<String> status = const Value.absent(),
              }) => GoalsCompanion(
                id: id,
                userId: userId,
                type: type,
                name: name,
                targetValue: targetValue,
                unit: unit,
                startDate: startDate,
                targetDate: targetDate,
                status: status,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                required String type,
                required String name,
                required double targetValue,
                required String unit,
                required DateTime startDate,
                Value<DateTime?> targetDate = const Value.absent(),
                required String status,
              }) => GoalsCompanion.insert(
                id: id,
                userId: userId,
                type: type,
                name: name,
                targetValue: targetValue,
                unit: unit,
                startDate: startDate,
                targetDate: targetDate,
                status: status,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GoalsTable, Goal>(table),
                  BaseReferences<_$AppDatabase, $GoalsTable, Goal>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GoalsTable,
      Goal,
      $$GoalsTableFilterComposer,
      $$GoalsTableOrderingComposer,
      $$GoalsTableAnnotationComposer,
      $$GoalsTableCreateCompanionBuilder,
      $$GoalsTableUpdateCompanionBuilder,
      (Goal, BaseReferences<_$AppDatabase, $GoalsTable, Goal>),
      Goal,
      PrefetchHooks Function()
    >;
typedef $$EquipmentTableCreateCompanionBuilder = EquipmentCompanion Function({
  Value<int> id,
  required String code,
  required String name,
  Value<bool> isActive,
});
typedef $$EquipmentTableUpdateCompanionBuilder = EquipmentCompanion Function({
  Value<int> id,
  Value<String> code,
  Value<String> name,
  Value<bool> isActive,
});

final class $$EquipmentTableReferences
    extends BaseReferences<_$AppDatabase, $EquipmentTable, EquipmentData> {
  $$EquipmentTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $ExerciseEquipmentTable,
    List<ExerciseEquipmentData>
  >
  _exerciseEquipmentRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.exerciseEquipment,
        aliasName: 'equipment__id__exercise_equipment__equipment_id',
      );

  $$ExerciseEquipmentTableProcessedTableManager get exerciseEquipmentRefs {
    final manager = $$ExerciseEquipmentTableTableManager(
      $_db,
      $_db.exerciseEquipment,
    ).filter((f) => f.equipmentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _exerciseEquipmentRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EquipmentTableFilterComposer
    extends Composer<_$AppDatabase, $EquipmentTable> {
  $$EquipmentTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> exerciseEquipmentRefs(
    Expression<bool> Function($$ExerciseEquipmentTableFilterComposer f) f,
  ) {
    final $$ExerciseEquipmentTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.exerciseEquipment,
      getReferencedColumn: (t) => t.equipmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExerciseEquipmentTableFilterComposer(
            $db: $db,
            $table: $db.exerciseEquipment,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EquipmentTableOrderingComposer
    extends Composer<_$AppDatabase, $EquipmentTable> {
  $$EquipmentTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EquipmentTableAnnotationComposer
    extends Composer<_$AppDatabase, $EquipmentTable> {
  $$EquipmentTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> exerciseEquipmentRefs<T extends Object>(
    Expression<T> Function($$ExerciseEquipmentTableAnnotationComposer a) f,
  ) {
    final $$ExerciseEquipmentTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.exerciseEquipment,
          getReferencedColumn: (t) => t.equipmentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ExerciseEquipmentTableAnnotationComposer(
                $db: $db,
                $table: $db.exerciseEquipment,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$EquipmentTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EquipmentTable,
          EquipmentData,
          $$EquipmentTableFilterComposer,
          $$EquipmentTableOrderingComposer,
          $$EquipmentTableAnnotationComposer,
          $$EquipmentTableCreateCompanionBuilder,
          $$EquipmentTableUpdateCompanionBuilder,
          (EquipmentData, $$EquipmentTableReferences),
          EquipmentData,
          PrefetchHooks Function({bool exerciseEquipmentRefs})
        > {
  $$EquipmentTableTableManager(_$AppDatabase db, $EquipmentTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EquipmentTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EquipmentTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EquipmentTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => EquipmentCompanion(
                id: id,
                code: code,
                name: name,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String code,
                required String name,
                Value<bool> isActive = const Value.absent(),
              }) => EquipmentCompanion.insert(
                id: id,
                code: code,
                name: name,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EquipmentTable, EquipmentData>(table),
                  $$EquipmentTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({exerciseEquipmentRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (exerciseEquipmentRefs) db.exerciseEquipment,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (exerciseEquipmentRefs)
                    await $_getPrefetchedData<
                      EquipmentData,
                      $EquipmentTable,
                      ExerciseEquipmentData
                    >(
                      currentTable: table,
                      referencedTable: $$EquipmentTableReferences
                          ._exerciseEquipmentRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$EquipmentTableReferences(
                            db,
                            table,
                            p0,
                          ).exerciseEquipmentRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.equipmentId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$EquipmentTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EquipmentTable,
      EquipmentData,
      $$EquipmentTableFilterComposer,
      $$EquipmentTableOrderingComposer,
      $$EquipmentTableAnnotationComposer,
      $$EquipmentTableCreateCompanionBuilder,
      $$EquipmentTableUpdateCompanionBuilder,
      (EquipmentData, $$EquipmentTableReferences),
      EquipmentData,
      PrefetchHooks Function({bool exerciseEquipmentRefs})
    >;
typedef $$ExercisesTableCreateCompanionBuilder = ExercisesCompanion Function({
  Value<int> id,
  required String name,
  required String description,
  required String primaryMuscle,
  required String difficulty,
  required String movementPattern,
  required String exerciseType,
  required String technique,
  required String commonMistakes,
  required String considerations,
  required String instructions,
  Value<bool> isActive,
});
typedef $$ExercisesTableUpdateCompanionBuilder = ExercisesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> description,
  Value<String> primaryMuscle,
  Value<String> difficulty,
  Value<String> movementPattern,
  Value<String> exerciseType,
  Value<String> technique,
  Value<String> commonMistakes,
  Value<String> considerations,
  Value<String> instructions,
  Value<bool> isActive,
});

final class $$ExercisesTableReferences
    extends BaseReferences<_$AppDatabase, $ExercisesTable, Exercise> {
  $$ExercisesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $ExerciseEquipmentTable,
    List<ExerciseEquipmentData>
  >
  _exerciseEquipmentRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.exerciseEquipment,
        aliasName: 'exercises__id__exercise_equipment__exercise_id',
      );

  $$ExerciseEquipmentTableProcessedTableManager get exerciseEquipmentRefs {
    final manager = $$ExerciseEquipmentTableTableManager(
      $_db,
      $_db.exerciseEquipment,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _exerciseEquipmentRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ExerciseRelationshipsTable,
    List<ExerciseRelationship>
  >
  _sourceExerciseTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.exerciseRelationships,
    aliasName: 'exercises__id__exercise_relationships__exercise_id',
  );

  $$ExerciseRelationshipsTableProcessedTableManager get sourceExercise {
    final manager = $$ExerciseRelationshipsTableTableManager(
      $_db,
      $_db.exerciseRelationships,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_sourceExerciseTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ExerciseRelationshipsTable,
    List<ExerciseRelationship>
  >
  _relatedExerciseTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.exerciseRelationships,
    aliasName: 'exercises__id__exercise_relationships__related_exercise_id',
  );

  $$ExerciseRelationshipsTableProcessedTableManager get relatedExercise {
    final manager = $$ExerciseRelationshipsTableTableManager(
      $_db,
      $_db.exerciseRelationships,
    ).filter((f) => f.relatedExerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_relatedExerciseTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WorkoutExercisesTable, List<WorkoutExercise>>
  _workoutExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutExercises,
    aliasName: 'exercises__id__workout_exercises__exercise_id',
  );

  $$WorkoutExercisesTableProcessedTableManager get workoutExercisesRefs {
    final manager = $$WorkoutExercisesTableTableManager(
      $_db,
      $_db.workoutExercises,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SessionExercisesTable, List<SessionExercise>>
  _sessionExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sessionExercises,
    aliasName: 'exercises__id__session_exercises__exercise_id',
  );

  $$SessionExercisesTableProcessedTableManager get sessionExercisesRefs {
    final manager = $$SessionExercisesTableTableManager(
      $_db,
      $_db.sessionExercises,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _sessionExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get primaryMuscle => $composableBuilder(
    column: $table.primaryMuscle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get movementPattern => $composableBuilder(
    column: $table.movementPattern,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseType => $composableBuilder(
    column: $table.exerciseType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get technique => $composableBuilder(
    column: $table.technique,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get commonMistakes => $composableBuilder(
    column: $table.commonMistakes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get considerations => $composableBuilder(
    column: $table.considerations,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> exerciseEquipmentRefs(
    Expression<bool> Function($$ExerciseEquipmentTableFilterComposer f) f,
  ) {
    final $$ExerciseEquipmentTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.exerciseEquipment,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExerciseEquipmentTableFilterComposer(
            $db: $db,
            $table: $db.exerciseEquipment,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sourceExercise(
    Expression<bool> Function($$ExerciseRelationshipsTableFilterComposer f) f,
  ) {
    final $$ExerciseRelationshipsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.exerciseRelationships,
          getReferencedColumn: (t) => t.exerciseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ExerciseRelationshipsTableFilterComposer(
                $db: $db,
                $table: $db.exerciseRelationships,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> relatedExercise(
    Expression<bool> Function($$ExerciseRelationshipsTableFilterComposer f) f,
  ) {
    final $$ExerciseRelationshipsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.exerciseRelationships,
          getReferencedColumn: (t) => t.relatedExerciseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ExerciseRelationshipsTableFilterComposer(
                $db: $db,
                $table: $db.exerciseRelationships,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> workoutExercisesRefs(
    Expression<bool> Function($$WorkoutExercisesTableFilterComposer f) f,
  ) {
    final $$WorkoutExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutExercises,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExercisesTableFilterComposer(
            $db: $db,
            $table: $db.workoutExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sessionExercisesRefs(
    Expression<bool> Function($$SessionExercisesTableFilterComposer f) f,
  ) {
    final $$SessionExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionExercises,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionExercisesTableFilterComposer(
            $db: $db,
            $table: $db.sessionExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryMuscle => $composableBuilder(
    column: $table.primaryMuscle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get movementPattern => $composableBuilder(
    column: $table.movementPattern,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseType => $composableBuilder(
    column: $table.exerciseType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get technique => $composableBuilder(
    column: $table.technique,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get commonMistakes => $composableBuilder(
    column: $table.commonMistakes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get considerations => $composableBuilder(
    column: $table.considerations,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get primaryMuscle => $composableBuilder(
    column: $table.primaryMuscle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get movementPattern => $composableBuilder(
    column: $table.movementPattern,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exerciseType => $composableBuilder(
    column: $table.exerciseType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get technique =>
      $composableBuilder(column: $table.technique, builder: (column) => column);

  GeneratedColumn<String> get commonMistakes => $composableBuilder(
    column: $table.commonMistakes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get considerations => $composableBuilder(
    column: $table.considerations,
    builder: (column) => column,
  );

  GeneratedColumn<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> exerciseEquipmentRefs<T extends Object>(
    Expression<T> Function($$ExerciseEquipmentTableAnnotationComposer a) f,
  ) {
    final $$ExerciseEquipmentTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.exerciseEquipment,
          getReferencedColumn: (t) => t.exerciseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ExerciseEquipmentTableAnnotationComposer(
                $db: $db,
                $table: $db.exerciseEquipment,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> sourceExercise<T extends Object>(
    Expression<T> Function($$ExerciseRelationshipsTableAnnotationComposer a) f,
  ) {
    final $$ExerciseRelationshipsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.exerciseRelationships,
          getReferencedColumn: (t) => t.exerciseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ExerciseRelationshipsTableAnnotationComposer(
                $db: $db,
                $table: $db.exerciseRelationships,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> relatedExercise<T extends Object>(
    Expression<T> Function($$ExerciseRelationshipsTableAnnotationComposer a) f,
  ) {
    final $$ExerciseRelationshipsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.exerciseRelationships,
          getReferencedColumn: (t) => t.relatedExerciseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ExerciseRelationshipsTableAnnotationComposer(
                $db: $db,
                $table: $db.exerciseRelationships,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> workoutExercisesRefs<T extends Object>(
    Expression<T> Function($$WorkoutExercisesTableAnnotationComposer a) f,
  ) {
    final $$WorkoutExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutExercises,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> sessionExercisesRefs<T extends Object>(
    Expression<T> Function($$SessionExercisesTableAnnotationComposer a) f,
  ) {
    final $$SessionExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionExercises,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.sessionExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExercisesTable,
          Exercise,
          $$ExercisesTableFilterComposer,
          $$ExercisesTableOrderingComposer,
          $$ExercisesTableAnnotationComposer,
          $$ExercisesTableCreateCompanionBuilder,
          $$ExercisesTableUpdateCompanionBuilder,
          (Exercise, $$ExercisesTableReferences),
          Exercise,
          PrefetchHooks Function({
            bool exerciseEquipmentRefs,
            bool sourceExercise,
            bool relatedExercise,
            bool workoutExercisesRefs,
            bool sessionExercisesRefs,
          })
        > {
  $$ExercisesTableTableManager(_$AppDatabase db, $ExercisesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> primaryMuscle = const Value.absent(),
                Value<String> difficulty = const Value.absent(),
                Value<String> movementPattern = const Value.absent(),
                Value<String> exerciseType = const Value.absent(),
                Value<String> technique = const Value.absent(),
                Value<String> commonMistakes = const Value.absent(),
                Value<String> considerations = const Value.absent(),
                Value<String> instructions = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => ExercisesCompanion(
                id: id,
                name: name,
                description: description,
                primaryMuscle: primaryMuscle,
                difficulty: difficulty,
                movementPattern: movementPattern,
                exerciseType: exerciseType,
                technique: technique,
                commonMistakes: commonMistakes,
                considerations: considerations,
                instructions: instructions,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String description,
                required String primaryMuscle,
                required String difficulty,
                required String movementPattern,
                required String exerciseType,
                required String technique,
                required String commonMistakes,
                required String considerations,
                required String instructions,
                Value<bool> isActive = const Value.absent(),
              }) => ExercisesCompanion.insert(
                id: id,
                name: name,
                description: description,
                primaryMuscle: primaryMuscle,
                difficulty: difficulty,
                movementPattern: movementPattern,
                exerciseType: exerciseType,
                technique: technique,
                commonMistakes: commonMistakes,
                considerations: considerations,
                instructions: instructions,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExercisesTable, Exercise>(table),
                  $$ExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                exerciseEquipmentRefs = false,
                sourceExercise = false,
                relatedExercise = false,
                workoutExercisesRefs = false,
                sessionExercisesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (exerciseEquipmentRefs) db.exerciseEquipment,
                    if (sourceExercise) db.exerciseRelationships,
                    if (relatedExercise) db.exerciseRelationships,
                    if (workoutExercisesRefs) db.workoutExercises,
                    if (sessionExercisesRefs) db.sessionExercises,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (exerciseEquipmentRefs)
                        await $_getPrefetchedData<
                          Exercise,
                          $ExercisesTable,
                          ExerciseEquipmentData
                        >(
                          currentTable: table,
                          referencedTable: $$ExercisesTableReferences
                              ._exerciseEquipmentRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).exerciseEquipmentRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.exerciseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (sourceExercise)
                        await $_getPrefetchedData<
                          Exercise,
                          $ExercisesTable,
                          ExerciseRelationship
                        >(
                          currentTable: table,
                          referencedTable: $$ExercisesTableReferences
                              ._sourceExerciseTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).sourceExercise,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.exerciseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (relatedExercise)
                        await $_getPrefetchedData<
                          Exercise,
                          $ExercisesTable,
                          ExerciseRelationship
                        >(
                          currentTable: table,
                          referencedTable: $$ExercisesTableReferences
                              ._relatedExerciseTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).relatedExercise,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.relatedExerciseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (workoutExercisesRefs)
                        await $_getPrefetchedData<
                          Exercise,
                          $ExercisesTable,
                          WorkoutExercise
                        >(
                          currentTable: table,
                          referencedTable: $$ExercisesTableReferences
                              ._workoutExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutExercisesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.exerciseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (sessionExercisesRefs)
                        await $_getPrefetchedData<
                          Exercise,
                          $ExercisesTable,
                          SessionExercise
                        >(
                          currentTable: table,
                          referencedTable: $$ExercisesTableReferences
                              ._sessionExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).sessionExercisesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.exerciseId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExercisesTable,
      Exercise,
      $$ExercisesTableFilterComposer,
      $$ExercisesTableOrderingComposer,
      $$ExercisesTableAnnotationComposer,
      $$ExercisesTableCreateCompanionBuilder,
      $$ExercisesTableUpdateCompanionBuilder,
      (Exercise, $$ExercisesTableReferences),
      Exercise,
      PrefetchHooks Function({
        bool exerciseEquipmentRefs,
        bool sourceExercise,
        bool relatedExercise,
        bool workoutExercisesRefs,
        bool sessionExercisesRefs,
      })
    >;
typedef $$ExerciseEquipmentTableCreateCompanionBuilder =
    ExerciseEquipmentCompanion Function({
      Value<int> id,
      required int exerciseId,
      required int equipmentId,
    });
typedef $$ExerciseEquipmentTableUpdateCompanionBuilder =
    ExerciseEquipmentCompanion Function({
      Value<int> id,
      Value<int> exerciseId,
      Value<int> equipmentId,
    });

final class $$ExerciseEquipmentTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ExerciseEquipmentTable,
          ExerciseEquipmentData
        > {
  $$ExerciseEquipmentTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ExercisesTable _exerciseIdTable(_$AppDatabase db) => db.exercises
      .createAlias('exercise_equipment__exercise_id__exercises__id');

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<int>('exercise_id')!;

    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EquipmentTable _equipmentIdTable(_$AppDatabase db) => db.equipment
      .createAlias('exercise_equipment__equipment_id__equipment__id');

  $$EquipmentTableProcessedTableManager get equipmentId {
    final $_column = $_itemColumn<int>('equipment_id')!;

    final manager = $$EquipmentTableTableManager(
      $_db,
      $_db.equipment,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_equipmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExerciseEquipmentTableFilterComposer
    extends Composer<_$AppDatabase, $ExerciseEquipmentTable> {
  $$ExerciseEquipmentTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquipmentTableFilterComposer get equipmentId {
    final $$EquipmentTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipmentId,
      referencedTable: $db.equipment,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipmentTableFilterComposer(
            $db: $db,
            $table: $db.equipment,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExerciseEquipmentTableOrderingComposer
    extends Composer<_$AppDatabase, $ExerciseEquipmentTable> {
  $$ExerciseEquipmentTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquipmentTableOrderingComposer get equipmentId {
    final $$EquipmentTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipmentId,
      referencedTable: $db.equipment,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipmentTableOrderingComposer(
            $db: $db,
            $table: $db.equipment,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExerciseEquipmentTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExerciseEquipmentTable> {
  $$ExerciseEquipmentTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquipmentTableAnnotationComposer get equipmentId {
    final $$EquipmentTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipmentId,
      referencedTable: $db.equipment,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipmentTableAnnotationComposer(
            $db: $db,
            $table: $db.equipment,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExerciseEquipmentTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExerciseEquipmentTable,
          ExerciseEquipmentData,
          $$ExerciseEquipmentTableFilterComposer,
          $$ExerciseEquipmentTableOrderingComposer,
          $$ExerciseEquipmentTableAnnotationComposer,
          $$ExerciseEquipmentTableCreateCompanionBuilder,
          $$ExerciseEquipmentTableUpdateCompanionBuilder,
          (ExerciseEquipmentData, $$ExerciseEquipmentTableReferences),
          ExerciseEquipmentData,
          PrefetchHooks Function({bool exerciseId, bool equipmentId})
        > {
  $$ExerciseEquipmentTableTableManager(
    _$AppDatabase db,
    $ExerciseEquipmentTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExerciseEquipmentTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExerciseEquipmentTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExerciseEquipmentTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> exerciseId = const Value.absent(),
                Value<int> equipmentId = const Value.absent(),
              }) => ExerciseEquipmentCompanion(
                id: id,
                exerciseId: exerciseId,
                equipmentId: equipmentId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int exerciseId,
                required int equipmentId,
              }) => ExerciseEquipmentCompanion.insert(
                id: id,
                exerciseId: exerciseId,
                equipmentId: equipmentId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExerciseEquipmentTable, ExerciseEquipmentData>(
                    table,
                  ),
                  $$ExerciseEquipmentTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({exerciseId = false, equipmentId = false}) {
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
                    if (exerciseId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.exerciseId,
                        referencedTable: $$ExerciseEquipmentTableReferences
                            ._exerciseIdTable(db),
                        referencedColumn: $$ExerciseEquipmentTableReferences
                            ._exerciseIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (equipmentId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.equipmentId,
                        referencedTable: $$ExerciseEquipmentTableReferences
                            ._equipmentIdTable(db),
                        referencedColumn: $$ExerciseEquipmentTableReferences
                            ._equipmentIdTable(db)
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

typedef $$ExerciseEquipmentTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExerciseEquipmentTable,
      ExerciseEquipmentData,
      $$ExerciseEquipmentTableFilterComposer,
      $$ExerciseEquipmentTableOrderingComposer,
      $$ExerciseEquipmentTableAnnotationComposer,
      $$ExerciseEquipmentTableCreateCompanionBuilder,
      $$ExerciseEquipmentTableUpdateCompanionBuilder,
      (ExerciseEquipmentData, $$ExerciseEquipmentTableReferences),
      ExerciseEquipmentData,
      PrefetchHooks Function({bool exerciseId, bool equipmentId})
    >;
typedef $$ExerciseRelationshipsTableCreateCompanionBuilder =
    ExerciseRelationshipsCompanion Function({
      Value<int> id,
      required int exerciseId,
      required int relatedExerciseId,
      required String relationshipType,
    });
typedef $$ExerciseRelationshipsTableUpdateCompanionBuilder =
    ExerciseRelationshipsCompanion Function({
      Value<int> id,
      Value<int> exerciseId,
      Value<int> relatedExerciseId,
      Value<String> relationshipType,
    });

final class $$ExerciseRelationshipsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ExerciseRelationshipsTable,
          ExerciseRelationship
        > {
  $$ExerciseRelationshipsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ExercisesTable _exerciseIdTable(_$AppDatabase db) => db.exercises
      .createAlias('exercise_relationships__exercise_id__exercises__id');

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<int>('exercise_id')!;

    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExercisesTable _relatedExerciseIdTable(_$AppDatabase db) =>
      db.exercises.createAlias(
        'exercise_relationships__related_exercise_id__exercises__id',
      );

  $$ExercisesTableProcessedTableManager get relatedExerciseId {
    final $_column = $_itemColumn<int>('related_exercise_id')!;

    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_relatedExerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExerciseRelationshipsTableFilterComposer
    extends Composer<_$AppDatabase, $ExerciseRelationshipsTable> {
  $$ExerciseRelationshipsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relationshipType => $composableBuilder(
    column: $table.relationshipType,
    builder: (column) => ColumnFilters(column),
  );

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableFilterComposer get relatedExerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.relatedExerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExerciseRelationshipsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExerciseRelationshipsTable> {
  $$ExerciseRelationshipsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relationshipType => $composableBuilder(
    column: $table.relationshipType,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableOrderingComposer get relatedExerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.relatedExerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExerciseRelationshipsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExerciseRelationshipsTable> {
  $$ExerciseRelationshipsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get relationshipType => $composableBuilder(
    column: $table.relationshipType,
    builder: (column) => column,
  );

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableAnnotationComposer get relatedExerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.relatedExerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExerciseRelationshipsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExerciseRelationshipsTable,
          ExerciseRelationship,
          $$ExerciseRelationshipsTableFilterComposer,
          $$ExerciseRelationshipsTableOrderingComposer,
          $$ExerciseRelationshipsTableAnnotationComposer,
          $$ExerciseRelationshipsTableCreateCompanionBuilder,
          $$ExerciseRelationshipsTableUpdateCompanionBuilder,
          (ExerciseRelationship, $$ExerciseRelationshipsTableReferences),
          ExerciseRelationship,
          PrefetchHooks Function({bool exerciseId, bool relatedExerciseId})
        > {
  $$ExerciseRelationshipsTableTableManager(
    _$AppDatabase db,
    $ExerciseRelationshipsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExerciseRelationshipsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ExerciseRelationshipsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ExerciseRelationshipsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> exerciseId = const Value.absent(),
                Value<int> relatedExerciseId = const Value.absent(),
                Value<String> relationshipType = const Value.absent(),
              }) => ExerciseRelationshipsCompanion(
                id: id,
                exerciseId: exerciseId,
                relatedExerciseId: relatedExerciseId,
                relationshipType: relationshipType,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int exerciseId,
                required int relatedExerciseId,
                required String relationshipType,
              }) => ExerciseRelationshipsCompanion.insert(
                id: id,
                exerciseId: exerciseId,
                relatedExerciseId: relatedExerciseId,
                relationshipType: relationshipType,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $ExerciseRelationshipsTable,
                    ExerciseRelationship
                  >(table),
                  $$ExerciseRelationshipsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({exerciseId = false, relatedExerciseId = false}) {
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
                        if (exerciseId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.exerciseId,
                            referencedTable:
                                $$ExerciseRelationshipsTableReferences
                                    ._exerciseIdTable(db),
                            referencedColumn:
                                $$ExerciseRelationshipsTableReferences
                                    ._exerciseIdTable(db)
                                    .id,
                          ) as T;
                        }
                        if (relatedExerciseId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.relatedExerciseId,
                            referencedTable:
                                $$ExerciseRelationshipsTableReferences
                                    ._relatedExerciseIdTable(db),
                            referencedColumn:
                                $$ExerciseRelationshipsTableReferences
                                    ._relatedExerciseIdTable(db)
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

typedef $$ExerciseRelationshipsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExerciseRelationshipsTable,
      ExerciseRelationship,
      $$ExerciseRelationshipsTableFilterComposer,
      $$ExerciseRelationshipsTableOrderingComposer,
      $$ExerciseRelationshipsTableAnnotationComposer,
      $$ExerciseRelationshipsTableCreateCompanionBuilder,
      $$ExerciseRelationshipsTableUpdateCompanionBuilder,
      (ExerciseRelationship, $$ExerciseRelationshipsTableReferences),
      ExerciseRelationship,
      PrefetchHooks Function({bool exerciseId, bool relatedExerciseId})
    >;
typedef $$WorkoutsTableCreateCompanionBuilder = WorkoutsCompanion Function({
  Value<int> id,
  required int userId,
  required String name,
  required String goal,
  required String difficulty,
  required int daysPerWeek,
  required int estimatedDurationMinutes,
  Value<bool> isActive,
  required DateTime createdAt,
});
typedef $$WorkoutsTableUpdateCompanionBuilder = WorkoutsCompanion Function({
  Value<int> id,
  Value<int> userId,
  Value<String> name,
  Value<String> goal,
  Value<String> difficulty,
  Value<int> daysPerWeek,
  Value<int> estimatedDurationMinutes,
  Value<bool> isActive,
  Value<DateTime> createdAt,
});

final class $$WorkoutsTableReferences
    extends BaseReferences<_$AppDatabase, $WorkoutsTable, Workout> {
  $$WorkoutsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('workouts__user_id__users__id');

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$WorkoutExercisesTable, List<WorkoutExercise>>
  _workoutExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutExercises,
    aliasName: 'workouts__id__workout_exercises__workout_id',
  );

  $$WorkoutExercisesTableProcessedTableManager get workoutExercisesRefs {
    final manager = $$WorkoutExercisesTableTableManager(
      $_db,
      $_db.workoutExercises,
    ).filter((f) => f.workoutId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SessionsTable, List<Session>> _sessionsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.sessions,
    aliasName: 'workouts__id__sessions__workout_id',
  );

  $$SessionsTableProcessedTableManager get sessionsRefs {
    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.workoutId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_sessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutsTable> {
  $$WorkoutsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goal => $composableBuilder(
    column: $table.goal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get daysPerWeek => $composableBuilder(
    column: $table.daysPerWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimatedDurationMinutes => $composableBuilder(
    column: $table.estimatedDurationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> workoutExercisesRefs(
    Expression<bool> Function($$WorkoutExercisesTableFilterComposer f) f,
  ) {
    final $$WorkoutExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutExercises,
      getReferencedColumn: (t) => t.workoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExercisesTableFilterComposer(
            $db: $db,
            $table: $db.workoutExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sessionsRefs(
    Expression<bool> Function($$SessionsTableFilterComposer f) f,
  ) {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.workoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutsTable> {
  $$WorkoutsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goal => $composableBuilder(
    column: $table.goal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get daysPerWeek => $composableBuilder(
    column: $table.daysPerWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedDurationMinutes => $composableBuilder(
    column: $table.estimatedDurationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutsTable> {
  $$WorkoutsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get goal =>
      $composableBuilder(column: $table.goal, builder: (column) => column);

  GeneratedColumn<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<int> get daysPerWeek => $composableBuilder(
    column: $table.daysPerWeek,
    builder: (column) => column,
  );

  GeneratedColumn<int> get estimatedDurationMinutes => $composableBuilder(
    column: $table.estimatedDurationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> workoutExercisesRefs<T extends Object>(
    Expression<T> Function($$WorkoutExercisesTableAnnotationComposer a) f,
  ) {
    final $$WorkoutExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutExercises,
      getReferencedColumn: (t) => t.workoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> sessionsRefs<T extends Object>(
    Expression<T> Function($$SessionsTableAnnotationComposer a) f,
  ) {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.workoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutsTable,
          Workout,
          $$WorkoutsTableFilterComposer,
          $$WorkoutsTableOrderingComposer,
          $$WorkoutsTableAnnotationComposer,
          $$WorkoutsTableCreateCompanionBuilder,
          $$WorkoutsTableUpdateCompanionBuilder,
          (Workout, $$WorkoutsTableReferences),
          Workout,
          PrefetchHooks Function({
            bool userId,
            bool workoutExercisesRefs,
            bool sessionsRefs,
          })
        > {
  $$WorkoutsTableTableManager(_$AppDatabase db, $WorkoutsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> goal = const Value.absent(),
                Value<String> difficulty = const Value.absent(),
                Value<int> daysPerWeek = const Value.absent(),
                Value<int> estimatedDurationMinutes = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => WorkoutsCompanion(
                id: id,
                userId: userId,
                name: name,
                goal: goal,
                difficulty: difficulty,
                daysPerWeek: daysPerWeek,
                estimatedDurationMinutes: estimatedDurationMinutes,
                isActive: isActive,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                required String name,
                required String goal,
                required String difficulty,
                required int daysPerWeek,
                required int estimatedDurationMinutes,
                Value<bool> isActive = const Value.absent(),
                required DateTime createdAt,
              }) => WorkoutsCompanion.insert(
                id: id,
                userId: userId,
                name: name,
                goal: goal,
                difficulty: difficulty,
                daysPerWeek: daysPerWeek,
                estimatedDurationMinutes: estimatedDurationMinutes,
                isActive: isActive,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutsTable, Workout>(table),
                  $$WorkoutsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                userId = false,
                workoutExercisesRefs = false,
                sessionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (workoutExercisesRefs) db.workoutExercises,
                    if (sessionsRefs) db.sessions,
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
                        if (userId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.userId,
                            referencedTable: $$WorkoutsTableReferences
                                ._userIdTable(db),
                            referencedColumn: $$WorkoutsTableReferences
                                ._userIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (workoutExercisesRefs)
                        await $_getPrefetchedData<
                          Workout,
                          $WorkoutsTable,
                          WorkoutExercise
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutsTableReferences
                              ._workoutExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutsTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutExercisesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.workoutId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (sessionsRefs)
                        await $_getPrefetchedData<
                          Workout,
                          $WorkoutsTable,
                          Session
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutsTableReferences
                              ._sessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutsTableReferences(
                                db,
                                table,
                                p0,
                              ).sessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.workoutId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WorkoutsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutsTable,
      Workout,
      $$WorkoutsTableFilterComposer,
      $$WorkoutsTableOrderingComposer,
      $$WorkoutsTableAnnotationComposer,
      $$WorkoutsTableCreateCompanionBuilder,
      $$WorkoutsTableUpdateCompanionBuilder,
      (Workout, $$WorkoutsTableReferences),
      Workout,
      PrefetchHooks Function({
        bool userId,
        bool workoutExercisesRefs,
        bool sessionsRefs,
      })
    >;
typedef $$WorkoutExercisesTableCreateCompanionBuilder =
    WorkoutExercisesCompanion Function({
      Value<int> id,
      required int workoutId,
      required int exerciseId,
      required int orderIndex,
      required int sets,
      required int minReps,
      required int maxReps,
      required int restSeconds,
      required String setType,
    });
typedef $$WorkoutExercisesTableUpdateCompanionBuilder =
    WorkoutExercisesCompanion Function({
      Value<int> id,
      Value<int> workoutId,
      Value<int> exerciseId,
      Value<int> orderIndex,
      Value<int> sets,
      Value<int> minReps,
      Value<int> maxReps,
      Value<int> restSeconds,
      Value<String> setType,
    });

final class $$WorkoutExercisesTableReferences
    extends
        BaseReferences<_$AppDatabase, $WorkoutExercisesTable, WorkoutExercise> {
  $$WorkoutExercisesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkoutsTable _workoutIdTable(_$AppDatabase db) =>
      db.workouts.createAlias('workout_exercises__workout_id__workouts__id');

  $$WorkoutsTableProcessedTableManager get workoutId {
    final $_column = $_itemColumn<int>('workout_id')!;

    final manager = $$WorkoutsTableTableManager(
      $_db,
      $_db.workouts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workoutIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExercisesTable _exerciseIdTable(_$AppDatabase db) =>
      db.exercises.createAlias('workout_exercises__exercise_id__exercises__id');

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<int>('exercise_id')!;

    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WorkoutExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutExercisesTable> {
  $$WorkoutExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sets => $composableBuilder(
    column: $table.sets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minReps => $composableBuilder(
    column: $table.minReps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxReps => $composableBuilder(
    column: $table.maxReps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get setType => $composableBuilder(
    column: $table.setType,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutsTableFilterComposer get workoutId {
    final $$WorkoutsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableFilterComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutExercisesTable> {
  $$WorkoutExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sets => $composableBuilder(
    column: $table.sets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minReps => $composableBuilder(
    column: $table.minReps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxReps => $composableBuilder(
    column: $table.maxReps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get setType => $composableBuilder(
    column: $table.setType,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutsTableOrderingComposer get workoutId {
    final $$WorkoutsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableOrderingComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutExercisesTable> {
  $$WorkoutExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sets =>
      $composableBuilder(column: $table.sets, builder: (column) => column);

  GeneratedColumn<int> get minReps =>
      $composableBuilder(column: $table.minReps, builder: (column) => column);

  GeneratedColumn<int> get maxReps =>
      $composableBuilder(column: $table.maxReps, builder: (column) => column);

  GeneratedColumn<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get setType =>
      $composableBuilder(column: $table.setType, builder: (column) => column);

  $$WorkoutsTableAnnotationComposer get workoutId {
    final $$WorkoutsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableAnnotationComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutExercisesTable,
          WorkoutExercise,
          $$WorkoutExercisesTableFilterComposer,
          $$WorkoutExercisesTableOrderingComposer,
          $$WorkoutExercisesTableAnnotationComposer,
          $$WorkoutExercisesTableCreateCompanionBuilder,
          $$WorkoutExercisesTableUpdateCompanionBuilder,
          (WorkoutExercise, $$WorkoutExercisesTableReferences),
          WorkoutExercise,
          PrefetchHooks Function({bool workoutId, bool exerciseId})
        > {
  $$WorkoutExercisesTableTableManager(
    _$AppDatabase db,
    $WorkoutExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> workoutId = const Value.absent(),
                Value<int> exerciseId = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<int> sets = const Value.absent(),
                Value<int> minReps = const Value.absent(),
                Value<int> maxReps = const Value.absent(),
                Value<int> restSeconds = const Value.absent(),
                Value<String> setType = const Value.absent(),
              }) => WorkoutExercisesCompanion(
                id: id,
                workoutId: workoutId,
                exerciseId: exerciseId,
                orderIndex: orderIndex,
                sets: sets,
                minReps: minReps,
                maxReps: maxReps,
                restSeconds: restSeconds,
                setType: setType,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int workoutId,
                required int exerciseId,
                required int orderIndex,
                required int sets,
                required int minReps,
                required int maxReps,
                required int restSeconds,
                required String setType,
              }) => WorkoutExercisesCompanion.insert(
                id: id,
                workoutId: workoutId,
                exerciseId: exerciseId,
                orderIndex: orderIndex,
                sets: sets,
                minReps: minReps,
                maxReps: maxReps,
                restSeconds: restSeconds,
                setType: setType,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutExercisesTable, WorkoutExercise>(table),
                  $$WorkoutExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workoutId = false, exerciseId = false}) {
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
                    if (workoutId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.workoutId,
                        referencedTable: $$WorkoutExercisesTableReferences
                            ._workoutIdTable(db),
                        referencedColumn: $$WorkoutExercisesTableReferences
                            ._workoutIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (exerciseId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.exerciseId,
                        referencedTable: $$WorkoutExercisesTableReferences
                            ._exerciseIdTable(db),
                        referencedColumn: $$WorkoutExercisesTableReferences
                            ._exerciseIdTable(db)
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

typedef $$WorkoutExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutExercisesTable,
      WorkoutExercise,
      $$WorkoutExercisesTableFilterComposer,
      $$WorkoutExercisesTableOrderingComposer,
      $$WorkoutExercisesTableAnnotationComposer,
      $$WorkoutExercisesTableCreateCompanionBuilder,
      $$WorkoutExercisesTableUpdateCompanionBuilder,
      (WorkoutExercise, $$WorkoutExercisesTableReferences),
      WorkoutExercise,
      PrefetchHooks Function({bool workoutId, bool exerciseId})
    >;
typedef $$SessionsTableCreateCompanionBuilder = SessionsCompanion Function({
  Value<int> id,
  required int userId,
  Value<int?> workoutId,
  required DateTime startedAt,
  Value<DateTime?> completedAt,
  Value<int?> durationSeconds,
  required String status,
});
typedef $$SessionsTableUpdateCompanionBuilder = SessionsCompanion Function({
  Value<int> id,
  Value<int> userId,
  Value<int?> workoutId,
  Value<DateTime> startedAt,
  Value<DateTime?> completedAt,
  Value<int?> durationSeconds,
  Value<String> status,
});

final class $$SessionsTableReferences
    extends BaseReferences<_$AppDatabase, $SessionsTable, Session> {
  $$SessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('sessions__user_id__users__id');

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $WorkoutsTable _workoutIdTable(_$AppDatabase db) =>
      db.workouts.createAlias('sessions__workout_id__workouts__id');

  $$WorkoutsTableProcessedTableManager? get workoutId {
    final $_column = $_itemColumn<int>('workout_id');
    if ($_column == null) return null;
    final manager = $$WorkoutsTableTableManager(
      $_db,
      $_db.workouts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workoutIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SessionExercisesTable, List<SessionExercise>>
  _sessionExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sessionExercises,
    aliasName: 'sessions__id__session_exercises__session_id',
  );

  $$SessionExercisesTableProcessedTableManager get sessionExercisesRefs {
    final manager = $$SessionExercisesTableTableManager(
      $_db,
      $_db.sessionExercises,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _sessionExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SessionsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorkoutsTableFilterComposer get workoutId {
    final $$WorkoutsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableFilterComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> sessionExercisesRefs(
    Expression<bool> Function($$SessionExercisesTableFilterComposer f) f,
  ) {
    final $$SessionExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionExercises,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionExercisesTableFilterComposer(
            $db: $db,
            $table: $db.sessionExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorkoutsTableOrderingComposer get workoutId {
    final $$WorkoutsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableOrderingComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorkoutsTableAnnotationComposer get workoutId {
    final $$WorkoutsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableAnnotationComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> sessionExercisesRefs<T extends Object>(
    Expression<T> Function($$SessionExercisesTableAnnotationComposer a) f,
  ) {
    final $$SessionExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionExercises,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.sessionExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionsTable,
          Session,
          $$SessionsTableFilterComposer,
          $$SessionsTableOrderingComposer,
          $$SessionsTableAnnotationComposer,
          $$SessionsTableCreateCompanionBuilder,
          $$SessionsTableUpdateCompanionBuilder,
          (Session, $$SessionsTableReferences),
          Session,
          PrefetchHooks Function({
            bool userId,
            bool workoutId,
            bool sessionExercisesRefs,
          })
        > {
  $$SessionsTableTableManager(_$AppDatabase db, $SessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<int?> workoutId = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<String> status = const Value.absent(),
              }) => SessionsCompanion(
                id: id,
                userId: userId,
                workoutId: workoutId,
                startedAt: startedAt,
                completedAt: completedAt,
                durationSeconds: durationSeconds,
                status: status,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                Value<int?> workoutId = const Value.absent(),
                required DateTime startedAt,
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                required String status,
              }) => SessionsCompanion.insert(
                id: id,
                userId: userId,
                workoutId: workoutId,
                startedAt: startedAt,
                completedAt: completedAt,
                durationSeconds: durationSeconds,
                status: status,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SessionsTable, Session>(table),
                  $$SessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                userId = false,
                workoutId = false,
                sessionExercisesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (sessionExercisesRefs) db.sessionExercises,
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
                        if (userId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.userId,
                            referencedTable: $$SessionsTableReferences
                                ._userIdTable(db),
                            referencedColumn: $$SessionsTableReferences
                                ._userIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (workoutId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.workoutId,
                            referencedTable: $$SessionsTableReferences
                                ._workoutIdTable(db),
                            referencedColumn: $$SessionsTableReferences
                                ._workoutIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (sessionExercisesRefs)
                        await $_getPrefetchedData<
                          Session,
                          $SessionsTable,
                          SessionExercise
                        >(
                          currentTable: table,
                          referencedTable: $$SessionsTableReferences
                              ._sessionExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).sessionExercisesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionsTable,
      Session,
      $$SessionsTableFilterComposer,
      $$SessionsTableOrderingComposer,
      $$SessionsTableAnnotationComposer,
      $$SessionsTableCreateCompanionBuilder,
      $$SessionsTableUpdateCompanionBuilder,
      (Session, $$SessionsTableReferences),
      Session,
      PrefetchHooks Function({
        bool userId,
        bool workoutId,
        bool sessionExercisesRefs,
      })
    >;
typedef $$SessionExercisesTableCreateCompanionBuilder =
    SessionExercisesCompanion Function({
      Value<int> id,
      required int sessionId,
      required int exerciseId,
      required int orderIndex,
    });
typedef $$SessionExercisesTableUpdateCompanionBuilder =
    SessionExercisesCompanion Function({
      Value<int> id,
      Value<int> sessionId,
      Value<int> exerciseId,
      Value<int> orderIndex,
    });

final class $$SessionExercisesTableReferences
    extends
        BaseReferences<_$AppDatabase, $SessionExercisesTable, SessionExercise> {
  $$SessionExercisesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.sessions.createAlias('session_exercises__session_id__sessions__id');

  $$SessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExercisesTable _exerciseIdTable(_$AppDatabase db) =>
      db.exercises.createAlias('session_exercises__exercise_id__exercises__id');

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<int>('exercise_id')!;

    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$WorkoutSetsTable, List<WorkoutSet>>
  _workoutSetsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutSets,
    aliasName: 'session_exercises__id__workout_sets__session_exercise_id',
  );

  $$WorkoutSetsTableProcessedTableManager get workoutSetsRefs {
    final manager = $$WorkoutSetsTableTableManager(
      $_db,
      $_db.workoutSets,
    ).filter((f) => f.sessionExerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_workoutSetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SessionExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $SessionExercisesTable> {
  $$SessionExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  $$SessionsTableFilterComposer get sessionId {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> workoutSetsRefs(
    Expression<bool> Function($$WorkoutSetsTableFilterComposer f) f,
  ) {
    final $$WorkoutSetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSets,
      getReferencedColumn: (t) => t.sessionExerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionExercisesTable> {
  $$SessionExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  $$SessionsTableOrderingComposer get sessionId {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableOrderingComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionExercisesTable> {
  $$SessionExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  $$SessionsTableAnnotationComposer get sessionId {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> workoutSetsRefs<T extends Object>(
    Expression<T> Function($$WorkoutSetsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutSetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSets,
      getReferencedColumn: (t) => t.sessionExerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionExercisesTable,
          SessionExercise,
          $$SessionExercisesTableFilterComposer,
          $$SessionExercisesTableOrderingComposer,
          $$SessionExercisesTableAnnotationComposer,
          $$SessionExercisesTableCreateCompanionBuilder,
          $$SessionExercisesTableUpdateCompanionBuilder,
          (SessionExercise, $$SessionExercisesTableReferences),
          SessionExercise,
          PrefetchHooks Function({
            bool sessionId,
            bool exerciseId,
            bool workoutSetsRefs,
          })
        > {
  $$SessionExercisesTableTableManager(
    _$AppDatabase db,
    $SessionExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionId = const Value.absent(),
                Value<int> exerciseId = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
              }) => SessionExercisesCompanion(
                id: id,
                sessionId: sessionId,
                exerciseId: exerciseId,
                orderIndex: orderIndex,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionId,
                required int exerciseId,
                required int orderIndex,
              }) => SessionExercisesCompanion.insert(
                id: id,
                sessionId: sessionId,
                exerciseId: exerciseId,
                orderIndex: orderIndex,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SessionExercisesTable, SessionExercise>(table),
                  $$SessionExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                sessionId = false,
                exerciseId = false,
                workoutSetsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (workoutSetsRefs) db.workoutSets,
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
                        if (sessionId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.sessionId,
                            referencedTable: $$SessionExercisesTableReferences
                                ._sessionIdTable(db),
                            referencedColumn: $$SessionExercisesTableReferences
                                ._sessionIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (exerciseId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.exerciseId,
                            referencedTable: $$SessionExercisesTableReferences
                                ._exerciseIdTable(db),
                            referencedColumn: $$SessionExercisesTableReferences
                                ._exerciseIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (workoutSetsRefs)
                        await $_getPrefetchedData<
                          SessionExercise,
                          $SessionExercisesTable,
                          WorkoutSet
                        >(
                          currentTable: table,
                          referencedTable: $$SessionExercisesTableReferences
                              ._workoutSetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SessionExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutSetsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionExerciseId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SessionExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionExercisesTable,
      SessionExercise,
      $$SessionExercisesTableFilterComposer,
      $$SessionExercisesTableOrderingComposer,
      $$SessionExercisesTableAnnotationComposer,
      $$SessionExercisesTableCreateCompanionBuilder,
      $$SessionExercisesTableUpdateCompanionBuilder,
      (SessionExercise, $$SessionExercisesTableReferences),
      SessionExercise,
      PrefetchHooks Function({
        bool sessionId,
        bool exerciseId,
        bool workoutSetsRefs,
      })
    >;
typedef $$WorkoutSetsTableCreateCompanionBuilder =
    WorkoutSetsCompanion Function({
      Value<int> id,
      required int sessionExerciseId,
      required int setIndex,
      Value<double?> weightKg,
      required int repetitions,
      required String setType,
    });
typedef $$WorkoutSetsTableUpdateCompanionBuilder =
    WorkoutSetsCompanion Function({
      Value<int> id,
      Value<int> sessionExerciseId,
      Value<int> setIndex,
      Value<double?> weightKg,
      Value<int> repetitions,
      Value<String> setType,
    });

final class $$WorkoutSetsTableReferences
    extends BaseReferences<_$AppDatabase, $WorkoutSetsTable, WorkoutSet> {
  $$WorkoutSetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SessionExercisesTable _sessionExerciseIdTable(_$AppDatabase db) => db
      .sessionExercises
      .createAlias('workout_sets__session_exercise_id__session_exercises__id');

  $$SessionExercisesTableProcessedTableManager get sessionExerciseId {
    final $_column = $_itemColumn<int>('session_exercise_id')!;

    final manager = $$SessionExercisesTableTableManager(
      $_db,
      $_db.sessionExercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionExerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WorkoutSetsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get setIndex => $composableBuilder(
    column: $table.setIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get setType => $composableBuilder(
    column: $table.setType,
    builder: (column) => ColumnFilters(column),
  );

  $$SessionExercisesTableFilterComposer get sessionExerciseId {
    final $$SessionExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionExerciseId,
      referencedTable: $db.sessionExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionExercisesTableFilterComposer(
            $db: $db,
            $table: $db.sessionExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get setIndex => $composableBuilder(
    column: $table.setIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get setType => $composableBuilder(
    column: $table.setType,
    builder: (column) => ColumnOrderings(column),
  );

  $$SessionExercisesTableOrderingComposer get sessionExerciseId {
    final $$SessionExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionExerciseId,
      referencedTable: $db.sessionExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.sessionExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get setIndex =>
      $composableBuilder(column: $table.setIndex, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get setType =>
      $composableBuilder(column: $table.setType, builder: (column) => column);

  $$SessionExercisesTableAnnotationComposer get sessionExerciseId {
    final $$SessionExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionExerciseId,
      referencedTable: $db.sessionExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.sessionExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSetsTable,
          WorkoutSet,
          $$WorkoutSetsTableFilterComposer,
          $$WorkoutSetsTableOrderingComposer,
          $$WorkoutSetsTableAnnotationComposer,
          $$WorkoutSetsTableCreateCompanionBuilder,
          $$WorkoutSetsTableUpdateCompanionBuilder,
          (WorkoutSet, $$WorkoutSetsTableReferences),
          WorkoutSet,
          PrefetchHooks Function({bool sessionExerciseId})
        > {
  $$WorkoutSetsTableTableManager(_$AppDatabase db, $WorkoutSetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionExerciseId = const Value.absent(),
                Value<int> setIndex = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<int> repetitions = const Value.absent(),
                Value<String> setType = const Value.absent(),
              }) => WorkoutSetsCompanion(
                id: id,
                sessionExerciseId: sessionExerciseId,
                setIndex: setIndex,
                weightKg: weightKg,
                repetitions: repetitions,
                setType: setType,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionExerciseId,
                required int setIndex,
                Value<double?> weightKg = const Value.absent(),
                required int repetitions,
                required String setType,
              }) => WorkoutSetsCompanion.insert(
                id: id,
                sessionExerciseId: sessionExerciseId,
                setIndex: setIndex,
                weightKg: weightKg,
                repetitions: repetitions,
                setType: setType,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutSetsTable, WorkoutSet>(table),
                  $$WorkoutSetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionExerciseId = false}) {
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
                    if (sessionExerciseId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sessionExerciseId,
                        referencedTable: $$WorkoutSetsTableReferences
                            ._sessionExerciseIdTable(db),
                        referencedColumn: $$WorkoutSetsTableReferences
                            ._sessionExerciseIdTable(db)
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

typedef $$WorkoutSetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSetsTable,
      WorkoutSet,
      $$WorkoutSetsTableFilterComposer,
      $$WorkoutSetsTableOrderingComposer,
      $$WorkoutSetsTableAnnotationComposer,
      $$WorkoutSetsTableCreateCompanionBuilder,
      $$WorkoutSetsTableUpdateCompanionBuilder,
      (WorkoutSet, $$WorkoutSetsTableReferences),
      WorkoutSet,
      PrefetchHooks Function({bool sessionExerciseId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$WeightEntriesTableTableManager get weightEntries =>
      $$WeightEntriesTableTableManager(_db, _db.weightEntries);
  $$GoalsTableTableManager get goals =>
      $$GoalsTableTableManager(_db, _db.goals);
  $$EquipmentTableTableManager get equipment =>
      $$EquipmentTableTableManager(_db, _db.equipment);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db, _db.exercises);
  $$ExerciseEquipmentTableTableManager get exerciseEquipment =>
      $$ExerciseEquipmentTableTableManager(_db, _db.exerciseEquipment);
  $$ExerciseRelationshipsTableTableManager get exerciseRelationships =>
      $$ExerciseRelationshipsTableTableManager(_db, _db.exerciseRelationships);
  $$WorkoutsTableTableManager get workouts =>
      $$WorkoutsTableTableManager(_db, _db.workouts);
  $$WorkoutExercisesTableTableManager get workoutExercises =>
      $$WorkoutExercisesTableTableManager(_db, _db.workoutExercises);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$SessionExercisesTableTableManager get sessionExercises =>
      $$SessionExercisesTableTableManager(_db, _db.sessionExercises);
  $$WorkoutSetsTableTableManager get workoutSets =>
      $$WorkoutSetsTableTableManager(_db, _db.workoutSets);
}
