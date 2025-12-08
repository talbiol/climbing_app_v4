// lib/style.dart

import 'package:flutter/material.dart';

class AppColors {
  // backgrounds
  static const Color mainBackground = Color(0xFFFFFFFF);  // lightmode: 0xFFFFFFFF | darkMode: 0xFF201F1F

  // text
  static const Color mainText = Color(0xFF000000);        // lightmode: 0xFF000000 | darkMode: 0xFFFFFFFF
  static const Color mainButtonText = Color(0xFFFFFFFF);  // lightmode: 0xFFFFFFFF | darkMode: 0xFF000000

  //elements
  static const mainWidget = Color(0xFF819A91);            // lightmode: 0xFF819A91 | darkMode: 0xFFD1D8BE
  static const secondaryWidget = Color(0xFFA7C1A8);       

  // borders
  static const buttonMainBorder = Color(0xFF383636);      // lightmode: 0xFF383636 | darkMode: 0xFFCBC5C5

  // event association
  static const deleteColor = Color(0xFFBB0202);
  static const snackBarMain = Color(0xFF607D8B);          // lightmode: 0xFF607D8B

  static const avatarBackground = Color(0xFF819A91);
  static const sportsColor = Color(0xFF162C91);

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
