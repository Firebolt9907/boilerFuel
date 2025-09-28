import 'package:flutter/material.dart';

class TitaniumContainer extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry padding;
  const TitaniumContainer({
    super.key,
    this.child,
    this.padding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
      ),
      child: child,
    );
  }
}
