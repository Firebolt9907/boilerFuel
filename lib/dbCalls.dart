import 'package:boiler_fuel/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCalls {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<List<String>?> getFoodIDsMeal(
    String diningCourt,
    DateTime date,
    MealTime mealTime,
  ) async {
    String collection = 'dining-halls';
    String document = diningCourt;

    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await db
          .collection(collection)
          .doc(document)
          .collection('meals')
          .doc(
            "${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}-${date.year}",
          )
          .get();
      if (snapshot.exists) {
        Meals meals = Meals.fromMap(snapshot.data() ?? {});
        switch (mealTime) {
          case MealTime.breakfast:
            return meals.breakfast;
          case MealTime.brunch:
            return meals.brunch;
          case MealTime.lunch:
            return meals.lunch;
          case MealTime.lateLunch:
            return meals.lunch; // Assuming lateLunch uses lunch data
          case MealTime.dinner:
            return meals.dinner;
        }
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
    return null;
  }

  Future<List<Food>?> getFoods() async {
    String collection = 'foods';

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await db
          .collection(collection)
          .get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) => Food.fromMap(doc.data())).toList();
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
    return null;
  }
}
