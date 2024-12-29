class UserModel {
  final String name;
  final String surname;
  final String username;
  final String bio;
  final String email;
  final String imageUrl;
  final String occupation;
  final DateTime? createdAt;
  final String userId;

  UserModel({
    required this.name,
    required this.surname,
    required this.username,
    required this.bio,
    required this.email,
    required this.imageUrl,
    required this.occupation,
    this.createdAt,
    required this.userId,
  });
}
