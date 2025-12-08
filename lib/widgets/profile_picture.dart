import 'package:flutter/material.dart';

import '../style.dart';

class ProfilePicture extends StatelessWidget {
  final double size;

  const ProfilePicture({super.key, required this.size});

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
        size: size * 0.7,
      ),
    );
  }
}