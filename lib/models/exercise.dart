class Exercise {
  String? exerciseId;
  int? exerciseOrder;
  String? name;

  int? nReps;
  int metricReps;

  int? nSets;

  int? nWeight;
  int metricWeight;

  int? nRestBetweenSets;
  int metricRestBetweenSets;

  int? nRestPostExercise;
  int metricRestPostExercise;

  String? description;

  Exercise({
    this.exerciseId,
    required this.exerciseOrder,
    required this.name,
    this.nReps,
    required this.metricReps,
    this.nSets,
    this.nWeight,
    required this.metricWeight,
    this.nRestBetweenSets,
    required this.metricRestBetweenSets,
    this.nRestPostExercise,
    required this.metricRestPostExercise,
    this.description,
  });
}
