import 'package:boiler_fuel/widgets/tabs_content.dart';
import 'package:boiler_fuel/widgets/tabs_list.dart';
import 'package:flutter/material.dart';
import 'package:boiler_fuel/constants.dart';
import 'package:flutter/services.dart';

/// Custom Tabs Widget - matches Radix UI design
class CustomTabs extends StatefulWidget {
  final List<TabItem> tabs;
  final String? initialValue;
  final ValueChanged<String>? onValueChanged;
  final EdgeInsets? padding;

  const CustomTabs({
    Key? key,
    required this.tabs,
    this.initialValue,
    this.onValueChanged,
    this.padding,
  }) : super(key: key);

  @override
  State<CustomTabs> createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabs> {
  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue ?? widget.tabs.first.value;
  }

  void _handleTabChange(String value) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedValue = value;
    });
    widget.onValueChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return TabsList(
      selectedValue: _selectedValue,
      tabs: widget.tabs,
      onTabSelected: _handleTabChange,
    );
  }
}
