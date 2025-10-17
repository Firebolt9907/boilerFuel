import 'package:boiler_fuel/api/local_database.dart';
import 'package:boiler_fuel/constants.dart';
import 'package:boiler_fuel/main.dart';
import 'package:boiler_fuel/planner.dart';
import 'package:boiler_fuel/screens/dietary_restrictions_screen.dart';
import 'package:boiler_fuel/screens/dining_hall_ranking_screen.dart';
import 'package:boiler_fuel/screens/suggested_macros_screen.dart';
import 'package:boiler_fuel/widgets/animated_button.dart';
import 'package:boiler_fuel/widgets/animated_dropdown_menu.dart';
import 'package:boiler_fuel/widgets/animated_goal_option.dart';
import 'package:boiler_fuel/widgets/animated_text_field.dart';
import 'package:boiler_fuel/widgets/animated_toggle.dart';
import 'package:boiler_fuel/widgets/default_button.dart';
import 'package:boiler_fuel/widgets/default_dropdown_menu.dart';
import 'package:boiler_fuel/widgets/default_goal_option.dart';
import 'package:boiler_fuel/widgets/default_text_field.dart';
import 'package:boiler_fuel/widgets/titanium_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class UserInfoScreen extends StatefulWidget {
  final User? user;
  final bool? useMealPlanning;
  final bool? useDietary;

  UserInfoScreen({Key? key, this.user, this.useDietary, this.useMealPlanning})
    : super(key: key);

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
  bool useDietary = true;
  bool useMealPlanning = true;
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
      _weightController.text = checkNulls(widget.user!.weight.toString());
      _heightController.text = checkNulls(widget.user!.height.toString());
      _selectedGoal = widget.user!.goal;
      _ageController.text = checkNulls(widget.user!.age.toString());
      _selectedGender = widget.user!.gender != Gender.na
          ? widget.user!.gender
          : null;
      useDietary = widget.user!.useDietary;
      useMealPlanning = widget.user!.useMealPlanning;
    } else {
      useDietary = widget.useDietary ?? true;
      useMealPlanning = widget.useMealPlanning ?? true;
    }
  }

  String checkNulls(String input) {
    if (input == "-1") {
      return "";
    }
    return input;
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
    HapticFeedback.mediumImpact();
    MacroResult result = useMealPlanning
        ? CalorieMacroCalculator.calculateMacros(
            age: int.parse(_ageController.text),
            weightLbs: double.parse(_weightController.text),
            heightInches: double.parse(_heightController.text),
            gender: _selectedGender ?? Gender.male,
            goal: _selectedGoal ?? Goal.maintain,
          )
        : MacroResult(
            calories: -1,
            protein: -1,
            carbs: -1,
            fat: -1,
            bmr: -1,
            tdee: -1,
          );
    User user = User(
      uid: widget.user?.uid ?? '',
      name: _nameController.text,
      useDietary: useDietary,
      useMealPlanning: useMealPlanning,
      macros: result,

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
      if (!useMealPlanning) {
        Navigator.pop(context, user);
        return;
      } else {
        User? newU = await Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) =>
                SuggestedMacrosScreen(user: user, isEditing: true),
          ),
        );
        Navigator.pop(context, newU);
        return;
      }
    }
    if (!useMealPlanning) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => DietaryRestrictionsScreen(user: user),
        ),
      );
    } else {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => SuggestedMacrosScreen(user: user),
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
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Main content
            SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                top: MediaQuery.of(context).padding.top,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Enhanced title with styling (moved higher)
                  Text(
                    widget.user == null
                        ? 'Tell us about yourself'
                        : 'Update your info',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 0.5,
                    ),
                  ),

                  SizedBox(height: 8),
                  Text(
                    widget.user == null
                        ? 'Help us personalize your experience'
                        : 'Make changes to your personal info',
                    style: TextStyle(
                      fontSize: 16,
                      color: styling.darkGray,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      letterSpacing: 0.5,
                    ),
                  ),
                  DefaultTextField(
                    controller: _nameController,
                    hint: 'Enter your name',
                    keyboardType: TextInputType.text,
                    onChanged: (s) {
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 12),
                  if (useMealPlanning) ...[
                    Text(
                      'Age',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        letterSpacing: 0.5,
                      ),
                    ),
                    DefaultTextField(
                      controller: _ageController,
                      hint: 'Enter your age',
                      keyboardType: TextInputType.number,
                      onChanged: (s) {
                        setState(() {});
                      },
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Sex',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        letterSpacing: 0.5,
                      ),
                    ),
                    DefaultDropdownMenu<Gender>(
                      value: _selectedGender,
                      label: "Sex",
                      hint: "Choose your sex",
                      items: [
                        DropdownMenuItem(
                          value: Gender.male,
                          child: Text(
                            "Male",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        DropdownMenuItem(
                          value: Gender.female,
                          child: Text(
                            "Female",
                            style: TextStyle(color: Colors.black),
                          ),
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
                    Text(
                      'Weight',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        letterSpacing: 0.5,
                      ),
                    ),
                    DefaultTextField(
                      controller: _weightController,
                      hint: 'Enter your weight (lbs)',
                      keyboardType: TextInputType.number,
                      onChanged: (s) {
                        setState(() {});
                      },
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Height',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        letterSpacing: 0.5,
                      ),
                    ),
                    DefaultTextField(
                      controller: _heightController,
                      hint: 'Enter your height (inches)',
                      keyboardType: TextInputType.number,
                      onChanged: (s) {
                        setState(() {});
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Health Goal',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 16),
                    ...['Cutting', 'Maintain', 'Bulking'].map(
                      (goal) => DefaultGoalOption(
                        text: goal,
                        isSelected: _selectedGoal.toString() == goal,
                        onTap: () {
                          setState(() => _selectedGoal = Goal.fromString(goal));
                        },
                      ),
                    ),
                  ],
                  // Enhanced continue button
                  DefaultButton(
                    text:
                        _nameController.text.isNotEmpty &&
                            ((_heightController.text.isNotEmpty &&
                                    _selectedGoal != null &&
                                    _weightController.text.isNotEmpty &&
                                    _selectedGender != null &&
                                    _ageController.text.isNotEmpty) ||
                                !useMealPlanning)
                        ? widget.user == null
                              ? Text(
                                  'Continue',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Next',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                )
                        : Text(
                            'Continue',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                    onTap: _continue,
                    isEnabled:
                        _nameController.text.isNotEmpty &&
                        ((_heightController.text.isNotEmpty &&
                                _selectedGoal != null &&
                                _weightController.text.isNotEmpty &&
                                _selectedGender != null &&
                                _ageController.text.isNotEmpty) ||
                            !useMealPlanning),
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
          ],
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
