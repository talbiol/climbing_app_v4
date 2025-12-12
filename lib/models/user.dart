// lib/models/user.dart

class User {
  final String userId;

  bool? finishedRegistration;
  bool? isTrainer;
  bool? hasTrainer;
  bool? isPremium;
  bool? questionnaireNotifications;

  List<String>? userCategoryIds;
  List<String>? userRoutineIds;

  String? fullName;

  User({required this.userId});
}
