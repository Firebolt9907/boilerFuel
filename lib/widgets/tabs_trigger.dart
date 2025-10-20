import 'package:boiler_fuel/styling.dart';
import 'package:boiler_fuel/constants.dart';
import 'package:flutter/material.dart';

/// Tabs Trigger - individual tab button
class TabsTrigger extends StatefulWidget {
  final TabItem tab;
  final bool isSelected;
  final VoidCallback onTap;

  const TabsTrigger({
    Key? key,
    required this.tab,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  State<TabsTrigger> createState() => _TabsTriggerState();
}

class _TabsTriggerState extends State<TabsTrigger> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color backgroundColor;
    Color textColor;
    Color borderColor;

    if (widget.isSelected) {
      backgroundColor = DynamicStyling.getWhite(context);
      textColor = DynamicStyling.getBlack(context);
      borderColor = Colors.transparent;
    } else {
      backgroundColor = DynamicStyling.getIsDarkMode(context)
          ? Colors.white
          : Color(0xffececf0);
      textColor = DynamicStyling.getIsDarkMode(context)
          ? DynamicStyling.getWhite(context)
          : DynamicStyling.getBlack(context);
      borderColor = Colors.transparent;
    }

    return Expanded(
      child: Focus(
        onFocusChange: (focused) {
          setState(() {
            _isFocused = focused;
          });
        },
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            height: 30,
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(12),
              boxShadow: _isFocused
                  ? [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                        blurRadius: 3,
                        spreadRadius: 3,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.tab.icon != null) ...[
                  Icon(widget.tab.icon, size: 16, color: textColor),
                  const SizedBox(width: 6),
                ],
                Text(
                  widget.tab.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
