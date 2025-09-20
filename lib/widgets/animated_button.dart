import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final bool isEnabled;

  AnimatedButton({
    required this.text,
    required this.onTap,
    this.isEnabled = true,
  });

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.isEnabled
          ? (_) {
              setState(() => _isPressed = true);
              _controller.forward();
              HapticFeedback.lightImpact();
            }
          : null,
      onTapUp: widget.isEnabled
          ? (_) {
              setState(() => _isPressed = false);
              _controller.reverse();
              widget.onTap();
            }
          : null,
      onTapCancel: widget.isEnabled
          ? () {
              setState(() => _isPressed = false);
              _controller.reverse();
            }
          : null,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 18, horizontal: 24),
          decoration: BoxDecoration(
            gradient: widget.isEnabled
                ? LinearGradient(
                    colors: [
                      Color(0xFF4C956C),
                      Color(0xFF2F9B69),
                      Color(0xFF61A5C2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : LinearGradient(colors: [Colors.grey, Colors.grey]),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
            boxShadow: widget.isEnabled && !_isPressed
                ? [
                    BoxShadow(
                      color: Color(0xFF4C956C).withOpacity(0.4),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
