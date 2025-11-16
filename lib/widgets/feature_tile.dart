import 'package:boiler_fuel/main.dart';
import 'package:boiler_fuel/styling.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeatureTile extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  const FeatureTile({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: DynamicStyling.getWhite(context), width: 0),
        borderRadius: BorderRadius.circular(16),
        color: DynamicStyling.getWhite(context),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: DynamicStyling.getWhite(context),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: DynamicStyling.getBlack(context),
              size: 22,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: DynamicStyling.getBlack(context),
                    letterSpacing: 0.2,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: DynamicStyling.getDarkGrey(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
