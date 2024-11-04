import 'package:cloud_firestore/cloud_firestore.dart';

class UserProgress {
  final String id; // Firestore document ID
  final String courseId;
  final String authorId;
  final double progress;

  UserProgress({
    required this.id,
    required this.courseId,
    required this.authorId,
    required this.progress,
  });

  factory UserProgress.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserProgress(
      id: doc.id,
      courseId: data['courseId'] ?? '',
      authorId: data['authorId'] ?? '',
      progress: (data['progress'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'courseId': courseId,
      'authorId': authorId,
      'progress': progress,
    };
  }
}