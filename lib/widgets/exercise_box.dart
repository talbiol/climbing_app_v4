import 'package:flutter/material.dart';
import '../models/exercise.dart';
import 'custom_input_box.dart';
import 'metric_dropdown.dart';

class ExerciseBox extends StatefulWidget {
  final bool create;
  final List<Map<int, String>> routineMetrics;
  final Exercise exercise; // always non-null
  final VoidCallback? onDelete;

  const ExerciseBox({
    super.key,
    required this.create,
    required this.routineMetrics,
    required this.exercise,
    this.onDelete,
  });

  @override
  State<ExerciseBox> createState() => _ExerciseBoxState();
}

class _ExerciseBoxState extends State<ExerciseBox> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _repsController;
  late TextEditingController _setsController;
  late TextEditingController _weightController;
  late TextEditingController _restBetweenController;
  late TextEditingController _restPostController;

  @override
  void initState() {
    super.initState();
    final ex = widget.exercise;

    _nameController = TextEditingController(text: ex.name);
    _descriptionController = TextEditingController(text: ex.description);
    _repsController = TextEditingController(text: ex.nReps?.toString() ?? '');
    _setsController = TextEditingController(text: ex.nSets?.toString() ?? '');
    _weightController = TextEditingController(text: ex.nWeight?.toString() ?? '');
    _restBetweenController = TextEditingController(text: ex.nRestBetweenSets?.toString() ?? '');
    _restPostController = TextEditingController(text: ex.nRestPostExercise?.toString() ?? '');
  }

  void _updateExercise() {
    final ex = widget.exercise;
    ex.name = _nameController.text;
    ex.description = _descriptionController.text;
    ex.nReps = int.tryParse(_repsController.text);
    ex.nSets = int.tryParse(_setsController.text);
    ex.nWeight = int.tryParse(_weightController.text);
    ex.nRestBetweenSets = int.tryParse(_restBetweenController.text);
    ex.nRestPostExercise = int.tryParse(_restPostController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomInputBox(
                  controller: _nameController,
                  placeholder: 'Exercise Name',
                  onChanged: (_) => _updateExercise(),
                ),
                const SizedBox(height: 12),
                _buildRow(
                  firstController: _repsController,
                  firstMetric: widget.exercise.metricReps,
                  metricOptions: const [1,2,3,4],
                  label: 'x',
                  secondController: _setsController,
                  secondLabel: 'sets',
                  onFirstMetricChanged: (value) {
                    setState(() => widget.exercise.metricReps = value!);
                  },
                ),
                const SizedBox(height: 12),
                _buildRow(
                  firstController: _weightController,
                  firstMetric: widget.exercise.metricWeight,
                  metricOptions: const [5,6,7],
                  secondLabel: 'working weight',
                  onFirstMetricChanged: (value) {
                    setState(() => widget.exercise.metricWeight = value!);
                  },
                ),
                const SizedBox(height: 12),
                _buildRow(
                  firstController: _restBetweenController,
                  firstMetric: widget.exercise.metricRestBetweenSets,
                  metricOptions: const [2,3],
                  secondLabel: 'rest between sets',
                  onFirstMetricChanged: (value) {
                    setState(() => widget.exercise.metricRestBetweenSets = value!);
                  },
                ),
                const SizedBox(height: 12),
                _buildRow(
                  firstController: _restPostController,
                  firstMetric: widget.exercise.metricRestPostExercise,
                  metricOptions: const [2,3],
                  secondLabel: 'rest post exercise',
                  onFirstMetricChanged: (value) {
                    setState(() => widget.exercise.metricRestPostExercise = value!);
                  },
                ),
                const SizedBox(height: 12),
                CustomInputBox(
                  controller: _descriptionController,
                  placeholder: 'Description',
                  maxLines: 3,
                  onChanged: (_) => _updateExercise(),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -10,
          left: -15,
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: widget.onDelete,
          ),
        ),
      ],
    );
  }

  Widget _buildRow({
    required TextEditingController firstController,
    required int? firstMetric,
    required List<int> metricOptions,
    required ValueChanged<int?> onFirstMetricChanged,
    String? label,
    TextEditingController? secondController,
    String? secondLabel,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: CustomInputBox(controller: firstController, onChanged: (_) => _updateExercise()),
        ),
        if (metricOptions.isNotEmpty) ...[
          const SizedBox(width: 8),
          Expanded(
            flex: 1,
            child: RoutineMetricDropdown(
              metricIdsOptions: metricOptions,
              selectedMetric: firstMetric,
              routineMetrics: widget.routineMetrics,
              onChanged: onFirstMetricChanged,
            ),
          ),
        ],
        if (label != null) ...[const SizedBox(width: 8), Flexible(child: Text(label))],
        if (secondController != null) ...[
          const SizedBox(width: 8),
          Expanded(flex: 1, child: CustomInputBox(controller: secondController, onChanged: (_) => _updateExercise())),
        ],
        if (secondLabel != null) ...[const SizedBox(width: 8), Flexible(child: Text(secondLabel))],
      ],
    );
  }
}

