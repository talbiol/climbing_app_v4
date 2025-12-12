class Routine {
  final String routineId;

  String? name;
  String? lastEditDate; 
  String? description;
  double? duration;
  int? durationMetric;
  String? durationMetricName;

  bool? wasTrainerPosted;

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

    this.wasTrainerPosted,

    this.trainerId,
    this.trainerUsername,
    this.trainerFullName,
  });
}