import 'package:boiler_fuel/styling.dart';
import 'package:flutter/material.dart';

class AnimatedDropdownMenu<T> extends StatefulWidget {
  final T? value;
  final String label;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? hint;

  AnimatedDropdownMenu({
    required this.value,
    required this.label,
    required this.items,
    required this.onChanged,
    this.hint,
  });

  @override
  _AnimatedDropdownMenuState<T> createState() =>
      _AnimatedDropdownMenuState<T>();
}

class _AnimatedDropdownMenuState<T> extends State<AnimatedDropdownMenu<T>>
    with SingleTickerProviderStateMixin {
  bool _isFocused = false;

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
      child: DropdownButtonFormField<T>(
        value: widget.value,
        items: widget.items,
        onChanged: widget.onChanged,

        style: TextStyle(color: DynamicStyling.getWhite(context), fontSize: 16),
        dropdownColor: Color(0xFF170d27),
        iconEnabledColor: Colors.blue.shade300,
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: TextStyle(color: Colors.blue.shade300),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
          hintText: widget.hint,
          hintStyle: TextStyle(
            color: DynamicStyling.getWhite(context),
            fontSize: 16,
          ),
        ),
        validator: (value) {
          // Auto-unfocus when validation occurs (typically after selection)

          return null;
        },
        // Custom menu styling
        menuMaxHeight: 200,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
