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
  static bool isMaterialYou = false;
  static double lightTintMultiplier = 0.25;

  static Color getBlack(BuildContext context) {
    if (isMaterialYou) {
      return Theme.of(context).colorScheme.onPrimaryContainer;
    }
    return Theme.of(context).colorScheme.onSurface;
  }

  static Color getWhite(BuildContext context) {
    if (isMaterialYou && !isDarkMode(context)) {
      Color c = Theme.of(context).colorScheme.primaryContainer;
      var m = lightTintMultiplier;
      List<double> argb = [c.a, c.r * m, c.g * m, c.b * m];
      if (!isDarkMode(context)) {
        argb[1] += (1 - m);
        argb[2] += (1 - m);
        argb[3] += (1 - m);
      }
      argb[0] *= 255;
      argb[1] *= 255;
      argb[2] *= 255;
      argb[3] *= 255;
      // print(c.toARGB32());
      // print(argb);
      return Color.fromARGB(
        argb[0].round(),
        argb[1].round(),
        argb[2].round(),
        argb[3].round(),
      );
    }
    return Theme.of(context).colorScheme.surface;
  }

  static Color getDarkGrey(BuildContext context) {
    if (isMaterialYou) {
      return Theme.of(context).colorScheme.onPrimaryContainer.withAlpha(170);
    }
    return Theme.of(context).colorScheme.onSurface.withAlpha(170);
  }

  static Color getGrey(BuildContext context) {
    if (isMaterialYou) {
      return Theme.of(context).colorScheme.onPrimaryContainer.withAlpha(100);
    }
    return Theme.of(context).colorScheme.onSurface.withAlpha(100);
  }

  static Color getLightGrey(BuildContext context) {
    if (isMaterialYou) {
      return Theme.of(context).colorScheme.onPrimaryContainer.withAlpha(20);
    }
    return Theme.of(context).colorScheme.onSurface.withAlpha(20);
  }

  static Color getPrimary(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
