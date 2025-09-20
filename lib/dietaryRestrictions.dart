

import 'package:boiler_fuel/constants.dart';

class DietaryRestrictions {
  final List<FoodAllergy> allergies;
  final List<FoodPreference> preferences;

  DietaryRestrictions({
    this.allergies = const [],
    this.preferences = const [],
  });

}