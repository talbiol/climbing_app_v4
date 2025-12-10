import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../models/privacy.dart';

class UserPrivacyService {
  final supabase = Supabase.instance.client;
  
  Future<void> writePrivacyPreferences(String userId, Privacy userPrivacy) async {
    final updates = {
      'public': userPrivacy.public,

      'friends_dashboard': userPrivacy.friendsDashboard,
      'friends_calendar': userPrivacy.friendsCalendar,
      'friends_objectives': userPrivacy.friendsPB,
      'friends_routines': userPrivacy.friendsRoutines,
      'friends_journal': userPrivacy.friendsJournal,

      'trainer_dashboard': userPrivacy.trainerDashboard,
      'trainer_calendar': userPrivacy.trainerCalendar,
      'trainer_objectives': userPrivacy.trainerPB,
      'trainer_routines': userPrivacy.trainerRoutines,
      'trainer_journal': userPrivacy.trainerJournal,
    };

    // Conditional entries for everyone / default users
    if (userPrivacy.public == false) {
      updates.addAll({
        'default_users_dashboard': false,
        'default_users_calendar': false,
        'default_users_objectives': false,
        'default_users_routines': false,
        'default_users_journal': false,
      });
    } else {
      updates.addAll({
        'default_users_dashboard': userPrivacy.everyoneDashboard,
        'default_users_calendar': userPrivacy.everyoneCalendar,
        'default_users_objectives': userPrivacy.everyonePB,
        'default_users_routines': userPrivacy.everyoneRoutines,
        'default_users_journal': userPrivacy.everyoneJournal,
      });
    }

    // Remove nulls so only existing values update
    updates.removeWhere((key, value) => value == null);

    final response = await supabase
      .from('privacy_settings')
      .update(updates)
      .eq('user_id', userId);
    print(response);
  }
}