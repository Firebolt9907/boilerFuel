import 'package:boiler_fuel/api/database.dart';
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
  MealTime _selectedMealTime = MealTime.breakfast;

  // Spacing between station items

  bool tappedSection = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
                            "Saved Meals",
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
         
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
