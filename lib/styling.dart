import 'dart:ui';

import 'package:flutter/material.dart';

class Styling {
  static const Color lightTeal = Color(0xffbfedef);
  static const Color mintGreen = Color(0xff98E2C6);
  static const Color slateBlue = Color(0xff6A809D);
  static const Color goldenYellow = Color(0xffeec643);
  static const Color softPink = Color(0xfff194b4);

  Color black = Color(0xff030213);
  Color gray = Color(0xff717181);
  Color darkGray = Color(0xff717182);
}

/// Class with dynamic colors named based on light mode
///
/// Returns:
/// a Color type
///
class DynamicStyling {
  static getBlack(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface;
  }

  static getWhite(BuildContext context) {
    return Theme.of(context).colorScheme.surface;
  }

  static getDarkGrey(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface.withAlpha(170);
  }

  static getGrey(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface.withAlpha(100);
  }

  static getLightGrey(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface.withAlpha(20);
  }

  static getPrimary(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }

  static getIsDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
