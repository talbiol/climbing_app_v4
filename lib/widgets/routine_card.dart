import 'package:climbing_app_v4/style.dart';
import 'package:flutter/material.dart';

import '../app/screens/routine_view.dart';
import '../models/routine.dart';
import '../models/user.dart';

class RoutineCard extends StatelessWidget {
  final Routine routine;
  final User loggedInUser;

  const RoutineCard({super.key, required this.routine, required this.loggedInUser});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: Spacing.small, horizontal: Spacing.medium),
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: AppColors.mainText,
          width: BorderThickness.small,
        ),
        borderRadius: BorderRadius.circular(CustomBorderRadius.somewhatRound),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(Spacing.small),
        onTap: () {
          final allowEdit = !(routine.wasTrainerPosted!);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RoutineViewScreen(
                routine: routine,
                edit: allowEdit,
                loggedInUser: loggedInUser,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(Spacing.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// --- Top Row (name + lastEditDate)
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      routine.name ?? "Unnamed routine",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.mainText
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(routine.lastEditDate!,
                      textAlign: TextAlign.end,
                      style: const TextStyle(color: AppColors.mainText),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: Spacing.small),

              /// --- Description
              if (routine.description != null)
                Text(
                  routine.description!,
                  style: const TextStyle(color: AppColors.mainText),
                ),

              const SizedBox(height: Spacing.medium),

              /// --- Bottom Row (duration + trainer)
              Row(
                children: [
                  /// Left side: duration info
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        const Icon(Icons.timer, size: 18, color: AppColors.mainText),
                        const SizedBox(width: Spacing.small),
                        Text("${routine.duration ?? 0}", style: TextStyle(color: AppColors.mainText)),
                        const SizedBox(width: Spacing.small),
                        Text(routine.durationMetricName ?? "", style: TextStyle(color: AppColors.mainText)),
                      ],
                    ),
                  ),

                  /// Right side: trainer username if trainer posted
                  if (routine.wasTrainerPosted == true)
                    Expanded(
                      flex: 1,
                      child: Text(
                        routine.trainerUsername ?? "",
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.mainText
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
