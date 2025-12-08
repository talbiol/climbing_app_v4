import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../models/profile.dart';

class EditProfileService {
  final supabase = Supabase.instance.client;

  Future<void> writeUserProfile(
    String userId,
    bool isTrainer,
    Profile userProfile,
  ) async {
    // --- Update user_info table ---
    await supabase.from('user_info').update({
      'full_name': userProfile.fullName,
      'instagram_username': userProfile.instagramUsername,
      'description': userProfile.description,
      'inserted_at': DateTime.now().toIso8601String(),
    }).eq('user_id', userId);

    // --- Trainer-specific logic ---
    if (isTrainer) {
      final existing = await supabase
          .from('trainer_contact')
          .select('contact_id')
          .eq('user_id', userId)
          .maybeSingle();

      if (existing != null) {
        await supabase.from('trainer_contact').update({
          'contact_email': userProfile.workEmail,
          'contact_tel': userProfile.workTel,
          'contact_tel_prefix': userProfile.workTelPrefix,
          'inserted_at': DateTime.now().toIso8601String(),
        }).eq('user_id', userId);
      } else {
        await supabase.from('trainer_contact').insert({
          'user_id': userId,
          'contact_email': userProfile.workEmail,
          'contact_tel': userProfile.workTel,
          'contact_tel_prefix': userProfile.workTelPrefix,
          'inserted_at': DateTime.now().toIso8601String(),
        });
      }
    }
  }

  /// --- New method to handle profile picture upload & deletion ---
  Future<String> uploadProfilePicture(String userId, File newPicture, {String? oldPictureName}) async {
    final storage = supabase.storage.from('profile-pictures');

    // Delete old picture if exists
    if (oldPictureName != null && oldPictureName.isNotEmpty) {
      try {
        await storage.remove([oldPictureName]);
      } catch (e) {
        print("Failed to delete old profile picture: $e");
      }
    }

    // New picture name: userId_timestamp.jpg
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final newPictureName = '${userId}_$timestamp.jpg';

    // Upload new picture
    await storage.upload(
      newPictureName,
      newPicture,
      fileOptions: FileOptions(upsert: true),
    );

    // Update user_info table with new picture name
    await supabase.from('user_info').update({
      'profile_picture_name': newPictureName,
      'inserted_at': DateTime.now().toIso8601String(),
    }).eq('user_id', userId);

    return newPictureName;
  }
}
