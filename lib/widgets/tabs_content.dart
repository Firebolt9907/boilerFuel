import 'package:flutter/material.dart';
import 'package:boiler_fuel/constants.dart';

/// Tabs Content - displays the selected tab's content
class TabsContent extends StatelessWidget {
  final String selectedValue;
  final List<TabItem> tabs;

  const TabsContent({Key? key, required this.selectedValue, required this.tabs})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedTab = tabs.firstWhere(
      (tab) => tab.value == selectedValue,
      orElse: () => tabs.first,
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: Container(key: ValueKey(selectedValue)),
    );
  }
}
