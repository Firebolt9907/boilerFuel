import 'package:boiler_fuel/widgets/tabs_trigger.dart';
import 'package:flutter/material.dart';
import 'package:boiler_fuel/constants.dart';

/// Tabs List - the tab buttons container
class TabsList extends StatelessWidget {
  final String selectedValue;
  final List<TabItem> tabs;
  final ValueChanged<String> onTabSelected;

  const TabsList({
    Key? key,
    required this.selectedValue,
    required this.tabs,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: tabs.map((tab) {
          return TabsTrigger(
            tab: tab,
            isSelected: selectedValue == tab.value,
            onTap: () => onTabSelected(tab.value),
          );
        }).toList(),
      ),
    );
  }
}
