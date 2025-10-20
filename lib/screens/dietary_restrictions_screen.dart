import 'package:boiler_fuel/styling.dart';
import 'package:boiler_fuel/api/local_database.dart';
import 'package:boiler_fuel/api/shared_preferences.dart';
import 'package:boiler_fuel/main.dart';
import 'package:boiler_fuel/planner.dart';
import 'package:boiler_fuel/screens/dining_hall_ranking_screen.dart';
import 'package:boiler_fuel/screens/home_screen.dart';
import 'package:boiler_fuel/widgets/default_button.dart';
import 'package:boiler_fuel/widgets/default_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';
import '../widgets/animated_button.dart';
import 'allergen_swipe_screen.dart';
import 'diet_preference_swipe_screen.dart';
import 'custom_ingredients_screen.dart';
import 'dart:math' as math;

class DietaryRestrictionsScreen extends StatefulWidget {
  final User user;
  final bool isEditing;

  const DietaryRestrictionsScreen({
    Key? key,
    required this.user,
    this.isEditing = false,
  }) : super(key: key);

  @override
  _DietaryRestrictionsScreenState createState() =>
      _DietaryRestrictionsScreenState();
}

class _DietaryRestrictionsScreenState extends State<DietaryRestrictionsScreen>
    with TickerProviderStateMixin {
  List<FoodAllergy> _selectedAllergies = [];
  List<FoodPreference> _selectedPreferences = [];
  List<String> _customIngredients = [];

  late AnimationController _animationController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;

  final List<String> _diningHalls = [
    "Wiley",
    "Hillenbrand",
    "Windsor",
    "Earhart",
    "Ford",
  ];
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _floatingController = AnimationController(
      duration: Duration(milliseconds: 3500),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _floatingAnimation = Tween<double>(begin: -25.0, end: 25.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    Future.delayed(Duration(milliseconds: 500), () {
      _floatingController.repeat(reverse: true);
      _pulseController.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _startAllergenFlow() async {
    HapticFeedback.mediumImpact();
    final result = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => AllergenSwipeScreen(
          selectedAllergies: _selectedAllergies,
          onAllergiesSelected: (allergies) {
            setState(() {
              _selectedAllergies = allergies;
            });
          },
        ),
      ),
    );

    // After allergen screen, automatically start preference flow
    // if (result != null) {
    //   _startPreferenceFlow();
    // }
  }

  void _startPreferenceFlow() async {
    HapticFeedback.mediumImpact();
    final result = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => DietPreferenceSwipeScreen(
          selectedPreferences: _selectedPreferences,
          onPreferencesSelected: (preferences) {
            setState(() {
              _selectedPreferences = preferences;
            });
          },
        ),
      ),
    );

    // // After preference screen, automatically start custom ingredients flow
    // if (result != null) {
    //   _startCustomIngredientsFlow();
    // }
  }

  void _startCustomIngredientsFlow() async {
    HapticFeedback.mediumImpact();
    final result = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => CustomIngredientsScreen(
          customIngredients: _customIngredients,
          onIngredientsSelected: (ingredients) {
            setState(() {
              _customIngredients = ingredients;
            });
          },
        ),
      ),
    );

    // After custom ingredients screen, complete the setup
    // if (result != null) {
    //   _completeSetup();
    // }
  }

  void _completeSetup() async {
    HapticFeedback.mediumImpact();
    final dietaryRestrictions = DietaryRestrictions(
      allergies: _selectedAllergies,
      preferences: _selectedPreferences,
      ingredientPreferences: _customIngredients,
    );

    // User user = (await LocalDB.getUser())!;

    //   LocalDB.saveUser(
    //     User(
    //       uid: "uid",
    //       name: ,
    //       dietaryRestrictions: dietaryRestrictions,
    //       uid: '',
    //       weight: null,
    //       height: null,
    //       goal: null,
    //       mealPlan: null,
    //       diningHallRank: [],
    //       age: null,
    //       gender: null,
    //     ),
    //   );

    widget.user.dietaryRestrictions = dietaryRestrictions;
    // final _userMacros = CalorieMacroCalculator.calculateMacros(
    //   age: widget.user.age,
    //   weightLbs: widget.user.weight.toDouble(),
    //   heightInches: widget.user.height.toDouble(),
    //   gender: widget.user.gender,
    //   goal: widget.user.goal,
    // );
    // double mealCalories = _userMacros.calories / 2;
    // double mealProtein = _userMacros.protein / 2;
    // double mealCarbs = _userMacros.carbs / 2;
    // double mealFat = _userMacros.fat / 2;
    // for (MealTime mealTime in MealTime.values) {
    //   // Run meal generation for all dining halls in parallel
    //   _diningHalls.forEach((diningHall) async {
    //     MealPlanner.generateDiningHallMeal(
    //       diningHall: diningHall,
    //       mealTime: mealTime,
    //       targetCalories: mealCalories,
    //       targetProtein: mealProtein,
    //       targetCarbs: mealCarbs,
    //       targetFat: mealFat,
    //       user: widget.user,
    //     );
    //   });
    // }

    if (widget.user.useMealPlanning) {
      if (widget.isEditing) {
        await LocalDatabase().deleteCurrentAndFutureMeals();
      } 
      MealPlanner.generateDayMealPlan(user: widget.user);
    }
    if (widget.isEditing) {
      Navigator.pop(context, widget.user);
      return;
    }

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => DiningHallRankingScreen(user: widget.user),
      ),
    );
  }

  void _skipAll() async {
    final emptyRestrictions = DietaryRestrictions(
      allergies: [],
      preferences: [],
      ingredientPreferences: [],
    );

    widget.user.dietaryRestrictions = emptyRestrictions;

    print("Getting new meal suggestions");
    // final _userMacros = CalorieMacroCalculator.calculateMacros(
    //   age: widget.user.age,
    //   weightLbs: widget.user.weight.toDouble(),
    //   heightInches: widget.user.height.toDouble(),
    //   gender: widget.user.gender,
    //   goal: widget.user.goal,
    // );
    // double mealCalories = _userMacros!.calories / 2;
    // double mealProtein = _userMacros!.protein / 2;
    // double mealCarbs = _userMacros!.carbs / 2;
    // double mealFat = _userMacros!.fat / 2;
    // for (MealTime mealTime in MealTime.values) {
    //   // Run meal generation for all dining halls in parallel
    //   _diningHalls.forEach((diningHall) async {
    //     MealPlanner.generateDiningHallMeal(
    //       diningHall: diningHall,
    //       mealTime: mealTime,
    //       targetCalories: mealCalories,
    //       targetProtein: mealProtein,
    //       targetCarbs: mealCarbs,
    //       targetFat: mealFat,
    //       user: widget.user,
    //     );
    //   });
    // }
    if (widget.user.useMealPlanning) {
      MealPlanner.generateDayMealPlan(user: widget.user);
    }

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => DiningHallRankingScreen(user: widget.user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DynamicStyling.getWhite(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: MediaQuery.of(context).padding.top,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dietary Preferences',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: DynamicStyling.getBlack(context),
              ),
            ),

            SizedBox(height: 16),
            Text(
              widget.isEditing
                  ? 'Update your dietary preferences and restrictions below.'
                  : 'Let\'s personalize your dining experience based on your dietary preferences and restrictions!',
              style: TextStyle(
                fontSize: 18,
                color: DynamicStyling.getDarkGrey(context),

                height: 1.4,
              ),
            ),

            SizedBox(height: 32),

            // Feature cards
            _buildFeatureCard(
              icon: Icons.warning,
              title: 'Food Allergies',
              description:
                  'Swipe through common allergens to identify what you need to avoid',
              color: Colors.red,
              onTap: () => _startAllergenFlow(),
            ),
            SizedBox(height: 20),

            _buildFeatureCard(
              icon: Icons.eco,
              title: 'Diet Preferences',
              description:
                  'Tell us about your lifestyle choices like vegan, vegetarian, or kosher',
              color: Colors.green,
              onTap: () => _startPreferenceFlow(),
            ),
            SizedBox(height: 20),

            _buildFeatureCard(
              icon: Icons.restaurant_menu,
              title: 'Custom Restrictions',
              description:
                  'Add specific ingredients you prefer to avoid like beef, pork, or mushrooms',
              color: Colors.orange,
              onTap: () => _startCustomIngredientsFlow(),
            ),
            SizedBox(height: 24),

            // Start journey button
            DefaultButton(
              text: Text(
                widget.isEditing ? 'Save Changes' : 'Continue',
                style: TextStyle(
                  color: DynamicStyling.getWhite(context),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                _completeSetup();
              },
            ),
            SizedBox(height: 8),

            Center(
              child: TextButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  Navigator.pop(context);
                },
                child: Text(
                  'Back',
                  style: TextStyle(
                    color: DynamicStyling.getDarkGrey(context),
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            // Progress indicator
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: List.generate(
            //     4, // Updated to match meal plan screen
            //     (index) => Container(
            //       margin: EdgeInsets.symmetric(horizontal: 4),
            //       width: index == 3
            //           ? 20
            //           : 8, // Changed to index == 3 for final step
            //       height: 8,
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(4),
            //         color: index == 3
            //             ? Colors.purple.shade400
            //             : DynamicStyling.getWhite(context).withOpacity(0.3),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: DefaultContainer(
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: DynamicStyling.getLightGrey(context),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: DynamicStyling.getBlack(context),
                size: 28,
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: DynamicStyling.getBlack(context),
                      letterSpacing: 0.3,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: DynamicStyling.getDarkGrey(context),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: DynamicStyling.getBlack(context),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
