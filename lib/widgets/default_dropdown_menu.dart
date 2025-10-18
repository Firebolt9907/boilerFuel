import 'package:boiler_fuel/styling.dart';
import 'package:boiler_fuel/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DefaultDropdownMenu<T> extends StatefulWidget {
  final T? value;
  final String label;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? hint;

  DefaultDropdownMenu({
    required this.value,
    required this.label,
    required this.items,
    required this.onChanged,
    this.hint,
  });

  @override
  _DefaultDropdownMenuState<T> createState() => _DefaultDropdownMenuState<T>();
}

class _DefaultDropdownMenuState<T> extends State<DefaultDropdownMenu<T>>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  late final AnimationController _controller;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 180),
    );

    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _scaleAnim = Tween<double>(
      begin: 0.96,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
  }

  void _toggleDropdown() {
    HapticFeedback.lightImpact();
    if (_isOpen) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _controller.forward(from: 0.0);
    setState(() {
      _isOpen = true;
    });
  }

  void _removeOverlay() {
    _controller.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      if (mounted) {
        setState(() {
          _isOpen = false;
        });
      }
    });
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        width: size.width,
        top: offset.dy + size.height + 6.0, // 6 px gap below the box
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 6.0),
          child: FadeTransition(
            opacity: _fadeAnim,
            child: ScaleTransition(
              scale: _scaleAnim,
              alignment: Alignment.topCenter,
              child: Material(
                elevation: 6,
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceBright,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: DynamicStyling.getLightGrey(context), // 26
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 300),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      children: widget.items.map((item) {
                        final bool selected = item.value == widget.value;
                        return InkWell(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            widget.onChanged(item.value);
                            _removeOverlay();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                DefaultTextStyle(
                                  style: TextStyle(
                                    color: selected
                                        ? Theme.of(context).primaryColorDark
                                        : DynamicStyling.getBlack(
                                            context,
                                          ), // 87
                                    fontSize: 16,
                                  ),
                                  child: item.child,
                                ),
                                if (selected) ...[
                                  Spacer(),
                                  Icon(
                                    Icons.check,
                                    color: DynamicStyling.getDarkGrey(context),
                                    size: 20,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _removeOverlay();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        behavior: HitTestBehavior.translucent,
        child: Container(
          decoration: BoxDecoration(
            color: DynamicStyling.getLightGrey(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.transparent, width: 2),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  child: Text(
                    widget.value != null
                        ? (widget.items
                                      .firstWhere(
                                        (i) => i.value == widget.value,
                                      )
                                      .child
                                  as Text)
                              .data
                              .toString()
                        : (widget.hint ?? ' '),
                    style: TextStyle(
                      color: DynamicStyling.getBlack(context),
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Icon(
                _isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: DynamicStyling.getDarkGrey(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// (animations initialized in class initState)
