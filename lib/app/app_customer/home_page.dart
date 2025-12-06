// lib/app/app_customer/home_page.dart

import 'package:flutter/material.dart';
import '../../auth/delete_account.dart';
import '../../auth/login.dart';
import '../../style.dart';
import '../../widgets/custom_button.dart';
import '../../models/logged_in_user.dart';
import '../../auth/auth_service.dart';

class HomePage extends StatelessWidget {
  final LoggedInUserInfo loggedInUser;
  final AuthService authService = AuthService();

  HomePage(this.loggedInUser);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainBackground,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.fromLTRB(Spacing.large, Spacing.large, Spacing.large, Spacing.large),
        child: Column(
          children: [
            Text(
              "finished registration: ${loggedInUser.finishedRegistration}",
              style: const TextStyle(
                color: AppColors.mainText, // Replace with your desired color
              ),
            ),
            Text(
              "${loggedInUser.userId}",
              style: const TextStyle(
                color: AppColors.mainText, // Replace with your desired color
              ),
            ),
            CustomButton(
              text: "Log Out",
              topPadding: Spacing.small,
              onClick: () async {
                await authService.logOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LogInScreen()),
                );
              },
            ),
            CustomButton(
              text: "Delete Account",
              backgroundColor: AppColors.deleteColor,
              topPadding: Spacing.small,
              onClick: () {
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
