// lib/models/build_model.dart

import 'package:climbing_app_v4/app/services/routine_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'routine.dart';
import 'user.dart';
import 'privacy.dart';
import 'profile.dart';
import 'searched_relationship.dart';
import 'sport.dart';

class BuildModel {
  final SupabaseClient supabase = Supabase.instance.client;

// ------------------------ LoggedInUserInfo ------------------------
  Future<User> buildLoggedInUser(String userId) async {
    final response = await supabase
        .from('user_info')
        .select()
        .eq('user_id', userId)
        .single();

    final user = User(userId: userId);
    user.fullName = response['full_name'];
    user.isTrainer = response['trainer'];
    user.finishedRegistration = response['registration_finished'];

    user.hasTrainer = false;
    if (user.finishedRegistration == true) {
      print("build user with finished registration parameters");
      // Safely fetch trainer_to_client row matching this user
      final trainerRow = await supabase
        .from('trainer_to_client')
        .select()
        .eq('client_id', userId)
        .maybeSingle(); // <- returns null if no row matches

      // Only set hasTrainer to true if trainerRow exists and status is accepted
      if (trainerRow != null &&
        trainerRow['client_status'] == 'accepted_client') {
        user.hasTrainer = true;
      }
      print('user ${user.fullName} has trainer: ${user.hasTrainer}');

      user.userRoutineIds = await RoutineService().fetchRoutinesUser(userId);

      print('routine Ids ${user.userRoutineIds}');
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
  Future<Profile> buildProfile(String userId) async {
    final userProfile = Profile(userId: userId);

    // Fetch user info from Supabase
    final userInfoResponse = await supabase
        .from('user_info')
        .select()
        .eq('user_id', userId)
        .single();

    userProfile.username = userInfoResponse['username'] ?? 'unknown';
    userProfile.isTrainer = userInfoResponse['trainer'];
    userProfile.fullName = userInfoResponse['full_name'];
    userProfile.instagramUsername = userInfoResponse['instagram_username'];
    userProfile.description = userInfoResponse['description'];

    userProfile.profilePictureName = userInfoResponse['profile_picture_name'];

    // Build sports list
    userProfile.sportNames = await buildProfileSportList(userId);

    print("profile isTrainer: ${userProfile.isTrainer} equals true?");
    if (userProfile.isTrainer == true) {
      final trainerInfoResponse = await supabase
      .from('trainer_contact')
      .select()
      .eq('user_id', userId)
      .maybeSingle(); // returns null if no row exists

      if (trainerInfoResponse != null) {
        userProfile.workEmail = trainerInfoResponse['contact_email'];
        userProfile.workTelPrefix = int.tryParse(trainerInfoResponse['contact_tel_prefix']);
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

// ------------------------ Privacy ------------------------

  Future<Privacy> getUsersPrivacy(String userId) async {
    Privacy usersPrivacy = Privacy(userId: userId);

    final response = await supabase
        .from('privacy_settings')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (response != null) {
      usersPrivacy.public = response['public'] as bool?;

      usersPrivacy.friendsDashboard = response['friends_dashboard'] as bool?;
      usersPrivacy.friendsCalendar = response['friends_calendar'] as bool?;
      usersPrivacy.friendsPB = response['friends_objectives'] as bool?;
      usersPrivacy.friendsRoutines = response['friends_routines'] as bool?;
      usersPrivacy.friendsJournal = response['friends_journal'] as bool?;

      usersPrivacy.trainerDashboard = response['trainer_dashboard'] as bool?;
      usersPrivacy.trainerCalendar = response['trainer_calendar'] as bool?;
      usersPrivacy.trainerPB = response['trainer_objectives'] as bool?;
      usersPrivacy.trainerRoutines = response['trainer_routines'] as bool?;
      usersPrivacy.trainerJournal = response['trainer_journal'] as bool?;

      usersPrivacy.everyoneDashboard = response['default_users_dashboard'] as bool?;
      usersPrivacy.everyoneCalendar = response['default_users_calendar'] as bool?;
      usersPrivacy.everyonePB = response['default_users_objectives'] as bool?;
      usersPrivacy.everyoneRoutines = response['default_users_routines'] as bool?;
      usersPrivacy.everyoneJournal = response['default_users_journal'] as bool?;
    }

    return usersPrivacy;
  }

// ------------------------ SearchedRelationship ------------------------

  Future<SearchedRelationship> buildSearchedRelationship(
    String loggedInId,
    bool loggedInIsTrainer,
    String searchedId,
    bool searchedIsTrainer,
  ) async {
    final relationship = SearchedRelationship(
      loggedInId: loggedInId,
      loggedInIsTrainer: loggedInIsTrainer,
      searchedId: searchedId,
      searchedIsTrainer: searchedIsTrainer,
    );

    // 1. CHECK FOLLOW STATUS
    final followResult = await supabase
        .from('user_followers')
        .select('follow_status')
        .eq('follower_id', loggedInId)
        .eq('followed_id', searchedId)
        .maybeSingle();

    final followStatus = followResult?['follow_status'];

    if (followStatus == "accepted") {
      relationship.loggedInFollowsSearched = true;
    } else if (followStatus == "pending") {
      relationship.loggedInFollowRequestedSearched = true;
    }

    // 2. CHECK IF LOGGED-IN TRAINS SEARCHED
    final trainsResult = await supabase
        .from('trainer_to_client')
        .select('client_status')
        .eq('trainer_id', loggedInId)
        .eq('client_id', searchedId)
        .maybeSingle();

    final trainsStatus = trainsResult?['client_status'];

    if (trainsStatus == "accepted_client") {
      relationship.loggedInTrainsSearched = true;
    } else if (trainsStatus == "pending_client") {
      relationship.loggedInTrainingRequestedSearched = true;
    }

    // 3. CHECK IF LOGGED-IN TRAINS *UNDER* SEARCHED
    final trainsUnderResult = await supabase
        .from('trainer_to_client')
        .select('client_status')
        .eq('trainer_id', searchedId)
        .eq('client_id', loggedInId)
        .maybeSingle();

    final trainsUnderStatus = trainsUnderResult?['client_status'];

    if (trainsUnderStatus == "accepted_client") {
      relationship.loggedInTrainsUnderSearched = true;
    }

    return relationship;
  }

// ------------------------ Routines ------------------------

  Future<Routine> buildRoutine(String routineId) async {
    final routineRes = await supabase
      .from('routines')
      .select()
      .eq('routine_id', routineId)
      .single();

    // print("Fetched routine row: $routineRes");
    Routine routine = Routine(routineId: routineId);

    routine.name = routineRes['name'];
    routine.description = routineRes['description'];
    routine.duration = (routineRes['duration'] is int)
      ? (routineRes['duration'] as int).toDouble()
      : routineRes['duration'];
    routine.durationMetric = routineRes['duration_metric'];

    // Explicitly convert trainer_posted to bool
    routine.wasTrainerPosted = routineRes['trainer_posted'] == true;

    // Format date
    DateTime date = DateTime.parse(routineRes['inserted_at']);
    routine.lastEditDate =
      "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";

    // Fetch trainer info if trainer_posted
    if (routine.wasTrainerPosted! && routineRes['trainer_id'] != null) {
      routine.trainerId = routineRes['trainer_id'];
      final trainer = await supabase
        .from('user_info')
        .select('username, full_name')
        .eq('user_id', routine.trainerId!)
        .maybeSingle(); // Use maybeSingle to avoid errors if not found

      if (trainer != null) {
        routine.trainerUsername = trainer['username'];
        routine.trainerFullName = trainer['full_name'];
      }
    }

    // Fetch metric name safely
    if (routine.durationMetric != null) {
      final metric = await supabase
        .from('exercise_metrics')
        .select('metric_name')
        .eq('exercise_metric_id', routine.durationMetric!)
        .maybeSingle();

      if (metric != null) {
        routine.durationMetricName = metric['metric_name'];
      }
    }

  return routine;
}


}
