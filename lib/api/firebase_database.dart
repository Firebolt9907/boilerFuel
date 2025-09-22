import 'package:boiler_fuel/api/database.dart';
import 'package:boiler_fuel/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FBDatabase {
  final String? uid;
  FBDatabase({this.uid});

  final CollectionReference foodCollection = FirebaseFirestore.instance
      .collection("foods");
  final CollectionReference diningHallsCollection = FirebaseFirestore.instance
      .collection("dining-halls");

  Future<List<MiniFood>?> getFoodIDsMeal(
    String diningCourt,
    DateTime date,
    MealTime mealTime,
  ) async {
    String document = diningCourt;

    // try {
    DocumentSnapshot<dynamic> snapshot = await diningHallsCollection
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
      DiningHallMeals meals = DiningHallMeals.fromMap(snapshot.data() ?? {});
      print(snapshot.data());
      List<MiniFood> foodIDs;

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
      return foodIDs;

      List<Food> foods = [];
      for (MiniFood foodID in foodIDs) {
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
    }
    // } catch (error) {
    //   print('Error fetching data (getFoodIDsMeal): $error');
    // }
    return null;
  }

  Future<Food?> getFoodByID(String foodID) async {
    String document = foodID;

    // try {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await foodCollection.doc(document).get()
            as DocumentSnapshot<Map<String, dynamic>>;
    if (snapshot.exists) {
      return Food.fromMap(snapshot.data() ?? {});
    }
    // } catch (error) {
    //   print('Error fetching data (getFoodByID): $error');
    // }
    return null;
  }
}
