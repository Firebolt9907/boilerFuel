import 'package:boiler_fuel/styling.dart';
import 'package:boiler_fuel/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultContainer extends StatelessWidget {
  final Widget? child;
  final Decoration? decoration;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? splashColor;
  final Color? primaryColor;

  const DefaultContainer({
    super.key,
    this.child,
    this.decoration,
    this.padding,
    this.onTap,
    this.splashColor,
    this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    // Default non-interactive container
    final defaultDecoration =
        decoration ??
        BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color:
              primaryColor?.withAlpha(40) ?? DynamicStyling.getWhite(context),
          border: Border.all(
            color:
                primaryColor?.withAlpha(100) ??
                DynamicStyling.getLightGrey(context),
            width: 2,
          ),
        );
    final BorderRadius resolvedRadius =
        defaultDecoration is BoxDecoration &&
            defaultDecoration.borderRadius != null
        ? (defaultDecoration.borderRadius as BorderRadius)
        : BorderRadius.circular(20);

    if (onTap != null) {
      // When interactive, put visual decoration on the Material so InkWell's
      // splash is visible above it.
      return Material(
        color: Colors.transparent,
        shape:
            defaultDecoration is BoxDecoration &&
                defaultDecoration.borderRadius != null
            ? RoundedRectangleBorder(borderRadius: resolvedRadius)
            : null,
        child: Ink(
          decoration: defaultDecoration,
          child: InkWell(
            borderRadius: resolvedRadius,
            splashColor: splashColor ?? Theme.of(context).splashColor,
            onTap: onTap,
            child: Padding(
              padding: padding ?? EdgeInsets.all(20),
              child: child,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: padding ?? EdgeInsets.all(20),
      decoration: defaultDecoration,
      child: child,
    );
  }
}
