import 'package:boiler_fuel/screens/user_info_screen.dart';
import 'package:boiler_fuel/styling.dart';
import 'package:boiler_fuel/constants.dart';
import 'package:boiler_fuel/widgets/default_button.dart';
import 'package:boiler_fuel/widgets/feature_choice_tile.dart';
import 'package:boiler_fuel/widgets/feature_tile.dart';
import 'package:boiler_fuel/widgets/activity_level_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import '../widgets/custom_app_bar.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  PageController _pageController = PageController();
  int currentIndex = 0;
  String editDescription = "";
  bool useDietary = true;
  bool useMealPlanning = true;
  ActivityLevel? selectedActivityLevel;
  // Pace selection now happens after goal selection in UserInfoScreen

  @override
  void initState() {
    // TODO: implement initState
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: DynamicStyling.getWhite(context),
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              PageView(
                onPageChanged: (int page) {
                  setState(() {
                    currentIndex = page;
                  });
                },
                controller: _pageController,
                children: <Widget>[
                  makePage(
                    title: 'Dietary Preferences',
                    subtitle:
                        'Find meals that match your dietary needs and restrictions',
                    body: [
                      FeatureTile(
                        title: "Dietary Filters",
                        description:
                            "Filter meals by vegetarian, vegan, gluten-free, and other dietary preferences",
                        icon: Icons.filter_list_outlined,
                      ),
                      FeatureTile(
                        title: "Simple Ingredient Tracking",
                        description:
                            "Easily track ingredients you want to avoid",
                        icon: Icons.no_food_outlined,
                      ),
                      FeatureTile(
                        title: "Custom Preferences",
                        description:
                            "Set your dietary restrictions once and find compatible meals easily",
                        icon: Icons.checklist_rtl_outlined,
                      ),
                    ],
                  ),
                  makePage(
                    title: 'Smart Meal Planning',
                    subtitle:
                        'Everything you need to plan your meals efficiently',
                    body: [
                      FeatureTile(
                        title: "AI-Powered Suggestions",
                        description:
                            "Get personalized meal suggestions based on your preferences and target nutrition goals",
                        icon: Icons.lightbulb_outline,
                      ),
                      FeatureTile(
                        title: "Synced with Purdue Dining",
                        description:
                            "Get real-time updates on dining hall menus and hours",
                        icon: Icons.sync_outlined,
                      ),
                      FeatureTile(
                        title: "Save Favorites",
                        description:
                            "Keep track of your favorite meals and find them easily",
                        icon: Icons.favorite_border_outlined,
                      ),
                    ],
                  ),

                  // makePage(
                  //   title: 'Dining Dollar Management',
                  //   subtitle:
                  //       'Stay on top of your dining budget with smart tracking',
                  //   lastPage: true,
                  //   body: [
                  //     FeatureTile(
                  //       title: "Track Balance",
                  //       description:
                  //           "Monitor your dining dollars and meal swipes throughout the semester",
                  //       icon: Icons.account_balance_wallet_outlined,
                  //     ),
                  //     FeatureTile(
                  //       title: "Smart Spending",
                  //       description:
                  //           "Get insights on where to spend your dining dollars for maximum value",
                  //       icon: Icons.trending_up_outlined,
                  //     ),
                  //   ],
                  // ),
                  // makeActivityPage(),
                  makePage(
                    title: 'Customize Your Experience',
                    subtitle:
                        'Choose which features you want to use to tailor the app to your needs',
                    lastPage: true,
                    body: [
                      FeatureChoiceTile(
                        title: "Dietary Preferences Filtering",
                        description:
                            "Find meals that match your dietary needs and restrictions",
                        icon: Icons.filter_list_outlined,
                        isSelected: useDietary,
                        onChanged: (bool? value) {
                          HapticFeedback.lightImpact();
                          setState(() {
                            useDietary = value ?? false;
                          });
                        },
                      ),
                      FeatureChoiceTile(
                        title: "Smart Meal Planning",
                        description:
                            "Get personalized meal suggestions and plan your meals efficiently",
                        icon: Icons.dining_outlined,
                        isSelected: useMealPlanning,
                        onChanged: (bool? value) {
                          HapticFeedback.lightImpact();
                          setState(() {
                            useMealPlanning = value ?? false;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),

              // Hide indicators on activity level page, show only activity level indicators
              Container(
                margin: const EdgeInsets.only(bottom: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildIndicator(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget makePage({
    required String title,
    required String subtitle,
    List<Widget>? body,
    lastPage = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: DynamicStyling.getWhite(context),
      child: Column(
        children: <Widget>[
          SizedBox(height: MediaQuery.of(context).padding.top + 12),
          // Modern title with better spacing
          Text(
            title,
            style: TextStyle(
              fontSize: 28,
              color: DynamicStyling.getBlack(context),
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          // Subtle divider line
          Container(
            width: 40,
            height: 3,
            decoration: BoxDecoration(
              color: DynamicStyling.getBlack(context),
              borderRadius: BorderRadius.circular(1.5),
            ),
          ),
          const SizedBox(height: 16),
          // Improved subtitle styling
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,
              color: DynamicStyling.getBlack(context).withOpacity(0.7),
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          if (body != null) ...[const SizedBox(height: 28), ...body],
          Spacer(),
          DefaultButton(
            isEnabled: useDietary || useMealPlanning,
            onTap: () async {
              HapticFeedback.mediumImpact();
              if (lastPage) {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => UserInfoScreen(
                      useDietary: useDietary,
                      useMealPlanning: useMealPlanning,
                      activityLevel: selectedActivityLevel,
                    ),
                  ),
                );
              } else {
                _pageController.animateToPage(
                  (_pageController.page ?? 0).round() + 1,
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                );
              }
            },

            text: Text(
              lastPage ? 'Get Started' : "Next",
              style: TextStyle(
                color: DynamicStyling.getWhite(context),
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(height: 60),
        ],
      ),
    );
  }

  // Widget makeActivityPage() {
  //   return
  // }

  // Pace selection page removed. Pace is chosen after goal selection in UserInfoScreen.

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 8,
      width: isActive ? 30 : 8,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: isActive
            ? DynamicStyling.getBlack(context)
            : DynamicStyling.getGrey(context),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  List<Widget> _buildIndicator() {
    List<Widget> indicators = [];
    for (var i = 0; i < 3; i++) {
      if (currentIndex == i) {
        indicators.add(_indicator(true));
      } else {
        indicators.add(_indicator(false));
      }
    }
    return indicators;
  }
}
