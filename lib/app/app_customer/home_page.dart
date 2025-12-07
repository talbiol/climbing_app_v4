// lib/app/app_customer/home_page.dart

import 'package:flutter/material.dart';
import '../../models/logged_in_user.dart';
import '../../style.dart';
import 'explore/explore.dart';
import 'profile/profile.dart';
import 'questionnaire/questionnaire.dart';
import 'routine/routine.dart';
import 'trainer/trainer.dart';

class HomePage extends StatefulWidget {
  final LoggedInUserInfo loggedInUser;
  HomePage(this.loggedInUser);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _selectedIndex = (widget.loggedInUser.isTrainer == true) ? 2 : 1;

  @override
  Widget build(BuildContext context) {
    // Build list of screens based on loggedInUser
    final List<Widget> _screens = [
      QuestionnaireScreen(widget.loggedInUser),
      if (widget.loggedInUser.isTrainer == true) TrainerScreen(widget.loggedInUser),
      ExploreScreen(widget.loggedInUser),
      RoutinesScreen(widget.loggedInUser),
      ProfileScreen(widget.loggedInUser),
    ];

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              label: '',
            ),
            if (widget.loggedInUser.isTrainer == true)
              BottomNavigationBarItem(
                icon: Icon(Icons.monetization_on),
                label: '',
              ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: '',
            ),
          ],
          unselectedItemColor: Colors.grey,
          selectedItemColor: AppColors.mainText,
        ),
      )
    );
  }
}
