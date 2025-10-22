import 'package:boiler_fuel/styling.dart';
import 'package:boiler_fuel/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DefaultGoalOption extends StatefulWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  DefaultGoalOption({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  _DefaultGoalOptionState createState() => _DefaultGoalOptionState();
}

class _DefaultGoalOptionState extends State<DefaultGoalOption>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTapDown: (_) {
          _controller.forward();
          HapticFeedback.selectionClick();
        },
        onTapUp: (_) {
          _controller.reverse();
          widget.onTap();
        },
        onTapCancel: () => _controller.reverse(),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: widget.isSelected ? 10 : 16,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: DynamicStyling.getLightGrey(
              context,
            ).withAlpha(widget.isSelected ? 20 : 0),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.isSelected
                  ? Colors.transparent
                  : DynamicStyling.getLightGrey(context),
              width: widget.isSelected ? 8 : 2,
            ),
          ),

          child: Row(
            children: [
              Icon(
                widget.isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: DynamicStyling.getBlack(context),
              ),
              SizedBox(width: 12),
              Text(
                widget.text,
                style: TextStyle(
                  color: DynamicStyling.getBlack(context),
                  fontSize: 16,
                  fontWeight: widget.isSelected
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
