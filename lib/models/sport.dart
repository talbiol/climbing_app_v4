// lib/models/sport.dart

class Sport {
  final String sportId;

  String? sportToUserId;

  String? name;
  String? description;

  bool currentlyAssignedToUser;

  Sport({
    required this.sportId,
    this.sportToUserId,
    this.name,
    this.description,
    this.currentlyAssignedToUser = false,
  });
}
