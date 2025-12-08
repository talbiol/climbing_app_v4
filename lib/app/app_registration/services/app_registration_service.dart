import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/logged_in_user.dart';
import '../../../models/sport.dart';


class AppRegistrationService {
  final SupabaseClient supabase = Supabase.instance.client;

  AppRegistrationService();

  // see if user has registered
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
            print('Inserted new sports_to_user: ${sport.name} (${sport.sportId}) active=${sport.currentlyAssignedToUser}');
            buildCategoriesForUser(userId, int.parse(sport.sportId));
          } catch (e) {
            print('Error inserting sport ${sport.name}: $e');
          }
        }
      }
    }
  }

  Future<void> buildCategoriesForUser(String userId, int sportId) async {
    try {
      // 1. Get all preset categories for the given sport
      final response = await supabase
        .from('preset_categories')
        .select()
        .eq('sport_id', sportId);

      final List<dynamic> presetCategories = response as List<dynamic>;

      // 2. Prepare user category rows
      List<Map<String, dynamic>> userCategoryRows = [];

      for (var preset in presetCategories) {
        final newUserCategory = {
          'preset_category_id': preset['category_id'],
          'user_id': userId,
          'type_id': preset['type_id'],
          'name': preset['name'],
          'is_preset': true,
          'is_personal_best': preset['is_personal_best'],
          'is_post_training': preset['is_post_training'],
        };

        userCategoryRows.add(newUserCategory);
      }

      // 3. Insert rows into user_categories
      if (userCategoryRows.isNotEmpty) {
        final insertResponse = await supabase
          .from('user_categories')
          .insert(userCategoryRows);

        if (insertResponse.error != null) {
          throw insertResponse.error!;
        }

        print('Inserted ${userCategoryRows.length} user categories.');
      } else {
        print('No preset categories found for sportId $sportId.');
      }
    } catch (e) {
      print('Error building categories: $e');
    }
  }

  Future<void> setPrivacySettings(String userId) async {
    try {
      // Insert a new row with default values
      final newPrivacyForUser = {
        'user_id': userId,
      };
      final insertResponse = await supabase
          .from('privacy_settings')
          .insert(newPrivacyForUser);

      print('Privacy settings created for user: $userId');
    } catch (e) {
      print('Error creating privacy settings: $e');
    }
  }
}
