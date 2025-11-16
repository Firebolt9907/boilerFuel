import 'package:boiler_fuel/api/cloud_db_interface.dart';
import 'package:boiler_fuel/api/database.dart';
import 'package:boiler_fuel/constants.dart';
import 'package:flutter/material.dart';

class CFDatabase implements CloudDbInterface {
  final String? uid;
  final bool localApi = true;
  // final String cloudEndpoint =
  final List<String> debugEndpoint = ["http:localhost:8787"];
  CFDatabase({this.uid});


  Future<List<MiniFood>?> getFoodIDsMeal(
    String diningCourt,
    DateTime date,
    MealTime mealTime,
  ) async {
  }

  Future<Food?> getFoodByID(String foodID) async {
  }

  Future<List<DiningHall>> getAllDiningHalls() async {
  }

  Future<DiningHall?> getDiningHallByName(String diningHallID) async {
  }
}
