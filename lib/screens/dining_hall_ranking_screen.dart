import 'package:boiler_fuel/api/local_database.dart';
import 'package:boiler_fuel/constants.dart';
import 'package:boiler_fuel/main.dart';
import 'package:boiler_fuel/screens/home_screen.dart';
import 'package:boiler_fuel/widgets/default_button.dart';
import 'package:boiler_fuel/widgets/default_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DiningHall {
  final String id;
  final String name;
  final String location;

  DiningHall({required this.id, required this.name, required this.location});
}

class DiningHallRankingScreen extends StatefulWidget {
  final User user;
  final bool isEditing;

  const DiningHallRankingScreen({
    Key? key,
    required this.user,
    this.isEditing = false,
  }) : super(key: key);

  @override
  State<DiningHallRankingScreen> createState() =>
      _DiningHallRankingScreenState();
}

class _DiningHallRankingScreenState extends State<DiningHallRankingScreen> {
  List<DiningHall> halls = [
    DiningHall(
      id: 'Earhart',
      name: 'Earhart Dining Court',
      location: 'Northwest Campus',
    ),
    DiningHall(
      id: 'Wiley',
      name: 'Wiley Dining Court',
      location: 'Southwest Campus',
    ),
    DiningHall(id: 'Ford', name: 'Ford Dining Court', location: 'North Campus'),
    DiningHall(
      id: 'Hillenbrand',
      name: 'Hillenbrand Dining Court',
      location: 'East Campus',
    ),
    DiningHall(
      id: 'Windsor',
      name: 'Windsor Dining Court',
      location: 'Northwest Campus',
    ),
  ];

  void _handleReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = halls.removeAt(oldIndex);
      halls.insert(newIndex, item);
    });
  }

  void _handleContinue() async {
    HapticFeedback.lightImpact();
    widget.user.diningHallRank = halls.map((e) => e.id).toList();
    print(widget.user.diningHallRank);
    await LocalDatabase().saveUser(widget.user);
    LocalDatabase().listenToAIDayMeals(aiMealStream);
    if (widget.isEditing) {
      Navigator.pop(context, widget.user);
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(builder: (context) => HomeScreen(user: widget.user)),
        (route) => false,
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isEditing) {
      List<DiningHall> newOrder = [];
      for (String hallName in widget.user.diningHallRank) {
        DiningHall? hall = halls.firstWhere(
          (element) => element.id == hallName,
          orElse: () => DiningHall(
            id: 'unknown',
            name: hallName,
            location: 'Unknown Location',
          ),
        );
        newOrder.add(hall);
      }
      setState(() {
        halls = newOrder;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: MediaQuery.of(context).padding.top,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rank Dining Halls',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Drag to reorder by your preference',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
                const SizedBox(height: 32),
                // Reorderable list
                ReorderableListView.builder(
                  buildDefaultDragHandles: false,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: halls.length,
                  onReorder: _handleReorder,
                  proxyDecorator:
                      (Widget child, int index, Animation<double> animation) {
                        // Smooth animated proxy: slight scale up + elevation while dragging.
                        final hall = halls[index];
                        return AnimatedBuilder(
                          animation: animation,
                          builder: (context, _) {
                            final t = Curves.easeOut.transform(animation.value);
                            return Material(
                              color: Colors.transparent,

                              child: Transform.scale(
                                scale: 1.0 + 0.03 * t,
                                alignment: Alignment.center,
                                child: DiningHallCard(
                                  key: ValueKey('dragging_${hall.id}'),
                                  hall: hall,
                                  rank: index + 1,
                                ),
                              ),
                            );
                          },
                        );
                      },
                  itemBuilder: (context, index) {
                    final hall = halls[index];
                    // Allow drag to start from anywhere on the item
                    return ReorderableDragStartListener(
                      key: ValueKey(hall.id),
                      index: index,
                      child: DiningHallCard(hall: hall, rank: index + 1),
                    );
                  },
                ),
                const SizedBox(height: 32),
                DefaultButton(
                  onTap: _handleContinue,
                  text: Text(
                    widget.isEditing ? 'Save Changes' : 'Complete Setup',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Back',
                      style: TextStyle(color: styling.darkGray, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom button
        ],
      ),
    );
  }

  Widget _buildProgressDot(bool isActive) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Theme.of(context).primaryColor : Colors.grey[300],
      ),
    );
  }
}

class DiningHallCard extends StatelessWidget {
  final DiningHall hall;
  final int rank;
  final bool isDragging;

  const DiningHallCard({
    Key? key,
    required this.hall,
    required this.rank,
    this.isDragging = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget content = Row(
      children: [
        // Rank circle
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColor.withOpacity(0.1),
          ),
          child: Center(
            child: Text(
              '$rank',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Hall info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hall.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                hall.location,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        // Drag handle icon
        Icon(Icons.drag_handle, color: Colors.grey[400], size: 20),
      ],
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: isDragging
          ? Container(color: Colors.transparent, child: content)
          : DefaultContainer(child: content),
    );
  }
}
