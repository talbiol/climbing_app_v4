import 'package:climbing_app_v4/style.dart';
import 'package:flutter/material.dart';

class CustomToggleSwitch extends StatefulWidget {
  final bool initState;
  final bool alwaysSameText;
  final String? text;
  final String? textWhenTrue;
  final String? textWhenFalse;

  final Color switchBackgroundFalse;
  final Color switchBallFalse;
  final Color switchBackgroundTrue;
  final Color switchBallTrue;

  final ValueChanged<bool>? onChanged;

  const CustomToggleSwitch({
    super.key,
    this.initState = false,
    this.alwaysSameText = true,
    this.text,
    this.textWhenTrue,
    this.textWhenFalse,
    this.switchBackgroundFalse = const Color(0xFFD3D3D3), // light gray
    this.switchBallFalse = const Color(0xFFA9A9A9),       // dark gray
    this.switchBackgroundTrue = const Color(0xFF006400),  // dark green
    this.switchBallTrue = const Color(0xFFD3D3D3),        // light gray
    this.onChanged,
  });

  @override
  State<CustomToggleSwitch> createState() => _CustomToggleSwitchState();
}

class _CustomToggleSwitchState extends State<CustomToggleSwitch> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initState;
  }

  @override
  Widget build(BuildContext context) {
    String displayText;
    if (widget.alwaysSameText) {
      displayText = widget.text ?? '';
    } else {
      displayText = _value ? (widget.textWhenTrue ?? '') : (widget.textWhenFalse ?? '');
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            displayText,
            style: const TextStyle(color: AppColors.mainText),
          ),
        ),
        Switch(
          value: _value,
          onChanged: (val) {
            setState(() {
              _value = val;
            });
            if (widget.onChanged != null) {
              widget.onChanged!(val);
            }
          },
          activeColor: widget.switchBallTrue,
          activeTrackColor: widget.switchBackgroundTrue,
          inactiveThumbColor: widget.switchBallFalse,
          inactiveTrackColor: widget.switchBackgroundFalse,
        ),
      ],
    );
  }
}
