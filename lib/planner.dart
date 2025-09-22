import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:boiler_fuel/api/database.dart';
import 'package:boiler_fuel/api/local_database.dart';
import 'package:boiler_fuel/constants.dart';
import 'package:boiler_fuel/api/firebase_database.dart';
import 'package:boiler_fuel/api/shared_preferences.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class CalorieMacroCalculator {
  /// Calculate BMR using Mifflin-St Jeor Equation
  static double calculateBMR({
    required int age,
    required double weightLbs,
    required double heightInches,
    required Gender gender,
  }) {
    // Convert to metric
    double weightKg = weightLbs * 0.453592;
    double heightCm = heightInches * 2.54;

    double bmr;
    if (gender == Gender.male) {
      bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5;
    } else {
      bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * age) - 161;
    }

    return bmr;
  }

  /// Calculate TDEE based on activity level
  static double calculateTDEE(double bmr, ActivityLevel activityLevel) {
    double multiplier;
    switch (activityLevel) {
      case ActivityLevel.sedentary:
        multiplier = 1.2;
        break;
      case ActivityLevel.lightly:
        multiplier = 1.375;
        break;
      case ActivityLevel.moderately:
        multiplier = 1.55;
        break;
      case ActivityLevel.very:
        multiplier = 1.725;
        break;
      case ActivityLevel.extremely:
        multiplier = 1.9;
        break;
    }
    return bmr * multiplier;
  }

  /// Adjust calories based on goal
  static double adjustCaloriesForGoal(double tdee, Goal goal) {
    switch (goal) {
      case Goal.lose:
        return tdee - 500; // 1 lb per week loss
      case Goal.maintain:
        return tdee;
      case Goal.gain:
        return tdee + 500; // 1 lb per week gain
    }
  }

  /// Calculate macronutrients
  static MacroResult calculateMacros({
    required int age,
    required double weightLbs,
    required double heightInches,
    required Gender gender,
    ActivityLevel activityLevel = ActivityLevel.sedentary,
    required Goal goal,
    double proteinPercentage = 0.25, // 25% protein
    double fatPercentage = 0.25, // 25% fat
    // Carbs will be the remainder (50%)
  }) {
    // Validate percentages
    if (proteinPercentage + fatPercentage >= 1.0) {
      throw ArgumentError(
        'Protein and fat percentages must sum to less than 100%',
      );
    }

    // Calculate BMR and TDEE
    double bmr = calculateBMR(
      age: age,
      weightLbs: weightLbs,
      heightInches: heightInches,
      gender: gender,
    );

    double tdee = calculateTDEE(bmr, activityLevel);
    double targetCalories = adjustCaloriesForGoal(tdee, goal);

    // Ensure minimum calories for safety
    targetCalories = max(targetCalories, gender == Gender.female ? 1200 : 1500);

    // Calculate macros
    double proteinCalories = targetCalories * proteinPercentage;
    double fatCalories = targetCalories * fatPercentage;
    double carbCalories = targetCalories - proteinCalories - fatCalories;

    // Convert calories to grams
    double proteinGrams = proteinCalories / 4; // 4 calories per gram
    double fatGrams = fatCalories / 9; // 9 calories per gram
    double carbGrams = carbCalories / 4; // 4 calories per gram

    return MacroResult(
      calories: targetCalories,
      protein: proteinGrams,
      carbs: carbGrams,
      fat: fatGrams,
      bmr: bmr,
      tdee: tdee,
    );
  }

  /// Alternative method with protein based on body weight
  static MacroResult calculateMacrosWithProteinTarget({
    required int age,
    required double weightLbs,
    required double heightInches,
    required Gender gender,
    required ActivityLevel activityLevel,
    required Goal goal,
    double proteinPerPound = 1.0, // 1g protein per lb body weight
    double fatPercentage = 0.25, // 25% fat
  }) {
    double bmr = calculateBMR(
      age: age,
      weightLbs: weightLbs,
      heightInches: heightInches,
      gender: gender,
    );

    double tdee = calculateTDEE(bmr, activityLevel);
    double targetCalories = adjustCaloriesForGoal(tdee, goal);

    // Ensure minimum calories
    targetCalories = max(targetCalories, gender == Gender.female ? 1200 : 1500);

    // Calculate protein based on body weight
    double proteinGrams = weightLbs * proteinPerPound;
    double proteinCalories = proteinGrams * 4;

    // Calculate fat
    double fatCalories = targetCalories * fatPercentage;
    double fatGrams = fatCalories / 9;

    // Remaining calories go to carbs
    double carbCalories = targetCalories - proteinCalories - fatCalories;
    double carbGrams = carbCalories / 4;

    // Ensure non-negative carbs
    if (carbGrams < 0) {
      carbGrams = 0;
      carbCalories = 0;
      // Recalculate to fit within calorie target
      double remainingCalories = targetCalories - proteinCalories;
      fatCalories = remainingCalories;
      fatGrams = fatCalories / 9;
    }

    return MacroResult(
      calories: targetCalories,
      protein: proteinGrams,
      carbs: carbGrams,
      fat: fatGrams,
      bmr: bmr,
      tdee: tdee,
    );
  }
}

class MealPlanner {
  static List<String> _diningHalls = [
    "Wiley",
    "Hillenbrand",
    "Windsor",
    "Earhart",
    "Ford",
  ];
  static Future<Meal> generateMeal({
    required double targetCalories,
    required double targetProtein,
    required double targetCarbs,
    required double targetFat,
    required List<Food> availableFoods,
    required String diningHall,
  }) async {
    // Placeholder implementation
    String geminiPrompt =
        """
Given this information for the food available, ignore the dips and sauces also if value is -1, the nutrition information isn't available just treat it as 0:

 ${availableFoods.map((f) => f.toString()).join(", ")}

Create ONE meal with the nutrition goals for one meal as follows :
Calories: ${targetCalories}kcal
Protein: ${targetProtein}g
Carbs: ${targetCarbs}g
Fat: ${targetFat}g

The NAME should be related to the ingredients used in the meal!

Return as a JSON as formatted as 
{
   mealName: string,
   totalCals: number,
   totalProtein: number,
   totalFat: number,
   totalCarbs: number,
   foods: List[] formatted as {name: string, calories: number, protein: number, carbs: number, fats: number, id: string, sugar: number}
}

DO NOT include any other text outside of the JSON block.
""";

    // Call Gemini API with the prompt and parse response
    String response =
        (await Gemini.instance.prompt(
          parts: [Part.text(geminiPrompt)],
        ))!.output ??
        "{}";
    print("Gemini response: $response");
    // Parse response and create Meal object
    response = response
        .replaceAll('\n', '')
        .replaceAll('```', '')
        .replaceAll("json", "");
    print("Cleaned response: $response");
    try {
      var decoded = jsonDecode(response);
      List<Food> foods = (decoded['foods'] as List).map((f) {
        return availableFoods.firstWhere(
          (food) => food.id == f['id'],
          orElse: () {
            return Food(
              id: f['id'] ?? '',
              name: f['name'] ?? 'Unknown',
              calories: (f['calories'] ?? 0).toDouble(),
              protein: (f['protein'] ?? 0).toDouble(),
              fat: (f['fats'] ?? 0).toDouble(),
              carbs: (f['carbs'] ?? 0).toDouble(),
              sugar: (f['sugar'] ?? 0).toDouble(),
              ingredients: "",
              labels: [],
            );
          },
        );
      }).toList();
      return Meal(
        name: decoded['mealName'] ?? 'Generated Meal',
        calories: (decoded['totalCals'] ?? 0).toDouble(),
        protein: (decoded['totalProtein'] ?? 0).toDouble(),
        fat: (decoded['totalFat'] ?? 0).toDouble(),
        carbs: (decoded['totalCarbs'] ?? 0).toDouble(),
        diningHall: diningHall, // Could be set based on food sources
        foods: foods,
      );
    } catch (e) {
      print("Error parsing response: $e");
      return Meal(
        name: "Error Meal",
        calories: 0,
        protein: 0,
        fat: 0,
        carbs: 0,
        diningHall: "",
        foods: [],
      );
    }
  }

  static Future<Meal?> generateDiningHallMeal({
    required double targetCalories,
    required double targetProtein,
    required double targetCarbs,
    required double targetFat,
    required MealTime mealTime,
    required String diningHall,
    required User user,
  }) async {
    List<Food> food =
        await Database().getDiningCourtMeal(
          diningHall,
          new DateTime.now(),
          mealTime,
        ) ??
        [];
    print("Fetched ${food.length} food items for $diningHall at $mealTime");
    print("User dietary restrictions: ${user.dietaryRestrictions.toMap()}");
    List<List<Food>> availableFoods = user.dietaryRestrictions.filterFoodList(
      food,
    );
    List<Food> availableFood = availableFoods.isNotEmpty
        ? availableFoods[0]
        : [];
    print("Filtered to ${availableFood.length} available food items");
    if (availableFood.isEmpty) {
      return null;
    }
    Meal meal = await generateMeal(
      targetCalories: targetCalories,
      targetProtein: targetProtein,
      targetCarbs: targetCarbs,
      targetFat: targetFat,
      availableFoods: availableFood,
      diningHall: diningHall,
    );

    meal.mealTime = mealTime;

    return meal;
  }

  static Future<void> generateDayMealPlan({required User user}) async {
    final _userMacros = CalorieMacroCalculator.calculateMacros(
      age: user.age,
      weightLbs: user.weight.toDouble(),
      heightInches: user.height.toDouble(),
      gender: user.gender,
      goal: user.goal,
    );
    double mealCalories = _userMacros!.calories / 2;
    double mealProtein = _userMacros!.protein / 2;
    double mealCarbs = _userMacros!.carbs / 2;
    double mealFat = _userMacros!.fat / 2;

    // Create a list to hold all the meal generation futures
    List<Future<Meal?>> mealGenerationTasks = [];

    for (MealTime mealTime in MealTime.values) {
      // Add meal generation for all dining halls to the task list
      for (String diningHall in _diningHalls) {
        mealGenerationTasks.add(
          MealPlanner.generateDiningHallMeal(
            diningHall: diningHall,
            mealTime: mealTime,
            targetCalories: mealCalories,
            targetProtein: mealProtein,
            targetCarbs: mealCarbs,
            targetFat: mealFat,
            user: user,
          ),
        );
      }
    }

    // Wait for all meal generation tasks to complete in parallel
    try {
      List<Meal?> generatedMeals = await Future.wait(mealGenerationTasks);
      for (Meal? meal in generatedMeals) {
        if (meal != null) {
          await LocalDatabase().addMeal(meal, meal.mealTime!);
        }
      }
      print(
        "Generated ${generatedMeals.where((meal) => meal != null).length} meals successfully",
      );
    } catch (e) {
      print("Error generating meals in parallel: $e");
    }
  }
}
