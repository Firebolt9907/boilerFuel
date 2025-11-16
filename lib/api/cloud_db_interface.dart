import 'package:boiler_fuel/constants.dart';

abstract interface class CloudDbInterface {
  Future<List<MiniFood>?> getFoodIDsMeal(
    String diningCourt,
    DateTime date,
    MealTime mealTime,
  );

  Future<Food?> getFoodByID(String foodID);

  Future<List<DiningHall>> getAllDiningHalls();

  Future<DiningHall?> getDiningHallByName(String diningHallID);
}
