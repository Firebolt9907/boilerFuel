import 'package:boiler_fuel/styling.dart';
import 'package:boiler_fuel/api/database.dart';
import 'package:boiler_fuel/main.dart';
import 'package:boiler_fuel/screens/item_details_screen.dart';
// removed unused import
import 'package:boiler_fuel/widgets/custom_tabs.dart';
import 'package:boiler_fuel/widgets/default_container.dart';
import 'package:boiler_fuel/widgets/default_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:string_similarity/string_similarity.dart';
import '../custom/cupertinoSheet.dart' as customCupertinoSheet;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';
// removed unused imports

// (Unused helper types for isolate processing removed)

// Wrapper class to handle both individual foods and collections
class FoodItem {
  final String name;

  final Food
  food; // Contains single food for individual items, multiple for collections
  final String station;
  final String? collection;
  final String diningHall;
  final MealTime mealTime;

  FoodItem({
    required this.name,

    required this.food,
    required this.station,
    required this.diningHall,
    this.collection,
    required this.mealTime,
  });
}

class DiningHallSearchScreen extends StatefulWidget {
  final String? diningHall;
  final User user;

  const DiningHallSearchScreen({
    Key? key,
    required this.diningHall,
    required this.user,
  }) : super(key: key);

  @override
  _DiningHallSearchScreenState createState() => _DiningHallSearchScreenState();
}

class _DiningHallSearchScreenState extends State<DiningHallSearchScreen>
    with TickerProviderStateMixin {
  bool _isLoading = true;
  // Station selection state (reserved for future use)

  // New variables for meal time selection
  Map<MealTime, List<FoodItem>> _allMealData = {};
  List<FoodItem> filteredFoods = [];
  TextEditingController searchController = TextEditingController();

  List<MealTime> _availableMealTimes = [];
  MealTime? _selectedMealTime;

  bool tappedSection = false;
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 200), () {
      if (mounted) {
        _loadDiningHallMenu();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  int menuCallCount = 0;

  Future<void> _loadDiningHallMenu() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Get list of meal times to process

      // Fetch data from database (must be done on main thread)
      Map<MealTime, List<FoodItem>> mealTimeFood = {};
      List<String> diningHallsToFetch = widget.diningHall != null
          ? [widget.diningHall!]
          : ['Earhart', 'Wiley', 'Ford', 'Hillenbrand', 'Windsor'];
      List<MealTime> mealTimesToProcess = MealTime.values
          .where(
            (mealTime) =>
                mealTime != MealTime.lateLunch &&
                !(mealTime == MealTime.brunch &&
                    widget.diningHall != "Hillenbrand"),
          )
          .toList();
      for (String hall in diningHallsToFetch) {
        for (MealTime mealTime in mealTimesToProcess) {
          menuCallCount++;
          print("calling Database().getDiningCourtMeal; call #$menuCallCount");

          List<Food>? diningHallFoods = await Database().getDiningCourtMeal(
            hall,
            DateTime.now(),
            mealTime,
          );

          if (diningHallFoods != null && diningHallFoods.isNotEmpty) {
            List<FoodItem> diningHallFoodItems = [];
            for (Food food in diningHallFoods) {
              diningHallFoodItems.add(
                FoodItem(
                  name: food.name,
                  food: food,
                  station: food.station,
                  collection: food.collection,
                  diningHall: hall,
                  mealTime: mealTime,
                ),
              );
            }
            mealTimeFood[mealTime] ??= [];
            mealTimeFood[mealTime]!.addAll(diningHallFoodItems);
          }
        }
      }

      if (!mounted) return;

      // Handle initial meal time selection

      // Update state with processed data
      setState(() {
        _allMealData = mealTimeFood;
        _availableMealTimes = mealTimeFood.keys.toList();
        _availableMealTimes.sort((a, b) => a.index.compareTo(b.index));
        if (_availableMealTimes.isNotEmpty) {
          _selectedMealTime = _availableMealTimes[0];
        }
        _isLoading = false;

        // Set default selections
      });

      print(
        "Menu loading completed with ${_availableMealTimes.length} meal times",
      );
    } catch (e) {
      print('Error loading dining hall menu: $e');
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  void searchFoods(String query) {
    setState(() {
      filteredFoods = _allMealData[_selectedMealTime]!
          .where(
            (foodItem) =>
                foodItem.name.toLowerCase().similarityTo(query.toLowerCase()) >=
                0.3,
          )
          .toList();
      //sort by similarity
      filteredFoods.sort((a, b) {
        double simA = a.name.toLowerCase().similarityTo(query.toLowerCase());
        double simB = b.name.toLowerCase().similarityTo(query.toLowerCase());
        return simB.compareTo(simA);
      });
    });
  }

  void updateFilteredFoods() {
    if (_selectedMealTime != null) {
      setState(() {
        filteredFoods = _allMealData[_selectedMealTime]!
            .where(
              (foodItem) =>
                  foodItem.name.toLowerCase().similarityTo(
                        searchController.text.toLowerCase(),
                      ) >=
                      0.3 &&
                  foodItem.mealTime == _selectedMealTime!,
            )
            .toList();
        //sort by similarity
        filteredFoods.sort((a, b) {
          double simA = a.name.toLowerCase().similarityTo(
            searchController.text.toLowerCase(),
          );
          double simB = b.name.toLowerCase().similarityTo(
            searchController.text.toLowerCase(),
          );
          return simB.compareTo(simA);
        });
      });
    }
  }

  // Improved scroll position calculation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
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
                  padding: const EdgeInsets.only(
                    left: 24.0,
                    bottom: 18,
                    right: 24,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width - 120,
                            ),
                            child: Text(
                              "Search for Foods" +
                                  (widget.diningHall != null
                                      ? " at ${widget.diningHall}"
                                      : ""),
                              style: TextStyle(
                                fontSize: 24,
                                color: DynamicStyling.getBlack(context),
                              ),
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
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  _isLoading
                      ? _buildLoadingView()
                      : _availableMealTimes.isEmpty
                      ? _buildEmptyView()
                      : Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Meal time selector
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DefaultTextField(
                                  controller: searchController,
                                  hint: 'Search foods...',
                                  onChanged: (value) {
                                    searchFoods(value);
                                  },
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildMealTimeSelector(),

                              const SizedBox(height: 8),
                              // Station selector

                              // Foods list: expand to take remaining space and scroll within bounds
                              Expanded(child: _buildFoodsList()),
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
            valueColor: AlwaysStoppedAnimation<Color>(
              DynamicStyling.getBlack(context),
            ),
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
              'No menu available',
              style: TextStyle(
                color: DynamicStyling.getWhite(context).withOpacity(0.6),
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
                color: DynamicStyling.getWhite(context).withOpacity(0.4),
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
            updateFilteredFoods();
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

  Widget _buildFoodsList() {
    if (filteredFoods.isEmpty && searchController.text.isNotEmpty)
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'No foods found matching your search.',
          style: TextStyle(
            color: DynamicStyling.getBlack(context),
            fontSize: 16,
            fontFamily: '.SF Pro Text',
            decoration: TextDecoration.none,
          ),
        ),
      );

    if (searchController.text.isEmpty)
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Start typing to search for foods.',
          style: TextStyle(
            color: DynamicStyling.getBlack(context),
            fontSize: 16,
            fontFamily: '.SF Pro Text',
            decoration: TextDecoration.none,
          ),
        ),
      );

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: filteredFoods.length,
      itemBuilder: (context, foodIndex) {
        return _buildFoodItem(filteredFoods[foodIndex], foodIndex);
      },
    );
  }

  Widget _buildFoodItem(FoodItem foodItem, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          // if (foodItem.isCollection) {
          //   _showCollectionDetails(foodItem);
          // } else {
          _showFoodDetails(foodItem);
          // }
        },
        child: DefaultContainer(
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
                                foodItem.name,
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

                        Text(
                          foodItem.station +
                              (widget.diningHall == null
                                  ? " at ${foodItem.diningHall}"
                                  : ""),
                          style: TextStyle(
                            fontSize: 14,

                            color: DynamicStyling.getDarkGrey(context),
                            fontFamily: '.SF Pro Text',
                            decoration: TextDecoration.none,
                          ),
                        ),

                        if (foodItem.food.restricted) ...[
                          SizedBox(height: 4),
                          _buildNutritionChip(
                            "Restriction: ${foodItem.food.rejectedReason.capitalize()}",
                            Colors.red,
                          ),
                        ],
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
              if (foodItem.food.calories > 0)
                Text(
                  foodItem.food.calories.round().toString() + " cal",
                  style: TextStyle(
                    fontSize: 12,
                    color: DynamicStyling.getDarkGrey(context),
                    fontFamily: '.SF Pro Text',
                    decoration: TextDecoration.none,
                  ),
                ),

              // Labels/allergens
              if (foodItem.food.labels.isNotEmpty) ...[
                SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: foodItem.food.labels
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

  Widget _buildNutritionChip(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color.withOpacity(0.2),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: DynamicStyling.getBlack(context),
          fontSize: 11,
          fontWeight: FontWeight.w500,
          fontFamily: '.SF Pro Text',
          decoration: TextDecoration.none,
        ),
      ),
    );
  }

  void _showFoodDetails(FoodItem food) {
    // Create a single-item meal for the food details screen

    customCupertinoSheet.showCupertinoSheet<void>(
      context: context,
      useNestedNavigation: true,
      pageBuilder: (BuildContext context) =>
          ItemDetailsScreen(food: food.food, diningHall: food.diningHall),
    );
  }
}

// Static function to process menu data in isolate
// _MenuProcessingResult _processMenuData(_MenuProcessingData data) {
//   Map<MealTime, Map<String, List<FoodItem>>> mealTimeData = {};
//   List<MealTime> availableTimes = [];

//   for (var entry in data.mealTimeFood.entries) {
//     MealTime mealTime = entry.key;
//     List<Food> diningHallFoods = entry.value;

//     List<List<Food>> temp = data.dietaryRestrictions.filterFoodList(
//       diningHallFoods,
//     );
//     List<Food> filteredFoods = temp[0];
//     List<Food> restrictedFoods = temp[1];
//     List<Food> allFoods = [...filteredFoods, ...restrictedFoods];

//     if (allFoods.isNotEmpty) {
//       Map<String, List<FoodItem>> stationGroups = {};

//       Map<String, List<Food>> stationRawFoods = {};
//       for (Food food in allFoods) {
//         String station = food.station.isNotEmpty ? food.station : 'Other';
//         if (!stationRawFoods.containsKey(station)) {
//           stationRawFoods[station] = [];
//         }
//         stationRawFoods[station]!.add(food);
//       }

//       for (var stationEntry in stationRawFoods.entries) {
//         String station = stationEntry.key;
//         List<Food> foods = stationEntry.value;
//         List<FoodItem> foodItems = [];

//         Map<String?, List<Food>> collectionGroups = {};
//         for (Food food in foods) {
//           if (!collectionGroups.containsKey(food.collection)) {
//             collectionGroups[food.collection] = [];
//           }
//           collectionGroups[food.collection]!.add(food);
//         }

//         for (var collectionEntry in collectionGroups.entries) {
//           String? collection = collectionEntry.key;
//           List<Food> collectionFoods = collectionEntry.value;

//           if (collection != null && collectionFoods.length > 1) {
//             collectionFoods.sort((a, b) => a.name.compareTo(b.name));
//             foodItems.add(
//               FoodItem(
//                 name: collection,
//                 isCollection: true,
//                 foods: collectionFoods,
//                 station: station,
//                 collection: collection,
//               ),
//             );
//           } else {
//             for (Food food in collectionFoods) {
//               foodItems.add(
//                 FoodItem(
//                   name: food.name,
//                   isCollection: false,
//                   foods: [food],
//                   station: station,
//                   collection: food.collection,
//                   diningHall: food.diningHall,
//                 ),
//               );
//             }
//           }
//         }

//         foodItems.sort((a, b) => a.name.compareTo(b.name));
//         stationGroups[station] = foodItems;
//       }

//       if (stationGroups.isNotEmpty) {
//         mealTimeData[mealTime] = stationGroups;
//         availableTimes.add(mealTime);
//       }
//     }
//   }

//   return _MenuProcessingResult(
//     mealTimeData: mealTimeData,
//     availableTimes: availableTimes,
//   );
// }
