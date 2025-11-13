// dart format width=80
// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
import 'package:drift/drift.dart';

class UsersTable extends Table with TableInfo<UsersTable, UsersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  UsersTable(this.attachedDatabase, [this._alias]);
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
  late final GeneratedColumn<String> uid = GeneratedColumn<String>(
    'uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<bool> useDietary = GeneratedColumn<bool>(
    'use_dietary',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("use_dietary" IN (0, 1))',
    ),
  );
  late final GeneratedColumn<bool> useMealPlanning = GeneratedColumn<bool>(
    'use_meal_planning',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("use_meal_planning" IN (0, 1))',
    ),
  );
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
    'age',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<int> weight = GeneratedColumn<int>(
    'weight',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
    'height',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> goal = GeneratedColumn<String>(
    'goal',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> dietaryRestrictions =
      GeneratedColumn<String>(
        'dietary_restrictions',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  late final GeneratedColumn<String> mealPlan = GeneratedColumn<String>(
    'meal_plan',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> diningCourtRanking =
      GeneratedColumn<String>(
        'dining_court_ranking',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  late final GeneratedColumn<String> macros = GeneratedColumn<String>(
    'macros',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<int> mealsPerDay = GeneratedColumn<int>(
    'meals_per_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('2'),
  );
  late final GeneratedColumn<String> activityLevel = GeneratedColumn<String>(
    'activity_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('\'sedentary\''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    uid,
    name,
    useDietary,
    useMealPlanning,
    gender,
    age,
    weight,
    height,
    goal,
    dietaryRestrictions,
    mealPlan,
    diningCourtRanking,
    macros,
    mealsPerDay,
    activityLevel,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users_table';
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
      useDietary: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}use_dietary'],
      )!,
      useMealPlanning: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}use_meal_planning'],
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
      macros: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}macros'],
      )!,
      mealsPerDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}meals_per_day'],
      )!,
      activityLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_level'],
      )!,
    );
  }

  @override
  UsersTable createAlias(String alias) {
    return UsersTable(attachedDatabase, alias);
  }
}

class UsersTableData extends DataClass implements Insertable<UsersTableData> {
  final int id;
  final String uid;
  final String name;
  final bool useDietary;
  final bool useMealPlanning;
  final String gender;
  final int age;
  final int weight;
  final int height;
  final String goal;
  final String dietaryRestrictions;
  final String mealPlan;
  final String diningCourtRanking;
  final String macros;
  final int mealsPerDay;
  final String activityLevel;
  const UsersTableData({
    required this.id,
    required this.uid,
    required this.name,
    required this.useDietary,
    required this.useMealPlanning,
    required this.gender,
    required this.age,
    required this.weight,
    required this.height,
    required this.goal,
    required this.dietaryRestrictions,
    required this.mealPlan,
    required this.diningCourtRanking,
    required this.macros,
    required this.mealsPerDay,
    required this.activityLevel,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uid'] = Variable<String>(uid);
    map['name'] = Variable<String>(name);
    map['use_dietary'] = Variable<bool>(useDietary);
    map['use_meal_planning'] = Variable<bool>(useMealPlanning);
    map['gender'] = Variable<String>(gender);
    map['age'] = Variable<int>(age);
    map['weight'] = Variable<int>(weight);
    map['height'] = Variable<int>(height);
    map['goal'] = Variable<String>(goal);
    map['dietary_restrictions'] = Variable<String>(dietaryRestrictions);
    map['meal_plan'] = Variable<String>(mealPlan);
    map['dining_court_ranking'] = Variable<String>(diningCourtRanking);
    map['macros'] = Variable<String>(macros);
    map['meals_per_day'] = Variable<int>(mealsPerDay);
    map['activity_level'] = Variable<String>(activityLevel);
    return map;
  }

  UsersTableCompanion toCompanion(bool nullToAbsent) {
    return UsersTableCompanion(
      id: Value(id),
      uid: Value(uid),
      name: Value(name),
      useDietary: Value(useDietary),
      useMealPlanning: Value(useMealPlanning),
      gender: Value(gender),
      age: Value(age),
      weight: Value(weight),
      height: Value(height),
      goal: Value(goal),
      dietaryRestrictions: Value(dietaryRestrictions),
      mealPlan: Value(mealPlan),
      diningCourtRanking: Value(diningCourtRanking),
      macros: Value(macros),
      mealsPerDay: Value(mealsPerDay),
      activityLevel: Value(activityLevel),
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
      useDietary: serializer.fromJson<bool>(json['useDietary']),
      useMealPlanning: serializer.fromJson<bool>(json['useMealPlanning']),
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
      macros: serializer.fromJson<String>(json['macros']),
      mealsPerDay: serializer.fromJson<int>(json['mealsPerDay']),
      activityLevel: serializer.fromJson<String>(json['activityLevel']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uid': serializer.toJson<String>(uid),
      'name': serializer.toJson<String>(name),
      'useDietary': serializer.toJson<bool>(useDietary),
      'useMealPlanning': serializer.toJson<bool>(useMealPlanning),
      'gender': serializer.toJson<String>(gender),
      'age': serializer.toJson<int>(age),
      'weight': serializer.toJson<int>(weight),
      'height': serializer.toJson<int>(height),
      'goal': serializer.toJson<String>(goal),
      'dietaryRestrictions': serializer.toJson<String>(dietaryRestrictions),
      'mealPlan': serializer.toJson<String>(mealPlan),
      'diningCourtRanking': serializer.toJson<String>(diningCourtRanking),
      'macros': serializer.toJson<String>(macros),
      'mealsPerDay': serializer.toJson<int>(mealsPerDay),
      'activityLevel': serializer.toJson<String>(activityLevel),
    };
  }

  UsersTableData copyWith({
    int? id,
    String? uid,
    String? name,
    bool? useDietary,
    bool? useMealPlanning,
    String? gender,
    int? age,
    int? weight,
    int? height,
    String? goal,
    String? dietaryRestrictions,
    String? mealPlan,
    String? diningCourtRanking,
    String? macros,
    int? mealsPerDay,
    String? activityLevel,
  }) => UsersTableData(
    id: id ?? this.id,
    uid: uid ?? this.uid,
    name: name ?? this.name,
    useDietary: useDietary ?? this.useDietary,
    useMealPlanning: useMealPlanning ?? this.useMealPlanning,
    gender: gender ?? this.gender,
    age: age ?? this.age,
    weight: weight ?? this.weight,
    height: height ?? this.height,
    goal: goal ?? this.goal,
    dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
    mealPlan: mealPlan ?? this.mealPlan,
    diningCourtRanking: diningCourtRanking ?? this.diningCourtRanking,
    macros: macros ?? this.macros,
    mealsPerDay: mealsPerDay ?? this.mealsPerDay,
    activityLevel: activityLevel ?? this.activityLevel,
  );
  UsersTableData copyWithCompanion(UsersTableCompanion data) {
    return UsersTableData(
      id: data.id.present ? data.id.value : this.id,
      uid: data.uid.present ? data.uid.value : this.uid,
      name: data.name.present ? data.name.value : this.name,
      useDietary: data.useDietary.present
          ? data.useDietary.value
          : this.useDietary,
      useMealPlanning: data.useMealPlanning.present
          ? data.useMealPlanning.value
          : this.useMealPlanning,
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
      macros: data.macros.present ? data.macros.value : this.macros,
      mealsPerDay: data.mealsPerDay.present
          ? data.mealsPerDay.value
          : this.mealsPerDay,
      activityLevel: data.activityLevel.present
          ? data.activityLevel.value
          : this.activityLevel,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsersTableData(')
          ..write('id: $id, ')
          ..write('uid: $uid, ')
          ..write('name: $name, ')
          ..write('useDietary: $useDietary, ')
          ..write('useMealPlanning: $useMealPlanning, ')
          ..write('gender: $gender, ')
          ..write('age: $age, ')
          ..write('weight: $weight, ')
          ..write('height: $height, ')
          ..write('goal: $goal, ')
          ..write('dietaryRestrictions: $dietaryRestrictions, ')
          ..write('mealPlan: $mealPlan, ')
          ..write('diningCourtRanking: $diningCourtRanking, ')
          ..write('macros: $macros, ')
          ..write('mealsPerDay: $mealsPerDay, ')
          ..write('activityLevel: $activityLevel')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    uid,
    name,
    useDietary,
    useMealPlanning,
    gender,
    age,
    weight,
    height,
    goal,
    dietaryRestrictions,
    mealPlan,
    diningCourtRanking,
    macros,
    mealsPerDay,
    activityLevel,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsersTableData &&
          other.id == this.id &&
          other.uid == this.uid &&
          other.name == this.name &&
          other.useDietary == this.useDietary &&
          other.useMealPlanning == this.useMealPlanning &&
          other.gender == this.gender &&
          other.age == this.age &&
          other.weight == this.weight &&
          other.height == this.height &&
          other.goal == this.goal &&
          other.dietaryRestrictions == this.dietaryRestrictions &&
          other.mealPlan == this.mealPlan &&
          other.diningCourtRanking == this.diningCourtRanking &&
          other.macros == this.macros &&
          other.mealsPerDay == this.mealsPerDay &&
          other.activityLevel == this.activityLevel);
}

class UsersTableCompanion extends UpdateCompanion<UsersTableData> {
  final Value<int> id;
  final Value<String> uid;
  final Value<String> name;
  final Value<bool> useDietary;
  final Value<bool> useMealPlanning;
  final Value<String> gender;
  final Value<int> age;
  final Value<int> weight;
  final Value<int> height;
  final Value<String> goal;
  final Value<String> dietaryRestrictions;
  final Value<String> mealPlan;
  final Value<String> diningCourtRanking;
  final Value<String> macros;
  final Value<int> mealsPerDay;
  final Value<String> activityLevel;
  const UsersTableCompanion({
    this.id = const Value.absent(),
    this.uid = const Value.absent(),
    this.name = const Value.absent(),
    this.useDietary = const Value.absent(),
    this.useMealPlanning = const Value.absent(),
    this.gender = const Value.absent(),
    this.age = const Value.absent(),
    this.weight = const Value.absent(),
    this.height = const Value.absent(),
    this.goal = const Value.absent(),
    this.dietaryRestrictions = const Value.absent(),
    this.mealPlan = const Value.absent(),
    this.diningCourtRanking = const Value.absent(),
    this.macros = const Value.absent(),
    this.mealsPerDay = const Value.absent(),
    this.activityLevel = const Value.absent(),
  });
  UsersTableCompanion.insert({
    this.id = const Value.absent(),
    required String uid,
    required String name,
    required bool useDietary,
    required bool useMealPlanning,
    required String gender,
    required int age,
    required int weight,
    required int height,
    required String goal,
    required String dietaryRestrictions,
    required String mealPlan,
    required String diningCourtRanking,
    required String macros,
    this.mealsPerDay = const Value.absent(),
    this.activityLevel = const Value.absent(),
  }) : uid = Value(uid),
       name = Value(name),
       useDietary = Value(useDietary),
       useMealPlanning = Value(useMealPlanning),
       gender = Value(gender),
       age = Value(age),
       weight = Value(weight),
       height = Value(height),
       goal = Value(goal),
       dietaryRestrictions = Value(dietaryRestrictions),
       mealPlan = Value(mealPlan),
       diningCourtRanking = Value(diningCourtRanking),
       macros = Value(macros);
  static Insertable<UsersTableData> custom({
    Expression<int>? id,
    Expression<String>? uid,
    Expression<String>? name,
    Expression<bool>? useDietary,
    Expression<bool>? useMealPlanning,
    Expression<String>? gender,
    Expression<int>? age,
    Expression<int>? weight,
    Expression<int>? height,
    Expression<String>? goal,
    Expression<String>? dietaryRestrictions,
    Expression<String>? mealPlan,
    Expression<String>? diningCourtRanking,
    Expression<String>? macros,
    Expression<int>? mealsPerDay,
    Expression<String>? activityLevel,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uid != null) 'uid': uid,
      if (name != null) 'name': name,
      if (useDietary != null) 'use_dietary': useDietary,
      if (useMealPlanning != null) 'use_meal_planning': useMealPlanning,
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
      if (macros != null) 'macros': macros,
      if (mealsPerDay != null) 'meals_per_day': mealsPerDay,
      if (activityLevel != null) 'activity_level': activityLevel,
    });
  }

  UsersTableCompanion copyWith({
    Value<int>? id,
    Value<String>? uid,
    Value<String>? name,
    Value<bool>? useDietary,
    Value<bool>? useMealPlanning,
    Value<String>? gender,
    Value<int>? age,
    Value<int>? weight,
    Value<int>? height,
    Value<String>? goal,
    Value<String>? dietaryRestrictions,
    Value<String>? mealPlan,
    Value<String>? diningCourtRanking,
    Value<String>? macros,
    Value<int>? mealsPerDay,
    Value<String>? activityLevel,
  }) {
    return UsersTableCompanion(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      useDietary: useDietary ?? this.useDietary,
      useMealPlanning: useMealPlanning ?? this.useMealPlanning,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      goal: goal ?? this.goal,
      dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
      mealPlan: mealPlan ?? this.mealPlan,
      diningCourtRanking: diningCourtRanking ?? this.diningCourtRanking,
      macros: macros ?? this.macros,
      mealsPerDay: mealsPerDay ?? this.mealsPerDay,
      activityLevel: activityLevel ?? this.activityLevel,
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
    if (useDietary.present) {
      map['use_dietary'] = Variable<bool>(useDietary.value);
    }
    if (useMealPlanning.present) {
      map['use_meal_planning'] = Variable<bool>(useMealPlanning.value);
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
    if (macros.present) {
      map['macros'] = Variable<String>(macros.value);
    }
    if (mealsPerDay.present) {
      map['meals_per_day'] = Variable<int>(mealsPerDay.value);
    }
    if (activityLevel.present) {
      map['activity_level'] = Variable<String>(activityLevel.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersTableCompanion(')
          ..write('id: $id, ')
          ..write('uid: $uid, ')
          ..write('name: $name, ')
          ..write('useDietary: $useDietary, ')
          ..write('useMealPlanning: $useMealPlanning, ')
          ..write('gender: $gender, ')
          ..write('age: $age, ')
          ..write('weight: $weight, ')
          ..write('height: $height, ')
          ..write('goal: $goal, ')
          ..write('dietaryRestrictions: $dietaryRestrictions, ')
          ..write('mealPlan: $mealPlan, ')
          ..write('diningCourtRanking: $diningCourtRanking, ')
          ..write('macros: $macros, ')
          ..write('mealsPerDay: $mealsPerDay, ')
          ..write('activityLevel: $activityLevel')
          ..write(')'))
        .toString();
  }
}

class MealsTable extends Table with TableInfo<MealsTable, MealsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  MealsTable(this.attachedDatabase, [this._alias]);
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
  late final GeneratedColumn<String> diningCourt = GeneratedColumn<String>(
    'dining_court',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> mealTime = GeneratedColumn<String>(
    'meal_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> foodItems = GeneratedColumn<String>(
    'food_items',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<double> totalCalories = GeneratedColumn<double>(
    'total_calories',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<double> totalProtein = GeneratedColumn<double>(
    'total_protein',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> mealId = GeneratedColumn<String>(
    'meal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<double> totalCarbs = GeneratedColumn<double>(
    'total_carbs',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<double> totalFats = GeneratedColumn<double>(
    'total_fats',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<double> totalSugar = GeneratedColumn<double>(
    'total_sugar',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('0.0'),
  );
  late final GeneratedColumn<double> totalSaturatedFat =
      GeneratedColumn<double>(
        'total_saturated_fat',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const CustomExpression('0.0'),
      );
  late final GeneratedColumn<double> totalAddedSugars = GeneratedColumn<double>(
    'total_added_sugars',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('0.0'),
  );
  late final GeneratedColumn<bool> isFavorited = GeneratedColumn<bool>(
    'is_favorited',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorited" IN (0, 1))',
    ),
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<bool> isAIMeal = GeneratedColumn<bool>(
    'is_a_i_meal',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_a_i_meal" IN (0, 1))',
    ),
    defaultValue: const CustomExpression('0'),
  );
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
    mealId,
    totalCarbs,
    totalFats,
    totalSugar,
    totalSaturatedFat,
    totalAddedSugars,
    isFavorited,
    isAIMeal,
    lastUpdated,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meals_table';
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
      mealId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_id'],
      )!,
      totalCarbs: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_carbs'],
      )!,
      totalFats: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_fats'],
      )!,
      totalSugar: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_sugar'],
      )!,
      totalSaturatedFat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_saturated_fat'],
      )!,
      totalAddedSugars: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_added_sugars'],
      )!,
      isFavorited: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorited'],
      )!,
      isAIMeal: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_a_i_meal'],
      )!,
      lastUpdated: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_updated'],
      )!,
    );
  }

  @override
  MealsTable createAlias(String alias) {
    return MealsTable(attachedDatabase, alias);
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
  final String mealId;
  final double totalCarbs;
  final double totalFats;
  final double totalSugar;
  final double totalSaturatedFat;
  final double totalAddedSugars;
  final bool isFavorited;
  final bool isAIMeal;
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
    required this.mealId,
    required this.totalCarbs,
    required this.totalFats,
    required this.totalSugar,
    required this.totalSaturatedFat,
    required this.totalAddedSugars,
    required this.isFavorited,
    required this.isAIMeal,
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
    map['meal_id'] = Variable<String>(mealId);
    map['total_carbs'] = Variable<double>(totalCarbs);
    map['total_fats'] = Variable<double>(totalFats);
    map['total_sugar'] = Variable<double>(totalSugar);
    map['total_saturated_fat'] = Variable<double>(totalSaturatedFat);
    map['total_added_sugars'] = Variable<double>(totalAddedSugars);
    map['is_favorited'] = Variable<bool>(isFavorited);
    map['is_a_i_meal'] = Variable<bool>(isAIMeal);
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
      mealId: Value(mealId),
      totalCarbs: Value(totalCarbs),
      totalFats: Value(totalFats),
      totalSugar: Value(totalSugar),
      totalSaturatedFat: Value(totalSaturatedFat),
      totalAddedSugars: Value(totalAddedSugars),
      isFavorited: Value(isFavorited),
      isAIMeal: Value(isAIMeal),
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
      mealId: serializer.fromJson<String>(json['mealId']),
      totalCarbs: serializer.fromJson<double>(json['totalCarbs']),
      totalFats: serializer.fromJson<double>(json['totalFats']),
      totalSugar: serializer.fromJson<double>(json['totalSugar']),
      totalSaturatedFat: serializer.fromJson<double>(json['totalSaturatedFat']),
      totalAddedSugars: serializer.fromJson<double>(json['totalAddedSugars']),
      isFavorited: serializer.fromJson<bool>(json['isFavorited']),
      isAIMeal: serializer.fromJson<bool>(json['isAIMeal']),
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
      'mealId': serializer.toJson<String>(mealId),
      'totalCarbs': serializer.toJson<double>(totalCarbs),
      'totalFats': serializer.toJson<double>(totalFats),
      'totalSugar': serializer.toJson<double>(totalSugar),
      'totalSaturatedFat': serializer.toJson<double>(totalSaturatedFat),
      'totalAddedSugars': serializer.toJson<double>(totalAddedSugars),
      'isFavorited': serializer.toJson<bool>(isFavorited),
      'isAIMeal': serializer.toJson<bool>(isAIMeal),
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
    String? mealId,
    double? totalCarbs,
    double? totalFats,
    double? totalSugar,
    double? totalSaturatedFat,
    double? totalAddedSugars,
    bool? isFavorited,
    bool? isAIMeal,
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
    mealId: mealId ?? this.mealId,
    totalCarbs: totalCarbs ?? this.totalCarbs,
    totalFats: totalFats ?? this.totalFats,
    totalSugar: totalSugar ?? this.totalSugar,
    totalSaturatedFat: totalSaturatedFat ?? this.totalSaturatedFat,
    totalAddedSugars: totalAddedSugars ?? this.totalAddedSugars,
    isFavorited: isFavorited ?? this.isFavorited,
    isAIMeal: isAIMeal ?? this.isAIMeal,
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
      mealId: data.mealId.present ? data.mealId.value : this.mealId,
      totalCarbs: data.totalCarbs.present
          ? data.totalCarbs.value
          : this.totalCarbs,
      totalFats: data.totalFats.present ? data.totalFats.value : this.totalFats,
      totalSugar: data.totalSugar.present
          ? data.totalSugar.value
          : this.totalSugar,
      totalSaturatedFat: data.totalSaturatedFat.present
          ? data.totalSaturatedFat.value
          : this.totalSaturatedFat,
      totalAddedSugars: data.totalAddedSugars.present
          ? data.totalAddedSugars.value
          : this.totalAddedSugars,
      isFavorited: data.isFavorited.present
          ? data.isFavorited.value
          : this.isFavorited,
      isAIMeal: data.isAIMeal.present ? data.isAIMeal.value : this.isAIMeal,
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
          ..write('mealId: $mealId, ')
          ..write('totalCarbs: $totalCarbs, ')
          ..write('totalFats: $totalFats, ')
          ..write('totalSugar: $totalSugar, ')
          ..write('totalSaturatedFat: $totalSaturatedFat, ')
          ..write('totalAddedSugars: $totalAddedSugars, ')
          ..write('isFavorited: $isFavorited, ')
          ..write('isAIMeal: $isAIMeal, ')
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
    mealId,
    totalCarbs,
    totalFats,
    totalSugar,
    totalSaturatedFat,
    totalAddedSugars,
    isFavorited,
    isAIMeal,
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
          other.mealId == this.mealId &&
          other.totalCarbs == this.totalCarbs &&
          other.totalFats == this.totalFats &&
          other.totalSugar == this.totalSugar &&
          other.totalSaturatedFat == this.totalSaturatedFat &&
          other.totalAddedSugars == this.totalAddedSugars &&
          other.isFavorited == this.isFavorited &&
          other.isAIMeal == this.isAIMeal &&
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
  final Value<String> mealId;
  final Value<double> totalCarbs;
  final Value<double> totalFats;
  final Value<double> totalSugar;
  final Value<double> totalSaturatedFat;
  final Value<double> totalAddedSugars;
  final Value<bool> isFavorited;
  final Value<bool> isAIMeal;
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
    this.mealId = const Value.absent(),
    this.totalCarbs = const Value.absent(),
    this.totalFats = const Value.absent(),
    this.totalSugar = const Value.absent(),
    this.totalSaturatedFat = const Value.absent(),
    this.totalAddedSugars = const Value.absent(),
    this.isFavorited = const Value.absent(),
    this.isAIMeal = const Value.absent(),
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
    required String mealId,
    required double totalCarbs,
    required double totalFats,
    this.totalSugar = const Value.absent(),
    this.totalSaturatedFat = const Value.absent(),
    this.totalAddedSugars = const Value.absent(),
    this.isFavorited = const Value.absent(),
    this.isAIMeal = const Value.absent(),
    required int lastUpdated,
  }) : diningCourt = Value(diningCourt),
       date = Value(date),
       mealTime = Value(mealTime),
       name = Value(name),
       foodItems = Value(foodItems),
       totalCalories = Value(totalCalories),
       totalProtein = Value(totalProtein),
       mealId = Value(mealId),
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
    Expression<String>? mealId,
    Expression<double>? totalCarbs,
    Expression<double>? totalFats,
    Expression<double>? totalSugar,
    Expression<double>? totalSaturatedFat,
    Expression<double>? totalAddedSugars,
    Expression<bool>? isFavorited,
    Expression<bool>? isAIMeal,
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
      if (mealId != null) 'meal_id': mealId,
      if (totalCarbs != null) 'total_carbs': totalCarbs,
      if (totalFats != null) 'total_fats': totalFats,
      if (totalSugar != null) 'total_sugar': totalSugar,
      if (totalSaturatedFat != null) 'total_saturated_fat': totalSaturatedFat,
      if (totalAddedSugars != null) 'total_added_sugars': totalAddedSugars,
      if (isFavorited != null) 'is_favorited': isFavorited,
      if (isAIMeal != null) 'is_a_i_meal': isAIMeal,
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
    Value<String>? mealId,
    Value<double>? totalCarbs,
    Value<double>? totalFats,
    Value<double>? totalSugar,
    Value<double>? totalSaturatedFat,
    Value<double>? totalAddedSugars,
    Value<bool>? isFavorited,
    Value<bool>? isAIMeal,
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
      mealId: mealId ?? this.mealId,
      totalCarbs: totalCarbs ?? this.totalCarbs,
      totalFats: totalFats ?? this.totalFats,
      totalSugar: totalSugar ?? this.totalSugar,
      totalSaturatedFat: totalSaturatedFat ?? this.totalSaturatedFat,
      totalAddedSugars: totalAddedSugars ?? this.totalAddedSugars,
      isFavorited: isFavorited ?? this.isFavorited,
      isAIMeal: isAIMeal ?? this.isAIMeal,
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
    if (mealId.present) {
      map['meal_id'] = Variable<String>(mealId.value);
    }
    if (totalCarbs.present) {
      map['total_carbs'] = Variable<double>(totalCarbs.value);
    }
    if (totalFats.present) {
      map['total_fats'] = Variable<double>(totalFats.value);
    }
    if (totalSugar.present) {
      map['total_sugar'] = Variable<double>(totalSugar.value);
    }
    if (totalSaturatedFat.present) {
      map['total_saturated_fat'] = Variable<double>(totalSaturatedFat.value);
    }
    if (totalAddedSugars.present) {
      map['total_added_sugars'] = Variable<double>(totalAddedSugars.value);
    }
    if (isFavorited.present) {
      map['is_favorited'] = Variable<bool>(isFavorited.value);
    }
    if (isAIMeal.present) {
      map['is_a_i_meal'] = Variable<bool>(isAIMeal.value);
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
          ..write('mealId: $mealId, ')
          ..write('totalCarbs: $totalCarbs, ')
          ..write('totalFats: $totalFats, ')
          ..write('totalSugar: $totalSugar, ')
          ..write('totalSaturatedFat: $totalSaturatedFat, ')
          ..write('totalAddedSugars: $totalAddedSugars, ')
          ..write('isFavorited: $isFavorited, ')
          ..write('isAIMeal: $isAIMeal, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }
}

class FoodsTable extends Table with TableInfo<FoodsTable, FoodsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  FoodsTable(this.attachedDatabase, [this._alias]);
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
  late final GeneratedColumn<String> foodId = GeneratedColumn<String>(
    'food_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<double> calories = GeneratedColumn<double>(
    'calories',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<double> protein = GeneratedColumn<double>(
    'protein',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<double> carbs = GeneratedColumn<double>(
    'carbs',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<double> fats = GeneratedColumn<double>(
    'fats',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<double> sugar = GeneratedColumn<double>(
    'sugar',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> labels = GeneratedColumn<String>(
    'labels',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> ingredients = GeneratedColumn<String>(
    'ingredients',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> station = GeneratedColumn<String>(
    'station',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> collection = GeneratedColumn<String>(
    'collection',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<int> lastUpdated = GeneratedColumn<int>(
    'last_updated',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<bool> isFavorited = GeneratedColumn<bool>(
    'is_favorited',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorited" IN (0, 1))',
    ),
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<String> servingSize = GeneratedColumn<String>(
    'serving_size',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<double> saturatedFat = GeneratedColumn<double>(
    'saturated_fat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('0.0'),
  );
  late final GeneratedColumn<double> addedSugars = GeneratedColumn<double>(
    'added_sugars',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('0.0'),
  );
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('1'),
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
    isFavorited,
    servingSize,
    saturatedFat,
    addedSugars,
    quantity,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'foods_table';
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
      isFavorited: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorited'],
      )!,
      servingSize: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}serving_size'],
      )!,
      saturatedFat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}saturated_fat'],
      )!,
      addedSugars: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}added_sugars'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
    );
  }

  @override
  FoodsTable createAlias(String alias) {
    return FoodsTable(attachedDatabase, alias);
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
  final bool isFavorited;
  final String servingSize;
  final double saturatedFat;
  final double addedSugars;
  final int quantity;
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
    required this.isFavorited,
    required this.servingSize,
    required this.saturatedFat,
    required this.addedSugars,
    required this.quantity,
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
    map['is_favorited'] = Variable<bool>(isFavorited);
    map['serving_size'] = Variable<String>(servingSize);
    map['saturated_fat'] = Variable<double>(saturatedFat);
    map['added_sugars'] = Variable<double>(addedSugars);
    map['quantity'] = Variable<int>(quantity);
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
      isFavorited: Value(isFavorited),
      servingSize: Value(servingSize),
      saturatedFat: Value(saturatedFat),
      addedSugars: Value(addedSugars),
      quantity: Value(quantity),
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
      isFavorited: serializer.fromJson<bool>(json['isFavorited']),
      servingSize: serializer.fromJson<String>(json['servingSize']),
      saturatedFat: serializer.fromJson<double>(json['saturatedFat']),
      addedSugars: serializer.fromJson<double>(json['addedSugars']),
      quantity: serializer.fromJson<int>(json['quantity']),
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
      'isFavorited': serializer.toJson<bool>(isFavorited),
      'servingSize': serializer.toJson<String>(servingSize),
      'saturatedFat': serializer.toJson<double>(saturatedFat),
      'addedSugars': serializer.toJson<double>(addedSugars),
      'quantity': serializer.toJson<int>(quantity),
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
    bool? isFavorited,
    String? servingSize,
    double? saturatedFat,
    double? addedSugars,
    int? quantity,
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
    isFavorited: isFavorited ?? this.isFavorited,
    servingSize: servingSize ?? this.servingSize,
    saturatedFat: saturatedFat ?? this.saturatedFat,
    addedSugars: addedSugars ?? this.addedSugars,
    quantity: quantity ?? this.quantity,
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
      isFavorited: data.isFavorited.present
          ? data.isFavorited.value
          : this.isFavorited,
      servingSize: data.servingSize.present
          ? data.servingSize.value
          : this.servingSize,
      saturatedFat: data.saturatedFat.present
          ? data.saturatedFat.value
          : this.saturatedFat,
      addedSugars: data.addedSugars.present
          ? data.addedSugars.value
          : this.addedSugars,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
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
          ..write('lastUpdated: $lastUpdated, ')
          ..write('isFavorited: $isFavorited, ')
          ..write('servingSize: $servingSize, ')
          ..write('saturatedFat: $saturatedFat, ')
          ..write('addedSugars: $addedSugars, ')
          ..write('quantity: $quantity')
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
    isFavorited,
    servingSize,
    saturatedFat,
    addedSugars,
    quantity,
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
          other.lastUpdated == this.lastUpdated &&
          other.isFavorited == this.isFavorited &&
          other.servingSize == this.servingSize &&
          other.saturatedFat == this.saturatedFat &&
          other.addedSugars == this.addedSugars &&
          other.quantity == this.quantity);
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
  final Value<bool> isFavorited;
  final Value<String> servingSize;
  final Value<double> saturatedFat;
  final Value<double> addedSugars;
  final Value<int> quantity;
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
    this.isFavorited = const Value.absent(),
    this.servingSize = const Value.absent(),
    this.saturatedFat = const Value.absent(),
    this.addedSugars = const Value.absent(),
    this.quantity = const Value.absent(),
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
    this.isFavorited = const Value.absent(),
    required String servingSize,
    this.saturatedFat = const Value.absent(),
    this.addedSugars = const Value.absent(),
    this.quantity = const Value.absent(),
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
       lastUpdated = Value(lastUpdated),
       servingSize = Value(servingSize);
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
    Expression<bool>? isFavorited,
    Expression<String>? servingSize,
    Expression<double>? saturatedFat,
    Expression<double>? addedSugars,
    Expression<int>? quantity,
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
      if (isFavorited != null) 'is_favorited': isFavorited,
      if (servingSize != null) 'serving_size': servingSize,
      if (saturatedFat != null) 'saturated_fat': saturatedFat,
      if (addedSugars != null) 'added_sugars': addedSugars,
      if (quantity != null) 'quantity': quantity,
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
    Value<bool>? isFavorited,
    Value<String>? servingSize,
    Value<double>? saturatedFat,
    Value<double>? addedSugars,
    Value<int>? quantity,
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
      isFavorited: isFavorited ?? this.isFavorited,
      servingSize: servingSize ?? this.servingSize,
      saturatedFat: saturatedFat ?? this.saturatedFat,
      addedSugars: addedSugars ?? this.addedSugars,
      quantity: quantity ?? this.quantity,
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
    if (isFavorited.present) {
      map['is_favorited'] = Variable<bool>(isFavorited.value);
    }
    if (servingSize.present) {
      map['serving_size'] = Variable<String>(servingSize.value);
    }
    if (saturatedFat.present) {
      map['saturated_fat'] = Variable<double>(saturatedFat.value);
    }
    if (addedSugars.present) {
      map['added_sugars'] = Variable<double>(addedSugars.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
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
          ..write('lastUpdated: $lastUpdated, ')
          ..write('isFavorited: $isFavorited, ')
          ..write('servingSize: $servingSize, ')
          ..write('saturatedFat: $saturatedFat, ')
          ..write('addedSugars: $addedSugars, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }
}

class DiningHallFoodsTable extends Table
    with TableInfo<DiningHallFoodsTable, DiningHallFoodsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  DiningHallFoodsTable(this.attachedDatabase, [this._alias]);
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
  late final GeneratedColumn<String> diningHall = GeneratedColumn<String>(
    'dining_hall',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> mealTime = GeneratedColumn<String>(
    'meal_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> miniFood = GeneratedColumn<String>(
    'mini_food',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
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
  DiningHallFoodsTable createAlias(String alias) {
    return DiningHallFoodsTable(attachedDatabase, alias);
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

class DiningHallsTable extends Table
    with TableInfo<DiningHallsTable, DiningHallsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  DiningHallsTable(this.attachedDatabase, [this._alias]);
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
  late final GeneratedColumn<String> diningHallId = GeneratedColumn<String>(
    'dining_hall_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
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
  DiningHallsTable createAlias(String alias) {
    return DiningHallsTable(attachedDatabase, alias);
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

class DatabaseAtV7 extends GeneratedDatabase {
  DatabaseAtV7(QueryExecutor e) : super(e);
  late final UsersTable usersTable = UsersTable(this);
  late final MealsTable mealsTable = MealsTable(this);
  late final FoodsTable foodsTable = FoodsTable(this);
  late final DiningHallFoodsTable diningHallFoodsTable = DiningHallFoodsTable(
    this,
  );
  late final DiningHallsTable diningHallsTable = DiningHallsTable(this);
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
  @override
  int get schemaVersion => 7;
}
