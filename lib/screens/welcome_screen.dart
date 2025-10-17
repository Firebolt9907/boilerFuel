import 'package:boiler_fuel/main.dart';
import 'package:boiler_fuel/screens/onboarding_page.dart';
import 'package:boiler_fuel/screens/user_info_screen.dart';
import 'package:boiler_fuel/widgets/animated_button.dart';
import 'package:boiler_fuel/widgets/default_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  bool _isDisposed = false; // Add this flag to track disposal

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _isDisposed = true; // Set flag before disposing

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Floating decorative elements

          // Main content
          Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24 + MediaQuery.of(context).padding.top,
              bottom:
                  24 +
                  MediaQuery.of(context).padding.bottom +
                  MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.local_dining,
                      color: Colors.white,
                      size: 64,
                    ),
                  ),
                ),
                Text(
                  'BoilerFuel',
                  style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 8),

                // Subtitle with modern styling
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withAlpha(100),
                      width: 1,
                    ),
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withAlpha(30),
                  ),
                  child: Text(
                    ' Your personal dining companion for smart meal planning and nutrition tracking',
                    // style: TextStyle(color: , letterSpacing: 0.5),
                    style: Theme.of(context).textTheme.displaySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 48),

                // Enhanced animated button
                DefaultButton(
                  text: Text(
                    'Get Started',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => OnBoardingPage(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 24),

                // College-themed subtitle
                Text(
                  'Made for Purdue students, by Purdue students',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.6),
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Spacer(),
          // SizedBox(height: 24),
        ],
      ),
    );
  }
}
