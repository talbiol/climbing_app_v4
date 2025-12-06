// lib/models/logged_in_user.dart

abstract class LoggedInUserInfo {
  final String userId;

  bool? finishedRegistration;
  bool? isTrainer;
  bool? hasTrainer;
  bool? isPremium;
  bool? questionnaireNotifications;

  List<String>? userCategoryIds;
  List<String>? userSportIds;
  List<String>? userRoutineIds;

  String? fullName;

  LoggedInUserInfo({required this.userId});
}
