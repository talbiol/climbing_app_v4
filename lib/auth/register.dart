// lib/auth/register.dart

import 'package:flutter/material.dart';
import '../app_registration/registration_controller.dart';
import '../models/build_model.dart';
import '../widgets/custom_input_box.dart';
import '../widgets/custom_button.dart';
import 'auth_service.dart';
import 'login.dart';
import '../style.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainBackground,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            Spacing.large, Spacing.large, Spacing.large, Spacing.large),
        child: Column(
          children: [
            CustomInputBox(
              placeholder: "full name",
              bottomPadding: Spacing.small,
              controller: fullNameController,
            ),
            CustomInputBox(
              placeholder: "username",
              bottomPadding: Spacing.small,
              controller: usernameController,
            ),
            CustomInputBox(
              placeholder: "email",
              bottomPadding: Spacing.small,
              controller: emailController,
            ),
            CustomInputBox(
              placeholder: "password",
              bottomPadding: Spacing.small,
              password: true,
              controller: passwordController,
            ),
            CustomButton(
              text: "Register",
              bottomPadding: Spacing.small,
              onClick: () async {
                String fullName = fullNameController.text.trim();
                String username = usernameController.text.trim();
                String email = emailController.text.trim();
                String password = passwordController.text;

                // Full name: letters (any case), space, dot, dash
                final namePattern = RegExp(r'^[a-zA-Z .-]+$');

                // Username: lowercase letters, numbers, underscore, dot
                final usernamePattern = RegExp(r'^[a-zA-Z0-9._]+$');

                final emailPattern = RegExp(r'^[a-zA-Z0-9._]+@[a-zA-Z0-9._]+\.[a-zA-Z]+$');

                // Validations
                if (fullName.isEmpty || username.isEmpty || email.isEmpty || password.isEmpty) {
                  _showError("All fields are required");
                  return;
                }
                if (!namePattern.hasMatch(fullName)) {
                  _showError("Full name contains invalid characters");
                  return;
                }
                if (!usernamePattern.hasMatch(username)) {
                  _showError("Username contains invalid characters");
                  return;
                }
                if (!emailPattern.hasMatch(email)) {
                  _showError("Invalid email address");
                  return;
                }
                if (password.length < 6) {
                  _showError("Password must be at least 6 characters");
                  return;
                }

                // All validations passed
                final userId = await authService.register(fullName, username, email, password);
                if (userId != null) {
                  final buildModel = BuildModel();
                  final loggedInUser = await buildModel.buildLoggedInUser(userId);

                  // Navigate to AppPage directly
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RegistrationController(loggedInUser: loggedInUser)),
                  );
                } else {
                  _showError("Registration failed. Please try again.");
                }
              },
            ),
            CustomButton(
              text: "Sign up with Google",
              bottomPadding: Spacing.small,
              textColor: AppColors.mainText,
              transparent: true,
              onClick: authService.registerWithGoogle,
            ),
            CustomButton(
              text: "Already have an account? Log in",
              textColor: AppColors.mainWidget,
              bold: true,
              transparent: true,
              onClick: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LogInScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.snackBarMain,
        duration: Duration(seconds: 2),),
    );
  }
}
