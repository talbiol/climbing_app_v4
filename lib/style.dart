// lib/style.dart

import 'package:flutter/material.dart';

class AppColors {
  // backgrounds
  static const Color mainBackground = Color(0xFFFFFFFF);  // white: 0xFFFFFFFF | black white: 0xFF201F1F

  // text
  static const Color mainText = Color(0xFF000000);        // black: 0xFF000000 | white: 0xFFFFFFFF
  static const Color mainButtonText = Color(0xFFFFFFFF);  // white: 0xFFFFFFFF | black: 0xFF000000

  //elements
  static const mainWidget = Color(0xFF819A91);            // darkGreen: 0xFF819A91 | 
  static const secondaryWidget = Color(0xFFA7C1A8);

  // borders
  static const buttonMainBorder = Color(0xFF383636);      // darkGrey: 0xFF383636 | lightGrey: 0xFFCBC5C5

  // event association
  static const deleteColor = Color(0xFFBB0202);
  static const snackBarMain = Colors.blueGrey;

}

class BorderThickness {
  static const double small = 1;
  static const double medium = 2;
  static const double large = 3;
}

class Spacing {
  static const double none = 0;
  static const double small = 8;
  static const double medium = 16;
  static const double large = 24;
  static const double veryLarge = 80;
}

class CustomBorderRadius {
  static const double somewhatRound = 5;
}
