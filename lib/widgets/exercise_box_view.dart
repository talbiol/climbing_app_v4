import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../style.dart';

class ExerciseBoxView extends StatelessWidget {
  final Exercise exercise;
  final List<Map<int, String>> routineMetrics;

  const ExerciseBoxView({
    super.key,
    required this.exercise,
    required this.routineMetrics,
  });

  String metricName(int? metricId) {
    if (metricId == null) return '';

    for (final map in routineMetrics) {
      if (map.containsKey(metricId)) {
        return map[metricId]!;
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (exercise.name?.isNotEmpty == true)
              Text(
                '${exercise.exerciseOrder}. ${exercise.name!}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

            if (exercise.nReps != null && exercise.nSets != null)
              Text(
                '${exercise.nReps} ${metricName(exercise.metricReps)} '
                'x ${exercise.nSets} sets',
              ),

            if (exercise.nReps != null && exercise.nSets == null)
              Text(
                '${exercise.nReps} ${metricName(exercise.metricReps)}',
              ),

            if (exercise.nReps == null && exercise.nSets != null)
              Text('${exercise.nSets} sets'),

            if (exercise.nWeight != null)
              Text(
                '${exercise.nWeight} '
                '${metricName(exercise.metricWeight)} '
                'working weight',
              ),

            if (exercise.nRestBetweenSets != null)
              Text(
                '${exercise.nRestBetweenSets} '
                '${metricName(exercise.metricRestBetweenSets)} '
                'rest between sets',
              ),

            if (exercise.nRestPostExercise != null)
              Text(
                '${exercise.nRestPostExercise} '
                '${metricName(exercise.metricRestPostExercise)} '
                'rest post exercise',
              ),

            if (exercise.description?.isNotEmpty == true) ...[
              const SizedBox(height: 8),
              Text(exercise.description!),
            ],
          ],
        ),
      ),
    );
  }
}

