import 'package:boiler_fuel/constants.dart';
import 'package:boiler_fuel/styling.dart';
import 'package:flutter/material.dart';

class NutritionLabel extends StatelessWidget {
  const NutritionLabel({super.key, this.food, this.meal});
  final Food? food;
  final Meal? meal;

  @override
  Widget build(BuildContext context) {
    if (food != null) {
      return _buildLabel(
        context,
        food!.servingSize,
        food!.calories,
        food!.fat,
        food!.saturatedFat,
        food!.carbs,
        food!.sugar,
        food!.addedSugars,
        food!.protein,
      );
    }
    if (meal != null) {
      return _buildLabel(
        context,
        "",
        meal!.calories,
        meal!.fat,
        meal!.saturatedFat,
        meal!.carbs,
        meal!.sugar,
        meal!.addedSugars,
        meal!.protein,
      );
    }

    return Text("No Food or Meal parameter given");
  }

  Widget _buildLabel(
    BuildContext context,
    String servingSize,
    double calories,
    double fat,
    double saturatedFat,
    double carbs,
    double sugar,
    double addedSugars,
    double protein,
  ) {
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

            servingSize != ""
                ? Text(
                    "Serving size " + servingSize,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: DynamicStyling.getBlack(context),
                      fontFamily: '.SF Pro Display',
                      decoration: TextDecoration.none,
                      height: 0,
                    ),
                  )
                : Container(),

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
                  ((calories / 10).ceil() * 10).toString(),
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
                        text: '${fat.ceil()}g',
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
                  "${(fat.ceil() * 100 / 65).ceil()}%",
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
            if (saturatedFat != -1) ...[
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
                            text: '${saturatedFat.ceil()}g',
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
                      "${(saturatedFat.ceil() * 100 / 50).ceil()}%",
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
                        text: '${carbs.ceil()}g',
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
                  "${(carbs.ceil() * 100 / 130).ceil()}%",
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

            Padding(
              padding: const EdgeInsets.only(
                left: 0,
              ), // change to 20 if making fda-compliant
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Total Sugars ',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight
                                .w900, // change to w400 if making fda-compliant
                            color: DynamicStyling.getBlack(context),
                            fontFamily: '.SF Pro Display',
                            decoration: TextDecoration.none,
                          ),
                        ),
                        TextSpan(
                          text: '${sugar.ceil()}g',
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
                    "",
                    // "${(food!.sugar.ceil() * 100 / 50).ceil()}%",
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
            if (addedSugars != -1) ...[
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                ), // change to 40 if making fda-compliant
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
                            text: '${addedSugars.ceil()}g',
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
                      "${(addedSugars.ceil() * 100 / 50).ceil()}%",
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
                        text: '${protein.ceil()}g',
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
                // the FDA actually removed the DV for protein
                // Text(
                //   "${(food!.protein * 100 / 50).ceil()}%",
                //   style: TextStyle(
                //     fontSize: 15,
                //     fontWeight: FontWeight.w900,
                //     color: DynamicStyling.getBlack(context),
                //     fontFamily: '.SF Pro Display',
                //     decoration: TextDecoration.none,
                //   ),
                // ),
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
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: DynamicStyling.getBlack(context),
                      fontFamily: '.SF Pro Display',
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
