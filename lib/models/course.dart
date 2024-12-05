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

    print('Raw data: ${data}');

    // Handle sections
    List<dynamic> sectionsData = (data['sections'] is List)
        ? data['sections']
        : (data['sections'] is Map ? (data['sections'] as Map).values.toList() : []);
    List<Section> sectionsList = sectionsData.where((section) => section is Map<String, dynamic>)
        .map((sectionData) => Section.fromMap(sectionData as Map<String, dynamic>))
        .toList();

    // Handle hashtags
    List<String> hashtagsList = (data['hashtags'] is List)
        ? List<String>.from(data['hashtags'].whereType<String>())
        : (data['hashtags'] is String ? [data['hashtags']] : []);

    // Handle description
    final String description = (data['description'] is List)
        ? (data['description'] as List).join('\n')
        : (data['description'] ?? '');

    // Handle learning outcomes
    final List<String> learningOutcomes = (data['learning_outcomes'] is List)
        ? List<String>.from(data['learning_outcomes'].whereType<String>())
        : [];

    return Course(
      id: doc.id,
      name: data['name'] ?? '',
      description: description,
      level: data['level'] ?? '',
      department: data['department'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      ratingCount: data['rating_count'] ?? 0,
      hashtags: hashtagsList,
      sections: sectionsList,
      // Assuming Course has a field for learning outcomes
    );
  }





  factory Course.fromMap(Map<String, dynamic> data, {String id = ''}) {
    List<dynamic> sectionsData = (data['sections'] is List) ? data['sections'] : [];
    List<Section> sectionsList = sectionsData.where((section) => section is Map<String, dynamic>)
        .map((sectionData) => Section.fromMap(sectionData as Map<String, dynamic>))
        .toList();


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
      'description': description.split('\n'), // Convert string back to list
      'level': level,
      'department': department,
      'rating': rating,
      'rating_count': ratingCount,
      'hashtags': hashtags,
      'sections': sections.map((section) => section.toMap()).toList(),

    };
  }



}