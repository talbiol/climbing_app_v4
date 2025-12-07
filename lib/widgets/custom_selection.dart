// widgets/custom_selection.dart

import 'package:flutter/material.dart';

import '../style.dart';

class CustomSelection extends StatelessWidget {
  final bool currentlyAssigned;
  final Widget card;

  const CustomSelection({
    Key? key,
    required this.currentlyAssigned,
    required this.card,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 22,
          height: 22,
          margin: const EdgeInsets.only(right: Spacing.medium),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.mainText, width: 2),
          ),
          child: currentlyAssigned
              ? Center(
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.mainText,
                    ),
                  ),
                )
              : null,
        ),
        Expanded(child: card),
      ],
    );
  }
}
