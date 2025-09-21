import 'package:boiler_fuel/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDB {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<List<Food>?> getFoodIDsMeal(
    String diningCourt,
    DateTime date,
    MealTime mealTime,
  ) async {
    String collection = 'dining-halls';
    String document = diningCourt;

    // try {
    DocumentSnapshot<dynamic> snapshot = await db
        .collection(collection)
        .doc(document)
        .collection('meals')
        .doc(
          "${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}-${date.year}",
        )
        .get();
    if (snapshot.exists) {
      print(
        "Fetched meal data for $diningCourt on ${date.month}-${date.day}-${date.year}",
      );
      Meals meals = Meals.fromMap(snapshot.data() ?? {});
      print(snapshot.data());
      List<Map<String, dynamic>> foodIDs;

      switch (mealTime) {
        case MealTime.breakfast:
          foodIDs = meals.breakfast;
          break;
        case MealTime.brunch:
          foodIDs = meals.brunch;
          break;
        case MealTime.lunch:
          foodIDs = meals.lunch;
          break;
        // Assuming lateLunch uses lunch data
        case MealTime.dinner:
          foodIDs = meals.dinner;
          break;
      }
      print("Found ${foodIDs.length} food items for $mealTime");

      List<Food> foods = [];
      for (dynamic foodID in foodIDs) {
        //check if foods already contains foodID
        if (foods.any((food) => food.id == foodID["id"])) {
          continue;
        }
        Food? food = await getFoodByID(foodID["id"]);
        if (food != null) {
          food.station = foodID["station"] ?? "";
          foods.add(food);
        }
      }
      return foods;
    }
    // } catch (error) {
    //   print('Error fetching data (getFoodIDsMeal): $error');
    // }
    return null;
  }

  Future<Food?> getFoodByID(String foodID) async {
    String collection = 'foods';
    String document = foodID;

    // try {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await db
        .collection(collection)
        .doc(document)
        .get();
    if (snapshot.exists) {
      return Food.fromMap(snapshot.data() ?? {});
    }
    // } catch (error) {
    //   print('Error fetching data (getFoodByID): $error');
    // }
    return null;
  }
}
