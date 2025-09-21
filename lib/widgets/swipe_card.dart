import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class SwipeCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color cardColor;
  final Function(bool)
  onSwipe; // true for right swipe (accept), false for left (reject)
  final bool isTopCard;
  final bool swapSides;

  const SwipeCard({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.cardColor,
    required this.onSwipe,
    this.isTopCard = true,
    this.swapSides = false,
  }) : super(key: key);

  @override
  _SwipeCardState createState() => _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _scaleController;
  late AnimationController _pulseController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  Offset _dragOffset = Offset.zero;
  bool _isDragging = false;
  bool _hasBeenSwiped = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(begin: Offset.zero, end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.elasticOut,
          ),
        );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _pulseAnimation = Tween<double>(begin: 0.98, end: 1.02).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.isTopCard) {
      _scaleController.forward();
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _animationController.stop();
    _scaleController.stop();
    _pulseController.stop();
    _animationController.dispose();
    _scaleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    if (!_hasBeenSwiped) {
      setState(() {
        _isDragging = true;
      });
      HapticFeedback.lightImpact();
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!_hasBeenSwiped) {
      setState(() {
        _dragOffset = Offset(
          _dragOffset.dx + details.delta.dx,
          _dragOffset.dy + details.delta.dy * 0.3, // Limit vertical movement
        );
      });
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (!_hasBeenSwiped) {
      final velocity = details.velocity.pixelsPerSecond.dx;
      final dragDistance = _dragOffset.dx.abs();
      final threshold = MediaQuery.of(context).size.width * 0.25;

      if (dragDistance > threshold || velocity.abs() > 500) {
        _performSwipe(_dragOffset.dx > 0);
      } else {
        _resetCard();
      }
    }
  }

  void _performSwipe(bool isRightSwipe) {
    if (_hasBeenSwiped) return;

    setState(() {
      _hasBeenSwiped = true;
    });

    HapticFeedback.mediumImpact();

    final screenWidth = MediaQuery.of(context).size.width;
    final targetX = isRightSwipe ? screenWidth * 1.5 : -screenWidth * 1.5;
    final targetRotation = isRightSwipe ? 0.3 : -0.3;

    _slideAnimation =
        Tween<Offset>(
          begin: _dragOffset,
          end: Offset(targetX, _dragOffset.dy),
        ).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _rotationAnimation =
        Tween<double>(
          begin: _dragOffset.dx * 0.0008,
          end: targetRotation,
        ).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _animationController.forward().then((_) {
      widget.onSwipe(isRightSwipe);
    });
  }

  void _resetCard() {
    setState(() {
      _isDragging = false;
    });

    _slideAnimation = Tween<Offset>(begin: _dragOffset, end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.elasticOut,
          ),
        );

    _rotationAnimation = Tween<double>(begin: _dragOffset.dx * 0.0008, end: 0.0)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.elasticOut,
          ),
        );

    _animationController.forward().then((_) {
      setState(() {
        _dragOffset = Offset.zero;
      });
      _animationController.reset();
    });
  }

  Color get _overlayColor {
    if (_dragOffset.dx > 50) {
      if (widget.swapSides) {
        return Colors.red.withOpacity(math.min(_dragOffset.dx / 150, 0.7));
      }
      return Colors.green.withOpacity(math.min(_dragOffset.dx / 150, 0.7));
    } else if (_dragOffset.dx < -50) {
      if (widget.swapSides) {
        return Colors.green.withOpacity(
          math.min(_dragOffset.dx.abs() / 150, 0.7),
        );
      }
      return Colors.red.withOpacity(math.min(_dragOffset.dx.abs() / 150, 0.7));
    }
    return Colors.transparent;
  }

  IconData? get _overlayIcon {
    if (_dragOffset.dx > 50) {
      if (widget.swapSides) {
        return Icons.close;
      }
      return Icons.check;
    } else if (_dragOffset.dx < -50) {
      if (widget.swapSides) {
        return Icons.check;
      }
      return Icons.close;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _animationController,
        _scaleController,
        _pulseController,
      ]),
      builder: (context, child) {
        final currentOffset = _hasBeenSwiped || _isDragging
            ? (_hasBeenSwiped ? _slideAnimation.value : _dragOffset)
            : Offset.zero;

        final currentRotation = _hasBeenSwiped || _isDragging
            ? (_hasBeenSwiped
                  ? _rotationAnimation.value
                  : _dragOffset.dx * 0.0008)
            : 0.0;

        return Transform.translate(
          offset: currentOffset,
          child: Transform.rotate(
            angle: currentRotation,
            child: Transform.scale(
              scale: widget.isTopCard ? 0.85 : 0.85,
              child: GestureDetector(
                onPanStart: _onPanStart,
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.height * 0.6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        widget.cardColor.withOpacity(0.8),
                        widget.cardColor,
                        widget.cardColor.withOpacity(0.9),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.cardColor.withOpacity(0.3),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Main content
                      Padding(
                        padding: EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icon with glow effect
                            Container(
                              padding: EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.2),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.3),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Icon(
                                widget.icon,
                                size: 64,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 32),

                            // Title
                            Text(
                              widget.title,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.5),
                                    offset: Offset(2, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16),

                            // Description
                            Text(
                              widget.description,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w300,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      // Swipe overlay
                      if (_dragOffset != Offset.zero)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: _overlayColor,
                          ),
                          child: Center(
                            child: _overlayIcon == null
                                ? Container()
                                : Icon(
                                    _overlayIcon,
                                    size: 80,
                                    color: Colors.white,
                                  ),
                          ),
                        ),

                      // Bottom swipe hints (only on top card)
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
