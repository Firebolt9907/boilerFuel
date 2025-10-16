import 'dart:async';

import 'package:boiler_fuel/api/database.dart';
import 'package:boiler_fuel/api/local_database.dart';
import 'package:boiler_fuel/main.dart';
import 'package:boiler_fuel/screens/item_details_screen.dart';
import 'package:boiler_fuel/widgets/custom_app_bar.dart';
import 'package:boiler_fuel/widgets/custom_tabs.dart';
import 'package:boiler_fuel/widgets/default_container.dart';
import 'package:flutter/cupertino.dart';
import '../custom/cupertinoSheet.dart' as customCupertinoSheet;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';
import 'meal_details_screen.dart';
import 'collection_screen.dart';

// Data structure for isolate communication
class _MenuProcessingData {
  final Map<MealTime, List<Food>> mealTimeFood;
  final DietaryRestrictions dietaryRestrictions;
  final String diningHall;

  _MenuProcessingData({
    required this.mealTimeFood,
    required this.dietaryRestrictions,
    required this.diningHall,
  });
}

// Result structure from isolate
class _MenuProcessingResult {
  final Map<MealTime, Map<String, List<FoodItem>>> mealTimeData;
  final List<MealTime> availableTimes;

  _MenuProcessingResult({
    required this.mealTimeData,
    required this.availableTimes,
  });
}

// Wrapper class to handle both individual foods and collections
class FoodItem {
  final String name;
  final bool isCollection;
  final List<Food>
  foods; // Contains single food for individual items, multiple for collections
  final String station;
  final String? collection;

  FoodItem({
    required this.name,
    required this.isCollection,
    required this.foods,
    required this.station,
    this.collection,
  });

  Food get firstFood => foods.first;
}

class SuggestedMealsScreen extends StatefulWidget {
  final User user;

  const SuggestedMealsScreen({Key? key, required this.user}) : super(key: key);

  @override
  _SuggestedMealsScreenState createState() => _SuggestedMealsScreenState();
}

class _SuggestedMealsScreenState extends State<SuggestedMealsScreen>
    with TickerProviderStateMixin {
  bool _isLoading = true;
  List<MealTime> _availableMealTimes = [];
  MealTime _selectedMealTime = MealTime.breakfast;
  Map<MealTime, List<Meal>> _meals = {};
  final StreamController<Map<MealTime, Map<String, Meal>>>
  _mealStreamController = StreamController.broadcast();
  // Spacing between station items

  bool tappedSection = false;

  void _fetchMenuData() async {
    setState(() {
      _isLoading = true;
    });

    Map<MealTime, Map<String, Meal>>? dayMeals = await LocalDatabase()
        .getAIDayMeals();
    print("Day Meals fetched: $dayMeals");
    if (dayMeals != null) {
      Map<MealTime, Map<String, Meal>> sortedSuggestions = {};
      for (MealTime mealTime in dayMeals.keys) {
        Map<String, Meal> originalMeals = dayMeals[mealTime]!;
        Map<String, Meal> sortedMeals = {};

        // First, add dining halls in the order of user's ranking
        for (String rankedHall in widget.user.diningHallRank) {
          if (originalMeals.containsKey(rankedHall)) {
            sortedMeals[rankedHall] = originalMeals[rankedHall]!;
          }
        }

        // Then, add any remaining dining halls that weren't in the user's ranking
        for (String diningHall in originalMeals.keys) {
          if (!sortedMeals.containsKey(diningHall)) {
            sortedMeals[diningHall] = originalMeals[diningHall]!;
          }
        }

        sortedSuggestions[mealTime] = sortedMeals;
      }
      Map<MealTime, List<Meal>> flattenedMeals = {};
      for (MealTime mealTime in sortedSuggestions.keys) {
        for (String diningHall in sortedSuggestions[mealTime]!.keys) {
          if (!flattenedMeals.containsKey(mealTime)) {
            flattenedMeals[mealTime] = [];
          }
          flattenedMeals[mealTime]!.add(
            sortedSuggestions[mealTime]![diningHall]!,
          );
          // Only take the first dining hall's meal for each meal time
        }
      }

      setState(() {
        print("Sorted Suggestions:");
        print(
          "Sorted Suggestions:" +
              sortedSuggestions
                  .map((k, v) => MapEntry(k.toString(), v.keys.toList()))
                  .toString(),
        );

        _availableMealTimes = sortedSuggestions.keys.toList();
        //Sort available meal times based on breakfast, lunch, dinner
        _availableMealTimes.sort((a, b) => a.index.compareTo(b.index));
        _meals = flattenedMeals;

        _isLoading = false;
        _selectedMealTime = _availableMealTimes.first;
      });
    }
    await LocalDatabase().listenToAIDayMeals(_mealStreamController);

    _mealStreamController.stream.listen((meals) {
      Map<MealTime, Map<String, Meal>> sortedSuggestions = {};
      for (MealTime mealTime in meals.keys) {
        Map<String, Meal> originalMeals = meals[mealTime]!;
        Map<String, Meal> sortedMeals = {};

        // First, add dining halls in the order of user's ranking
        for (String rankedHall in widget.user.diningHallRank) {
          if (originalMeals.containsKey(rankedHall)) {
            sortedMeals[rankedHall] = originalMeals[rankedHall]!;
          }
        }

        // Then, add any remaining dining halls that weren't in the user's ranking
        for (String diningHall in originalMeals.keys) {
          if (!sortedMeals.containsKey(diningHall)) {
            sortedMeals[diningHall] = originalMeals[diningHall]!;
          }
        }

        sortedSuggestions[mealTime] = sortedMeals;
      }

      Map<MealTime, List<Meal>> flattenedMeals = {};
      for (MealTime mealTime in sortedSuggestions.keys) {
        for (String diningHall in sortedSuggestions[mealTime]!.keys) {
          if (!flattenedMeals.containsKey(mealTime)) {
            flattenedMeals[mealTime] = [];
          }
          flattenedMeals[mealTime]!.add(
            sortedSuggestions[mealTime]![diningHall]!,
          );
          // Only take the first dining hall's meal for each meal time
        }
      }
      setState(() {
        print("Sorted Suggestions:");
        print(
          "Sorted Suggestions:" +
              sortedSuggestions
                  .map((k, v) => MapEntry(k.toString(), v.keys.toList()))
                  .toString(),
        );
        _meals = flattenedMeals;
        _availableMealTimes = sortedSuggestions.keys.toList();
        _availableMealTimes.sort((a, b) => a.index.compareTo(b.index));
        _isLoading = false;
        if (!_availableMealTimes.contains(_selectedMealTime)) {
          _selectedMealTime = _availableMealTimes.first;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchMenuData();
  }

  @override
  void dispose() {
    super.dispose();
    _mealStreamController.close();
  }

  int menuCallCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
            ),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top - 12),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: styling.gray,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),

                      Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: styling.gray,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24.0, bottom: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Suggested Meals",
                            style: TextStyle(fontSize: 24, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _isLoading
                      ? _buildLoadingView()
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Meal time selector
                            _buildMealTimeSelector(),

                            const SizedBox(height: 8),
                            // Station selector

                            // PageView for stations - give it a bounded max height
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                // Use a fraction of available height as an upper bound
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.7,
                              ),
                              child: _buildMealsView(),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade300),
          ),
          SizedBox(height: 16),
          Text(
            'Loading menu...',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
              fontFamily: '.SF Pro Text',
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              color: Colors.white.withOpacity(0.4),
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              'No menu available',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: '.SF Pro Display',
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Check back later for today\'s menu',
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 14,
                fontFamily: '.SF Pro Text',
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealTimeSelector() {
    if (_availableMealTimes.isEmpty) return SizedBox.shrink();

    return Container(
      height: 44,

      decoration: BoxDecoration(
        color: Color(0xffececf0),
        borderRadius: BorderRadius.circular(20),
      ),

      child: CustomTabs(
        initialValue: _selectedMealTime.toString(),
        onValueChanged: (value) {
          print("Meal time changed to $value");
          setState(() {
            _selectedMealTime = MealTime.fromString(value);
          });
        },
        tabs: [
          for (MealTime mealTime in _availableMealTimes)
            TabItem(
              label: mealTime.toDisplayString(),
              value: mealTime.toString(),
            ),
        ],
      ),
    );
  }

  Widget _buildMealsView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_meals[_selectedMealTime] == null)
            _buildEmptyView()
          else
            ..._meals[_selectedMealTime]!
                .map(
                  (meal) => Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey[200]!),
                    ),
                    child: InkWell(
                      onTap: () async {
                        HapticFeedback.lightImpact();
                        await Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => MealDetailsScreen(
                              meal: meal,
                              diningHall: meal.diningHall,
                            ),
                          ),
                        );
                        _fetchMenuData();
                      },
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              meal.name,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${meal.diningHall}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),

                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          styling.darkGray.withOpacity(0.05),
                                          styling.darkGray.withOpacity(0.1),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Calories',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${meal.calories.round()}',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          styling.darkGray.withOpacity(0.05),
                                          styling.darkGray.withOpacity(0.1),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Protein',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${meal.protein.round()}g',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey[400],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
        ],
      ),
    );
  }

  String _getMealTimeDisplayName(MealTime mealTime) {
    switch (mealTime) {
      case MealTime.breakfast:
        return 'Breakfast';
      case MealTime.lunch:
        return 'Lunch';
      case MealTime.dinner:
        return 'Dinner';
      default:
        return 'Menu';
    }
  }

  // Static function to process menu data in isolate
}
