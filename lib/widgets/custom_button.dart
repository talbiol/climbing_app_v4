// lib/widgets/custom_button.dart

import 'package:flutter/material.dart';
import '../style.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color textColor;

  final bool borderDisplay;
  final double borderThickness;
  final Color borderColor;

  final double leftPadding;
  final double topPadding;
  final double rightPadding;
  final double bottomPadding;

  final bool transparent;
  final Color backgroundColor;

  final bool entireAvailableWidth;

  final bool bold;

  final VoidCallback? onClick;

  CustomButton({
    required this.text,
    this.textColor = AppColors.mainButtonText,

    this.borderDisplay = false,
    this.borderThickness = BorderThickness.small,
    this.borderColor = AppColors.buttonMainBorder,

    this.leftPadding = Spacing.none,
    this.topPadding = Spacing.none,
    this.rightPadding = Spacing.none,
    this.bottomPadding = Spacing.none,
    
    this.transparent = false,
    this.backgroundColor = AppColors.mainWidget,

    this.entireAvailableWidth = true, // default spans entire width

    this.bold = false, 

    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        leftPadding,
        topPadding,
        rightPadding,
        bottomPadding,
      ),
      child: GestureDetector(
        onTap: onClick,
        child: Container(
          width: entireAvailableWidth ? double.infinity : null,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: transparent ? Colors.transparent : backgroundColor,
            border: borderDisplay
                ? Border.all(
                    color: borderColor,
                    width: borderThickness,
                  )
                : null,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal, // apply bold
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
