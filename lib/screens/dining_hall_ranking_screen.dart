import 'package:flutter/material.dart' hide AnimatedList;
import 'package:flutter/services.dart';
// Add these imports for your custom code:
import '../../models/user_model.dart';
import '../../widgets/animated_list.dart';
import '../../widgets/ranking_item.dart';
import '../../widgets/animated_button.dart';
import 'meal_plan_screen.dart';
class DiningHallRankingScreen extends StatefulWidget {
  final User user;

  DiningHallRankingScreen({required this.user});

  @override
  _DiningHallRankingScreenState createState() => _DiningHallRankingScreenState();
}

class _DiningHallRankingScreenState extends State<DiningHallRankingScreen>
    with TickerProviderStateMixin {
  List<String> diningHalls = ['Earhart', 'Ford', 'Hillenbrand', 'Wiley', 'Windsor'];
  List<String> rankedHalls = [];
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
    _animationController.dispose();
    super.dispose();
  }

  void _onItemSelect(String item, int index) {
    setState(() {
      if (!rankedHalls.contains(item)) {
        rankedHalls.add(item);
      }
    });
  }

  void _continue() {
    if (rankedHalls.length >= 3) {
      widget.user.diningHallsRank = rankedHalls;
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, _) =>
              MealPlanScreen(user: widget.user),
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
                    'Rank your dining halls',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Select at least 3 dining halls in order of preference',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 32),
                  Expanded(
                    child: AnimatedList(
                      items: diningHalls,
                      onItemSelect: _onItemSelect,
                      selectedItems: rankedHalls,
                    ),
                  ),
                  if (rankedHalls.isNotEmpty) ...[
                    SizedBox(height: 20),
                    Text(
                      'Your ranking:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    ...rankedHalls.asMap().entries.map((entry) =>
                        RankingItem(
                          rank: entry.key + 1,
                          name: entry.value,
                          onRemove: () {
                            setState(() {
                              rankedHalls.removeAt(entry.key);
                            });
                          },
                        )),
                  ],
                  SizedBox(height: 20),
                  AnimatedButton(
                    text: 'Continue',
                    onTap: _continue,
                    isEnabled: rankedHalls.length >= 3,
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
