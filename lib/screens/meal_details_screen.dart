import 'package:boiler_fuel/api/local_database.dart';
import 'package:boiler_fuel/custom/cupertinoSheet.dart' as customCupertinoSheet;
import 'package:boiler_fuel/main.dart';
import 'package:boiler_fuel/screens/item_details_screen.dart';
import 'package:boiler_fuel/widgets/custom_app_bar.dart';
import 'package:boiler_fuel/widgets/default_container.dart';
import 'package:boiler_fuel/widgets/nutrition_label.dart';
import 'package:boiler_fuel/widgets/titanium_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stupid_simple_sheet/stupid_simple_sheet.dart';
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
  });

  @override
  _MealDetailsScreenState createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends State<MealDetailsScreen>
    with TickerProviderStateMixin {
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      _isFavorited = widget.meal.isFavorited;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DynamicStyling.getWhite(context),

      extendBodyBehindAppBar: false,
      body: Column(
        children: [
          _buildMealHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(left: 24, right: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meal Header
                  SizedBox(height: 24),
                  // Nutritional Overview
                  NutritionLabel(meal: widget.meal),

                  // Detailed Macros
                  // _buildDetailedMacros(),
                  // SizedBox(height: 24),

                  // Individual Foods/Ingredients
                  _buildFoodsSection(),

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
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).pop();
            },
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_new, color: styling.gray),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.of(context).pop();
                  },
                ),

                Text(
                  'Back',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: styling.gray,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, bottom: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 250),
                      child: Text(
                        widget.meal.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: DynamicStyling.getBlack(context),
                          fontFamily: '.SF Pro Display',
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 250),
                      child: Text(
                        widget.meal.diningHall,
                        style: TextStyle(
                          fontSize: 14,
                          color: DynamicStyling.getDarkGrey(context),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 24.0),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      splashColor: Colors.red.withOpacity(0.15),
                      highlightColor: Colors.red.withOpacity(0.08),
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        setState(() {
                          _isFavorited = !_isFavorited;
                        });
                        widget.meal.isFavorited = _isFavorited;
                        print(
                          "Updating meal favorite status: ${widget.meal.mealTime} to $_isFavorited",
                        );
                        LocalDatabase().updateMeal(widget.meal.id, widget.meal);
                      },
                      child: DefaultContainer(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: DynamicStyling.getLightGrey(context),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          _isFavorited
                              ? Icons.bookmark_added
                              : Icons.bookmark_add_outlined,
                          color: _isFavorited
                              ? Colors.red
                              : DynamicStyling.getBlack(context),
                          size: 20,
                        ),
                      ),
                    ),
                  ),
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
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ingredients & Foods',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: DynamicStyling.getBlack(context),
            ),
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

  void _showFoodDetails(Food food) {
    // Create a single-item meal for the food details screen
    Meal singleFoodMeal = Meal(
      name: food.name,
      foods: [food],
      calories: food.calories,
      protein: food.protein,
      carbs: food.carbs,
      fat: food.fat,
      diningHall: widget.diningHall,
      isAIGenerated: false,
      id: food.id,
    );

    Navigator.of(context).push(
      StupidSimpleCupertinoSheetRoute(
        child: ItemDetailsScreen(food: food, diningHall: widget.diningHall),
      ),
    );
  }

  Widget _buildFoodItem(Food foodItem, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();

          _showFoodDetails(foodItem);
        },
        child: DefaultContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                foodItem.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: DynamicStyling.getBlack(context),
                                  fontFamily: '.SF Pro Text',
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                foodItem.station,
                                style: TextStyle(
                                  fontSize: 14,

                                  color: DynamicStyling.getDarkGrey(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Nutrition info (show only for individual items)
              if (foodItem.calories > 0)
                Text(
                  foodItem.calories.round().toString() + " cal",
                  style: TextStyle(
                    fontSize: 14,
                    color: DynamicStyling.getDarkGrey(context),
                    fontFamily: '.SF Pro Text',
                    decoration: TextDecoration.none,
                  ),
                ),

              // Labels/allergens
              if (foodItem.labels.isNotEmpty) ...[
                SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: foodItem.labels
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
        ),
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
          color: DynamicStyling.getWhite(context),
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
        color: DynamicStyling.getWhite(context).withOpacity(0.05),
        border: Border.all(
          color: DynamicStyling.getWhite(context).withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: DynamicStyling.getWhite(context),
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
                          color: DynamicStyling.getWhite(context),
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
                          color: DynamicStyling.getWhite(context),
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
