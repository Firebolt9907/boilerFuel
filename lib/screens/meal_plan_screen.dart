import 'package:boiler_fuel/api/local_database.dart';
import 'package:boiler_fuel/constants.dart';
import 'package:boiler_fuel/api/shared_preferences.dart';
import 'package:boiler_fuel/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:boiler_fuel/widgets/animated_goal_option.dart';
import 'package:boiler_fuel/widgets/animated_button.dart';
import 'dietary_restrictions_screen.dart';
import 'home_screen.dart';
import 'dart:math' as math;

// Make sure 'boiler_fuel' matches your project's package name
class MealPlanScreen extends StatefulWidget {
  final User user;
  final bool isEditing;

  MealPlanScreen({required this.user, this.isEditing = false});

  @override
  _MealPlanScreenState createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen>
    with TickerProviderStateMixin {
  String? _selectedPlan;
  late AnimationController _animationController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _selectedPlan = widget.user.mealPlan.toString() + " Plan";
    }
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _floatingController = AnimationController(
      duration: Duration(milliseconds: 3500),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 2200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _floatingAnimation = Tween<double>(begin: -18.0, end: 18.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );
    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.3).animate(
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

  void _finish() async {
    if (_selectedPlan != null) {
      // Convert string to MealPlan enum
      MealPlan mealPlan;
      switch (_selectedPlan) {
        case '10 Day Plan':
          mealPlan = MealPlan.TenDay;
          break;
        case '14 Day Plan':
          mealPlan = MealPlan.FourteenDay;
          break;
        case 'Unlimited Plan':
          mealPlan = MealPlan.Unlimited;
          break;
        case '7 Day Plan':
          mealPlan = MealPlan.SevenDay;
          break;
        case '50 Block':
          mealPlan = MealPlan.FiftyBlock;
          break;
        case '80 Block':
          mealPlan = MealPlan.EightyBlock;
        default:
          mealPlan = MealPlan.Unlimited; // Default fallback
          break;
      }

      widget.user.mealPlan = mealPlan;
      await LocalDatabase().saveUser(widget.user);
      if (widget.isEditing) {
        Navigator.pop(context, widget.user);
        return;
      }

      // Navigate to dietary restrictions flow
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(user: widget.user)),
        (route) => false,
      );
    }
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
              5,
              (index) => Positioned(
                left: (index * 75.0) % MediaQuery.of(context).size.width,
                top: (index * 130.0) % MediaQuery.of(context).size.height,
                child: AnimatedBuilder(
                  animation: _floatingAnimation,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(
                      math.sin(_floatingAnimation.value / 15 + index) * 10,
                      _floatingAnimation.value +
                          math.cos(_floatingAnimation.value / 12 + index) * 6,
                    ),
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) => Transform.scale(
                        scale: _pulseAnimation.value * (0.15 + index * 0.06),
                        child: Container(
                          width: 12 + (index * 6),
                          height: 12 + (index * 6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: [
                              Colors.orange.withOpacity(0.1),
                              Colors.yellow.withOpacity(0.08),
                              Colors.green.withOpacity(0.06),
                              Colors.blue.withOpacity(0.04),
                              Colors.purple.withOpacity(0.03),
                            ][index],
                            boxShadow: [
                              BoxShadow(
                                color: [
                                  Colors.orange,
                                  Colors.yellow,
                                  Colors.green,
                                  Colors.blue,
                                  Colors.purple,
                                ][index].withOpacity(0.15),
                                blurRadius: 6,
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
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back button with modern styling
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

                      // Enhanced title with emoji and styling
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.orange.shade300,
                            Colors.yellow.shade200,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: Text(
                          widget.isEditing
                              ? 'Update Your Meal Plan'
                              : 'What\'s Your Meal Plan',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white.withOpacity(0.05),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          widget.isEditing
                              ? 'Update your current meal plan'
                              : 'Select your current meal plan',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      SizedBox(height: 48),

                      // Enhanced meal plan options
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white.withOpacity(0.05),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.15),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Available Plans',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: 20),
                            ...[
                              '7 Day Plan',
                              '10 Day Plan',
                              '14 Day Plan',
                              'Unlimited Plan',
                              '50 Block',
                              "80 Block",
                            ].map(
                              (plan) => Container(
                                margin: EdgeInsets.only(bottom: 12),
                                child: AnimatedGoalOption(
                                  text: plan,
                                  isSelected: _selectedPlan == plan,
                                  onTap: () =>
                                      setState(() => _selectedPlan = plan),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 40),

                      // Enhanced finish button
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) => Transform.scale(
                          scale: (_selectedPlan != null) ? 1.0 : 0.98,
                          child: AnimatedButton(
                            text: (_selectedPlan == null)
                                ? 'Select a meal plan'
                                : widget.isEditing
                                ? 'Update Plan'
                                : 'Get Started',
                            onTap: _finish,
                            isEnabled: _selectedPlan != null,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Progress indicator
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: List.generate(
                      //     4, // Changed from 3 to 4 to show there's another step
                      //     (index) => Container(
                      //       margin: EdgeInsets.symmetric(horizontal: 4),
                      //       width: index == 2 ? 20 : 8,
                      //       height: 8,
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(4),
                      //         color: index == 2
                      //             ? Colors.green.shade400
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
}
