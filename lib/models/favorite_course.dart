// favorite_course.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteCourse {
  final String courseId;
  final String authorId;

  FavoriteCourse({
    required this.courseId,
    required this.authorId,
  });

  // Factory constructor to create a FavoriteCourse from a map
  factory FavoriteCourse.fromMap(Map<String, dynamic> map) {
    return FavoriteCourse(
      courseId: map['courseId'] ?? '',
      authorId: map['authorId'] ?? '',
    );
  }

  // Convert FavoriteCourse object to a map
  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'authorId': authorId,
    };
  }
  factory FavoriteCourse.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return FavoriteCourse(
      courseId: data['courseId'] ?? '',
      authorId: data['authorId'] ?? '',
    );
  }
}
