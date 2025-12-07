class Profile {
  // Constructor
  Profile({required this.userId});

  // Required property
  final String userId;

  // Optional properties with defaults
  String? username;
  String? profilePictureName;
  String? fullName;
  String? instagramUsername;
  String? description;
  List<String>? sportNames;
}
