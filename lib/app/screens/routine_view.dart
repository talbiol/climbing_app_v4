import 'package:flutter/material.dart';

import '../../models/routine.dart';
import '../../models/user.dart';
import '../../models/exercise.dart';
import '../services/routine_service.dart';
import 'routine_new_edit.dart';

class RoutineViewScreen extends StatefulWidget {
  final Routine routine;
  final bool edit;
  final User loggedInUser;
  final List<Exercise> exercises; // <-- Added this field

  const RoutineViewScreen({
    super.key,
    required this.routine,
    required this.edit,
    required this.loggedInUser,
    this.exercises = const [], // default empty list
  });

  @override
  State<RoutineViewScreen> createState() => _RoutineViewScreenState();
}

class _RoutineViewScreenState extends State<RoutineViewScreen> {
  late Future<List<Exercise>> _exercisesFuture;
  final RoutineService _routineService = RoutineService();
  late List<Exercise> _exercises; // store exercises here

  @override
  void initState() {
    super.initState();
    _exercises = widget.exercises; // initialize with widget.exercises
    _exercisesFuture =
        _routineService.getExercises(widget.routine.routineId!).then((value) {
      _exercises = value; // update state variable when future completes
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(widget.routine.name ?? 'Routine'),
        actions: [
          if (widget.routine.wasTrainerPosted == false ||
              (widget.routine.wasTrainerPosted == true &&
                  widget.loggedInUser.isTrainer == true))
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoutineNewEditScreen(
                      create: false,
                      loggedInUser: widget.loggedInUser,
                      routine: widget.routine,
                      exercises: _exercises, // <-- pass loaded exercises
                    ),
                  ),
                );
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Routine description
            if (widget.routine.description != null &&
                widget.routine.description!.isNotEmpty)
              Text(
                "Edit mode: ${widget.edit}\n\nDescription:\n${widget.routine.description ?? ''}",
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 24),

            /// Exercises title
            const Text(
              'Exercises',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            /// Exercises list
            Expanded(
              child: FutureBuilder<List<Exercise>>(
                future: _exercisesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Failed to load exercises'),
                    );
                  }

                  final exercises = snapshot.data ?? [];

                  if (exercises.isEmpty) {
                    return const Center(
                      child: Text('No exercises found'),
                    );
                  }

                  return ListView.builder(
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      final exercise = exercises[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exercise.name!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'ID: ${exercise.exerciseId}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Order: ${exercise.exerciseOrder}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
