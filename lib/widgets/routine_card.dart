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
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
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
          padding: const EdgeInsets.all(12.0),
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
                        fontSize: 16,
                        color: AppColors.mainText
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(routine.lastEditDate!,
                      textAlign: TextAlign.end,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              /// --- Description
              if (routine.description != null)
                Text(
                  routine.description!,
                  style: const TextStyle(fontSize: 14, color: AppColors.mainText),
                ),

              const SizedBox(height: 10),

              /// --- Bottom Row (duration + trainer)
              Row(
                children: [
                  /// Left side: duration info
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        const Icon(Icons.timer, size: 18, color: AppColors.mainText),
                        const SizedBox(width: 4),
                        Text("${routine.duration ?? 0}", style: TextStyle(color: AppColors.mainText)),
                        const SizedBox(width: 4),
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
