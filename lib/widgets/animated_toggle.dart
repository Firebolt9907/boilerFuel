import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimatedSwitch extends StatefulWidget {
  final String text;
  final Function(bool) onTap;
  final bool isEnabled;
  final bool initialValue;

  AnimatedSwitch({
    required this.text,
    required this.onTap,
    this.isEnabled = true,
    required this.initialValue,
  });

  @override
  _AnimatedSwitchState createState() => _AnimatedSwitchState();
}

class _AnimatedSwitchState extends State<AnimatedSwitch>
    with SingleTickerProviderStateMixin {
  bool _isToggled = false;

  @override
  void initState() {
    super.initState();
    _isToggled = widget.initialValue;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: widget.isEnabled
          ? (_) {
              setState(() => _isToggled = !_isToggled);
              widget.onTap(_isToggled);

              HapticFeedback.lightImpact();
            }
          : null,
      // onTapUp: widget.isEnabled
      //     ? (_) {
      //         setState(() => _isToggled = false);

      //         widget.onTap();
      //       }
      //     : null,
      onTapCancel: widget.isEnabled
          ? () {
              setState(() => _isToggled = !_isToggled);
              widget.onTap(_isToggled);
            }
          : null,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 16),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 18, horizontal: 24),
        decoration: BoxDecoration(
          gradient: _isToggled
              ? LinearGradient(
                  colors: [
                    Colors.blue.shade300,
                    Colors.lightBlueAccent,
                    Color(0xFF61A5C2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(colors: [Colors.grey, Colors.grey]),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          boxShadow: widget.isEnabled && !_isToggled
              ? [
                  BoxShadow(
                    color: Colors.blue.shade300.withOpacity(0.4),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                widget.text,
                textAlign: TextAlign.left,
                overflow: TextOverflow.visible,
                softWrap: true,
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
            ),
            CupertinoSwitch(
              value: _isToggled,
              onChanged: (value) {
                if (widget.isEnabled) {
                  setState(() => _isToggled = value);
                  widget.onTap(_isToggled);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
