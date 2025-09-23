import 'dart:async';

import 'package:boiler_fuel/api/database.dart';
import 'package:boiler_fuel/api/local_database.dart';
import 'package:boiler_fuel/api/shared_preferences.dart';
import 'package:boiler_fuel/screens/user_settings_screen.dart';
import 'package:boiler_fuel/widgets/titanium_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';
import '../planner.dart';
import 'meal_details_screen.dart';
import 'dining_hall_menu_screen.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({Key? key, required this.user}) : super(key: key);

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
  late AnimationController _statusBarController;
  late Animation<double> _statusBarAnimation;
  PageController _scrollController = PageController();

  StreamController<Map<MealTime, Map<String, Meal>>> _mealStreamController =
      StreamController.broadcast();

  User? _currentUser = null;
  List<DiningHall> _diningHalls = [];

  List<String> _rankedDiningHalls = [];
  Map<MealTime, Map<String, Meal>> _suggestedMeals = {};
  bool _isLoading = true;
  MacroResult? _userMacros;

  MealTime _selectedMealTime = MealTime.lunch;

  int _currentMealIndex = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      _currentUser = widget.user;
    });

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
    _statusBarController = AnimationController(
      duration: Duration(milliseconds: 600),
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

    _statusBarAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _statusBarController, curve: Curves.elasticOut),
    );

    _animationController.forward();
    Future.delayed(Duration(milliseconds: 400), () {
      _floatingController.repeat(reverse: true);
      _pulseController.repeat(reverse: true);
      _statusBarController.repeat(reverse: true);
    });

    _loadHomeData(widget.user);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    _statusBarController.dispose();
    _mealStreamController.close();
    super.dispose();
  }

  Map<String, dynamic> _getDiningHallStatus(DiningHall diningHall) {
    DateTime now = DateTime.now();
    String weekday = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ][now.weekday - 1];

    // Check current meal time
    MealTime? currentMeal = diningHall.schedule.getCurrentMealTime();

    if (currentMeal != null) {
      // Currently open - find when it closes
      TimePeriod? currentPeriod;
      String mealName = '';

      switch (currentMeal) {
        case MealTime.breakfast:
          currentPeriod = diningHall.schedule.breakfast?[weekday];
          mealName = 'Breakfast';
          break;
        case MealTime.brunch:
          currentPeriod = diningHall.schedule.brunch?[weekday];
          mealName = 'Brunch';
          break;
        case MealTime.lunch:
          currentPeriod = diningHall.schedule.lunch?[weekday];
          mealName = 'Lunch';
          break;
        case MealTime.lateLunch:
          currentPeriod = diningHall.schedule.lateLunch?[weekday];
          mealName = 'Late Lunch';
          break;
        case MealTime.dinner:
          currentPeriod = diningHall.schedule.dinner?[weekday];
          mealName = 'Dinner';
          break;
      }

      String closeTime = currentPeriod != null
          ? _formatTime(currentPeriod.end)
          : '';

      return {
        'isOpen': true,
        'currentMeal': mealName,
        'closeTime': closeTime,
        'status': 'Open for $mealName',
        'subStatus': 'Closes at $closeTime',
      };
    } else {
      // Currently closed - find next opening
      Map<String, dynamic> nextOpening = _getNextOpening(diningHall, now);

      return {
        'isOpen': false,
        'currentMeal': null,
        'nextMeal': nextOpening['meal'],
        'nextTime': nextOpening['time'],
        'nextDay': nextOpening['day'],
        'status': 'Currently Closed',
        'subStatus': nextOpening['day'] == 'Today'
            ? 'Opens at ${nextOpening['time']} for ${nextOpening['meal']}'
            : 'Opens ${nextOpening['day']} at ${nextOpening['time']} for ${nextOpening['meal']}',
      };
    }
  }

  Map<String, dynamic> _getNextOpening(DiningHall diningHall, DateTime now) {
    String currentWeekday = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ][now.weekday - 1];

    // Check remaining meals today
    List<Map<String, dynamic>> todayMeals = _getMealsForDay(
      diningHall,
      currentWeekday,
    );

    for (var meal in todayMeals) {
      TimePeriod period = meal['period'];
      DateTime openTime = DateTime(
        now.year,
        now.month,
        now.day,
        period.start.hour,
        period.start.minute,
      );

      if (openTime.isAfter(now)) {
        return {
          'meal': meal['name'],
          'time': _formatTime(period.start),
          'day': 'Today',
        };
      }
    }

    // Check next days (up to 7 days ahead)
    for (int i = 1; i <= 7; i++) {
      DateTime nextDay = now.add(Duration(days: i));
      String nextWeekday = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ][nextDay.weekday - 1];

      List<Map<String, dynamic>> nextDayMeals = _getMealsForDay(
        diningHall,
        nextWeekday,
      );

      if (nextDayMeals.isNotEmpty) {
        var firstMeal = nextDayMeals.first;
        return {
          'meal': firstMeal['name'],
          'time': _formatTime(firstMeal['period'].start),
          'day': i == 1 ? 'Tomorrow' : nextWeekday,
        };
      }
    }

    return {'meal': 'Unknown', 'time': 'Unknown', 'day': 'Unknown'};
  }

  List<Map<String, dynamic>> _getMealsForDay(
    DiningHall diningHall,
    String weekday,
  ) {
    List<Map<String, dynamic>> meals = [];

    if (diningHall.schedule.breakfast?[weekday] != null) {
      meals.add({
        'name': 'Breakfast',
        'period': diningHall.schedule.breakfast![weekday]!,
      });
    }
    if (diningHall.schedule.brunch?[weekday] != null) {
      meals.add({
        'name': 'Brunch',
        'period': diningHall.schedule.brunch![weekday]!,
      });
    }
    if (diningHall.schedule.lunch?[weekday] != null) {
      meals.add({
        'name': 'Lunch',
        'period': diningHall.schedule.lunch![weekday]!,
      });
    }
    if (diningHall.schedule.lateLunch?[weekday] != null) {
      meals.add({
        'name': 'Late Lunch',
        'period': diningHall.schedule.lateLunch![weekday]!,
      });
    }
    if (diningHall.schedule.dinner?[weekday] != null) {
      meals.add({
        'name': 'Dinner',
        'period': diningHall.schedule.dinner![weekday]!,
      });
    }

    // Sort meals by start time
    meals.sort((a, b) {
      TimePeriod periodA = a['period'];
      TimePeriod periodB = b['period'];
      return (periodA.start.hour * 60 + periodA.start.minute).compareTo(
        periodB.start.hour * 60 + periodB.start.minute,
      );
    });

    return meals;
  }

  String _formatTime(TimeOfDay time) {
    int hour = time.hour;
    String period = hour >= 12 ? 'PM' : 'AM';
    if (hour > 12) hour -= 12;
    if (hour == 0) hour = 12;

    String minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  Future<void> _loadHomeData(User user) async {
    _userMacros = CalorieMacroCalculator.calculateMacros(
      age: user.age,
      weightLbs: user.weight.toDouble(),
      heightInches: user.height.toDouble(),
      gender: user.gender,
      goal: user.goal,
    );

    // Use user's dining hall ranking from their profile
    _rankedDiningHalls = List.from(user.diningHallRank);
    List<DiningHall> diningHalls = await Database().getDiningHalls();
    //sort dining halls by user's ranking
    diningHalls.sort((a, b) {
      int indexA = _rankedDiningHalls.indexOf(a.name);
      int indexB = _rankedDiningHalls.indexOf(b.name);
      if (indexA == -1) indexA = _rankedDiningHalls.length;
      if (indexB == -1) indexB = _rankedDiningHalls.length;
      return indexA.compareTo(indexB);
    });
    setState(() {
      _diningHalls = diningHalls;
    });
    // Generate meal suggestions for all dining halls
    if (_diningHalls.isNotEmpty) {
      setState(() {
        _isLoading = false;
      });
      // Fetch meal suggestions for each meal time and dining hall

      await LocalDatabase().listenToDayMeals(_mealStreamController);
      _mealStreamController.stream.listen((meals) {
        Map<MealTime, Map<String, Meal>> sortedSuggestions = {};
        for (MealTime mealTime in meals.keys) {
          Map<String, Meal> originalMeals = meals[mealTime]!;
          Map<String, Meal> sortedMeals = {};

          // First, add dining halls in the order of user's ranking
          for (String rankedHall in _rankedDiningHalls) {
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

        setState(() {
          _suggestedMeals = sortedSuggestions;
        });
      });
      //Sort each meal time's dining halls by user's ranking
    }
  }

  //OLD BACKGROUND
  //  Container(
  //         decoration: BoxDecoration(
  //           gradient: LinearGradient(
  //             begin: Alignment.topLeft,
  //             end: Alignment.bottomRight,
  //             colors: [
  //               Colors.black,
  //               Color(0xFF0D1B2A),
  //               Color(0xFF1B263B),
  //               Color(0xFF415A77),
  //               Color(0xFF778DA9),
  //             ],
  //             stops: [0.0, 0.25, 0.5, 0.75, 1.0],
  //           ),
  //         ),
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    bottom: false,
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

                              // Suggested Meal Plan
                              _buildSuggestedMealPlan(),
                              SizedBox(height: 32),
                              _buildDiningHallRankings(),
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
            Spacer(),
            IconButton(
              onPressed: () {
                // Open settings screen
                HapticFeedback.lightImpact();
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => UserSettingsScreen(
                      user: _currentUser!,
                      onUserUpdated: (updatedUser) {
                        setState(() {
                          _currentUser = updatedUser;
                        });
                        _loadHomeData(updatedUser);
                      },
                    ),
                  ),
                );
              },
              icon: Icon(
                Icons.settings,
                color: Colors.white.withOpacity(0.8),
                size: 28,
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
    return TitaniumContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.restaurant, color: Colors.orange.shade300, size: 24),
              SizedBox(width: 12),
              Text(
                'Dining Halls',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          if (_diningHalls.isEmpty)
            Text(
              'No dining hall preferences set',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14,
              ),
            )
          else
            ...List.generate(_diningHalls.length, (index) {
              final diningHall = _diningHalls[index];
              final status = _getDiningHallStatus(diningHall);

              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => DiningHallMenuScreen(
                        diningHall: _diningHalls[index].name,
                        user: _currentUser!,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white.withOpacity(0.05),
                    border: Border.all(
                      color: status['isOpen']
                          ? Colors.green.withOpacity(0.3)
                          : Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Status indicator dot
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: status['isOpen']
                                  ? Colors.green.shade400
                                  : Colors.red.shade400,
                              boxShadow: status['isOpen']
                                  ? [
                                      BoxShadow(
                                        color: Colors.green.shade400
                                            .withOpacity(0.4),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      ),
                                    ]
                                  : null,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              diningHall.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: index == 0
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white.withOpacity(0.4),
                            size: 16,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),

                      // Status row
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: status['isOpen']
                                  ? Colors.green.withOpacity(0.25)
                                  : Colors.red.withOpacity(0.25),
                              border: Border.all(
                                color: status['isOpen']
                                    ? Colors.green.shade300
                                    : Colors.red.shade300,
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              status['status'],
                              style: TextStyle(
                                color: status['isOpen']
                                    ? Colors.green.shade200
                                    : Colors.red.shade200,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),

                      // Additional info
                      Text(
                        status['subStatus'],
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildSuggestedMealPlan() {
    final diningHallMeals = _suggestedMeals[_selectedMealTime] ?? {};

    return TitaniumContainer(
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
          if (_suggestedMeals.isEmpty)
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white.withOpacity(0.05),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.green.shade300,
                    ),
                    strokeWidth: 3,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Generating personalized meals...',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: '.SF Pro Display',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'BoilerFuel is creating custom meal plans from today\'s dining hall menus',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 13,
                      fontFamily: '.SF Pro Text',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else ...[
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
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (_scrollController.hasClients) {
                          _scrollController.jumpToPage(0);
                        }
                      });
                    });
                  }
                },
                items: MealTime.values
                    .where((v) => v != MealTime.lateLunch)
                    .map<DropdownMenuItem<MealTime>>((MealTime value) {
                      return DropdownMenuItem<MealTime>(
                        value: value,
                        child: Text(
                          value.toString().substring(0, 1).toUpperCase() +
                              value.toString().substring(1),
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    })
                    .toList(),
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
                    // Trigger a more pronounced animation for the new active indicator
                    _statusBarController.reset();
                    _statusBarController.forward();

                    // Add haptic feedback for page changes
                    HapticFeedback.selectionClick();
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
              AnimatedBuilder(
                animation: _statusBarAnimation,
                builder: (context, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(diningHallMeals.length, (index) {
                      bool isActive = _currentMealIndex == index;

                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 24 : 8,
                        height: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: isActive
                                ? Colors.green.shade400
                                : Colors.white.withOpacity(0.3),
                            boxShadow: isActive
                                ? [
                                    BoxShadow(
                                      color: Colors.green.shade400.withOpacity(
                                        0.4,
                                      ),
                                      blurRadius: 8 * _statusBarAnimation.value,
                                      spreadRadius:
                                          2 * _statusBarAnimation.value,
                                    ),
                                  ]
                                : null,
                          ),
                          child: isActive
                              ? Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.green.shade300,
                                        Colors.green.shade500,
                                        Colors.green.shade300,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      );
                    }),
                  );
                },
              ),
            ],
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
    return TitaniumContainer(
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
