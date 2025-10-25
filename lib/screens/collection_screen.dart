import 'package:boiler_fuel/main.dart';
import 'package:boiler_fuel/screens/dining_hall_menu_screen.dart';

import 'package:boiler_fuel/styling.dart';

import 'package:boiler_fuel/screens/item_details_screen.dart';
import 'package:boiler_fuel/widgets/custom_app_bar.dart';
import 'package:boiler_fuel/widgets/default_container.dart';
import 'package:boiler_fuel/widgets/header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';
import 'meal_details_screen.dart';
import "../custom/cupertinoSheet.dart" as customCupertinoSheet;

class CollectionScreen extends StatefulWidget {
  final String collectionName;
  final List<Food> foods;
  final String diningHall;
  final String station;
  final bool isCreatingMeal;
  final List<FoodItem> selectedFoods;

  const CollectionScreen({
    Key? key,
    required this.collectionName,
    required this.foods,
    required this.diningHall,
    required this.station,
    this.selectedFoods = const [],

    this.isCreatingMeal = false,
  }) : super(key: key);

  @override
  _CollectionScreenState createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen>
    with TickerProviderStateMixin {
  List<FoodItem> selectedFoods = [];

  @override
  void initState() {
    super.initState();
    selectedFoods = widget.selectedFoods;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DynamicStyling.getWhite(context),

      body: Column(
        children: [
          Header(
            context: context,
            title: widget.collectionName,
            onBackButtonPressed: () {
              Navigator.of(context).pop<List<FoodItem>>(selectedFoods);
            },
          ),
          // Collection info header
          // _buildCollectionHeader(),
          widget.foods.isEmpty
              ? _buildEmptyView()
              :
                // Foods list
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                      top: 8.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [Expanded(child: _buildFoodsList())],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              color: DynamicStyling.getWhite(context).withOpacity(0.4),
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              'No items in collection',
              style: TextStyle(
                color: DynamicStyling.getWhite(context).withOpacity(0.6),
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: '.SF Pro Display',
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'This collection is currently empty',
              style: TextStyle(
                color: DynamicStyling.getWhite(context).withOpacity(0.4),
                fontSize: 14,
                fontFamily: '.SF Pro Text',
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollectionHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: DynamicStyling.getWhite(context).withOpacity(0.08),
        border: Border.all(
          color: DynamicStyling.getLightGrey(context),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.withOpacity(0.2),
                ),
                child: Icon(Icons.collections, color: Colors.blue, size: 24),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.collectionName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: DynamicStyling.getWhite(context),
                        fontFamily: '.SF Pro Text',
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${widget.foods.length} items from ${widget.station}',
                      style: TextStyle(
                        fontSize: 14,
                        color: DynamicStyling.getWhite(
                          context,
                        ).withOpacity(0.7),
                        fontFamily: '.SF Pro Text',
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFoodsList() {
    return ListView.builder(
      itemCount: widget.foods.length,
      padding: const EdgeInsets.all(0),
      itemBuilder: (context, index) =>
          _buildFoodItem(widget.foods[index], index),
    );
  }

  Widget _buildFoodItem(Food foodItem, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          if (widget.isCreatingMeal) {
            // Return the selected food item to the previous screen
            setState(() {
              if (selectedFoods.any(
                (selected) => selected.firstFood.id == foodItem.id,
              )) {
                selectedFoods.removeWhere(
                  (selected) => selected.firstFood.id == foodItem.id,
                );
                return;
              }
              selectedFoods.add(
                FoodItem(
                  name: foodItem.name,
                  isCollection: false,
                  foods: [foodItem],
                  station: foodItem.station,
                  collection: foodItem.collection,
                ),
              );
            });
          } else {
            _showFoodDetails(foodItem);
          }
        },
        child: DefaultContainer(
          primaryColor:
              selectedFoods.any(
                (selected) => selected.firstFood.id == foodItem.id,
              )
              ? Colors.green
              : null,
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

                        if (foodItem.restricted) ...[
                          SizedBox(height: 4),
                          _buildNutritionChip(
                            "Restriction: ${foodItem.rejectedReason.capitalize()}",
                            Colors.red,
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: DynamicStyling.getWhite(context).withOpacity(0.4),
                    size: 20,
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
      id: food.id,
      isAIGenerated: false,
    );

    customCupertinoSheet.showCupertinoSheet<void>(
      context: context,
      useNestedNavigation: true,
      pageBuilder: (BuildContext context) =>
          ItemDetailsScreen(food: food, diningHall: widget.diningHall),
    );
  }
}
