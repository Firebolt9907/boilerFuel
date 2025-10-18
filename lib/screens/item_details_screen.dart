import 'package:boiler_fuel/main.dart';
import 'package:boiler_fuel/widgets/custom_app_bar.dart';
import 'package:boiler_fuel/widgets/titanium_container.dart';
import 'package:bottom_sheet_scroll_physics/bottom_sheet_scroll_physics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';
import '../styling.dart';
import 'dart:math' as math;

class ItemDetailsScreen extends StatefulWidget {
  final Food food;
  final String diningHall;

  const ItemDetailsScreen({
    Key? key,
    required this.food,
    required this.diningHall,
  });

  @override
  _ItemDetailsScreenState createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen>
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

    _fadeAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
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
      backgroundColor: Colors.grey[50],

      extendBodyBehindAppBar: false,
      body: Column(
        children: [
          _buildMealHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(left: 24, right: 24),
              physics: BottomSheetScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24),
                  // Meal Header
                  Text(
                    "Dietary Information",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: DynamicStyling.getBlack(context),
                      fontFamily: '.SF Pro Display',
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(height: 12),
                  // Nutritional Overview
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: widget.food.labels
                        .take(4)
                        .map(
                          (label) => Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: DynamicStyling.getDarkGrey(
                                context,
                              ).withOpacity(0.1),
                            ),
                            child: Text(
                              label,
                              style: TextStyle(
                                color: DynamicStyling.getDarkGrey(context),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                fontFamily: '.SF Pro Text',
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),

                  SizedBox(height: 24),
                  if (widget.food.calories != -1 &&
                      widget.food.carbs != -1 &&
                      widget.food.fat != -1 &&
                      widget.food.sugar != -1 &&
                      widget.food.protein != -1) ...[
                    // Nutrition Information Section
                    Text(
                      "Nutrition Information",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: DynamicStyling.getBlack(context),
                        fontFamily: '.SF Pro Display',
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Calories",
                            style: TextStyle(
                              fontSize: 14,

                              color: DynamicStyling.getBlack(context),
                              fontFamily: '.SF Pro Text',
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Text(
                            "${widget.food.calories.round()} cal",
                            style: TextStyle(
                              fontSize: 16,
                              color: DynamicStyling.getBlack(
                                context,
                              ).withOpacity(0.6),
                              fontFamily: '.SF Pro Text',
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey[300]),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Protein",
                            style: TextStyle(
                              fontSize: 14,

                              color: DynamicStyling.getBlack(context),
                              fontFamily: '.SF Pro Text',
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Text(
                            "${widget.food.protein.round()}g",
                            style: TextStyle(
                              fontSize: 16,
                              color: DynamicStyling.getBlack(
                                context,
                              ).withOpacity(0.6),
                              fontFamily: '.SF Pro Text',
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey[300]),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Carbs",
                            style: TextStyle(
                              fontSize: 14,

                              color: DynamicStyling.getBlack(context),
                              fontFamily: '.SF Pro Text',
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Text(
                            "${widget.food.carbs.round()}g",
                            style: TextStyle(
                              fontSize: 16,
                              color: DynamicStyling.getBlack(
                                context,
                              ).withOpacity(0.6),
                              fontFamily: '.SF Pro Text',
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey[300]),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Fat",
                            style: TextStyle(
                              fontSize: 14,

                              color: DynamicStyling.getBlack(context),
                              fontFamily: '.SF Pro Text',
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Text(
                            "${widget.food.fat.round()}g",
                            style: TextStyle(
                              fontSize: 16,
                              color: DynamicStyling.getBlack(
                                context,
                              ).withOpacity(0.6),
                              fontFamily: '.SF Pro Text',
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey[300]),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Sugar",
                            style: TextStyle(
                              fontSize: 14,

                              color: DynamicStyling.getBlack(context),
                              fontFamily: '.SF Pro Text',
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Text(
                            "${widget.food.sugar.round()}g",
                            style: TextStyle(
                              fontSize: 16,
                              color: DynamicStyling.getBlack(
                                context,
                              ).withOpacity(0.6),
                              fontFamily: '.SF Pro Text',
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey[300]),
                  ],
                  SizedBox(height: 24),
                  // Ingredients Section
                  Text(
                    "Ingredients",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: DynamicStyling.getBlack(context),
                      fontFamily: '.SF Pro Display',
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(height: 12),
                  if (widget.food.ingredients.isNotEmpty) ...[
                    _buildIngredients(widget.food, 0),
                  ] else ...[
                    Text(
                      "No ingredients available.",
                      style: TextStyle(
                        fontSize: 14,
                        color: DynamicStyling.getDarkGrey(context),
                        fontFamily: '.SF Pro Text',
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],

                  // Quick Actions
                  // _buildQuickActions(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealHeader() {
    return Container(
      decoration: BoxDecoration(
        color: DynamicStyling.getWhite(context),
        border: Border(
          bottom: BorderSide(color: DynamicStyling.getGrey(context)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 250),
                      child: Text(
                        widget.food.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: DynamicStyling.getBlack(context),
                          fontFamily: '.SF Pro Display',
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),

                // if (widget.user.useMealPlanning)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildIngredients(widget.food, 0)],
    );
  }

  Widget _buildIngredients(Food food, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          food.ingredients,
          style: TextStyle(
            fontSize: 14,
            color: DynamicStyling.getDarkGrey(context),
            fontFamily: '.SF Pro Text',
            decoration: TextDecoration.none,
          ),
        ),
      ],
    );
  }
}
