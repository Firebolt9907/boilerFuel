import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

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
  TextColumn get gender => text()();
  IntColumn get age => integer()();
  IntColumn get weight => integer()();
  IntColumn get height => integer()();
  TextColumn get goal => text()();
  TextColumn get dietaryRestrictions => text()();
  TextColumn get mealPlan => text()();
  TextColumn get diningCourtRanking => text()();
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
  RealColumn get totalCarbs => real()();
  RealColumn get totalFats => real()();

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
  IntColumn get lastUpdated => integer()();
}

class DiningHallFoodsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get diningHall => text()();
  TextColumn get date => text()();
  TextColumn get mealTime => text()();
  TextColumn get miniFood => text()();

  IntColumn get lastUpdated => integer()();
}

@DriftDatabase(
  tables: [UsersTable, MealsTable, FoodsTable, DiningHallFoodsTable],
)
class AppDb extends _$AppDb {
  AppDb() : super(_openConnection());

  @override
  int get schemaVersion => 2;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();

    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    int resetLocalDB = await SharedPrefs.getResetLocalData();
    try {
      if (resetLocalDB <= 15) {
        print("Deleting old database");
        await file.delete();
        await SharedPrefs.setResetLocalData(16);
        // print("Deleted old database");
        // await LocalDatabase().deleteOldResponse();
        // print("Deleted old responses");
      }
    } catch (e) {
      print(e);
    }

    return NativeDatabase.createInBackground(file);
  });
}

class LocalDatabase {
  Future<void> deleteDB(bool fully) async {
    try {
      //Delete all calendars

      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'db.sqlite'));
      await file.delete();
      print("Database deleted successfully.");
      // await _recreateDB();
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
        weight: usersRes.first.weight,
        height: usersRes.first.height,
        age: usersRes.first.age,
        gender: Gender.fromString(usersRes.first.gender),
        goal: Goal.fromString(usersRes.first.goal),
        dietaryRestrictions: _stringToDietaryRestrictions(
          usersRes.first.dietaryRestrictions,
        ),
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
          weight: Value(user.weight),
          height: Value(user.height),
          age: Value(user.age),
          gender: Value(user.gender.toString()),
          goal: Value(user.goal.toString()),
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
              weight: Value(user.weight),
              height: Value(user.height),
              age: Value(user.age),
              gender: Value(user.gender.toString()),
              goal: Value(user.goal.toString()),
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

  Future<void> addMeal(Meal meal, MealTime mealTime) async {
    DateTime now = DateTime.now();
    String dateStr = "${now.year}-${now.month}-${now.day}";

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
              lastUpdated: Value(DateTime.now().millisecondsSinceEpoch),
            ),
          );
      print("Meal inserted: ${meal.name} at ${meal.diningHall}");
    }
  }

  Future<Map<MealTime, Map<String, Meal>>?> getDayMeals() async {
    DateTime now = DateTime.now();
    String dateStr = "${now.year}-${now.month}-${now.day}";

    final mealsRes = await (localDb.select(
      localDb.mealsTable,
    )..where((tbl) => tbl.date.equals(dateStr))).get();

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
      );

      meals.putIfAbsent(mealTime, () => {});
      meals[mealTime]![diningHall] = meal;
    }

    print("Retrieved ${mealsRes.length} meals for today.");
    return meals;
  }

  Future<void> listenToDayMeals(
    StreamController<Map<MealTime, Map<String, Meal>>> controller,
  ) async {
    DateTime now = DateTime.now();
    String dateStr = "${now.year}-${now.month}-${now.day}";

    final query = (localDb.select(
      localDb.mealsTable,
    )..where((tbl) => tbl.date.equals(dateStr))).watch();

    query.listen((mealsRes) {
      if (controller.isClosed) {
        return;
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
        );

        meals.putIfAbsent(mealTime, () => {});
        meals[mealTime]![diningHall] = meal;
      }

      controller.add(meals);
    });
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
          lastUpdated: Value(DateTime.now().millisecondsSinceEpoch),
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
              lastUpdated: Value(DateTime.now().millisecondsSinceEpoch),
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
        labels: (jsonDecode(row.labels) as List<dynamic>).cast<String>(),
        station: row.station.isNotEmpty ? row.station : "",
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
    return miniFoods;
  }
}
