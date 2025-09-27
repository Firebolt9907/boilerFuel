import 'package:boiler_fuel/screens/dietary_restrictions_screen.dart';
import 'package:boiler_fuel/screens/dining_hall_ranking_screen.dart';
import 'package:boiler_fuel/screens/meal_plan_screen.dart';
import 'package:boiler_fuel/screens/user_info_screen.dart';
import 'package:boiler_fuel/widgets/custom_app_bar.dart';
import 'package:boiler_fuel/widgets/titanium_button.dart';
import 'package:boiler_fuel/widgets/titanium_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';
import '../styling.dart';
import 'dart:math' as math;

class UserSettingsScreen extends StatefulWidget {
  final User user;
  final Function(User) onUserUpdated;

  const UserSettingsScreen({
    Key? key,
    required this.user,
    required this.onUserUpdated,
  }) : super(key: key);

  @override
  _UserSettingsScreenState createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  User? currentUser;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    setState(() {
      currentUser = widget.user;
    });

    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0D1B2A),
                Color(0xFF1B263B),
                Color(0xFF415A77),
                Color(0xFF778DA9),
                Color(0xFF415A77),
              ],
              stops: [0.0, 0.25, 0.5, 0.75, 1.0],
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: CustomAppBar(
              title: 'Settings',
              showBackButton: true,
              onBackButtonPressed: (context) {
                Navigator.of(context).pop();
              },
            ),
          ),
          extendBodyBehindAppBar: false,
          body: Stack(
            children: [
              // Floating decorative elements

              // Main content
              SafeArea(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Quick Actions
                        // _buildQuickActions(),
                        TitaniumButton(
                          title: "User Settings",
                          subtitle:
                              "Change your user preferences, like name, age, weight, and dietary goals.",
                          icon: Icons.person,
                          onTap: () async {
                            User? user = await Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    UserInfoScreen(user: currentUser),
                              ),
                            );
                            if (user != null) {
                              widget.onUserUpdated(user);
                            }
                          },
                        ),
                        // TitaniumButton(
                        //   title: "Deitary Restrictions",
                        //   subtitle:
                        //       "Change your deitary Restrictions, like allergies and food preferences.",
                        //   icon: Icons.no_food,
                        //   onTap: () async {
                        //     User? user = await Navigator.push(
                        //       context,
                        //       CupertinoPageRoute(
                        //         builder: (context) => DietaryRestrictionsScreen(
                        //           user: currentUser!,
                        //           isEditing: true,
                        //         ),
                        //       ),
                        //     );
                        //     if (user != null) {
                        //       widget.onUserUpdated(user);
                        //     }
                        //   },
                        // ),
                        TitaniumButton(
                          title: "Dining Hall Rankings",
                          subtitle:
                              "Change your dining hall rankings to prioritize your favorite dining halls.",
                          icon: Icons.dining,
                          onTap: () async {
                            User? user = await Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => DiningHallRankingScreen(
                                  user: currentUser!,
                                  isEditing: true,
                                ),
                              ),
                            );
                            if (user != null) {
                              widget.onUserUpdated(user);
                            }
                          },
                        ),
                        TitaniumButton(
                          title: "Purdue Meal Plan",
                          subtitle: "Change your current purdue meal plan",
                          icon: Icons.dinner_dining,
                          onTap: () async {
                            User? user = await Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => MealPlanScreen(
                                  user: currentUser!,
                                  isEditing: true,
                                ),
                              ),
                            );
                            if (user != null) {
                              widget.onUserUpdated(user);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
