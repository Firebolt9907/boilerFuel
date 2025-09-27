import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:boiler_fuel/algo_planner.dart';
import 'package:boiler_fuel/api/database.dart';
import 'package:boiler_fuel/api/local_database.dart';
import 'package:boiler_fuel/api/web_api.dart';
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
    final gemini = Gemini.instance;

    gemini
        .listModels()
        .then((models) => print(models))
        /// list
        .catchError((e) => print('listModels' + e.toString()));
    // Call Gemini API with the prompt and parse response
    try {
      String response =
          (await Gemini.instance.prompt(
            model: "gemini-1.5-flash",
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
    } catch (e) {
      print("Error initializing Gemini: $e");
      List<String> geminiPromptLines = geminiPrompt.split("\n");
      for (String line in geminiPromptLines) {
        print("$line");
      }
      // print("With prompt: $geminiPrompt");
      await Future.delayed(Duration(minutes: 1));
      return generateMeal(
        targetCalories: targetCalories,
        targetProtein: targetProtein,
        targetCarbs: targetCarbs,
        targetFat: targetFat,
        availableFoods: availableFoods,
        diningHall: diningHall,
      );
    }
  }

  static Future<Map<MealTime, Meal>> generateDayMeal({
    required double targetCalories,
    required double targetProtein,
    required double targetCarbs,
    required double targetFat,
    required Map<MealTime, List<Food>> availableFoods,
    required String diningHall,
  }) async {
    Map<MealTime, Meal> meals = {};
    String availableMealTimes = availableFoods.keys
        .map((e) => e.toString())
        .join(", ");
    String mealTimeIngredients = "";
    for (MealTime mealTime in availableFoods.keys) {
      mealTimeIngredients = availableFoods[mealTime]!
          .map((f) => f.toMiniString())
          .join(", ");
      mealTimeIngredients +=
          """Given this information for the food available for $mealTime, ignore the dips and sauces, treat -1 as 0:
   $mealTimeIngredients
\n
  """;
    }

    if (availableFoods.keys.length == 0) {
      return {};
    }

    String geminiPrompt =
        """Given this information for the food available for $availableMealTimes:
  $mealTimeIngredients
Create ${availableFoods.keys.length} meal with the nutrition goals for the day as follows :
Calories: ${targetCalories}kcal
Protein: ${targetProtein}g
Carbs: ${targetCarbs}g
Fat: ${targetFat}g
The NAME of each meal should be related to the ingredients used in the meal!
Return as a JSON as formatted as 
{
  "breakfast" |"lunch" | "brunch" | "dinner": {
   mealName: string,
   totalCals: number,
   totalProtein: number,
   totalFat: number,
   totalCarbs: number,
   foods: List[] formatted as {name: string, calories: number, protein: number, carbs: number, fats: number, id: string, sugar: number}
 }
 ...
}
DO NOT include any other text outside of the JSON block.
""";

    // Call Gemini API with the prompt and parse response
    try {
      // String response =
      //     (await Gemini.instance.prompt(
      //       parts: [Part.text(geminiPrompt)],
      //       model: "gemini-2.0-flash-lite",
      //     ))!.output ??
      //     "{}";
      String response = await WebAPI().getGeminiResponse(
        "gemini-2.0-flash-lite",
        geminiPrompt,
      );
      print("Gemini response: $response");
      print("Gemini Prompt Tokens: ${geminiPrompt.length / 4}");
      print("Response Tokens: ${response.length / 4}");
      await SharedPrefs.updateTokenStats(
        (geminiPrompt.length / 4).round(),
        (response.length / 4).round(),
      );
      // Parse response and create Meal object
      response = response
          .replaceAll('\n', '')
          .replaceAll('```', '')
          .replaceAll("json", "");
      print("Cleaned response: $response");
      try {
        var decoded = jsonDecode(response);
        for (MealTime mealTime in availableFoods.keys) {
          if (decoded[mealTime.toString()] != null) {
            var mealData = decoded[mealTime.toString()] as Map;
            List<Food> foods = (mealData['foods'] as List).map((f) {
              return availableFoods[mealTime]!.firstWhere(
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
            meals[mealTime] = Meal(
              name: mealData['mealName'] ?? 'Generated Meal',
              calories: (mealData['totalCals'] ?? 0).toDouble(),
              protein: (mealData['totalProtein'] ?? 0).toDouble(),
              fat: (mealData['totalFat'] ?? 0).toDouble(),
              carbs: (mealData['totalCarbs'] ?? 0).toDouble(),
              diningHall: diningHall, // Could be set based on food sources
              foods: foods,
              mealTime: mealTime,
            );
          }
        }
        return meals;
      } catch (e) {
        print("Error parsing response: $e");
        return {};
      }
    } catch (e) {
      print("Error initializing Gemini: $e");
      //get retry again header

      List<String> geminiPromptLines = geminiPrompt.split("\n");
      for (String line in geminiPromptLines) {
        print("$line");
      }
      Map<MealTime, Meal> meals = {};
      for (MealTime mt in availableFoods.keys) {
        final optimizer = MealOptimizerGA(
          oneServingOnly: true,
          availableFoods: availableFoods[mt]!.map((e) {
            e.calories = e.calories < 0 ? 0 : e.calories;
            e.protein = e.protein < 0 ? 0 : e.protein;
            e.carbs = e.carbs < 0 ? 0 : e.carbs;
            e.fat = e.fat < 0 ? 0 : e.fat;
            e.sugar = e.sugar < 0 ? 0 : e.sugar;
            return e;
          }).toList(),
          targets: MacroTargets(
            calories: targetCalories / 2,
            protein: targetProtein / 2,
            carbs: targetCarbs / 2,
            fat: targetFat / 2,
          ),
          diningHall: diningHall,
          mealTime: mt,
        );
        final optimizedMeal = optimizer.optimize(
          mealName: 'Optimized' + mt.toString() + ' Meal',
          generations: 50,
          onProgress: (generation, fitness) {
            print(
              'Generation $generation: Best fitness = ${fitness.toStringAsFixed(3)}',
            );
          },
        );
        //Change the meal name to be just the top 3 ingredients based on calories
        if (optimizedMeal.foods.isNotEmpty) {
          List<Food> sortedFoods = List<Food>.from(optimizedMeal.foods);
          sortedFoods.sort((a, b) => b.calories.compareTo(a.calories));
          optimizedMeal.name = sortedFoods
              .sublist(0, min(2, sortedFoods.length))
              .map((f) => f.name)
              .join(" and ");
        }
        optimizedMeal.mealTime = mt;
        meals[mt] = optimizedMeal;
      }
      return meals;

      // print("With prompt: $geminiPrompt");
      // await Future.delayed(Duration(minutes: 1));
      // return generateDayMeal(
      //   targetCalories: targetCalories,
      //   targetProtein: targetProtein,
      //   targetCarbs: targetCarbs,
      //   targetFat: targetFat,
      //   availableFoods: availableFoods,
      //   diningHall: diningHall,
      // );

      // return generateMeal(
      //   targetCalories: targetCalories,
      //   targetProtein: targetProtein,
      //   targetCarbs: targetCarbs,
      //   targetFat: targetFat,
      //   availableFoods: availableFoods,
      //   diningHall: diningHall,
      // );
    }
  }

  static Future<Map<MealTime, Meal>> generateDiningHallMeal({
    required double targetCalories,
    required double targetProtein,
    required double targetCarbs,
    required double targetFat,

    required String diningHall,
    required User user,
    required DateTime date,
  }) async {
    // Map<MealTime, List<Food>> availableFoods = {};
    // for (MealTime mt in MealTime.values) {
    //   if (mt == MealTime.lateLunch) continue;
    //   List<Food> food =
    //       await Database().getDiningCourtMeal(diningHall, date, mt) ?? [];
    //   print("Fetched ${food.length} food items for $diningHall at $mt");
    //   print("User dietary restrictions: ${user.dietaryRestrictions.toMap()}");
    //   List<List<Food>> filteredFoods = user.dietaryRestrictions.filterFoodList(
    //     food,
    //   );
    //   List<Food> filteredFood = filteredFoods.isNotEmpty
    //       ? filteredFoods[0]
    //       : [];
    //   print("Filtered to ${filteredFood.length} available food items");
    //   if (filteredFood.isNotEmpty) {
    //     availableFoods[mt] = filteredFood;
    //   }
    // }
    Map<MealTime, List<Food>> availableFoods = {};
    for (MealTime mt in MealTime.values) {
      if (mt == MealTime.lateLunch) continue;
      List<Food> food =
          await Database().getDiningCourtMeal(diningHall, date, mt) ?? [];
      print("Fetched ${food.length} food items for $diningHall at $mt");
      print("User dietary restrictions: ${user.dietaryRestrictions.toMap()}");
      List<List<Food>> filteredFoods = user.dietaryRestrictions.filterFoodList(
        food,
      );
      List<Food> filteredFood = filteredFoods.isNotEmpty
          ? filteredFoods[0]
          : [];
      print("Filtered to ${filteredFood.length} available food items");
      if (filteredFood.isNotEmpty) {
        availableFoods[mt] = filteredFood;
      }
    }
    // Map<MealTime, Meal> meals = {};

    // for (MealTime mt in availableFoods.keys) {
    //   final optimizer = MealOptimizerGA(
    //     oneServingOnly: true,
    //     availableFoods: availableFoods[mt]!.map((e) {
    //       e.calories = e.calories < 0 ? 0 : e.calories;
    //       e.protein = e.protein < 0 ? 0 : e.protein;
    //       e.carbs = e.carbs < 0 ? 0 : e.carbs;
    //       e.fat = e.fat < 0 ? 0 : e.fat;
    //       e.sugar = e.sugar < 0 ? 0 : e.sugar;
    //       return e;
    //     }).toList(),
    //     targets: MacroTargets(
    //       calories: targetCalories / 2,
    //       protein: targetProtein / 2,
    //       carbs: targetCarbs / 2,
    //       fat: targetFat / 2,
    //     ),
    //     diningHall: diningHall,
    //     mealTime: mt,
    //   );
    //   final optimizedMeal = optimizer.optimize(
    //     mealName: 'Optimized ' + mt.toString() + ' Meal',
    //     generations: 50,
    //     onProgress: (generation, fitness) {
    //       print(
    //         'Generation $generation: Best fitness = ${fitness.toStringAsFixed(3)}',
    //       );
    //     },
    //   );
    //   //Change the meal name to be just the top 3 ingredients based on calories
    //   if (optimizedMeal.foods.isNotEmpty) {
    //     List<Food> sortedFoods = List<Food>.from(optimizedMeal.foods);
    //     sortedFoods.sort((a, b) => b.calories.compareTo(a.calories));
    //     optimizedMeal.name = sortedFoods
    //         .sublist(0, min(2, sortedFoods.length))
    //         .map((f) => f.name)
    //         .join(" and ");
    //   }
    //   optimizedMeal.mealTime = mt;

    //   meals[mt] = optimizedMeal;
    // }
    // return meals;

    // Meal meal = await generateMeal(
    //   targetCalories: targetCalories,
    //   targetProtein: targetProtein,
    //   targetCarbs: targetCarbs,
    //   targetFat: targetFat,
    //   availableFoods: availableFood,
    //   diningHall: diningHall,
    // );

    // meal.mealTime = mealTime;

    return await generateDayMeal(
      targetCalories: targetCalories,
      targetProtein: targetProtein,
      targetCarbs: targetCarbs,
      targetFat: targetFat,
      availableFoods: availableFoods,
      diningHall: diningHall,
    );
  }

  static Future<void> generateDayMealPlan({
    required User user,
    DateTime? date,
  }) async {
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
    List<Future<Map<MealTime, Meal>>> mealGenerationTasks = [];

    // Add meal generation for all dining halls to the task list
    for (String diningHall in _diningHalls) {
      mealGenerationTasks.add(
        MealPlanner.generateDiningHallMeal(
          diningHall: diningHall,

          targetCalories: mealCalories,
          targetProtein: mealProtein,
          targetCarbs: mealCarbs,
          targetFat: mealFat,
          date: date ?? DateTime.now(),

          user: user,
        ),
      );
    }

    // Wait for all meal generation tasks to complete in parallel

    List<Map<MealTime, Meal>> generatedMeals = await Future.wait(
      mealGenerationTasks,
    );
    for (Map<MealTime, Meal>? meal in generatedMeals) {
      if (meal != null) {
        for (MealTime mt in meal.keys) {
          Meal m = meal[mt]!;
          print(
            "Generated meal for ${m.diningHall} at ${mt.toString()} with ${m.calories} kcal, ${m.protein}g protein, ${m.carbs}g carbs, ${m.fat}g fat",
          );
          await LocalDatabase().addMeal(m, mt, date ?? DateTime.now());
        }
      }
    }
    print(
      "Generated ${generatedMeals.where((meal) => meal != null).length} meals successfully for ${date ?? DateTime.now()}",
    );
    double averagePromptTokens = await SharedPrefs.getAveragePromptTokens();
    double averageResponseTokens = await SharedPrefs.getAverageResponseTokens();
    int totalPrompts = await SharedPrefs.getTotalPrompts();
    int totalResponses = await SharedPrefs.getTotalResponses();
    print(
      "Average Prompt Tokens: $averagePromptTokens, Average Response Tokens: $averageResponseTokens, Total Prompts: $totalPrompts, Total Responses: $totalResponses",
    );
    //check if date is 3 days after now, if so stop
    if (date == null || date.isBefore(DateTime.now().add(Duration(days: 2)))) {
      //Wait 60 seconds between calls to avoid rate limiting
      // await Future.delayed(Duration(seconds: 60));
      await generateDayMealPlan(
        user: user,
        date: (date ?? DateTime.now()).add(Duration(days: 1)),
      );
    }
  }
}
