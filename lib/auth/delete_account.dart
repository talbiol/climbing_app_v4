// lib/auth/delete_account.dart

import 'package:flutter/material.dart';
import '../style.dart';
import '../widgets/custom_button.dart';
import '../widgets/loading_wheel.dart';
import 'auth_service.dart';
import 'login.dart';
import '../widgets/delete_confirmation.dart';

class DeleteAccountPage extends StatefulWidget {
  DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  Future<void> _deleteAccount() async {
    final confirmed = await showDialog(
      context: context,
      builder: (_) => const DeleteConfirmation(
        message:
            'Are you sure you want to delete your account? This action cannot be undone.',
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);

    final success = await _authService.deleteAccount();

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LogInScreen()),
        (_) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete account.')),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Delete Account'),
        backgroundColor: AppColors.mainBackground,
        foregroundColor: AppColors.mainText,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(Spacing.large),
        child: Column(
          children: [
            const Text(
              'Deleting your account is permanent. Are you sure you want to continue?',
              textAlign: TextAlign.center,
            ),
            _isLoading
                ? const LoadingWidget()
                : CustomButton(
                    text: 'Delete Account',
                    backgroundColor: AppColors.deleteColor,
                    textColor: Colors.white,
                    topPadding: Spacing.large,
                    onClick: _deleteAccount,
                  ),
          ],
        ),
      ),
    );
  }
}