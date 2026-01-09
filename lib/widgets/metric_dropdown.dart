import 'package:flutter/material.dart';

import '../style.dart';

class RoutineMetricDropdown extends StatelessWidget {
  final List<int> metricIdsOptions;
  final int? selectedMetric;
  final List<Map<int, String>> routineMetrics;
  final ValueChanged<int?> onChanged;
  final bool asSmallAsPossible; // ✅ New parameter

  const RoutineMetricDropdown({
    super.key,
    required this.metricIdsOptions,
    required this.routineMetrics,
    required this.onChanged,
    this.selectedMetric,
    this.asSmallAsPossible = false, // default false
  });

  @override
  Widget build(BuildContext context) {
    final filteredMetrics = routineMetrics.where((metricMap) {
      final int id = metricMap.keys.first;
      return metricIdsOptions.contains(id);
    }).toList();

    if (filteredMetrics.isEmpty) {
      return const Text('No metrics available');
    }

    final int effectiveSelectedMetric =
        selectedMetric != null &&
                filteredMetrics.any((m) => m.keys.first == selectedMetric)
            ? selectedMetric!
            : filteredMetrics.first.keys.first;

    return LayoutBuilder(
  builder: (context, constraints) {
    return DropdownButtonFormField<int>(
      isExpanded: true,
      value: effectiveSelectedMetric,

      dropdownColor: AppColors.mainBackground, // dropdown menu background
      iconEnabledColor: AppColors.mainText, // dropdown arrow

      style: const TextStyle(
        color: AppColors.mainText, // selected value text
      ),

      decoration: const InputDecoration(
        labelText: 'Metric',
        labelStyle: TextStyle(color: AppColors.mainText),

        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.mainText),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.mainText),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.mainText, width: 2),
        ),

        contentPadding: EdgeInsets.symmetric(
          horizontal: Spacing.small,
          vertical: 12,
        ),
      ),

      items: filteredMetrics.map((metricMap) {
        final int id = metricMap.keys.first;
        final String name = metricMap.values.first;

        return DropdownMenuItem<int>(
          value: id,
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.mainText),
          ),
        );
      }).toList(),

      onChanged: onChanged,
    );
  },
);
  }
}
