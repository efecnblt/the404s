import 'package:flutter/material.dart';
import 'package:cyber_security_app/models/course.dart';
import 'package:cyber_security_app/services/api_services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../build_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavoritesPage extends StatefulWidget {
  final int userId;
  final bool isDark;
  final AppLocalizations? localizations;

  const FavoritesPage({
    Key? key,
    required this.userId,
    required this.isDark,
    required this.localizations,
  }) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Future<List<Course>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _favoritesFuture = _fetchFavoriteCourses();
  }

  /// Fetch favorite courses by first getting studentId and then fetching courses
  Future<List<Course>> _fetchFavoriteCourses() async {
    try {
      final studentId = await ApiService.getStudentIdByUserId(widget.userId);
      if (studentId == null) {
        print('No studentId found for userId: ${widget.userId}');
        return [];
      }

      final favoriteCourses = await ApiService.getFavoriteCourses(studentId);
      final List<Course> courseDetails = [];

      for (var favorite in favoriteCourses) {
        final courseData = await ApiService.getCourseById(favorite['courseID']);
        courseDetails.add(Course.fromMap(courseData));
      }

      return courseDetails;
    } catch (e) {
      print('Error fetching favorite courses: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.localizations!.myFavCourses,
          style: TextStyle(
            color: widget.isDark ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: widget.isDark ? Colors.black : Colors.white,
      ),
      body: FutureBuilder<List<Course>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(widget.localizations!.anErrorOccured));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(widget.localizations!.noFavourite));
          }

          final courses = snapshot.data!;
          return ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return BuildCard(
                price: course.price!,
                courseImage: course.image!,
                userId: widget.userId,
                authorId: course.authorId!,
                course: course,
                authorName: 'Unknown Author',
                icon: FontAwesomeIcons.graduationCap,
                courseName: course.name ?? '',
                description: course.description ?? 'No description available',
                rating: course.rating ?? 0.0,
                level: course.levelId!,
                isDark: widget.isDark,
                localizations: widget.localizations,
              );
            },
          );
        },
      ),
      backgroundColor: widget.isDark ? Colors.black : Colors.white,
    );
  }
}
