// lib/widgets/delete_confirmation.dart

import 'package:flutter/material.dart';
import '../style.dart';

class DeleteConfirmation extends StatelessWidget {
  final String message;

  const DeleteConfirmation({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.mainBackground,
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('Cancel', style: TextStyle(color: AppColors.mainText)),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text('Confirm', style: TextStyle(color: AppColors.deleteColor)),
        ),
      ],
    );
  }
}