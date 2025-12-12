import 'package:flutter/material.dart';

import '../../models/routine.dart';
import '../../models/user.dart';
import 'routine_new_edit.dart';

class RoutineViewScreen extends StatelessWidget {
  final Routine routine;
  final bool edit;
  final User loggedInUser;

  const RoutineViewScreen({
    super.key,
    required this.routine,
    required this.edit,
    required this.loggedInUser,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(routine.name ?? "Routine"),
        actions: [
          if (routine.wasTrainerPosted == false)
          IconButton(onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RoutineNewEditScreen(create: false, loggedInUser: loggedInUser, routine: routine,),
                ),
              );
            },
            icon: Icon(Icons.edit))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "Edit mode: $edit\n\nRoutine info:\n${routine.description ?? ''}",
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
