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
      margin: const EdgeInsets.symmetric(vertical: Spacing.small),
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: AppColors.mainText,
          width: BorderThickness.small,
        ),
        borderRadius: BorderRadius.circular(CustomBorderRadius.somewhatRound),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (exercise.name?.isNotEmpty == true)
              Text(
                '${exercise.exerciseOrder}. ${exercise.name!}',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.mainText),
              ),

            if (exercise.nReps != null && exercise.nSets != null)
              Text(
                '${exercise.nReps} ${metricName(exercise.metricReps)} x ${exercise.nSets} sets',
                style: TextStyle(color: AppColors.mainText)
              ),

            if (exercise.nReps != null && exercise.nSets == null)
              Text(
                '${exercise.nReps} ${metricName(exercise.metricReps)}',
                style: TextStyle(color: AppColors.mainText)
              ),

            if (exercise.nReps == null && exercise.nSets != null)
              Text('${exercise.nSets} sets', style: TextStyle(color: AppColors.mainText)),
              

            if (exercise.nWeight != null)
              Text(
                '${exercise.nWeight} '
                '${metricName(exercise.metricWeight)} '
                'working weight',
                style: TextStyle(color: AppColors.mainText)
              ),

            if (exercise.nRestBetweenSets != null)
              Text(
                '${exercise.nRestBetweenSets} '
                '${metricName(exercise.metricRestBetweenSets)} '
                'rest between sets',
                style: TextStyle(color: AppColors.mainText)
              ),

            if (exercise.nRestPostExercise != null)
              Text(
                '${exercise.nRestPostExercise} '
                '${metricName(exercise.metricRestPostExercise)} '
                'rest post exercise',
                style: TextStyle(color: AppColors.mainText)
              ),

            if (exercise.description?.isNotEmpty == true) ...[
              const SizedBox(height: Spacing.small),
              Text(exercise.description!, style: TextStyle(color: AppColors.mainText)),
              
            ],
          ],
        ),
      ),
    );
  }
}

