import 'package:supabase_flutter/supabase_flutter.dart';

class RoutineService {
  final SupabaseClient supabase = Supabase.instance.client;

  /// Fetches:
  /// 1. Routines created by the user (trainer_posted = false)
  /// 2. Routines assigned to the user by a trainer (routine_to_client table)
  Future<List<String>> fetchRoutinesUser(String userId) async {
    // --- 1. Get routines created by the user ---
    final userMadeRes = await supabase
        .from('routines')
        .select('routine_id')
        .eq('user_id', userId)
        .eq('trainer_posted', false);

    final List<String> userMadeRoutineIds =
        userMadeRes.map<String>((row) => row['routine_id'] as String).toList();

    // --- 2. Get routines assigned to the user ---
    final assignedRes = await supabase
        .from('routine_to_client')
        .select('routine_id')
        .eq('client_id', userId);

    final List<String> trainerAssignedRoutineIds =
        assignedRes.map<String>((row) => row['routine_id'] as String).toList();

    // --- 3. Merge + dedupe ---
    final allIds = <String>{
      ...userMadeRoutineIds,
      ...trainerAssignedRoutineIds,
    }.toList();

    return allIds;
  }
}
