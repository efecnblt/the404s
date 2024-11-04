import 'package:cloud_firestore/cloud_firestore.dart';

import 'course.dart';

class Author {
  final String id;
  final String name;
  final String imageUrl;
  final String department;
  final int courseCount;
  final int studentCount;
  final double rating;
  final List<Course> courses; // List of courses

  Author({
    required this.id,
    required this.name,
    required this.department,
    required this.imageUrl,
    required this.courseCount,
    required this.studentCount,
    required this.rating,
    required this.courses,
  });

  factory Author.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    List<dynamic> coursesData = data['courses'] ?? [];
    List<Course> coursesList = coursesData.map((courseData) => Course.fromMap(courseData)).toList();
    return Author(
      id: doc.id,
      name: data['name'] ?? '',
      department: data['department'] ?? '',
      imageUrl: data['image_url'] ?? '',
      courseCount: (data['courseCount'] ?? 0).toInt(),
      studentCount: (data['studentCount'] ?? 0).toInt(),
      rating: (data['rating'] ?? 0.0).toDouble(),
      courses: coursesList,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'department': department,
      'image_url': imageUrl,
      'course_count': courseCount,
      'studentCount': studentCount,
      'rating': rating,
      'courses': courses.map((course) => course.toMap()).toList(),
    };
  }
}
