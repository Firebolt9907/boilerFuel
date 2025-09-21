import 'package:boiler_fuel/models/user_model.dart';
import 'package:boiler_fuel/screens/dining_hall_ranking_screen.dart';
import 'package:boiler_fuel/widgets/animated_button.dart';
import 'package:boiler_fuel/widgets/animated_goal_option.dart';
import 'package:boiler_fuel/widgets/animated_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class UserInfoScreen extends StatefulWidget {
  final User user;

  UserInfoScreen({required this.user});

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen>
    with TickerProviderStateMixin {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  String? _selectedGoal;
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
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _floatingController = AnimationController(
      duration: Duration(milliseconds: 4000),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 2500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _floatingAnimation = Tween<double>(begin: -15.0, end: 15.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );
    _pulseAnimation = Tween<double>(begin: 0.7, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    Future.delayed(Duration(milliseconds: 400), () {
      _floatingController.repeat(reverse: true);
      _pulseController.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _animationController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _continue() {
    if (_weightController.text.isNotEmpty &&
        _heightController.text.isNotEmpty &&
        _selectedGoal != null) {
      widget.user.weight = double.tryParse(_weightController.text);
      widget.user.height = double.tryParse(_heightController.text);
      widget.user.eatingHabits = _selectedGoal;

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
              4,
              (index) => Positioned(
                left: (index * 90.0) % MediaQuery.of(context).size.width,
                top: (index * 150.0) % MediaQuery.of(context).size.height,
                child: AnimatedBuilder(
                  animation: _floatingAnimation,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(
                      math.sin(_floatingAnimation.value / 12 + index) * 12,
                      _floatingAnimation.value +
                          math.cos(_floatingAnimation.value / 10 + index) * 8,
                    ),
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) => Transform.scale(
                        scale: _pulseAnimation.value * (0.2 + index * 0.08),
                        child: Container(
                          width: 15 + (index * 8),
                          height: 15 + (index * 8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: [
                              Colors.blue.withOpacity(0.08),
                              Colors.cyan.withOpacity(0.06),
                              Colors.teal.withOpacity(0.04),
                              Colors.purple.withOpacity(0.03),
                            ][index],
                            boxShadow: [
                              BoxShadow(
                                color: [
                                  Colors.blue,
                                  Colors.cyan,
                                  Colors.teal,
                                  Colors.purple,
                                ][index].withOpacity(0.1),
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
                      SizedBox(height: 16),

                      // Enhanced title with styling (moved higher)
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
                          'Tell us about yourself',
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
                          'Help us personalize your experience',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      SizedBox(height: 40),

                      // Enhanced input fields
                      AnimatedTextField(
                        controller: _weightController,
                        label: 'Weight (lbs)',
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 24),
                      AnimatedTextField(
                        controller: _heightController,
                        label: 'Height (inches)',
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 40),

                      // Goal selection section
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
                              'Health Goal',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: 16),
                            ...['Cutting', 'Maintain', 'Bulking'].map(
                              (goal) => AnimatedGoalOption(
                                text: goal,
                                isSelected: _selectedGoal == goal,
                                onTap: () =>
                                    setState(() => _selectedGoal = goal),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 60),

                      // Enhanced continue button
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) => Transform.scale(
                          scale:
                              (_weightController.text.isNotEmpty &&
                                  _heightController.text.isNotEmpty &&
                                  _selectedGoal != null)
                              ? 1.0
                              : 0.98,
                          child: AnimatedButton(
                            text: 'Continue Your Journey',
                            onTap: _continue,
                            isEnabled:
                                _weightController.text.isNotEmpty &&
                                _heightController.text.isNotEmpty &&
                                _selectedGoal != null,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Progress indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                          (index) => Container(
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            width: index == 0 ? 20 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: index == 0
                                  ? Colors.blue.shade400
                                  : Colors.white.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ),
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
