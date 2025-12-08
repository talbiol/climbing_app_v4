import 'package:flutter/material.dart';

import '../../../../style.dart';
import '../../../../widgets/custom_toggle_switch.dart';


class PrivacySettingsPage extends StatefulWidget {
  final String userId;
  PrivacySettingsPage({super.key, required this.userId});

  @override
  State<PrivacySettingsPage> createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Privacy Settings'),
        backgroundColor: AppColors.mainBackground,
        foregroundColor: AppColors.mainText,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(Spacing.large),
        child: Column(
          children: [
            Text(
              'not sure',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.mainText, 
              ),
            ),
            CustomToggleSwitch(
              initState: true,
              alwaysSameText: false,
              textWhenTrue: "Enabled",
              textWhenFalse: "Disabled",
              onChanged: (value) {
                print("Switch value: $value");
              },
            )
          ],
        ),
      ),
    );
  }
}