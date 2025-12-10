import 'package:climbing_app_v4/style.dart';
import 'package:climbing_app_v4/widgets/profile_area.dart';
import 'package:flutter/material.dart';

import '../../../models/profile.dart';

class SearchedAccountScreen extends StatelessWidget {
  final Profile profile;

  const SearchedAccountScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: false,
        title: Text(profile.username ?? "User", style: TextStyle(color: AppColors.mainText, fontWeight: FontWeight.bold)),
        leading: BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: Spacing.large, right: Spacing.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileArea(userProfile: profile),
            Text("Username: ${profile.username}"),
            Text("Trainer: ${profile.isTrainer ?? false}"),
            Text("User ID: ${profile.userId}"),
          ],
        ),
      ),
    );
  }
}
