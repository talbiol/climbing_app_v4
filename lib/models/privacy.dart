class Privacy {
  // Constructor
  Privacy({required this.userId});

  // Required property
  final String userId;

  bool? public;

  bool? friendsDashboard;
  bool? friendsCalendar;
  bool? friendsPB;
  bool? friendsRoutines;
  bool? friendsJournal;
  
  bool? trainerDashboard;
  bool? trainerCalendar;
  bool? trainerPB;
  bool? trainerRoutines;
  bool? trainerJournal;

  bool? everyoneDashboard;
  bool? everyoneCalendar;
  bool? everyonePB;
  bool? everyoneRoutines;
  bool? everyoneJournal;
}