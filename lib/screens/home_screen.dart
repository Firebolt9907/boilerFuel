import 'package:boiler_fuel/custom/cupertinoSheet.dart' as customCupertinoSheet;
import 'package:boiler_fuel/screens/dining_hall_search_screen.dart';
import 'package:boiler_fuel/styling.dart';
import 'dart:async';

import 'package:boiler_fuel/api/database.dart';
import 'package:boiler_fuel/api/local_database.dart';
import 'package:boiler_fuel/api/shared_preferences.dart';
import 'package:boiler_fuel/main.dart';
import 'package:boiler_fuel/screens/saved_meals_screen.dart';
import 'package:boiler_fuel/screens/suggested_meals_screen.dart';
import 'package:boiler_fuel/screens/user_settings_screen.dart';
import 'package:boiler_fuel/widgets/default_container.dart';
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

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _animationController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;
  late AnimationController _statusBarController;
  late Animation<double> _statusBarAnimation;
  PageController _scrollController = PageController();

  // animated ellipsis for generating text
  String _generatingEllipsis = '';
  Timer? _ellipsisTimer;

  User? _currentUser = null;
  List<DiningHall> _diningHalls = [];

  List<String> _rankedDiningHalls = [];
  Map<MealTime, Map<String, Meal>> _suggestedMeals = {};
  bool _isLoading = true;

  Meal? displayMeal;
  MealTime _selectedMealTime = MealTime.lunch;

  int _currentMealIndex = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      _currentUser = widget.user;
    });
    WidgetsBinding.instance.addObserver(this);
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

    // start ellipsis animation (cycles: '', '.', '..', '...')
    _ellipsisTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        if (_generatingEllipsis.length >= 3) {
          _generatingEllipsis = '';
        } else {
          _generatingEllipsis = '${_generatingEllipsis}.';
        }
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    _statusBarController.dispose();

    _ellipsisTimer?.cancel();
    super.dispose();
  }

  DiningHallStatus _getDiningHallStatus(DiningHall diningHall) {
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

      switch (currentMeal) {
        case MealTime.breakfast:
          currentPeriod = diningHall.schedule.breakfast?[weekday];

          break;
        case MealTime.brunch:
          currentPeriod = diningHall.schedule.brunch?[weekday];

          break;
        case MealTime.lunch:
          currentPeriod = diningHall.schedule.lunch?[weekday];

          break;
        case MealTime.lateLunch:
          currentPeriod = diningHall.schedule.lateLunch?[weekday];

          break;
        case MealTime.dinner:
          currentPeriod = diningHall.schedule.dinner?[weekday];

          break;
      }

      return DiningHallStatus(
        isOpen: true,
        currentMealTime: currentMeal,
        closingTime: currentPeriod!.end,
      );
    } else {
      // Currently closed - find next opening
      Map<String, dynamic> nextOpening = _getNextOpening(diningHall, now);
      return DiningHallStatus(
        isOpen: false,
        nextMealTime: nextOpening['meal'],
        nextOpeningDay: nextOpening['day'],
        nextOpeningTime: nextOpening['time'],
      );
    }
  }

  List<Map<String, dynamic>> _getMealsForDay(
    DiningHall diningHall,
    String weekday,
  ) {
    List<Map<String, dynamic>> meals = [];

    if (diningHall.schedule.breakfast?[weekday] != null) {
      meals.add({
        'name': MealTime.breakfast,
        'period': diningHall.schedule.breakfast![weekday]!,
      });
    }
    if (diningHall.schedule.brunch?[weekday] != null) {
      meals.add({
        'name': MealTime.brunch,
        'period': diningHall.schedule.brunch![weekday]!,
      });
    }
    if (diningHall.schedule.lunch?[weekday] != null) {
      meals.add({
        'name': MealTime.lunch,
        'period': diningHall.schedule.lunch![weekday]!,
      });
    }
    if (diningHall.schedule.lateLunch?[weekday] != null) {
      meals.add({
        'name': MealTime.lateLunch,
        'period': diningHall.schedule.lateLunch![weekday]!,
      });
    }
    if (diningHall.schedule.dinner?[weekday] != null) {
      meals.add({
        'name': MealTime.dinner,
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

  void getDisplayMeal(
    Map<MealTime, Map<String, Meal>> suggestedMeals,
    List<DiningHall> rankedDiningHalls,
  ) {
    Meal? firstMeal;
    MealTime? firstMealTime;
    for (DiningHall hall in rankedDiningHalls) {
      DiningHallStatus hallStatus = _getDiningHallStatus(
        _diningHalls.firstWhere((dh) => dh.name == hall.name),
      );
      MealTime? currentMealTime = hallStatus.currentMealTime;
      print("Current Meal Time: $currentMealTime");
      print("DINING HALL: ${hall.name}");
      print("IS OPEN: ${hallStatus.isOpen}");
      Map<String, Meal>? mealsForCurrentTime = currentMealTime != null
          ? suggestedMeals[currentMealTime]
          : null;
      if (mealsForCurrentTime != null &&
          mealsForCurrentTime.containsKey(hall.name)) {
        firstMeal = mealsForCurrentTime[hall.name];
        firstMealTime = currentMealTime;
        break;
      }
    }
    if (firstMeal != null && firstMealTime != null) {
      setState(() {
        displayMeal = firstMeal;
        _selectedMealTime = firstMealTime!;
        print("displayMeal set to: ${displayMeal?.name}");
        print("displayMeal mealTime: ${displayMeal?.mealTime}");
      });
    } else {
      for (DiningHall hall in rankedDiningHalls) {
        DiningHallStatus hallStatus = _getDiningHallStatus(
          _diningHalls.firstWhere((dh) => dh.name == hall.name),
        );
        MealTime? nextMealTime = hallStatus.nextMealTime;
        print("Next Meal Time: $nextMealTime");
        print("DINING HALL: ${hall.name}");
        print("IS OPEN: ${hallStatus.isOpen}");
        Map<String, Meal>? mealsForNextTime = nextMealTime != null
            ? suggestedMeals[nextMealTime]
            : null;
        if (mealsForNextTime != null &&
            mealsForNextTime.containsKey(hall.name)) {
          firstMeal = mealsForNextTime[hall.name];
          firstMealTime = nextMealTime;
          break;
        }
      }
      if (firstMeal != null && firstMealTime != null) {
        setState(() {
          displayMeal = firstMeal;
          _selectedMealTime = firstMealTime!;
          print("displayMeal set to: ${displayMeal?.name}");
          print("displayMeal mealTime: ${displayMeal?.mealTime}");
        });
      } else {
        print("No meal found for displayMeal");
      }
    }
  }

  Future<void> _loadHomeData(User user) async {
    //Scroll to beginning
    if (_scrollController.hasClients) {
      _scrollController.jumpToPage(0);
    }

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
      print(_rankedDiningHalls);
      print(diningHalls.map((e) => e.name).toList());
      _diningHalls = diningHalls;
    });
    // Generate meal suggestions for all dining halls
    if (_diningHalls.isNotEmpty && user.useMealPlanning) {
      // Fetch meal suggestions for each meal time and dining hall
      Map<MealTime, Map<String, Meal>>? dayMeals = await LocalDatabase()
          .getAIDayMeals();
      print("Day Meals fetched: $dayMeals");
      if (dayMeals != null) {
        Map<MealTime, Map<String, Meal>> sortedSuggestions = {};
        for (MealTime mealTime in dayMeals.keys) {
          Map<String, Meal> originalMeals = dayMeals[mealTime]!;
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
          print("Sorted Suggestions:");
          print(
            "Sorted Suggestions:" +
                sortedSuggestions
                    .map((k, v) => MapEntry(k.toString(), v.keys.toList()))
                    .toString(),
          );
          _suggestedMeals = sortedSuggestions;
          getDisplayMeal(sortedSuggestions, diningHalls);
          // Meal? firstMeal;
          // for (String hall in _rankedDiningHalls) {
          //   DiningHallStatus hallStatus = _getDiningHallStatus(
          //     _diningHalls.firstWhere((dh) => dh.name == hall),
          //   );
          //   MealTime? currentMealTime = hallStatus.currentMealTime;
          //   Map<String, Meal>? mealsForCurrentTime = currentMealTime != null
          //       ? _suggestedMeals[currentMealTime]
          //       : null;
          //   if (mealsForCurrentTime != null &&
          //       mealsForCurrentTime.containsKey(hall)) {
          //     firstMeal = mealsForCurrentTime[hall];
          //     break;
          //   }
          // }
          // MealTime? nextMealTime;
          // if (firstMeal == null) {
          //   // Find the next meal time with suggestions
          //   for (String hall in _rankedDiningHalls) {
          //     DiningHallStatus hallStatus = _getDiningHallStatus(
          //       _diningHalls.firstWhere((dh) => dh.name == hall),
          //     );

          //     MealTime? currentMealTime = hallStatus.isOpen
          //         ? hallStatus.currentMealTime
          //         : hallStatus.nextMealTime;
          //     if (hallStatus.nextOpeningDay != 'Today') {
          //       continue; //skip if next meal is not today
          //     }

          //     if (_suggestedMeals.containsKey(currentMealTime) &&
          //         _suggestedMeals[currentMealTime]!.containsKey(hall)) {
          //       nextMealTime = currentMealTime;
          //       firstMeal = _suggestedMeals[currentMealTime]![hall];
          //       break;
          //     }
          //   }
          //   _selectedMealTime = nextMealTime ?? MealTime.getCurrentMealTime();
          //   if (firstMeal == null) {
          //     print("No meal found, defaulting to first meal of the time");
          //     firstMeal = _suggestedMeals[_selectedMealTime]?.values.first;
          //   }
          // } else {
          //   _selectedMealTime =
          //       displayMeal?.mealTime ?? MealTime.getCurrentMealTime();
          // }
          // displayMeal = firstMeal;

          // print(displayMeal?.mealTime);

          // print("Display Meal: ${displayMeal?.name}");
          // setState(() {});
        });
      }

      aiMealStream.stream.listen((meals) {
        if (!mounted) return;
        if (aiMealStream.isClosed) return;
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
          print("Sorted Suggestions:");
          print(
            "Sorted Suggestions:" +
                sortedSuggestions
                    .map((k, v) => MapEntry(k.toString(), v.keys.toList()))
                    .toString(),
          );
          _suggestedMeals = sortedSuggestions;

          // Meal? firstMeal;
          // for (String hall in _rankedDiningHalls) {
          //   DiningHallStatus hallStatus = _getDiningHallStatus(
          //     _diningHalls.firstWhere((dh) => dh.name == hall),
          //   );
          //   MealTime? currentMealTime = hallStatus.currentMealTime;
          //   Map<String, Meal>? mealsForCurrentTime = currentMealTime != null
          //       ? _suggestedMeals[currentMealTime]
          //       : null;
          //   if (mealsForCurrentTime != null &&
          //       mealsForCurrentTime.containsKey(hall)) {
          //     firstMeal = mealsForCurrentTime[hall];
          //     break;
          //   }
          // }
          // MealTime? nextMealTime;
          // if (firstMeal == null) {
          //   // Find the next meal time with suggestions
          //   for (String hall in _rankedDiningHalls) {
          //     DiningHallStatus hallStatus = _getDiningHallStatus(
          //       _diningHalls.firstWhere((dh) => dh.name == hall),
          //     );

          //     MealTime? currentMealTime = hallStatus.isOpen
          //         ? hallStatus.currentMealTime
          //         : hallStatus.nextMealTime;
          //     if (hallStatus.nextOpeningDay != 'Today') {
          //       continue; //skip if next meal is not today
          //     }

          //     if (_suggestedMeals.containsKey(currentMealTime) &&
          //         _suggestedMeals[currentMealTime]!.containsKey(hall)) {
          //       nextMealTime = currentMealTime;
          //       firstMeal = _suggestedMeals[currentMealTime]![hall];
          //       break;
          //     }
          //   }
          //   _selectedMealTime = nextMealTime ?? MealTime.getCurrentMealTime();
          //   if (firstMeal == null) {
          //     print("No meal found, defaulting to first meal of the time");
          //     firstMeal = _suggestedMeals[_selectedMealTime]?.values.first;
          //     return;
          //   }
          // } else {
          //   _selectedMealTime =
          //       displayMeal?.mealTime ?? MealTime.getCurrentMealTime();
          // }

          // displayMeal = firstMeal;
          // print(displayMeal?.mealTime);

          // print("Display Meal: ${displayMeal?.name}");
          getDisplayMeal(sortedSuggestions, diningHalls);
        });
      });

      //Sort each meal time's dining halls by user's ranking
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");

        getDisplayMeal(_suggestedMeals, _diningHalls);

        break;
      case AppLifecycleState.inactive:
        print("app in inactive");

        break;
      case AppLifecycleState.paused:
        print("app in paused");

        break;
      case AppLifecycleState.detached:
        print("app in detached");

        break;
      case AppLifecycleState.hidden:
        print("app in hidden");

        break;
    }
  }

  //OLD BACKGROUND
  //  Container(
  //         decoration: BoxDecoration(
  //           gradient: LinearGradient(
  //             begin: Alignment.topLeft,
  //             end: Alignment.bottomRight,
  //             colors: [
  //               DynamicStyling.getBlack(context),
  //               Color(0xFF0D1B2A),
  //               Color(0xFF1B263B),
  //               Color(0xFF415A77),
  //               Color(0xFF778DA9),
  //             ],
  //             stops: [0.0, 0.25, 0.5, 0.75, 1.0],
  //           ),
  //         ),

  void onViewSavedMeals() {
    HapticFeedback.mediumImpact();
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => SavedMealsScreen(user: widget.user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mealTime = MealTime.getCurrentMealTime();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // Header
          _buildHeader(context),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                top: 12.0,
                bottom: 12.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _isLoading
                    ? [
                        Center(
                          child: CircularProgressIndicator(
                            color: DynamicStyling.getBlack(context),
                          ),
                        ),
                      ]
                    : [
                        // Suggested Meals Section
                        if (widget.user.useMealPlanning)
                          Row(
                            children: [
                              Icon(
                                Icons.auto_awesome,
                                color: DynamicStyling.getBlack(context),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Suggested Meal for ${_selectedMealTime.toDisplayString()}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        if (widget.user.useMealPlanning)
                          const SizedBox(height: 12),
                        if (widget.user.useMealPlanning)
                          _buildSuggestedMealCard(context),
                        if (widget.user.useMealPlanning)
                          const SizedBox(height: 12),
                        if (widget.user.useMealPlanning)
                          Card(
                            elevation: 0,
                            color: DynamicStyling.getWhite(context),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                width: 2,
                                color: DynamicStyling.getLightGrey(context),
                              ),
                            ),
                            child: InkWell(
                              onTap: onViewSavedMeals,
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                              splashColor: DynamicStyling.getLightGrey(context),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(20, 255, 0, 0),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.bookmark_outline,
                                        color: Color(0xfffb2c35),
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Saved Meals',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'View and manage your saved meals',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: DynamicStyling.getDarkGrey(
                                                context,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.chevron_right,
                                      color: DynamicStyling.getGrey(context),
                                      size: 24,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                        if (widget.user.useMealPlanning)
                          const SizedBox(height: 24),

                        // Dining Halls Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Dining Halls',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            DefaultContainer(
                              onTap: () {
                                HapticFeedback.mediumImpact();
                                customCupertinoSheet.showCupertinoSheet<void>(
                                  context: context,
                                  useNestedNavigation: true,
                                  pageBuilder: (BuildContext context) =>
                                      DiningHallSearchScreen(
                                        diningHall: null,
                                        user: widget.user,
                                      ),
                                );
                                // Navigator.push(
                                //   context,
                                //   CupertinoPageRoute(
                                //     builder: (context) =>
                                //         DiningHallSearchScreen(
                                //           diningHall: null,
                                //           user: widget.user,
                                //         ),
                                //   ),
                                // );
                              },

                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              splashColor: DynamicStyling.getLightGrey(context),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.search,
                                    color: DynamicStyling.getDarkGrey(context),
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Search for Foods',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: DynamicStyling.getDarkGrey(
                                        context,
                                      ),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ..._diningHalls.map(
                          (hall) => Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: _buildDiningHallCard(context, hall),
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

  void onViewSuggestedMeals() {
    HapticFeedback.mediumImpact();
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => SuggestedMealsScreen(user: widget.user),
      ),
    );
  }

  void onViewMeal() {
    if (displayMeal == null) return;
    HapticFeedback.mediumImpact();
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => MealDetailsScreen(
          meal: displayMeal!,
          diningHall: displayMeal!.diningHall,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: DynamicStyling.getWhite(context),
        border: Border(
          bottom: BorderSide(
            color: DynamicStyling.getLightGrey(context),
            width: 2,
          ),
        ),
      ),
      child: Column(
        children: [
          // Clamp to 0 to avoid negative height on platforms with small/zero safe area (e.g., macOS)
          SizedBox(
            height: (MediaQuery.of(context).padding.top - 12)
                .clamp(0.0, double.infinity)
                .toDouble(),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'UPlate',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Welcome back, ${widget.user.name.split(' ').first}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: DynamicStyling.getGrey(context),
                      ),
                    ),
                  ],
                ),
                // if (widget.user.useMealPlanning)
                DefaultContainer(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => UserSettingsScreen(
                          user: widget.user,
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
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: DynamicStyling.getLightGrey(context),
                      width: 1,
                    ),
                  ),

                  child: Icon(
                    Icons.settings_outlined,
                    color: DynamicStyling.getBlack(context),
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedMealCard(BuildContext context) {
    return Card(
      elevation: 0,
      color: DynamicStyling.getWhite(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(width: 2, color: DynamicStyling.getLightGrey(context)),
      ),
      child: Column(
        children: [
          if (displayMeal == null) ...[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    'Meal Suggestion Generating${_generatingEllipsis}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'UPlate is working to find the best meal for you based on your preferences and dining hall hours. This may take a moment.',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ] else
            InkWell(
              onTap: onViewMeal,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              splashColor: DynamicStyling.getLightGrey(context),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayMeal!.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${displayMeal!.diningHall}',
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
                                    color: DynamicStyling.getGrey(context),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${displayMeal!.calories.round()}',
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
                                    color: DynamicStyling.getGrey(context),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${displayMeal!.protein.round()}g',
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
                          color: styling.gray,
                          size: 24,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          Divider(height: 2, color: DynamicStyling.getLightGrey(context)),
          InkWell(
            onTap: onViewSuggestedMeals,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            splashColor: DynamicStyling.getLightGrey(context),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'View all suggested meals',
                          style: TextStyle(
                            fontSize: 14,
                            color: DynamicStyling.getGrey(context),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: DynamicStyling.getGrey(context),
                          size: 20,
                        ),
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

  void onDiningHallSelect(DiningHall diningHall, MealTime initialMealTime) {
    HapticFeedback.mediumImpact();
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => DiningHallMenuScreen(
          diningHall: diningHall.name,
          user: widget.user,
          initialMealTime: initialMealTime,
        ),
      ),
    );
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
        return {'meal': meal['name'], 'time': period.start, 'day': 'Today'};
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
          'time': firstMeal['period'].start,
          'day': i == 1 ? 'Tomorrow' : nextWeekday,
        };
      }
    }

    return {'meal': 'Unknown', 'time': 'Unknown', 'day': 'Unknown'};
  }

  Widget _buildDiningHallCard(BuildContext context, DiningHall hall) {
    final statusInfo = _getDiningHallStatus(hall);

    return Card(
      elevation: 0,
      color: DynamicStyling.getWhite(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: DynamicStyling.getLightGrey(context), width: 2),
      ),
      child: InkWell(
        onTap: () => onDiningHallSelect(
          hall,
          statusInfo.isOpen
              ? statusInfo.currentMealTime!
              : statusInfo.nextMealTime!,
        ),
        splashColor: DynamicStyling.getLightGrey(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            hall.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: statusInfo.isOpen
                                ? Colors.green[600]
                                : Colors.red[600],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          statusInfo.getStatus(),
                          style: TextStyle(
                            fontSize: 12,
                            color: statusInfo.isOpen
                                ? Colors.green[600]
                                : Colors.red[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // Icon(
                        //   Icons.local_dining,
                        //   size: 14,
                        //   color: DynamicStyling.getGrey(context),
                        // ),
                        // const SizedBox(width: 4),
                        // Text(
                        //   statusInfo['currentMeal'] != ""
                        //       ? statusInfo['currentMeal']
                        //       : statusInfo['nextMeal'],
                        //   style: TextStyle(color: Colors.grey[600]),
                        // ),
                        // const SizedBox(width: 16),
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: DynamicStyling.getGrey(context),
                        ),
                        const SizedBox(width: 4),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 200),
                          child: Text(
                            statusInfo.getSubStatus(context),
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      ],
                    ),
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
        ),
      ),
    );
  }
}
