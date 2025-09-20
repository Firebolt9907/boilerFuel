import 'package:boiler_fuel/models/user_model.dart';
import 'package:boiler_fuel/screens/dining_hall_ranking_screen.dart';
import 'package:boiler_fuel/widgets/animated_button.dart';
import 'package:boiler_fuel/widgets/animated_goal_option.dart';
import 'package:boiler_fuel/widgets/animated_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserInfoScreen extends StatefulWidget {
  final User user;

  UserInfoScreen({required this.user});

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen>
    with TickerProviderStateMixin {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  String? _selectedGoal;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _continue() {
    if (_weightController.text.isNotEmpty &&
        _heightController.text.isNotEmpty &&
        _selectedGoal != null) {
      widget.user.weight = double.tryParse(_weightController.text);
      widget.user.height = double.tryParse(_heightController.text);
      widget.user.eatingHabits = _selectedGoal;

      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, _) =>
              DiningHallRankingScreen(user: widget.user),
          transitionsBuilder: (context, animation, _, child) {
            return SlideTransition(
              position: animation.drive(
                Tween(begin: Offset(1.0, 0.0), end: Offset.zero)
                    .chain(CurveTween(curve: Curves.easeInOut)),
              ),
              child: child,
            );
          },
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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF060010), Color(0xFF170d27)],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Tell us about yourself',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 32),
                  AnimatedTextField(
                    controller: _weightController,
                    label: 'Weight (lbs)',
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20),
                  AnimatedTextField(
                    controller: _heightController,
                    label: 'Height (inches)',
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 32),
                  Text(
                    'Health Goal',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  ...['Cutting', 'Maintain', 'Bulking'].map((goal) =>
                      AnimatedGoalOption(
                        text: goal,
                        isSelected: _selectedGoal == goal,
                        onTap: () => setState(() => _selectedGoal = goal),
                      )),
                  Spacer(),
                  AnimatedButton(
                    text: 'Continue',
                    onTap: _continue,
                    isEnabled: _weightController.text.isNotEmpty &&
                        _heightController.text.isNotEmpty &&
                        _selectedGoal != null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
