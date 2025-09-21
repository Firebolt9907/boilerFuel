import 'package:boiler_fuel/local_storage.dart';
import 'package:boiler_fuel/screens/dining_hall_ranking_screen.dart';
import 'package:boiler_fuel/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/animated_button.dart';
import 'allergen_swipe_screen.dart';
import 'diet_preference_swipe_screen.dart';
import 'custom_ingredients_screen.dart';
import 'dart:math' as math;

class DietaryRestrictionsScreen extends StatefulWidget {
  final User user;

  const DietaryRestrictionsScreen({Key? key, required this.user})
    : super(key: key);

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
              8,
              (index) => Positioned(
                left: (index * 50.0) % MediaQuery.of(context).size.width,
                top: (index * 90.0) % MediaQuery.of(context).size.height,
                child: AnimatedBuilder(
                  animation: _floatingAnimation,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(
                      math.sin(_floatingAnimation.value / 20 + index) * 12,
                      _floatingAnimation.value +
                          math.cos(_floatingAnimation.value / 16 + index) * 8,
                    ),
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) => Transform.scale(
                        scale: _pulseAnimation.value * (0.05 + index * 0.02),
                        child: Container(
                          width: 8 + (index * 2),
                          height: 8 + (index * 2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: [
                              Colors.red.withOpacity(0.12),
                              Colors.orange.withOpacity(0.1),
                              Colors.yellow.withOpacity(0.09),
                              Colors.green.withOpacity(0.08),
                              Colors.blue.withOpacity(0.07),
                              Colors.indigo.withOpacity(0.06),
                              Colors.purple.withOpacity(0.05),
                              Colors.pink.withOpacity(0.04),
                            ][index],
                            boxShadow: [
                              BoxShadow(
                                color: [
                                  Colors.red,
                                  Colors.orange,
                                  Colors.yellow,
                                  Colors.green,
                                  Colors.blue,
                                  Colors.indigo,
                                  Colors.purple,
                                  Colors.pink,
                                ][index].withOpacity(0.15),
                                blurRadius: 8,
                                spreadRadius: 1,
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
            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back button
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      SizedBox(height: 32),

                      // Title section
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.red.shade300,
                            Colors.orange.shade200,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: Text(
                          'Dietary Preferences',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.white.withOpacity(0.05),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'Let\'s personalize your dining experience with a fun swipe-through setup!',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white.withOpacity(0.85),
                            fontWeight: FontWeight.w300,
                            height: 1.4,
                          ),
                        ),
                      ),
                      SizedBox(height: 48),

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
                      SizedBox(height: 48),

                      // Start journey button
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) => Transform.scale(
                          scale: _pulseAnimation.value,
                          child: AnimatedButton(
                            text: 'Save',
                            onTap: () {
                              _completeSetup();
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Center(
                        child: TextButton(
                          onPressed: _skipAll,
                          child: Text(
                            'Skip for now',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
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
                      //             : Colors.white.withOpacity(0.3),
                      //       ),
                      //     ),
                      //   ),
                      // ),
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

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) => Transform.scale(
          scale: 1.0 + (_pulseAnimation.value - 1.0) * 0.02,
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white.withOpacity(0.05),
              border: Border.all(color: color.withOpacity(0.3), width: 1),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.1),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withOpacity(0.2),
                    border: Border.all(color: color.withOpacity(0.4), width: 2),
                  ),
                  child: Icon(icon, color: color.withOpacity(0.9), size: 28),
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
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.7),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: color.withOpacity(0.6),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
