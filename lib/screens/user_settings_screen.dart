import 'dart:async';

import 'package:boiler_fuel/api/firebase_database.dart';
import 'package:boiler_fuel/api/local_database.dart';
import 'package:boiler_fuel/api/shared_preferences.dart';
import 'package:boiler_fuel/main.dart';
import 'package:boiler_fuel/screens/dietary_restrictions_screen.dart';
import 'package:boiler_fuel/screens/dining_hall_ranking_screen.dart';

import 'package:boiler_fuel/screens/user_info_screen.dart';
import 'package:boiler_fuel/screens/welcome_screen.dart';
import 'package:boiler_fuel/widgets/default_text_field.dart';
import 'package:boiler_fuel/widgets/header.dart';

import 'package:boiler_fuel/widgets/settings_button.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';
import '../styling.dart';

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
  User? currentUser;
  bool isLoadingDelete = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      currentUser = widget.user;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DynamicStyling.getWhite(context),

      extendBodyBehindAppBar: false,
      body: Column(
        children: [
          // Container(
          //   decoration: BoxDecoration(
          //     color: DynamicStyling.getWhite(context),
          //     border: Border(
          //       bottom: BorderSide(color: DynamicStyling.getGrey(context)),
          //     ),
          //   ),
          //   child: Column(
          //     children: [
          //       SizedBox(height: MediaQuery.of(context).padding.top),
          //       GestureDetector(
          //         onTap: () {
          //           HapticFeedback.lightImpact();
          //           Navigator.of(context).pop();
          //         },
          //         child: Row(
          //           children: [
          //             IconButton(
          //               icon: Icon(
          //                 Icons.arrow_back_ios_new,
          //                 color: styling.gray,
          //               ),
          //               onPressed: () {
          //                 HapticFeedback.lightImpact();
          //                 Navigator.of(context).pop();
          //               },
          //             ),

          //             Text(
          //               'Back',
          //               style: TextStyle(
          //                 fontSize: 14,
          //                 fontWeight: FontWeight.bold,
          //                 color: styling.gray,
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.only(left: 24.0, bottom: 18),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Text(
          //                   "Settings",
          //                   style: TextStyle(
          //                     fontSize: 24,
          //                     color: DynamicStyling.getBlack(context),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Header(context: context, title: "Settings"),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const SizedBox(height: 16),

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
                          setState(() {
                            currentUser = user;
                          });
                          widget.onUserUpdated(user);
                        }
                      },
                    ),
                  ),

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
                          setState(() {
                            currentUser = user;
                          });
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
                          setState(() {
                            currentUser = user;
                          });
                          widget.onUserUpdated(user);
                        }
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SettingsButton(
                      title: "Submit Feedback",
                      subtitle:
                          "Help us improve UPlate by submitting your feedback.",
                      icon: Icons.feedback,
                      onTap: () async {
                        TextEditingController feedbackController =
                            TextEditingController();
                        HapticFeedback.mediumImpact();
                        // Show sleek confirmation dialog
                        showDialog<bool>(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            bool isSubmitting = false;

                            return StatefulBuilder(
                              builder: (context, setState) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  backgroundColor: DynamicStyling.getWhite(
                                    context,
                                  ),
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.all(24.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          // Icon
                                          Container(
                                            width: 64,
                                            height: 64,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.green.withOpacity(
                                                0.1,
                                              ),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.feedback_rounded,
                                                color: Colors.green,
                                                size: 32,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 20),

                                          // Title
                                          Text(
                                            'Submit Feedback',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color: DynamicStyling.getBlack(
                                                context,
                                              ),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 12),

                                          // Description
                                          Text(
                                            'We value your feedback! Please let us know your thoughts or any issues you\'ve encountered.',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: DynamicStyling.getDarkGrey(
                                                context,
                                              ),
                                              height: 1.5,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 16),
                                          DefaultTextField(
                                            controller: feedbackController,
                                            maxLines: 6,
                                            hint: 'Enter your feedback here...',
                                          ),
                                          const SizedBox(height: 28),

                                          // Buttons
                                          Row(
                                            children: [
                                              // Cancel Button
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                    border: Border.all(
                                                      color:
                                                          DynamicStyling.getGrey(
                                                            context,
                                                          ),
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      onTap: () {
                                                        HapticFeedback.lightImpact();
                                                        Navigator.of(
                                                          context,
                                                        ).pop();
                                                      },
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              vertical: 12.0,
                                                            ),
                                                        child: Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                DynamicStyling.getBlack(
                                                                  context,
                                                                ),
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),

                                              // Delete Button
                                              isSubmitting
                                                  ? CircularProgressIndicator(
                                                      color: Colors.green,
                                                    )
                                                  : Expanded(
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                12,
                                                              ),
                                                          color: Colors.green,
                                                        ),
                                                        child: Material(
                                                          color: Colors
                                                              .transparent,
                                                          child: InkWell(
                                                            onTap: () async {
                                                              HapticFeedback.mediumImpact();
                                                              setState(() {
                                                                isSubmitting =
                                                                    true;
                                                              });
                                                              await FBDatabase()
                                                                  .submitFeedback(
                                                                    feedbackController
                                                                        .text,
                                                                  );

                                                              if (mounted) {
                                                                ScaffoldMessenger.of(
                                                                  context,
                                                                ).showSnackBar(
                                                                  SnackBar(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .green,
                                                                    content: Text(
                                                                      'Thank you for your feedback!',
                                                                      style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                                Navigator.of(
                                                                  context,
                                                                ).pop();
                                                              }
                                                            },
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  12,
                                                                ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    vertical:
                                                                        12.0,
                                                                  ),
                                                              child: Text(
                                                                'Submit',
                                                                style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SettingsButton(
                      title: "Delete User Data",
                      subtitle: "Permanently delete your user data",
                      icon: Icons.delete,
                      onTap: () async {
                        HapticFeedback.mediumImpact();
                        // Show sleek confirmation dialog
                        bool? confirm = await showDialog<bool>(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            bool isDeleting = false;

                            return StatefulBuilder(
                              builder: (context, setState) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  backgroundColor: DynamicStyling.getWhite(
                                    context,
                                  ),
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.all(24.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          // Icon
                                          Container(
                                            width: 64,
                                            height: 64,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.red.withOpacity(
                                                0.1,
                                              ),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.warning_rounded,
                                                color: Colors.red,
                                                size: 32,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 20),

                                          // Title
                                          Text(
                                            'Delete User Data?',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color: DynamicStyling.getBlack(
                                                context,
                                              ),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 12),

                                          // Description
                                          Text(
                                            'This action cannot be undone. All your profile data, preferences, and saved meals will be permanently deleted.',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: DynamicStyling.getDarkGrey(
                                                context,
                                              ),
                                              height: 1.5,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 28),

                                          // Buttons
                                          Row(
                                            children: [
                                              // Cancel Button
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                    border: Border.all(
                                                      color:
                                                          DynamicStyling.getGrey(
                                                            context,
                                                          ),
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      onTap: () {
                                                        HapticFeedback.lightImpact();
                                                        Navigator.of(
                                                          context,
                                                        ).pop(false);
                                                      },
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              vertical: 12.0,
                                                            ),
                                                        child: Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                DynamicStyling.getBlack(
                                                                  context,
                                                                ),
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),

                                              // Delete Button
                                              isDeleting
                                                  ? CircularProgressIndicator(
                                                      color: Colors.red,
                                                    )
                                                  : Expanded(
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                12,
                                                              ),
                                                          color: Colors.red,
                                                        ),
                                                        child: Material(
                                                          color: Colors
                                                              .transparent,
                                                          child: InkWell(
                                                            onTap: () async {
                                                              HapticFeedback.mediumImpact();
                                                              setState(() {
                                                                isDeleting =
                                                                    true;
                                                              });
                                                              aiMealStream
                                                                  .close();
                                                              await LocalDatabase()
                                                                  .deleteDB(
                                                                    true,
                                                                  );
                                                              await SharedPrefs.clearAll();
                                                              aiMealStream =
                                                                  StreamController<
                                                                    Map<
                                                                      MealTime,
                                                                      Map<
                                                                        String,
                                                                        Meal
                                                                      >
                                                                    >
                                                                  >.broadcast();
                                                              if (mounted) {
                                                                Navigator.push(
                                                                  context,
                                                                  CupertinoPageRoute(
                                                                    builder:
                                                                        (
                                                                          context,
                                                                        ) =>
                                                                            WelcomeScreen(),
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  12,
                                                                ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    vertical:
                                                                        12.0,
                                                                  ),
                                                              child: Text(
                                                                'Delete',
                                                                style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
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
