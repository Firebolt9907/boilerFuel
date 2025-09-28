import 'package:boiler_fuel/api/local_database.dart';
import 'package:boiler_fuel/constants.dart';
import 'package:boiler_fuel/planner.dart';
import 'package:boiler_fuel/screens/dietary_restrictions_screen.dart';
import 'package:boiler_fuel/screens/dining_hall_ranking_screen.dart';
import 'package:boiler_fuel/widgets/animated_button.dart';
import 'package:boiler_fuel/widgets/animated_dropdown_menu.dart';
import 'package:boiler_fuel/widgets/animated_goal_option.dart';
import 'package:boiler_fuel/widgets/animated_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class UserInfoScreen extends StatefulWidget {
  final User? user;
  UserInfoScreen({Key? key, this.user}) : super(key: key);

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen>
    with TickerProviderStateMixin {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  Goal? _selectedGoal;
  late AnimationController _animationController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;
  Gender? _selectedGender;

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

    if (widget.user != null) {
      _nameController.text = widget.user!.name;
      _weightController.text = widget.user!.weight.toString();
      _heightController.text = widget.user!.height.toString();
      _selectedGoal = widget.user!.goal;
      _ageController.text = widget.user!.age.toString();
      _selectedGender = widget.user!.gender;
    }
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

  void _continue() async {
    if (_weightController.text.isNotEmpty &&
        _heightController.text.isNotEmpty &&
        _selectedGoal != null &&
        _nameController.text.isNotEmpty &&
        _selectedGender != null &&
        _ageController.text.isNotEmpty) {
      User user = User(
        uid: widget.user?.uid ?? '',
        name: _nameController.text,
        weight: int.tryParse(_weightController.text)!,
        height: int.tryParse(_heightController.text)!,
        goal: _selectedGoal!,
        dietaryRestrictions:
            widget.user?.dietaryRestrictions ??
            DietaryRestrictions(
              allergies: [],
              preferences: [],
              ingredientPreferences: [],
            ),
        mealPlan: widget.user?.mealPlan ?? MealPlan.unset,
        diningHallRank: widget.user?.diningHallRank ?? [],
        age: int.tryParse(_ageController.text)!,
        gender: _selectedGender!,
      );
      if (widget.user != null) {
        LocalDatabase().saveUser(user);
        await LocalDatabase().deleteCurrentAndFutureMeals();
        MealPlanner.generateDayMealPlan(user: user);
        Navigator.pop(context, user);
        return;
      }
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => DietaryRestrictionsScreen(user: user),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
              FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 24.0,
                    right: 24.0,
                    top: 24.0 + MediaQuery.of(context).padding.top,
                    bottom:
                        24.0 +
                        MediaQuery.of(context).padding.bottom +
                        MediaQuery.of(context).viewInsets.bottom,
                  ),
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
                          widget.user == null
                              ? 'Tell us about yourself'
                              : 'Update your info',
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
                          widget.user == null
                              ? 'Help us personalize your experience'
                              : 'Make changes to your personal info',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      AnimatedTextField(
                        controller: _nameController,
                        label: 'Name',
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: 12),
                      AnimatedTextField(
                        controller: _ageController,
                        label: 'Age',
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 12),
                      AnimatedDropdownMenu<Gender>(
                        value: _selectedGender,
                        label: "Sex",
                        hint: "Choose your sex",
                        items: [
                          DropdownMenuItem(
                            value: Gender.male,
                            child: Text("Male"),
                          ),
                          DropdownMenuItem(
                            value: Gender.female,
                            child: Text("Female"),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                      ),
                      SizedBox(height: 12),
                      // Enhanced input fields
                      AnimatedTextField(
                        controller: _weightController,
                        label: 'Weight (lbs)',
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 12),
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
                                isSelected: _selectedGoal.toString() == goal,
                                onTap: () => setState(
                                  () => _selectedGoal = Goal.fromString(goal),
                                ),
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
                                  _selectedGoal != null &&
                                  _nameController.text.isNotEmpty &&
                                  _selectedGender != null &&
                                  _ageController.text.isNotEmpty)
                              ? 1.0
                              : 0.98,
                          child: AnimatedButton(
                            text:
                                _weightController.text.isNotEmpty &&
                                    _heightController.text.isNotEmpty &&
                                    _selectedGoal != null &&
                                    _nameController.text.isNotEmpty &&
                                    _selectedGender != null &&
                                    _ageController.text.isNotEmpty
                                ? widget.user == null
                                      ? 'Continue Your Journey'
                                      : 'Update Info'
                                : 'Enter your info',
                            onTap: _continue,
                            isEnabled:
                                _weightController.text.isNotEmpty &&
                                _heightController.text.isNotEmpty &&
                                _selectedGoal != null &&
                                _nameController.text.isNotEmpty &&
                                _selectedGender != null &&
                                _ageController.text.isNotEmpty,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Progress indicator
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: List.generate(
                      //     3,
                      //     (index) => Container(
                      //       margin: EdgeInsets.symmetric(horizontal: 4),
                      //       width: index == 0 ? 20 : 8,
                      //       height: 8,
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(4),
                      //         color: index == 0
                      //             ? Colors.blue.shade400
                      //             : Colors.white.withOpacity(0.3),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
