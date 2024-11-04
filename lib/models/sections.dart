import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber_security_app/models/video.dart';

class Section {
  final String id;
  final String title;
  final int order;
  List<Video> videos;

  Section({
    required this.id,
    required this.title,
    required this.order,
    required this.videos,
  });

  factory Section.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Section(
      id: doc.id,
      title: data['title'] ?? '',
      order: data['order'] ?? 0,
      videos: [], // Videoları daha sonra yükleyeceğiz
    );
  }

  factory Section.fromMap(Map<String, dynamic> data, {String id = ''}) {
    List<dynamic> videosData = data['videos'] ?? [];
    List<Video> videosList = videosData.map((videoData) => Video.fromMap(videoData)).toList();

    return Section(
      id: id,
      title: data['title'] ?? '',
      order: data['order'] ?? 0,
      videos: videosList,
    );
  }

  Map<String, dynamic> toFirestore() {
    return toMap()..remove('id');
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'order': order,
      'videos': videos.map((video) => video.toMap()).toList(),
    };
  }

  // Static method to load Section with its videos from Firestore
  static Future<Section> fromFirestoreWithVideos(String authorId, String courseId, DocumentSnapshot doc) async {
    Section section = Section.fromFirestore(doc);
    await section.loadVideos(authorId, courseId);
    return section;
  }

  // Loads videos for the section from Firestore
  Future<void> loadVideos(String authorId, String courseId) async {
    QuerySnapshot videoSnapshot = await FirebaseFirestore.instance
        .collection('authors')
        .doc(authorId)
        .collection('courses')
        .doc(courseId)
        .collection('sections')
        .doc(id)
        .collection('videos')
        .orderBy('order')
        .get();

    videos = videoSnapshot.docs.map((doc) => Video.fromFirestore(doc)).toList();
  }

  // Saves videos for the section to Firestore
  Future<void> saveVideos(String authorId, String courseId) async {
    CollectionReference videoRef = FirebaseFirestore.instance
        .collection('authors')
        .doc(authorId)
        .collection('courses')
        .doc(courseId)
        .collection('sections')
        .doc(id)
        .collection('videos');

    for (var video in videos) {
      await videoRef.doc(video.id).set(video.toFirestore());
    }
  }
}