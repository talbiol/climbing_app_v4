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
      // Check if trainer_contact row exists
      final existing = await supabase
          .from('trainer_contact')
          .select('contact_id')
          .eq('user_id', userId)
          .maybeSingle();

      if (existing != null) {
        // Update existing trainer_contact row
        await supabase.from('trainer_contact').update({
          'contact_email': userProfile.workEmail,
          'contact_tel': userProfile.workTel,
          'contact_tel_prefix': userProfile.workTelPrefix,
          'inserted_at': DateTime.now().toIso8601String(),
        }).eq('user_id', userId);
      } else {
        // Insert new trainer_contact row
        await supabase.from('trainer_contact').insert({
          // contact_id auto-generates
          'user_id': userId,
          'contact_email': userProfile.workEmail,
          'contact_tel': userProfile.workTel,
          'contact_tel_prefix': userProfile.workTelPrefix,
          'inserted_at': DateTime.now().toIso8601String(),
        });
      }
    }
  }
}
