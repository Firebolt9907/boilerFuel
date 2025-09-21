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
        child: DropdownButtonFormField<T>(
          value: widget.value,
          items: widget.items,
          onChanged: widget.onChanged,
          onTap: () {
            setState(() => _isFocused = true);
            _controller.forward();
          },
          style: TextStyle(color: Colors.white, fontSize: 16),
          dropdownColor: Color(0xFF170d27),
          iconEnabledColor: _isFocused ? Colors.blue.shade300 : Colors.white70,
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: TextStyle(
              color: _isFocused ? Colors.blue.shade300 : Colors.white70,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(16),
            hintText: widget.hint,
            hintStyle: TextStyle(color: Colors.white54, fontSize: 16),
          ),
          validator: (value) {
            // Auto-unfocus when validation occurs (typically after selection)
            if (_isFocused) {
              Future.delayed(Duration(milliseconds: 100), () {
                if (mounted) {
                  setState(() => _isFocused = false);
                  _controller.reverse();
                }
              });
            }
            return null;
          },
          // Custom menu styling
          menuMaxHeight: 200,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
