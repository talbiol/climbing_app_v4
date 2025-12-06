import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/logged_in_user.dart';
import '../../models/sport.dart';


class AppRegistrationService {
  final SupabaseClient supabase = Supabase.instance.client;

  AppRegistrationService();

  /// Write the user's trainer status
  Future<void> writeTrainerOrNotToUser(LoggedInUserInfo user) async {
    try {
      await supabase.from('user_info').update({
        'trainer': user.isTrainer,
      }).eq('user_id', user.userId);
      print('Updated trainer status for ${user.userId}: ${user.isTrainer}');
    } catch (e) {
      print('Error updating trainer status: $e');
    }
  }

  Future<void> writeFinishedRegistrationToUser(LoggedInUserInfo user) async {
    try {
      await supabase.from('user_info').update({
        'registration_finished':true,
      }).eq('user_id', user.userId);
      print('Updated registration status for ${user.userId}: true');
    } catch (e) {
      print('Error updating trainer status: $e');
    }
  }

  /// Write sports assignments for a user
  Future<void> writeSportsToUser(String userId, List<Sport> sports) async {
    for (Sport sport in sports) {
      final now = DateTime.now().toUtc().toIso8601String();

      if (sport.sportToUserId != null) {
        // Update existing mapping
        try {
          await supabase.from('sports_to_user').update({
            'currently_active': sport.currentlyAssignedToUser,
            'inserted_at': now,
          }).eq('sports_to_user_id', sport.sportToUserId!); // <-- note the !
          print(
              'Updated sports_to_user: ${sport.name} (${sport.sportId}) active=${sport.currentlyAssignedToUser}');
        } catch (e) {
          print('Error updating sport ${sport.name}: $e');
        }
      } else {
        // Insert new row if no existing mapping
        if (sport.currentlyAssignedToUser == true) {
          try {
            await supabase.from('sports_to_user').insert({
              'user_id': userId,
              'sport_id': int.parse(sport.sportId), // your DB uses INT
              'currently_active': sport.currentlyAssignedToUser,
              'inserted_at': now,
            });
            print(
              'Inserted new sports_to_user: ${sport.name} (${sport.sportId}) active=${sport.currentlyAssignedToUser}');
          } catch (e) {
            print('Error inserting sport ${sport.name}: $e');
          }
        }
      }
    }
  }
}
