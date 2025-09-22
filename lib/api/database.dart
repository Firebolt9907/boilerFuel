import 'package:boiler_fuel/api/firebase_database.dart';
import 'package:boiler_fuel/api/local_database.dart';
import 'package:boiler_fuel/api/web_api.dart';
import 'package:boiler_fuel/constants.dart';

class Database {
  Future<Food> getFoodByID(String foodID) async {
    Food? localFood = await LocalDatabase().getFoodByID(foodID);
    if (localFood != null) {
      return localFood;
    }
    Food? fbFood = await FBDatabase().getFoodByID(foodID);
    if (fbFood != null) {
      await LocalDatabase().addFood(fbFood);
      return fbFood;
    }
    Food newFood = (await WebAPI().fetchFoodResponse(foodID))!;
    await LocalDatabase().addFood(newFood);
    return newFood;
    throw Exception("Food with ID $foodID not found in local or Firebase DB");
  }

  Future<List<Food>?> getDiningCourtMeal(
    String diningCourt,
    DateTime date,
    MealTime mealTime,
  ) async {
    List<Food>? foods = await FBDatabase().getFoodIDsMeal(
      diningCourt,
      date,
      mealTime,
    );
    return foods;
  }
}
