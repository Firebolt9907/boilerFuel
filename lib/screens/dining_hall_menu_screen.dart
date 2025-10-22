import 'package:boiler_fuel/screens/dining_hall_search_screen.dart';
import 'package:boiler_fuel/styling.dart';
import 'package:boiler_fuel/api/database.dart';
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

class DiningHallMenuScreen extends StatefulWidget {
  final String diningHall;
  final User user;
  final MealTime? initialMealTime;

  const DiningHallMenuScreen({
    Key? key,
    required this.diningHall,
    required this.user,
    this.initialMealTime,
  }) : super(key: key);

  @override
  _DiningHallMenuScreenState createState() => _DiningHallMenuScreenState();
}

class _DiningHallMenuScreenState extends State<DiningHallMenuScreen>
    with TickerProviderStateMixin {
  Map<String, List<FoodItem>> _stationFoods = {};
  bool _isLoading = true;

  // Spacing between station items
  double _stationSpacing = 12.0;

  // New variables for meal time selection
  Map<MealTime, Map<String, List<FoodItem>>> _allMealData = {};
  List<MealTime> _availableMealTimes = [];
  MealTime? _selectedMealTime;

  bool tappedSection = false;

  DiningHall? diningHallInfo;

  // Scroll animation variables
  late ScrollController _scrollController;
  double _scrollCollapseThreshold = 50.0; // Pixels scrolled to fully collapse
  double _currentScrollProgress =
      0.0; // 0.0 = fully expanded, 1.0 = fully collapsed
  double _lastScrollPosition = 0.0;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    _loadDiningHallMenu();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    double scrollPixels = _scrollController.position.pixels;

    // Don't process animation if we're at the very top (scrollPixels <= 0)
    // This prevents bounce-back animations
    if (scrollPixels <= 0) {
      if (_currentScrollProgress != 0.0) {
        setState(() {
          _currentScrollProgress = 0.0;
        });
      }
      _lastScrollPosition = 0.0;
      return;
    }

    bool scrollingDown = scrollPixels > _lastScrollPosition;

    if (scrollingDown) {
      // If scrolling down, calculate progress based on scroll distance
      double scrollDistance = scrollPixels - _lastScrollPosition;
      double newProgress =
          (_currentScrollProgress + (scrollDistance / _scrollCollapseThreshold))
              .clamp(0.0, 1.0);

      if (newProgress != _currentScrollProgress) {
        setState(() {
          _currentScrollProgress = newProgress;
        });
      }
    } else {
      // If user scrolls up, animate the schedule back in proportionally
      double scrollDistance = _lastScrollPosition - scrollPixels;
      double newProgress =
          (_currentScrollProgress - (scrollDistance / _scrollCollapseThreshold))
              .clamp(0.0, 1.0);

      if (newProgress != _currentScrollProgress) {
        setState(() {
          _currentScrollProgress = newProgress;
        });
      }
    }

    _lastScrollPosition = scrollPixels;
  }

  int menuCallCount = 0;

  Future<void> _loadDiningHallMenu() async {
    try {
      setState(() {
        _isLoading = true;
      });

      DiningHall? hall = await Database().getDiningHallByName(
        widget.diningHall,
      );
      diningHallInfo = hall;
      List<MealTime> availableTimes = [];
      for (MealTime mealTime in MealTime.values) {
        Schedule diningHallSchedule = diningHallInfo!.schedule;
        if (diningHallSchedule.isMealTimeAvailable(mealTime)) {
          availableTimes.add(mealTime);
        }
      }
      setState(() {
        _availableMealTimes = availableTimes;
      });

      // Get list of meal times to process
      List<MealTime> mealTimesToProcess = MealTime.values
          .where(
            (mealTime) =>
                !(mealTime == MealTime.brunch &&
                    widget.diningHall != "Hillenbrand"),
          )
          .toList();

      // Fetch data from database (must be done on main thread)
      Map<MealTime, List<Food>> mealTimeFood = {};

      for (MealTime mealTime in mealTimesToProcess) {
        menuCallCount++;
        print("calling Database().getDiningCourtMeal; call #$menuCallCount");

        List<Food>? diningHallFoods = await Database().getDiningCourtMeal(
          widget.diningHall,
          DateTime.now(),
          mealTime,
        );

        if (diningHallFoods != null && diningHallFoods.isNotEmpty) {
          mealTimeFood[mealTime] = diningHallFoods;
        }

        print(
          "Fetched ${diningHallFoods?.length ?? 0} foods for #$menuCallCount",
        );
      }

      if (mealTimeFood.isNotEmpty) {
        // Move heavy processing to isolate
        _MenuProcessingData processingData = _MenuProcessingData(
          mealTimeFood: mealTimeFood,
          dietaryRestrictions: widget.user.dietaryRestrictions,
          diningHall: widget.diningHall,
        );

        // Process data in isolate to prevent UI freezing
        _MenuProcessingResult result = await compute(
          _processMenuData,
          processingData,
        );

        if (!mounted) return;

        // Handle initial meal time selection
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (widget.initialMealTime != null) {
            int initialIndex = result.availableTimes.indexOf(
              widget.initialMealTime!,
            );

            if (initialIndex >= 0 &&
                initialIndex < result.availableTimes.length) {
              _updateStationFoods();
            } else {
              _updateStationFoods();
              setState(() {
                _selectedMealTime = result.availableTimes.first;
              });
            }
          }
        });

        // Update state with processed data
        setState(() {
          _selectedMealTime =
              widget.initialMealTime != null &&
                  result.availableTimes.contains(widget.initialMealTime)
              ? widget.initialMealTime
              : result.availableTimes.first;

          _allMealData = result.mealTimeData;

          _isLoading = false;

          // Set default selections
        });

        // Update station foods after setState
        if (_availableMealTimes.isNotEmpty) {
          _updateStationFoods();
        }

        print(
          "Menu loading completed with ${_availableMealTimes.length} meal times",
        );
      } else {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading dining hall menu: $e');
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateStationFoods() {
    if (_selectedMealTime != null &&
        _allMealData.containsKey(_selectedMealTime)) {
      _stationFoods = _allMealData[_selectedMealTime]!;
    } else {
      _stationFoods = {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // Header
          Header(
            context: context,
            title: widget.diningHall,
            trailingIcon: Icons.search,
            trailingPage: DiningHallSearchScreen(
              diningHall: widget.diningHall,
              user: widget.user,
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
                              // Animated schedule with vertical shrink based on scroll
                              AnimatedBuilder(
                                animation: _scrollController,
                                builder: (context, child) {
                                  final heightFactor =
                                      1.0 - _currentScrollProgress;
                                  return ClipRect(
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      heightFactor: heightFactor,
                                      child: Opacity(
                                        opacity: heightFactor,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            _buildScheduleDiningHall(),
                                            SizedBox(height: 8 * heightFactor),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              _buildMealTimeSelector(),

                              const SizedBox(height: 8),
                              // Station selector

                              // PageView for stations - give it a bounded max height
                              Expanded(child: _buildStationPageView()),
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

  Widget _buildScheduleDiningHall() {
    if (diningHallInfo == null) return SizedBox.shrink();

    Schedule schedule = diningHallInfo!.schedule;

    return DefaultContainer(
      child: SizedBox(
        width: double.infinity,
        child: Wrap(
          alignment: WrapAlignment.spaceAround,
          spacing: 10,
          runSpacing: 4,

          children: [
            for (MealTime mealTime in _availableMealTimes)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text(
                  '${mealTime.toDisplayString()}\n${schedule.getMealTimeHours(mealTime, context)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: DynamicStyling.getDarkGrey(context),
                    fontWeight:
                        diningHallInfo!.schedule.getCurrentMealTime() ==
                            mealTime
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealTimeSelector() {
    if (_availableMealTimes.isEmpty) return SizedBox.shrink();

    return Container(
      // height: 84,
      child: CustomTabs(
        expand: true,
        initialValue: _selectedMealTime.toString(),
        onValueChanged: (value) {
          print("Meal time changed to $value");
          setState(() {
            _selectedMealTime = MealTime.fromString(value);
            _updateStationFoods();
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

  Widget _buildStationSelector() {
    List<String> stationNames = _stationFoods.keys.toList();
    if (stationNames.isEmpty) return SizedBox.shrink();
    return Container(
      height: 44,

      decoration: BoxDecoration(
        color: DynamicStyling.getLightGrey(context),
        borderRadius: BorderRadius.circular(20),
      ),

      child: CustomTabs(
        initialValue: _selectedMealTime.toString(),
        onValueChanged: (value) {
          setState(() {
            _selectedMealTime = MealTime.fromString(value);
          });
        },
        tabs: [
          for (String station in stationNames)
            TabItem(label: station, value: station),
        ],
      ),
    );
  }

  Widget _buildStationPageView() {
    if (_stationFoods.isEmpty) return SizedBox.shrink();

    List<String> stationNames = _stationFoods.keys.toList();

    // Build a flat list of all items (stations and foods)
    List<dynamic> flatItems = [];
    for (String stationName in stationNames) {
      flatItems.add(stationName); // Station header
      for (FoodItem food in _stationFoods[stationName]!) {
        flatItems.add(food); // Food item
      }
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(0),

      itemCount: flatItems.length,
      itemBuilder: (context, index) {
        final item = flatItems[index];

        // If item is a String, it's a station header
        if (item is String) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item,
              style: TextStyle(
                fontSize: 20,
                color: DynamicStyling.getBlack(context),
              ),
              textAlign: TextAlign.left,
            ),
          );
        }

        // Otherwise it's a FoodItem
        return _buildFoodItem(item as FoodItem, index);
      },
    );
  }

  Widget _buildFoodItem(FoodItem foodItem, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          if (foodItem.isCollection) {
            _showCollectionDetails(foodItem);
          } else {
            _showFoodDetails(foodItem.firstFood);
          }
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

                        if (!foodItem.isCollection &&
                            foodItem.firstFood.restricted) ...[
                          SizedBox(height: 4),
                          _buildNutritionChip(
                            "Restriction: ${foodItem.firstFood.rejectedReason.capitalize()}",
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
              if (!foodItem.isCollection) ...[
                if (foodItem.firstFood.calories > 0)
                  Text(
                    foodItem.firstFood.calories.round().toString() + " cal",
                    style: TextStyle(
                      fontSize: 14,
                      color: DynamicStyling.getDarkGrey(context),
                      fontFamily: '.SF Pro Text',
                      decoration: TextDecoration.none,
                    ),
                  ),

                // Labels/allergens
                if (foodItem.firstFood.labels.isNotEmpty) ...[
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: foodItem.firstFood.labels
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
              ] else ...[
                // For collections, show aggregated info
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Tap to view all items in this collection',
                        style: TextStyle(
                          fontSize: 12,
                          color: DynamicStyling.getDarkGrey(context),
                          fontFamily: '.SF Pro Text',
                          decoration: TextDecoration.none,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
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

  void _showFoodDetails(Food food) {
    // Create a single-item meal for the food details screen
    Meal singleFoodMeal = Meal(
      name: food.name,
      foods: [food],
      calories: food.calories,
      protein: food.protein,
      carbs: food.carbs,
      fat: food.fat,
      diningHall: widget.diningHall,
      isAIGenerated: false,
      id: food.id,
    );

    customCupertinoSheet.showCupertinoSheet<void>(
      context: context,
      useNestedNavigation: true,
      pageBuilder: (BuildContext context) =>
          ItemDetailsScreen(food: food, diningHall: widget.diningHall),
    );
  }

  void _showCollectionDetails(FoodItem foodItem) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => CollectionScreen(
          collectionName: foodItem.name,
          foods: foodItem.foods,
          diningHall: widget.diningHall,
          station: foodItem.station,
        ),
      ),
    );
  }
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
_MenuProcessingResult _processMenuData(_MenuProcessingData data) {
  Map<MealTime, Map<String, List<FoodItem>>> mealTimeData = {};
  List<MealTime> availableTimes = [];

  for (var entry in data.mealTimeFood.entries) {
    MealTime mealTime = entry.key;
    List<Food> diningHallFoods = entry.value;

    List<List<Food>> temp = data.dietaryRestrictions.filterFoodList(
      diningHallFoods,
    );
    List<Food> filteredFoods = temp[0];
    List<Food> restrictedFoods = temp[1];
    List<Food> allFoods = [...filteredFoods, ...restrictedFoods];

    if (allFoods.isNotEmpty) {
      Map<String, List<FoodItem>> stationGroups = {};

      Map<String, List<Food>> stationRawFoods = {};
      for (Food food in allFoods) {
        String station = food.station.isNotEmpty ? food.station : 'Other';
        if (!stationRawFoods.containsKey(station)) {
          stationRawFoods[station] = [];
        }
        stationRawFoods[station]!.add(food);
      }

      for (var stationEntry in stationRawFoods.entries) {
        String station = stationEntry.key;
        List<Food> foods = stationEntry.value;
        List<FoodItem> foodItems = [];

        Map<String?, List<Food>> collectionGroups = {};
        for (Food food in foods) {
          if (!collectionGroups.containsKey(food.collection)) {
            collectionGroups[food.collection] = [];
          }
          collectionGroups[food.collection]!.add(food);
        }

        for (var collectionEntry in collectionGroups.entries) {
          String? collection = collectionEntry.key;
          List<Food> collectionFoods = collectionEntry.value;

          if (collection != null && collectionFoods.length > 1) {
            collectionFoods.sort((a, b) => a.name.compareTo(b.name));
            foodItems.add(
              FoodItem(
                name: collection,
                isCollection: true,
                foods: collectionFoods,
                station: station,
                collection: collection,
              ),
            );
          } else {
            for (Food food in collectionFoods) {
              foodItems.add(
                FoodItem(
                  name: food.name,
                  isCollection: false,
                  foods: [food],
                  station: station,
                  collection: food.collection,
                ),
              );
            }
          }
        }

        foodItems.sort((a, b) => a.name.compareTo(b.name));
        stationGroups[station] = foodItems;
      }

      if (stationGroups.isNotEmpty) {
        mealTimeData[mealTime] = stationGroups;
        availableTimes.add(mealTime);
      }
    }
  }

  return _MenuProcessingResult(
    mealTimeData: mealTimeData,
    availableTimes: availableTimes,
  );
}
