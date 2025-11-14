import 'package:boiler_fuel/api/local_database.dart';
import 'package:boiler_fuel/widgets/default_container.dart';
import 'package:boiler_fuel/widgets/nutrition_label.dart';
import 'package:bottom_sheet_scroll_physics/bottom_sheet_scroll_physics.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';
import '../styling.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Food food;
  final String? diningHall;
  final User? user;
  final Function(Food)? onFoodUpdated;

  const ItemDetailsScreen({
    Key? key,
    required this.food,
    this.diningHall,
    this.user,
    this.onFoodUpdated,
  });

  @override
  _ItemDetailsScreenState createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen>
    with TickerProviderStateMixin {
  bool isFavorited = false;
  @override
  void initState() {
    super.initState();
    isFavorited = widget.food.isFavorited;
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
              // physics: BottomSheetScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12),
                  if (widget.food.calories != -1 &&
                      widget.food.carbs != -1 &&
                      widget.food.fat != -1 &&
                      widget.food.sugar != -1 &&
                      widget.food.protein != -1) ...[
                    NutritionLabel(food: widget.food),
                  ],
                  SizedBox(height: 20),
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

                  // if (widget.food.calories != -1 &&
                  //     widget.food.carbs != -1 &&
                  //     widget.food.fat != -1 &&
                  //     widget.food.sugar != -1 &&
                  //     widget.food.protein != -1) ...[
                  //   // Nutrition Information Section
                  //   Text(
                  //     "Nutrition Information",
                  //     style: TextStyle(
                  //       fontSize: 18,
                  //       fontWeight: FontWeight.bold,
                  //       color: DynamicStyling.getBlack(context),
                  //       fontFamily: '.SF Pro Display',
                  //       decoration: TextDecoration.none,
                  //     ),
                  //   ),
                  //   SizedBox(height: 12),
                  //   Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Text(
                  //           "Calories",
                  //           style: TextStyle(
                  //             fontSize: 14,

                  //             color: DynamicStyling.getBlack(context),
                  //             fontFamily: '.SF Pro Text',
                  //             decoration: TextDecoration.none,
                  //           ),
                  //         ),
                  //         Text(
                  //           "${widget.food.calories.round()} cal",
                  //           style: TextStyle(
                  //             fontSize: 16,
                  //             color: DynamicStyling.getBlack(
                  //               context,
                  //             ).withOpacity(0.6),
                  //             fontFamily: '.SF Pro Text',
                  //             decoration: TextDecoration.none,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  //   Divider(color: Colors.grey[300]),
                  //   Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Text(
                  //           "Protein",
                  //           style: TextStyle(
                  //             fontSize: 14,

                  //             color: DynamicStyling.getBlack(context),
                  //             fontFamily: '.SF Pro Text',
                  //             decoration: TextDecoration.none,
                  //           ),
                  //         ),
                  //         Text(
                  //           "${widget.food.protein.round()}g",
                  //           style: TextStyle(
                  //             fontSize: 16,
                  //             color: DynamicStyling.getBlack(
                  //               context,
                  //             ).withOpacity(0.6),
                  //             fontFamily: '.SF Pro Text',
                  //             decoration: TextDecoration.none,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  //   Divider(color: Colors.grey[300]),
                  //   Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Text(
                  //           "Carbs",
                  //           style: TextStyle(
                  //             fontSize: 14,

                  //             color: DynamicStyling.getBlack(context),
                  //             fontFamily: '.SF Pro Text',
                  //             decoration: TextDecoration.none,
                  //           ),
                  //         ),
                  //         Text(
                  //           "${widget.food.carbs.round()}g",
                  //           style: TextStyle(
                  //             fontSize: 16,
                  //             color: DynamicStyling.getBlack(
                  //               context,
                  //             ).withOpacity(0.6),
                  //             fontFamily: '.SF Pro Text',
                  //             decoration: TextDecoration.none,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  //   Divider(color: Colors.grey[300]),
                  //   Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Text(
                  //           "Fat",
                  //           style: TextStyle(
                  //             fontSize: 14,

                  //             color: DynamicStyling.getBlack(context),
                  //             fontFamily: '.SF Pro Text',
                  //             decoration: TextDecoration.none,
                  //           ),
                  //         ),
                  //         Text(
                  //           "${widget.food.fat.round()}g",
                  //           style: TextStyle(
                  //             fontSize: 16,
                  //             color: DynamicStyling.getBlack(
                  //               context,
                  //             ).withOpacity(0.6),
                  //             fontFamily: '.SF Pro Text',
                  //             decoration: TextDecoration.none,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  //   Divider(color: Colors.grey[300]),
                  //   Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Text(
                  //           "Sugar",
                  //           style: TextStyle(
                  //             fontSize: 14,

                  //             color: DynamicStyling.getBlack(context),
                  //             fontFamily: '.SF Pro Text',
                  //             decoration: TextDecoration.none,
                  //           ),
                  //         ),
                  //         Text(
                  //           "${widget.food.sugar.round()}g",
                  //           style: TextStyle(
                  //             fontSize: 16,
                  //             color: DynamicStyling.getBlack(
                  //               context,
                  //             ).withOpacity(0.6),
                  //             fontFamily: '.SF Pro Text',
                  //             decoration: TextDecoration.none,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  //   Divider(color: Colors.grey[300]),
                  // ],
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

                  SizedBox(height: MediaQuery.viewPaddingOf(context).bottom),

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
            padding: const EdgeInsets.all(24.0).copyWith(bottom: 18),
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
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: DynamicStyling.getBlack(context),
                          fontFamily: '.SF Pro Display',
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    if (widget.food.quantity > 1) SizedBox(height: 6),
                    if (widget.food.quantity > 1)
                      Text(
                        "${widget.food.quantity} servings",
                        style: TextStyle(
                          fontSize: 14,
                          color: DynamicStyling.getDarkGrey(context),
                          fontFamily: '.SF Pro Text',
                          decoration: TextDecoration.none,
                        ),
                      ),
                  ],
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    splashColor: Colors.yellow.withOpacity(0.15),
                    highlightColor: Colors.yellow.withOpacity(0.08),
                    onTap: () async {
                      HapticFeedback.mediumImpact();
                      await LocalDatabase().toggleFavoriteFood(widget.food);
                      setState(() {
                        isFavorited = !isFavorited;
                      });
                      if (widget.onFoodUpdated != null) {
                        widget.food.isFavorited = !widget.food.isFavorited;
                        widget.onFoodUpdated!(widget.food);
                      }
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
                        isFavorited ? Icons.star : Icons.star_outline,
                        color: isFavorited
                            ? Colors.yellow
                            : DynamicStyling.getBlack(context),
                        size: 20,
                      ),
                    ),
                  ),
                ),
                // if (widget.user.useMealPlanning)
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
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
