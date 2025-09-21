import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    widget.onAllergiesSelected(_selectedAllergies);
    Navigator.pop(context, true); // Return success
  }

  void _skipAllergies() {
    widget.onAllergiesSelected([]);
    Navigator.pop(context, true); // Return success
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = _currentIndex >= _allergens.length;

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
              5,
              (index) => Positioned(
                left: (index * 70.0) % MediaQuery.of(context).size.width,
                top: (index * 120.0) % MediaQuery.of(context).size.height,
                child: AnimatedBuilder(
                  animation: _floatingAnimation,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(
                      math.sin(_floatingAnimation.value / 15 + index) * 10,
                      _floatingAnimation.value +
                          math.cos(_floatingAnimation.value / 12 + index) * 6,
                    ),
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) => Transform.scale(
                        scale: _pulseAnimation.value * (0.1 + index * 0.06),
                        child: Container(
                          width: 12 + (index * 6),
                          height: 12 + (index * 6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: [
                              Colors.red.withOpacity(0.08),
                              Colors.orange.withOpacity(0.06),
                              Colors.yellow.withOpacity(0.05),
                              Colors.green.withOpacity(0.04),
                              Colors.blue.withOpacity(0.03),
                            ][index],
                            boxShadow: [
                              BoxShadow(
                                color: [
                                  Colors.red,
                                  Colors.orange,
                                  Colors.yellow,
                                  Colors.green,
                                  Colors.blue,
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
                child: Column(
                  children: [
                    // Header
                    Padding(
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
                                Colors.red.shade300,
                                Colors.orange.shade200,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds),
                            child: Text(
                              'Food Allergies',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),

                          // Progress and description
                          Row(
                            children: [
                              Expanded(
                                child: Container(
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
                                    isCompleted
                                        ? 'Swipe through complete!'
                                        : 'Swipe right if you have this allergy',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.8),
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.blue.withOpacity(0.2),
                                  border: Border.all(
                                    color: Colors.blue.withOpacity(0.5),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  '${_currentIndex}/${_allergens.length}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue.shade300,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Card stack area
                    Expanded(
                      child: Center(
                        child: isCompleted
                            ? _buildCompletionView()
                            : _buildCardStack(),
                      ),
                    ),
                    if (!isCompleted)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //Swap the order if swapSides is true
                        children: [
                          // Reject hint
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.red.withOpacity(0.2),
                              border: Border.all(
                                color: Colors.red.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.arrow_left,
                                  color: Colors.red.shade300,
                                  size: 16,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Not Allergic',
                                  style: TextStyle(
                                    color: Colors.red.shade300,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Accept hint
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.green.withOpacity(0.2),
                              border: Border.all(
                                color: Colors.green.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Allergic',
                                  style: TextStyle(
                                    color: Colors.green.shade300,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_right,
                                  color: Colors.green.shade300,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    else
                      SizedBox(height: 24),

                    // Bottom section
                    if (isCompleted) _buildBottomButtons(),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardStack() {
    return Stack(
      alignment: Alignment.center,
      children: [
        for (
          int i = math.min(
            _currentIndex + _allergens.length,
            _allergens.length - 1,
          );
          i >= _currentIndex;
          i--
        )
          if (i < _allergens.length)
            Positioned(
              child: SwipeCard(
                title: _allergens[i].toString(),
                description: _allergenDescriptions[_allergens[i]] ?? '',
                icon: _allergenIcons[_allergens[i]] ?? Icons.warning,
                cardColor: _allergenColors[_allergens[i]] ?? Colors.grey,
                onSwipe: i == _currentIndex ? _onSwipe : (swipe) {},
                isTopCard: i == _currentIndex,
                swapSides: false,
              ),
            ),
      ],
    );
  }

  Widget _buildCompletionView() {
    return Container(
      padding: EdgeInsets.all(32),
      margin: EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 80, color: Colors.green.shade400),
          SizedBox(height: 24),
          Text(
            'Allergies Recorded!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          if (_selectedAllergies.isNotEmpty) ...[
            Text(
              'Selected allergies:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 12),
            ListView(
              shrinkWrap: true,

              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selectedAllergies.map((allergy) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: _allergenColors[allergy]?.withOpacity(0.2),
                        border: Border.all(
                          color:
                              _allergenColors[allergy]?.withOpacity(0.5) ??
                              Colors.grey,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        allergy.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ] else ...[
            Text(
              'No allergies selected',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.6),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          AnimatedButton(
            text: 'Continue to Diet Preferences',
            onTap: _continue,
          ),
          SizedBox(height: 12),
          TextButton(
            onPressed: _skipAllergies,
            child: Text(
              'Skip allergies',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
