import 'package:boiler_fuel/constants.dart';
import 'package:boiler_fuel/main.dart';
import 'package:boiler_fuel/widgets/default_button.dart';
import 'package:boiler_fuel/widgets/default_container.dart';
import 'package:boiler_fuel/widgets/default_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/animated_button.dart';
import '../widgets/animated_text_field.dart';
import 'dart:math' as math;

class CustomIngredientsScreen extends StatefulWidget {
  final List<String> customIngredients;
  final Function(List<String>) onIngredientsSelected;

  const CustomIngredientsScreen({
    Key? key,
    required this.customIngredients,
    required this.onIngredientsSelected,
  }) : super(key: key);

  @override
  _CustomIngredientsScreenState createState() =>
      _CustomIngredientsScreenState();
}

class _CustomIngredientsScreenState extends State<CustomIngredientsScreen>
    with TickerProviderStateMixin {
  final TextEditingController _ingredientController = TextEditingController();
  late List<String> _customIngredients;

  late AnimationController _animationController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;

  // Common ingredient suggestions (removed aliases, alcohol, made uppercase)
  final List<String> _suggestionChips = [
    'BEEF',
    'PORK',
    'LAMB',
    'TURKEY',
    'DUCK',
    'MUSHROOMS',
    'ONIONS',
    'GARLIC',
    'CILANTRO',
    'COCONUT',
    'AVOCADO',
    'TOMATOES',
    'CHEESE',
    'BUTTER',
    'CREAM',
    'YOGURT',
  ];

  final List<String> _hardcodedAllergens = [
    'BEEF',
    'PORK',
    'LAMB',
    'TURKEY',
    'DUCK',
    'MUSHROOMS',
    'ONIONS',
    'GARLIC',
    'CILANTRO',
    'COCONUT',
    'AVOCADO',
    'TOMATOES',
    'CHEESE',
    'BUTTER',
    'CREAM',
    'YOGURT',
  ];

  @override
  void initState() {
    super.initState();
    _customIngredients = List.from(widget.customIngredients);

    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _floatingController = AnimationController(
      duration: Duration(milliseconds: 5000),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _floatingAnimation = Tween<double>(begin: -20.0, end: 20.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );
    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.4).animate(
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
    _ingredientController.dispose();
    _animationController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _addIngredient(String ingredient) {
    final trimmedIngredient = ingredient.trim().toLowerCase();
    print("Adding ingredient: $trimmedIngredient");
    if (trimmedIngredient.isNotEmpty &&
        !_customIngredients.contains(trimmedIngredient)) {
      setState(() {
        _customIngredients.add(trimmedIngredient);
      });
      _ingredientController.clear();
    }
  }

  void _removeIngredient(String ingredient) {
    print("Removing ingredient: $ingredient");
    setState(() {
      _customIngredients.remove(ingredient.trim().toLowerCase());
      if (!_hardcodedAllergens.contains(ingredient.trim().toUpperCase())) {
        _suggestionChips.remove(ingredient.trim().toUpperCase());
      }
    });
  }

  void _addFromSuggestion(String suggestion) {
    _addIngredient(suggestion);
  }

  void _continue() {
    HapticFeedback.lightImpact();
    int initialLength = _customIngredients.length;
    print("Initial custom ingredients: $_customIngredients");
    for (int i = 0; i < initialLength; i++) {
      String ingredient = _customIngredients[i];
      if (ingredientAliases[ingredient] != null) {
        _customIngredients.addAll(ingredientAliases[ingredient]!);
      }
    }
    print("Final custom ingredients with aliases: $_customIngredients");
    widget.onIngredientsSelected(_customIngredients);
    Navigator.pop(context, true); // Return success
  }

  void _skip() {
    widget.onIngredientsSelected([]);
    Navigator.pop(context, true); // Return success
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Floating decorative elements

          // Main content
          SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: MediaQuery.of(context).padding.top,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  'Custom Restrictions',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Add specific ingredients you want to avoid',
                  style: TextStyle(fontSize: 16, color: styling.darkGray),
                ),
                SizedBox(height: 40),

                // Input field
                DefaultContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Ingredient',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 16),

                      // Text field with add button
                      Row(
                        children: [
                          Expanded(
                            child: DefaultTextField(
                              controller: _ingredientController,
                              label: 'e.g., beef, pork, mushrooms',
                            ),
                          ),
                          SizedBox(width: 12),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 15,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: Icon(Icons.add, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  _suggestionChips.add(
                                    _ingredientController.text.toUpperCase(),
                                  );
                                });
                                _addIngredient(_ingredientController.text);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),

                // Quick suggestions
                DefaultContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quick Add',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _suggestionChips.map((suggestion) {
                            final isSelected = _customIngredients.contains(
                              suggestion.trim().toLowerCase(),
                            );
                            return GestureDetector(
                              onTap: () => isSelected
                                  ? _removeIngredient(suggestion)
                                  : _addFromSuggestion(suggestion),
                              child: DefaultContainer(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.black
                                        : styling.darkGray,
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (isSelected) ...[
                                      Icon(
                                        Icons.check,
                                        size: 16,
                                        color: Colors.black,
                                      ),
                                      SizedBox(width: 4),
                                    ],
                                    Text(
                                      suggestion,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.black
                                            : styling.darkGray,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 32),

                // Bottom buttons
                DefaultButton(
                  text: Text(
                    "Save",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onTap: _continue,
                ),
                Center(
                  child: TextButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Back',
                      style: TextStyle(color: styling.darkGray, fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
