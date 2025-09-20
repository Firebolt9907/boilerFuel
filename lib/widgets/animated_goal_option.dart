import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class AnimatedGoalOption extends StatefulWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  AnimatedGoalOption({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  _AnimatedGoalOptionState createState() => _AnimatedGoalOptionState();
}

class _AnimatedGoalOptionState extends State<AnimatedGoalOption>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
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
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.isSelected ? Color(0xFF271e37) : Color(0xFF170d27),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.isSelected ? Colors.amber : Colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  widget.isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: widget.isSelected ? Colors.amber : Colors.white70,
                ),
                SizedBox(width: 12),
                Text(
                  widget.text,
                  style: TextStyle(
                    color: widget.isSelected ? Colors.white : Colors.white70,
                    fontSize: 16,
                    fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.normal,
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
