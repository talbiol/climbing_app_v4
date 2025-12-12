import 'package:climbing_app_v4/models/build_model.dart';
import 'package:flutter/material.dart';

import '../../models/routine.dart';
import '../../models/user.dart';
import '../../style.dart';
import '../../widgets/routine_card.dart';


class RoutinesScreen extends StatelessWidget {
  final User loggedInUser;

  const RoutinesScreen(this.loggedInUser, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routineIds = loggedInUser.userRoutineIds ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Routines'),
      ),
      body: routineIds.isEmpty
          ? Center(
              child: Text(
                "No routines yet.",
                style: TextStyle(color: AppColors.mainText),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: routineIds.length,
              itemBuilder: (context, index) {
                final routineId = routineIds[index];

                return FutureBuilder<Routine>(
                  future: BuildModel().buildRoutine(routineId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final routine = snapshot.data!;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: RoutineCard(routine: routine),
                    );
                  },
                );
              },
            ),
    );
  }
}


