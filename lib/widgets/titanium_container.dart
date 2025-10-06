import 'package:flutter/material.dart';

class TitaniumContainer extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry padding;
  final bool warning;
  const TitaniumContainer({
    super.key,
    this.child,
    this.padding = const EdgeInsets.all(20),
    this.warning = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: warning
            ? Colors.red.withAlpha(40)
            : Colors.white.withOpacity(0.05),
        border: Border.all(
          color: warning
              ? Colors.red.withAlpha(120)
              : Colors.white.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: child,
    );
  }
}
