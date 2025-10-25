import 'package:boiler_fuel/styling.dart';
import 'package:boiler_fuel/widgets/tabs_content.dart';
import 'package:boiler_fuel/widgets/tabs_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:boiler_fuel/constants.dart';
import 'package:flutter/services.dart';

/// Custom Tabs Widget - matches Radix UI design
class CustomTabs extends StatefulWidget {
  final List<TabItem> tabs;
  final String? initialValue;
  final ValueChanged<String>? onValueChanged;
  final EdgeInsets? padding;
  final bool? legacy;
  final bool? expand;

  const CustomTabs({
    Key? key,
    required this.tabs,
    this.initialValue,
    this.onValueChanged,
    this.padding,
    this.legacy,
    this.expand = false,
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
    if (widget.legacy != true && widget.expand == true) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final tabCount = widget.tabs.length;
          final segmentWidth = (constraints.maxWidth / tabCount)
              .floorToDouble();
          return CupertinoSlidingSegmentedControl<String>(
            backgroundColor: DynamicStyling.getLightGrey(context),
            thumbColor: DynamicStyling.getWhite(context),
            groupValue: _selectedValue,
            onValueChanged: (String? value) {
              if (value != null) {
                _handleTabChange(value);
              }
            },
            children: Map<String, Widget>.fromEntries(
              widget.tabs.map(
                (tab) => MapEntry(
                  tab.label,
                  SizedBox(
                    width: segmentWidth,
                    child: Center(
                      child: Text(
                        tab.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: DynamicStyling.getBlack(context),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    } else if (widget.legacy != true) {
      if (widget.tabs.length == 1) {
        return Container(
          decoration: BoxDecoration(
            color: DynamicStyling.getLightGrey(context),
            borderRadius: BorderRadius.circular(8),
          ),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              decoration: BoxDecoration(
                color: DynamicStyling.getWhite(context),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.tabs.first.value,
                    style: TextStyle(color: DynamicStyling.getBlack(context)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }
      return CupertinoSlidingSegmentedControl<String>(
        backgroundColor: DynamicStyling.getLightGrey(context),
        thumbColor: DynamicStyling.getWhite(context),
        groupValue: _selectedValue,
        onValueChanged: (String? value) {
          if (value != null) {
            _handleTabChange(value);
          }
        },
        children: Map<String, Widget>.fromEntries(
          widget.tabs.map(
            (tab) => MapEntry(
              tab.label,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: Text(
                  tab.value,
                  style: TextStyle(color: DynamicStyling.getBlack(context)),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return TabsList(
      selectedValue: _selectedValue,
      tabs: widget.tabs,
      onTabSelected: _handleTabChange,
    );
  }
}
