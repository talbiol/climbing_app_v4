// lib/auth/login.dart

import 'package:flutter/material.dart';
import '../style.dart';
import '../widgets/custom_input_box.dart';
import '../widgets/custom_button.dart';
import 'auth_service.dart';
import '../models/build_model.dart';
import '../app/app_registration/registration_controller.dart';
import 'register.dart';

class LogInScreen extends StatefulWidget {
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();
  final BuildModel buildModel = BuildModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainBackground,
        automaticallyImplyLeading: false,
      ),
      body: Padding(padding: EdgeInsetsGeometry.fromLTRB(Spacing.large, Spacing.large, Spacing.large, Spacing.large), 
      child: Column(
        children: [
          CustomInputBox(
            placeholder: "email",
            controller: emailController,
            bottomPadding: Spacing.small,
          ),
          CustomInputBox(
            placeholder: "password",
            bottomPadding: Spacing.small,
            password: true,
            controller: passwordController,
          ),
          CustomButton(
            text: "Log In",
            bottomPadding: Spacing.small,
            onClick: () async {
              final userId = await authService.logIn(
                  emailController.text, passwordController.text);
              if (userId != null) {
                final loggedInUser =
                    await buildModel.buildLoggedInUser(userId);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RegistrationController(loggedInUser: loggedInUser)),
                );
              } else {
                // Show Snackbar on failed login
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Login failed. Invalid credentials.'),
                    backgroundColor: AppColors.snackBarMain,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
          CustomButton(
            text: "Log in with Google",
            bottomPadding: Spacing.small,
            textColor: AppColors.mainText,
            transparent: true,
            onClick: authService.logInWithGoogle,
          ),
          CustomButton(
            text: "Don't have an account? Sign up",
            textColor: AppColors.mainWidget,
            bold: true,
            transparent: true,
            onClick: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterScreen()),
              );
            },
          ),
          CustomButton(
            text: "Forgot your password?",
            textColor: AppColors.mainWidget,
            transparent: true,
            onClick: authService.resetPassword,
          ),
        ],
      ),
    ));
  }
}
