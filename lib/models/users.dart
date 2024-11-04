import 'package:cloud_firestore/cloud_firestore.dart';

import 'favorite_course.dart';

class User {
  final String id;
  String name;
  String username;
  final String email;
  String imageUrl;
  final DateTime createdAt;
  final List<FavoriteCourse> favorites;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.imageUrl,
    required this.createdAt,
    required this.favorites,
  });

  // Factory constructor to create a User from Firestore document
  factory User.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Extract 'favorites' list
    List<dynamic> favoritesList = data['favorites'] as List<dynamic>? ?? [];

    // Convert each entry in the list to a FavoriteCourse object
    List<FavoriteCourse> favoriteCourses = favoritesList.map((favoriteData) {
      Map<String, dynamic> favoriteMap = favoriteData as Map<String, dynamic>;
      return FavoriteCourse(
        authorId: favoriteMap['authorId'] ?? '',
        courseId: favoriteMap['courseId'] ?? '',
      );
    }).toList();

    return User(
      id: doc.id,
      name: data['name'] ?? '',
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      imageUrl: data['image_url'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      favorites: favoriteCourses,
    );
  }

  // Convert User object to Firestore-compatible map
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'username': username,
      'email': email,
      'image_url': imageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'favorites': favorites
          .map((fav) => {
                'authorId': fav.authorId,
                'courseId': fav.courseId,
              })
          .toList(),
    };
  }
}
