import 'package:boiler_fuel/api/local_database.dart';
import 'package:boiler_fuel/main.dart';
import 'package:boiler_fuel/screens/dietary_restrictions_screen.dart';
import 'package:boiler_fuel/screens/dining_hall_ranking_screen.dart';
import 'package:boiler_fuel/screens/meal_plan_screen.dart';
import 'package:boiler_fuel/screens/user_info_screen.dart';
import 'package:boiler_fuel/screens/welcome_screen.dart';
import 'package:boiler_fuel/widgets/custom_app_bar.dart';
import 'package:boiler_fuel/widgets/settings_button.dart';
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
    return Scaffold(
      backgroundColor: Colors.grey[50],

      extendBodyBehindAppBar: false,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: DynamicStyling.getWhite(context),
              border: Border(
                bottom: BorderSide(color: DynamicStyling.getGrey(context)),
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: styling.gray,
                        ),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          Navigator.of(context).pop();
                        },
                      ),

                      Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: styling.gray,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24.0, bottom: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Settings",
                            style: TextStyle(
                              fontSize: 24,
                              color: DynamicStyling.getBlack(context),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header

                  // Quick Actions
                  // _buildQuickActions(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SettingsButton(
                      title: "User Settings",
                      subtitle:
                          "Change your user preferences, like name, age, weight, and dietary goals.",
                      icon: Icons.person,
                      onTap: () async {
                        HapticFeedback.mediumImpact();
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
                  ),
                  // TitaniumButton(
                  //   title: "Dietary Restrictions",
                  //   subtitle:
                  //       "Change your dietary restrictions, like allergies and food preferences.",
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SettingsButton(
                      title: "Dining Hall Rankings",
                      subtitle:
                          "Change your dining hall rankings to prioritize your favorite dining halls.",
                      icon: Icons.dining,
                      onTap: () async {
                        HapticFeedback.mediumImpact();
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
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SettingsButton(
                      title: "Dietary Restrictions",
                      subtitle:
                          "Change your dietary restrictions, like allergies and food preferences.",
                      icon: Icons.no_food,
                      onTap: () async {
                        HapticFeedback.mediumImpact();
                        User? user = await Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => DietaryRestrictionsScreen(
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
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: SettingsButton(
                  //     title: "Purdue Meal Plan",
                  //     subtitle: "Change your current purdue meal plan",
                  //     icon: Icons.dinner_dining,
                  //     onTap: () async {
                  //       User? user = await Navigator.push(
                  //         context,
                  //         CupertinoPageRoute(
                  //           builder: (context) =>
                  //               MealPlanScreen(user: currentUser!, isEditing: true),
                  //         ),
                  //       );
                  //       if (user != null) {
                  //         widget.onUserUpdated(user);
                  //       }
                  //     },
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SettingsButton(
                      title: "Delete User Data",
                      subtitle: "Permanently delete your user data",
                      icon: Icons.delete,
                      onTap: () async {
                        HapticFeedback.mediumImpact();
                        await LocalDatabase().deleteDB(true);
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => WelcomeScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
