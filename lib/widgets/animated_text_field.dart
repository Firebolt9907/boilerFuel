import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimatedTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;

  AnimatedTextField({
    required this.controller,
    required this.label,
    this.keyboardType = TextInputType.text,
  });

  @override
  _AnimatedTextFieldState createState() => _AnimatedTextFieldState();
}

class _AnimatedTextFieldState extends State<AnimatedTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF170d27),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isFocused ? Colors.blue.shade300 : Colors.transparent,
            width: 2,
          ),
        ),
        child: TextField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          style: TextStyle(color: Colors.white, fontSize: 16),
          onTap: () {
            setState(() => _isFocused = true);
            _controller.forward();
          },
          onEditingComplete: () {
            setState(() => _isFocused = false);
            _controller.reverse();
          },
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: TextStyle(
              color: _isFocused ? Colors.blue.shade300 : Colors.white70,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(16),
          ),
          cursorColor: Colors.blue.shade300,
        ),
      ),
    );
  }
}
