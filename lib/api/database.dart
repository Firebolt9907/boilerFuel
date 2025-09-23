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
    List<MiniFood>? foodIDs = await LocalDatabase().getDiningHallMeals(
      diningCourt,
      date,
      mealTime,
    );
    if (foodIDs == null) {
      print(
        "No local meal data found, fetching from Firebase $diningCourt on"
        " ${date.month}-${date.day}-${date.year} for $mealTime",
      );
      List<MiniFood>? foods = await FBDatabase().getFoodIDsMeal(
        diningCourt,
        date,
        mealTime,
      );

      await LocalDatabase().addDiningHallMeal(
        foods ?? [],
        diningCourt,
        date,
        mealTime,
      );

      foodIDs = foods;
    }
    List<Food> foods = [];
    for (MiniFood foodID in foodIDs ?? []) {
      //check if foods already contains foodID
      if (foods.any((food) => food.id == foodID.id)) {
        continue;
      }
      print(
        "Fetcing from dining hall: ${diningCourt}, foodID: ${foodID.id}, station: ${foodID.station}",
      );
      Food food = await Database().getFoodByID(foodID.id);

      food.station = foodID.station;
      foods.add(food);
    }

    return foods;
  }

  Future<List<DiningHall>> getDiningHalls() async {
    List<DiningHall> localDiningHalls = await LocalDatabase().getDiningHalls();
    if (localDiningHalls.isEmpty) {
      print("No local dining halls found, fetching from Firebase");
      List<DiningHall> fbDiningHalls = await FBDatabase().getAllDiningHalls();
      for (DiningHall diningHall in fbDiningHalls) {
        await LocalDatabase().addDiningHall(diningHall);
      }
      return fbDiningHalls;
    }
    return localDiningHalls;
  }
}
