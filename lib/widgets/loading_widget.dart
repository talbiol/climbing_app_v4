// lib/widgets/loading_widget.dart

import 'package:flutter/material.dart';
import '../style.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;
  const LoadingWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondaryWidget),
              backgroundColor: AppColors.mainWidget,
            ),
          ),
          const SizedBox(height: Spacing.small),
          Text(
            message ?? '',
          ),
        ],
      ),
    );
  }
}