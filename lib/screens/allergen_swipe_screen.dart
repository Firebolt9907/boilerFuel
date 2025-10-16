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

class AllergenSwipeScreen extends StatefulWidget {
  final List<FoodAllergy> selectedAllergies;
  final Function(List<FoodAllergy>) onAllergiesSelected;

  const AllergenSwipeScreen({
    Key? key,
    required this.selectedAllergies,
    required this.onAllergiesSelected,
  }) : super(key: key);

  @override
  _AllergenSwipeScreenState createState() => _AllergenSwipeScreenState();
}

class _AllergenSwipeScreenState extends State<AllergenSwipeScreen>
    with TickerProviderStateMixin {
  late List<FoodAllergy> _allergens;
  late List<FoodAllergy> _selectedAllergies;
  int _currentIndex = 0;

  late AnimationController _animationController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;

  // Colors for different allergens
  final Map<FoodAllergy, Color> _allergenColors = {
    FoodAllergy.Gluten: Colors.amber,
    FoodAllergy.Dairy: Colors.blue,
    FoodAllergy.Nuts: Colors.brown,
    FoodAllergy.Shellfish: Colors.orange,
    FoodAllergy.Soy: Colors.green,
    FoodAllergy.Eggs: Colors.yellow,
    FoodAllergy.Peanuts: Colors.deepOrange,
    FoodAllergy.Wheat: Colors.lightGreen,
    FoodAllergy.Fish: Colors.teal,
    FoodAllergy.TreeNuts: Colors.brown.shade700,
    FoodAllergy.Coconut: Colors.brown.shade300,
    FoodAllergy.Sesame: Colors.orange.shade300,
  };

  // Icons for different allergens
  final Map<FoodAllergy, IconData> _allergenIcons = {
    FoodAllergy.Gluten: Icons.grain,
    FoodAllergy.Dairy: Icons.local_drink,
    FoodAllergy.Nuts: Icons.eco,
    FoodAllergy.Shellfish: Icons.set_meal,
    FoodAllergy.Soy: Icons.grass,
    FoodAllergy.Eggs: Icons.egg,
    FoodAllergy.Peanuts: Icons.eco,
    FoodAllergy.Wheat: Icons.agriculture,
    FoodAllergy.Fish: Icons.phishing,
    FoodAllergy.TreeNuts: Icons.park,
    FoodAllergy.Coconut: Icons.local_florist,
    FoodAllergy.Sesame: Icons.grain,
  };

  // Descriptions for allergens
  final Map<FoodAllergy, String> _allergenDescriptions = {
    FoodAllergy.Gluten:
        'Protein found in wheat, barley, and rye that can cause digestive issues',
    FoodAllergy.Dairy: 'Milk products from cows, goats, and other mammals',
    FoodAllergy.Nuts: 'Tree nuts including almonds, walnuts, cashews, and more',
    FoodAllergy.Shellfish:
        'Crustaceans like shrimp, crab, lobster, and mollusks',
    FoodAllergy.Soy: 'Products derived from soybeans, common in Asian cuisine',
    FoodAllergy.Eggs: 'Chicken eggs and products containing eggs',
    FoodAllergy.Peanuts: 'Legumes that grow underground, despite the name',
    FoodAllergy.Wheat: 'Wheat grain and wheat-based products',
    FoodAllergy.Fish: 'Finned fish including salmon, tuna, cod, and others',
    FoodAllergy.TreeNuts: 'Nuts that grow on trees, different from peanuts',
    FoodAllergy.Coconut: 'Coconut meat, milk, oil, and related products',
    FoodAllergy.Sesame: 'Sesame seeds and sesame-based products like tahini',
  };

  @override
  void initState() {
    super.initState();
    _allergens = FoodAllergy.values.toList();
    _selectedAllergies = List.from(widget.selectedAllergies);

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
    final currentAllergy = _allergens[_currentIndex];

    if (isRightSwipe) {
      // Right swipe = has allergy
      if (!_selectedAllergies.contains(currentAllergy)) {
        setState(() {
          _selectedAllergies.add(currentAllergy);
        });
      }
    } else {
      // Left swipe = no allergy
      setState(() {
        _selectedAllergies.remove(currentAllergy);
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
    widget.onAllergiesSelected(_selectedAllergies);
    setState(() {
      _allergens = FoodAllergy.values.toList();

      _currentIndex = 0;
    });

    Navigator.pop(context, true); // Return success
  }

  // void _skipAllergies() {
  //   widget.onAllergiesSelected([]);
  //   Navigator.pop(context, true); // Return success
  // }

  @override
  Widget build(BuildContext context) {
    final isCompleted = _currentIndex >= _allergens.length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 48),
            // Header
            Text(
              'Food Allergies',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Select your food allergies by tapping on each of your allergies.',
                style: TextStyle(
                  fontSize: 16,
                  color: styling.darkGray,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  for (FoodAllergy a in _allergens)
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        setState(() {
                          if (_selectedAllergies.contains(a)) {
                            _selectedAllergies.remove(a);
                          } else {
                            _selectedAllergies.add(a);
                          }
                        });
                      },
                      child: DefaultContainer(
                        decoration: _selectedAllergies.contains(a)
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              )
                            : null,

                        child: Column(
                          children: [
                            Icon(
                              _allergenIcons[a],
                              color: _selectedAllergies.contains(a)
                                  ? Colors.black
                                  : Colors.grey.shade400,
                              size: 32,
                            ),
                            SizedBox(height: 8),
                            Text(
                              a.name,
                              style: TextStyle(
                                fontSize: 14,
                                color: _selectedAllergies.contains(a)
                                    ? Colors.black
                                    : Colors.grey.shade400,
                                fontWeight: _selectedAllergies.contains(a)
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DefaultButton(
                text: Text(
                  "Save",
                  style: TextStyle(color: Colors.white, fontSize: 16),
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
                  style: TextStyle(color: styling.darkGray, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
