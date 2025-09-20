import 'dart:io';
import 'dart:math';

import 'package:boiler_fuel/constants.dart';

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
