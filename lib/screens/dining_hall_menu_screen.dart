import 'package:boiler_fuel/api/local_database.dart';
import 'package:boiler_fuel/screens/dining_hall_search_screen.dart';
import 'package:boiler_fuel/styling.dart';
import 'package:boiler_fuel/api/database.dart';
import 'package:boiler_fuel/main.dart';
import 'package:boiler_fuel/screens/item_details_screen.dart';
import 'package:boiler_fuel/widgets/custom_app_bar.dart';
import 'package:boiler_fuel/widgets/custom_tabs.dart';
import 'package:boiler_fuel/widgets/default_container.dart';
import 'package:boiler_fuel/widgets/default_text_field.dart';
import 'package:boiler_fuel/widgets/header.dart';
import 'package:flutter/cupertino.dart';
import '../custom/cupertinoSheet.dart' as customCupertinoSheet;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';
import 'meal_details_screen.dart';
import 'collection_screen.dart';
import 'package:stupid_simple_sheet/stupid_simple_sheet.dart';

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
  bool isCreatingMeal = false;

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
  double _scrollCollapseThreshold = 80.0; // Pixels scrolled to fully collapse
  double _currentScrollProgress =
      0.0; // 0.0 = fully expanded, 1.0 = fully collapsed
  double _lastScrollPosition = 0.0;

  double mealCalories = 0.0;
  double mealProtein = 0.0;
  double mealCarbs = 0.0;
  double mealFat = 0.0;
  double mealSugar = 0.0;
  double mealSaturatedFat = 0.0;
  double mealAddedSugars = 0.0;

  double targetCalories = 0.0;
  double targetProtein = 0.0;
  double targetCarbs = 0.0;
  double targetFat = 0.0;

  List<FoodItem> selectedFoods = [];

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    setState(() {
      targetCalories = widget.user.macros.calories / widget.user.mealsPerDay;
      targetProtein = widget.user.macros.protein / widget.user.mealsPerDay;
      targetCarbs = widget.user.macros.carbs / widget.user.mealsPerDay;
      targetFat = widget.user.macros.fat / widget.user.mealsPerDay;
    });

    _loadDiningHallMenu(false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // TODO: Replace setState with ValueNotifier to improve performance
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

  Future<void> _loadDiningHallMenu(bool? silent) async {
    if (silent != true) {
      setState(() {
        _isLoading = true;
      });
    }
    DiningHall? hall = await Database().getDiningHallByName(widget.diningHall);
    diningHallInfo = hall;
    List<MealTime> availableTimes = [];
    for (MealTime mealTime in MealTime.values) {
      Schedule diningHallSchedule = diningHallInfo!.schedule;
      if (diningHallSchedule.isMealTimeAvailable(mealTime)) {
        availableTimes.add(mealTime);
      }
    }
    _availableMealTimes = availableTimes;
    if (silent != true) {
      setState(() {});
    }

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

            _selectedMealTime = result.availableTimes.first;

            if (silent != true) {
              setState(() {});
            }
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
      backgroundColor: DynamicStyling.getWhite(context),
      floatingActionButton: widget.user.useMealPlanning
          ? Container(
              decoration: BoxDecoration(
                color: DynamicStyling.getBlack(context),
                borderRadius: BorderRadius.circular(15),
              ),
              width: 50,
              height: 50,
              child: IconButton(
                splashColor: DynamicStyling.getDarkGrey(context),
                icon: Stack(
                  children: [
                    Icon(
                      isCreatingMeal
                          ? selectedFoods.isEmpty
                                ? Icons.close
                                : Icons.save
                          : Icons.add,
                      color: DynamicStyling.getWhite(context),
                      // size: 32,
                    ),
                  ],
                ),
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  if (isCreatingMeal) {
                    if (selectedFoods.isEmpty) {
                      setState(() {
                        isCreatingMeal = false;
                      });
                      return;
                    }
                    showDialog<bool>(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        TextEditingController controller =
                            TextEditingController();
                        bool loading = false;
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              backgroundColor: DynamicStyling.getWhite(context),
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Icon

                                    // Title
                                    Text(
                                      'Meal Name',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: DynamicStyling.getBlack(context),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 12),

                                    // Description
                                    DefaultTextField(
                                      controller: controller,
                                      hint: "Meal Name",
                                    ),
                                    const SizedBox(height: 28),

                                    // Buttons
                                    Row(
                                      children: [
                                        // Cancel Button
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: DynamicStyling.getGrey(
                                                  context,
                                                ),
                                                width: 1,
                                              ),
                                            ),
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                onTap: () {
                                                  HapticFeedback.lightImpact();
                                                  Navigator.of(context).pop();
                                                },
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 12.0,
                                                      ),
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          DynamicStyling.getBlack(
                                                            context,
                                                          ),
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),

                                        // Save Button
                                        loading
                                            ? CircularProgressIndicator(
                                                color: Colors.green,
                                              )
                                            : Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                    color: Colors.green,
                                                  ),
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      onTap: () async {
                                                        HapticFeedback.mediumImpact();
                                                        if (controller
                                                            .text
                                                            .isEmpty) {
                                                          // Show error
                                                          ScaffoldMessenger.of(
                                                            context,
                                                          ).showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                'Please enter a meal name.',
                                                              ),
                                                            ),
                                                          );
                                                          return;
                                                        }
                                                        setState(() {
                                                          loading = true;
                                                        });
                                                        final id = UniqueKey()
                                                            .toString();
                                                        Meal meal = Meal(
                                                          name: controller.text,
                                                          foods: selectedFoods
                                                              .map(
                                                                (e) =>
                                                                    e.firstFood,
                                                              )
                                                              .toList(),

                                                          mealTime:
                                                              _selectedMealTime!,
                                                          calories:
                                                              mealCalories,
                                                          protein: mealProtein,
                                                          carbs: mealCarbs,
                                                          fat: mealFat,
                                                          sugar: mealSugar,
                                                          addedSugars:
                                                              mealAddedSugars,
                                                          saturatedFat:
                                                              mealSaturatedFat,
                                                          diningHall:
                                                              widget.diningHall,
                                                          isAIGenerated: false,
                                                          isFavorited: true,
                                                          id: id,
                                                        );
                                                        await LocalDatabase()
                                                            .addMeal(
                                                              meal,
                                                              _selectedMealTime!,
                                                              DateTime.now(),
                                                            );
                                                        if (!mounted) return;
                                                        setState(() {
                                                          loading = false;
                                                        });
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          SnackBar(
                                                            backgroundColor:
                                                                Colors.green,
                                                            content: Text(
                                                              'Meal saved successfully! View it in Saved Meals.',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                        Navigator.of(
                                                          context,
                                                        ).pop();
                                                        this.setState(() {
                                                          isCreatingMeal =
                                                              false;
                                                          selectedFoods.clear();
                                                          mealCalories = 0.0;
                                                          mealProtein = 0.0;
                                                          mealCarbs = 0.0;
                                                          mealFat = 0.0;
                                                          mealAddedSugars = 0.0;
                                                          mealSaturatedFat =
                                                              0.0;
                                                          mealSugar = 0.0;
                                                        });
                                                      },
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              vertical: 12.0,
                                                            ),
                                                        child: Text(
                                                          'Save Meal',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.white,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else {
                    selectedFoods.clear();
                    mealCalories = 0.0;
                    mealProtein = 0.0;
                    mealCarbs = 0.0;
                    mealFat = 0.0;
                    mealAddedSugars = 0.0;
                    mealSaturatedFat = 0.0;
                    mealSugar = 0.0;
                    setState(() {
                      isCreatingMeal = true;
                    });
                  }
                },
              ),
            )
          : null,
      body: Column(
        children: [
          // Header
          Header(
            context: context,
            title: widget.diningHall,
            trailingIcon: !isCreatingMeal ? Icons.search : null,
            trailingPage: !isCreatingMeal
                ? DiningHallSearchScreen(
                    diningHall: widget.diningHall,
                    user: widget.user,
                  )
                : null,
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
                                      heightFactor: isCreatingMeal
                                          ? 1
                                          : heightFactor,
                                      child: Opacity(
                                        opacity: isCreatingMeal
                                            ? 1
                                            : heightFactor,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (isCreatingMeal)
                                              _buildMealNutrition()
                                            else
                                              _buildScheduleDiningHall(),
                                            SizedBox(
                                              height:
                                                  8 *
                                                  (isCreatingMeal
                                                      ? 1
                                                      : heightFactor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              if (isCreatingMeal)
                                Text(
                                  "Select foods to add to your meal for ${_selectedMealTime?.toDisplayString()}",
                                )
                              else
                                _buildMealTimeSelector(),

                              const SizedBox(height: 8),
                              // Station selector
                              if (_allMealData.isEmpty)
                                SizedBox()
                              else
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

  Widget _buildMealNutrition() {
    return DefaultContainer(
      child: SizedBox(
        width: double.infinity,
        child: Wrap(
          alignment: WrapAlignment.spaceAround,
          spacing: 10,
          runSpacing: 4,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Text(
                'Calories: ${mealCalories.toStringAsFixed(0)} / ${targetCalories.toStringAsFixed(0)} cal',
                style: TextStyle(
                  fontSize: 14,
                  color: DynamicStyling.getDarkGrey(context),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Text(
                'Protein: ${mealProtein.toStringAsFixed(0)} / ${targetProtein.toStringAsFixed(0)} g',
                style: TextStyle(
                  fontSize: 14,
                  color: DynamicStyling.getDarkGrey(context),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Text(
                'Carbs: ${mealCarbs.toStringAsFixed(0)} / ${targetCarbs.toStringAsFixed(0)} g',
                style: TextStyle(
                  fontSize: 14,
                  color: DynamicStyling.getDarkGrey(context),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Text(
                'Fat: ${mealFat.toStringAsFixed(0)} / ${targetFat.toStringAsFixed(0)} g',
                style: TextStyle(
                  fontSize: 14,
                  color: DynamicStyling.getDarkGrey(context),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
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
              color: DynamicStyling.getBlack(context).withOpacity(0.4),
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              'No menu available',
              style: TextStyle(
                color: DynamicStyling.getBlack(context).withOpacity(0.6),
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: '.SF Pro Display',
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Check back later for tomorrow\'s menu',
              style: TextStyle(
                color: DynamicStyling.getBlack(context).withOpacity(0.4),
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
      padding: const EdgeInsets.only(bottom: 240.0),
      physics: ScrollPhysics(),

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

  String _buildFoodSubtitle(FoodItem foodItem) {
    String subtitle = "";
    if (foodItem.firstFood.calories > 0) {
      String calString = foodItem.firstFood.calories < 1
          ? foodItem.firstFood.calories.toStringAsFixed(2)
          : foodItem.firstFood.calories.round().toString();
      subtitle += "${calString} cal";
    }
    if (isCreatingMeal) {
      if (subtitle.isNotEmpty) subtitle += " • ";
      if (foodItem.firstFood.protein > 0) {
        String proteinString = foodItem.firstFood.protein < 1
            ? foodItem.firstFood.protein.toStringAsFixed(2)
            : foodItem.firstFood.protein.round().toString();
        subtitle += "${proteinString}g of protein";
      }

      if (foodItem.firstFood.carbs > 0) {
        if (subtitle.isNotEmpty) subtitle += " • ";
        String carbsString = foodItem.firstFood.carbs < 1
            ? foodItem.firstFood.carbs.toStringAsFixed(2)
            : foodItem.firstFood.carbs.round().toString();
        subtitle += "${carbsString}g of carbs";
      }

      if (foodItem.firstFood.fat > 0) {
        if (subtitle.isNotEmpty) subtitle += " • ";
        String fatString = foodItem.firstFood.fat < 1
            ? foodItem.firstFood.fat.toStringAsFixed(2)
            : foodItem.firstFood.fat.round().toString();
        subtitle += "${fatString}g of fat";
      }
    }
    return subtitle;
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
            if (isCreatingMeal) {
              setState(() {
                if (selectedFoods.contains(foodItem)) {
                  selectedFoods.remove(foodItem);
                  mealCalories -= foodItem.firstFood.calories > 0
                      ? foodItem.firstFood.calories
                      : 0;
                  mealProtein -= foodItem.firstFood.protein > 0
                      ? foodItem.firstFood.protein
                      : 0;
                  mealCarbs -= foodItem.firstFood.carbs > 0
                      ? foodItem.firstFood.carbs
                      : 0;
                  mealFat -= foodItem.firstFood.fat > 0
                      ? foodItem.firstFood.fat
                      : 0;
                  mealAddedSugars -= foodItem.firstFood.addedSugars > 0
                      ? foodItem.firstFood.addedSugars
                      : 0;
                  mealSaturatedFat -= foodItem.firstFood.saturatedFat > 0
                      ? foodItem.firstFood.saturatedFat
                      : 0;
                  mealSugar -= foodItem.firstFood.sugar > 0
                      ? foodItem.firstFood.sugar
                      : 0;
                  return;
                }
                selectedFoods.add(foodItem);
                mealCalories += foodItem.firstFood.calories > 0
                    ? foodItem.firstFood.calories
                    : 0;
                mealProtein += foodItem.firstFood.protein > 0
                    ? foodItem.firstFood.protein
                    : 0;
                mealCarbs += foodItem.firstFood.carbs > 0
                    ? foodItem.firstFood.carbs
                    : 0;
                mealFat += foodItem.firstFood.fat > 0
                    ? foodItem.firstFood.fat
                    : 0;
                mealAddedSugars += foodItem.firstFood.addedSugars > 0
                    ? foodItem.firstFood.addedSugars
                    : 0;
                mealSaturatedFat += foodItem.firstFood.saturatedFat > 0
                    ? foodItem.firstFood.saturatedFat
                    : 0;
                mealSugar += foodItem.firstFood.sugar > 0
                    ? foodItem.firstFood.sugar
                    : 0;
              });
            } else {
              _showFoodDetails(foodItem.firstFood);
            }
          }
        },
        child: DefaultContainer(
          primaryColor: !foodItem.isCollection
              ? isCreatingMeal && selectedFoods.contains(foodItem)
                    ? Colors.green
                    : foodItem.firstFood.isFavorited
                    ? Colors.yellow
                    : foodItem.firstFood.restricted
                    ? Colors.red
                    : null
              : null,
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
                                  color:
                                      isCreatingMeal &&
                                          selectedFoods.contains(foodItem)
                                      ? Colors.green
                                      : foodItem.firstFood.isFavorited
                                      ? Colors.yellow
                                      : foodItem.firstFood.restricted
                                      ? Colors.red
                                      : DynamicStyling.getBlack(context),
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
                    color: DynamicStyling.getGrey(context),
                    size: 20,
                  ),
                ],
              ),

              // Nutrition info (show only for individual items)
              if (!foodItem.isCollection) ...[
                if (_buildFoodSubtitle(foodItem).isNotEmpty)
                  Text(
                    _buildFoodSubtitle(foodItem),
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          (isCreatingMeal && selectedFoods.contains(foodItem)
                                  ? Colors.green
                                  : foodItem.firstFood.isFavorited
                                  ? Colors.yellow
                                  : foodItem.firstFood.restricted
                                  ? Colors.red
                                  : DynamicStyling.getDarkGrey(context))
                              .withAlpha(140),
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
          color: color, // DynamicStyling.getBlack(context),
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

    // customCupertinoSheet
    //     .showCupertinoSheet<void>(
    //       context: context,
    //       pageBuilder: (BuildContext context) =>
    //           ItemDetailsScreen(food: food, diningHall: widget.diningHall),
    //     )
    //     .then((e) {
    //       _loadDiningHallMenu(true);
    //     });
    Navigator.of(context)
        .push(
          StupidSimpleCupertinoSheetRoute(
            child: ItemDetailsScreen(food: food, diningHall: widget.diningHall),
          ),
        )
        .then((u) {
          _loadDiningHallMenu(true);
        });
  }

  void _showCollectionDetails(FoodItem foodItem) async {
    final result = await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => CollectionScreen(
          collectionName: foodItem.name,
          foods: foodItem.foods,
          diningHall: widget.diningHall,
          station: foodItem.station,
          isCreatingMeal: isCreatingMeal,
          selectedFoods: [...selectedFoods],
        ),
      ),
    );
    // print((result?[0]));
    if (isCreatingMeal && result != null) {
      mealProtein = 0.0;
      mealCarbs = 0.0;
      mealFat = 0.0;
      mealAddedSugars = 0.0;
      mealSaturatedFat = 0.0;
      mealSugar = 0.0;
      mealCalories = 0.0;
      setState(() {
        selectedFoods.clear();
        for (FoodItem item in result) {
          selectedFoods.add(item);
          mealCalories += item.firstFood.calories > 0
              ? item.firstFood.calories
              : 0;
          mealProtein += item.firstFood.protein > 0
              ? item.firstFood.protein
              : 0;
          mealCarbs += item.firstFood.carbs > 0 ? item.firstFood.carbs : 0;
          mealFat += item.firstFood.fat > 0 ? item.firstFood.fat : 0;
          mealAddedSugars += item.firstFood.addedSugars > 0
              ? item.firstFood.addedSugars
              : 0;
          mealSaturatedFat += item.firstFood.saturatedFat > 0
              ? item.firstFood.saturatedFat
              : 0;
          mealSugar += item.firstFood.sugar > 0 ? item.firstFood.sugar : 0;
        }
      });
    }
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
