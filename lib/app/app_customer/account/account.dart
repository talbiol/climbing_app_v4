import 'package:flutter/material.dart';
import '../../../auth/auth_service.dart';
import '../../../models/logged_in_user.dart';
import '../../../models/profile.dart';
import '../../../style.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/profile_area.dart';
import 'settings/settings_home.dart';

class AccountScreen extends StatefulWidget {
  final LoggedInUserInfo loggedInUser;
  final Profile loggedInProfile;

  const AccountScreen(
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
        title: Text(
          widget.loggedInProfile.username ?? "unknown",
          style: TextStyle(color: AppColors.mainText),
        ),
        actions: [
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
        padding: const EdgeInsets.all(Spacing.large),
        child: Column(
          children: [
            ProfileArea(userProfile: widget.loggedInProfile),
            CustomButton(
              text: 'Edit Profile',
              height: 32,
              verticalPadding: 0,
            ),
          ],
        ),
      ),
    );
  }
}
