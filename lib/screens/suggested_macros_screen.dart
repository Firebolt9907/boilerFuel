import 'package:boiler_fuel/api/local_database.dart';
import 'package:boiler_fuel/api/shared_preferences.dart';
import 'package:boiler_fuel/main.dart';
import 'package:boiler_fuel/planner.dart';
import 'package:boiler_fuel/screens/dietary_restrictions_screen.dart';
import 'package:boiler_fuel/screens/dining_hall_ranking_screen.dart';
import 'package:boiler_fuel/screens/home_screen.dart';
import 'package:boiler_fuel/widgets/default_button.dart';
import 'package:boiler_fuel/widgets/default_container.dart';
import 'package:boiler_fuel/widgets/default_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';
import '../widgets/animated_button.dart';
import 'allergen_swipe_screen.dart';
import 'diet_preference_swipe_screen.dart';
import 'custom_ingredients_screen.dart';
import 'dart:math' as math;

class SuggestedMacrosScreen extends StatefulWidget {
  final User user;
  final bool isEditing;

  const SuggestedMacrosScreen({
    Key? key,
    required this.user,
    this.isEditing = false,
  }) : super(key: key);

  @override
  _SuggestedMacrosScreenState createState() => _SuggestedMacrosScreenState();
}

class _SuggestedMacrosScreenState extends State<SuggestedMacrosScreen>
    with TickerProviderStateMixin {
  TextEditingController caloriesController = TextEditingController();
  TextEditingController proteinController = TextEditingController();
  TextEditingController carbsController = TextEditingController();
  TextEditingController fatController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // Calculate suggested macros based on user info
    MacroResult result = CalorieMacroCalculator.calculateMacros(
      age: widget.user.age,
      weightLbs: widget.user.weight.toDouble(),
      heightInches: widget.user.height.toDouble(),
      gender: widget.user.gender,
      goal: widget.user.goal,
    );
    caloriesController.text = result.calories.toStringAsFixed(0);
    proteinController.text = result.protein.toStringAsFixed(0);
    carbsController.text = result.carbs.toStringAsFixed(0);
    fatController.text = result.fat.toStringAsFixed(0);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _completeSetup() async {
    HapticFeedback.mediumImpact();
    if (widget.user.useDietary) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => DietaryRestrictionsScreen(user: widget.user),
        ),
      );
    } else {
      MealPlanner.generateDayMealPlan(user: widget.user);

      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => DiningHallRankingScreen(user: widget.user),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
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
                'Suggested Macros',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              SizedBox(height: 16),
              Text(
                widget.isEditing
                    ? 'Review and adjust your suggested daily macronutrient intake based on your profile.'
                    : 'Based on your profile, here are your suggested daily macronutrient intakes. You can adjust them if needed.',
                style: TextStyle(
                  fontSize: 18,
                  color: styling.darkGray,

                  height: 1.4,
                ),
              ),

              SizedBox(height: 32),
              // Macro cards
              _buildFeatureCard(
                icon: Icons.local_fire_department,
                title: 'Calories (cal)',
                description: 'Total daily calorie intake',
                controller: caloriesController,
                color: Colors.orange,
                onTap: () {
                  // Optionally implement editing functionality
                },
              ),
              SizedBox(height: 16),
              _buildFeatureCard(
                icon: Icons.fitness_center,
                title: 'Protein (g)',
                description: 'Daily protein intake in grams',
                controller: proteinController,
                color: Colors.blue,
                onTap: () {
                  // Optionally implement editing functionality
                },
              ),
              SizedBox(height: 16),
              _buildFeatureCard(
                icon: Icons.grain,
                title: 'Carbohydrates (g)',
                description: 'Daily carbohydrate intake in grams',
                controller: carbsController,
                color: Colors.green,
                onTap: () {
                  // Optionally implement editing functionality
                },
              ),
              SizedBox(height: 16),
              _buildFeatureCard(
                icon: Icons.opacity,
                title: 'Fats (g)',
                description: 'Daily fat intake in grams',
                controller: fatController,
                color: Colors.purple,
                onTap: () {
                  // Optionally implement editing functionality
                },
              ),
              SizedBox(height: 24),

              // Start journey button
              DefaultButton(
                text: Text(
                  widget.isEditing ? 'Save Changes' : 'Continue',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  _completeSetup();
                },
              ),
              if (!widget.isEditing) SizedBox(height: 8),
              if (!widget.isEditing)
                Center(
                  child: TextButton(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Back',
                      style: TextStyle(color: styling.darkGray, fontSize: 16),
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
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
    required TextEditingController controller,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: DefaultContainer(
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xffe5e5e7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.black, size: 28),
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
                      color: Colors.black,
                      letterSpacing: 0.3,
                    ),
                  ),
                  SizedBox(height: 8),
                  DefaultTextField(controller: controller),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: styling.darkGray,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
