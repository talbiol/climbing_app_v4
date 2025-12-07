// lib/app/app_registration/trainer_or_not.dart

import 'package:climbing_app_v4/style.dart';
import 'package:flutter/material.dart';
import '../../../models/logged_in_user.dart';
import '../../../widgets/custom_button.dart';
import 'sports_choice.dart';

class TrainerOrNot extends StatelessWidget {
  final LoggedInUserInfo loggedInUser;

  const TrainerOrNot({
    Key? key,
    required this.loggedInUser,
  }) : super(key: key);

  void _goToSportsChoice(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SportsChoice(
          loggedInUser: loggedInUser,
          registrationProcess: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.large),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                text: "Trainer",
                bottomPadding: Spacing.small,
                onClick: () {
                  loggedInUser.isTrainer = true;
                  _goToSportsChoice(context);
                },
              ),
              CustomButton(
                text: "Self-trained / Client",
                backgroundColor: AppColors.secondaryWidget,
                onClick: () {
                  loggedInUser.isTrainer = false;
                  _goToSportsChoice(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
