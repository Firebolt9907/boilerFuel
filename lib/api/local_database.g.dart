// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// ignore_for_file: type=lint
class $UsersTableTable extends UsersTable
    with TableInfo<$UsersTableTable, UsersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _uidMeta = const VerificationMeta('uid');
  @override
  late final GeneratedColumn<String> uid = GeneratedColumn<String>(
    'uid',
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
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
    'age',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<int> weight = GeneratedColumn<int>(
    'weight',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
    'height',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
  static const VerificationMeta _dietaryRestrictionsMeta =
      const VerificationMeta('dietaryRestrictions');
  @override
  late final GeneratedColumn<String> dietaryRestrictions =
      GeneratedColumn<String>(
        'dietary_restrictions',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _mealPlanMeta = const VerificationMeta(
    'mealPlan',
  );
  @override
  late final GeneratedColumn<String> mealPlan = GeneratedColumn<String>(
    'meal_plan',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _diningCourtRankingMeta =
      const VerificationMeta('diningCourtRanking');
  @override
  late final GeneratedColumn<String> diningCourtRanking =
      GeneratedColumn<String>(
        'dining_court_ranking',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    uid,
    name,
    gender,
    age,
    weight,
    height,
    goal,
    dietaryRestrictions,
    mealPlan,
    diningCourtRanking,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UsersTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uid')) {
      context.handle(
        _uidMeta,
        uid.isAcceptableOrUnknown(data['uid']!, _uidMeta),
      );
    } else if (isInserting) {
      context.missing(_uidMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    } else if (isInserting) {
      context.missing(_genderMeta);
    }
    if (data.containsKey('age')) {
      context.handle(
        _ageMeta,
        age.isAcceptableOrUnknown(data['age']!, _ageMeta),
      );
    } else if (isInserting) {
      context.missing(_ageMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    } else if (isInserting) {
      context.missing(_weightMeta);
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    } else if (isInserting) {
      context.missing(_heightMeta);
    }
    if (data.containsKey('goal')) {
      context.handle(
        _goalMeta,
        goal.isAcceptableOrUnknown(data['goal']!, _goalMeta),
      );
    } else if (isInserting) {
      context.missing(_goalMeta);
    }
    if (data.containsKey('dietary_restrictions')) {
      context.handle(
        _dietaryRestrictionsMeta,
        dietaryRestrictions.isAcceptableOrUnknown(
          data['dietary_restrictions']!,
          _dietaryRestrictionsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dietaryRestrictionsMeta);
    }
    if (data.containsKey('meal_plan')) {
      context.handle(
        _mealPlanMeta,
        mealPlan.isAcceptableOrUnknown(data['meal_plan']!, _mealPlanMeta),
      );
    } else if (isInserting) {
      context.missing(_mealPlanMeta);
    }
    if (data.containsKey('dining_court_ranking')) {
      context.handle(
        _diningCourtRankingMeta,
        diningCourtRanking.isAcceptableOrUnknown(
          data['dining_court_ranking']!,
          _diningCourtRankingMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_diningCourtRankingMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UsersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsersTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uid'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      )!,
      age: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age'],
      )!,
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weight'],
      )!,
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height'],
      )!,
      goal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal'],
      )!,
      dietaryRestrictions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dietary_restrictions'],
      )!,
      mealPlan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_plan'],
      )!,
      diningCourtRanking: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dining_court_ranking'],
      )!,
    );
  }

  @override
  $UsersTableTable createAlias(String alias) {
    return $UsersTableTable(attachedDatabase, alias);
  }
}

class UsersTableData extends DataClass implements Insertable<UsersTableData> {
  final int id;
  final String uid;
  final String name;
  final String gender;
  final int age;
  final int weight;
  final int height;
  final String goal;
  final String dietaryRestrictions;
  final String mealPlan;
  final String diningCourtRanking;
  const UsersTableData({
    required this.id,
    required this.uid,
    required this.name,
    required this.gender,
    required this.age,
    required this.weight,
    required this.height,
    required this.goal,
    required this.dietaryRestrictions,
    required this.mealPlan,
    required this.diningCourtRanking,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uid'] = Variable<String>(uid);
    map['name'] = Variable<String>(name);
    map['gender'] = Variable<String>(gender);
    map['age'] = Variable<int>(age);
    map['weight'] = Variable<int>(weight);
    map['height'] = Variable<int>(height);
    map['goal'] = Variable<String>(goal);
    map['dietary_restrictions'] = Variable<String>(dietaryRestrictions);
    map['meal_plan'] = Variable<String>(mealPlan);
    map['dining_court_ranking'] = Variable<String>(diningCourtRanking);
    return map;
  }

  UsersTableCompanion toCompanion(bool nullToAbsent) {
    return UsersTableCompanion(
      id: Value(id),
      uid: Value(uid),
      name: Value(name),
      gender: Value(gender),
      age: Value(age),
      weight: Value(weight),
      height: Value(height),
      goal: Value(goal),
      dietaryRestrictions: Value(dietaryRestrictions),
      mealPlan: Value(mealPlan),
      diningCourtRanking: Value(diningCourtRanking),
    );
  }

  factory UsersTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsersTableData(
      id: serializer.fromJson<int>(json['id']),
      uid: serializer.fromJson<String>(json['uid']),
      name: serializer.fromJson<String>(json['name']),
      gender: serializer.fromJson<String>(json['gender']),
      age: serializer.fromJson<int>(json['age']),
      weight: serializer.fromJson<int>(json['weight']),
      height: serializer.fromJson<int>(json['height']),
      goal: serializer.fromJson<String>(json['goal']),
      dietaryRestrictions: serializer.fromJson<String>(
        json['dietaryRestrictions'],
      ),
      mealPlan: serializer.fromJson<String>(json['mealPlan']),
      diningCourtRanking: serializer.fromJson<String>(
        json['diningCourtRanking'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uid': serializer.toJson<String>(uid),
      'name': serializer.toJson<String>(name),
      'gender': serializer.toJson<String>(gender),
      'age': serializer.toJson<int>(age),
      'weight': serializer.toJson<int>(weight),
      'height': serializer.toJson<int>(height),
      'goal': serializer.toJson<String>(goal),
      'dietaryRestrictions': serializer.toJson<String>(dietaryRestrictions),
      'mealPlan': serializer.toJson<String>(mealPlan),
      'diningCourtRanking': serializer.toJson<String>(diningCourtRanking),
    };
  }

  UsersTableData copyWith({
    int? id,
    String? uid,
    String? name,
    String? gender,
    int? age,
    int? weight,
    int? height,
    String? goal,
    String? dietaryRestrictions,
    String? mealPlan,
    String? diningCourtRanking,
  }) => UsersTableData(
    id: id ?? this.id,
    uid: uid ?? this.uid,
    name: name ?? this.name,
    gender: gender ?? this.gender,
    age: age ?? this.age,
    weight: weight ?? this.weight,
    height: height ?? this.height,
    goal: goal ?? this.goal,
    dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
    mealPlan: mealPlan ?? this.mealPlan,
    diningCourtRanking: diningCourtRanking ?? this.diningCourtRanking,
  );
  UsersTableData copyWithCompanion(UsersTableCompanion data) {
    return UsersTableData(
      id: data.id.present ? data.id.value : this.id,
      uid: data.uid.present ? data.uid.value : this.uid,
      name: data.name.present ? data.name.value : this.name,
      gender: data.gender.present ? data.gender.value : this.gender,
      age: data.age.present ? data.age.value : this.age,
      weight: data.weight.present ? data.weight.value : this.weight,
      height: data.height.present ? data.height.value : this.height,
      goal: data.goal.present ? data.goal.value : this.goal,
      dietaryRestrictions: data.dietaryRestrictions.present
          ? data.dietaryRestrictions.value
          : this.dietaryRestrictions,
      mealPlan: data.mealPlan.present ? data.mealPlan.value : this.mealPlan,
      diningCourtRanking: data.diningCourtRanking.present
          ? data.diningCourtRanking.value
          : this.diningCourtRanking,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsersTableData(')
          ..write('id: $id, ')
          ..write('uid: $uid, ')
          ..write('name: $name, ')
          ..write('gender: $gender, ')
          ..write('age: $age, ')
          ..write('weight: $weight, ')
          ..write('height: $height, ')
          ..write('goal: $goal, ')
          ..write('dietaryRestrictions: $dietaryRestrictions, ')
          ..write('mealPlan: $mealPlan, ')
          ..write('diningCourtRanking: $diningCourtRanking')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    uid,
    name,
    gender,
    age,
    weight,
    height,
    goal,
    dietaryRestrictions,
    mealPlan,
    diningCourtRanking,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsersTableData &&
          other.id == this.id &&
          other.uid == this.uid &&
          other.name == this.name &&
          other.gender == this.gender &&
          other.age == this.age &&
          other.weight == this.weight &&
          other.height == this.height &&
          other.goal == this.goal &&
          other.dietaryRestrictions == this.dietaryRestrictions &&
          other.mealPlan == this.mealPlan &&
          other.diningCourtRanking == this.diningCourtRanking);
}

class UsersTableCompanion extends UpdateCompanion<UsersTableData> {
  final Value<int> id;
  final Value<String> uid;
  final Value<String> name;
  final Value<String> gender;
  final Value<int> age;
  final Value<int> weight;
  final Value<int> height;
  final Value<String> goal;
  final Value<String> dietaryRestrictions;
  final Value<String> mealPlan;
  final Value<String> diningCourtRanking;
  const UsersTableCompanion({
    this.id = const Value.absent(),
    this.uid = const Value.absent(),
    this.name = const Value.absent(),
    this.gender = const Value.absent(),
    this.age = const Value.absent(),
    this.weight = const Value.absent(),
    this.height = const Value.absent(),
    this.goal = const Value.absent(),
    this.dietaryRestrictions = const Value.absent(),
    this.mealPlan = const Value.absent(),
    this.diningCourtRanking = const Value.absent(),
  });
  UsersTableCompanion.insert({
    this.id = const Value.absent(),
    required String uid,
    required String name,
    required String gender,
    required int age,
    required int weight,
    required int height,
    required String goal,
    required String dietaryRestrictions,
    required String mealPlan,
    required String diningCourtRanking,
  }) : uid = Value(uid),
       name = Value(name),
       gender = Value(gender),
       age = Value(age),
       weight = Value(weight),
       height = Value(height),
       goal = Value(goal),
       dietaryRestrictions = Value(dietaryRestrictions),
       mealPlan = Value(mealPlan),
       diningCourtRanking = Value(diningCourtRanking);
  static Insertable<UsersTableData> custom({
    Expression<int>? id,
    Expression<String>? uid,
    Expression<String>? name,
    Expression<String>? gender,
    Expression<int>? age,
    Expression<int>? weight,
    Expression<int>? height,
    Expression<String>? goal,
    Expression<String>? dietaryRestrictions,
    Expression<String>? mealPlan,
    Expression<String>? diningCourtRanking,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uid != null) 'uid': uid,
      if (name != null) 'name': name,
      if (gender != null) 'gender': gender,
      if (age != null) 'age': age,
      if (weight != null) 'weight': weight,
      if (height != null) 'height': height,
      if (goal != null) 'goal': goal,
      if (dietaryRestrictions != null)
        'dietary_restrictions': dietaryRestrictions,
      if (mealPlan != null) 'meal_plan': mealPlan,
      if (diningCourtRanking != null)
        'dining_court_ranking': diningCourtRanking,
    });
  }

  UsersTableCompanion copyWith({
    Value<int>? id,
    Value<String>? uid,
    Value<String>? name,
    Value<String>? gender,
    Value<int>? age,
    Value<int>? weight,
    Value<int>? height,
    Value<String>? goal,
    Value<String>? dietaryRestrictions,
    Value<String>? mealPlan,
    Value<String>? diningCourtRanking,
  }) {
    return UsersTableCompanion(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      goal: goal ?? this.goal,
      dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
      mealPlan: mealPlan ?? this.mealPlan,
      diningCourtRanking: diningCourtRanking ?? this.diningCourtRanking,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uid.present) {
      map['uid'] = Variable<String>(uid.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (weight.present) {
      map['weight'] = Variable<int>(weight.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (goal.present) {
      map['goal'] = Variable<String>(goal.value);
    }
    if (dietaryRestrictions.present) {
      map['dietary_restrictions'] = Variable<String>(dietaryRestrictions.value);
    }
    if (mealPlan.present) {
      map['meal_plan'] = Variable<String>(mealPlan.value);
    }
    if (diningCourtRanking.present) {
      map['dining_court_ranking'] = Variable<String>(diningCourtRanking.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersTableCompanion(')
          ..write('id: $id, ')
          ..write('uid: $uid, ')
          ..write('name: $name, ')
          ..write('gender: $gender, ')
          ..write('age: $age, ')
          ..write('weight: $weight, ')
          ..write('height: $height, ')
          ..write('goal: $goal, ')
          ..write('dietaryRestrictions: $dietaryRestrictions, ')
          ..write('mealPlan: $mealPlan, ')
          ..write('diningCourtRanking: $diningCourtRanking')
          ..write(')'))
        .toString();
  }
}

class $MealsTableTable extends MealsTable
    with TableInfo<$MealsTableTable, MealsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _diningCourtMeta = const VerificationMeta(
    'diningCourt',
  );
  @override
  late final GeneratedColumn<String> diningCourt = GeneratedColumn<String>(
    'dining_court',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mealTimeMeta = const VerificationMeta(
    'mealTime',
  );
  @override
  late final GeneratedColumn<String> mealTime = GeneratedColumn<String>(
    'meal_time',
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
  static const VerificationMeta _foodItemsMeta = const VerificationMeta(
    'foodItems',
  );
  @override
  late final GeneratedColumn<String> foodItems = GeneratedColumn<String>(
    'food_items',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalCaloriesMeta = const VerificationMeta(
    'totalCalories',
  );
  @override
  late final GeneratedColumn<double> totalCalories = GeneratedColumn<double>(
    'total_calories',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalProteinMeta = const VerificationMeta(
    'totalProtein',
  );
  @override
  late final GeneratedColumn<double> totalProtein = GeneratedColumn<double>(
    'total_protein',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalCarbsMeta = const VerificationMeta(
    'totalCarbs',
  );
  @override
  late final GeneratedColumn<double> totalCarbs = GeneratedColumn<double>(
    'total_carbs',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalFatsMeta = const VerificationMeta(
    'totalFats',
  );
  @override
  late final GeneratedColumn<double> totalFats = GeneratedColumn<double>(
    'total_fats',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastUpdatedMeta = const VerificationMeta(
    'lastUpdated',
  );
  @override
  late final GeneratedColumn<int> lastUpdated = GeneratedColumn<int>(
    'last_updated',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    diningCourt,
    date,
    mealTime,
    name,
    foodItems,
    totalCalories,
    totalProtein,
    totalCarbs,
    totalFats,
    lastUpdated,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meals_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('dining_court')) {
      context.handle(
        _diningCourtMeta,
        diningCourt.isAcceptableOrUnknown(
          data['dining_court']!,
          _diningCourtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_diningCourtMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('meal_time')) {
      context.handle(
        _mealTimeMeta,
        mealTime.isAcceptableOrUnknown(data['meal_time']!, _mealTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_mealTimeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('food_items')) {
      context.handle(
        _foodItemsMeta,
        foodItems.isAcceptableOrUnknown(data['food_items']!, _foodItemsMeta),
      );
    } else if (isInserting) {
      context.missing(_foodItemsMeta);
    }
    if (data.containsKey('total_calories')) {
      context.handle(
        _totalCaloriesMeta,
        totalCalories.isAcceptableOrUnknown(
          data['total_calories']!,
          _totalCaloriesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalCaloriesMeta);
    }
    if (data.containsKey('total_protein')) {
      context.handle(
        _totalProteinMeta,
        totalProtein.isAcceptableOrUnknown(
          data['total_protein']!,
          _totalProteinMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalProteinMeta);
    }
    if (data.containsKey('total_carbs')) {
      context.handle(
        _totalCarbsMeta,
        totalCarbs.isAcceptableOrUnknown(data['total_carbs']!, _totalCarbsMeta),
      );
    } else if (isInserting) {
      context.missing(_totalCarbsMeta);
    }
    if (data.containsKey('total_fats')) {
      context.handle(
        _totalFatsMeta,
        totalFats.isAcceptableOrUnknown(data['total_fats']!, _totalFatsMeta),
      );
    } else if (isInserting) {
      context.missing(_totalFatsMeta);
    }
    if (data.containsKey('last_updated')) {
      context.handle(
        _lastUpdatedMeta,
        lastUpdated.isAcceptableOrUnknown(
          data['last_updated']!,
          _lastUpdatedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      diningCourt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dining_court'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      mealTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_time'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      foodItems: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_items'],
      )!,
      totalCalories: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_calories'],
      )!,
      totalProtein: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_protein'],
      )!,
      totalCarbs: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_carbs'],
      )!,
      totalFats: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_fats'],
      )!,
      lastUpdated: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_updated'],
      )!,
    );
  }

  @override
  $MealsTableTable createAlias(String alias) {
    return $MealsTableTable(attachedDatabase, alias);
  }
}

class MealsTableData extends DataClass implements Insertable<MealsTableData> {
  final int id;
  final String diningCourt;
  final String date;
  final String mealTime;
  final String name;
  final String foodItems;
  final double totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFats;
  final int lastUpdated;
  const MealsTableData({
    required this.id,
    required this.diningCourt,
    required this.date,
    required this.mealTime,
    required this.name,
    required this.foodItems,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFats,
    required this.lastUpdated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['dining_court'] = Variable<String>(diningCourt);
    map['date'] = Variable<String>(date);
    map['meal_time'] = Variable<String>(mealTime);
    map['name'] = Variable<String>(name);
    map['food_items'] = Variable<String>(foodItems);
    map['total_calories'] = Variable<double>(totalCalories);
    map['total_protein'] = Variable<double>(totalProtein);
    map['total_carbs'] = Variable<double>(totalCarbs);
    map['total_fats'] = Variable<double>(totalFats);
    map['last_updated'] = Variable<int>(lastUpdated);
    return map;
  }

  MealsTableCompanion toCompanion(bool nullToAbsent) {
    return MealsTableCompanion(
      id: Value(id),
      diningCourt: Value(diningCourt),
      date: Value(date),
      mealTime: Value(mealTime),
      name: Value(name),
      foodItems: Value(foodItems),
      totalCalories: Value(totalCalories),
      totalProtein: Value(totalProtein),
      totalCarbs: Value(totalCarbs),
      totalFats: Value(totalFats),
      lastUpdated: Value(lastUpdated),
    );
  }

  factory MealsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealsTableData(
      id: serializer.fromJson<int>(json['id']),
      diningCourt: serializer.fromJson<String>(json['diningCourt']),
      date: serializer.fromJson<String>(json['date']),
      mealTime: serializer.fromJson<String>(json['mealTime']),
      name: serializer.fromJson<String>(json['name']),
      foodItems: serializer.fromJson<String>(json['foodItems']),
      totalCalories: serializer.fromJson<double>(json['totalCalories']),
      totalProtein: serializer.fromJson<double>(json['totalProtein']),
      totalCarbs: serializer.fromJson<double>(json['totalCarbs']),
      totalFats: serializer.fromJson<double>(json['totalFats']),
      lastUpdated: serializer.fromJson<int>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'diningCourt': serializer.toJson<String>(diningCourt),
      'date': serializer.toJson<String>(date),
      'mealTime': serializer.toJson<String>(mealTime),
      'name': serializer.toJson<String>(name),
      'foodItems': serializer.toJson<String>(foodItems),
      'totalCalories': serializer.toJson<double>(totalCalories),
      'totalProtein': serializer.toJson<double>(totalProtein),
      'totalCarbs': serializer.toJson<double>(totalCarbs),
      'totalFats': serializer.toJson<double>(totalFats),
      'lastUpdated': serializer.toJson<int>(lastUpdated),
    };
  }

  MealsTableData copyWith({
    int? id,
    String? diningCourt,
    String? date,
    String? mealTime,
    String? name,
    String? foodItems,
    double? totalCalories,
    double? totalProtein,
    double? totalCarbs,
    double? totalFats,
    int? lastUpdated,
  }) => MealsTableData(
    id: id ?? this.id,
    diningCourt: diningCourt ?? this.diningCourt,
    date: date ?? this.date,
    mealTime: mealTime ?? this.mealTime,
    name: name ?? this.name,
    foodItems: foodItems ?? this.foodItems,
    totalCalories: totalCalories ?? this.totalCalories,
    totalProtein: totalProtein ?? this.totalProtein,
    totalCarbs: totalCarbs ?? this.totalCarbs,
    totalFats: totalFats ?? this.totalFats,
    lastUpdated: lastUpdated ?? this.lastUpdated,
  );
  MealsTableData copyWithCompanion(MealsTableCompanion data) {
    return MealsTableData(
      id: data.id.present ? data.id.value : this.id,
      diningCourt: data.diningCourt.present
          ? data.diningCourt.value
          : this.diningCourt,
      date: data.date.present ? data.date.value : this.date,
      mealTime: data.mealTime.present ? data.mealTime.value : this.mealTime,
      name: data.name.present ? data.name.value : this.name,
      foodItems: data.foodItems.present ? data.foodItems.value : this.foodItems,
      totalCalories: data.totalCalories.present
          ? data.totalCalories.value
          : this.totalCalories,
      totalProtein: data.totalProtein.present
          ? data.totalProtein.value
          : this.totalProtein,
      totalCarbs: data.totalCarbs.present
          ? data.totalCarbs.value
          : this.totalCarbs,
      totalFats: data.totalFats.present ? data.totalFats.value : this.totalFats,
      lastUpdated: data.lastUpdated.present
          ? data.lastUpdated.value
          : this.lastUpdated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealsTableData(')
          ..write('id: $id, ')
          ..write('diningCourt: $diningCourt, ')
          ..write('date: $date, ')
          ..write('mealTime: $mealTime, ')
          ..write('name: $name, ')
          ..write('foodItems: $foodItems, ')
          ..write('totalCalories: $totalCalories, ')
          ..write('totalProtein: $totalProtein, ')
          ..write('totalCarbs: $totalCarbs, ')
          ..write('totalFats: $totalFats, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    diningCourt,
    date,
    mealTime,
    name,
    foodItems,
    totalCalories,
    totalProtein,
    totalCarbs,
    totalFats,
    lastUpdated,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealsTableData &&
          other.id == this.id &&
          other.diningCourt == this.diningCourt &&
          other.date == this.date &&
          other.mealTime == this.mealTime &&
          other.name == this.name &&
          other.foodItems == this.foodItems &&
          other.totalCalories == this.totalCalories &&
          other.totalProtein == this.totalProtein &&
          other.totalCarbs == this.totalCarbs &&
          other.totalFats == this.totalFats &&
          other.lastUpdated == this.lastUpdated);
}

class MealsTableCompanion extends UpdateCompanion<MealsTableData> {
  final Value<int> id;
  final Value<String> diningCourt;
  final Value<String> date;
  final Value<String> mealTime;
  final Value<String> name;
  final Value<String> foodItems;
  final Value<double> totalCalories;
  final Value<double> totalProtein;
  final Value<double> totalCarbs;
  final Value<double> totalFats;
  final Value<int> lastUpdated;
  const MealsTableCompanion({
    this.id = const Value.absent(),
    this.diningCourt = const Value.absent(),
    this.date = const Value.absent(),
    this.mealTime = const Value.absent(),
    this.name = const Value.absent(),
    this.foodItems = const Value.absent(),
    this.totalCalories = const Value.absent(),
    this.totalProtein = const Value.absent(),
    this.totalCarbs = const Value.absent(),
    this.totalFats = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  });
  MealsTableCompanion.insert({
    this.id = const Value.absent(),
    required String diningCourt,
    required String date,
    required String mealTime,
    required String name,
    required String foodItems,
    required double totalCalories,
    required double totalProtein,
    required double totalCarbs,
    required double totalFats,
    required int lastUpdated,
  }) : diningCourt = Value(diningCourt),
       date = Value(date),
       mealTime = Value(mealTime),
       name = Value(name),
       foodItems = Value(foodItems),
       totalCalories = Value(totalCalories),
       totalProtein = Value(totalProtein),
       totalCarbs = Value(totalCarbs),
       totalFats = Value(totalFats),
       lastUpdated = Value(lastUpdated);
  static Insertable<MealsTableData> custom({
    Expression<int>? id,
    Expression<String>? diningCourt,
    Expression<String>? date,
    Expression<String>? mealTime,
    Expression<String>? name,
    Expression<String>? foodItems,
    Expression<double>? totalCalories,
    Expression<double>? totalProtein,
    Expression<double>? totalCarbs,
    Expression<double>? totalFats,
    Expression<int>? lastUpdated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (diningCourt != null) 'dining_court': diningCourt,
      if (date != null) 'date': date,
      if (mealTime != null) 'meal_time': mealTime,
      if (name != null) 'name': name,
      if (foodItems != null) 'food_items': foodItems,
      if (totalCalories != null) 'total_calories': totalCalories,
      if (totalProtein != null) 'total_protein': totalProtein,
      if (totalCarbs != null) 'total_carbs': totalCarbs,
      if (totalFats != null) 'total_fats': totalFats,
      if (lastUpdated != null) 'last_updated': lastUpdated,
    });
  }

  MealsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? diningCourt,
    Value<String>? date,
    Value<String>? mealTime,
    Value<String>? name,
    Value<String>? foodItems,
    Value<double>? totalCalories,
    Value<double>? totalProtein,
    Value<double>? totalCarbs,
    Value<double>? totalFats,
    Value<int>? lastUpdated,
  }) {
    return MealsTableCompanion(
      id: id ?? this.id,
      diningCourt: diningCourt ?? this.diningCourt,
      date: date ?? this.date,
      mealTime: mealTime ?? this.mealTime,
      name: name ?? this.name,
      foodItems: foodItems ?? this.foodItems,
      totalCalories: totalCalories ?? this.totalCalories,
      totalProtein: totalProtein ?? this.totalProtein,
      totalCarbs: totalCarbs ?? this.totalCarbs,
      totalFats: totalFats ?? this.totalFats,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (diningCourt.present) {
      map['dining_court'] = Variable<String>(diningCourt.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (mealTime.present) {
      map['meal_time'] = Variable<String>(mealTime.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (foodItems.present) {
      map['food_items'] = Variable<String>(foodItems.value);
    }
    if (totalCalories.present) {
      map['total_calories'] = Variable<double>(totalCalories.value);
    }
    if (totalProtein.present) {
      map['total_protein'] = Variable<double>(totalProtein.value);
    }
    if (totalCarbs.present) {
      map['total_carbs'] = Variable<double>(totalCarbs.value);
    }
    if (totalFats.present) {
      map['total_fats'] = Variable<double>(totalFats.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<int>(lastUpdated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealsTableCompanion(')
          ..write('id: $id, ')
          ..write('diningCourt: $diningCourt, ')
          ..write('date: $date, ')
          ..write('mealTime: $mealTime, ')
          ..write('name: $name, ')
          ..write('foodItems: $foodItems, ')
          ..write('totalCalories: $totalCalories, ')
          ..write('totalProtein: $totalProtein, ')
          ..write('totalCarbs: $totalCarbs, ')
          ..write('totalFats: $totalFats, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }
}

class $FoodsTableTable extends FoodsTable
    with TableInfo<$FoodsTableTable, FoodsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _foodIdMeta = const VerificationMeta('foodId');
  @override
  late final GeneratedColumn<String> foodId = GeneratedColumn<String>(
    'food_id',
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
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<double> calories = GeneratedColumn<double>(
    'calories',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proteinMeta = const VerificationMeta(
    'protein',
  );
  @override
  late final GeneratedColumn<double> protein = GeneratedColumn<double>(
    'protein',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carbsMeta = const VerificationMeta('carbs');
  @override
  late final GeneratedColumn<double> carbs = GeneratedColumn<double>(
    'carbs',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fatsMeta = const VerificationMeta('fats');
  @override
  late final GeneratedColumn<double> fats = GeneratedColumn<double>(
    'fats',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sugarMeta = const VerificationMeta('sugar');
  @override
  late final GeneratedColumn<double> sugar = GeneratedColumn<double>(
    'sugar',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelsMeta = const VerificationMeta('labels');
  @override
  late final GeneratedColumn<String> labels = GeneratedColumn<String>(
    'labels',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ingredientsMeta = const VerificationMeta(
    'ingredients',
  );
  @override
  late final GeneratedColumn<String> ingredients = GeneratedColumn<String>(
    'ingredients',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stationMeta = const VerificationMeta(
    'station',
  );
  @override
  late final GeneratedColumn<String> station = GeneratedColumn<String>(
    'station',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _collectionMeta = const VerificationMeta(
    'collection',
  );
  @override
  late final GeneratedColumn<String> collection = GeneratedColumn<String>(
    'collection',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastUpdatedMeta = const VerificationMeta(
    'lastUpdated',
  );
  @override
  late final GeneratedColumn<int> lastUpdated = GeneratedColumn<int>(
    'last_updated',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    foodId,
    name,
    calories,
    protein,
    carbs,
    fats,
    sugar,
    labels,
    ingredients,
    station,
    collection,
    lastUpdated,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'foods_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<FoodsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('food_id')) {
      context.handle(
        _foodIdMeta,
        foodId.isAcceptableOrUnknown(data['food_id']!, _foodIdMeta),
      );
    } else if (isInserting) {
      context.missing(_foodIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    } else if (isInserting) {
      context.missing(_caloriesMeta);
    }
    if (data.containsKey('protein')) {
      context.handle(
        _proteinMeta,
        protein.isAcceptableOrUnknown(data['protein']!, _proteinMeta),
      );
    } else if (isInserting) {
      context.missing(_proteinMeta);
    }
    if (data.containsKey('carbs')) {
      context.handle(
        _carbsMeta,
        carbs.isAcceptableOrUnknown(data['carbs']!, _carbsMeta),
      );
    } else if (isInserting) {
      context.missing(_carbsMeta);
    }
    if (data.containsKey('fats')) {
      context.handle(
        _fatsMeta,
        fats.isAcceptableOrUnknown(data['fats']!, _fatsMeta),
      );
    } else if (isInserting) {
      context.missing(_fatsMeta);
    }
    if (data.containsKey('sugar')) {
      context.handle(
        _sugarMeta,
        sugar.isAcceptableOrUnknown(data['sugar']!, _sugarMeta),
      );
    } else if (isInserting) {
      context.missing(_sugarMeta);
    }
    if (data.containsKey('labels')) {
      context.handle(
        _labelsMeta,
        labels.isAcceptableOrUnknown(data['labels']!, _labelsMeta),
      );
    } else if (isInserting) {
      context.missing(_labelsMeta);
    }
    if (data.containsKey('ingredients')) {
      context.handle(
        _ingredientsMeta,
        ingredients.isAcceptableOrUnknown(
          data['ingredients']!,
          _ingredientsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ingredientsMeta);
    }
    if (data.containsKey('station')) {
      context.handle(
        _stationMeta,
        station.isAcceptableOrUnknown(data['station']!, _stationMeta),
      );
    } else if (isInserting) {
      context.missing(_stationMeta);
    }
    if (data.containsKey('collection')) {
      context.handle(
        _collectionMeta,
        collection.isAcceptableOrUnknown(data['collection']!, _collectionMeta),
      );
    }
    if (data.containsKey('last_updated')) {
      context.handle(
        _lastUpdatedMeta,
        lastUpdated.isAcceptableOrUnknown(
          data['last_updated']!,
          _lastUpdatedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FoodsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FoodsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      foodId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calories'],
      )!,
      protein: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein'],
      )!,
      carbs: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs'],
      )!,
      fats: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fats'],
      )!,
      sugar: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sugar'],
      )!,
      labels: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}labels'],
      )!,
      ingredients: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ingredients'],
      )!,
      station: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}station'],
      )!,
      collection: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}collection'],
      ),
      lastUpdated: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_updated'],
      )!,
    );
  }

  @override
  $FoodsTableTable createAlias(String alias) {
    return $FoodsTableTable(attachedDatabase, alias);
  }
}

class FoodsTableData extends DataClass implements Insertable<FoodsTableData> {
  final int id;
  final String foodId;
  final String name;
  final double calories;
  final double protein;
  final double carbs;
  final double fats;
  final double sugar;
  final String labels;
  final String ingredients;
  final String station;
  final String? collection;
  final int lastUpdated;
  const FoodsTableData({
    required this.id,
    required this.foodId,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.sugar,
    required this.labels,
    required this.ingredients,
    required this.station,
    this.collection,
    required this.lastUpdated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['food_id'] = Variable<String>(foodId);
    map['name'] = Variable<String>(name);
    map['calories'] = Variable<double>(calories);
    map['protein'] = Variable<double>(protein);
    map['carbs'] = Variable<double>(carbs);
    map['fats'] = Variable<double>(fats);
    map['sugar'] = Variable<double>(sugar);
    map['labels'] = Variable<String>(labels);
    map['ingredients'] = Variable<String>(ingredients);
    map['station'] = Variable<String>(station);
    if (!nullToAbsent || collection != null) {
      map['collection'] = Variable<String>(collection);
    }
    map['last_updated'] = Variable<int>(lastUpdated);
    return map;
  }

  FoodsTableCompanion toCompanion(bool nullToAbsent) {
    return FoodsTableCompanion(
      id: Value(id),
      foodId: Value(foodId),
      name: Value(name),
      calories: Value(calories),
      protein: Value(protein),
      carbs: Value(carbs),
      fats: Value(fats),
      sugar: Value(sugar),
      labels: Value(labels),
      ingredients: Value(ingredients),
      station: Value(station),
      collection: collection == null && nullToAbsent
          ? const Value.absent()
          : Value(collection),
      lastUpdated: Value(lastUpdated),
    );
  }

  factory FoodsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FoodsTableData(
      id: serializer.fromJson<int>(json['id']),
      foodId: serializer.fromJson<String>(json['foodId']),
      name: serializer.fromJson<String>(json['name']),
      calories: serializer.fromJson<double>(json['calories']),
      protein: serializer.fromJson<double>(json['protein']),
      carbs: serializer.fromJson<double>(json['carbs']),
      fats: serializer.fromJson<double>(json['fats']),
      sugar: serializer.fromJson<double>(json['sugar']),
      labels: serializer.fromJson<String>(json['labels']),
      ingredients: serializer.fromJson<String>(json['ingredients']),
      station: serializer.fromJson<String>(json['station']),
      collection: serializer.fromJson<String?>(json['collection']),
      lastUpdated: serializer.fromJson<int>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'foodId': serializer.toJson<String>(foodId),
      'name': serializer.toJson<String>(name),
      'calories': serializer.toJson<double>(calories),
      'protein': serializer.toJson<double>(protein),
      'carbs': serializer.toJson<double>(carbs),
      'fats': serializer.toJson<double>(fats),
      'sugar': serializer.toJson<double>(sugar),
      'labels': serializer.toJson<String>(labels),
      'ingredients': serializer.toJson<String>(ingredients),
      'station': serializer.toJson<String>(station),
      'collection': serializer.toJson<String?>(collection),
      'lastUpdated': serializer.toJson<int>(lastUpdated),
    };
  }

  FoodsTableData copyWith({
    int? id,
    String? foodId,
    String? name,
    double? calories,
    double? protein,
    double? carbs,
    double? fats,
    double? sugar,
    String? labels,
    String? ingredients,
    String? station,
    Value<String?> collection = const Value.absent(),
    int? lastUpdated,
  }) => FoodsTableData(
    id: id ?? this.id,
    foodId: foodId ?? this.foodId,
    name: name ?? this.name,
    calories: calories ?? this.calories,
    protein: protein ?? this.protein,
    carbs: carbs ?? this.carbs,
    fats: fats ?? this.fats,
    sugar: sugar ?? this.sugar,
    labels: labels ?? this.labels,
    ingredients: ingredients ?? this.ingredients,
    station: station ?? this.station,
    collection: collection.present ? collection.value : this.collection,
    lastUpdated: lastUpdated ?? this.lastUpdated,
  );
  FoodsTableData copyWithCompanion(FoodsTableCompanion data) {
    return FoodsTableData(
      id: data.id.present ? data.id.value : this.id,
      foodId: data.foodId.present ? data.foodId.value : this.foodId,
      name: data.name.present ? data.name.value : this.name,
      calories: data.calories.present ? data.calories.value : this.calories,
      protein: data.protein.present ? data.protein.value : this.protein,
      carbs: data.carbs.present ? data.carbs.value : this.carbs,
      fats: data.fats.present ? data.fats.value : this.fats,
      sugar: data.sugar.present ? data.sugar.value : this.sugar,
      labels: data.labels.present ? data.labels.value : this.labels,
      ingredients: data.ingredients.present
          ? data.ingredients.value
          : this.ingredients,
      station: data.station.present ? data.station.value : this.station,
      collection: data.collection.present
          ? data.collection.value
          : this.collection,
      lastUpdated: data.lastUpdated.present
          ? data.lastUpdated.value
          : this.lastUpdated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FoodsTableData(')
          ..write('id: $id, ')
          ..write('foodId: $foodId, ')
          ..write('name: $name, ')
          ..write('calories: $calories, ')
          ..write('protein: $protein, ')
          ..write('carbs: $carbs, ')
          ..write('fats: $fats, ')
          ..write('sugar: $sugar, ')
          ..write('labels: $labels, ')
          ..write('ingredients: $ingredients, ')
          ..write('station: $station, ')
          ..write('collection: $collection, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    foodId,
    name,
    calories,
    protein,
    carbs,
    fats,
    sugar,
    labels,
    ingredients,
    station,
    collection,
    lastUpdated,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FoodsTableData &&
          other.id == this.id &&
          other.foodId == this.foodId &&
          other.name == this.name &&
          other.calories == this.calories &&
          other.protein == this.protein &&
          other.carbs == this.carbs &&
          other.fats == this.fats &&
          other.sugar == this.sugar &&
          other.labels == this.labels &&
          other.ingredients == this.ingredients &&
          other.station == this.station &&
          other.collection == this.collection &&
          other.lastUpdated == this.lastUpdated);
}

class FoodsTableCompanion extends UpdateCompanion<FoodsTableData> {
  final Value<int> id;
  final Value<String> foodId;
  final Value<String> name;
  final Value<double> calories;
  final Value<double> protein;
  final Value<double> carbs;
  final Value<double> fats;
  final Value<double> sugar;
  final Value<String> labels;
  final Value<String> ingredients;
  final Value<String> station;
  final Value<String?> collection;
  final Value<int> lastUpdated;
  const FoodsTableCompanion({
    this.id = const Value.absent(),
    this.foodId = const Value.absent(),
    this.name = const Value.absent(),
    this.calories = const Value.absent(),
    this.protein = const Value.absent(),
    this.carbs = const Value.absent(),
    this.fats = const Value.absent(),
    this.sugar = const Value.absent(),
    this.labels = const Value.absent(),
    this.ingredients = const Value.absent(),
    this.station = const Value.absent(),
    this.collection = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  });
  FoodsTableCompanion.insert({
    this.id = const Value.absent(),
    required String foodId,
    required String name,
    required double calories,
    required double protein,
    required double carbs,
    required double fats,
    required double sugar,
    required String labels,
    required String ingredients,
    required String station,
    this.collection = const Value.absent(),
    required int lastUpdated,
  }) : foodId = Value(foodId),
       name = Value(name),
       calories = Value(calories),
       protein = Value(protein),
       carbs = Value(carbs),
       fats = Value(fats),
       sugar = Value(sugar),
       labels = Value(labels),
       ingredients = Value(ingredients),
       station = Value(station),
       lastUpdated = Value(lastUpdated);
  static Insertable<FoodsTableData> custom({
    Expression<int>? id,
    Expression<String>? foodId,
    Expression<String>? name,
    Expression<double>? calories,
    Expression<double>? protein,
    Expression<double>? carbs,
    Expression<double>? fats,
    Expression<double>? sugar,
    Expression<String>? labels,
    Expression<String>? ingredients,
    Expression<String>? station,
    Expression<String>? collection,
    Expression<int>? lastUpdated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (foodId != null) 'food_id': foodId,
      if (name != null) 'name': name,
      if (calories != null) 'calories': calories,
      if (protein != null) 'protein': protein,
      if (carbs != null) 'carbs': carbs,
      if (fats != null) 'fats': fats,
      if (sugar != null) 'sugar': sugar,
      if (labels != null) 'labels': labels,
      if (ingredients != null) 'ingredients': ingredients,
      if (station != null) 'station': station,
      if (collection != null) 'collection': collection,
      if (lastUpdated != null) 'last_updated': lastUpdated,
    });
  }

  FoodsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? foodId,
    Value<String>? name,
    Value<double>? calories,
    Value<double>? protein,
    Value<double>? carbs,
    Value<double>? fats,
    Value<double>? sugar,
    Value<String>? labels,
    Value<String>? ingredients,
    Value<String>? station,
    Value<String?>? collection,
    Value<int>? lastUpdated,
  }) {
    return FoodsTableCompanion(
      id: id ?? this.id,
      foodId: foodId ?? this.foodId,
      name: name ?? this.name,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fats: fats ?? this.fats,
      sugar: sugar ?? this.sugar,
      labels: labels ?? this.labels,
      ingredients: ingredients ?? this.ingredients,
      station: station ?? this.station,
      collection: collection ?? this.collection,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (foodId.present) {
      map['food_id'] = Variable<String>(foodId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (calories.present) {
      map['calories'] = Variable<double>(calories.value);
    }
    if (protein.present) {
      map['protein'] = Variable<double>(protein.value);
    }
    if (carbs.present) {
      map['carbs'] = Variable<double>(carbs.value);
    }
    if (fats.present) {
      map['fats'] = Variable<double>(fats.value);
    }
    if (sugar.present) {
      map['sugar'] = Variable<double>(sugar.value);
    }
    if (labels.present) {
      map['labels'] = Variable<String>(labels.value);
    }
    if (ingredients.present) {
      map['ingredients'] = Variable<String>(ingredients.value);
    }
    if (station.present) {
      map['station'] = Variable<String>(station.value);
    }
    if (collection.present) {
      map['collection'] = Variable<String>(collection.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<int>(lastUpdated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodsTableCompanion(')
          ..write('id: $id, ')
          ..write('foodId: $foodId, ')
          ..write('name: $name, ')
          ..write('calories: $calories, ')
          ..write('protein: $protein, ')
          ..write('carbs: $carbs, ')
          ..write('fats: $fats, ')
          ..write('sugar: $sugar, ')
          ..write('labels: $labels, ')
          ..write('ingredients: $ingredients, ')
          ..write('station: $station, ')
          ..write('collection: $collection, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }
}

class $DiningHallFoodsTableTable extends DiningHallFoodsTable
    with TableInfo<$DiningHallFoodsTableTable, DiningHallFoodsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiningHallFoodsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _diningHallMeta = const VerificationMeta(
    'diningHall',
  );
  @override
  late final GeneratedColumn<String> diningHall = GeneratedColumn<String>(
    'dining_hall',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mealTimeMeta = const VerificationMeta(
    'mealTime',
  );
  @override
  late final GeneratedColumn<String> mealTime = GeneratedColumn<String>(
    'meal_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _miniFoodMeta = const VerificationMeta(
    'miniFood',
  );
  @override
  late final GeneratedColumn<String> miniFood = GeneratedColumn<String>(
    'mini_food',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastUpdatedMeta = const VerificationMeta(
    'lastUpdated',
  );
  @override
  late final GeneratedColumn<int> lastUpdated = GeneratedColumn<int>(
    'last_updated',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    diningHall,
    date,
    mealTime,
    miniFood,
    lastUpdated,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dining_hall_foods_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<DiningHallFoodsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('dining_hall')) {
      context.handle(
        _diningHallMeta,
        diningHall.isAcceptableOrUnknown(data['dining_hall']!, _diningHallMeta),
      );
    } else if (isInserting) {
      context.missing(_diningHallMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('meal_time')) {
      context.handle(
        _mealTimeMeta,
        mealTime.isAcceptableOrUnknown(data['meal_time']!, _mealTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_mealTimeMeta);
    }
    if (data.containsKey('mini_food')) {
      context.handle(
        _miniFoodMeta,
        miniFood.isAcceptableOrUnknown(data['mini_food']!, _miniFoodMeta),
      );
    } else if (isInserting) {
      context.missing(_miniFoodMeta);
    }
    if (data.containsKey('last_updated')) {
      context.handle(
        _lastUpdatedMeta,
        lastUpdated.isAcceptableOrUnknown(
          data['last_updated']!,
          _lastUpdatedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiningHallFoodsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiningHallFoodsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      diningHall: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dining_hall'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      mealTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_time'],
      )!,
      miniFood: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mini_food'],
      )!,
      lastUpdated: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_updated'],
      )!,
    );
  }

  @override
  $DiningHallFoodsTableTable createAlias(String alias) {
    return $DiningHallFoodsTableTable(attachedDatabase, alias);
  }
}

class DiningHallFoodsTableData extends DataClass
    implements Insertable<DiningHallFoodsTableData> {
  final int id;
  final String diningHall;
  final String date;
  final String mealTime;
  final String miniFood;
  final int lastUpdated;
  const DiningHallFoodsTableData({
    required this.id,
    required this.diningHall,
    required this.date,
    required this.mealTime,
    required this.miniFood,
    required this.lastUpdated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['dining_hall'] = Variable<String>(diningHall);
    map['date'] = Variable<String>(date);
    map['meal_time'] = Variable<String>(mealTime);
    map['mini_food'] = Variable<String>(miniFood);
    map['last_updated'] = Variable<int>(lastUpdated);
    return map;
  }

  DiningHallFoodsTableCompanion toCompanion(bool nullToAbsent) {
    return DiningHallFoodsTableCompanion(
      id: Value(id),
      diningHall: Value(diningHall),
      date: Value(date),
      mealTime: Value(mealTime),
      miniFood: Value(miniFood),
      lastUpdated: Value(lastUpdated),
    );
  }

  factory DiningHallFoodsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiningHallFoodsTableData(
      id: serializer.fromJson<int>(json['id']),
      diningHall: serializer.fromJson<String>(json['diningHall']),
      date: serializer.fromJson<String>(json['date']),
      mealTime: serializer.fromJson<String>(json['mealTime']),
      miniFood: serializer.fromJson<String>(json['miniFood']),
      lastUpdated: serializer.fromJson<int>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'diningHall': serializer.toJson<String>(diningHall),
      'date': serializer.toJson<String>(date),
      'mealTime': serializer.toJson<String>(mealTime),
      'miniFood': serializer.toJson<String>(miniFood),
      'lastUpdated': serializer.toJson<int>(lastUpdated),
    };
  }

  DiningHallFoodsTableData copyWith({
    int? id,
    String? diningHall,
    String? date,
    String? mealTime,
    String? miniFood,
    int? lastUpdated,
  }) => DiningHallFoodsTableData(
    id: id ?? this.id,
    diningHall: diningHall ?? this.diningHall,
    date: date ?? this.date,
    mealTime: mealTime ?? this.mealTime,
    miniFood: miniFood ?? this.miniFood,
    lastUpdated: lastUpdated ?? this.lastUpdated,
  );
  DiningHallFoodsTableData copyWithCompanion(
    DiningHallFoodsTableCompanion data,
  ) {
    return DiningHallFoodsTableData(
      id: data.id.present ? data.id.value : this.id,
      diningHall: data.diningHall.present
          ? data.diningHall.value
          : this.diningHall,
      date: data.date.present ? data.date.value : this.date,
      mealTime: data.mealTime.present ? data.mealTime.value : this.mealTime,
      miniFood: data.miniFood.present ? data.miniFood.value : this.miniFood,
      lastUpdated: data.lastUpdated.present
          ? data.lastUpdated.value
          : this.lastUpdated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiningHallFoodsTableData(')
          ..write('id: $id, ')
          ..write('diningHall: $diningHall, ')
          ..write('date: $date, ')
          ..write('mealTime: $mealTime, ')
          ..write('miniFood: $miniFood, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, diningHall, date, mealTime, miniFood, lastUpdated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiningHallFoodsTableData &&
          other.id == this.id &&
          other.diningHall == this.diningHall &&
          other.date == this.date &&
          other.mealTime == this.mealTime &&
          other.miniFood == this.miniFood &&
          other.lastUpdated == this.lastUpdated);
}

class DiningHallFoodsTableCompanion
    extends UpdateCompanion<DiningHallFoodsTableData> {
  final Value<int> id;
  final Value<String> diningHall;
  final Value<String> date;
  final Value<String> mealTime;
  final Value<String> miniFood;
  final Value<int> lastUpdated;
  const DiningHallFoodsTableCompanion({
    this.id = const Value.absent(),
    this.diningHall = const Value.absent(),
    this.date = const Value.absent(),
    this.mealTime = const Value.absent(),
    this.miniFood = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  });
  DiningHallFoodsTableCompanion.insert({
    this.id = const Value.absent(),
    required String diningHall,
    required String date,
    required String mealTime,
    required String miniFood,
    required int lastUpdated,
  }) : diningHall = Value(diningHall),
       date = Value(date),
       mealTime = Value(mealTime),
       miniFood = Value(miniFood),
       lastUpdated = Value(lastUpdated);
  static Insertable<DiningHallFoodsTableData> custom({
    Expression<int>? id,
    Expression<String>? diningHall,
    Expression<String>? date,
    Expression<String>? mealTime,
    Expression<String>? miniFood,
    Expression<int>? lastUpdated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (diningHall != null) 'dining_hall': diningHall,
      if (date != null) 'date': date,
      if (mealTime != null) 'meal_time': mealTime,
      if (miniFood != null) 'mini_food': miniFood,
      if (lastUpdated != null) 'last_updated': lastUpdated,
    });
  }

  DiningHallFoodsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? diningHall,
    Value<String>? date,
    Value<String>? mealTime,
    Value<String>? miniFood,
    Value<int>? lastUpdated,
  }) {
    return DiningHallFoodsTableCompanion(
      id: id ?? this.id,
      diningHall: diningHall ?? this.diningHall,
      date: date ?? this.date,
      mealTime: mealTime ?? this.mealTime,
      miniFood: miniFood ?? this.miniFood,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (diningHall.present) {
      map['dining_hall'] = Variable<String>(diningHall.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (mealTime.present) {
      map['meal_time'] = Variable<String>(mealTime.value);
    }
    if (miniFood.present) {
      map['mini_food'] = Variable<String>(miniFood.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<int>(lastUpdated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiningHallFoodsTableCompanion(')
          ..write('id: $id, ')
          ..write('diningHall: $diningHall, ')
          ..write('date: $date, ')
          ..write('mealTime: $mealTime, ')
          ..write('miniFood: $miniFood, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }
}

class $DiningHallsTableTable extends DiningHallsTable
    with TableInfo<$DiningHallsTableTable, DiningHallsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiningHallsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _diningHallIdMeta = const VerificationMeta(
    'diningHallId',
  );
  @override
  late final GeneratedColumn<String> diningHallId = GeneratedColumn<String>(
    'dining_hall_id',
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
  static const VerificationMeta _scheduleMeta = const VerificationMeta(
    'schedule',
  );
  @override
  late final GeneratedColumn<String> schedule = GeneratedColumn<String>(
    'schedule',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, diningHallId, name, schedule];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dining_halls_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<DiningHallsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('dining_hall_id')) {
      context.handle(
        _diningHallIdMeta,
        diningHallId.isAcceptableOrUnknown(
          data['dining_hall_id']!,
          _diningHallIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_diningHallIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('schedule')) {
      context.handle(
        _scheduleMeta,
        schedule.isAcceptableOrUnknown(data['schedule']!, _scheduleMeta),
      );
    } else if (isInserting) {
      context.missing(_scheduleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiningHallsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiningHallsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      diningHallId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dining_hall_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      schedule: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}schedule'],
      )!,
    );
  }

  @override
  $DiningHallsTableTable createAlias(String alias) {
    return $DiningHallsTableTable(attachedDatabase, alias);
  }
}

class DiningHallsTableData extends DataClass
    implements Insertable<DiningHallsTableData> {
  final int id;
  final String diningHallId;
  final String name;
  final String schedule;
  const DiningHallsTableData({
    required this.id,
    required this.diningHallId,
    required this.name,
    required this.schedule,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['dining_hall_id'] = Variable<String>(diningHallId);
    map['name'] = Variable<String>(name);
    map['schedule'] = Variable<String>(schedule);
    return map;
  }

  DiningHallsTableCompanion toCompanion(bool nullToAbsent) {
    return DiningHallsTableCompanion(
      id: Value(id),
      diningHallId: Value(diningHallId),
      name: Value(name),
      schedule: Value(schedule),
    );
  }

  factory DiningHallsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiningHallsTableData(
      id: serializer.fromJson<int>(json['id']),
      diningHallId: serializer.fromJson<String>(json['diningHallId']),
      name: serializer.fromJson<String>(json['name']),
      schedule: serializer.fromJson<String>(json['schedule']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'diningHallId': serializer.toJson<String>(diningHallId),
      'name': serializer.toJson<String>(name),
      'schedule': serializer.toJson<String>(schedule),
    };
  }

  DiningHallsTableData copyWith({
    int? id,
    String? diningHallId,
    String? name,
    String? schedule,
  }) => DiningHallsTableData(
    id: id ?? this.id,
    diningHallId: diningHallId ?? this.diningHallId,
    name: name ?? this.name,
    schedule: schedule ?? this.schedule,
  );
  DiningHallsTableData copyWithCompanion(DiningHallsTableCompanion data) {
    return DiningHallsTableData(
      id: data.id.present ? data.id.value : this.id,
      diningHallId: data.diningHallId.present
          ? data.diningHallId.value
          : this.diningHallId,
      name: data.name.present ? data.name.value : this.name,
      schedule: data.schedule.present ? data.schedule.value : this.schedule,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiningHallsTableData(')
          ..write('id: $id, ')
          ..write('diningHallId: $diningHallId, ')
          ..write('name: $name, ')
          ..write('schedule: $schedule')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, diningHallId, name, schedule);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiningHallsTableData &&
          other.id == this.id &&
          other.diningHallId == this.diningHallId &&
          other.name == this.name &&
          other.schedule == this.schedule);
}

class DiningHallsTableCompanion extends UpdateCompanion<DiningHallsTableData> {
  final Value<int> id;
  final Value<String> diningHallId;
  final Value<String> name;
  final Value<String> schedule;
  const DiningHallsTableCompanion({
    this.id = const Value.absent(),
    this.diningHallId = const Value.absent(),
    this.name = const Value.absent(),
    this.schedule = const Value.absent(),
  });
  DiningHallsTableCompanion.insert({
    this.id = const Value.absent(),
    required String diningHallId,
    required String name,
    required String schedule,
  }) : diningHallId = Value(diningHallId),
       name = Value(name),
       schedule = Value(schedule);
  static Insertable<DiningHallsTableData> custom({
    Expression<int>? id,
    Expression<String>? diningHallId,
    Expression<String>? name,
    Expression<String>? schedule,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (diningHallId != null) 'dining_hall_id': diningHallId,
      if (name != null) 'name': name,
      if (schedule != null) 'schedule': schedule,
    });
  }

  DiningHallsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? diningHallId,
    Value<String>? name,
    Value<String>? schedule,
  }) {
    return DiningHallsTableCompanion(
      id: id ?? this.id,
      diningHallId: diningHallId ?? this.diningHallId,
      name: name ?? this.name,
      schedule: schedule ?? this.schedule,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (diningHallId.present) {
      map['dining_hall_id'] = Variable<String>(diningHallId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (schedule.present) {
      map['schedule'] = Variable<String>(schedule.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiningHallsTableCompanion(')
          ..write('id: $id, ')
          ..write('diningHallId: $diningHallId, ')
          ..write('name: $name, ')
          ..write('schedule: $schedule')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(e);
  $AppDbManager get managers => $AppDbManager(this);
  late final $UsersTableTable usersTable = $UsersTableTable(this);
  late final $MealsTableTable mealsTable = $MealsTableTable(this);
  late final $FoodsTableTable foodsTable = $FoodsTableTable(this);
  late final $DiningHallFoodsTableTable diningHallFoodsTable =
      $DiningHallFoodsTableTable(this);
  late final $DiningHallsTableTable diningHallsTable = $DiningHallsTableTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    usersTable,
    mealsTable,
    foodsTable,
    diningHallFoodsTable,
    diningHallsTable,
  ];
}

typedef $$UsersTableTableCreateCompanionBuilder =
    UsersTableCompanion Function({
      Value<int> id,
      required String uid,
      required String name,
      required String gender,
      required int age,
      required int weight,
      required int height,
      required String goal,
      required String dietaryRestrictions,
      required String mealPlan,
      required String diningCourtRanking,
    });
typedef $$UsersTableTableUpdateCompanionBuilder =
    UsersTableCompanion Function({
      Value<int> id,
      Value<String> uid,
      Value<String> name,
      Value<String> gender,
      Value<int> age,
      Value<int> weight,
      Value<int> height,
      Value<String> goal,
      Value<String> dietaryRestrictions,
      Value<String> mealPlan,
      Value<String> diningCourtRanking,
    });

class $$UsersTableTableFilterComposer
    extends Composer<_$AppDb, $UsersTableTable> {
  $$UsersTableTableFilterComposer({
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

  ColumnFilters<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goal => $composableBuilder(
    column: $table.goal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dietaryRestrictions => $composableBuilder(
    column: $table.dietaryRestrictions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealPlan => $composableBuilder(
    column: $table.mealPlan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get diningCourtRanking => $composableBuilder(
    column: $table.diningCourtRanking,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableTableOrderingComposer
    extends Composer<_$AppDb, $UsersTableTable> {
  $$UsersTableTableOrderingComposer({
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

  ColumnOrderings<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goal => $composableBuilder(
    column: $table.goal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dietaryRestrictions => $composableBuilder(
    column: $table.dietaryRestrictions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealPlan => $composableBuilder(
    column: $table.mealPlan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get diningCourtRanking => $composableBuilder(
    column: $table.diningCourtRanking,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableTableAnnotationComposer
    extends Composer<_$AppDb, $UsersTableTable> {
  $$UsersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uid =>
      $composableBuilder(column: $table.uid, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<int> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<String> get goal =>
      $composableBuilder(column: $table.goal, builder: (column) => column);

  GeneratedColumn<String> get dietaryRestrictions => $composableBuilder(
    column: $table.dietaryRestrictions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mealPlan =>
      $composableBuilder(column: $table.mealPlan, builder: (column) => column);

  GeneratedColumn<String> get diningCourtRanking => $composableBuilder(
    column: $table.diningCourtRanking,
    builder: (column) => column,
  );
}

class $$UsersTableTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $UsersTableTable,
          UsersTableData,
          $$UsersTableTableFilterComposer,
          $$UsersTableTableOrderingComposer,
          $$UsersTableTableAnnotationComposer,
          $$UsersTableTableCreateCompanionBuilder,
          $$UsersTableTableUpdateCompanionBuilder,
          (
            UsersTableData,
            BaseReferences<_$AppDb, $UsersTableTable, UsersTableData>,
          ),
          UsersTableData,
          PrefetchHooks Function()
        > {
  $$UsersTableTableTableManager(_$AppDb db, $UsersTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> uid = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> gender = const Value.absent(),
                Value<int> age = const Value.absent(),
                Value<int> weight = const Value.absent(),
                Value<int> height = const Value.absent(),
                Value<String> goal = const Value.absent(),
                Value<String> dietaryRestrictions = const Value.absent(),
                Value<String> mealPlan = const Value.absent(),
                Value<String> diningCourtRanking = const Value.absent(),
              }) => UsersTableCompanion(
                id: id,
                uid: uid,
                name: name,
                gender: gender,
                age: age,
                weight: weight,
                height: height,
                goal: goal,
                dietaryRestrictions: dietaryRestrictions,
                mealPlan: mealPlan,
                diningCourtRanking: diningCourtRanking,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String uid,
                required String name,
                required String gender,
                required int age,
                required int weight,
                required int height,
                required String goal,
                required String dietaryRestrictions,
                required String mealPlan,
                required String diningCourtRanking,
              }) => UsersTableCompanion.insert(
                id: id,
                uid: uid,
                name: name,
                gender: gender,
                age: age,
                weight: weight,
                height: height,
                goal: goal,
                dietaryRestrictions: dietaryRestrictions,
                mealPlan: mealPlan,
                diningCourtRanking: diningCourtRanking,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $UsersTableTable,
      UsersTableData,
      $$UsersTableTableFilterComposer,
      $$UsersTableTableOrderingComposer,
      $$UsersTableTableAnnotationComposer,
      $$UsersTableTableCreateCompanionBuilder,
      $$UsersTableTableUpdateCompanionBuilder,
      (
        UsersTableData,
        BaseReferences<_$AppDb, $UsersTableTable, UsersTableData>,
      ),
      UsersTableData,
      PrefetchHooks Function()
    >;
typedef $$MealsTableTableCreateCompanionBuilder =
    MealsTableCompanion Function({
      Value<int> id,
      required String diningCourt,
      required String date,
      required String mealTime,
      required String name,
      required String foodItems,
      required double totalCalories,
      required double totalProtein,
      required double totalCarbs,
      required double totalFats,
      required int lastUpdated,
    });
typedef $$MealsTableTableUpdateCompanionBuilder =
    MealsTableCompanion Function({
      Value<int> id,
      Value<String> diningCourt,
      Value<String> date,
      Value<String> mealTime,
      Value<String> name,
      Value<String> foodItems,
      Value<double> totalCalories,
      Value<double> totalProtein,
      Value<double> totalCarbs,
      Value<double> totalFats,
      Value<int> lastUpdated,
    });

class $$MealsTableTableFilterComposer
    extends Composer<_$AppDb, $MealsTableTable> {
  $$MealsTableTableFilterComposer({
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

  ColumnFilters<String> get diningCourt => $composableBuilder(
    column: $table.diningCourt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealTime => $composableBuilder(
    column: $table.mealTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foodItems => $composableBuilder(
    column: $table.foodItems,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalCalories => $composableBuilder(
    column: $table.totalCalories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalProtein => $composableBuilder(
    column: $table.totalProtein,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalCarbs => $composableBuilder(
    column: $table.totalCarbs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalFats => $composableBuilder(
    column: $table.totalFats,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MealsTableTableOrderingComposer
    extends Composer<_$AppDb, $MealsTableTable> {
  $$MealsTableTableOrderingComposer({
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

  ColumnOrderings<String> get diningCourt => $composableBuilder(
    column: $table.diningCourt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealTime => $composableBuilder(
    column: $table.mealTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foodItems => $composableBuilder(
    column: $table.foodItems,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalCalories => $composableBuilder(
    column: $table.totalCalories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalProtein => $composableBuilder(
    column: $table.totalProtein,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalCarbs => $composableBuilder(
    column: $table.totalCarbs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalFats => $composableBuilder(
    column: $table.totalFats,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MealsTableTableAnnotationComposer
    extends Composer<_$AppDb, $MealsTableTable> {
  $$MealsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get diningCourt => $composableBuilder(
    column: $table.diningCourt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get mealTime =>
      $composableBuilder(column: $table.mealTime, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get foodItems =>
      $composableBuilder(column: $table.foodItems, builder: (column) => column);

  GeneratedColumn<double> get totalCalories => $composableBuilder(
    column: $table.totalCalories,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalProtein => $composableBuilder(
    column: $table.totalProtein,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalCarbs => $composableBuilder(
    column: $table.totalCarbs,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalFats =>
      $composableBuilder(column: $table.totalFats, builder: (column) => column);

  GeneratedColumn<int> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => column,
  );
}

class $$MealsTableTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $MealsTableTable,
          MealsTableData,
          $$MealsTableTableFilterComposer,
          $$MealsTableTableOrderingComposer,
          $$MealsTableTableAnnotationComposer,
          $$MealsTableTableCreateCompanionBuilder,
          $$MealsTableTableUpdateCompanionBuilder,
          (
            MealsTableData,
            BaseReferences<_$AppDb, $MealsTableTable, MealsTableData>,
          ),
          MealsTableData,
          PrefetchHooks Function()
        > {
  $$MealsTableTableTableManager(_$AppDb db, $MealsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> diningCourt = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String> mealTime = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> foodItems = const Value.absent(),
                Value<double> totalCalories = const Value.absent(),
                Value<double> totalProtein = const Value.absent(),
                Value<double> totalCarbs = const Value.absent(),
                Value<double> totalFats = const Value.absent(),
                Value<int> lastUpdated = const Value.absent(),
              }) => MealsTableCompanion(
                id: id,
                diningCourt: diningCourt,
                date: date,
                mealTime: mealTime,
                name: name,
                foodItems: foodItems,
                totalCalories: totalCalories,
                totalProtein: totalProtein,
                totalCarbs: totalCarbs,
                totalFats: totalFats,
                lastUpdated: lastUpdated,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String diningCourt,
                required String date,
                required String mealTime,
                required String name,
                required String foodItems,
                required double totalCalories,
                required double totalProtein,
                required double totalCarbs,
                required double totalFats,
                required int lastUpdated,
              }) => MealsTableCompanion.insert(
                id: id,
                diningCourt: diningCourt,
                date: date,
                mealTime: mealTime,
                name: name,
                foodItems: foodItems,
                totalCalories: totalCalories,
                totalProtein: totalProtein,
                totalCarbs: totalCarbs,
                totalFats: totalFats,
                lastUpdated: lastUpdated,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MealsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $MealsTableTable,
      MealsTableData,
      $$MealsTableTableFilterComposer,
      $$MealsTableTableOrderingComposer,
      $$MealsTableTableAnnotationComposer,
      $$MealsTableTableCreateCompanionBuilder,
      $$MealsTableTableUpdateCompanionBuilder,
      (
        MealsTableData,
        BaseReferences<_$AppDb, $MealsTableTable, MealsTableData>,
      ),
      MealsTableData,
      PrefetchHooks Function()
    >;
typedef $$FoodsTableTableCreateCompanionBuilder =
    FoodsTableCompanion Function({
      Value<int> id,
      required String foodId,
      required String name,
      required double calories,
      required double protein,
      required double carbs,
      required double fats,
      required double sugar,
      required String labels,
      required String ingredients,
      required String station,
      Value<String?> collection,
      required int lastUpdated,
    });
typedef $$FoodsTableTableUpdateCompanionBuilder =
    FoodsTableCompanion Function({
      Value<int> id,
      Value<String> foodId,
      Value<String> name,
      Value<double> calories,
      Value<double> protein,
      Value<double> carbs,
      Value<double> fats,
      Value<double> sugar,
      Value<String> labels,
      Value<String> ingredients,
      Value<String> station,
      Value<String?> collection,
      Value<int> lastUpdated,
    });

class $$FoodsTableTableFilterComposer
    extends Composer<_$AppDb, $FoodsTableTable> {
  $$FoodsTableTableFilterComposer({
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

  ColumnFilters<String> get foodId => $composableBuilder(
    column: $table.foodId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get protein => $composableBuilder(
    column: $table.protein,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbs => $composableBuilder(
    column: $table.carbs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fats => $composableBuilder(
    column: $table.fats,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sugar => $composableBuilder(
    column: $table.sugar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get labels => $composableBuilder(
    column: $table.labels,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ingredients => $composableBuilder(
    column: $table.ingredients,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get station => $composableBuilder(
    column: $table.station,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get collection => $composableBuilder(
    column: $table.collection,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FoodsTableTableOrderingComposer
    extends Composer<_$AppDb, $FoodsTableTable> {
  $$FoodsTableTableOrderingComposer({
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

  ColumnOrderings<String> get foodId => $composableBuilder(
    column: $table.foodId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get protein => $composableBuilder(
    column: $table.protein,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbs => $composableBuilder(
    column: $table.carbs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fats => $composableBuilder(
    column: $table.fats,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sugar => $composableBuilder(
    column: $table.sugar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get labels => $composableBuilder(
    column: $table.labels,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ingredients => $composableBuilder(
    column: $table.ingredients,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get station => $composableBuilder(
    column: $table.station,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get collection => $composableBuilder(
    column: $table.collection,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FoodsTableTableAnnotationComposer
    extends Composer<_$AppDb, $FoodsTableTable> {
  $$FoodsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get foodId =>
      $composableBuilder(column: $table.foodId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<double> get protein =>
      $composableBuilder(column: $table.protein, builder: (column) => column);

  GeneratedColumn<double> get carbs =>
      $composableBuilder(column: $table.carbs, builder: (column) => column);

  GeneratedColumn<double> get fats =>
      $composableBuilder(column: $table.fats, builder: (column) => column);

  GeneratedColumn<double> get sugar =>
      $composableBuilder(column: $table.sugar, builder: (column) => column);

  GeneratedColumn<String> get labels =>
      $composableBuilder(column: $table.labels, builder: (column) => column);

  GeneratedColumn<String> get ingredients => $composableBuilder(
    column: $table.ingredients,
    builder: (column) => column,
  );

  GeneratedColumn<String> get station =>
      $composableBuilder(column: $table.station, builder: (column) => column);

  GeneratedColumn<String> get collection => $composableBuilder(
    column: $table.collection,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => column,
  );
}

class $$FoodsTableTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $FoodsTableTable,
          FoodsTableData,
          $$FoodsTableTableFilterComposer,
          $$FoodsTableTableOrderingComposer,
          $$FoodsTableTableAnnotationComposer,
          $$FoodsTableTableCreateCompanionBuilder,
          $$FoodsTableTableUpdateCompanionBuilder,
          (
            FoodsTableData,
            BaseReferences<_$AppDb, $FoodsTableTable, FoodsTableData>,
          ),
          FoodsTableData,
          PrefetchHooks Function()
        > {
  $$FoodsTableTableTableManager(_$AppDb db, $FoodsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoodsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoodsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoodsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> foodId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> calories = const Value.absent(),
                Value<double> protein = const Value.absent(),
                Value<double> carbs = const Value.absent(),
                Value<double> fats = const Value.absent(),
                Value<double> sugar = const Value.absent(),
                Value<String> labels = const Value.absent(),
                Value<String> ingredients = const Value.absent(),
                Value<String> station = const Value.absent(),
                Value<String?> collection = const Value.absent(),
                Value<int> lastUpdated = const Value.absent(),
              }) => FoodsTableCompanion(
                id: id,
                foodId: foodId,
                name: name,
                calories: calories,
                protein: protein,
                carbs: carbs,
                fats: fats,
                sugar: sugar,
                labels: labels,
                ingredients: ingredients,
                station: station,
                collection: collection,
                lastUpdated: lastUpdated,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String foodId,
                required String name,
                required double calories,
                required double protein,
                required double carbs,
                required double fats,
                required double sugar,
                required String labels,
                required String ingredients,
                required String station,
                Value<String?> collection = const Value.absent(),
                required int lastUpdated,
              }) => FoodsTableCompanion.insert(
                id: id,
                foodId: foodId,
                name: name,
                calories: calories,
                protein: protein,
                carbs: carbs,
                fats: fats,
                sugar: sugar,
                labels: labels,
                ingredients: ingredients,
                station: station,
                collection: collection,
                lastUpdated: lastUpdated,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FoodsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $FoodsTableTable,
      FoodsTableData,
      $$FoodsTableTableFilterComposer,
      $$FoodsTableTableOrderingComposer,
      $$FoodsTableTableAnnotationComposer,
      $$FoodsTableTableCreateCompanionBuilder,
      $$FoodsTableTableUpdateCompanionBuilder,
      (
        FoodsTableData,
        BaseReferences<_$AppDb, $FoodsTableTable, FoodsTableData>,
      ),
      FoodsTableData,
      PrefetchHooks Function()
    >;
typedef $$DiningHallFoodsTableTableCreateCompanionBuilder =
    DiningHallFoodsTableCompanion Function({
      Value<int> id,
      required String diningHall,
      required String date,
      required String mealTime,
      required String miniFood,
      required int lastUpdated,
    });
typedef $$DiningHallFoodsTableTableUpdateCompanionBuilder =
    DiningHallFoodsTableCompanion Function({
      Value<int> id,
      Value<String> diningHall,
      Value<String> date,
      Value<String> mealTime,
      Value<String> miniFood,
      Value<int> lastUpdated,
    });

class $$DiningHallFoodsTableTableFilterComposer
    extends Composer<_$AppDb, $DiningHallFoodsTableTable> {
  $$DiningHallFoodsTableTableFilterComposer({
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

  ColumnFilters<String> get diningHall => $composableBuilder(
    column: $table.diningHall,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealTime => $composableBuilder(
    column: $table.mealTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get miniFood => $composableBuilder(
    column: $table.miniFood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DiningHallFoodsTableTableOrderingComposer
    extends Composer<_$AppDb, $DiningHallFoodsTableTable> {
  $$DiningHallFoodsTableTableOrderingComposer({
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

  ColumnOrderings<String> get diningHall => $composableBuilder(
    column: $table.diningHall,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealTime => $composableBuilder(
    column: $table.mealTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get miniFood => $composableBuilder(
    column: $table.miniFood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DiningHallFoodsTableTableAnnotationComposer
    extends Composer<_$AppDb, $DiningHallFoodsTableTable> {
  $$DiningHallFoodsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get diningHall => $composableBuilder(
    column: $table.diningHall,
    builder: (column) => column,
  );

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get mealTime =>
      $composableBuilder(column: $table.mealTime, builder: (column) => column);

  GeneratedColumn<String> get miniFood =>
      $composableBuilder(column: $table.miniFood, builder: (column) => column);

  GeneratedColumn<int> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => column,
  );
}

class $$DiningHallFoodsTableTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $DiningHallFoodsTableTable,
          DiningHallFoodsTableData,
          $$DiningHallFoodsTableTableFilterComposer,
          $$DiningHallFoodsTableTableOrderingComposer,
          $$DiningHallFoodsTableTableAnnotationComposer,
          $$DiningHallFoodsTableTableCreateCompanionBuilder,
          $$DiningHallFoodsTableTableUpdateCompanionBuilder,
          (
            DiningHallFoodsTableData,
            BaseReferences<
              _$AppDb,
              $DiningHallFoodsTableTable,
              DiningHallFoodsTableData
            >,
          ),
          DiningHallFoodsTableData,
          PrefetchHooks Function()
        > {
  $$DiningHallFoodsTableTableTableManager(
    _$AppDb db,
    $DiningHallFoodsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiningHallFoodsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiningHallFoodsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DiningHallFoodsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> diningHall = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String> mealTime = const Value.absent(),
                Value<String> miniFood = const Value.absent(),
                Value<int> lastUpdated = const Value.absent(),
              }) => DiningHallFoodsTableCompanion(
                id: id,
                diningHall: diningHall,
                date: date,
                mealTime: mealTime,
                miniFood: miniFood,
                lastUpdated: lastUpdated,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String diningHall,
                required String date,
                required String mealTime,
                required String miniFood,
                required int lastUpdated,
              }) => DiningHallFoodsTableCompanion.insert(
                id: id,
                diningHall: diningHall,
                date: date,
                mealTime: mealTime,
                miniFood: miniFood,
                lastUpdated: lastUpdated,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DiningHallFoodsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $DiningHallFoodsTableTable,
      DiningHallFoodsTableData,
      $$DiningHallFoodsTableTableFilterComposer,
      $$DiningHallFoodsTableTableOrderingComposer,
      $$DiningHallFoodsTableTableAnnotationComposer,
      $$DiningHallFoodsTableTableCreateCompanionBuilder,
      $$DiningHallFoodsTableTableUpdateCompanionBuilder,
      (
        DiningHallFoodsTableData,
        BaseReferences<
          _$AppDb,
          $DiningHallFoodsTableTable,
          DiningHallFoodsTableData
        >,
      ),
      DiningHallFoodsTableData,
      PrefetchHooks Function()
    >;
typedef $$DiningHallsTableTableCreateCompanionBuilder =
    DiningHallsTableCompanion Function({
      Value<int> id,
      required String diningHallId,
      required String name,
      required String schedule,
    });
typedef $$DiningHallsTableTableUpdateCompanionBuilder =
    DiningHallsTableCompanion Function({
      Value<int> id,
      Value<String> diningHallId,
      Value<String> name,
      Value<String> schedule,
    });

class $$DiningHallsTableTableFilterComposer
    extends Composer<_$AppDb, $DiningHallsTableTable> {
  $$DiningHallsTableTableFilterComposer({
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

  ColumnFilters<String> get diningHallId => $composableBuilder(
    column: $table.diningHallId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get schedule => $composableBuilder(
    column: $table.schedule,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DiningHallsTableTableOrderingComposer
    extends Composer<_$AppDb, $DiningHallsTableTable> {
  $$DiningHallsTableTableOrderingComposer({
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

  ColumnOrderings<String> get diningHallId => $composableBuilder(
    column: $table.diningHallId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get schedule => $composableBuilder(
    column: $table.schedule,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DiningHallsTableTableAnnotationComposer
    extends Composer<_$AppDb, $DiningHallsTableTable> {
  $$DiningHallsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get diningHallId => $composableBuilder(
    column: $table.diningHallId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get schedule =>
      $composableBuilder(column: $table.schedule, builder: (column) => column);
}

class $$DiningHallsTableTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $DiningHallsTableTable,
          DiningHallsTableData,
          $$DiningHallsTableTableFilterComposer,
          $$DiningHallsTableTableOrderingComposer,
          $$DiningHallsTableTableAnnotationComposer,
          $$DiningHallsTableTableCreateCompanionBuilder,
          $$DiningHallsTableTableUpdateCompanionBuilder,
          (
            DiningHallsTableData,
            BaseReferences<
              _$AppDb,
              $DiningHallsTableTable,
              DiningHallsTableData
            >,
          ),
          DiningHallsTableData,
          PrefetchHooks Function()
        > {
  $$DiningHallsTableTableTableManager(_$AppDb db, $DiningHallsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiningHallsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiningHallsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiningHallsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> diningHallId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> schedule = const Value.absent(),
              }) => DiningHallsTableCompanion(
                id: id,
                diningHallId: diningHallId,
                name: name,
                schedule: schedule,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String diningHallId,
                required String name,
                required String schedule,
              }) => DiningHallsTableCompanion.insert(
                id: id,
                diningHallId: diningHallId,
                name: name,
                schedule: schedule,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DiningHallsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $DiningHallsTableTable,
      DiningHallsTableData,
      $$DiningHallsTableTableFilterComposer,
      $$DiningHallsTableTableOrderingComposer,
      $$DiningHallsTableTableAnnotationComposer,
      $$DiningHallsTableTableCreateCompanionBuilder,
      $$DiningHallsTableTableUpdateCompanionBuilder,
      (
        DiningHallsTableData,
        BaseReferences<_$AppDb, $DiningHallsTableTable, DiningHallsTableData>,
      ),
      DiningHallsTableData,
      PrefetchHooks Function()
    >;

class $AppDbManager {
  final _$AppDb _db;
  $AppDbManager(this._db);
  $$UsersTableTableTableManager get usersTable =>
      $$UsersTableTableTableManager(_db, _db.usersTable);
  $$MealsTableTableTableManager get mealsTable =>
      $$MealsTableTableTableManager(_db, _db.mealsTable);
  $$FoodsTableTableTableManager get foodsTable =>
      $$FoodsTableTableTableManager(_db, _db.foodsTable);
  $$DiningHallFoodsTableTableTableManager get diningHallFoodsTable =>
      $$DiningHallFoodsTableTableTableManager(_db, _db.diningHallFoodsTable);
  $$DiningHallsTableTableTableManager get diningHallsTable =>
      $$DiningHallsTableTableTableManager(_db, _db.diningHallsTable);
}
