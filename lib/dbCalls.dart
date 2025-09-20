import 'package:boiler_fuel/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCalls {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getIDs(
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
        return snapshot.data() as Map<String, dynamic>;
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
    return null;
  }

  Future<List<Map<String, dynamic>>?> getFoods() async {
    String collection = 'foods';

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await db
          .collection(collection)
          .get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) => doc.data()).toList();
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
    return null;
  }
}
