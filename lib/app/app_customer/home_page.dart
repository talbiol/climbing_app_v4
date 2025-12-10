// lib/app/app_customer/home_page.dart

import 'package:flutter/material.dart';
import '../../models/logged_in_user.dart';
import '../../models/profile.dart';
import '../../models/build_model.dart';
import '../../style.dart';
import '../../widgets/loading_widget.dart';
import 'explore/explore.dart';
import 'account/account.dart';
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

  final BuildModel buildModel = BuildModel();
  Profile? loggedInProfile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await buildModel.buildProfile(widget.loggedInUser.userId);
    setState(() {
      loggedInProfile = profile;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show loading screen while profile is being built
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: LoadingWidget(),
        ),
      );
    }

    // Build list of screens now that profile is available
    final List<Widget> _screens = [
      QuestionnaireScreen(widget.loggedInUser),
      if (widget.loggedInUser.isTrainer == true)
        TrainerScreen(widget.loggedInUser),
        ExploreScreen(loggedInUser: widget.loggedInUser),
        RoutinesScreen(widget.loggedInUser),
        AccountScreen(
          widget.loggedInUser,
          loggedInProfile!, // ✅ pass preloaded profile
        ),
    ];

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          backgroundColor: AppColors.mainBackground,
          iconSize: 30,
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
            const BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              label: '',
            ),
            if (widget.loggedInUser.isTrainer == true)
              const BottomNavigationBarItem(
                icon: Icon(Icons.monetization_on),
                label: '',
              ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: '',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center),
              label: '',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: '',
            ),
          ],
          unselectedItemColor: Colors.grey,
          selectedItemColor: AppColors.mainWidget,
        ),
      ),
    );
  }
}
