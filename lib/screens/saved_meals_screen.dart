import 'package:boiler_fuel/styling.dart';
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

class SavedMealsScreen extends StatefulWidget {
  final User user;

  const SavedMealsScreen({Key? key, required this.user}) : super(key: key);

  @override
  _SavedMealsScreenState createState() => _SavedMealsScreenState();
}

class _SavedMealsScreenState extends State<SavedMealsScreen>
    with TickerProviderStateMixin {
  bool _isLoading = true;
  List<MealTime> _availableMealTimes = [];
  MealTime _selectedMealTime = MealTime.dinner;
  List<Meal> _meals = [];

  // Spacing between station items

  bool tappedSection = false;

  void _fetchSavedMeals() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch saved meals from the database
      List<Meal> meals = await LocalDatabase().getFavoritedMeals();

      // Determine available meal times from fetched meals (filter out nulls)
      Set<MealTime> mealTimesSet = meals
          .map((meal) => meal.mealTime)
          .whereType<MealTime>()
          .toSet();
      List<MealTime> mealTimesList = mealTimesSet.toList()
        ..sort((a, b) => a.index.compareTo(b.index));

      setState(() {
        _meals = meals;
        _availableMealTimes = mealTimesList;
        print(meals.map((e) => e.mealTime).toList());
        _selectedMealTime = MealTime.getCurrentMealTime();
        if (!_availableMealTimes.contains(MealTime.getCurrentMealTime())) {
          _selectedMealTime = _availableMealTimes.first;
        }
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching saved meals: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchSavedMeals();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int menuCallCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              color: DynamicStyling.getWhite(context),
              border: Border(
                bottom: BorderSide(color: DynamicStyling.getGrey(context)),
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top),
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
                          HapticFeedback.lightImpact();
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
                            "Saved Meals",
                            style: TextStyle(
                              fontSize: 24,
                              color: DynamicStyling.getBlack(context),
                            ),
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
                  const SizedBox(height: 8),
                  _isLoading
                      ? _buildLoadingView()
                      : Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: _availableMealTimes.isEmpty
                                ? [
                                    // No saved meals view
                                    _buildEmptyView(),
                                  ]
                                : [
                                    // Meal time selector
                                    _buildMealTimeSelector(),

                                    const SizedBox(height: 8),
                                    // Station selector

                                    // PageView for stations - give it a bounded max height
                                    Expanded(child: _buildMealsView()),
                                  ],
                          ),
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
              color: DynamicStyling.getWhite(context).withOpacity(0.7),
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
              color: DynamicStyling.getWhite(context).withOpacity(0.4),
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              'No saved meals',
              style: TextStyle(
                color: DynamicStyling.getBlack(context),
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: '.SF Pro Display',
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tap on the bookmark icon on any meal to save it here.',
              style: TextStyle(
                color: DynamicStyling.getDarkGrey(context),
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

      // decoration: BoxDecoration(
      //   color: Color(0xffececf0),
      //   borderRadius: BorderRadius.circular(20),
      // ),
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
    return ListView.builder(
      padding: EdgeInsets.all(0),
      itemCount: _meals
          .where((meal) => meal.mealTime == _selectedMealTime)
          .length,
      itemBuilder: (context, index) {
        final meal = _meals
            .where((meal) => meal.mealTime == _selectedMealTime)
            .toList()[index];
        return Card(
          elevation: 0,
          color: DynamicStyling.getWhite(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey[200]!),
          ),
          child: InkWell(
            onTap: () async {
              HapticFeedback.mediumImpact();
              await Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => MealDetailsScreen(
                    meal: meal,
                    diningHall: meal.diningHall,
                  ),
                ),
              );
              _fetchSavedMeals();
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${meal.diningHall}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),

                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                DynamicStyling.getDarkGrey(
                                  context,
                                ).withOpacity(0.05),
                                DynamicStyling.getDarkGrey(
                                  context,
                                ).withOpacity(0.1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                DynamicStyling.getDarkGrey(
                                  context,
                                ).withOpacity(0.05),
                                DynamicStyling.getDarkGrey(
                                  context,
                                ).withOpacity(0.1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                      Icon(Icons.chevron_right, color: Colors.grey[400]),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
