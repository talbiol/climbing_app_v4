import 'package:supabase_flutter/supabase_flutter.dart';

class RelationshipService {
  final SupabaseClient supabase = Supabase.instance.client;

  /// Check if the user has a public account
  Future<bool> getUserPublicSetting(String userId) async {
    final response = await supabase
        .from('privacy_settings')
        .select('public')
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) {
      return false; // default to private if not found
    }

    return response['public'] == true;
  }

  /// Send a follow request
  Future<String> sendFollowRequest(String loggedInId, String searchedId) async {
    bool searchedUserPublic = await getUserPublicSetting(searchedId);
    String buttonText;

    if (searchedUserPublic) {
      // Auto-accept follow
      final response = await supabase.from('user_followers').insert({
        'follower_id': loggedInId,
        'followed_id': searchedId,
        'follow_status': 'accepted',
      });
      print(response);
      buttonText = 'Following';
    } else {
      // Request pending
      final response = await supabase.from('user_followers').insert({
        'follower_id': loggedInId,
        'followed_id': searchedId,
        'follow_status': 'pending',
        'inserted_at': DateTime.now().toUtc().toIso8601String(),
      });
      print(response);
      buttonText = 'Requested';
    }
    
    return buttonText;
  }

  /// Send a training request
  Future<String> sendTrainingRequest(String loggedInId, String searchedId) async {
    await supabase.from('trainer_to_client').insert({
      'trainer_id': loggedInId,
      'client_id': searchedId,
      'client_status': 'pending_client',
      'inserted_at': DateTime.now().toUtc().toIso8601String(),
    });

    return 'Client Requested';
  }

  /// Remove following
  Future<String> removeFollowing(String loggedInId, String searchedId) async {
    await supabase.from('user_followers').delete().eq('follower_id', loggedInId).eq('followed_id', searchedId);
    return 'Follow';
  }

  /// Remove client relationship
  Future<String> removeClient(String loggedInId, String searchedId) async {
    await supabase.from('trainer_to_client').delete().eq('trainer_id', loggedInId).eq('client_id', searchedId);
    return 'Add Client';
  }

  /// Remove trainer relationship
  Future<String> removeTrainer(String loggedInId, String searchedId) async {
    await supabase.from('trainer_to_client').delete().eq('trainer_id', searchedId).eq('client_id', loggedInId);
    return 'No Button';
  }
}
