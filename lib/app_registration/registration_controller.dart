// lib/app/app_registration/app_registration.dart

import 'package:flutter/material.dart';

import '../models/logged_in_user.dart';
import '../app/screens/home_page.dart';
import 'screens/trainer_or_not.dart';

class RegistrationController extends StatelessWidget {
  final LoggedInUserInfo loggedInUser;

  const RegistrationController({
    Key? key,
    required this.loggedInUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Redirect user based on registration state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (loggedInUser.finishedRegistration == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomePage(loggedInUser),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => TrainerOrNot(loggedInUser: loggedInUser),
          ),
        );
      }
    });

    // Empty screen while redirecting
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
