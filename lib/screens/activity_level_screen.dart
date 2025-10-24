import 'package:boiler_fuel/screens/suggested_macros_screen.dart';
import 'package:boiler_fuel/styling.dart';

import 'package:boiler_fuel/widgets/activity_level_selector.dart';
import 'package:boiler_fuel/widgets/default_button.dart';
import 'package:boiler_fuel/widgets/default_container.dart';
import 'package:boiler_fuel/widgets/default_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';

class ActivityLevelScreen extends StatefulWidget {
  final User user;
  final bool isEditing;

  const ActivityLevelScreen({
    Key? key,
    required this.user,
    this.isEditing = false,
  }) : super(key: key);

  @override
  _ActivityLevelScreenState createState() => _ActivityLevelScreenState();
}

class _ActivityLevelScreenState extends State<ActivityLevelScreen>
    with TickerProviderStateMixin {
  TextEditingController caloriesController = TextEditingController();
  TextEditingController proteinController = TextEditingController();
  TextEditingController carbsController = TextEditingController();
  TextEditingController fatController = TextEditingController();
  ActivityLevel? selectedActivityLevel;
  @override
  void initState() {
    super.initState();
    // Calculate suggested macros based on user info

    caloriesController.text = widget.user.macros.calories.toStringAsFixed(0);
    proteinController.text = widget.user.macros.protein.toStringAsFixed(0);
    carbsController.text = widget.user.macros.carbs.toStringAsFixed(0);
    fatController.text = widget.user.macros.fat.toStringAsFixed(0);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _completeSetup() async {
    HapticFeedback.mediumImpact();

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => SuggestedMacrosScreen(
          user: widget.user,
          isEditing: widget.isEditing,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: DynamicStyling.getWhite(context),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: MediaQuery.of(context).padding.top,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Activity Level',
                style: TextStyle(
                  fontSize: 32,
                  color: DynamicStyling.getBlack(context),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),

              Text(
                'Help us calculate your personalized nutrition goals',
                style: TextStyle(
                  fontSize: 16,
                  color: DynamicStyling.getBlack(context).withOpacity(0.7),
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              // Let the selector size itself without forcing expansion
              Flexible(
                fit: FlexFit.loose,
                child: RepaintBoundary(
                  child: ActivityLevelSelector(
                    initialValue: selectedActivityLevel,
                    onSelected: (level) {
                      selectedActivityLevel = level;
                      // Don't call setState here - let the selector manage its own state
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Start journey button
              DefaultButton(
                text: Text(
                  widget.isEditing ? 'Save Changes' : 'Continue',
                  style: TextStyle(
                    color: DynamicStyling.getWhite(context),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  _completeSetup();
                },
              ),
              SizedBox(height: 8),

              Center(
                child: TextButton(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Back',
                    style: TextStyle(
                      color: DynamicStyling.getDarkGrey(context),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              // Progress indicator
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: List.generate(
              //     4, // Updated to match meal plan screen
              //     (index) => Container(
              //       margin: EdgeInsets.symmetric(horizontal: 4),
              //       width: index == 3
              //           ? 20
              //           : 8, // Changed to index == 3 for final step
              //       height: 8,
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(4),
              //         color: index == 3
              //             ? Colors.purple.shade400
              //             : DynamicStyling.getWhite(context).withOpacity(0.3),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
    required TextEditingController controller,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: DefaultContainer(
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: DynamicStyling.getLightGrey(context),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: DynamicStyling.getBlack(context),
                size: 28,
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: DynamicStyling.getBlack(context),
                      letterSpacing: 0.3,
                    ),
                  ),
                  SizedBox(height: 8),
                  DefaultTextField(controller: controller),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: DynamicStyling.getDarkGrey(context),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
