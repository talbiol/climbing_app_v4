import 'package:climbing_app_v4/style.dart';
import 'package:flutter/material.dart';

import '../../models/exercise.dart';
import '../../models/routine.dart';
import '../../models/user.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_input_box.dart';
import '../../widgets/custom_toggle_switch.dart';
import '../../widgets/exercise_box_edit.dart';
import '../../widgets/metric_dropdown.dart';
import '../services/routine_metric_service.dart';
import '../services/routine_service.dart';

class RoutineNewEditScreen extends StatefulWidget {
  final Routine? routine;
  final User? loggedInUser;
  final bool create;
  List<Exercise>? exercises;

  RoutineNewEditScreen({
    super.key,
    this.routine,
    required this.loggedInUser,
    required this.create,
    this.exercises,
  });

  @override
  State<RoutineNewEditScreen> createState() => _RoutineNewEditScreenState();
}

class _RoutineNewEditScreenState extends State<RoutineNewEditScreen> {
  late bool forClient;
  late bool share;

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _durationController;

  final RoutineMetricService _metricService = RoutineMetricService();
  List<Map<int, String>> routineMetrics = [];
  bool isLoadingMetrics = true;

  final List<Exercise> _deletedExercises = [];

  @override
  void initState() {
    super.initState();

    forClient = widget.create
        ? true
        : widget.routine?.wasTrainerPosted ?? false;

    share = widget.create
        ? true
        : widget.routine?.share ?? false;

    _nameController =
        TextEditingController(text: widget.create ? '' : widget.routine?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.create ? '' : widget.routine?.description ?? '');
    _durationController =
        TextEditingController(text: widget.create ? '' : widget.routine?.duration?.toString() ?? '');

    // Initialize exercises list if null
    widget.exercises ??= [];
    if (widget.create || widget.exercises!.isEmpty) _addEmptyExercise();

    _loadRoutineMetrics();
  }

  Future<void> _loadRoutineMetrics() async {
    final metrics = await _metricService.getAllRoutineMetrics();

    setState(() {
      routineMetrics = metrics;
      isLoadingMetrics = false;
    });
  }

  void _removeExercise(int index) {
    setState(() {
      final removed = widget.exercises!.removeAt(index);
      if (removed.exerciseId != null) _deletedExercises.add(removed);
    });
  }

  void _addEmptyExercise() {
    setState(() {
      final ex = Exercise(
        exerciseOrder: (widget.exercises!.length) + 1,
        name: '',
        metricReps: 1,
        metricWeight: 5,
        metricRestBetweenSets: 2,
        metricRestPostExercise: 2,
      );
      widget.exercises!.add(ex);
    });
  }

  Future<void> _saveRoutine() async {
    final routineService = RoutineService();

    final routine = Routine(
      routineId: widget.create ? null : widget.routine!.routineId,
      name: _nameController.text,
      description: _descriptionController.text,
      duration: double.tryParse(_durationController.text),
      durationMetric: widget.routine?.durationMetric ?? 2,
      share: share,
      wasTrainerPosted: forClient,
      trainerId: widget.loggedInUser?.isTrainer == true ? widget.loggedInUser?.userId : null,
    );

    String routineId;
    if (widget.create) {
      routineId = await routineService.createRoutine(routine, widget.loggedInUser!.userId);
    } else {
      routineId = routine.routineId!;
      await routineService.updateRoutine(routine);
    }

    // Create or update exercises
    for (var ex in widget.exercises!) {
      if (ex.exerciseId != null) {
        await routineService.updateExercise(ex);
      } else {
        await routineService.createExercise(routineId, ex);
      }
    }

    // Delete exercises marked for deletion
    for (var ex in _deletedExercises) {
      await routineService.deleteExercise(ex.exerciseId!);
    }
    _deletedExercises.clear();

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final routine = widget.routine;
    final isTrainer = widget.loggedInUser?.isTrainer == true;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(widget.create ? 'Create Routine' : 'Edit Routine'),
      ),
      body: isLoadingMetrics
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                CustomInputBox(
                  controller: _nameController,
                  placeholder: 'Routine Name',
                ),

                if (isTrainer)
                  CustomToggleSwitch(
                    alwaysSameText: false,
                    textWhenTrue: 'For client',
                    textWhenFalse: 'Personal use',
                    initState: forClient,
                    onChanged: (value) => setState(() => forClient = value),
                  ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          const Icon(Icons.timer),
                          const SizedBox(width: 8),
                          Expanded(
                            child: CustomInputBox(
                              controller: _durationController,
                              placeholder: 'Duration',
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 100,
                            child: RoutineMetricDropdown(
                              metricIdsOptions: const [2, 3, 4],
                              selectedMetric: routine?.durationMetric,
                              routineMetrics: routineMetrics,
                              onChanged: (value) => setState(() {
                                routine?.durationMetric = value;
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          if ((isTrainer && !forClient) || !isTrainer)
                            Expanded(
                              child: CustomToggleSwitch(
                                alwaysSameText: true,
                                text: 'Share',
                                initState: share,
                                onChanged: (value) => setState(() => share = value),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                CustomInputBox(
                  controller: _descriptionController,
                  placeholder: 'Description',
                ),

                const SizedBox(height: 12),

                const Text(
                  'Exercises',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Existing and new exercises
                ...List.generate(widget.exercises!.length, (index) {
                  final exercise = widget.exercises![index];
                  return ExerciseBoxEdit(
                    key: ValueKey(exercise.exerciseId ?? 'new_$index'),
                    create: widget.create,
                    routineMetrics: routineMetrics,
                    exercise: exercise,
                    onDelete: () => _removeExercise(index),
                  );
                }),

                const SizedBox(height: 8),
                CustomButton(
                  text: 'Add Exercise',
                  topPadding: Spacing.medium,
                  onClick: _addEmptyExercise,
                ),
              ],
            ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.mainBackground,
        child: CustomButton(
          text: 'Save',
          onClick: _saveRoutine,
        ),
      ),
    );
  }
}
