import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';
import '../styling.dart';
import 'dart:math' as math;

class MealDetailsScreen extends StatefulWidget {
  final Meal meal;
  final String diningHall;

  const MealDetailsScreen({
    Key? key,
    required this.meal,
    required this.diningHall,
  }) : super(key: key);

  @override
  _MealDetailsScreenState createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends State<MealDetailsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;

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
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _floatingAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    Future.delayed(Duration(milliseconds: 400), () {
      if (mounted) {
        _floatingController.repeat(reverse: true);
        _pulseController.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Color(0xFF1B263B),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Meal Details',
          style: TextStyle(
            color: Colors.white,
            fontFamily: '.SF Pro Display',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            decoration: TextDecoration.none,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            height: 0.5,
            color: Color(0xFF415A77).withOpacity(0.3),
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
          statusBarColor: Colors.transparent,
        ),
      ),
      extendBodyBehindAppBar: false,
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
              4,
              (index) => Positioned(
                left: (index * 90.0) % MediaQuery.of(context).size.width,
                top: (index * 180.0) % MediaQuery.of(context).size.height,
                child: AnimatedBuilder(
                  animation: _floatingAnimation,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(
                      math.sin(_floatingAnimation.value / 12 + index) * 6,
                      _floatingAnimation.value +
                          math.cos(_floatingAnimation.value / 10 + index) * 4,
                    ),
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) => Transform.scale(
                        scale: _pulseAnimation.value * (0.04 + index * 0.02),
                        child: Container(
                          width: 12 + (index * 4),
                          height: 12 + (index * 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: [
                              Colors.orange.withOpacity(0.06),
                              Colors.green.withOpacity(0.05),
                              Colors.blue.withOpacity(0.04),
                              Colors.purple.withOpacity(0.03),
                            ][index],
                            boxShadow: [
                              BoxShadow(
                                color: [
                                  Colors.orange,
                                  Colors.green,
                                  Colors.blue,
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
                      // Meal Header
                      _buildMealHeader(),
                      SizedBox(height: 24),

                      // Nutritional Overview
                      _buildNutritionalOverview(),
                      SizedBox(height: 24),

                      // Detailed Macros
                      // _buildDetailedMacros(),
                      // SizedBox(height: 24),

                      // Individual Foods/Ingredients
                      _buildFoodsSection(),
                      SizedBox(height: 24),

                      // Quick Actions
                      // _buildQuickActions(),
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

  Widget _buildMealHeader() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.withOpacity(0.15),
            Colors.blue.withOpacity(0.10),
            Colors.purple.withOpacity(0.05),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.withOpacity(0.2),
                  border: Border.all(
                    color: Colors.green.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Icon(
                  CupertinoIcons.rectangle_grid_1x2_fill,
                  color: Colors.green.shade300,
                  size: 24,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.meal.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: '.SF Pro Display',
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Available at ${widget.diningHall}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.7),
                        fontFamily: '.SF Pro Text',
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white.withOpacity(0.1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  CupertinoIcons.flame_fill,
                  color: Colors.orange.shade300,
                  size: 16,
                ),
                SizedBox(width: 6),
                Text(
                  '${widget.meal.calories.round()} Calories',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: '.SF Pro Text',
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionalOverview() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                CupertinoIcons.chart_pie_fill,
                color: Colors.cyan.shade300,
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                'Nutritional Overview',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: '.SF Pro Display',
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildNutritionCard(
                  'Protein',
                  '${widget.meal.protein.round()}g',
                  Colors.green,
                  CupertinoIcons.bolt_fill,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildNutritionCard(
                  'Carbs',
                  '${widget.meal.carbs.round()}g',
                  Colors.orange,
                  CupertinoIcons.heart_fill,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildNutritionCard(
                  'Fat',
                  '${widget.meal.fat.round()}g',
                  Colors.purple,
                  CupertinoIcons.drop_fill,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildNutritionCard(
                  'Foods',
                  '${widget.meal.foods.length}',
                  Colors.blue,
                  CupertinoIcons.square_grid_2x2_fill,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionCard(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: '.SF Pro Display',
              decoration: TextDecoration.none,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.7),
              fontFamily: '.SF Pro Text',
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedMacros() {
    double totalCalories = widget.meal.calories;
    double proteinCalories = widget.meal.protein * 4;
    double carbCalories = widget.meal.carbs * 4;
    double fatCalories = widget.meal.fat * 9;

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                CupertinoIcons.graph_square_fill,
                color: Colors.blue.shade300,
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                'Macro Breakdown',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: '.SF Pro Display',
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildMacroBar(
            'Protein',
            proteinCalories,
            totalCalories,
            Colors.green,
          ),
          SizedBox(height: 12),
          _buildMacroBar('Carbs', carbCalories, totalCalories, Colors.orange),
          SizedBox(height: 12),
          _buildMacroBar('Fat', fatCalories, totalCalories, Colors.purple),
        ],
      ),
    );
  }

  Widget _buildMacroBar(
    String label,
    double calories,
    double totalCalories,
    Color color,
  ) {
    double percentage = (calories / totalCalories) * 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.8),
                fontWeight: FontWeight.w500,
                fontFamily: '.SF Pro Text',
                decoration: TextDecoration.none,
              ),
            ),
            Text(
              '${calories.round()} cal (${percentage.round()}%)',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.6),
                fontFamily: '.SF Pro Text',
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
        SizedBox(height: 6),
        Container(
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.white.withOpacity(0.1),
          ),
          child: FractionallySizedBox(
            widthFactor: percentage / 100,
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: color,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFoodsSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                CupertinoIcons.list_bullet,
                color: Colors.amber.shade300,
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                'Ingredients & Foods',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: '.SF Pro Display',
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...widget.meal.foods.asMap().entries.map((entry) {
            int index = entry.key;
            Food food = entry.value;
            return _buildFoodItem(food, index);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildFoodItem(Food food, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.08),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: [
                    Colors.blue,
                    Colors.green,
                    Colors.orange,
                    Colors.purple,
                    Colors.cyan,
                    Colors.pink,
                  ][index % 6].withOpacity(0.2),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: '.SF Pro Text',
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: '.SF Pro Text',
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Text(
                      food.station.isNotEmpty
                          ? food.station
                          : "Unknown Station",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.6),
                        fontFamily: '.SF Pro Text',
                        decoration: TextDecoration.none,
                      ),
                    ),
                    if (food.ingredients.isNotEmpty) ...[
                      SizedBox(height: 4),
                      Text(
                        food.ingredients,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.6),
                          fontFamily: '.SF Pro Text',
                          decoration: TextDecoration.none,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _buildNutritionChip('${food.calories.round()} cal', Colors.blue),
              _buildNutritionChip('${food.protein.round()}g P', Colors.green),
              _buildNutritionChip('${food.carbs.round()}g C', Colors.orange),
              _buildNutritionChip('${food.fat.round()}g F', Colors.purple),
            ],
          ),
          if (food.labels.isNotEmpty) ...[
            SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: food.labels
                  .take(4)
                  .map(
                    (label) => Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.cyan.withOpacity(0.2),
                        border: Border.all(
                          color: Colors.cyan.withOpacity(0.5),
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                          color: Colors.cyan.shade200,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          fontFamily: '.SF Pro Text',
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNutritionChip(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color.withOpacity(0.2),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          fontFamily: '.SF Pro Text',
          decoration: TextDecoration.none,
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: '.SF Pro Display',
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CupertinoButton(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.heart_fill,
                        color: Colors.green,
                        size: 16,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Save Meal',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          fontFamily: '.SF Pro Text',
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    // TODO: Implement save meal functionality
                  },
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: CupertinoButton(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.share, color: Colors.blue, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Share',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          fontFamily: '.SF Pro Text',
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    // TODO: Implement share functionality
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
