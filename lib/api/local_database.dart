import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'local_database.steps.dart';

import 'package:boiler_fuel/api/shared_preferences.dart';
import 'package:boiler_fuel/constants.dart';
import 'package:boiler_fuel/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'package:flutter/material.dart' as mat;

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
part 'local_database.g.dart';

class UsersTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uid => text()();
  TextColumn get name => text()();
  BoolColumn get useDietary => boolean()();
  BoolColumn get useMealPlanning => boolean()();
  TextColumn get gender => text()();
  IntColumn get age => integer()();
  IntColumn get weight => integer()();
  IntColumn get height => integer()();
  TextColumn get goal => text()();
  TextColumn get dietaryRestrictions => text()();
  TextColumn get mealPlan => text()();
  TextColumn get diningCourtRanking => text()();
  TextColumn get macros => text()();
}

class MealsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get diningCourt => text()();
  TextColumn get date => text()();
  TextColumn get mealTime => text()();
  TextColumn get name => text()();
  TextColumn get foodItems => text()();
  RealColumn get totalCalories => real()();
  RealColumn get totalProtein => real()();
  TextColumn get mealId => text()();
  RealColumn get totalCarbs => real()();
  RealColumn get totalFats => real()();
  BoolColumn get isFavorited => boolean().withDefault(const Constant(false))();
  BoolColumn get isAIMeal => boolean().withDefault(const Constant(false))();
  IntColumn get lastUpdated => integer()();
}

class FoodsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get foodId => text()();
  TextColumn get name => text()();
  RealColumn get calories => real()();
  RealColumn get protein => real()();
  RealColumn get carbs => real()();
  RealColumn get fats => real()();
  RealColumn get sugar => real()();
  TextColumn get labels => text()();
  TextColumn get ingredients => text()();
  TextColumn get station => text()();
  TextColumn get collection => text().nullable()();
  IntColumn get lastUpdated => integer()();
  BoolColumn get isFavorited => boolean().withDefault(const Constant(false))();
  TextColumn get servingSize => text()();
  RealColumn get saturatedFat => real().withDefault(const Constant(0))();
  RealColumn get addedSugars => real().withDefault(const Constant(0))();
}

class DiningHallFoodsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get diningHall => text()();
  TextColumn get date => text()();
  TextColumn get mealTime => text()();
  TextColumn get miniFood => text()();
  IntColumn get lastUpdated => integer()();
}

class DiningHallsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get diningHallId => text()();
  TextColumn get name => text()();
  TextColumn get schedule => text()(); // JSON encoded Schedule
}

@DriftDatabase(
  tables: [
    UsersTable,
    MealsTable,
    FoodsTable,
    DiningHallFoodsTable,
    DiningHallsTable,
  ],
)
class AppDb extends _$AppDb {
  AppDb() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: stepByStep(
        from2To3: (m, schema) async {
          await m.addColumn(foodsTable, foodsTable.addedSugars);
          await m.addColumn(foodsTable, foodsTable.saturatedFat);
        },
      ),
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();

    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    // int resetLocalDB = await SharedPrefs.getResetLocalData();
    // try {
    //   if (resetLocalDB <= 32) {
    //     print("Deleting old database to add new columns");
    //     await file.delete();
    //     await SharedPrefs.setResetLocalData(33);
    //     print("Deleted old database - new schema will be created");
    //   }
    // } catch (e) {
    //   print(e);
    // }

    return NativeDatabase.createInBackground(file);
  });
}

class LocalDatabase {
  Future<void> deleteDB(bool fully) async {
    try {
      //delete all tables
      final users = await (localDb.select(localDb.usersTable)).get();
      for (var user in users) {
        await (localDb.delete(
          localDb.usersTable,
        )..where((tbl) => tbl.id.equals(user.id))).go();
      }
      final meals = await (localDb.select(localDb.mealsTable)).get();
      for (var meal in meals) {
        await (localDb.delete(
          localDb.mealsTable,
        )..where((tbl) => tbl.id.equals(meal.id))).go();
      }
      final foods = await (localDb.select(localDb.foodsTable)).get();
      for (var food in foods) {
        await (localDb.delete(
          localDb.foodsTable,
        )..where((tbl) => tbl.id.equals(food.id))).go();
      }
      final dhfs = await (localDb.select(localDb.diningHallFoodsTable)).get();
      for (var dhf in dhfs) {
        await (localDb.delete(
          localDb.diningHallFoodsTable,
        )..where((tbl) => tbl.id.equals(dhf.id))).go();
      }

      if (fully) {
        final diningHalls = await (localDb.select(
          localDb.diningHallsTable,
        )).get();
        for (var dh in diningHalls) {
          await (localDb.delete(
            localDb.diningHallsTable,
          )..where((tbl) => tbl.id.equals(dh.id))).go();
        }
      }
      print("Local database cleared");
    } catch (e) {
      print(e);
    }
  }

  String _dietaryRestrictionsToString(DietaryRestrictions dietaryRestrictions) {
    return jsonEncode(dietaryRestrictions.toMap());
  }

  DietaryRestrictions _stringToDietaryRestrictions(String str) {
    Map<String, dynamic> map = jsonDecode(str);
    return DietaryRestrictions.fromMap(map);
  }

  Future<User?> getUser() async {
    final usersRes = await (localDb.select(localDb.usersTable)).get();
    if (usersRes.isNotEmpty) {
      print("User found: ${usersRes.first.name}");
      return User(
        uid: usersRes.first.uid,
        name: usersRes.first.name,
        useDietary: usersRes.first.useDietary,
        useMealPlanning: usersRes.first.useMealPlanning,
        weight: usersRes.first.weight,
        height: usersRes.first.height,
        age: usersRes.first.age,
        gender: Gender.fromString(usersRes.first.gender),
        goal: Goal.fromString(usersRes.first.goal),
        dietaryRestrictions: _stringToDietaryRestrictions(
          usersRes.first.dietaryRestrictions,
        ),
        macros: MacroResult.fromMap(jsonDecode(usersRes.first.macros)),
        mealPlan: MealPlan.fromString(usersRes.first.mealPlan),
        diningHallRank: usersRes.first.diningCourtRanking.split(","),
      );
    } else {
      print("No user found.");
    }
  }

  Future<void> saveUser(User user) async {
    final usersRes = await (localDb.select(localDb.usersTable)).get();
    if (usersRes.isNotEmpty) {
      // Update existing user
      await (localDb.update(
        localDb.usersTable,
      )..where((tbl) => tbl.id.equals(usersRes.first.id))).write(
        UsersTableCompanion(
          uid: Value(user.uid),
          name: Value(user.name),
          useDietary: Value(user.useDietary),
          useMealPlanning: Value(user.useMealPlanning),
          weight: Value(user.weight),
          height: Value(user.height),
          age: Value(user.age),
          gender: Value(user.gender.toString()),
          goal: Value(user.goal.toString()),
          macros: Value(jsonEncode(user.macros.toMap())),
          dietaryRestrictions: Value(
            _dietaryRestrictionsToString(user.dietaryRestrictions),
          ),
          mealPlan: Value(user.mealPlan.toString()),
          diningCourtRanking: Value(user.diningHallRank.join(",")),
        ),
      );
      print("User updated: ${user.name}");
    } else {
      // Insert new user
      await localDb
          .into(localDb.usersTable)
          .insert(
            UsersTableCompanion(
              uid: Value(user.uid),
              name: Value(user.name),
              useDietary: Value(user.useDietary),
              useMealPlanning: Value(user.useMealPlanning),
              weight: Value(user.weight),
              height: Value(user.height),
              age: Value(user.age),
              gender: Value(user.gender.toString()),
              goal: Value(user.goal.toString()),
              macros: Value(jsonEncode(user.macros.toMap())),
              dietaryRestrictions: Value(
                _dietaryRestrictionsToString(user.dietaryRestrictions),
              ),
              mealPlan: Value(user.mealPlan.toString()),
              diningCourtRanking: Value(user.diningHallRank.join(",")),
            ),
          );
      print("User inserted: ${user.name}");
    }
  }

  Future<void> addMeal(Meal meal, MealTime mealTime, DateTime date) async {
    String dateStr = "${date.year}-${date.month}-${date.day}";

    List<Map<String, dynamic>> foodListMap = meal.foods
        .map((f) => f.toMap())
        .toList();

    final mealsRes =
        await (localDb.select(localDb.mealsTable)
              ..where((tbl) => tbl.date.equals(dateStr))
              ..where((tbl) => tbl.mealTime.equals(mealTime.toString()))
              ..where((tbl) => tbl.diningCourt.equals(meal.diningHall)))
            .get();

    if (mealsRes.isNotEmpty) {
      // Update existing meal
      await (localDb.update(
        localDb.mealsTable,
      )..where((tbl) => tbl.id.equals(mealsRes.first.id))).write(
        MealsTableCompanion(
          diningCourt: Value(meal.diningHall),
          date: Value(dateStr),
          mealTime: Value(mealTime.toString()),
          name: Value(meal.name),
          foodItems: Value(jsonEncode(foodListMap)),
          totalCalories: Value(meal.calories),
          totalProtein: Value(meal.protein),
          totalCarbs: Value(meal.carbs),
          totalFats: Value(meal.fat),
          lastUpdated: Value(DateTime.now().millisecondsSinceEpoch),
          isFavorited: Value(meal.isFavorited),
          mealId: Value(meal.id),
          isAIMeal: Value(meal.isAIGenerated),
        ),
      );
      print("Meal updated: ${meal.name} at ${meal.diningHall}");
    } else {
      // Insert new meal
      await localDb
          .into(localDb.mealsTable)
          .insert(
            MealsTableCompanion(
              diningCourt: Value(meal.diningHall),
              date: Value(dateStr),
              mealTime: Value(mealTime.toString()),
              name: Value(meal.name),
              foodItems: Value(jsonEncode(foodListMap)),
              totalCalories: Value(meal.calories),
              totalProtein: Value(meal.protein),
              totalCarbs: Value(meal.carbs),
              totalFats: Value(meal.fat),
              isFavorited: Value(meal.isFavorited),
              lastUpdated: Value(DateTime.now().millisecondsSinceEpoch),
              mealId: Value(meal.id),
              isAIMeal: Value(meal.isAIGenerated),
            ),
          );
      print("Meal inserted: ${meal.name} at ${meal.diningHall}");
    }
  }

  Future<Map<MealTime, Map<String, Meal>>?> getAIDayMeals() async {
    DateTime now = DateTime.now();
    String dateStr = "${now.year}-${now.month}-${now.day}";

    final mealsRes =
        await (localDb.select(localDb.mealsTable)
              ..where((tbl) => tbl.date.equals(dateStr))
              ..where((tbl) => tbl.isAIMeal))
            .get();

    if (mealsRes.isEmpty) {
      print("No meals found for today.");
      return null;
    }

    Map<MealTime, Map<String, Meal>> meals = {};

    for (var row in mealsRes) {
      MealTime mealTime = MealTime.values.firstWhere(
        (e) => e.toString().split('.').last == row.mealTime,
        orElse: () => MealTime.breakfast,
      );
      String diningHall = row.diningCourt;

      List<dynamic> foodListJson = jsonDecode(row.foodItems);
      List<Food> foods = foodListJson.map((f) {
        return Food.fromMap(f);
      }).toList();

      Meal meal = Meal(
        name: row.name,
        calories: row.totalCalories,
        protein: row.totalProtein,
        fat: row.totalFats,
        carbs: row.totalCarbs,
        diningHall: diningHall,
        foods: foods,
        isFavorited: row.isFavorited,
        id: row.mealId,
        mealTime: mealTime,
        isAIGenerated: row.isAIMeal,
      );

      meals.putIfAbsent(mealTime, () => {});
      meals[mealTime]![diningHall] = meal;
    }

    print("Retrieved ${mealsRes.length} meals for today.");
    return meals;
  }

  Future<void> listenToAIDayMeals(
    StreamController<Map<MealTime, Map<String, Meal>>> controller,
  ) async {
    DateTime now = DateTime.now();
    String dateStr = "${now.year}-${now.month}-${now.day}";

    final query =
        (localDb.select(localDb.mealsTable)
              ..where((tbl) => tbl.date.equals(dateStr))
              ..where((tbl) => tbl.isAIMeal))
            .watch();

    print("Listening to AI Day Meals for date: $dateStr");
    query.listen((mealsRes) {
      if (controller.isClosed) {
        print("Controller is closed, stopping listener.");
        return;
      }
      Map<MealTime, Map<String, Meal>> meals = {};

      for (var row in mealsRes) {
        print("Meal row: ${row.name}, ${row.mealTime}, ${row.diningCourt}");
        MealTime mealTime = MealTime.fromString(
          row.mealTime != "null" ? row.mealTime : "breakfast",
        );
        String diningHall = row.diningCourt;

        List<dynamic> foodListJson = jsonDecode(row.foodItems);
        List<Food> foods = foodListJson.map((f) {
          return Food.fromMap(f);
        }).toList();

        Meal meal = Meal(
          name: row.name,
          calories: row.totalCalories,
          protein: row.totalProtein,
          fat: row.totalFats,
          carbs: row.totalCarbs,
          diningHall: diningHall,
          foods: foods,
          isFavorited: row.isFavorited,
          id: row.mealId,
          isAIGenerated: row.isAIMeal,
          mealTime: mealTime,
        );

        meals.putIfAbsent(mealTime, () => {});
        meals[mealTime]![diningHall] = meal;
      }

      controller.add(meals);
    });
  }

  Future<DateTime?> getLastMeal() async {
    final mealsRes =
        await (localDb.select(localDb.mealsTable)
              ..orderBy([
                (tbl) =>
                    OrderingTerm(expression: tbl.date, mode: OrderingMode.desc),
              ])
              ..limit(1))
            .get();

    if (mealsRes.isNotEmpty) {
      var row = mealsRes.first;
      List<String> dateParts = row.date.split("-");
      if (dateParts.length == 3) {
        int year = int.parse(dateParts[0]);
        int month = int.parse(dateParts[1]);
        int day = int.parse(dateParts[2]);
        return DateTime(year, month, day);
      }
    } else {
      print("No meals found.");
      return null;
    }
  }

  Future<void> updateMeal(String mealId, Meal meal) async {
    final mealsRes = await (localDb.select(
      localDb.mealsTable,
    )..where((tbl) => tbl.mealId.equals(mealId))).get();

    if (mealsRes.isNotEmpty) {
      List<Map<String, dynamic>> foodListMap = meal.foods
          .map((f) => f.toMap())
          .toList();

      // Update existing meal
      await (localDb.update(
        localDb.mealsTable,
      )..where((tbl) => tbl.id.equals(mealsRes.first.id))).write(
        MealsTableCompanion(
          diningCourt: Value(meal.diningHall),
          name: Value(meal.name),
          foodItems: Value(jsonEncode(foodListMap)),
          totalCalories: Value(meal.calories),
          totalProtein: Value(meal.protein),
          totalCarbs: Value(meal.carbs),
          totalFats: Value(meal.fat),
          lastUpdated: Value(DateTime.now().millisecondsSinceEpoch),
          isFavorited: Value(meal.isFavorited),
          mealTime: Value(meal.mealTime.toString()),
          isAIMeal: Value(meal.isAIGenerated),
        ),
      );
      print("Meal updated: ${meal.name} at ${meal.diningHall} with");
    } else {
      print("No meal found with ID: $mealId");
    }
  }

  Future<List<Meal>> getFavoritedMeals() async {
    final mealsRes = await (localDb.select(
      localDb.mealsTable,
    )..where((tbl) => tbl.isFavorited.equals(true))).get();

    List<Meal> meals = [];

    for (var row in mealsRes) {
      List<dynamic> foodListJson = jsonDecode(row.foodItems);
      List<Food> foods = foodListJson.map((f) {
        return Food.fromMap(f);
      }).toList();

      Meal meal = Meal(
        name: row.name,
        calories: row.totalCalories,
        protein: row.totalProtein,
        fat: row.totalFats,
        carbs: row.totalCarbs,
        diningHall: row.diningCourt,
        foods: foods,
        isFavorited: row.isFavorited,
        id: row.mealId,
        isAIGenerated: row.isAIMeal,
        mealTime: MealTime.fromString(
          row.mealTime != "null" ? row.mealTime : "breakfast",
        ),
      );

      meals.add(meal);
    }

    print("Retrieved ${meals.length} favorited meals.");
    return meals;
  }

  Future<void> addFood(Food food) async {
    final foodsRes = await (localDb.select(
      localDb.foodsTable,
    )..where((tbl) => tbl.foodId.equals(food.id))).get();

    if (foodsRes.isNotEmpty) {
      // Update existing food
      await (localDb.update(
        localDb.foodsTable,
      )..where((tbl) => tbl.id.equals(foodsRes.first.id))).write(
        FoodsTableCompanion(
          foodId: Value(food.id),
          name: Value(food.name),
          calories: Value(food.calories),
          protein: Value(food.protein),
          carbs: Value(food.carbs),
          fats: Value(food.fat),
          sugar: Value(food.sugar),
          labels: Value(jsonEncode(food.labels)),
          ingredients: Value(food.ingredients),
          station: Value(food.station ?? ""),
          collection: Value(food.collection),
          lastUpdated: Value(DateTime.now().millisecondsSinceEpoch),
          isFavorited: Value(food.isFavorited),
          servingSize: Value(food.servingSize),
          saturatedFat: Value(food.saturatedFat),
          addedSugars: Value(food.addedSugars),
        ),
      );
      print("Food updated: ${food.name}");
    } else {
      // Insert new food
      await localDb
          .into(localDb.foodsTable)
          .insert(
            FoodsTableCompanion(
              foodId: Value(food.id),
              name: Value(food.name),
              calories: Value(food.calories),
              protein: Value(food.protein),
              carbs: Value(food.carbs),
              fats: Value(food.fat),
              sugar: Value(food.sugar),
              labels: Value(jsonEncode(food.labels)),
              ingredients: Value(food.ingredients),
              station: Value(food.station ?? ""),
              collection: Value(food.collection),
              lastUpdated: Value(DateTime.now().millisecondsSinceEpoch),
              isFavorited: Value(food.isFavorited),
              servingSize: Value(food.servingSize),
              saturatedFat: Value(food.saturatedFat),
              addedSugars: Value(food.addedSugars),
            ),
          );
      print("Food inserted: ${food.name}");
    }
  }

  Future<Food?> getFoodByID(String foodId) async {
    final foodsRes = await (localDb.select(
      localDb.foodsTable,
    )..where((tbl) => tbl.foodId.equals(foodId))).get();

    if (foodsRes.isNotEmpty) {
      var row = foodsRes.first;
      return Food(
        id: row.foodId,
        name: row.name,
        calories: row.calories,
        protein: row.protein,
        fat: row.fats,
        carbs: row.carbs,
        sugar: row.sugar,
        ingredients: row.ingredients,
        collection: row.collection,
        labels: (jsonDecode(row.labels) as List<dynamic>).cast<String>(),
        station: row.station.isNotEmpty ? row.station : "",
        isFavorited: row.isFavorited,
        servingSize: row.servingSize,
        saturatedFat: row.saturatedFat,
        addedSugars: row.addedSugars,
      );
    } else {
      print("No food found with ID: $foodId");
      return null;
    }
  }

  Future<void> addDiningHallMeal(
    List<MiniFood> miniFoods,
    String diningHall,
    DateTime date,
    MealTime mealTime,
  ) async {
    DateTime now = DateTime.now();
    String dateStr = "${date.year}-${date.month}-${date.day}";

    for (MiniFood miniFood in miniFoods) {
      final dhfRes =
          await (localDb.select(localDb.diningHallFoodsTable)
                ..where((tbl) => tbl.diningHall.equals(diningHall))
                ..where((tbl) => tbl.date.equals(dateStr))
                ..where((tbl) => tbl.mealTime.equals(mealTime.toString()))
                ..where(
                  (tbl) => tbl.miniFood.equals(jsonEncode(miniFood.toMap())),
                ))
              .get();

      if (dhfRes.isEmpty) {
        // Insert new dining hall food entry
        await localDb
            .into(localDb.diningHallFoodsTable)
            .insert(
              DiningHallFoodsTableCompanion(
                diningHall: Value(diningHall),
                date: Value(dateStr),
                mealTime: Value(mealTime.toString()),
                miniFood: Value(jsonEncode(miniFood.toMap())),
                lastUpdated: Value(DateTime.now().millisecondsSinceEpoch),
              ),
            );
        print(
          "Dining hall food inserted: ${miniFood.id} at $diningHall for $mealTime on $dateStr",
        );
      }
    }
    if (miniFoods.isEmpty) {
      print(
        "No dining hall foods to add for $diningHall on $dateStr for $mealTime",
      );
      // Still add an entry to indicate that the meal was checked but had no items
      await localDb
          .into(localDb.diningHallFoodsTable)
          .insert(
            DiningHallFoodsTableCompanion(
              diningHall: Value(diningHall),
              date: Value(dateStr),
              mealTime: Value(mealTime.toString()),
              miniFood: Value(
                jsonEncode(MiniFood(id: "none", station: "none").toMap()),
              ),
              lastUpdated: Value(DateTime.now().millisecondsSinceEpoch),
            ),
          );
      print(
        "Inserted placeholder entry for $diningHall on $dateStr for $mealTime",
      );
    }
  }

  Future<List<MiniFood>?> getDiningHallMeals(
    String diningCourt,
    DateTime date,
    MealTime mealTime,
  ) async {
    String dateStr = "${date.year}-${date.month}-${date.day}";

    final dhfRes =
        await (localDb.select(localDb.diningHallFoodsTable)
              ..where((tbl) => tbl.diningHall.equals(diningCourt))
              ..where((tbl) => tbl.date.equals(dateStr))
              ..where((tbl) => tbl.mealTime.equals(mealTime.toString())))
            .get();

    if (dhfRes.isEmpty) {
      print("No dining hall foods found for $diningCourt on $dateStr");
      return null;
    }

    List<MiniFood> miniFoods = [];
    for (var row in dhfRes) {
      MiniFood miniFood = MiniFood.fromMap(jsonDecode(row.miniFood));
      if (miniFood.id == "none" && miniFood.station == "none") {
        // This is a placeholder entry indicating no foods were available
        continue;
      }
      miniFoods.add(miniFood);
    }
    print(
      "Retrieved ${miniFoods.length} dining hall foods for $diningCourt on $dateStr",
    );
    if (miniFoods.isEmpty) {
      return null;
    }
    return miniFoods;
  }

  Future<void> deleteCurrentAndFutureMeals() async {
    DateTime now = DateTime.now();
    String dateStr = "${now.year}-${now.month}-${now.day}";

    await (localDb.delete(
      localDb.mealsTable,
    )..where((tbl) => tbl.date.isBiggerOrEqualValue(dateStr))).go();

    print("Deleted current and future meals from local database.");
  }

  Future<List<DiningHall>> getDiningHalls() async {
    final dhRes = await (localDb.select(localDb.diningHallsTable)).get();
    List<DiningHall> diningHalls = [];
    if (dhRes.isNotEmpty) {
      for (var row in dhRes) {
        Map<String, dynamic> scheduleMap = jsonDecode(row.schedule);
        Schedule schedule = Schedule.fromMap(scheduleMap);
        diningHalls.add(
          DiningHall(id: row.diningHallId, name: row.name, schedule: schedule),
        );
      }
    } else {
      print("No dining halls found.");
    }
    return diningHalls;
  }

  Future<DiningHall?> getDiningHallByName(String name) async {
    final dhRes = await (localDb.select(
      localDb.diningHallsTable,
    )..where((tbl) => tbl.name.equals(name))).get();

    if (dhRes.isNotEmpty) {
      var row = dhRes.first;
      Map<String, dynamic> scheduleMap = jsonDecode(row.schedule);
      Schedule schedule = Schedule.fromMap(scheduleMap);
      return DiningHall(
        id: row.diningHallId,
        name: row.name,
        schedule: schedule,
      );
    } else {
      print("No dining hall found with name: $name");
      return null;
    }
  }

  Future<void> addDiningHall(DiningHall diningHall) async {
    final dhRes = await (localDb.select(
      localDb.diningHallsTable,
    )..where((tbl) => tbl.diningHallId.equals(diningHall.id))).get();

    String scheduleStr = jsonEncode(diningHall.schedule.toMap());

    if (dhRes.isNotEmpty) {
      // Update existing dining hall
      await (localDb.update(
        localDb.diningHallsTable,
      )..where((tbl) => tbl.id.equals(dhRes.first.id))).write(
        DiningHallsTableCompanion(
          diningHallId: Value(diningHall.id),
          schedule: Value(scheduleStr),
          name: Value(diningHall.name),
        ),
      );
      print("Dining hall updated: ${diningHall.id}");
    } else {
      // Insert new dining hall
      await localDb
          .into(localDb.diningHallsTable)
          .insert(
            DiningHallsTableCompanion(
              diningHallId: Value(diningHall.id),
              schedule: Value(scheduleStr),
              name: Value(diningHall.name),
            ),
          );
      print("Dining hall inserted: ${diningHall.id}");
    }
  }
}
