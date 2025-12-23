import 'package:supabase_flutter/supabase_flutter.dart';

class RoutineMetricService {
  final SupabaseClient supabase = Supabase.instance.client;

  /// Returns a list of maps: [{id: name}, ...]
  Future<List<Map<int, String>>> getAllRoutineMetrics() async {
    final response = await supabase
        .from('exercise_metrics')
        .select('exercise_metric_id, metric_name');

    final List<Map<int, String>> routineMetrics = [];

    for (final row in response) {
      final int id = row['exercise_metric_id'] as int;
      final String name = row['metric_name'] as String;

      routineMetrics.add({id: name});
    }

    return routineMetrics;
  }
}
