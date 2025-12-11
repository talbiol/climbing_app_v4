// lib/app/app_customer/home_page.dart

import 'package:flutter/material.dart';

import '../../auth/auth_service.dart';
import '../../auth/delete_account.dart';
import '../../auth/login.dart';
import '../../models/logged_in_user.dart';
import '../../style.dart';
import 'privacy_settings.dart';


class SettingsHome extends StatelessWidget {
  final LoggedInUserInfo loggedInUser;
  final AuthService authService = AuthService();

  SettingsHome(this.loggedInUser);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainBackground,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          color: AppColors.mainText
        ),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.fromLTRB(Spacing.large, Spacing.large, Spacing.large, Spacing.large),
        child: Column(
          children: [
            
            Text(
              "Registration finished: ${loggedInUser.finishedRegistration}",
              style: const TextStyle(
                color: AppColors.mainText, 
              ),
            ),
            Text(
              "Trainer: ${loggedInUser.isTrainer}",
              style: const TextStyle(
                color: AppColors.mainText, 
              ),
            ),
            Text(
              "${loggedInUser.userId}",
              style: const TextStyle(
                color: AppColors.mainText, 
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('Privacy Settings', style: TextStyle(color: AppColors.mainText)),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PrivacySettingsPage(userId: loggedInUser.userId),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Logout', style: TextStyle(color: AppColors.mainText)),
              onTap: () async {
                await authService.logOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LogInScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Delete Account', style: TextStyle(color: AppColors.deleteColor)),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DeleteAccountPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
