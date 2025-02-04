class CourseProgress {
  final int id;
  final int userId;
  final int courseId;
  final double progress;

  CourseProgress({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.progress,
  });

  factory CourseProgress.fromMap(Map<String, dynamic> map) {
    return CourseProgress(
      id: map['id'] ?? 0,
      userId: map['userId'] ?? 0,
      courseId: map['courseId'] ?? 0,
      progress: (map['progress'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'courseId': courseId,
      'progress': progress,
    };
  }
}
