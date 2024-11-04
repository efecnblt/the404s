import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  final String id;
  final String title;
  final int duration;
  final int order;
  final String url;

  Video({
    required this.id,
    required this.title,
    required this.duration,
    required this.order,
    required this.url,
  });

  factory Video.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Video(
      id: doc.id,
      title: data['title'] ?? '',
      duration: data['duration'] ?? 0,
      order: data['order'] ?? 0,
      url: data['url'] ?? '',
    );
  }

  factory Video.fromMap(Map<String, dynamic> data) {
    return Video(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      duration: data['duration'] ?? 0,
      order: data['order'] ?? 0,
      url: data['url'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'duration': duration,
      'order': order,
      'url': url,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'duration': duration,
      'order': order,
      'url': url,
    };
  }
}