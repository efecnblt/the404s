class FavoriteCourse {
  final int id;
  final int userId;
  final int courseId;

  FavoriteCourse({
    required this.id,
    required this.userId,
    required this.courseId,
  });

  factory FavoriteCourse.fromMap(Map<String, dynamic> map) {
    return FavoriteCourse(
      id: map['id'] ?? 0,
      userId: map['userId'] ?? 0,
      courseId: map['courseId'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'courseId': courseId,
    };
  }
}
