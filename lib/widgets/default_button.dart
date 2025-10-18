import 'package:boiler_fuel/main.dart';

import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  final Widget text;
  final VoidCallback onTap;
  final double? width;
  final bool isEnabled;
  const DefaultButton({
    super.key,
    required this.text,
    required this.onTap,
    this.width,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled ? onTap : () {},

        child: text,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          backgroundColor: isEnabled
              ? Theme.of(context).buttonTheme.colorScheme!.onSurface
              : Color(0xff818089),
        ),
      ),
    );
  }
}
