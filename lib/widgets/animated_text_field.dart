import 'package:boiler_fuel/styling.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF170d27),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.transparent, width: 2),
      ),
      child: TextField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        style: TextStyle(color: DynamicStyling.getWhite(context), fontSize: 16),

        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: TextStyle(color: Colors.blue.shade300),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
        cursorColor: Colors.blue.shade300,
      ),
    );
  }
}
