import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/user_model.dart';
import 'package:boiler_fuel/widgets/animated_goal_option.dart';
import 'package:boiler_fuel/widgets/animated_button.dart';

// Make sure 'boiler_fuel' matches your project's package name
class MealPlanScreen extends StatefulWidget {
  final User user;

  MealPlanScreen({required this.user});

  @override
  _MealPlanScreenState createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen>
    with TickerProviderStateMixin {
  String? _selectedPlan;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _finish() {
    if (_selectedPlan != null) {
      widget.user.mealPlan = _selectedPlan;
      // Navigate to main app or show completion
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Color(0xFF271e37),
          title: Text('Setup Complete!', style: TextStyle(color: Colors.white)),
          content: Text('Welcome to BoilerFuel! Your preferences have been saved.',
              style: TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('Start Using App', style: TextStyle(color: Colors.amber)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF060010), Color(0xFF170d27)],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Choose your meal plan',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 32),
                  ...['10 Day', '14 Day', 'Unlimited'].map((plan) =>
                      AnimatedGoalOption(
                        text: plan,
                        isSelected: _selectedPlan == plan,
                        onTap: () => setState(() => _selectedPlan = plan),
                      )),
                  Spacer(),
                  AnimatedButton(
                    text: 'Finish Setup',
                    onTap: _finish,
                    isEnabled: _selectedPlan != null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}