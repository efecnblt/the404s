class UserModel {
  final int id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? firebaseUID;
  final bool? isVerified;
  final String? imageUrl;
  final String? username;

  UserModel({
    required this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.firebaseUID,
    this.isVerified,
    this.imageUrl,
    this.username,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['userId'] ?? 0,
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      firebaseUID: map['firebaseUID'],
      isVerified: map['isVerified'] ?? false,
      imageUrl: map['imageUrl'],
      username: map['username'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'firebaseUID': firebaseUID,
      'isVerified': isVerified,
      'imageUrl': imageUrl,
      'username': username,
    };
  }
}
