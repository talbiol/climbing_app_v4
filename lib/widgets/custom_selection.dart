// widgets/custom_selection.dart

import 'package:flutter/material.dart';

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
        // Selection Indicator
        Container(
          width: 22,
          height: 22,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: currentlyAssigned
              ? Center(
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                  ),
                )
              : null,
        ),

        // Your Card Widget
        Expanded(child: card),
      ],
    );
  }
}
