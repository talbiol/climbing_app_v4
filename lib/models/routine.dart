class Routine {
  final String routineId;

  String? name;
  DateTime? lastEditDate; 
  String? description;
  double? duration;
  int? durationMetric;
  String? durationMetricName;

  bool? isTrainerPosted;

  String? trainerId;
  String? trainerUsername;
  String? trainerFullName;

  Routine({
    required this.routineId,

    this.name,
    this.lastEditDate,
    this.description,
    this.duration,
    this.durationMetric,
    this.durationMetricName,

    this.isTrainerPosted,

    this.trainerId,
    this.trainerUsername,
    this.trainerFullName,
  });
}