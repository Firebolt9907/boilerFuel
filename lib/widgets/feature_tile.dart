import 'package:boiler_fuel/main.dart';
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
      padding: EdgeInsets.all(16),

      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xffe5e5e7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Color(0xff030213), size: 24),
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
                  style: TextStyle(fontSize: 14, color: styling.darkGray),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
