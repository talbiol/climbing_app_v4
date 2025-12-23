import 'package:flutter/material.dart';

import '../../models/routine.dart';
import '../../models/user.dart';
import '../../models/exercise.dart';
import '../services/routine_service.dart';
import '../services/routine_metric_service.dart';
import '../../widgets/exercise_box_view.dart';
import 'routine_new_edit.dart';

class RoutineViewScreen extends StatefulWidget {
  final Routine routine;
  final bool edit;
  final User loggedInUser;
  final List<Exercise> exercises;

  const RoutineViewScreen({
    super.key,
    required this.routine,
    required this.edit,
    required this.loggedInUser,
    this.exercises = const [],
  });

  @override
  State<RoutineViewScreen> createState() => _RoutineViewScreenState();
}

class _RoutineViewScreenState extends State<RoutineViewScreen> {
  final RoutineService _routineService = RoutineService();
  final RoutineMetricService _metricService = RoutineMetricService();

  late Future<void> _loadFuture;

  List<Exercise> _exercises = [];
  List<Map<int, String>> routineMetrics = [];

  @override
  void initState() {
    super.initState();
    _loadFuture = _loadData();
  }

  Future<void> _loadData() async {
    // Load exercises
    _exercises = widget.exercises.isNotEmpty
        ? widget.exercises
        : await _routineService.getExercises(widget.routine.routineId!);

    // Load metrics
    routineMetrics = await _metricService.getAllRoutineMetrics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.routine.name ?? 'Routine'),
        actions: [
          if (widget.routine.wasTrainerPosted == false || (widget.routine.wasTrainerPosted == true && widget.loggedInUser.isTrainer!))
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final updated = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RoutineNewEditScreen(
                      create: false,
                      loggedInUser: widget.loggedInUser,
                      routine: widget.routine,
                      exercises: _exercises,
                    ),
                  ),
                );

                if (updated == true) {
                  setState(() {
                    _loadFuture = _loadData();
                  });
                }
              },
            ),
        ],
      ),
      body: FutureBuilder<void>(
        future: _loadFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Failed to load routine'));
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Duration + Trainer row
                Row(
                  children: [
                    if (widget.routine.duration != null)
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.timer),
                            const SizedBox(width: 8),
                            Text(
                              '${widget.routine.duration} ${widget.routine.durationMetricName}',
                            ),
                          ],
                        ),
                      ),
                    if (widget.routine.wasTrainerPosted == true)
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.group),
                            const SizedBox(width: 8),
                            Text(widget.routine.trainerFullName ?? ''),
                          ],
                        ),
                      ),
                  ],
                ),

                if (widget.routine.description?.isNotEmpty == true) ...[
                  const SizedBox(height: 24),
                  Text(widget.routine.description!),
                ],

                const SizedBox(height: 24),

                const Text(
                  'Exercises',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),

                Expanded(
                  child: _exercises.isEmpty
                      ? const Center(child: Text('No exercises found'))
                      : ListView.builder(
                          itemCount: _exercises.length,
                          itemBuilder: (context, index) {
                            return ExerciseBoxView(
                              exercise: _exercises[index],
                              routineMetrics: routineMetrics,
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
