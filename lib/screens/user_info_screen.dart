import 'package:boiler_fuel/screens/activity_level_screen.dart';
import 'package:boiler_fuel/styling.dart';
import 'package:boiler_fuel/api/local_database.dart';
import 'package:boiler_fuel/constants.dart';
// Removed unused: main.dart
import 'package:boiler_fuel/planner.dart';
import 'package:boiler_fuel/screens/dietary_restrictions_screen.dart';
// Removed unused: dining_hall_ranking_screen.dart
import 'package:boiler_fuel/screens/suggested_macros_screen.dart';
// Removed unused animated widget imports
import 'package:boiler_fuel/widgets/default_button.dart';
import 'package:boiler_fuel/widgets/default_dropdown_menu.dart';
import 'package:boiler_fuel/widgets/default_goal_option.dart';
import 'package:boiler_fuel/widgets/default_text_field.dart';
// Removed unused titanium_container import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Removed unused math import

class UserInfoScreen extends StatefulWidget {
  final User? user;
  final bool? useMealPlanning;
  final bool? useDietary;
  final ActivityLevel? activityLevel;
  final double? weeklyChangeLbs;

  UserInfoScreen({
    Key? key,
    this.user,
    this.useDietary,
    this.useMealPlanning,
    this.activityLevel,
    this.weeklyChangeLbs,
  }) : super(key: key);

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
  Gender? _selectedGender;
  bool useDietary = true;
  bool useMealPlanning = true;
  ActivityLevel? _selectedActivityLevel;
  double? _weeklyChangeLbs; // negative for cut, positive for bulk
  PageController? _pacePageController;
  int _paceIndex = 0; // 0 = gentle/lean, 1 = aggressive

  @override
  void initState() {
    super.initState();

    if (widget.user != null) {
      _nameController.text = widget.user!.name;
      _weightController.text = checkNulls(widget.user!.weight.toString());
      _heightController.text = checkNulls(widget.user!.height.toString());
      _selectedGoal = widget.user!.goal;
      _ageController.text = checkNulls(widget.user!.age.toString());
      _selectedGender = widget.user!.gender != Gender.na
          ? widget.user!.gender
          : null;
      _selectedActivityLevel = widget.user!.activityLevel;
      useDietary = widget.user!.useDietary;
      useMealPlanning = widget.user!.useMealPlanning;
    } else {
      useDietary = widget.useDietary ?? true;
      useMealPlanning = widget.useMealPlanning ?? true;
      _selectedActivityLevel = widget.activityLevel ?? ActivityLevel.sedentary;
    }

    _weeklyChangeLbs = widget.weeklyChangeLbs;
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
    _pacePageController?.dispose();
    super.dispose();
  }

  void _continue() async {
    HapticFeedback.mediumImpact();
    // If user still didn't pick a pace and goal requires it, default gently
    if (_weeklyChangeLbs == null) {
      if ((_selectedGoal ?? Goal.maintain) == Goal.lose) {
        _weeklyChangeLbs = -0.5;
      } else if ((_selectedGoal ?? Goal.maintain) == Goal.gain) {
        _weeklyChangeLbs = 0.5;
      }
    }

    MacroResult result = useMealPlanning
        ? CalorieMacroCalculator.calculateMacros(
            age: int.parse(_ageController.text),
            weightLbs: double.parse(_weightController.text),
            heightInches: double.parse(_heightController.text),
            gender: _selectedGender ?? Gender.male,
            goal: _selectedGoal ?? Goal.maintain,
            activityLevel: _selectedActivityLevel ?? ActivityLevel.sedentary,
            weeklyChangeLbs: (_selectedGoal == Goal.maintain)
                ? null
                : _weeklyChangeLbs,
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
      activityLevel: _selectedActivityLevel ?? ActivityLevel.sedentary,
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
                ActivityLevelScreen(user: user, isEditing: true),
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
          builder: (context) => ActivityLevelScreen(user: user),
        ),
      );
    }
  }

  // Removed popup-based pace selection; using swipe UI instead.

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: DynamicStyling.getWhite(context),
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
                      color: DynamicStyling.getBlack(context),
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
                      color: DynamicStyling.getDarkGrey(context),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: DynamicStyling.getBlack(context),
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
                        color: DynamicStyling.getBlack(context),
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
                        color: DynamicStyling.getBlack(context),
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
                            style: TextStyle(
                              color: DynamicStyling.getBlack(context),
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: Gender.female,
                          child: Text(
                            "Female",
                            style: TextStyle(
                              color: DynamicStyling.getBlack(context),
                            ),
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
                        color: DynamicStyling.getBlack(context),
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
                        color: DynamicStyling.getBlack(context),
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
                        color: DynamicStyling.getBlack(context),
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 16),
                    ...['Cutting', 'Maintain', 'Bulking'].map(
                      (goal) => DefaultGoalOption(
                        text: goal,
                        isSelected: _selectedGoal.toString() == goal,
                        onTap: () {
                          setState(() {
                            _selectedGoal = Goal.fromString(goal);
                            // Reset pace when goal changes and default to gentle/lean
                            if (_selectedGoal == Goal.lose) {
                              _paceIndex = 0;
                              _weeklyChangeLbs = -0.5;
                              // Ensure PageView shows first page
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _pacePageController?.jumpToPage(0);
                              });
                            } else if (_selectedGoal == Goal.gain) {
                              _paceIndex = 0;
                              _weeklyChangeLbs = 0.5;
                              // Ensure PageView shows first page
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _pacePageController?.jumpToPage(0);
                              });
                            } else {
                              _weeklyChangeLbs = null; // maintain
                              // Remove controller when pace UI is hidden
                              _pacePageController?.dispose();
                              _pacePageController = null;
                            }
                          });
                        },
                      ),
                    ),
                    if (_selectedGoal == Goal.lose ||
                        _selectedGoal == Goal.gain) ...[
                      SizedBox(height: 24),
                      Text(
                        'Choose your pace',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: DynamicStyling.getBlack(context),
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 12),
                      SizedBox(
                        height: 140,
                        child: PageView.builder(
                          controller: _pacePageController ??= PageController(
                            initialPage: _paceIndex,
                          ),
                          onPageChanged: (idx) {
                            setState(() {
                              _paceIndex = idx;
                              if (_selectedGoal == Goal.lose) {
                                _weeklyChangeLbs = idx == 0 ? -0.5 : -1.0;
                              } else if (_selectedGoal == Goal.gain) {
                                _weeklyChangeLbs = idx == 0 ? 0.5 : 1.0;
                              }
                            });
                          },
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            final isLose = _selectedGoal == Goal.lose;
                            final isFirst = index == 0;
                            final label = isLose
                                ? (isFirst ? 'Gentle Cut' : 'Aggressive Cut')
                                : (isFirst ? 'Lean Bulk' : 'Aggressive Bulk');
                            final change = isLose
                                ? (isFirst ? -0.5 : -1.0)
                                : (isFirst ? 0.5 : 1.0);
                            final delta = (change.abs() * 500).round();
                            final deltaText = isLose
                                ? '≈ -$delta kcal/day'
                                : '≈ +$delta kcal/day';
                            final selected = _weeklyChangeLbs == change;

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _paceIndex = index;
                                    _weeklyChangeLbs = change;
                                    _pacePageController?.animateToPage(
                                      index,
                                      duration: const Duration(
                                        milliseconds: 250,
                                      ),
                                      curve: Curves.easeInOut,
                                    );
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: selected
                                        ? Colors.blue.withOpacity(0.12)
                                        : DynamicStyling.getWhite(context),
                                    border: Border.all(
                                      color: selected
                                          ? Colors.blueAccent
                                          : DynamicStyling.getBlack(
                                              context,
                                            ).withOpacity(0.12),
                                      width: selected ? 1.5 : 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            isLose
                                                ? Icons.trending_down
                                                : Icons.trending_up,
                                            color: isLose
                                                ? Colors.redAccent
                                                : Colors.green,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            label,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: DynamicStyling.getBlack(
                                                context,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${change > 0 ? '+' : ''}${change.toStringAsFixed(1)} lb/week',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: DynamicStyling.getDarkGrey(
                                            context,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        deltaText,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: DynamicStyling.getDarkGrey(
                                            context,
                                          ).withOpacity(0.9),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          2,
                          (i) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _paceIndex == i ? 16 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: _paceIndex == i
                                  ? Colors.blueAccent
                                  : Colors.grey.shade300,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
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
                                    color: DynamicStyling.getWhite(context),
                                  ),
                                )
                              : Text(
                                  'Next',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: DynamicStyling.getWhite(context),
                                  ),
                                )
                        : Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 15,
                              color: DynamicStyling.getWhite(context),
                            ),
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

                  SizedBox(
                    height:
                        20 +
                        (MediaQuery.viewInsetsOf(context).bottom <=
                                MediaQuery.viewPaddingOf(context).bottom
                            ? MediaQuery.viewPaddingOf(context).bottom
                            : MediaQuery.viewInsetsOf(context).bottom),
                  ),

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
                  //             : DynamicStyling.getWhite(context).withOpacity(0.3),
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

  // ignore: unused_element
}
