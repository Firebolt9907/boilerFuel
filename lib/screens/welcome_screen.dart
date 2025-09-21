import 'package:boiler_fuel/models/user_model.dart';
import 'package:boiler_fuel/screens/user_info_screen.dart';
import 'package:boiler_fuel/widgets/animated_button.dart';
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
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _floatingController = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    _rotationController = AnimationController(
      duration: Duration(milliseconds: 20000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    _floatingAnimation = Tween<double>(begin: -20.0, end: 20.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    // Start animations with delays for staggered effect
    _fadeController.forward();
    Future.delayed(Duration(milliseconds: 300), () {
      _scaleController.forward();
    });
    Future.delayed(Duration(milliseconds: 600), () {
      _floatingController.repeat(reverse: true);
      _pulseController.repeat(reverse: true);
      _rotationController.repeat();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black,
              Color(0xFF0D1B2A),
              Color(0xFF1B263B),
              Color(0xFF415A77),
              Color(0xFF778DA9),
            ],
            stops: [0.0, 0.25, 0.5, 0.75, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Floating decorative elements
            ...List.generate(
              6,
              (index) => Positioned(
                left: (index * 60.0) % MediaQuery.of(context).size.width,
                top: (index * 120.0) % MediaQuery.of(context).size.height,
                child: AnimatedBuilder(
                  animation: _floatingAnimation,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(
                      math.sin(_floatingAnimation.value / 10 + index) * 15,
                      _floatingAnimation.value +
                          math.cos(_floatingAnimation.value / 8 + index) * 10,
                    ),
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) => Transform.scale(
                        scale: _pulseAnimation.value * (0.3 + index * 0.1),
                        child: Container(
                          width: 20 + (index * 5),
                          height: 20 + (index * 5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: [
                              Colors.amber.withOpacity(0.1),
                              Colors.blue.withOpacity(0.08),
                              Colors.cyan.withOpacity(0.06),
                              Colors.orange.withOpacity(0.04),
                              Colors.purple.withOpacity(0.03),
                              Colors.green.withOpacity(0.02),
                            ][index],
                            boxShadow: [
                              BoxShadow(
                                color: [
                                  Colors.amber,
                                  Colors.blue,
                                  Colors.cyan,
                                  Colors.orange,
                                  Colors.purple,
                                  Colors.green,
                                ][index].withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Main content
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spacer(),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Column(
                          children: [
                            // Animated icon with rotation and glow
                            AnimatedBuilder(
                              animation: _rotationAnimation,
                              builder: (context, child) => Transform.rotate(
                                angle: _rotationAnimation.value * 0.1,
                                child: AnimatedBuilder(
                                  animation: _pulseAnimation,
                                  builder: (context, child) => Container(
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          Colors.amber.withOpacity(0.3),
                                          Colors.amber.withOpacity(0.1),
                                          Colors.transparent,
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.amber.withOpacity(0.4),
                                          blurRadius:
                                              30 * _pulseAnimation.value,
                                          spreadRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.restaurant_menu,
                                      size: 80,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 32),

                            // App title with enhanced styling
                            ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                colors: [
                                  Colors.white,
                                  Colors.amber,
                                  Colors.blue.shade300,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds),
                              child: Text(
                                'BoilerFuel',
                                style: TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.3),
                                      offset: Offset(2, 2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 16),

                            // Subtitle with modern styling
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                                color: Colors.white.withOpacity(0.05),
                              ),
                              child: Text(
                                'Your personalized dining companion',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 0.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 48),

                            // Enhanced animated button
                            AnimatedButton(
                              text: 'Get Started',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => UserInfoScreen(),
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
                    ),
                    Spacer(),

                    // Bottom floating indicators
                    // AnimatedBuilder(
                    //   animation: _floatingAnimation,
                    //   builder: (context, child) => Transform.translate(
                    //     offset: Offset(0, _floatingAnimation.value * 0.3),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: List.generate(
                    //         3,
                    //         (index) => Container(
                    //           margin: EdgeInsets.symmetric(horizontal: 4),
                    //           width: 8,
                    //           height: 8,
                    //           decoration: BoxDecoration(
                    //             shape: BoxShape.circle,
                    //             color: Colors.white.withOpacity(
                    //               0.3 + index * 0.1,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
