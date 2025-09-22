import 'package:boiler_fuel/api/database.dart';
import 'package:boiler_fuel/widgets/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';
import '../api/local_database.dart';
import 'meal_details_screen.dart';
import 'dart:math' as math;

class DiningHallMenuScreen extends StatefulWidget {
  final String diningHall;
  final User user;

  const DiningHallMenuScreen({
    Key? key,
    required this.diningHall,
    required this.user,
  }) : super(key: key);

  @override
  _DiningHallMenuScreenState createState() => _DiningHallMenuScreenState();
}

class _DiningHallMenuScreenState extends State<DiningHallMenuScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _floatingController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _floatingAnimation;

  Map<String, List<Food>> _stationFoods = {};
  bool _isLoading = true;
  String _selectedStation = '';

  // New variables for meal time selection
  Map<MealTime, Map<String, List<Food>>> _allMealData = {};
  List<MealTime> _availableMealTimes = [];
  MealTime? _selectedMealTime;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _floatingController = AnimationController(
      duration: Duration(milliseconds: 3500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _floatingAnimation = Tween<double>(begin: -12.0, end: 12.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    Future.delayed(Duration(milliseconds: 400), () {
      if (mounted) {
        _floatingController.repeat(reverse: true);
      }
    });

    _loadDiningHallMenu();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  Future<void> _loadDiningHallMenu() async {
    try {
      // Get all meals from the database
      Map<MealTime, Map<String, Meal>>? allMeals = await LocalDatabase()
          .getDayMeals();

      if (allMeals != null) {
        Map<MealTime, Map<String, List<Food>>> mealTimeData = {};
        List<MealTime> availableTimes = [];

        // Process each meal time
        for (MealTime mealTime in MealTime.values) {
          List<Food> diningHallFoods =
              (await Database().getDiningCourtMeal(
                widget.diningHall,
                new DateTime.now(),
                mealTime,
              )) ??
              [];

          diningHallFoods = widget.user.dietaryRestrictions.filterFoodList(
            diningHallFoods,
          )[0];

          if (diningHallFoods.isNotEmpty) {
            // Group foods by station for this meal time
            Map<String, List<Food>> stationGroups = {};
            for (Food food in diningHallFoods) {
              String station = food.station.isNotEmpty ? food.station : 'Other';
              if (!stationGroups.containsKey(station)) {
                stationGroups[station] = [];
              }
              stationGroups[station]!.add(food);
            }

            // Sort foods within each station alphabetically
            stationGroups.forEach((station, foods) {
              foods.sort((a, b) => a.name.compareTo(b.name));
            });

            // Only add meal times that have food
            if (stationGroups.isNotEmpty) {
              mealTimeData[mealTime] = stationGroups;
              availableTimes.add(mealTime);
            }
          }
        }

        setState(() {
          _allMealData = mealTimeData;
          _availableMealTimes = availableTimes;
          _isLoading = false;

          // Set default selections
          if (_availableMealTimes.isNotEmpty) {
            _selectedMealTime = _availableMealTimes.first;
            _updateStationFoods();
          }
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading dining hall menu: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateStationFoods() {
    if (_selectedMealTime != null &&
        _allMealData.containsKey(_selectedMealTime)) {
      _stationFoods = _allMealData[_selectedMealTime]!;
      if (_stationFoods.isNotEmpty) {
        _selectedStation = _stationFoods.keys.first;
      }
    } else {
      _stationFoods = {};
      _selectedStation = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0D1B2A),
                Color(0xFF1B263B),
                Color(0xFF415A77),
                Color(0xFF778DA9),
                Color(0xFF415A77),
              ],
              stops: [0.0, 0.25, 0.5, 0.75, 1.0],
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: CustomAppBar(
              title: widget.diningHall,
              showBackButton: true,
              onBackButtonPressed: (context) {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0D1B2A),
                  Color(0xFF1B263B),
                  Color(0xFF415A77),
                  Color(0xFF778DA9),
                  Color(0xFF415A77),
                ],
                stops: [0.0, 0.25, 0.5, 0.75, 1.0],
              ),
            ),
            child: Stack(
              children: [
                // Floating decorative elements
                ...List.generate(
                  4,
                  (index) => Positioned(
                    left: (index * 95.0) % MediaQuery.of(context).size.width,
                    top: (index * 200.0) % MediaQuery.of(context).size.height,
                    child: AnimatedBuilder(
                      animation: _floatingAnimation,
                      builder: (context, child) => Transform.translate(
                        offset: Offset(
                          math.sin(_floatingAnimation.value / 10 + index) * 5,
                          _floatingAnimation.value +
                              math.cos(_floatingAnimation.value / 8 + index) *
                                  3,
                        ),
                        child: Container(
                          width: 14 + (index * 6),
                          height: 14 + (index * 6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: [
                              Colors.orange.withOpacity(0.05),
                              Colors.green.withOpacity(0.04),
                              Colors.blue.withOpacity(0.03),
                              Colors.purple.withOpacity(0.02),
                            ][index],
                            boxShadow: [
                              BoxShadow(
                                color: [
                                  Colors.orange,
                                  Colors.green,
                                  Colors.blue,
                                  Colors.purple,
                                ][index].withOpacity(0.1),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Main content
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: _isLoading
                      ? _buildLoadingView()
                      : _availableMealTimes.isEmpty
                      ? _buildEmptyView()
                      : Column(
                          children: [
                            // Meal time selector
                            SizedBox(height: 8),

                            _buildMealTimeSelector(),

                            // Station selector
                            _buildStationSelector(),

                            // Food list
                            Expanded(child: _buildFoodList()),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
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
      height: 60,
      padding: EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: _availableMealTimes.length,
        itemBuilder: (context, index) {
          MealTime mealTime = _availableMealTimes[index];
          bool isSelected = _selectedMealTime == mealTime;

          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() {
                _selectedMealTime = mealTime;
                _updateStationFoods();
              });
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              margin: EdgeInsets.only(right: 12),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isSelected
                    ? Colors.green.shade400
                    : Colors.white.withOpacity(0.1),
                border: Border.all(
                  color: isSelected
                      ? Colors.green.shade300
                      : Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  _getMealTimeDisplayName(mealTime),
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.8),
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontFamily: '.SF Pro Text',
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStationSelector() {
    if (_stationFoods.isEmpty) return SizedBox.shrink();

    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: _stationFoods.keys.length,
        itemBuilder: (context, index) {
          String stationName = _stationFoods.keys.elementAt(index);
          bool isSelected = _selectedStation == stationName;

          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() {
                _selectedStation = stationName;
              });
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              margin: EdgeInsets.only(right: 12),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isSelected
                    ? Colors.blue.shade400
                    : Colors.white.withOpacity(0.1),
                border: Border.all(
                  color: isSelected
                      ? Colors.blue.shade300
                      : Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  stationName,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.8),
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontFamily: '.SF Pro Text',
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFoodList() {
    if (_selectedStation.isEmpty ||
        !_stationFoods.containsKey(_selectedStation)) {
      return SizedBox.shrink();
    }

    List<Food> foods = _stationFoods[_selectedStation]!;

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: foods.length,
      itemBuilder: (context, index) {
        Food food = foods[index];
        return _buildFoodItem(food, index);
      },
    );
  }

  Widget _buildFoodItem(Food food, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          _showFoodDetails(food);
        },
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white.withOpacity(0.08),
            border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: [
                        Colors.blue,
                        Colors.green,
                        Colors.orange,
                        Colors.purple,
                        Colors.cyan,
                        Colors.pink,
                      ][index % 6].withOpacity(0.2),
                    ),
                    child: Icon(
                      Icons.restaurant,
                      color: [
                        Colors.blue,
                        Colors.green,
                        Colors.orange,
                        Colors.purple,
                        Colors.cyan,
                        Colors.pink,
                      ][index % 6],
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          food.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontFamily: '.SF Pro Text',
                            decoration: TextDecoration.none,
                          ),
                        ),
                        if (food.ingredients.isNotEmpty) ...[
                          SizedBox(height: 4),
                          Text(
                            food.ingredients,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.6),
                              fontFamily: '.SF Pro Text',
                              decoration: TextDecoration.none,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.white.withOpacity(0.4),
                    size: 20,
                  ),
                ],
              ),
              SizedBox(height: 12),

              // Nutrition info
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  if (food.calories > 0)
                    _buildNutritionChip(
                      '${food.calories.round()} cal',
                      Colors.blue,
                    ),
                  if (food.protein > 0)
                    _buildNutritionChip(
                      '${food.protein.round()}g P',
                      Colors.green,
                    ),
                  if (food.carbs > 0)
                    _buildNutritionChip(
                      '${food.carbs.round()}g C',
                      Colors.orange,
                    ),
                  if (food.fat > 0)
                    _buildNutritionChip(
                      '${food.fat.round()}g F',
                      Colors.purple,
                    ),
                ],
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
                            color: Colors.amber.withOpacity(0.2),
                            border: Border.all(
                              color: Colors.amber.withOpacity(0.5),
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            label,
                            style: TextStyle(
                              color: Colors.amber.shade200,
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
          color: Colors.white,
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
    );

    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => MealDetailsScreen(
          meal: singleFoodMeal,
          diningHall: widget.diningHall,
        ),
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
}
