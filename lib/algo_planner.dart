import 'dart:math';
import 'dart:math' as math;

import 'package:boiler_fuel/constants.dart';
import 'dart:math';

// Additional classes for the genetic algorithm
class FoodServing {
  final Food food;
  final double servings;

  FoodServing({required this.food, required this.servings});

  FoodServing copyWith({Food? food, double? servings}) {
    return FoodServing(
      food: food ?? this.food,
      servings: servings ?? this.servings,
    );
  }
}

class MacroTargets {
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double? maxSugar; // Optional sugar limit

  MacroTargets({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.maxSugar,
  });
}

class MealTotals {
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double sugar;

  MealTotals({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.sugar,
  });
}

// Genetic Algorithm Meal Optimizer
class MealOptimizerGA {
  final List<Food> availableFoods;
  final MacroTargets targets;
  final Random _random = Random();
  final String diningHall;
  final MealTime? mealTime;
  final bool allowPartialServings;
  final bool oneServingOnly;

  // GA Parameters
  static const int populationSize = 50;
  static const double mutationRate = 0.1;
  static const int maxFoodsPerMeal = 8;
  static const int minFoodsPerMeal = 3;
  static const double maxServingsPerFood = 3.0;
  static const double minServingsPerFood = 0.1;

  List<List<FoodServing>> population = [];
  int generation = 0;

  MealOptimizerGA({
    required this.availableFoods,
    required this.targets,
    required this.diningHall,
    this.mealTime,
    this.allowPartialServings = true,
    this.oneServingOnly = false,
  });

  // Initialize the population with random meals
  void initializePopulation() {
    population.clear();
    generation = 0;

    for (int i = 0; i < populationSize; i++) {
      population.add(_generateRandomMeal());
    }
  }

  // Generate a random meal (individual)
  List<FoodServing> _generateRandomMeal() {
    final meal = <FoodServing>[];
    final numFoods =
        _random.nextInt(maxFoodsPerMeal - minFoodsPerMeal + 1) +
        minFoodsPerMeal;

    final selectedFoods = <Food>[];

    // Select random foods without duplicates
    while (selectedFoods.length < numFoods &&
        selectedFoods.length < availableFoods.length) {
      final food = availableFoods[_random.nextInt(availableFoods.length)];
      if (!selectedFoods.any((f) => f.id == food.id)) {
        selectedFoods.add(food);
      }
    }

    // Add servings for each selected food
    for (final food in selectedFoods) {
      double servings;

      if (oneServingOnly) {
        servings = 1.0;
      } else if (allowPartialServings) {
        servings =
            _random.nextDouble() * (maxServingsPerFood - minServingsPerFood) +
            minServingsPerFood;
      } else {
        servings = (_random.nextInt(maxServingsPerFood.round()) + 1).toDouble();
      }

      meal.add(FoodServing(food: food, servings: servings));
    }

    return meal;
  }

  // Calculate meal totals
  MealTotals calculateMealTotals(List<FoodServing> meal) {
    double calories = 0, protein = 0, carbs = 0, fat = 0, sugar = 0;

    for (final serving in meal) {
      calories += serving.food.calories * serving.servings;
      protein += serving.food.protein * serving.servings;
      carbs += serving.food.carbs * serving.servings;
      fat += serving.food.fat * serving.servings;
      sugar += serving.food.sugar * serving.servings;
    }

    return MealTotals(
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
      sugar: sugar,
    );
  }

  // Calculate fitness score (lower is better)
  double calculateFitness(List<FoodServing> meal) {
    final totals = calculateMealTotals(meal);

    // Macro difference penalty (normalized)
    double macroDiff = 0;
    if (targets.calories > 0)
      macroDiff +=
          (totals.calories - targets.calories).abs() / targets.calories;
    if (targets.protein > 0)
      macroDiff += (totals.protein - targets.protein).abs() / targets.protein;
    if (targets.carbs > 0)
      macroDiff += (totals.carbs - targets.carbs).abs() / targets.carbs;
    if (targets.fat > 0)
      macroDiff += (totals.fat - targets.fat).abs() / targets.fat;

    double balancePenalty = 0;

    // Sugar penalty - discourage high-sugar foods (desserts)
    if (targets.maxSugar != null && targets.maxSugar! > 0) {
      if (totals.sugar > targets.maxSugar!) {
        // Heavy penalty for exceeding sugar limit
        balancePenalty +=
            (totals.sugar - targets.maxSugar!) / targets.maxSugar! * 0.5;
      }
    } else {
      // If no sugar limit specified, still penalize very high sugar content
      // Penalize meals with more than 15g sugar total (arbitrary threshold for dessert detection)
      const defaultSugarThreshold = 15.0;
      if (totals.sugar > defaultSugarThreshold) {
        balancePenalty +=
            (totals.sugar - defaultSugarThreshold) /
            defaultSugarThreshold *
            0.3;
      }
    }

    // Individual food sugar penalty - heavily penalize foods with high sugar density
    for (final serving in meal) {
      final sugarPerServing = serving.food.sugar * serving.servings;
      final caloriesPerServing = serving.food.calories * serving.servings;

      if (caloriesPerServing > 0) {
        final sugarPercentage =
            (sugarPerServing * 4) /
            caloriesPerServing; // 4 calories per gram of sugar

        // Penalize foods where sugar makes up more than 25% of calories (likely desserts)
        if (sugarPercentage > 0.25) {
          balancePenalty +=
              (sugarPercentage - 0.25) *
              2.0; // Heavy penalty for dessert-like foods
        }

        // Extra penalty for extremely high sugar foods (>50% calories from sugar)
        if (sugarPercentage > 0.5) {
          balancePenalty += 1.0; // Very heavy penalty for candy/dessert items
        }
      }

      // Direct penalty for high-sugar foods (>10g sugar per serving)
      if (sugarPerServing > 10.0) {
        balancePenalty += (sugarPerServing - 10.0) / 10.0 * 0.4;
      }
    }

    // Penalty for extreme serving sizes
    for (final serving in meal) {
      if (oneServingOnly) {
        // Heavy penalty for anything other than exactly 1.0 serving
        if (serving.servings != 1.0) {
          balancePenalty += 1.0; // Very heavy penalty
        }
      } else if (allowPartialServings) {
        if (serving.servings > maxServingsPerFood) {
          balancePenalty += (serving.servings - maxServingsPerFood) * 0.2;
        }
        if (serving.servings < minServingsPerFood) {
          balancePenalty += 0.1;
        }
      } else {
        // For whole servings only, penalize non-integer values
        if (serving.servings != serving.servings.round()) {
          balancePenalty += 0.5; // Heavy penalty for fractional servings
        }
        if (serving.servings > maxServingsPerFood || serving.servings < 1.0) {
          balancePenalty += 0.3;
        }
      }
    }

    // Penalty for lack of variety in labels/categories
    final uniqueLabels = <String>{};
    for (final serving in meal) {
      uniqueLabels.addAll(serving.food.labels);
    }
    if (uniqueLabels.length < 3) {
      balancePenalty += (3 - uniqueLabels.length) * 0.3;
    }

    // Penalty for too few foods
    if (meal.length < minFoodsPerMeal) {
      balancePenalty += (minFoodsPerMeal - meal.length) * 0.5;
    }

    return macroDiff + balancePenalty;
  }

  // Tournament selection
  List<FoodServing> tournamentSelection(List<double> fitnessScores) {
    final tournament1 = _random.nextInt(populationSize);
    final tournament2 = _random.nextInt(populationSize);

    return fitnessScores[tournament1] < fitnessScores[tournament2]
        ? List.from(population[tournament1])
        : List.from(population[tournament2]);
  }

  // Crossover two meals
  List<List<FoodServing>> crossover(
    List<FoodServing> parent1,
    List<FoodServing> parent2,
  ) {
    final minLength = math.min(parent1.length, parent2.length);
    if (minLength <= 1) {
      return [List.from(parent1), List.from(parent2)];
    }

    final crossoverPoint = _random.nextInt(minLength);

    final child1 = <FoodServing>[
      ...parent1.sublist(0, crossoverPoint),
      ...parent2.sublist(crossoverPoint),
    ];

    final child2 = <FoodServing>[
      ...parent2.sublist(0, crossoverPoint),
      ...parent1.sublist(crossoverPoint),
    ];

    return [child1, child2];
  }

  // Mutate a meal
  List<FoodServing> mutate(List<FoodServing> meal) {
    final mutated = <FoodServing>[];

    for (final serving in meal) {
      if (_random.nextDouble() < mutationRate) {
        if (_random.nextBool()) {
          // Change food
          final newFood =
              availableFoods[_random.nextInt(availableFoods.length)];
          mutated.add(FoodServing(food: newFood, servings: serving.servings));
        } else {
          // Change serving size
          double newServings;

          if (oneServingOnly) {
            // Keep at 1.0 serving always
            newServings = 1.0;
          } else if (allowPartialServings) {
            newServings = math.max(
              minServingsPerFood,
              serving.servings + (_random.nextDouble() - 0.5),
            );
          } else {
            // For whole servings, add/subtract 1 or keep same
            final change = _random.nextInt(3) - 1; // -1, 0, or 1
            newServings = math
                .max(1.0, serving.servings + change)
                .round()
                .toDouble();
            newServings = math.min(maxServingsPerFood, newServings);
          }

          mutated.add(serving.copyWith(servings: newServings));
        }
      } else {
        mutated.add(serving);
      }
    }

    // Sometimes add or remove a food
    if (_random.nextDouble() < 0.1) {
      if (_random.nextBool() && mutated.length > minFoodsPerMeal) {
        // Remove a food
        mutated.removeAt(_random.nextInt(mutated.length));
      } else if (mutated.length < maxFoodsPerMeal) {
        // Add a food
        final newFood = availableFoods[_random.nextInt(availableFoods.length)];
        double servings;

        if (oneServingOnly) {
          servings = 1.0;
        } else if (allowPartialServings) {
          servings = _random.nextDouble() * 1.5 + minServingsPerFood;
        } else {
          servings = (_random.nextInt(maxServingsPerFood.round()) + 1)
              .toDouble();
        }

        mutated.add(FoodServing(food: newFood, servings: servings));
      }
    }

    return mutated;
  }

  // Run one generation
  List<FoodServing>? runGeneration() {
    if (population.isEmpty) return null;

    // Calculate fitness for all individuals
    final fitnessScores = population.map(calculateFitness).toList();

    // Find best individual
    final bestIndex = fitnessScores.indexOf(fitnessScores.reduce(math.min));
    final bestMeal = population[bestIndex];

    // Create new population
    final newPopulation = <List<FoodServing>>[];

    // Elitism: keep best individual
    newPopulation.add(List.from(bestMeal));

    // Generate rest of population through selection, crossover, and mutation
    while (newPopulation.length < populationSize) {
      final parent1 = tournamentSelection(fitnessScores);
      final parent2 = tournamentSelection(fitnessScores);

      final children = crossover(parent1, parent2);

      newPopulation.add(mutate(children[0]));
      if (newPopulation.length < populationSize) {
        newPopulation.add(mutate(children[1]));
      }
    }

    population = newPopulation;
    generation++;

    return bestMeal;
  }

  // Convert optimized meal to your Meal class
  Meal convertToMeal(List<FoodServing> optimizedMeal, String mealName) {
    final foods = optimizedMeal.map((serving) => serving.food).toList();
    final totals = calculateMealTotals(optimizedMeal);

    return Meal(
      name: mealName,
      calories: totals.calories,
      protein: totals.protein,
      carbs: totals.carbs,
      fat: totals.fat,
      foods: foods,
      diningHall: diningHall,
      mealTime: mealTime,
    );
  }

  // Run optimization for specified generations
  Meal optimize({
    required String mealName,
    int generations = 100,
    Function(int generation, double bestFitness)? onProgress,
  }) {
    initializePopulation();

    List<FoodServing>? bestMeal;

    for (int i = 0; i < generations; i++) {
      bestMeal = runGeneration();

      if (onProgress != null && bestMeal != null) {
        final fitness = calculateFitness(bestMeal);
        onProgress(generation, fitness);
      }
    }

    if (bestMeal == null) {
      throw Exception('Failed to generate optimal meal');
    }

    return convertToMeal(bestMeal, mealName);
  }

  // Get current best meal
  Meal? getCurrentBestMeal(String mealName) {
    if (population.isEmpty) return null;

    final fitnessScores = population.map(calculateFitness).toList();
    final bestIndex = fitnessScores.indexOf(fitnessScores.reduce(math.min));
    final bestMeal = population[bestIndex];

    return convertToMeal(bestMeal, mealName);
  }

  // Get fitness of current best meal
  double? getCurrentBestFitness() {
    if (population.isEmpty) return null;

    final fitnessScores = population.map(calculateFitness).toList();
    return fitnessScores.reduce(math.min);
  }
}
