// lib/widgets/custom_input_box.dart

import 'package:flutter/material.dart';
import '../style.dart';

class CustomInputBox extends StatefulWidget {
  final String? placeholder;
  final Color? textColor;

  final double leftPadding;
  final double topPadding;
  final double rightPadding;
  final double bottomPadding;

  final bool transparent;
  final Color backgroundColor;

  final Color? cursorColor; 

  final bool password;
  final TextEditingController? controller;

  final bool borderDisplay;
  final double borderRoundness;

  final double unselectedBorderWidth;
  final Color? unselectedBorderColor;
  final double selectedBorderWidth;
  final Color? selectedBorderColor;

  CustomInputBox({
    this.placeholder,
    this.textColor = AppColors.mainText,

    this.leftPadding = Spacing.none,
    this.topPadding = Spacing.none,
    this.rightPadding = Spacing.none,
    this.bottomPadding = Spacing.none,

    this.transparent = false,
    this.backgroundColor = AppColors.mainBackground,

    this.cursorColor = AppColors.mainWidget,

    this.password = false,
    this.controller,

    this.borderDisplay = true,
    this.borderRoundness = CustomBorderRadius.somewhatRound,

    this.unselectedBorderWidth = BorderThickness.small,
    Color? unselectedBorderColor,
    this.selectedBorderWidth = BorderThickness.medium,
    Color? selectedBorderColor,
  })  : unselectedBorderColor = unselectedBorderColor ?? textColor,
        selectedBorderColor = selectedBorderColor ?? AppColors.mainWidget;

  @override
  _CustomInputBoxState createState() => _CustomInputBoxState();
}

class _CustomInputBoxState extends State<CustomInputBox> {
  bool obscureText = true;

  OutlineInputBorder buildBorder(double width, Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRoundness),
      borderSide: BorderSide(
        width: width,
        color: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color unselectedColor = widget.borderDisplay
        ? widget.unselectedBorderColor!
        : Colors.transparent;
    final Color selectedColor = widget.borderDisplay
        ? widget.selectedBorderColor!
        : Colors.transparent;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        widget.leftPadding,
        widget.topPadding,
        widget.rightPadding,
        widget.bottomPadding,
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.password ? obscureText : false,
        cursorColor: widget.cursorColor ?? widget.textColor,
        style: TextStyle(color: widget.textColor),
        decoration: InputDecoration(
          hintText: widget.placeholder,
          hintStyle: TextStyle(color: widget.textColor),
          filled: true,
          fillColor: widget.transparent ? Colors.transparent : widget.backgroundColor,
          enabledBorder: buildBorder(widget.unselectedBorderWidth, unselectedColor),
          focusedBorder: buildBorder(widget.selectedBorderWidth, selectedColor),
          border: buildBorder(widget.unselectedBorderWidth, unselectedColor),
          suffixIcon: widget.password
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: widget.textColor,
                  ),
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
