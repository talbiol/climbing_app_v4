import 'package:climbing_app_v4/style.dart';
import 'package:climbing_app_v4/widgets/profile_area.dart';
import 'package:flutter/material.dart';

import '../../../models/logged_in_user.dart';
import '../../../models/profile.dart';

class SearchedAccountScreen extends StatelessWidget {
  final Profile profile;
  final LoggedInUserInfo loggedInUser;
  const SearchedAccountScreen({super.key, required this.profile, required this.loggedInUser});

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
            Divider(),
            Text("Searched User ID: ${profile.userId}"),
            Text("Logged In User ID: ${loggedInUser.userId}"),
          ],
        ),
      ),
    );
  }
}
