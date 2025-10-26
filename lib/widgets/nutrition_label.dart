import 'package:boiler_fuel/constants.dart';
import 'package:boiler_fuel/styling.dart';
import 'package:flutter/material.dart';

class NutritionLabel extends StatelessWidget {
  const NutritionLabel({super.key, this.food, this.meal});
  final Food? food;
  final Meal? meal;

  @override
  Widget build(BuildContext context) {
    if (food == null && meal == null) {
      return Text("No Food or Meal parameter given");
    }

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
              "Serving size " + food!.servingSize,
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
                  ((food!.calories / 10).ceil() * 10).toString(),
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
                        text: '${food!.fat.ceil()}g',
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
                  "${(food!.fat.ceil() * 100 / 65).ceil()}%",
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
            if (food!.saturatedFat != -1) ...[
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
                            text: '${food!.saturatedFat.ceil()}g',
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
                      "${(food!.saturatedFat.ceil() * 100 / 50).ceil()}%",
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
                        text: '${food!.carbs.ceil()}g',
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
                  "${(food!.carbs.ceil() * 100 / 130).ceil()}%",
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
                          text: '${food!.sugar.ceil()}g',
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
            if (food!.addedSugars != -1) ...[
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
                            text: '${food!.addedSugars.ceil()}g',
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
                      "${(food!.addedSugars.ceil() * 100 / 50).ceil()}%",
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
                        text: '${food!.protein.ceil()}g',
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
