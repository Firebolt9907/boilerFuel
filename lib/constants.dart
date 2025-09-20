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

  factory Food.fromMap(Map<String, dynamic> map) {
    return Food(
      name: map['name'],
      id: map['id'],
      calories: map['calories'],
      protein: map['protein'],
      carbs: map['carbs'],
      fat: map['fat'],
      sugar: map['sugar'],
      ingredients: map['ingredients'],
      labels: List<String>.from(map['labels']),
    );
  }
}

enum EatingHabit { cutting, bulking, maintenance }

enum MealPlan { TenDay, FourteenDay, Unlimited }

enum Gender { Male, Female }

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
  final EatingHabit eatingHabit;
  final List<FoodPreference> foodPreferences;
  final List<FoodAllergy> foodAllergies;
  final MealPlan mealPlan;
  final List<String> diningHallRanking;
  final int age;
  final Gender gender;

  User({
    required this.uid,
    required this.name,
    required this.weight,
    required this.height,
    required this.eatingHabit,
    required this.foodPreferences,
    required this.mealPlan,
    required this.diningHallRanking,
    required this.age,
    required this.gender,
    required this.foodAllergies,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'weight': weight,
      'height': height,
      'eatingHabit': eatingHabit.toString().split('.').last,
      'foodPreferences': foodPreferences,
      'mealPlan': mealPlan.toString().split('.').last,
      'diningHallRanking': diningHallRanking,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'],
      name: map['name'],
      weight: map['weight'],
      height: map['height'],
      eatingHabit: EatingHabit.values.firstWhere(
        (e) => e.toString().split('.').last == map['eatingHabit'],
      ),
      foodPreferences: List<FoodPreference>.from(
        (map['foodPreferences'] as List<dynamic>).map(
          (e) => FoodPreference.fromString(e as String),
        ),
      ),
      mealPlan: MealPlan.values.firstWhere(
        (m) => m.toString().split('.').last == map['mealPlan'],
      ),
      diningHallRanking: List<String>.from(map['diningHallRanking']),
      age: map['age'],
      gender: map['gender'],
      foodAllergies: List<FoodAllergy>.from(
        (map['foodAllergies'] as List<dynamic>).map(
          (e) => FoodAllergy.fromString(e as String),
        ),
      ),
    );
  }
}

enum MealTime {
  breakfast,
  brunch,
  lunch,
  lateLunch,
  dinner
}

getMealTimeString(MealTime mealTime) {
  switch (mealTime) {
    case MealTime.breakfast:
      return 'breakfast';
    case MealTime.brunch:
      return 'brunch';
    case MealTime.lunch:
      return 'lunch';
    case MealTime.lateLunch:
      return 'lateLunch';
    case MealTime.dinner:
      return 'dinner';
    default:
      return '';
  }
}
