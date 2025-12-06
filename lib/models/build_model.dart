// lib/models/build_model.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import 'logged_in_user.dart';
import 'sport.dart';

class BuildModel {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<LoggedInUserInfo> buildLoggedInUser(String userId) async {
    final response = await supabase
        .from('user_info')
        .select()
        .eq('user_id', userId)
        .single();

    final user = _ConcreteLoggedInUser(userId: userId);
    user.finishedRegistration = response['registration_finished'];
    user.fullName = response['full_name'];
    user.isTrainer = response['trainer'];

    return user;
  }

  Future<Sport> buildSport(String sportId, String userId) async {
    // Convert sportId to int since DB uses SERIAL (int)
    final int parsedSportId = int.parse(sportId);

    // 1) Get sport info from sports_choices
    final sportChoice = await supabase
        .from('sports_choices')
        .select('name, description')
        .eq('sport_id', parsedSportId)
        .single();

    // 2) Try to find user-to-sport relation
    final sportToUser = await supabase
        .from('sports_to_user')
        .select('sports_to_user_id, currently_active')
        .eq('sport_id', parsedSportId)
        .eq('user_id', userId)
        .maybeSingle();

    // 3) Build the Sport object
    final sport = Sport(
      sportId: sportId,
      name: sportChoice['name'] as String?,
      description: sportChoice['description'] as String?,
      sportToUserId: sportToUser?['sports_to_user_id'] as int?,
      currentlyAssignedToUser:
          (sportToUser?['currently_active'] as bool?) ?? false,
    );

    return sport;
  }
}

class _ConcreteLoggedInUser extends LoggedInUserInfo {
  _ConcreteLoggedInUser({required super.userId});
}
