import 'package:flutter/material.dart';

import '../style.dart';

// ------------------------------------------------------------
//                 FEATURE MENU WIDGET
// ------------------------------------------------------------
class FeatureMenuWidget extends StatefulWidget {
  final String userId;
  final bool inAccount;
  final bool displayDashboard;
  final bool displayCalendar;
  final bool displayPersonalBest;
  final bool displayRoutine;
  final bool displayJournal;

  final Color activeColor;
  final Color inactiveColor;

  const FeatureMenuWidget({
    super.key,
    required this.userId,
    required this.inAccount,
    required this.displayDashboard,
    required this.displayCalendar,
    required this.displayPersonalBest,
    required this.displayRoutine,
    required this.displayJournal,
    this.activeColor = AppColors.mainWidget,
    this.inactiveColor = Colors.grey,
  });

  @override
  State<FeatureMenuWidget> createState() => _FeatureMenuWidgetState();
}

class _FeatureMenuWidgetState extends State<FeatureMenuWidget> {
  int _selectedIndex = 2;
  final List<IconData> _icons = [];
  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();

    if (widget.displayDashboard) {
      _icons.add(Icons.dashboard_rounded);
      _pages.add(DashboardPage(userId: widget.userId, inAccount: widget.inAccount));
    }
    if (widget.displayCalendar) {
      _icons.add(Icons.calendar_month_rounded);
      _pages.add(CalendarPage(userId: widget.userId, inAccount: widget.inAccount));
    }
    if (widget.displayPersonalBest) {
      _icons.add(Icons.emoji_events);
      _pages.add(PersonalBestPage(userId: widget.userId, inAccount: widget.inAccount));
    }
    if (widget.displayRoutine) {
      _icons.add(Icons.fitness_center_rounded);
      _pages.add(RoutinePage(userId: widget.userId, inAccount: widget.inAccount));
    }
    if (widget.displayJournal) {
      _icons.add(Icons.book_rounded);
      _pages.add(JournalPage(userId: widget.userId, inAccount: widget.inAccount));
    }
  }

  @override
  @override
Widget build(BuildContext context) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      // ICON MENU
      Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(_icons.length, (index) {
            final isSelected = index == _selectedIndex;
            return GestureDetector(
              onTap: () => setState(() => _selectedIndex = index),
              child: Icon(
                _icons[index],
                size: 30,
                color: isSelected ? widget.activeColor : widget.inactiveColor,
              ),
            );
          }),
        ),
      ),

      const Divider(height: 1),

      // PAGE (Flexible instead of Expanded)
      Flexible(
        fit: FlexFit.loose,
        child: _pages[_selectedIndex],
      ),
    ],
  );
}
}

// ------------------------------------------------------------
//                 PAGE DEFINITIONS
// ------------------------------------------------------------

class DashboardPage extends StatelessWidget {
  final String userId;
  final bool inAccount;

  const DashboardPage({super.key, required this.userId, required this.inAccount});

  @override
  Widget build(BuildContext context) => const Center(child: Text("This is Dashboard"));
}

class CalendarPage extends StatelessWidget {
  final String userId;
  final bool inAccount;

  const CalendarPage({super.key, required this.userId, required this.inAccount});

  @override
  Widget build(BuildContext context) => const Center(child: Text("This is Calendar"));
}

class PersonalBestPage extends StatelessWidget {
  final String userId;
  final bool inAccount;

  const PersonalBestPage({super.key, required this.userId, required this.inAccount});

  @override
  Widget build(BuildContext context) => const Center(child: Text("This is Personal Best"));
}

class RoutinePage extends StatelessWidget {
  final String userId;
  final bool inAccount;

  const RoutinePage({super.key, required this.userId, required this.inAccount});

  @override
  Widget build(BuildContext context) => const Center(child: Text("This is Routine"));
}

class JournalPage extends StatelessWidget {
  final String userId;
  final bool inAccount;

  const JournalPage({super.key, required this.userId, required this.inAccount});

  @override
  Widget build(BuildContext context) => Center(child: Text("This is Journal: ${this.userId}"));
}
