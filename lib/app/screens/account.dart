import 'package:flutter/material.dart';
import '../../auth/auth_service.dart';
import '../../models/user.dart';
import '../../models/profile.dart';
import '../../style.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/profile_area.dart';
import 'edit_profile.dart';
import '../../widgets/section_menu.dart';
import 'inbox.dart';
import 'settings_home.dart';

class AccountScreen extends StatefulWidget {
  late User loggedInUser;
  late Profile loggedInProfile;

  AccountScreen(
    this.loggedInUser,
    this.loggedInProfile, {
    Key? key,
  }) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainBackground,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text(
          widget.loggedInProfile.username ?? "unknown",
          style: TextStyle(color: AppColors.mainText, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.group),
            color: AppColors.mainText,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      InboxScreen(loggedInUser: widget.loggedInUser),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            color: AppColors.mainText,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SettingsHome(widget.loggedInUser),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(Spacing.large,Spacing.small,Spacing.large,Spacing.small),
        child: ListView(
          children: [
            ProfileArea(userProfile: widget.loggedInProfile),
            CustomButton(
              text: 'Edit Profile',
              height: 32,
              verticalPadding: 0,
              topPadding: Spacing.small,
              onClick:() async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(
                      loggedInUser: widget.loggedInUser,
                      loggedInProfile: widget.loggedInProfile,
                    ),
                  ),
                );
                if (result != null && result is List<String>) {
                  setState(() {
                    widget.loggedInProfile.sportNames = result;
                  });
                }
                if (result != null && result is Map<String, dynamic>) {
                  setState(() {
                    widget.loggedInUser = result['loggedInUser'];
                    widget.loggedInProfile = result['loggedInProfile'];
                  });
                }
              },
            ),
            Padding(
              padding:EdgeInsetsGeometry.only(top: Spacing.medium),
              child: FeatureMenuWidget(
                userId: widget.loggedInUser.userId,
                inAccount: true,
                displayDashboard: true,
                displayCalendar: true,
                displayPersonalBest: true,
                displayRoutine: true,
                displayJournal: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
