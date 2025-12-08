// lib/models/build_model.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import 'logged_in_user.dart';
import 'profile.dart';
import 'sport.dart';

class BuildModel {
  final SupabaseClient supabase = Supabase.instance.client;

// ------------------------ LoggedInUserInfo ------------------------
  Future<LoggedInUserInfo> buildLoggedInUser(String userId) async {
    final response = await supabase
        .from('user_info')
        .select()
        .eq('user_id', userId)
        .single();

    final user = LoggedInUserInfo(userId: userId);
    user.fullName = response['full_name'];
    user.isTrainer = response['trainer'];
    user.finishedRegistration = response['registration_finished'];
    if (user.finishedRegistration == true) {
      print("build user with finished registration parameters");
    }
    return user;
  }

// ------------------------ Sport ------------------------

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
      sportToUserId: sportToUser?['sports_to_user_id'] as String?,
      currentlyAssignedToUser:
          (sportToUser?['currently_active'] as bool?) ?? false,
    );

    return sport;
  }

  // ------------------------ Profile ------------------------
  Future<Profile> buildProfile(String userId, bool isTrainer) async {
    final userProfile = Profile(userId: userId);

    // Fetch user info from Supabase
    final userInfoResponse = await supabase
        .from('user_info')
        .select()
        .eq('user_id', userId)
        .single();

    userProfile.username = userInfoResponse['username'] ?? 'unknown';
    userProfile.fullName = userInfoResponse['full_name'];
    userProfile.instagramUsername = userInfoResponse['instagram_username'];
    userProfile.description = userInfoResponse['description'];

    userProfile.profilePictureName = userInfoResponse['profile_picture_name'];

    // Build sports list
    userProfile.sportNames = await buildProfileSportList(userId);

    if (isTrainer == true) {
      final trainerInfoResponse = await supabase
      .from('trainer_contact')
      .select()
      .eq('user_id', userId)
      .maybeSingle(); // returns null if no row exists

      if (trainerInfoResponse != null) {
        userProfile.workEmail = trainerInfoResponse['contact_email'];
        userProfile.workTelPrefix = trainerInfoResponse['contact_tel_prefix'];
        userProfile.workTel = trainerInfoResponse['contact_tel'];
      }
    }
    return userProfile;
  }

  // Build list of sports for a given user
  Future<List<String>> buildProfileSportList(String userId) async {
    // 1. Get sport IDs associated with the user
    final userSportsResponse = await supabase
        .from('sports_to_user')
        .select('sport_id')
        .eq('currently_active', true)
        .eq('user_id', userId);

    List<String> sportIds = [];
    sportIds = List<String>.from(
        userSportsResponse.map((row) => row['sport_id'].toString()));
    
    // 2. Fetch sport names for each sport ID
    List<String> sportNames = [];
    for (var sportId in sportIds) {
      final sportResponse = await supabase
          .from('sports_choices')
          .select('name')
          .eq('sport_id', sportId)
          .single();

      final sportName = sportResponse['name'] as String;
      
      if (sportName.toLowerCase() != 'general') {
        sportNames.add(sportName);
      }
    }
    return sportNames;
  }
}
