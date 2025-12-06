// lib/app/app_registration/sports_choice.dart

import 'package:climbing_app_v4/style.dart';
import 'package:climbing_app_v4/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import '../../models/logged_in_user.dart';
import '../app_customer/home_page.dart';

class SportsChoice extends StatelessWidget {
  final LoggedInUserInfo loggedInUser;
  final bool registrationProcess;

  const SportsChoice({
    Key? key,
    required this.loggedInUser,
    required this.registrationProcess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainBackground,
        automaticallyImplyLeading: true,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              '${loggedInUser.isTrainer}',
              style: const TextStyle(
                color: AppColors.mainText, // Replace with your desired color
              ),
            ),
            CustomButton(
              text: 'Advance to next',
              topPadding: Spacing.medium,
              leftPadding: Spacing.large,
              rightPadding: Spacing.large,
              onClick: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HomePage(loggedInUser),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
