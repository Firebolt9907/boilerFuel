import 'package:boiler_fuel/api/local_database.dart';
import 'package:boiler_fuel/widgets/default_container.dart';
import 'package:bottom_sheet_scroll_physics/bottom_sheet_scroll_physics.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';
import '../styling.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Food food;
  final String? diningHall;

  const ItemDetailsScreen({
    Key? key,
    required this.food,
    this.diningHall,
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
              physics: BottomSheetScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12),
                  if (widget.food.calories != -1 &&
                      widget.food.carbs != -1 &&
                      widget.food.fat != -1 &&
                      widget.food.sugar != -1 &&
                      widget.food.protein != -1) ...[
                    _buildNutritionLabel(context, widget.food),
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
        // border: Border(
        //   bottom: BorderSide(
        //     color: Colors.,
        //     width: 2,
        //   ),
        // ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Padding(
            padding: const EdgeInsets.all(24.0).copyWith(bottom: 0),
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
                  ],
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    splashColor: Colors.red.withOpacity(0.15),
                    highlightColor: Colors.red.withOpacity(0.08),
                    onTap: () async {
                      HapticFeedback.mediumImpact();
                      await LocalDatabase().toggleFavoriteFood(widget.food);
                      setState(() {
                        isFavorited = !isFavorited;
                      });
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
                        isFavorited
                            ? Icons.bookmark_added
                            : Icons.bookmark_add_outlined,
                        color: isFavorited
                            ? Colors.red
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

Widget _buildNutritionLabel(BuildContext context, Food food) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: DynamicStyling.getLightGrey(context),
      borderRadius: BorderRadius.circular(20),
    ),
    child: DefaultTextStyle.merge(
      style: TextStyle(letterSpacing: -1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Nutrition Facts",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: DynamicStyling.getBlack(context),
              fontFamily: '.SF Pro Display',
              decoration: TextDecoration.none,
              height: 0,
            ),
          ),

          Text(
            "Serving size " + food.servingSize,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: DynamicStyling.getBlack(context),
              fontFamily: '.SF Pro Display',
              decoration: TextDecoration.none,
              height: 0,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3),
            child: Container(
              color: DynamicStyling.getBlack(context),
              height: 15,
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Amount Per Serving",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: DynamicStyling.getBlack(context),
                      fontFamily: '.SF Pro Display',
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    "Calories",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: DynamicStyling.getBlack(context),
                      fontFamily: '.SF Pro Display',
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
              Text(
                ((food.calories / 10).floor() * 10).toString(),
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: DynamicStyling.getBlack(context),
                  fontFamily: '.SF Pro Display',
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),

          Container(color: DynamicStyling.getBlack(context), height: 5),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                "% Daily Value*",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: DynamicStyling.getBlack(context),
                  fontFamily: '.SF Pro Display',
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),

          Container(color: DynamicStyling.getGrey(context), height: 1),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Total Fat ',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: DynamicStyling.getBlack(context),
                        fontFamily: '.SF Pro Display',
                        decoration: TextDecoration.none,
                      ),
                    ),
                    TextSpan(
                      text: '${food.fat.ceil()}g',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: DynamicStyling.getBlack(context),
                        fontFamily: '.SF Pro Text',
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "${(food.fat * 100 / 65).ceil()}%",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: DynamicStyling.getBlack(context),
                  fontFamily: '.SF Pro Display',
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),

          Container(color: DynamicStyling.getGrey(context), height: 1),
          if (food.saturatedFat != -1) ...[
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Saturated Fat ',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: DynamicStyling.getBlack(context),
                            fontFamily: '.SF Pro Display',
                            decoration: TextDecoration.none,
                          ),
                        ),
                        TextSpan(
                          text: '${food.saturatedFat.ceil()}g',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: DynamicStyling.getBlack(context),
                            fontFamily: '.SF Pro Text',
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "${(food.saturatedFat * 100 / 50).ceil()}%",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: DynamicStyling.getBlack(context),
                      fontFamily: '.SF Pro Display',
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
            Container(color: DynamicStyling.getGrey(context), height: 1),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Total Carbohydrate ',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: DynamicStyling.getBlack(context),
                        fontFamily: '.SF Pro Display',
                        decoration: TextDecoration.none,
                      ),
                    ),
                    TextSpan(
                      text: '${food.carbs.ceil()}g',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: DynamicStyling.getBlack(context),
                        fontFamily: '.SF Pro Text',
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "${(food.carbs * 100 / 130).ceil()}%",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: DynamicStyling.getBlack(context),
                  fontFamily: '.SF Pro Display',
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),

          Container(color: DynamicStyling.getGrey(context), height: 1),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Total Sugars ',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: DynamicStyling.getBlack(context),
                        fontFamily: '.SF Pro Display',
                        decoration: TextDecoration.none,
                      ),
                    ),
                    TextSpan(
                      text: '${food.sugar.ceil()}g',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: DynamicStyling.getBlack(context),
                        fontFamily: '.SF Pro Text',
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "${(food.sugar * 100 / 50).ceil()}%",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: DynamicStyling.getBlack(context),
                  fontFamily: '.SF Pro Display',
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),

          Container(color: DynamicStyling.getGrey(context), height: 1),
          if (food.addedSugars != -1) ...[
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Added Sugars ',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: DynamicStyling.getBlack(context),
                            fontFamily: '.SF Pro Display',
                            decoration: TextDecoration.none,
                          ),
                        ),
                        TextSpan(
                          text: '${food.addedSugars.ceil()}g',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: DynamicStyling.getBlack(context),
                            fontFamily: '.SF Pro Text',
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "${(food.addedSugars * 100 / 50).ceil()}%",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: DynamicStyling.getBlack(context),
                      fontFamily: '.SF Pro Display',
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
            Container(color: DynamicStyling.getGrey(context), height: 1),
          ],

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Protein ',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: DynamicStyling.getBlack(context),
                        fontFamily: '.SF Pro Display',
                        decoration: TextDecoration.none,
                      ),
                    ),
                    TextSpan(
                      text: '${food.protein.ceil()}g',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: DynamicStyling.getBlack(context),
                        fontFamily: '.SF Pro Text',
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "${(food.protein * 100 / 50).ceil()}%",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: DynamicStyling.getBlack(context),
                  fontFamily: '.SF Pro Display',
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Container(
              color: DynamicStyling.getBlack(context),
              height: 15,
            ),
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                " * ",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: DynamicStyling.getBlack(context),
                  fontFamily: '.SF Pro Display',
                  decoration: TextDecoration.none,
                ),
              ),
              Flexible(
                child: Text(
                  "The % Daily Value (DV) tells you how much a nutrient in a serving of food contributes to a daily diet. 2,000 calories a day is used for general nutrition advice.",
                  softWrap: true,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
