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
        IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile picture column
            Column(
              children: [
                ProfilePicture(size: 90, loggedInProfile: this.userProfile),
              ],
            ),

            // Expand the container so it takes all remaining space
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: Spacing.large),
                child: Container(
                  padding: EdgeInsets.all(Spacing.small),
                  /*decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.mainWidget,
                      width: BorderThickness.small,
                    ),
                  ),*/
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Full name (wraps automatically)
                      Text(
                        userProfile.fullName ?? '',
                        style: TextStyle(color: AppColors.mainText, fontWeight: FontWeight.bold),
                      ),

                      // Instagram username
                      if (userProfile.instagramUsername != null)
                        Text(
                          '@${userProfile.instagramUsername}',
                          style: TextStyle(color: AppColors.mainText),
                        ),

                      // work email
                      if (userProfile.workEmail != null)
                        Text(
                          '${userProfile.workEmail}',
                          style: TextStyle(color: AppColors.mainText),
                        ),
                      
                      // tel + prefix
                      if (userProfile.workTelPrefix != null && userProfile.workTel != null)
                        Text(
                          '+(${userProfile.workTelPrefix}) ${userProfile.workTel}',
                          style: TextStyle(color: AppColors.mainText),
                        ),

                      if (userProfile.workTelPrefix == null && userProfile.workTel != null)
                        Text(
                          '${userProfile.workTel}',
                          style: TextStyle(color: AppColors.mainText),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )),
        // Sports list
        if (userProfile.sportNames != null && userProfile.sportNames!.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: Spacing.medium, bottom: Spacing.small),
            child: Text(
              'Sports: ${userProfile.sportNames?.join(', ') ?? ''}',
              style: TextStyle(color: AppColors.sportsColor),
            ),
          ),
          
        // Description
        if (userProfile.description != null)
          Text(userProfile.description!, style: TextStyle(color: AppColors.mainText))
      ],
    );
  }
}


