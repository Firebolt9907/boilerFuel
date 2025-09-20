import 'package:boiler_fuel/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCalls {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getData(
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
        return snapshot.data()![getMealTimeString(mealTime)]
            as Map<String, dynamic>;
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
    return null;
  }
}
