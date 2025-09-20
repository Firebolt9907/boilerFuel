import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimatedList extends StatefulWidget {
  final List<String> items;
  final Function(String, int) onItemSelect;
  final List<String> selectedItems;

  AnimatedList({
    required this.items,
    required this.onItemSelect,

    this.selectedItems = const [],
  });

  @override
  _AnimatedListState createState() => _AnimatedListState();
}

class _AnimatedListState extends State<AnimatedList>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.items.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 300),
        vsync: this,
      ),
    );

    _scaleAnimations = _controllers
        .map(
          (controller) => Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(parent: controller, curve: Curves.elasticOut),
          ),
        )
        .toList();

    _slideAnimations = _controllers
        .map(
          (controller) => Tween<Offset>(
            begin: Offset(0.3, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut)),
        )
        .toList();

    // Stagger animations
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) _controllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF170d27).withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final item = widget.items[index];
          final isSelected = widget.selectedItems.contains(item);
          final rank = widget.selectedItems.indexOf(item) + 1;

          return SlideTransition(
            position: _slideAnimations[index],
            child: ScaleTransition(
              scale: _scaleAnimations[index],
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xFF271e37) : Color(0xFF170d27),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? Colors.amber : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: GestureDetector(
                  onTap: () => widget.onItemSelect(item, index),
                  child: Row(
                    children: [
                      if (isSelected) ...[
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              rank.toString(),
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                      ],
                      Text(
                        item,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
