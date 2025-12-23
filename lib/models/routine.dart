class Routine {
  final String? routineId;

  String? name;
  String? lastEditDate; 
  String? description;
  double? duration;
  int? durationMetric;
  String? durationMetricName;

  bool? wasTrainerPosted;
  bool? share;

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
    this.share,

    this.trainerId,
    this.trainerUsername,
    this.trainerFullName,
  });
}