import 'package:flutter/material.dart';

import '../../models/routine.dart';

class RoutineViewScreen extends StatelessWidget {
  final Routine routine;
  final bool edit;

  const RoutineViewScreen({
    super.key,
    required this.routine,
    required this.edit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(routine.name ?? "Routine"),
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
