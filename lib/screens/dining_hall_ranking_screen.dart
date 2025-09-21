import 'package:boiler_fuel/constants.dart';
import 'package:flutter/cupertino.dart' hide AnimatedList;
import 'package:flutter/material.dart' hide AnimatedList;
// Add these imports for your custom code:

import '../../widgets/animated_list.dart';
import '../../widgets/animated_button.dart';
import 'meal_plan_screen.dart';
import 'dart:math' as math;

class DiningHallRankingScreen extends StatefulWidget {
  final User user;

  DiningHallRankingScreen({required this.user});

  @override
  _DiningHallRankingScreenState createState() =>
      _DiningHallRankingScreenState();
}

class _DiningHallRankingScreenState extends State<DiningHallRankingScreen>
    with TickerProviderStateMixin {
  List<String> diningHalls = [
    'Earhart',
    'Ford',
    'Hillenbrand',
    'Wiley',
    'Windsor',
  ];
  List<String> rankedHalls = [];
  late AnimationController _animationController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _floatingController = AnimationController(
      duration: Duration(milliseconds: 4500),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _floatingAnimation = Tween<double>(begin: -20.0, end: 20.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );
    _pulseAnimation = Tween<double>(begin: 0.5, end: 1.4).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    Future.delayed(Duration(milliseconds: 600), () {
      _floatingController.repeat(reverse: true);
      _pulseController.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onItemSelect(String item, int index) {
    setState(() {
      if (!rankedHalls.contains(item)) {
        rankedHalls.add(item);
      } else {
        rankedHalls.remove(item);
      }
    });
  }

  void _continue() {
    if (rankedHalls.length == 5) {
      widget.user.diningHallRank = rankedHalls;
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => MealPlanScreen(user: widget.user),
        ),
      );
    }
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
                left: (index * 65.0) % MediaQuery.of(context).size.width,
                top: (index * 110.0) % MediaQuery.of(context).size.height,
                child: AnimatedBuilder(
                  animation: _floatingAnimation,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(
                      math.sin(_floatingAnimation.value / 18 + index) * 8,
                      _floatingAnimation.value +
                          math.cos(_floatingAnimation.value / 14 + index) * 5,
                    ),
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) => Transform.scale(
                        scale: _pulseAnimation.value * (0.12 + index * 0.05),
                        child: Container(
                          width: 10 + (index * 5),
                          height: 10 + (index * 5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: [
                              Colors.red.withOpacity(0.1),
                              Colors.orange.withOpacity(0.08),
                              Colors.yellow.withOpacity(0.06),
                              Colors.green.withOpacity(0.05),
                              Colors.blue.withOpacity(0.04),
                              Colors.purple.withOpacity(0.03),
                            ][index],
                            boxShadow: [
                              BoxShadow(
                                color: [
                                  Colors.red,
                                  Colors.orange,
                                  Colors.yellow,
                                  Colors.green,
                                  Colors.blue,
                                  Colors.purple,
                                ][index].withOpacity(0.12),
                                blurRadius: 4,
                                spreadRadius: 1,
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
            FadeTransition(
              opacity: _fadeAnimation,
              child: SizedBox(
                height: double.infinity,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back button with modern styling
                      Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.paddingOf(context).top,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                      SizedBox(height: 32),

                      // Enhanced title with emoji and styling
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.red.shade300,
                            Colors.orange.shade200,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: Text(
                          'Rank your dining halls',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white.withOpacity(0.05),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'Select all 5 dining halls in order of preference',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      SizedBox(height: 32),

                      // Enhanced dining halls list
                      Container(
                        height: 400,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white.withOpacity(0.05),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.15),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Available Dining Halls',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: rankedHalls.length >= 5
                                        ? Colors.green.withOpacity(0.2)
                                        : Colors.orange.withOpacity(0.2),
                                    border: Border.all(
                                      color: rankedHalls.length >= 5
                                          ? Colors.green.withOpacity(0.5)
                                          : Colors.orange.withOpacity(0.5),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    '${rankedHalls.length}/5',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: rankedHalls.length == 5
                                          ? Colors.green.shade300
                                          : Colors.orange.shade300,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 16),
                            Container(
                              height: 320,
                              child: AnimatedList(
                                items: diningHalls,
                                onItemSelect: _onItemSelect,
                                selectedItems: rankedHalls,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24),

                      // Rankings display
                      // Container(
                      //   padding: EdgeInsets.all(16),
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(20),
                      //     color: Colors.white.withOpacity(0.05),
                      //     border: Border.all(
                      //       color: Colors.white.withOpacity(0.15),
                      //       width: 1,
                      //     ),
                      //   ),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Row(
                      //         children: [
                      //           Text(
                      //             'Your Rankings',
                      //             style: TextStyle(
                      //               fontSize: 18,
                      //               fontWeight: FontWeight.w600,
                      //               color: Colors.white,
                      //               letterSpacing: 0.5,
                      //             ),
                      //           ),
                      //           Spacer(),
                      //     Container(
                      //       padding: EdgeInsets.symmetric(
                      //         horizontal: 12,
                      //         vertical: 4,
                      //       ),
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(12),
                      //         color: rankedHalls.length >= 3
                      //             ? Colors.green.withOpacity(0.2)
                      //             : Colors.orange.withOpacity(0.2),
                      //         border: Border.all(
                      //           color: rankedHalls.length >= 3
                      //               ? Colors.green.withOpacity(0.5)
                      //               : Colors.orange.withOpacity(0.5),
                      //           width: 1,
                      //         ),
                      //       ),
                      //       child: Text(
                      //         '${rankedHalls.length}/3 minimum',
                      //         style: TextStyle(
                      //           fontSize: 12,
                      //           color: rankedHalls.length >= 3
                      //               ? Colors.green.shade300
                      //               : Colors.orange.shade300,
                      //           fontWeight: FontWeight.w500,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      //       SizedBox(height: 12),
                      //       ...rankedHalls.asMap().entries.map(
                      //         (entry) => Container(
                      //           margin: EdgeInsets.only(bottom: 8),
                      //           child: RankingItem(
                      //             rank: entry.key + 1,
                      //             name: entry.value,
                      //             onRemove: () {
                      //               setState(() {
                      //                 rankedHalls.removeAt(entry.key);
                      //               });
                      //             },
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      // SizedBox(height: 24),

                      // Enhanced continue button
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) => Transform.scale(
                          scale: (rankedHalls.length == 5) ? 1.0 : 0.98,
                          child: AnimatedButton(
                            text: rankedHalls.length < 5
                                ? 'Select more to continue'
                                : 'Continue to Meal Plans',
                            onTap: _continue,
                            isEnabled: rankedHalls.length == 5,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Progress indicator
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: List.generate(
                      //     5,
                      //     (index) => Container(
                      //       margin: EdgeInsets.symmetric(horizontal: 4),
                      //       width: index == 1 ? 20 : 8,
                      //       height: 8,
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(4),
                      //         color: index == 1
                      //             ? Colors.orange.shade400
                      //             : Colors.white.withOpacity(0.3),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
