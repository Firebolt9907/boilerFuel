import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
              7,
              (index) => Positioned(
                left: (index * 55.0) % MediaQuery.of(context).size.width,
                top: (index * 100.0) % MediaQuery.of(context).size.height,
                child: AnimatedBuilder(
                  animation: _floatingAnimation,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(
                      math.sin(_floatingAnimation.value / 17 + index) * 8,
                      _floatingAnimation.value +
                          math.cos(_floatingAnimation.value / 14 + index) * 5,
                    ),
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) => Transform.scale(
                        scale: _pulseAnimation.value * (0.06 + index * 0.03),
                        child: Container(
                          width: 10 + (index * 3),
                          height: 10 + (index * 3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: [
                              Colors.orange.withOpacity(0.1),
                              Colors.amber.withOpacity(0.08),
                              Colors.yellow.withOpacity(0.07),
                              Colors.lime.withOpacity(0.06),
                              Colors.cyan.withOpacity(0.05),
                              Colors.pink.withOpacity(0.04),
                              Colors.purple.withOpacity(0.03),
                            ][index],
                            boxShadow: [
                              BoxShadow(
                                color: [
                                  Colors.orange,
                                  Colors.amber,
                                  Colors.yellow,
                                  Colors.lime,
                                  Colors.cyan,
                                  Colors.pink,
                                  Colors.purple,
                                ][index].withOpacity(0.1),
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
                  padding: EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back button
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
                      SizedBox(height: 24),

                      // Title
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.orange.shade300,
                            Colors.amber.shade200,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: Text(
                          'Custom Restrictions',
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
                          'Add specific ingredients you want to avoid',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      SizedBox(height: 40),

                      // Input field
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
                              'Add Ingredient',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: 16),

                            // Text field with add button
                            Row(
                              children: [
                                Expanded(
                                  child: AnimatedTextField(
                                    controller: _ingredientController,
                                    label: 'e.g., beef, pork, mushrooms',
                                  ),
                                ),
                                SizedBox(width: 12),
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.orange.shade400,
                                        Colors.amber.shade300,
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.orange.withOpacity(0.3),
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
                                          _ingredientController.text
                                              .toUpperCase(),
                                        );
                                      });
                                      _addIngredient(
                                        _ingredientController.text,
                                      );
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
                              'Quick Add',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: 16),
                            Wrap(
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
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 200),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: isSelected
                                          ? Colors.orange.withOpacity(0.3)
                                          : Colors.white.withOpacity(0.1),
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.orange.withOpacity(0.7)
                                            : Colors.white.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (isSelected) ...[
                                          Icon(
                                            Icons.check,
                                            size: 16,
                                            color: Colors.orange.shade300,
                                          ),
                                          SizedBox(width: 4),
                                        ],
                                        Text(
                                          suggestion,
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.orange.shade200
                                                : Colors.white.withOpacity(0.8),
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
                          ],
                        ),
                      ),
                      SizedBox(height: 32),

                      // Current restrictions
                      // if (_customIngredients.isNotEmpty) ...[
                      //   Container(
                      //     padding: EdgeInsets.all(20),
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(20),
                      //       color: Colors.white.withOpacity(0.05),
                      //       border: Border.all(
                      //         color: Colors.white.withOpacity(0.15),
                      //         width: 1,
                      //       ),
                      //     ),
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Row(
                      //           children: [
                      //             Text(
                      //               'Your Restrictions',
                      //               style: TextStyle(
                      //                 fontSize: 18,
                      //                 fontWeight: FontWeight.w600,
                      //                 color: Colors.white,
                      //                 letterSpacing: 0.5,
                      //               ),
                      //             ),
                      //             Spacer(),
                      //             Container(
                      //               padding: EdgeInsets.symmetric(
                      //                 horizontal: 12,
                      //                 vertical: 4,
                      //               ),
                      //               decoration: BoxDecoration(
                      //                 borderRadius: BorderRadius.circular(12),
                      //                 color: Colors.orange.withOpacity(0.2),
                      //                 border: Border.all(
                      //                   color: Colors.orange.withOpacity(0.5),
                      //                   width: 1,
                      //                 ),
                      //               ),
                      //               child: Text(
                      //                 '${_customIngredients.length} items',
                      //                 style: TextStyle(
                      //                   fontSize: 12,
                      //                   color: Colors.orange.shade300,
                      //                   fontWeight: FontWeight.w500,
                      //                 ),
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //         SizedBox(height: 16),
                      //         Wrap(
                      //           spacing: 8,
                      //           runSpacing: 8,
                      //           children: _customIngredients.map((ingredient) {
                      //             return Container(
                      //               padding: EdgeInsets.symmetric(
                      //                 horizontal: 12,
                      //                 vertical: 8,
                      //               ),
                      //               decoration: BoxDecoration(
                      //                 borderRadius: BorderRadius.circular(20),
                      //                 color: Colors.red.withOpacity(0.2),
                      //                 border: Border.all(
                      //                   color: Colors.red.withOpacity(0.5),
                      //                   width: 1,
                      //                 ),
                      //               ),
                      //               child: Row(
                      //                 mainAxisSize: MainAxisSize.min,
                      //                 children: [
                      //                   Text(
                      //                     ingredient,
                      //                     style: TextStyle(
                      //                       color: Colors.red.shade200,
                      //                       fontSize: 12,
                      //                       fontWeight: FontWeight.w500,
                      //                     ),
                      //                   ),
                      //                   SizedBox(width: 6),
                      //                   GestureDetector(
                      //                     onTap: () =>
                      //                         _removeIngredient(ingredient),
                      //                     child: Icon(
                      //                       Icons.close,
                      //                       size: 16,
                      //                       color: Colors.red.shade300,
                      //                     ),
                      //                   ),
                      //                 ],
                      //               ),
                      //             );
                      //           }).toList(),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      //   SizedBox(height: 40),
                      // ],

                      // Bottom buttons
                      AnimatedButton(text: 'Complete Setup', onTap: _continue),
                      SizedBox(height: 12),
                      Center(
                        child: TextButton(
                          onPressed: _skip,
                          child: Text(
                            'Skip custom restrictions',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
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
