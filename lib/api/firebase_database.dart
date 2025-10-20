import 'package:boiler_fuel/api/database.dart';
import 'package:boiler_fuel/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
        case MealTime.lateLunch:
          foodIDs = meals.lunch;
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

  Future<void> createDiningHalls() async {
    Schedule fordSchedule = Schedule(
      breakfast: {
        'Sunday': TimePeriod(
          start: TimeOfDay(hour: 8, minute: 0),
          end: TimeOfDay(hour: 10, minute: 0),
        ),
        'Monday': TimePeriod(
          start: TimeOfDay(hour: 7, minute: 0),
          end: TimeOfDay(hour: 10, minute: 0),
        ),
        'Tuesday': TimePeriod(
          start: TimeOfDay(hour: 7, minute: 0),
          end: TimeOfDay(hour: 10, minute: 0),
        ),
        'Wednesday': TimePeriod(
          start: TimeOfDay(hour: 7, minute: 0),
          end: TimeOfDay(hour: 10, minute: 0),
        ),
        'Thursday': TimePeriod(
          start: TimeOfDay(hour: 7, minute: 0),
          end: TimeOfDay(hour: 10, minute: 0),
        ),
        'Friday': TimePeriod(
          start: TimeOfDay(hour: 7, minute: 0),
          end: TimeOfDay(hour: 10, minute: 0),
        ),
        'Saturday': TimePeriod(
          start: TimeOfDay(hour: 8, minute: 0),
          end: TimeOfDay(hour: 10, minute: 0),
        ),
      },

      brunch: null,
      lunch: {
        'Sunday': TimePeriod(
          start: TimeOfDay(hour: 11, minute: 0),
          end: TimeOfDay(hour: 14, minute: 0),
        ),
        'Monday': TimePeriod(
          start: TimeOfDay(hour: 11, minute: 0),
          end: TimeOfDay(hour: 14, minute: 0),
        ),
        'Tuesday': TimePeriod(
          start: TimeOfDay(hour: 11, minute: 0),
          end: TimeOfDay(hour: 14, minute: 0),
        ),
        'Wednesday': TimePeriod(
          start: TimeOfDay(hour: 11, minute: 0),
          end: TimeOfDay(hour: 14, minute: 0),
        ),
        'Thursday': TimePeriod(
          start: TimeOfDay(hour: 11, minute: 0),
          end: TimeOfDay(hour: 14, minute: 0),
        ),
        'Friday': TimePeriod(
          start: TimeOfDay(hour: 11, minute: 0),
          end: TimeOfDay(hour: 14, minute: 0),
        ),
        'Saturday': TimePeriod(
          start: TimeOfDay(hour: 11, minute: 0),
          end: TimeOfDay(hour: 14, minute: 0),
        ),
      },
      lateLunch: null,
      dinner: {
        'Sunday': TimePeriod(
          start: TimeOfDay(hour: 17, minute: 0),
          end: TimeOfDay(hour: 21, minute: 0),
        ),
        'Monday': TimePeriod(
          start: TimeOfDay(hour: 17, minute: 0),
          end: TimeOfDay(hour: 21, minute: 0),
        ),
        'Tuesday': TimePeriod(
          start: TimeOfDay(hour: 17, minute: 0),
          end: TimeOfDay(hour: 21, minute: 0),
        ),
        'Wednesday': TimePeriod(
          start: TimeOfDay(hour: 17, minute: 0),
          end: TimeOfDay(hour: 21, minute: 0),
        ),
        'Thursday': TimePeriod(
          start: TimeOfDay(hour: 17, minute: 0),
          end: TimeOfDay(hour: 21, minute: 0),
        ),
        'Friday': TimePeriod(
          start: TimeOfDay(hour: 17, minute: 0),
          end: TimeOfDay(hour: 21, minute: 0),
        ),
        'Saturday': null,
      },
    );
    await diningHallsCollection.doc("Ford").set({
      'name': "Ford",
      'id': "Ford",
      'schedule': fordSchedule.toMap(),
    });
    Schedule wileySchedule = Schedule(
      breakfast: {
        'Sunday': null,
        'Monday': TimePeriod(
          start: TimeOfDay(hour: 7, minute: 0),
          end: TimeOfDay(hour: 10, minute: 0),
        ),
        'Tuesday': TimePeriod(
          start: TimeOfDay(hour: 7, minute: 0),
          end: TimeOfDay(hour: 10, minute: 0),
        ),
        'Wednesday': TimePeriod(
          start: TimeOfDay(hour: 7, minute: 0),
          end: TimeOfDay(hour: 10, minute: 0),
        ),
        'Thursday': TimePeriod(
          start: TimeOfDay(hour: 7, minute: 0),
          end: TimeOfDay(hour: 10, minute: 0),
        ),
        'Friday': TimePeriod(
          start: TimeOfDay(hour: 7, minute: 0),
          end: TimeOfDay(hour: 10, minute: 0),
        ),
        'Saturday': null,
      },

      brunch: null,
      lunch: {
        'Sunday': null,
        'Monday': TimePeriod(
          start: TimeOfDay(hour: 11, minute: 0),
          end: TimeOfDay(hour: 14, minute: 0),
        ),
        'Tuesday': TimePeriod(
          start: TimeOfDay(hour: 11, minute: 0),
          end: TimeOfDay(hour: 14, minute: 0),
        ),
        'Wednesday': TimePeriod(
          start: TimeOfDay(hour: 11, minute: 0),
          end: TimeOfDay(hour: 14, minute: 0),
        ),
        'Thursday': TimePeriod(
          start: TimeOfDay(hour: 11, minute: 0),
          end: TimeOfDay(hour: 14, minute: 0),
        ),
        'Friday': TimePeriod(
          start: TimeOfDay(hour: 11, minute: 0),
          end: TimeOfDay(hour: 14, minute: 0),
        ),
        'Saturday': TimePeriod(
          start: TimeOfDay(hour: 11, minute: 0),
          end: TimeOfDay(hour: 14, minute: 0),
        ),
      },
      lateLunch: null,
      dinner: {
        'Sunday': TimePeriod(
          start: TimeOfDay(hour: 17, minute: 0),
          end: TimeOfDay(hour: 21, minute: 0),
        ),
        'Monday': TimePeriod(
          start: TimeOfDay(hour: 17, minute: 0),
          end: TimeOfDay(hour: 21, minute: 0),
        ),
        'Tuesday': TimePeriod(
          start: TimeOfDay(hour: 17, minute: 0),
          end: TimeOfDay(hour: 21, minute: 0),
        ),
        'Wednesday': TimePeriod(
          start: TimeOfDay(hour: 17, minute: 0),
          end: TimeOfDay(hour: 21, minute: 0),
        ),
        'Thursday': TimePeriod(
          start: TimeOfDay(hour: 17, minute: 0),
          end: TimeOfDay(hour: 21, minute: 0),
        ),
        'Friday': TimePeriod(
          start: TimeOfDay(hour: 17, minute: 0),
          end: TimeOfDay(hour: 21, minute: 0),
        ),
        'Saturday': TimePeriod(
          start: TimeOfDay(hour: 17, minute: 0),
          end: TimeOfDay(hour: 21, minute: 0),
        ),
      },
    );
    await diningHallsCollection.doc("Wiley").set({
      'name': "Wiley",
      'id': "Wiley",
      'schedule': wileySchedule.toMap(),
    });

    Schedule windsorSchedule = Schedule(
      breakfast: null,

      brunch: null,
      lunch: {
        'Sunday': TimePeriod(
          start: TimeOfDay(hour: 11, minute: 0),
          end: TimeOfDay(hour: 14, minute: 0),
        ),
        'Monday': TimePeriod(
          start: TimeOfDay(hour: 10, minute: 0),
          end: TimeOfDay(hour: 14, minute: 0),
        ),
        'Tuesday': TimePeriod(
          start: TimeOfDay(hour: 10, minute: 0),
          end: TimeOfDay(hour: 14, minute: 0),
        ),
        'Wednesday': TimePeriod(
          start: TimeOfDay(hour: 10, minute: 0),
          end: TimeOfDay(hour: 14, minute: 0),
        ),
        'Thursday': TimePeriod(
          start: TimeOfDay(hour: 10, minute: 0),
          end: TimeOfDay(hour: 14, minute: 0),
        ),
        'Friday': TimePeriod(
          start: TimeOfDay(hour: 10, minute: 0),
          end: TimeOfDay(hour: 14, minute: 0),
        ),
        'Saturday': null,
      },
      lateLunch: {
        'Sunday': null,
        'Monday': TimePeriod(
          start: TimeOfDay(hour: 14, minute: 0),
          end: TimeOfDay(hour: 17, minute: 0),
        ),
        'Tuesday': TimePeriod(
          start: TimeOfDay(hour: 14, minute: 0),
          end: TimeOfDay(hour: 17, minute: 0),
        ),
        'Wednesday': TimePeriod(
          start: TimeOfDay(hour: 14, minute: 0),
          end: TimeOfDay(hour: 17, minute: 0),
        ),
        'Thursday': TimePeriod(
          start: TimeOfDay(hour: 14, minute: 0),
          end: TimeOfDay(hour: 17, minute: 0),
        ),
        'Friday': TimePeriod(
          start: TimeOfDay(hour: 14, minute: 0),
          end: TimeOfDay(hour: 16, minute: 0),
        ),
        'Saturday': TimePeriod(
          start: TimeOfDay(hour: 14, minute: 0),
          end: TimeOfDay(hour: 17, minute: 0),
        ),
      },
      dinner: {
        'Sunday': TimePeriod(
          start: TimeOfDay(hour: 17, minute: 0),
          end: TimeOfDay(hour: 21, minute: 0),
        ),
        'Monday': TimePeriod(
          start: TimeOfDay(hour: 17, minute: 0),
          end: TimeOfDay(hour: 21, minute: 0),
        ),
        'Tuesday': TimePeriod(
          start: TimeOfDay(hour: 17, minute: 0),
          end: TimeOfDay(hour: 21, minute: 0),
        ),
        'Wednesday': TimePeriod(
          start: TimeOfDay(hour: 17, minute: 0),
          end: TimeOfDay(hour: 21, minute: 0),
        ),
        'Thursday': TimePeriod(
          start: TimeOfDay(hour: 17, minute: 0),
          end: TimeOfDay(hour: 21, minute: 0),
        ),
        'Friday': null,
        'Saturday': TimePeriod(
          start: TimeOfDay(hour: 17, minute: 0),
          end: TimeOfDay(hour: 21, minute: 0),
        ),
      },
    );
    await diningHallsCollection.doc("Windsor").set({
      'name': "Windsor",
      'id': "Windsor",
      'schedule': windsorSchedule.toMap(),
    });
    Schedule hillenbrandSchedule = Schedule(
      breakfast: null,

      brunch: {
        'Sunday': TimePeriod(
          start: TimeOfDay(hour: 11, minute: 0),
          end: TimeOfDay(hour: 14, minute: 0),
        ),
        'Monday': null,
        'Tuesday': null,
        'Wednesday': null,
        'Thursday': null,
        'Friday': null,
        'Saturday': null,
      },
      lunch: {
        'Sunday': null,
        'Monday': TimePeriod(
          start: TimeOfDay(hour: 11, minute: 0),
          end: TimeOfDay(hour: 14, minute: 0),
        ),
        'Tuesday': TimePeriod(
          start: TimeOfDay(hour: 11, minute: 0),
          end: TimeOfDay(hour: 14, minute: 0),
        ),
        'Wednesday': TimePeriod(
          start: TimeOfDay(hour: 11, minute: 0),
          end: TimeOfDay(hour: 14, minute: 0),
        ),
        'Thursday': TimePeriod(
          start: TimeOfDay(hour: 11, minute: 0),
          end: TimeOfDay(hour: 14, minute: 0),
        ),
        'Friday': null,
        'Saturday': null,
      },
      lateLunch: {
        'Sunday': null,
        'Monday': TimePeriod(
          start: TimeOfDay(hour: 14, minute: 0),
          end: TimeOfDay(hour: 17, minute: 0),
        ),
        'Tuesday': TimePeriod(
          start: TimeOfDay(hour: 14, minute: 0),
          end: TimeOfDay(hour: 17, minute: 0),
        ),
        'Wednesday': TimePeriod(
          start: TimeOfDay(hour: 14, minute: 0),
          end: TimeOfDay(hour: 17, minute: 0),
        ),
        'Thursday': TimePeriod(
          start: TimeOfDay(hour: 14, minute: 0),
          end: TimeOfDay(hour: 17, minute: 0),
        ),
        'Friday': null,
        'Saturday': null,
      },
      dinner: {
        'Sunday': null,
        'Monday': TimePeriod(
          start: TimeOfDay(hour: 17, minute: 0),
          end: TimeOfDay(hour: 21, minute: 0),
        ),
        'Tuesday': TimePeriod(
          start: TimeOfDay(hour: 17, minute: 0),
          end: TimeOfDay(hour: 21, minute: 0),
        ),
        'Wednesday': TimePeriod(
          start: TimeOfDay(hour: 17, minute: 0),
          end: TimeOfDay(hour: 21, minute: 0),
        ),
        'Thursday': TimePeriod(
          start: TimeOfDay(hour: 17, minute: 0),
          end: TimeOfDay(hour: 21, minute: 0),
        ),
        'Friday': null,
        'Saturday': null,
      },
    );
    await diningHallsCollection.doc("Hillenbrand").set({
      'name': "Hillenbrand",
      'id': "Hillenbrand",
      'schedule': hillenbrandSchedule.toMap(),
    });
    Schedule earhartSchedule = Schedule(
      breakfast: {
        'Sunday': null,
        'Monday': TimePeriod(
          start: TimeOfDay(hour: 7, minute: 0),
          end: TimeOfDay(hour: 10, minute: 0),
        ),
        'Tuesday': TimePeriod(
          start: TimeOfDay(hour: 7, minute: 0),
          end: TimeOfDay(hour: 10, minute: 0),
        ),
        'Wednesday': TimePeriod(
          start: TimeOfDay(hour: 7, minute: 0),
          end: TimeOfDay(hour: 10, minute: 0),
        ),
        'Thursday': TimePeriod(
          start: TimeOfDay(hour: 7, minute: 0),
          end: TimeOfDay(hour: 10, minute: 0),
        ),
        'Friday': TimePeriod(
          start: TimeOfDay(hour: 7, minute: 0),
          end: TimeOfDay(hour: 10, minute: 0),
        ),
        'Saturday': null,
      },

      brunch: null,
      lunch: {
        'Sunday': TimePeriod(
          start: TimeOfDay(hour: 11, minute: 0),
          end: TimeOfDay(hour: 14, minute: 0),
        ),
        'Monday': TimePeriod(
          start: TimeOfDay(hour: 11, minute: 0),
          end: TimeOfDay(hour: 14, minute: 0),
        ),
        'Tuesday': TimePeriod(
          start: TimeOfDay(hour: 11, minute: 0),
          end: TimeOfDay(hour: 14, minute: 0),
        ),
        'Wednesday': TimePeriod(
          start: TimeOfDay(hour: 11, minute: 0),
          end: TimeOfDay(hour: 14, minute: 0),
        ),
        'Thursday': TimePeriod(
          start: TimeOfDay(hour: 11, minute: 0),
          end: TimeOfDay(hour: 14, minute: 0),
        ),
        'Friday': TimePeriod(
          start: TimeOfDay(hour: 11, minute: 0),
          end: TimeOfDay(hour: 14, minute: 0),
        ),
        'Saturday': TimePeriod(
          start: TimeOfDay(hour: 11, minute: 0),
          end: TimeOfDay(hour: 14, minute: 0),
        ),
      },
      lateLunch: null,
      dinner: {
        'Sunday': TimePeriod(
          start: TimeOfDay(hour: 17, minute: 0),
          end: TimeOfDay(hour: 21, minute: 0),
        ),
        'Monday': TimePeriod(
          start: TimeOfDay(hour: 17, minute: 0),
          end: TimeOfDay(hour: 21, minute: 0),
        ),
        'Tuesday': TimePeriod(
          start: TimeOfDay(hour: 17, minute: 0),
          end: TimeOfDay(hour: 21, minute: 0),
        ),
        'Wednesday': TimePeriod(
          start: TimeOfDay(hour: 17, minute: 0),
          end: TimeOfDay(hour: 21, minute: 0),
        ),
        'Thursday': TimePeriod(
          start: TimeOfDay(hour: 17, minute: 0),
          end: TimeOfDay(hour: 21, minute: 0),
        ),
        'Friday': TimePeriod(
          start: TimeOfDay(hour: 17, minute: 0),
          end: TimeOfDay(hour: 21, minute: 0),
        ),
        'Saturday': TimePeriod(
          start: TimeOfDay(hour: 17, minute: 0),
          end: TimeOfDay(hour: 21, minute: 0),
        ),
      },
    );
    await diningHallsCollection.doc("Earhart").set({
      'name': "Earhart",
      'id': "Earhart",
      'schedule': earhartSchedule.toMap(),
    });
  }

  Future<List<DiningHall>> getAllDiningHalls() async {
    QuerySnapshot snapshot = await diningHallsCollection.get();
    List<DiningHall> diningHalls = snapshot.docs.map((doc) {
      return DiningHall.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
    return diningHalls;
  }

  Future<DiningHall?> getDiningHallByName(String diningHallID) async {
    // try {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await diningHallsCollection.doc(diningHallID).get()
            as DocumentSnapshot<Map<String, dynamic>>;
    if (snapshot.exists) {
      return DiningHall.fromMap(snapshot.data() ?? {});
    }
    // } catch (error) {
    //   print('Error fetching data (getDiningHallByName): $error');
    // }
    return null;
  }
}
