import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber_security_app/models/sections.dart';

class Course {
  final String id;
  final String name;
  final String description;
  final String level;
  final String department;
  List<String> hashtags;
  final double rating;
  final int ratingCount;
  List<dynamic> sections;

  Course({
    required this.id,
    required this.name,
    required this.description,
    required this.level,
    required this.rating,
    required this.sections,
    required this.ratingCount,
    required this.department,
    required this.hashtags
  });

  Future<void> loadSections(String authorId) async {
    QuerySnapshot sectionSnapshot = await FirebaseFirestore.instance
        .collection('authors')
        .doc(authorId)
        .collection('courses')
        .doc(id)
        .collection('sections')
        .orderBy('order')
        .get();

    sections = sectionSnapshot.docs.map((doc) => Section.fromFirestore(doc)).toList();
  }

  factory Course.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    List<dynamic> sectionsData = data['sections'] ?? [];
    List<Section> sectionsList = sectionsData.map((sectionData) => Section.fromMap(sectionData)).toList();
    return Course(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      level: data['level'] ?? '',
      department: data['department'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      ratingCount: data['rating_count'] ?? 0,
      hashtags: List<String>.from(data['hashtags'] ?? []),
      sections: sectionsList,
    );
  }

  factory Course.fromMap(Map<String, dynamic> data, {String id = ''}) {
    List<dynamic> sectionsData = data['sections'] ?? [];
    List<Section> sectionsList = sectionsData.map((sectionData) => Section.fromMap(sectionData)).toList();

    return Course(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      level: data['level'] ?? '',
      department: data['department'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      ratingCount: data['rating_count'] ?? 0,
      hashtags: List<String>.from(data['hashtags'] ?? []),
      sections: sectionsList,
    );
  }

  Map<String, dynamic> toFirestore() {
    return toMap()..remove('id');
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'level': level,
      'department': department,
      'rating': rating,
      'rating_count': ratingCount,
      'hashtags': hashtags,
      'sections': sections.map((section) => section.toMap()).toList(),
    };
  }

}