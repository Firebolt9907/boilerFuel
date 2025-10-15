import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DefaultTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final TextInputType keyboardType;
  final Function(String)? onChanged;

  DefaultTextField({
    required this.controller,
    this.label,
    this.hint,
    this.keyboardType = TextInputType.text,
    this.onChanged,
  });

  @override
  _DefaultTextFieldState createState() => _DefaultTextFieldState();
}

class _DefaultTextFieldState extends State<DefaultTextField>
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
        color: Color(0xFFf3f3f5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        style: TextStyle(color: Colors.black, fontSize: 16),
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          labelStyle: TextStyle(color: Color(0xff717182)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFFf3f3f5), width: 2),
          ),
          contentPadding: EdgeInsets.all(16),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xff717182), width: 2),
          ),
        ),
        cursorColor: Color(0xff717182),
      ),
    );
  }
}
