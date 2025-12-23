import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/exercise.dart';
import '../../models/routine.dart';

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

    // temporary
    // --- 3. Get routines created as trainer ---
    final trainerCreated = await supabase
        .from('routines')
        .select('routine_id')
        .eq('trainer_id', userId)
        .eq('trainer_posted', true);

    final List<String> trainerCreatedRoutineIds =
        trainerCreated.map<String>((row) => row['routine_id'] as String).toList();

    // --- 4. Merge + dedupe ---
    final allIds = <String>{
      ...userMadeRoutineIds,
      ...trainerAssignedRoutineIds,
      ...trainerCreatedRoutineIds,
    }.toList();

    return allIds;
  }

  Future<List<Exercise>> getExercises(String routineId) async {
    final response = await supabase
        .from('exercises')
        .select()
        .eq('routine_id', routineId)
        .order('exercise_order', ascending: true);

    final List<Exercise> exercises = [];

    for (final row in response) {
      exercises.add(
        Exercise(
          exerciseId: row['exercise_id'],
          exerciseOrder: row['exercise_order'],
          name: row['name'],
          nReps: row['n_reps'],
          metricReps: row['metric_reps'],
          nSets: row['n_sets'],
          nWeight: row['n_weight'],
          metricWeight: row['metric_weight'],
          nRestBetweenSets: row['n_rest_between_sets'],
          metricRestBetweenSets: row['metric_rest_between_sets'],
          nRestPostExercise: row['n_rest_post_exercise'],
          metricRestPostExercise: row['metric_rest_post_exercise'],
          description: row['description'],
        ),
      );
    }

    return exercises;
  }

  /// Create a new routine and return its ID
  Future<String> createRoutine(Routine routine, String userId) async {
    final Map<String, dynamic> data = {
      'name': routine.name,
      'description': routine.description,
      'duration': routine.duration,
      'duration_metric': routine.durationMetric,
      'trainer_posted': routine.wasTrainerPosted,
      'share': routine.share ?? true,
    };

    // Conditional fields
    if (routine.wasTrainerPosted == false) {
      data['user_id'] = userId; // user who creates it
    } else {
      data['trainer_id'] = userId; // trainer assigns it
    }

    final response = await supabase
      .from('routines')
      .insert(data)
      .select()
      .single();

    return response['routine_id'] as String;
  }

  /// Update an existing routine
  Future<void> updateRoutine(Routine routine) async {
    if (routine.routineId == null) return;

    await supabase.from('routines').update({
      'name': routine.name,
      'description': routine.description,
      'duration': routine.duration,
      'duration_metric': routine.durationMetric,
      'trainer_posted': routine.wasTrainerPosted,
      'share': routine.share,
    }).eq('routine_id', routine.routineId!);
  }

  /// Create a new exercise linked to a routine
  Future<void> createExercise(String routineId, Exercise exercise) async {
    await supabase.from('exercises').insert({
      'routine_id': routineId,
      'exercise_order': exercise.exerciseOrder,
      'name': exercise.name,
      'n_reps': exercise.nReps,
      'metric_reps': exercise.metricReps,
      'n_sets': exercise.nSets,
      'n_weight': exercise.nWeight,
      'metric_weight': exercise.metricWeight,
      'n_rest_between_sets': exercise.nRestBetweenSets,
      'metric_rest_between_sets': exercise.metricRestBetweenSets,
      'n_rest_post_exercise': exercise.nRestPostExercise,
      'metric_rest_post_exercise': exercise.metricRestPostExercise,
      'description': exercise.description,
    });
  }

  /// Update an existing exercise
  Future<void> updateExercise(Exercise exercise) async {
    if (exercise.exerciseId == null) return;

    await supabase.from('exercises').update({
      'exercise_order': exercise.exerciseOrder,
      'name': exercise.name,
      'n_reps': exercise.nReps,
      'metric_reps': exercise.metricReps,
      'n_sets': exercise.nSets,
      'n_weight': exercise.nWeight,
      'metric_weight': exercise.metricWeight,
      'n_rest_between_sets': exercise.nRestBetweenSets,
      'metric_rest_between_sets': exercise.metricRestBetweenSets,
      'n_rest_post_exercise': exercise.nRestPostExercise,
      'metric_rest_post_exercise': exercise.metricRestPostExercise,
      'description': exercise.description,
    }).eq('exercise_id', exercise.exerciseId!);
  }


  Future<void> deleteExercise(String exerciseId) async {
    await supabase
      .from('exercises')
      .delete()
      .eq('exercise_id', exerciseId);
  }
}
