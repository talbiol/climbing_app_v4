import 'package:supabase_flutter/supabase_flutter.dart';

class InboxService {
  static final supabase = Supabase.instance.client;

  /// Pending follow requests *sent to* logged-in user.
  static Future<List<Map<String, dynamic>>> getFollowRequests(String userId) async {
    final res = await supabase
        .from('user_followers')
        .select('follow_id, follower_id')
        .eq('followed_id', userId)
        .eq('follow_status', 'pending');

    return List<Map<String, dynamic>>.from(res);
  }

  /// Pending training requests *sent to* logged-in user.
  static Future<List<Map<String, dynamic>>> getTrainingRequests(String userId) async {
    final res = await supabase
        .from('trainer_to_client')
        .select('trainer_to_client_id, trainer_id')
        .eq('client_id', userId)
        .eq('client_status', 'pending_client');

    return List<Map<String, dynamic>>.from(res);
  }

  static Future<void> acceptFollowRequest(String entryId) async {
    await supabase
        .from('user_followers')
        .update({'follow_status': 'accepted'})
        .eq('follow_id', entryId);
  }

  static Future<void> denyFollowRequest(String entryId) async {
    await supabase
        .from('user_followers')
        .delete()
        .eq('follow_id', entryId);
  }

  static Future<void> acceptTrainingRequest(String entryId) async {
    await supabase
        .from('trainer_to_client')
        .update({'client_status': 'accepted_client'})
        .eq('trainer_to_client_id', entryId);
  }

  static Future<void> denyTrainingRequest(String entryId) async {
    await supabase
        .from('trainer_to_client')
        .delete()
        .eq('trainer_to_client_id', entryId);
  }

  /// Accepted follow entries
  static Future<List<Map<String, dynamic>>> getFollowAccepted(String userId) async {
    final res = await supabase
        .from('user_followers')
        .select('follow_id, follower_id')
        .eq('followed_id', userId)
        .eq('follow_status', 'accepted');

    return List<Map<String, dynamic>>.from(res);
  }

  /// Accepted training entries
  static Future<List<Map<String, dynamic>>> getTrainingAccepted(String userId) async {
    final res = await supabase
        .from('trainer_to_client')
        .select('trainer_to_client_id, trainer_id')
        .eq('client_id', userId)
        .eq('client_status', 'accepted_client');

    return List<Map<String, dynamic>>.from(res);
  }
}
