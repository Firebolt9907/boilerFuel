import 'package:boiler_fuel/styling.dart';
import 'package:boiler_fuel/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultContainer extends StatelessWidget {
  final Widget? child;
  final Decoration? decoration;
  final EdgeInsetsGeometry? padding;
  const DefaultContainer({
    super.key,
    this.child,
    this.decoration,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.all(20),
      decoration:
          decoration ??
          BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: DynamicStyling.getWhite(context),
            border: Border.all(
              color: DynamicStyling.getLightGrey(context),
              width: 2,
            ),
          ),
      child: child,
    );
  }
}
