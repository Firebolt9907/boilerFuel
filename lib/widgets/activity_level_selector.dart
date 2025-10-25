import 'package:boiler_fuel/constants.dart';
import 'package:boiler_fuel/styling.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ActivityLevelSelector extends StatefulWidget {
  final ActivityLevel? initialValue;
  final Function(ActivityLevel) onSelected;

  const ActivityLevelSelector({
    Key? key,
    this.initialValue,
    required this.onSelected,
  }) : super(key: key);

  @override
  State<ActivityLevelSelector> createState() => _ActivityLevelSelectorState();
}

class _ActivityLevelSelectorState extends State<ActivityLevelSelector> {
  late PageController _pageController;

  int _currentPage = 0;
  ActivityLevel? _selectedLevel;

  final List<ActivityLevelOption> _levels = [
    ActivityLevelOption(
      level: ActivityLevel.sedentary,
      title: 'Sedentary',
      subtitle: 'Little or no exercise',
      description: 'Desk job, minimal physical activity',
      icon: Icons.event_seat,
      color: Colors.blue,
    ),
    ActivityLevelOption(
      level: ActivityLevel.lightly,
      title: 'Lightly Active',
      subtitle: '1-3 times per week',
      description: 'Light exercise or sports',
      icon: Icons.directions_walk,
      color: Colors.cyan,
    ),
    ActivityLevelOption(
      level: ActivityLevel.moderately,
      title: 'Moderately Active',
      subtitle: '3-5 times per week',
      description: 'Moderate exercise 3-5 days weekly',
      icon: Icons.directions_run,
      color: Colors.green,
    ),
    ActivityLevelOption(
      level: ActivityLevel.very,
      title: 'Very Active',
      subtitle: '6-7 times per week',
      description: 'Exercise 6-7 days per week',
      icon: Icons.fitness_center,
      color: Colors.orange,
    ),
    ActivityLevelOption(
      level: ActivityLevel.extremely,
      title: 'Extremely Active',
      subtitle: 'Very hard + physical job',
      description: 'Daily intense training and physical job',
      icon: Icons.sports_gymnastics,
      color: Colors.red,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _selectedLevel = widget.initialValue;
    final initialIndex = _levels.indexWhere(
      (l) => l.level == widget.initialValue,
    );

    _pageController = PageController(
      initialPage: initialIndex >= 0 ? initialIndex : 0,
    );
    _currentPage = initialIndex >= 0 ? initialIndex : 0;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _selectLevel(ActivityLevel level) {
    HapticFeedback.mediumImpact();
    setState(() => _selectedLevel = level);
    widget.onSelected(level);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // The page view with constrained height
        SizedBox(
          height: 350,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
              _selectedLevel = _levels[index].level;
              widget.onSelected(_selectedLevel!);
            },
            itemCount: _levels.length,
            itemBuilder: (context, index) {
              return SingleChildScrollView(
                child: _buildActivityCard(_levels[index]),
              );
            },
          ),
        ),

        SizedBox(height: 24),
        // Page indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _levels.length,
            (index) => AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 6),
              height: 10,
              width: _currentPage == index ? 28 : 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: _currentPage == index
                    ? DynamicStyling.getBlack(context)
                    : DynamicStyling.getBlack(context).withOpacity(0.2),
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        // Current selection display
        AnimatedOpacity(
          opacity: _selectedLevel != null ? 1.0 : 0.5,
          duration: Duration(milliseconds: 300),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: DynamicStyling.getBlack(context).withOpacity(0.05),
              border: Border.all(
                color: DynamicStyling.getBlack(context).withOpacity(0.1),
              ),
            ),
            child: Text(
              'Swipe to select your activity level',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: DynamicStyling.getBlack(context),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityCard(ActivityLevelOption option) {
    final isSelected = _selectedLevel == option.level;

    return GestureDetector(
      onTap: () => _selectLevel(option.level),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: DynamicStyling.getWhite(context),
          border: Border.all(
            color: isSelected
                ? DynamicStyling.getBlack(context)
                : DynamicStyling.getBlack(context).withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? DynamicStyling.getBlack(context).withOpacity(0.15)
                  : Colors.black.withOpacity(0.05),
              blurRadius: isSelected ? 12 : 6,
              offset: Offset(0, isSelected ? 6 : 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with animated scale - centered
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: AnimatedScale(
                scale: isSelected ? 1.15 : 1.0,
                duration: Duration(milliseconds: 300),
                child: Icon(
                  option.icon,
                  size: 60,
                  color: isSelected
                      ? DynamicStyling.getBlack(context)
                      : DynamicStyling.getBlack(context).withOpacity(0.6),
                ),
              ),
            ),
            // Divider line
            Container(
              height: 1,
              color: DynamicStyling.getBlack(context).withOpacity(0.08),
              margin: EdgeInsets.symmetric(vertical: 16),
            ),
            // Title - centered
            Text(
              option.title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: DynamicStyling.getBlack(context),
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            // Subtitle - centered
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: DynamicStyling.getBlack(context).withOpacity(0.05),
              ),
              child: Text(
                option.subtitle,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: DynamicStyling.getBlack(context).withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 12),
            // Description - centered
            Text(
              option.description,
              style: TextStyle(
                fontSize: 13,
                color: DynamicStyling.getBlack(context).withOpacity(0.6),
                height: 1.4,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityLevelOption {
  final ActivityLevel level;
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;

  ActivityLevelOption({
    required this.level,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
  });
}
