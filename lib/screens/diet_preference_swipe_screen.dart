import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      duration: Duration(milliseconds: 2200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _floatingAnimation = Tween<double>(begin: -18.0, end: 18.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );
    _pulseAnimation = Tween<double>(begin: 0.7, end: 1.3).animate(
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
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _currentIndex++;
        });
      }
    });
  }

  void _continue() {
    widget.onPreferencesSelected(_selectedPreferences);
    Navigator.pop(context, true); // Return success
  }

  void _skipPreferences() {
    widget.onPreferencesSelected([]);
    Navigator.pop(context, true); // Return success
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = _currentIndex >= _preferences.length;

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
              6,
              (index) => Positioned(
                left: (index * 65.0) % MediaQuery.of(context).size.width,
                top: (index * 130.0) % MediaQuery.of(context).size.height,
                child: AnimatedBuilder(
                  animation: _floatingAnimation,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(
                      math.sin(_floatingAnimation.value / 16 + index) * 12,
                      _floatingAnimation.value +
                          math.cos(_floatingAnimation.value / 13 + index) * 8,
                    ),
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) => Transform.scale(
                        scale: _pulseAnimation.value * (0.08 + index * 0.04),
                        child: Container(
                          width: 14 + (index * 4),
                          height: 14 + (index * 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: [
                              Colors.green.withOpacity(0.1),
                              Colors.lightGreen.withOpacity(0.08),
                              Colors.teal.withOpacity(0.06),
                              Colors.purple.withOpacity(0.05),
                              Colors.indigo.withOpacity(0.04),
                              Colors.cyan.withOpacity(0.03),
                            ][index],
                            boxShadow: [
                              BoxShadow(
                                color: [
                                  Colors.green,
                                  Colors.lightGreen,
                                  Colors.teal,
                                  Colors.purple,
                                  Colors.indigo,
                                  Colors.cyan,
                                ][index].withOpacity(0.12),
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
                                Colors.green.shade300,
                                Colors.teal.shade200,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds),
                            child: Text(
                              'Diet Preferences',
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
                                        ? 'Diet preferences complete!'
                                        : 'Swipe right if you follow this diet',
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
                                  color: Colors.green.withOpacity(0.2),
                                  border: Border.all(
                                    color: Colors.green.withOpacity(0.5),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  '${math.min(_currentIndex + 1, _preferences.length)}/${_preferences.length}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.green.shade300,
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

                    // Bottom section
                    if (isCompleted) _buildBottomButtons(),
                    if (isCompleted) SizedBox(height: 24),
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
        // Background cards - show current and next 2 cards
        for (
          int i = math.min(_currentIndex + 2, _preferences.length - 1);
          i >= _currentIndex;
          i--
        )
          if (i < _preferences.length)
            Positioned(
              child: SwipeCard(
                title: _preferences[i].toString(),
                description: _preferenceDescriptions[_preferences[i]] ?? '',
                icon: _preferenceIcons[_preferences[i]] ?? Icons.restaurant,
                cardColor: _preferenceColors[_preferences[i]] ?? Colors.grey,
                onSwipe: i == _currentIndex ? _onSwipe : (swipe) {},
                isTopCard: i == _currentIndex,
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
            'Diet Preferences Set!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          if (_selectedPreferences.isNotEmpty) ...[
            Text(
              'Selected preferences:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _selectedPreferences.map((preference) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: _preferenceColors[preference]?.withOpacity(0.2),
                    border: Border.all(
                      color:
                          _preferenceColors[preference]?.withOpacity(0.5) ??
                          Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    preference.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ] else ...[
            Text(
              'No diet preferences selected',
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
            text: 'Continue to Custom Restrictions',
            onTap: _continue,
          ),
          SizedBox(height: 12),
          TextButton(
            onPressed: _skipPreferences,
            child: Text(
              'Skip diet preferences',
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
