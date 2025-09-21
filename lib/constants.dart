class Food {
  final String name;
  final String id;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double sugar;
  final String ingredients;
  final List<String> labels;
  String rejectedReason;

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
    this.rejectedReason = "",
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
    };
  }

  @override
  String toString() {
    return toMap().toString();
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
      rejectedReason: map['rejectedReason'] ?? "",
    );
  }
}

enum MealPlan {
  TenDay,
  FourteenDay,
  Unlimited,
  unset,
  FortyBlock,
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
      case MealPlan.FortyBlock:
        return '40 Block';
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
        return MealPlan.FortyBlock;
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

class Meals {
  final List<String> breakfast;
  final List<String> brunch;
  final List<String> lunch;
  final List<String> dinner;

  Meals({
    required this.breakfast,
    required this.brunch,
    required this.lunch,
    required this.dinner,
  });

  Map<String, dynamic> toMap() {
    return {
      'breakfast': breakfast,
      'brunch': brunch,
      'lunch': lunch,
      'dinner': dinner,
    };
  }

  factory Meals.fromMap(Map<String, dynamic> map) {
    return Meals(
      breakfast: List<String>.from(map['Breakfast'] ?? []),
      brunch: List<String>.from(map['Brunch'] ?? []),
      lunch: List<String>.from(map['Lunch'] ?? []),
      dinner: List<String>.from(map['Dinner'] ?? []),
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
      if (ingredientAliases[ingredient] != null) {
        ingredientPreferences.addAll(ingredientAliases[ingredient]!);
      }

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
      allFoods.where((food) => isFoodSuitable(food)).toList(),
      allFoods.where((food) => !isFoodSuitable(food)).toList(),
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
  final String name;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final List<Food> foods;
  final String diningHall;

  Meal({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.foods,
    required this.diningHall,
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
}
