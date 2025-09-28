import 'package:flutter/material.dart';

class Food {
  final String name;
  final String id;
  double calories;
  double protein;
  double carbs;
  double fat;
  double sugar;
  final String ingredients;
  String station;
  final List<String> labels;
  bool restricted;
  String rejectedReason;
  String? collection;

  Food({
    required this.name,
    required this.id,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.sugar,
    required this.ingredients,
    required this.labels,
    this.restricted = false,
    this.rejectedReason = "",
    this.station = "",
    this.collection,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'sugar': sugar,
      'ingredients': ingredients,
      'labels': labels,
      'rejectedReason': rejectedReason,
      'station': station,
      'collection': collection,
      'restricted': restricted,
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }

  String toMiniString() {
    return '{name:$name,id:$id,calories:$calories,protein:$protein,carbs:$carbs,fat:$fat,sugar:$sugar,restricted:$restricted}';
  }

  factory Food.fromMap(Map<String, dynamic> map) {
    return Food(
      name: map['name'],
      id: map['id'],
      calories: (map['calories'] ?? -1) * 1.0,
      protein: (map['protein'] ?? -1) * 1.0,
      carbs: (map['carbs'] ?? -1) * 1.0,
      fat: (map['fat'] ?? -1) * 1.0,
      sugar: (map['sugar'] ?? -1) * 1.0,
      ingredients: map['ingredients'],
      labels: List<String>.from(map['labels'] ?? []),
      station: map['station'] ?? "",
      rejectedReason: map['rejectedReason'] ?? "",
      collection: map['collection'],
      restricted: map['restricted'] ?? false,
    );
  }

  factory Food.fromGraphQL(Map<String, dynamic> data) {
    List<String> labels = [];
    if (data['traits'] != null) {
      for (var trait in data['traits']) {
        if (trait['name'] != null) {
          labels.add(trait['name']);
        }
      }
    }

    double calories = -1;
    double protein = -1;
    double carbs = -1;
    double fat = -1;
    double sugar = -1;

    if (data['nutritionFacts'] != null) {
      for (var fact in data['nutritionFacts']) {
        if (fact['name'] == 'Calories') {
          calories = (fact['value'] ?? 0).toDouble();
        } else if (fact['name'] == 'Protein') {
          protein = (fact['value'] ?? 0).toDouble();
        } else if (fact['name'] == 'Total Carbohydrate') {
          carbs = (fact['value'] ?? 0).toDouble();
        } else if (fact['name'] == 'Total Fat') {
          fat = (fact['value'] ?? 0).toDouble();
        } else if (fact['name'] == 'Sugars') {
          sugar = (fact['value'] ?? 0).toDouble();
        }
      }
    }

    return Food(
      name: data['name'] ?? 'Unknown',
      id: data['itemId'] ?? '',
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
      sugar: sugar,
      ingredients: data['ingredients'] ?? '',
      labels: labels,
      restricted: data['restricted'] ?? false,
    );
  }
}

enum MealPlan {
  TenDay,
  FourteenDay,
  Unlimited,
  unset,
  FiftyBlock,
  EightyBlock,
  SevenDay;

  @override
  String toString() {
    switch (this) {
      case MealPlan.TenDay:
        return '10 Day';
      case MealPlan.FourteenDay:
        return '14 Day';
      case MealPlan.Unlimited:
        return 'Unlimited';
      case MealPlan.unset:
        return 'Unset';
      case MealPlan.FiftyBlock:
        return '50 Block';
      case MealPlan.EightyBlock:
        return '80 Block';
      case MealPlan.SevenDay:
        return '7 Day';
    }
  }

  static MealPlan fromString(String value) {
    switch (value) {
      case '10 Day':
        return MealPlan.TenDay;
      case '14 Day':
        return MealPlan.FourteenDay;
      case 'Unlimited':
        return MealPlan.Unlimited;
      case 'Unset':
        return MealPlan.unset;
      case '40 Block':
        return MealPlan.FiftyBlock;
      case '80 Block':
        return MealPlan.EightyBlock;
      case '7 Day':
        return MealPlan.SevenDay;
      default:
        return MealPlan.unset;
    }
  }
}

enum Gender {
  male,
  female;

  @override
  String toString() {
    switch (this) {
      case Gender.female:
        return "female";
      case Gender.male:
        return "male";
    }
  }

  static Gender fromString(String value) {
    switch (value) {
      case "female":
        return Gender.female;
      case "male":
        return Gender.male;
      default:
        throw ArgumentError('Invalid Gender: $value');
    }
  }
}

enum FoodPreference {
  Vegan,
  Vegetarian,
  Pescatarian,
  Halal,
  Kosher;

  @override
  String toString() {
    switch (this) {
      case FoodPreference.Vegan:
        return 'Vegan';
      case FoodPreference.Vegetarian:
        return 'Vegetarian';
      case FoodPreference.Pescatarian:
        return 'Pescatarian';
      case FoodPreference.Halal:
        return 'Halal';
      case FoodPreference.Kosher:
        return 'Kosher';
    }
  }

  static FoodPreference fromString(String value) {
    switch (value) {
      case 'Vegan':
        return FoodPreference.Vegan;
      case 'Vegetarian':
        return FoodPreference.Vegetarian;
      case 'Pescatarian':
        return FoodPreference.Pescatarian;
      case 'Halal':
        return FoodPreference.Halal;
      case 'Kosher':
        return FoodPreference.Kosher;
      default:
        throw ArgumentError('Invalid food preference: $value');
    }
  }
}

enum FoodAllergy {
  Gluten,
  Dairy,
  Nuts,
  Shellfish,
  Soy,
  Eggs,
  Peanuts,
  Wheat,
  Fish,
  TreeNuts,
  Coconut,
  Sesame;

  @override
  String toString() {
    switch (this) {
      case FoodAllergy.Gluten:
        return 'Gluten';
      case FoodAllergy.Dairy:
        return 'Dairy';
      case FoodAllergy.Nuts:
        return 'Nuts';
      case FoodAllergy.Shellfish:
        return 'Shellfish';
      case FoodAllergy.Soy:
        return 'Soy';
      case FoodAllergy.Eggs:
        return 'Eggs';
      case FoodAllergy.Peanuts:
        return 'Peanuts';
      case FoodAllergy.Wheat:
        return 'Wheat';
      case FoodAllergy.Fish:
        return 'Fish';
      case FoodAllergy.TreeNuts:
        return 'Tree Nuts';
      case FoodAllergy.Sesame:
        return 'Sesame';
      case FoodAllergy.Coconut:
        return 'Coconut';
    }
  }

  static FoodAllergy fromString(String value) {
    switch (value) {
      case 'Gluten':
        return FoodAllergy.Gluten;
      case 'Dairy':
        return FoodAllergy.Dairy;
      case 'Nuts':
        return FoodAllergy.Nuts;
      case 'Shellfish':
        return FoodAllergy.Shellfish;
      case 'Soy':
        return FoodAllergy.Soy;
      case 'Eggs':
        return FoodAllergy.Eggs;
      case 'Peanuts':
        return FoodAllergy.Peanuts;
      case 'Wheat':
        return FoodAllergy.Wheat;
      case 'Fish':
        return FoodAllergy.Fish;
      case 'Tree Nuts':
        return FoodAllergy.TreeNuts;
      case 'Sesame':
        return FoodAllergy.Sesame;
      case 'Coconut':
        return FoodAllergy.Coconut;
      default:
        throw ArgumentError('Invalid food allergy: $value');
    }
  }
}

class User {
  final String uid;
  final String name;
  final int weight;
  final int height;
  final Goal goal;
  DietaryRestrictions dietaryRestrictions;
  MealPlan mealPlan;
  List<String> diningHallRank;
  final int age;
  final Gender gender;

  User({
    required this.uid,
    required this.name,
    required this.weight,
    required this.height,
    required this.goal,
    required this.dietaryRestrictions,
    required this.mealPlan,
    required this.diningHallRank,
    required this.age,
    required this.gender,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'weight': weight,
      'height': height,
      'goal': goal.toString(),
      'dietaryRestrictions': dietaryRestrictions.toMap(),
      'mealPlan': mealPlan.toString(),
      'diningHallRank': diningHallRank,
      'age': age,
      'gender': gender.toString(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'],
      name: map['name'],
      weight: map['weight'],
      height: map['height'],
      goal: Goal.fromString(map['goal']),
      dietaryRestrictions: DietaryRestrictions.fromMap(
        map['dietaryRestrictions'],
      ),
      mealPlan: MealPlan.fromString(map['mealPlan']),
      diningHallRank: List<String>.from(map['diningHallRank']),
      age: map['age'] ?? 19,
      gender: Gender.fromString(map['gender']) ?? Gender.male,
    );
  }
}

enum MealTime {
  breakfast,
  brunch,
  lunch,
  lateLunch,
  dinner;

  @override
  String toString() {
    switch (this) {
      case MealTime.breakfast:
        return 'breakfast';
      case MealTime.brunch:
        return 'brunch';
      case MealTime.lunch:
        return 'lunch';
      case MealTime.lateLunch:
        return 'lunch'; // Treat late lunch as lunch
      case MealTime.dinner:
        return 'dinner';
    }
  }

  static MealTime fromString(String value) {
    switch (value) {
      case 'breakfast':
        return MealTime.breakfast;
      case 'brunch':
        return MealTime.brunch;
      case 'lunch':
        return MealTime.lunch;
      case 'dinner':
        return MealTime.dinner;
      default:
        throw ArgumentError('Invalid meal time: $value');
    }
  }
}

class MiniFood {
  final String id;
  final String station;
  final String? collection;

  MiniFood({required this.id, required this.station, this.collection});

  Map<String, dynamic> toMap() {
    return {'id': id, 'station': station, 'collection': collection};
  }

  @override
  String toString() {
    return toMap().toString();
  }

  factory MiniFood.fromMap(Map<String, dynamic> map) {
    return MiniFood(
      id: map['id'],
      station: map['station'] ?? "",
      collection: map['collection'],
    );
  }
}

class TimePeriod {
  final TimeOfDay start;
  final TimeOfDay end;

  TimePeriod({required this.start, required this.end});

  Map<String, dynamic> toMap() {
    return {
      'start':
          '${start.hour.toString().padLeft(2, '0')}:'
          '${start.minute.toString().padLeft(2, '0')}',
      'end':
          '${end.hour.toString().padLeft(2, '0')}:'
          '${end.minute.toString().padLeft(2, '0')}',
    };
  }

  factory TimePeriod.fromMap(Map<String, dynamic> map) {
    return TimePeriod(
      start: TimeOfDay(
        hour: int.parse(map['start'].split(':')[0]),
        minute: int.parse(map['start'].split(':')[1]),
      ),
      end: TimeOfDay(
        hour: int.parse(map['end'].split(':')[0]),
        minute: int.parse(map['end'].split(':')[1]),
      ),
    );
  }

  bool isOpenNow() {
    DateTime now = DateTime.now();
    DateTime startTime = DateTime(
      now.year,
      now.month,
      now.day,
      start.hour,
      start.minute,
    );
    DateTime endTime = DateTime(
      now.year,
      now.month,
      now.day,
      end.hour,
      end.minute,
    );

    return (now.isAfter(startTime) && now.isBefore(endTime)) ||
        now.isAtSameMomentAs(startTime) ||
        now.isAtSameMomentAs(endTime);
  }
}

class Schedule {
  final Map<String, TimePeriod?>? breakfast;
  final Map<String, TimePeriod?>? brunch;
  final Map<String, TimePeriod?>? lunch;
  final Map<String, TimePeriod?>? dinner;
  final Map<String, TimePeriod?>? lateLunch;

  Schedule({
    this.breakfast,
    this.brunch,
    this.lunch,
    this.dinner,
    this.lateLunch,
  });

  @override
  String toString() {
    return '''=== SCHEDULE ===
Breakfast: ${breakfast ?? 'Closed'}
Brunch: ${brunch ?? 'Closed'}
Lunch: ${lunch ?? 'Closed'}
Late Lunch: ${lateLunch ?? 'Closed'}
Dinner: ${dinner ?? 'Closed'}
''';
  }

  Map<String, dynamic> toMap() {
    return {
      'breakfast': breakfast != null
          ? breakfast!.map((key, value) => MapEntry(key, value?.toMap()))
          : null,
      'brunch': brunch != null
          ? brunch!.map((key, value) => MapEntry(key, value?.toMap()))
          : null,
      'lunch': lunch != null
          ? lunch!.map((key, value) => MapEntry(key, value?.toMap()))
          : null,
      'dinner': dinner != null
          ? dinner!.map((key, value) => MapEntry(key, value?.toMap()))
          : null,
      'lateLunch': lateLunch != null
          ? lateLunch!.map((key, value) => MapEntry(key, value?.toMap()))
          : null,
    };
  }

  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
      breakfast: map['breakfast'] != null
          ? (map['breakfast'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(
                key,
                value != null ? TimePeriod.fromMap(value) : null,
              ),
            )
          : null,
      brunch: map['brunch'] != null
          ? (map['brunch'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(
                key,
                value != null ? TimePeriod.fromMap(value) : null,
              ),
            )
          : null,
      lunch: map['lunch'] != null
          ? (map['lunch'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(
                key,
                value != null ? TimePeriod.fromMap(value) : null,
              ),
            )
          : null,
      dinner: map['dinner'] != null
          ? (map['dinner'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(
                key,
                value != null ? TimePeriod.fromMap(value) : null,
              ),
            )
          : null,
      lateLunch: map['lateLunch'] != null
          ? (map['lateLunch'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(
                key,
                value != null ? TimePeriod.fromMap(value) : null,
              ),
            )
          : null,
    );
  }

  MealTime? getCurrentMealTime() {
    DateTime now = DateTime.now();
    String weekday = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ][now.weekday - 1];
    if (breakfast != null &&
        breakfast![weekday] != null &&
        breakfast![weekday]!.isOpenNow()) {
      return MealTime.breakfast;
    } else if (brunch != null &&
        brunch![weekday] != null &&
        brunch![weekday]!.isOpenNow()) {
      return MealTime.brunch;
    } else if (lunch != null &&
        lunch![weekday] != null &&
        lunch![weekday]!.isOpenNow()) {
      return MealTime.lunch;
    } else if (lateLunch != null &&
        lateLunch![weekday] != null &&
        lateLunch![weekday]!.isOpenNow()) {
      return MealTime.lateLunch;
    } else if (dinner != null &&
        dinner![weekday] != null &&
        dinner![weekday]!.isOpenNow()) {
      return MealTime.dinner;
    }
    return null;
  }
}

class DiningHall {
  final String name;
  final String id;
  final Schedule schedule;

  DiningHall({required this.name, required this.id, required this.schedule});

  Map<String, dynamic> toMap() {
    return {'name': name, 'id': id, 'schedule': schedule.toMap()};
  }

  @override
  String toString() {
    return toMap().toString();
  }

  factory DiningHall.fromMap(Map<String, dynamic> map) {
    return DiningHall(
      name: map['name'],
      id: map['id'],
      schedule: Schedule.fromMap(map['schedule']),
    );
  }
}

class DiningHallMeals {
  final List<MiniFood> breakfast;
  final List<MiniFood> brunch;
  final List<MiniFood> lunch;
  final List<MiniFood> dinner;

  DiningHallMeals({
    required this.breakfast,
    required this.brunch,
    required this.lunch,
    required this.dinner,
  });

  Map<String, dynamic> toMap() {
    return {
      'breakfast': breakfast.map((f) => f.toMap()).toList(),
      'brunch': brunch.map((f) => f.toMap()).toList(),
      'lunch': lunch.map((f) => f.toMap()).toList(),
      'dinner': dinner.map((f) => f.toMap()).toList(),
    };
  }

  factory DiningHallMeals.fromMap(Map<String, dynamic> map) {
    return DiningHallMeals(
      breakfast: List<MiniFood>.from(
        (map['Breakfast'] as List<dynamic>).map(
          (f) => MiniFood.fromMap(f as Map<String, dynamic>),
        ),
      ),
      brunch: List<MiniFood>.from(
        (map['Brunch'] as List<dynamic>).map(
          (f) => MiniFood.fromMap(f as Map<String, dynamic>),
        ),
      ),
      lunch: List<MiniFood>.from(
        (map['Lunch'] as List<dynamic>).map(
          (f) => MiniFood.fromMap(f as Map<String, dynamic>),
        ),
      ),
      dinner: List<MiniFood>.from(
        (map['Dinner'] as List<dynamic>).map(
          (f) => MiniFood.fromMap(f as Map<String, dynamic>),
        ),
      ),
    );
  }
}

enum ActivityLevel {
  sedentary, // Little/no exercise
  lightly, // Light exercise 1-3 days/week
  moderately, // Moderate exercise 3-5 days/week
  very, // Hard exercise 6-7 days/week
  extremely, // Very hard exercise & physical job
}

enum Goal {
  lose, // Weight loss
  maintain, // Maintain weight
  gain; // Weight gain

  @override
  String toString() {
    switch (this) {
      case Goal.lose:
        return "Cutting";
      case Goal.maintain:
        return "Maintain";
      case Goal.gain:
        return "Bulking";
    }
  }

  static Goal fromString(String value) {
    switch (value) {
      case 'Cutting':
        return Goal.lose;
      case 'Maintain':
        return Goal.maintain;
      case 'Bulking':
        return Goal.gain;
      default:
        throw ArgumentError('Invalid goal: $value');
    }
  }
}

class MacroResult {
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double bmr;
  final double tdee;

  MacroResult({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.bmr,
    required this.tdee,
  });

  @override
  String toString() {
    return '''
=== CALORIE & MACRO RESULTS ===
BMR (Basal Metabolic Rate): ${bmr.round()} calories
TDEE (Total Daily Energy Expenditure): ${tdee.round()} calories
Target Calories: ${calories.round()} calories

=== MACRONUTRIENTS ===
Protein: ${protein.round()}g (${(protein * 4).round()} calories)
Carbohydrates: ${carbs.round()}g (${(carbs * 4).round()} calories)
Fat: ${fat.round()}g (${(fat * 9).round()} calories)
''';
  }
}

class DietaryRestrictions {
  final List<FoodAllergy> allergies;
  final List<FoodPreference> preferences;
  final List<String> ingredientPreferences;

  DietaryRestrictions({
    required this.allergies,
    required this.preferences,
    required this.ingredientPreferences,
  });

  Map<String, dynamic> toMap() {
    return {
      'allergies': allergies.map((e) => e.toString()).toList(),
      'preferences': preferences.map((e) => e.toString()).toList(),
      'ingredientPreferences': ingredientPreferences,
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }

  factory DietaryRestrictions.fromMap(Map<String, dynamic> map) {
    return DietaryRestrictions(
      allergies: List<FoodAllergy>.from(
        (map['allergies'] as List<dynamic>).map(
          (e) => FoodAllergy.fromString(e as String),
        ),
      ),
      preferences: List<FoodPreference>.from(
        (map['preferences'] as List<dynamic>).map(
          (e) => FoodPreference.fromString(e as String),
        ),
      ),
      ingredientPreferences: List<String>.from(
        map['ingredientPreferences'] ?? [],
      ),
    );
  }

  bool hasDietaryRestrictions() {
    return allergies.isNotEmpty ||
        preferences.isNotEmpty ||
        ingredientPreferences.isNotEmpty;
  }

  bool isFoodSuitable(Food food) {
    // Check allergies
    for (var allergy in allergies) {
      if (food.labels.contains(allergy.toString())) {
        food.rejectedReason = "Contains allergen: ${allergy.toString()}";
        return false;
      }
      if (food.labels.contains("Milk") && allergy == FoodAllergy.Dairy) {
        food.rejectedReason = "Contains allergen: ${allergy.toString()}";
        return false;
      }
    }

    // Check preferences
    for (var preference in preferences) {
      if (!food.labels.contains(preference.toString())) {
        food.rejectedReason =
            "Does not meet preference: ${preference.toString()}";
        return false;
      }
    }

    // Check ingredient preferences
    for (var i = 0; i < ingredientPreferences.length; i++) {
      var ingredient = ingredientPreferences[i];

      // Expand aliases
      // if (ingredientAliases[ingredient] != null &&
      //     ingredientsWithAliasesPlaced[ingredient] == null) {
      //   print(ingredientsWithAliasesPlaced);
      //   print("i = $i adding aliases for: " + ingredient);
      //   ingredientsWithAliasesPlaced.addEntries({ingredient: true}.entries);
      //   ingredientPreferences.addAll(ingredientAliases[ingredient]!);
      // }

      // Check food name for restricted ingredients
      if (food.name.toLowerCase().contains(ingredient.toLowerCase())) {
        bool falsePositive = false;
        if (ingredientAliasFalsePositives[ingredient] != null) {
          food.rejectedReason = "Is dispreferred ingredient: $ingredient";
          return false;
        }
      }

      // Check ingredients list for restricted ingredients
      if (food.ingredients.toLowerCase().contains(ingredient.toLowerCase())) {
        food.rejectedReason = "Contains dispreferred ingredient: $ingredient";
        return false;
      }
    }

    return true;
  }

  List<List<Food>> filterFoodList(List<Food> allFoods) {
    return [
      allFoods.where((food) {
        bool suitable = isFoodSuitable(food);
        food.restricted = !suitable;
        return suitable;
      }).toList(),
      allFoods.where((food) {
        bool suitable = isFoodSuitable(food);
        food.restricted = !suitable;
        return !suitable;
      }).toList(),
    ];
  }
}

// Map of ingredient to its common aliases
var ingredientAliases = {
  "shellfish": [
    "shrimp",
    "prawn",
    "prawns",
    "crab",
    "lobster",
    "crayfish",
    "scallop",
    "oyster",
  ],
  "pork": ["bacon", "ham", "sausage", "salami", "prosciutto", "chorizo"],
  "beef": ["steak", "ribs", "brisket", "birria"],
  "chicken": ["pollo"],
};

var ingredientAliasFalsePositives = {
  "pork": ["bun"],
};

class Meal {
  String name;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final List<Food> foods;
  String diningHall;
  MealTime? mealTime;

  Meal({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.foods,
    required this.diningHall,
    this.mealTime,
  });

  @override
  String toString() {
    return '''=== ${name.toUpperCase()} at $diningHall ===
Total Calories: ${calories.round()} kcal
Protein: ${protein.round()}g
Carbs: ${carbs.round()}g
Fat: ${fat.round()}g
Foods:
${foods.map((f) => "- ${f.name} (${f.calories} kcal, ${f.protein}g P, ${f.carbs}g C, ${f.fat}g F)").join("\n")}
''';
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'foods': foods.map((f) => f.toMap()).toList(),
      'diningHall': diningHall,
    };
  }

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      name: map['name'],
      calories: (map['calories'] ?? -1) * 1.0,
      protein: (map['protein'] ?? -1) * 1.0,
      carbs: (map['carbs'] ?? -1) * 1.0,
      fat: (map['fat'] ?? -1) * 1.0,
      foods: List<Food>.from(
        (map['foods'] as List<dynamic>).map(
          (f) => Food.fromMap(f as Map<String, dynamic>),
        ),
      ),
      diningHall: map['diningHall'],
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) {
      return this; // Return empty string if it's empty
    }
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
