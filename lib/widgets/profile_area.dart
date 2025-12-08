import 'package:flutter/material.dart';

import '../models/profile.dart';
import '../style.dart';
import 'profile_picture.dart';

// ------------------------ ProfileArea Widget ------------------------
class ProfileArea extends StatelessWidget {
  final Profile userProfile;

  const ProfileArea({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top row: avatar + full name
        Row(
          children: [
            Column(
              children: [
                ProfilePicture(size: 60, loggedInProfile: this.userProfile),
                //Text(userProfile.profilePictureName ?? '', style: TextStyle(color: AppColors.mainText)),
                Padding(
                  padding:EdgeInsetsGeometry.fromLTRB(Spacing.large, Spacing.none, Spacing.none, Spacing.none), 
                  child: Text(userProfile.fullName ?? '', style: TextStyle(color: AppColors.mainText)),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
              ],
            ),
          ],
        ),
        // Instagram username
        if (userProfile.instagramUsername != null)
          Row(
            children: [
              Text('@${userProfile.instagramUsername}', style: TextStyle(color: AppColors.mainText)),
            ],
          ),
        // Sports list
        if (userProfile.sportNames != null && userProfile.sportNames!.isNotEmpty)
          Row(
            children: [
              Text(
                'Sports: ${userProfile.sportNames?.join(', ') ?? ''}',
                style: TextStyle(color: AppColors.mainText)
              ),
            ],
          ),
        // Description
        if (userProfile.description != null)
          Row(
            children: [
              Expanded(
                child: Text(userProfile.description!, style: TextStyle(color: AppColors.mainText))
              ),
            ],
          ),
      ],
    );
  }
}


