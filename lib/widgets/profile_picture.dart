import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile.dart';
import '../style.dart';

class ProfilePicture extends StatefulWidget {
  final double size;
  final bool edit;
  final Profile? loggedInProfile;
  final VoidCallback? onEdit; // optional callback if needed

  const ProfilePicture({
    Key? key,
    required this.size,
    this.edit = false,
    this.loggedInProfile,
    this.onEdit,
  }) : super(key: key);

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  File? _pickedImage;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
    }
  }

  Widget buildDefaultAvatar(double size) {
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

  Widget buildProfilePicture(double size) {
    // If user picked a new image, display it immediately
    if (_pickedImage != null) {
      return ClipOval(
        child: Image.file(
          _pickedImage!,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    }

    // Otherwise, display the current profile picture from Supabase
    final profilePictureName = widget.loggedInProfile?.profilePictureName;
    if (profilePictureName == null) return buildDefaultAvatar(size);

    // Only generating public URL; actual upload is handled elsewhere
    final imageUrl = Supabase.instance.client
        .storage
        .from('profile-pictures')
        .getPublicUrl(profilePictureName);

    return ClipOval(
      child: Image.network(
        imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return buildDefaultAvatar(size);
        },
      ),
    );
  }

  Widget buildEdit(double size, Widget picture) {
    return GestureDetector(
      onTap: _pickImage,
      child: Center( 
        child: Stack(
        children: [
          picture,
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: size * 0.3,
              height: size * 0.3,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Icon(
                Icons.edit,
                size: size * 0.2,
                color: Colors.black,
              ),
            ),
          ),
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget picture = buildProfilePicture(widget.size);

    if (!widget.edit) return picture;

    return buildEdit(widget.size, picture);
  }
}
