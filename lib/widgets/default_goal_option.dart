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
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.isSelected ? Color(0xfff3f3f5) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.transparent, width: 2),
          ),
          child: Row(
            children: [
              Icon(
                widget.isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: Colors.black,
              ),
              SizedBox(width: 12),
              Text(
                widget.text,
                style: TextStyle(
                  color: Colors.black,
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
