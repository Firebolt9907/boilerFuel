import 'package:boiler_fuel/styling.dart';
import 'package:boiler_fuel/api/database.dart';
import 'package:boiler_fuel/api/local_database.dart';
import 'package:boiler_fuel/main.dart';
import 'package:boiler_fuel/screens/item_details_screen.dart';
import 'package:boiler_fuel/widgets/custom_app_bar.dart';
import 'package:boiler_fuel/widgets/custom_tabs.dart';
import 'package:boiler_fuel/widgets/default_container.dart';
import 'package:boiler_fuel/widgets/header.dart';
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

class FavoritedFoodsScreen extends StatefulWidget {
  final User user;

  const FavoritedFoodsScreen({Key? key, required this.user}) : super(key: key);

  @override
  _FavoritedFoodsScreenState createState() => _FavoritedFoodsScreenState();
}

class _FavoritedFoodsScreenState extends State<FavoritedFoodsScreen>
    with TickerProviderStateMixin {
  bool _isLoading = true;
  List<MealTime> _availableMealTimes = [];
  MealTime _selectedMealTime = MealTime.dinner;
  List<Food> _foods = [];

  // Spacing between station items

  bool tappedSection = false;

  void _fetchFavoritedFoods() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch saved meals from the database
      List<Food> foods = await LocalDatabase().getFavoritedFoods();
      print(foods);

      setState(() {
        _foods = foods;
        print(foods.map((e) => e.name).toList());
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
    _fetchFavoritedFoods();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int menuCallCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DynamicStyling.getWhite(context),
      body: Column(
        children: [
          // Header
          // Container(
          //   decoration: BoxDecoration(
          //     color: DynamicStyling.getWhite(context),
          //     border: Border(
          //       bottom: BorderSide(color: DynamicStyling.getGrey(context)),
          //     ),
          //   ),
          //   child: Column(
          //     children: [
          //       SizedBox(height: MediaQuery.of(context).padding.top),
          //       GestureDetector(
          //         onTap: () {
          //           HapticFeedback.lightImpact();
          //           Navigator.of(context).pop();
          //         },
          //         child: Row(
          //           children: [
          //             IconButton(
          //               icon: Icon(
          //                 Icons.arrow_back_ios_new,
          //                 color: styling.gray,
          //               ),
          //               onPressed: () {
          //                 HapticFeedback.lightImpact();
          //                 Navigator.of(context).pop();
          //               },
          //             ),

          //             Text(
          //               'Back',
          //               style: TextStyle(
          //                 fontSize: 14,
          //                 fontWeight: FontWeight.bold,
          //                 color: styling.gray,
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.only(left: 24.0, bottom: 18),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Text(
          //                   "Saved Meals",
          //                   style: TextStyle(
          //                     fontSize: 24,
          //                     color: DynamicStyling.getBlack(context),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Header(context: context, title: "Favorited Food Items"),

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
                            children: _foods.isEmpty
                                ? [
                                    // No saved meals view
                                    _buildEmptyView(),
                                  ]
                                : [
                                    // PageView for stations - give it a bounded max height
                                    Expanded(child: _buildFoodsView()),
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
              'No favorited foods',
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
              'Tap on the bookmark icon on any food item to save it here.',
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

  Widget _buildFoodsView() {
    return ListView.builder(
      padding: EdgeInsets.all(0),
      itemCount: _foods.length,
      itemBuilder: (context, index) {
        final food = _foods.toList()[index];
        return _buildFoodItem(food, index);
      },
    );
  }

  Widget _buildFoodItem(Food food, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          _showFoodDetails(food);
        },
        child: DefaultContainer(
          primaryColor: food.restricted ? Colors.red : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                food.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: DynamicStyling.getBlack(context),
                                  fontFamily: '.SF Pro Text',
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: DynamicStyling.getWhite(context).withOpacity(0.4),
                    size: 20,
                  ),
                ],
              ),

              // Nutrition info (show only for individual items)
              if (food.calories > 0)
                Text(
                  food.calories.round().toString() + " cal",
                  style: TextStyle(
                    fontSize: 14,
                    color: DynamicStyling.getDarkGrey(context),
                    fontFamily: '.SF Pro Text',
                    decoration: TextDecoration.none,
                  ),
                ),

              // Labels/allergens
              if (food.labels.isNotEmpty) ...[
                SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: food.labels
                      .take(4)
                      .map(
                        (label) => Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: DynamicStyling.getDarkGrey(
                              context,
                            ).withOpacity(0.1),
                          ),
                          child: Text(
                            label,
                            style: TextStyle(
                              color: DynamicStyling.getDarkGrey(context),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              fontFamily: '.SF Pro Text',
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showFoodDetails(Food food) {
    // Create a single-item meal for the food details screen
    Meal singleFoodMeal = Meal(
      name: food.name,
      foods: [food],
      calories: food.calories,
      protein: food.protein,
      carbs: food.carbs,
      fat: food.fat,
      diningHall: "",
      isAIGenerated: false,
      id: food.id,
    );

    customCupertinoSheet
        .showCupertinoSheet<void>(
          context: context,
          useNestedNavigation: true,
          pageBuilder: (BuildContext context) => ItemDetailsScreen(food: food),
        )
        .then((e) {
          _fetchFavoritedFoods();
        });
  }
}
