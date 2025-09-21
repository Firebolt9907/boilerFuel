import 'dart:convert';

import 'package:boiler_fuel/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDB {
  static String userKey = "USER_KEY";
  static String mealsKey = "MEALS_KEYSSSS";

  static User? user;
  static String? userString;

  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userKey, jsonEncode(user.toMap()));
    LocalDB.user = user;
    userString = jsonEncode(user.toMap());
  }

  static Future<User?> getUser() async {
    if (user != null && userString != null) return user;

    final prefs = await SharedPreferences.getInstance();
    userString = prefs.getString(userKey);
    if (userString == null) return null;
    Map<String, dynamic> userMap = jsonDecode(userString!);
    user = User.fromMap(userMap);
    return user;
  }

  static Future<void> saveDaysMeals(
    Map<MealTime, Map<String, Meal>> meals,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    const mealTimeToString = {
      MealTime.breakfast: "breakfast",
      MealTime.lunch: "lunch",
      MealTime.dinner: "dinner",
      MealTime.brunch: "brunch",
    };
    List<String> mealStrings = [];
    meals.forEach((mealTime, mealList) {
      String mealTimeStr = mealTimeToString[mealTime]!;
      mealList.forEach((din, meal) {
        meal.diningHall = din;
        String mealJsonStr = jsonEncode(meal.toMap());
        print("Saving meal: ${meal.diningHall} $mealJsonStr");
        mealStrings.add("$mealTimeStr|$mealJsonStr");
      });
    });

    DateTime now = DateTime.now();
    String dateKey = "${now.year}-${now.month}-${now.day}";
    print("Saving ${mealStrings.length} meals for $dateKey");
    print(mealStrings);
    await prefs.setStringList(mealsKey + "_" + dateKey, mealStrings);
  }

  static Future<Map<MealTime, Map<String, Meal>>?> getDaysMeals() async {
    final prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    String dateKey = "${now.year}-${now.month}-${now.day}";
    List<String>? mealStrings = prefs.getStringList(mealsKey + "_" + dateKey);
    if (mealStrings == null) return null;

    const stringToMealTime = {
      "breakfast": MealTime.breakfast,
      "lunch": MealTime.lunch,
      "dinner": MealTime.dinner,
    };

    Map<MealTime, Map<String, Meal>> meals = {};
    for (String mealStr in mealStrings) {
      List<String> parts = mealStr.split("|");
      if (parts.length != 2) continue;
      String mealTimeStr = parts[0];
      String mealJsonStr = parts[1];
      MealTime? mealTime = stringToMealTime[mealTimeStr];
      if (mealTime == null) continue;
      Map<String, dynamic> mealMap = jsonDecode(mealJsonStr);
      Meal meal = Meal.fromMap(mealMap);
      print("Loaded meal: ${meal.diningHall} $mealJsonStr");
      meals.putIfAbsent(mealTime, () => {});
      meals[mealTime]![meal.diningHall] = meal;
    }
    return meals;
  }
}
