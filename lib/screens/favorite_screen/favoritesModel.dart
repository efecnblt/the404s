import 'package:flutter/material.dart';
import '../../models/course.dart';
import '../../services/auth_service.dart';
import '../build_card.dart';

class FavoritesScreen extends StatefulWidget {
  final String userId;
  const FavoritesScreen({super.key, required this.userId});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<Map<String, dynamic>>> _favoriteCoursesFuture;

  @override
  void initState() {
    super.initState();
    _favoriteCoursesFuture = AuthService.fetchFavoriteCourses(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorilerim'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _favoriteCoursesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While the future is loading, show a loading indicator
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If an error occurred, display an error message
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // If there are no favorite courses, inform the user
            return const Center(child: Text('Henüz favori kursunuz yok.'));
          } else {
            // If data is successfully fetched, build the list of favorite courses
            final favoriteCoursesWithDetails = snapshot.data!;

            return ListView.builder(
              itemCount: favoriteCoursesWithDetails.length,
              itemBuilder: (context, index) {
                final courseData = favoriteCoursesWithDetails[index];
                final Course course = Course.fromMap(
                    courseData['course']); // Convert Map to Course instance
                final String authorName = courseData['authorName'] as String;
                final String authorId = courseData['authorId'] as String;

                String sectionId = '';
                if (course.sections.isNotEmpty) {
                  sectionId = course.sections[0]['sectionId'] ?? '';
                }

                return BuildCard(
                  userId: widget.userId,
                  authorId: authorId,
                  sectionId: sectionId,
                  course: course,
                  authorName: authorName,
                  courseName: course.name,
                  description: course.description,
                  rating: course.rating,
                  level: course.level,
                  icon: Icons.book,
                  isDark: false,
                );
              },
            );
          }
        },
      ),
    );
  }
}
