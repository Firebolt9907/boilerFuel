import 'package:boiler_fuel/api/local_database.dart';
import 'package:boiler_fuel/constants.dart';
import 'package:boiler_fuel/planner.dart';
import 'package:boiler_fuel/screens/dietary_restrictions_screen.dart';
import 'package:boiler_fuel/screens/dining_hall_ranking_screen.dart';
import 'package:boiler_fuel/widgets/animated_button.dart';
import 'package:boiler_fuel/widgets/animated_dropdown_menu.dart';
import 'package:boiler_fuel/widgets/animated_goal_option.dart';
import 'package:boiler_fuel/widgets/animated_text_field.dart';
import 'package:boiler_fuel/widgets/animated_toggle.dart';
import 'package:boiler_fuel/widgets/titanium_container.dart';
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
  bool _offlineDietFeatures = true;
  bool _aiDietFeatures = false;
  MacroResult? _userMacros;

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
      _offlineDietFeatures = widget.user!.offlineDataFeatures;
      _aiDietFeatures = widget.user!.aiDataFeatures;
    }
    MacroResult result = CalorieMacroCalculator.calculateMacros(
      age: int.parse(
        _ageController.text.isNotEmpty ? _ageController.text : "0",
      ),
      weightLbs: double.parse(
        _weightController.text.isNotEmpty ? _weightController.text : "0",
      ),
      heightInches: double.parse(
        _heightController.text.isNotEmpty ? _heightController.text : "0",
      ),
      gender: _selectedGender ?? Gender.male,
      goal: _selectedGoal ?? Goal.maintain,
    );

    print("Initial macro calc: $result");
  }

  void _updateMacros() {
    if (_weightController.text.isNotEmpty &&
        _heightController.text.isNotEmpty &&
        _selectedGoal != null &&
        _ageController.text.isNotEmpty &&
        _selectedGender != null) {
      MacroResult result = CalorieMacroCalculator.calculateMacros(
        age: int.parse(_ageController.text),
        weightLbs: double.parse(_weightController.text),
        heightInches: double.parse(_heightController.text),
        gender: _selectedGender ?? Gender.male,
        goal: _selectedGoal ?? Goal.maintain,
      );
      print("Updated macro calc: $result");
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
    if (_nameController.text.isNotEmpty &&
        ((_heightController.text.isNotEmpty &&
                _selectedGoal != null &&
                _weightController.text.isNotEmpty &&
                _selectedGender != null &&
                _ageController.text.isNotEmpty) ||
            !_offlineDietFeatures)) {
      User user = User(
        uid: widget.user?.uid ?? '',
        name: _nameController.text,
        offlineDataFeatures: _offlineDietFeatures,
        aiDataFeatures: _aiDietFeatures,
        weight: int.tryParse(_weightController.text) ?? -1,
        height: int.tryParse(_heightController.text) ?? -1,
        goal: _selectedGoal ?? Goal.maintain,
        dietaryRestrictions:
            widget.user?.dietaryRestrictions ??
            DietaryRestrictions(
              allergies: [],
              preferences: [],
              ingredientPreferences: [],
            ),
        mealPlan: widget.user?.mealPlan ?? MealPlan.unset,
        diningHallRank: widget.user?.diningHallRank ?? [],
        age: int.tryParse(_ageController.text) ?? -1,
        gender: _selectedGender ?? Gender.na,
      );
      if (widget.user != null) {
        LocalDatabase().saveUser(user);
        await LocalDatabase().deleteCurrentAndFutureMeals();
        if (widget.user!.aiDataFeatures) {
          MealPlanner.generateDayMealPlan(user: user);
        }
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
                      AnimatedSwitch(
                        text: "Offline Diet Features",
                        onTap: (bool value) {
                          setState(() {
                            _offlineDietFeatures = value;
                          });
                        },
                        isEnabled: true,
                        initialValue: _offlineDietFeatures,
                      ),

                      AnimatedOpacity(
                        duration: Duration(milliseconds: 100),
                        curve: Curves.easeInOut,
                        opacity: _offlineDietFeatures ? 1 : 0.5,
                        child: Container(
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
                            spacing: 0,
                            children: [
                              Text(
                                'Nutritional Formula Inputs',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Text(
                                'None of these values will leave your device',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
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
                              SizedBox(height: 20),
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
                      ),
                      AnimatedOpacity(
                        duration: Duration(milliseconds: 100),
                        opacity: _offlineDietFeatures ? 1 : 0.5,
                        child: AnimatedSwitch(
                          text: "AI Meal Planning",
                          onTap: (bool value) {
                            setState(() {
                              _aiDietFeatures = value;
                              if (_aiDietFeatures) {
                                _userMacros =
                                    CalorieMacroCalculator.calculateMacros(
                                      age: int.parse(
                                        _ageController.text.isNotEmpty
                                            ? _ageController.text
                                            : "0",
                                      ),
                                      weightLbs: double.parse(
                                        _weightController.text.isNotEmpty
                                            ? _weightController.text
                                            : "0",
                                      ),
                                      heightInches: double.parse(
                                        _heightController.text.isNotEmpty
                                            ? _heightController.text
                                            : "0",
                                      ),
                                      goal: _selectedGoal ?? Goal.maintain,
                                      gender: _selectedGender ?? Gender.male,
                                    );
                              } else {
                                _userMacros = null;
                              }
                            });
                          },
                          isEnabled:
                              _offlineDietFeatures &&
                              _weightController.text.isNotEmpty &&
                              _heightController.text.isNotEmpty &&
                              _selectedGoal != null &&
                              _nameController.text.isNotEmpty &&
                              _selectedGender != null &&
                              _ageController.text.isNotEmpty,
                          initialValue: _aiDietFeatures,
                        ),
                      ),

                      _userMacros != null
                          ? _buildMacrosOverview(_userMacros!)
                          : Container(),

                      SizedBox(height: 60),

                      // Enhanced continue button
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) => Transform.scale(
                          scale:
                              _nameController.text.isNotEmpty &&
                                  ((_heightController.text.isNotEmpty &&
                                          _selectedGoal != null &&
                                          _weightController.text.isNotEmpty &&
                                          _selectedGender != null &&
                                          _ageController.text.isNotEmpty) ||
                                      !_offlineDietFeatures)
                              ? 1.0
                              : 0.98,
                          child: AnimatedButton(
                            text:
                                _nameController.text.isNotEmpty &&
                                    ((_heightController.text.isNotEmpty &&
                                            _selectedGoal != null &&
                                            _weightController.text.isNotEmpty &&
                                            _selectedGender != null &&
                                            _ageController.text.isNotEmpty) ||
                                        !_offlineDietFeatures)
                                ? widget.user == null
                                      ? 'Continue Your Journey'
                                      : 'Update Info'
                                : 'Enter your info',
                            onTap: _continue,
                            isEnabled:
                                _nameController.text.isNotEmpty &&
                                ((_heightController.text.isNotEmpty &&
                                        _selectedGoal != null &&
                                        _weightController.text.isNotEmpty &&
                                        _selectedGender != null &&
                                        _ageController.text.isNotEmpty) ||
                                    !_offlineDietFeatures),
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

  Widget _buildMacrosOverview(MacroResult _userMacros) {
    return TitaniumContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics, color: Colors.cyan.shade300, size: 24),
              SizedBox(width: 12),
              Text(
                'Data To Be Uploaded',
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
