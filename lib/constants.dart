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
    );
  }
}

enum MealPlan { TenDay, FourteenDay, Unlimited }

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
        return 'TreeNuts';
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
      case 'TreeNuts':
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
  final DietaryRestrictions dietaryRestrictions;
  final MealPlan mealPlan;
  final List<String> diningHallRanking;
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
    required this.diningHallRanking,
    required this.age,
    required this.gender,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'weight': weight,
      'height': height,
      'goal': goal.toString().split('.').last,
      'dietaryRestrictions': dietaryRestrictions.toMap(),
      'mealPlan': mealPlan.toString().split('.').last,
      'diningHallRanking': diningHallRanking,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'],
      name: map['name'],
      weight: map['weig`ht'],
      height: map['height'],
      goal: Goal.values.firstWhere(
        (e) => e.toString().split('.').last == map['eatingHabit'],
      ),
      dietaryRestrictions: DietaryRestrictions.fromMap(
        map['dietaryRestrictions'],
      ),
      mealPlan: MealPlan.values.firstWhere(
        (m) => m.toString().split('.').last == map['mealPlan'],
      ),
      diningHallRanking: List<String>.from(map['diningHallRanking']),
      age: map['age'],
      gender: map['gender'],
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
  gain, // Weight gain
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
}

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
}
