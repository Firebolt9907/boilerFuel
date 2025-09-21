import 'package:boiler_fuel/local_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';
import '../planner.dart';
import 'meal_details_screen.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  final User? user;

  const HomeScreen({Key? key, this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;
  PageController _scrollController = PageController();

  User? _currentUser = null;

  List<String> _rankedDiningHalls = [];
  Map<MealTime, Map<String, Meal>> _suggestedMeals = {};
  bool _isLoading = true;
  MacroResult? _userMacros;

  MealTime _selectedMealTime = MealTime.lunch;
  final List<String> _diningHalls = [
    "Wiley",
    "Hillenbrand",
    "Windsor",
    "Earhart",
    "Ford",
  ];
  int _currentMealIndex = 0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _floatingController = AnimationController(
      duration: Duration(milliseconds: 4000),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _floatingAnimation = Tween<double>(begin: -15.0, end: 15.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    Future.delayed(Duration(milliseconds: 400), () {
      _floatingController.repeat(reverse: true);
      _pulseController.repeat(reverse: true);
    });

    _loadHomeData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _loadHomeData() async {
    User? user = widget.user;
    if (user == null) {
      user = (await LocalDB.getUser())!;
    }
    setState(() {
      _currentUser = user;
    });
    // Get user data and calculate macros
    _userMacros = CalorieMacroCalculator.calculateMacros(
      age: user.age,
      weightLbs: user.weight.toDouble(),
      heightInches: user.height.toDouble(),
      gender: user.gender,
      goal: user.goal,
    );

    // Use user's dining hall ranking from their profile
    _rankedDiningHalls = List.from(user.diningHallRank);

    // Generate meal suggestions for all dining halls
    if (_diningHalls.isNotEmpty) {
      // Calculate per-meal macros (assuming 2 meals per day)
      double mealCalories = _userMacros!.calories / 2;
      double mealProtein = _userMacros!.protein / 2;
      double mealCarbs = _userMacros!.carbs / 2;
      double mealFat = _userMacros!.fat / 2;

      // Fetch meal suggestions for each meal time and dining hall
      Map<MealTime, Map<String, Meal>>? suggestions =
          await LocalDB.getDaysMeals();
      if (suggestions == null) {
        print("Getting new meal suggestions");
        suggestions = {};
        for (MealTime mealTime in MealTime.values) {
          Map<String, Meal> diningHallMeals = {};
          // Run meal generation for all dining halls in parallel
          final mealFutures = _diningHalls.map((diningHall) async {
            List<Meal> meals = await MealPlanner.generateDiningHallMeal(
              diningHall: diningHall,
              mealTime: mealTime,
              targetCalories: mealCalories,
              targetProtein: mealProtein,
              targetCarbs: mealCarbs,
              targetFat: mealFat,
            );
            if (meals.isNotEmpty) {
              return MapEntry(diningHall, meals.first);
            }
            return null;
          }).toList();

          final results = await Future.wait(mealFutures);
          for (final entry in results) {
            if (entry != null) {
              diningHallMeals[entry.key] = entry.value;
            }
          }
          suggestions[mealTime] = diningHallMeals;
        }
        await LocalDB.saveDaysMeals(suggestions);
      }
      //Sort each meal time's dining halls by user's ranking

      

      setState(() {
        _suggestedMeals = suggestions!;
      });
    }


    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black,
              Color(0xFF0D1B2A),
              Color(0xFF1B263B),
              Color(0xFF415A77),
              Color(0xFF778DA9),
            ],
            stops: [0.0, 0.25, 0.5, 0.75, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Floating decorative elements
            ...List.generate(
              6,
              (index) => Positioned(
                left: (index * 80.0) % MediaQuery.of(context).size.width,
                top: (index * 140.0) % MediaQuery.of(context).size.height,
                child: AnimatedBuilder(
                  animation: _floatingAnimation,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(
                      math.sin(_floatingAnimation.value / 18 + index) * 8,
                      _floatingAnimation.value +
                          math.cos(_floatingAnimation.value / 14 + index) * 6,
                    ),
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) => Transform.scale(
                        scale: _pulseAnimation.value * (0.06 + index * 0.03),
                        child: Container(
                          width: 16 + (index * 5),
                          height: 16 + (index * 5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: [
                              Colors.blue.withOpacity(0.08),
                              Colors.green.withOpacity(0.06),
                              Colors.orange.withOpacity(0.05),
                              Colors.purple.withOpacity(0.04),
                              Colors.cyan.withOpacity(0.03),
                              Colors.pink.withOpacity(0.02),
                            ][index],
                            boxShadow: [
                              BoxShadow(
                                color: [
                                  Colors.blue,
                                  Colors.green,
                                  Colors.orange,
                                  Colors.purple,
                                  Colors.cyan,
                                  Colors.pink,
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
              ),
            ),

            // Main content
            _currentUser == null
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.blue.shade300,
                      ),
                    ),
                  )
                : SafeArea(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            _buildHeader(),
                            SizedBox(height: 32),

                            // Loading or content
                            if (_isLoading)
                              _buildLoadingView(context)
                            else ...[
                              // Dining Hall Rankings
                              // _buildDiningHallRankings(),
                              // SizedBox(height: 32),

                              // Suggested Meal Plan
                              _buildSuggestedMealPlan(),
                              SizedBox(height: 32),

                              // Daily Macros Overview
                              if (_userMacros != null) _buildMacrosOverview(),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Icon(Icons.home, color: Colors.white, size: 28),
            // SizedBox(width: 12),
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  Colors.white,
                  Colors.blue.shade300,
                  Colors.cyan.shade200,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Text(
                'BoilerFuel',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          'Welcome back, ${_currentUser!.name}!',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingView(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade300),
            ),
            SizedBox(height: 16),
            Text(
              'Loading your personalized meal plan...',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiningHallRankings() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.restaurant, color: Colors.orange.shade300, size: 24),
              SizedBox(width: 12),
              Text(
                'Your Rankings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          if (_rankedDiningHalls.isEmpty)
            Text(
              'No dining hall preferences set',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14,
              ),
            )
          else
            ...List.generate(_rankedDiningHalls.length, (index) {
              return Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: index == 0
                      ? Colors.green.withOpacity(0.2)
                      : Colors.white.withOpacity(0.05),
                  border: Border.all(
                    color: index == 0
                        ? Colors.green.withOpacity(0.5)
                        : Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index == 0
                            ? Colors.green.shade400
                            : Colors.white.withOpacity(0.2),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _rankedDiningHalls[index],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: index == 0
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                    if (index == 0)
                      Icon(Icons.star, color: Colors.amber.shade400, size: 20),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildSuggestedMealPlan() {
    final diningHallMeals = _suggestedMeals[_selectedMealTime] ?? {};

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_dining, color: Colors.green.shade300, size: 24),
              SizedBox(width: 12),
              Text(
                'Suggested Meal Plan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Meal time dropdown
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white.withOpacity(0.1),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: DropdownButton<MealTime>(
              value: _selectedMealTime,
              dropdownColor: Color(0xFF1B263B),
              style: TextStyle(color: Colors.white, fontSize: 14),
              underline: Container(),
              icon: Icon(Icons.arrow_drop_down, color: Colors.white),
              onChanged: (MealTime? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedMealTime = newValue;
                    _currentMealIndex =
                        0; // Reset to first meal when changing meal time
                    _scrollController.jumpToPage(0);
                  });
                }
              },
              items: MealTime.values.map<DropdownMenuItem<MealTime>>((
                MealTime value,
              ) {
                return DropdownMenuItem<MealTime>(
                  value: value,
                  child: Text(
                    value.toString().substring(0, 1).toUpperCase() +
                        value.toString().substring(1),
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
            ),
          ),

          SizedBox(height: 16),

          if (diningHallMeals.isEmpty)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white.withOpacity(0.05),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.restaurant_menu,
                    color: Colors.white.withOpacity(0.4),
                    size: 48,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'No meals available',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Check back later for personalized meal suggestions',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else ...[
            // Horizontal scrolling meal cards
            Container(
              height: 200,
              child: PageView.builder(
                onPageChanged: (index) {
                  setState(() {
                    _currentMealIndex = index;
                  });
                },
                controller: _scrollController,
                itemCount: diningHallMeals.length,
                itemBuilder: (context, index) {
                  final diningHall = diningHallMeals.keys.elementAt(index);
                  final meal = diningHallMeals[diningHall]!;

                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => MealDetailsScreen(
                            meal: meal,
                            diningHall: diningHall,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white.withOpacity(0.08),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  meal.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(
                                CupertinoIcons.chevron_right,
                                color: Colors.white.withOpacity(0.5),
                                size: 16,
                              ),
                            ],
                          ),
                          Text(
                            "At $diningHall",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                          SizedBox(height: 12),
                          Expanded(
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _buildNutritionChip(
                                  '${meal.calories.round()} cal',
                                  Colors.blue,
                                ),
                                _buildNutritionChip(
                                  '${meal.protein.round()}g Protein',
                                  Colors.green,
                                ),
                                _buildNutritionChip(
                                  '${meal.carbs.round()}g Carbs',
                                  Colors.orange,
                                ),
                                _buildNutritionChip(
                                  '${meal.fat.round()}g Fat',
                                  Colors.purple,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 16),

            // Status bar (page indicator)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                diningHallMeals.length,
                (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: _currentMealIndex == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: _currentMealIndex == index
                        ? Colors.green.shade400
                        : Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ],
        ],
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
        ),
      ),
    );
  }

  Widget _buildMacrosOverview() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics, color: Colors.cyan.shade300, size: 24),
              SizedBox(width: 12),
              Text(
                'Daily Nutrition Goals',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMacroCard(
                  'Calories',
                  '${_userMacros!.calories.round()}',
                  'kcal',
                  Colors.blue,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildMacroCard(
                  'Protein',
                  '${_userMacros!.protein.round()}',
                  'g',
                  Colors.green,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMacroCard(
                  'Carbs',
                  '${_userMacros!.carbs.round()}',
                  'g',
                  Colors.orange,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildMacroCard(
                  'Fat',
                  '${_userMacros!.fat.round()}',
                  'g',
                  Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroCard(String label, String value, String unit, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 2),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
