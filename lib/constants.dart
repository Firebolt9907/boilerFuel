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

class User {
  final String uid;
  final String name;
  final int weight;
  final int height;
  final EatingHabit eatingHabit;
  final List<String> foodPreferences;
  final MealPlan mealPlan;
  final List<String> diningHallRanking;

  User({
    required this.uid,
    required this.name,
    required this.weight,
    required this.height,
    required this.eatingHabit,
    required this.foodPreferences,
    required this.mealPlan,
    required this.diningHallRanking,
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
      foodPreferences: List<String>.from(map['foodPreferences']),
      mealPlan: MealPlan.values.firstWhere(
        (m) => m.toString().split('.').last == map['mealPlan'],
      ),
      diningHallRanking: List<String>.from(map['diningHallRanking']),
    );
  }
}

class Meal {
  final List<String> breakfast;
  final List<String> brunch;
  final List<String> lunch;
  final List<String> dinner;

  Meal({
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

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      breakfast: List<String>.from(map['breakfast']),
      brunch: List<String>.from(map['brunch']),
      lunch: List<String>.from(map['lunch']),
      dinner: List<String>.from(map['dinner']),
    );
  }
}
