import 'package:boiler_fuel/main.dart';
import 'package:boiler_fuel/styling.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeatureChoiceTile extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final ValueChanged<bool?>? onChanged;

  const FeatureChoiceTile({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onChanged != null) {
          onChanged!(!isSelected);
        }
      },
      child: Container(
        padding: EdgeInsets.all(16),

        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: DynamicStyling.getLightGrey(context),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: DynamicStyling.getBlack(context),
                size: 24,
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: DynamicStyling.getDarkGrey(context),
                    ),
                  ),
                ],
              ),
            ),
            Checkbox(
              value: isSelected,
              onChanged: onChanged,
              activeColor: DynamicStyling.getBlack(context),
            ),
          ],
        ),
      ),
    );
  }
}
