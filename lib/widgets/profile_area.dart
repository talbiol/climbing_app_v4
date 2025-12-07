import 'package:flutter/material.dart';

import '../models/profile.dart';
import '../style.dart';

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
                ProfileAvatar(size: 60),
                Text(userProfile.profilePictureName ?? '', style: TextStyle(color: AppColors.mainText)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:EdgeInsetsGeometry.fromLTRB(Spacing.large, Spacing.none, Spacing.none, Spacing.none), 
                  child: Text(userProfile.fullName ?? '', style: TextStyle(color: AppColors.mainText)),
                ),
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
              Text(userProfile.sportNames!.join(', '), style: TextStyle(color: AppColors.mainText)),
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

// ------------------------ ProfileAvatar Widget ------------------------
class ProfileAvatar extends StatelessWidget {
  final double size;

  const ProfileAvatar({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.avatarBackground,
      ),
      child: Icon(
        Icons.person,
        color: Colors.white,
        size: size * 0.6,
      ),
    );
  }
}
