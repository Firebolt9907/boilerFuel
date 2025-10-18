import 'package:boiler_fuel/styling.dart';
import 'package:boiler_fuel/main.dart';
import 'package:boiler_fuel/widgets/default_button.dart';
import 'package:boiler_fuel/widgets/default_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';
import '../widgets/swipe_card.dart';
import '../widgets/animated_button.dart';
import 'dart:math' as math;

class DietPreferenceSwipeScreen extends StatefulWidget {
  final List<FoodPreference> selectedPreferences;
  final Function(List<FoodPreference>) onPreferencesSelected;

  const DietPreferenceSwipeScreen({
    Key? key,
    required this.selectedPreferences,
    required this.onPreferencesSelected,
  }) : super(key: key);

  @override
  _DietPreferenceSwipeScreenState createState() =>
      _DietPreferenceSwipeScreenState();
}

class _DietPreferenceSwipeScreenState extends State<DietPreferenceSwipeScreen>
    with TickerProviderStateMixin {
  late List<FoodPreference> _preferences;
  late List<FoodPreference> _selectedPreferences;
  int _currentIndex = 0;

  late AnimationController _animationController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;

  // Colors for different preferences
  final Map<FoodPreference, Color> _preferenceColors = {
    FoodPreference.Vegan: Colors.green,
    FoodPreference.Vegetarian: Colors.lightGreen,
    FoodPreference.Pescatarian: Colors.teal,
    FoodPreference.Halal: Colors.purple,
    FoodPreference.Kosher: Colors.indigo,
  };

  // Icons for different preferences
  final Map<FoodPreference, IconData> _preferenceIcons = {
    FoodPreference.Vegan: Icons.eco,
    FoodPreference.Vegetarian: Icons.local_florist,
    FoodPreference.Pescatarian: Icons.waves,
    FoodPreference.Halal: Icons.mosque,
    FoodPreference.Kosher: Icons.star,
  };

  // Descriptions for preferences
  final Map<FoodPreference, String> _preferenceDescriptions = {
    FoodPreference.Vegan:
        'Plant-based diet excluding all animal products including dairy and eggs',
    FoodPreference.Vegetarian:
        'Diet excluding meat and fish but may include dairy and eggs',
    FoodPreference.Pescatarian:
        'Vegetarian diet that includes fish and seafood',
    FoodPreference.Halal:
        'Islamic dietary laws - no pork, alcohol, or non-halal meat',
    FoodPreference.Kosher:
        'Jewish dietary laws - specific preparation and food combinations',
  };

  @override
  void initState() {
    super.initState();
    _preferences = FoodPreference.values.toList();
    _selectedPreferences = List.from(widget.selectedPreferences);

    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _floatingController = AnimationController(
      duration: Duration(milliseconds: 4500),
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
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
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
    _animationController.stop();
    _floatingController.stop();
    _pulseController.stop();
    _animationController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onSwipe(bool isRightSwipe) {
    final currentPreference = _preferences[_currentIndex];

    if (isRightSwipe) {
      // Right swipe = follows this diet
      if (!_selectedPreferences.contains(currentPreference)) {
        setState(() {
          _selectedPreferences.add(currentPreference);
        });
      }
    } else {
      // Left swipe = doesn't follow this diet
      setState(() {
        _selectedPreferences.remove(currentPreference);
      });
    }

    // Move to next card after a delay

    if (mounted) {
      setState(() {
        _currentIndex++;
      });
    }
  }

  void _continue() {
    HapticFeedback.mediumImpact();
    widget.onPreferencesSelected(_selectedPreferences);
    Navigator.pop(context, true); // Return success
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = _currentIndex >= _preferences.length;

    return Scaffold(
      backgroundColor: DynamicStyling.getWhite(context),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Text(
            'Diet Preferences',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: DynamicStyling.getBlack(context),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Select your diets by tapping on each of your diets.',
            style: TextStyle(
              fontSize: 16,
              color: DynamicStyling.getDarkGrey(context),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: _preferences.map((preference) {
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      if (_selectedPreferences.contains(preference)) {
                        _selectedPreferences.remove(preference);
                      } else {
                        _selectedPreferences.add(preference);
                      }
                    });
                  },
                  child: DefaultContainer(
                    decoration: _selectedPreferences.contains(preference)
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: DynamicStyling.getBlack(context),
                              width: 2,
                            ),
                          )
                        : null,

                    child: Column(
                      children: [
                        Icon(
                          _preferenceIcons[preference],
                          color: _selectedPreferences.contains(preference)
                              ? DynamicStyling.getBlack(context)
                              : DynamicStyling.getGrey(context),
                          size: 32,
                        ),
                        SizedBox(height: 8),
                        Text(
                          preference.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: _selectedPreferences.contains(preference)
                                ? DynamicStyling.getBlack(context)
                                : DynamicStyling.getGrey(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DefaultButton(
              text: Text(
                "Save",
                style: TextStyle(
                  color: DynamicStyling.getWhite(context),
                  fontSize: 16,
                ),
              ),
              onTap: _continue,
            ),
          ),

          Center(
            child: TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();
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
        ],
      ),
    );
  }
}
