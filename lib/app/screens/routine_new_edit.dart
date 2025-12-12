import 'package:flutter/material.dart';
import '../../models/routine.dart';
import '../../models/user.dart';

class RoutineNewEditScreen extends StatelessWidget {
  final Routine? routine;
  final User? loggedInUser;
  final bool create;

  const RoutineNewEditScreen({
    super.key,
    required this.create,
    this.routine,
    this.loggedInUser,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(create ? "Create Routine" : "Edit Routine"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            "Is trainer: ${loggedInUser?.isTrainer}",
          ),
          const SizedBox(height: 12),
          Text(
            routine != null ? routine!.name! : "Create routine",
          ),
        ],
      ),
    );
  }
}
