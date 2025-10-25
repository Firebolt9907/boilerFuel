import 'package:boiler_fuel/styling.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DefaultTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final int? maxLines;
  final TextInputType keyboardType;
  final Function(String)? onChanged;

  DefaultTextField({
    required this.controller,
    this.label,
    this.hint,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.maxLines = 1,
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
        color: DynamicStyling.getLightGrey(context).withAlpha(20),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        onTap: () => HapticFeedback.selectionClick(),
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines,
        style: TextStyle(color: DynamicStyling.getBlack(context), fontSize: 16),
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          labelStyle: TextStyle(color: DynamicStyling.getDarkGrey(context)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.transparent, width: 2),
          ),
          contentPadding: EdgeInsets.all(16),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: DynamicStyling.getDarkGrey(context),
              width: 2,
            ),
          ),
        ),
        cursorColor: DynamicStyling.getDarkGrey(context),
      ),
    );
  }
}
