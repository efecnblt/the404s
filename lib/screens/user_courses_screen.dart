import 'package:cyber_security_app/screens/app_theme.dart';
import 'package:cyber_security_app/screens/build_card.dart';
import 'package:flutter/material.dart';
import 'package:cyber_security_app/models/course.dart';
import 'package:cyber_security_app/services/api_services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserCoursesScreen extends StatefulWidget {
  final int userId;
  final bool isDark;
  final AppLocalizations? localizations;

  const UserCoursesScreen({
    Key? key,
    required this.userId,
    required this.isDark,
    required this.localizations,
  }) : super(key: key);

  @override
  _UserCoursesScreenState createState() => _UserCoursesScreenState();
}

class _UserCoursesScreenState extends State<UserCoursesScreen> {
  late Future<List<Course>> _userCoursesFuture;
  @override
  void initState() {
    super.initState();
    _userCoursesFuture = _fetchUserCourses(widget.userId);
  }

  Future<List<Course>> _fetchUserCourses(int userId) async {
    try {
      print('Debug: Fetching user courses for userId $userId...');
      final coursesData = await ApiService.getUserCourses(userId);
      print('Debug: Raw course data fetched: $coursesData');

      final userCourses = coursesData.map((data) {
        print('Debug: Processing course data: $data');
        return data['course'] as Course;
      }).toList();

      print('Debug: User courses successfully parsed: $userCourses');

      return userCourses;
    } catch (e) {
      print('Error fetching user courses: $e');
      throw Exception('Failed to load courses.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Course>>(
        future: _userCoursesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No user data found'));
          } else {
            final userCourses = snapshot.data!;
            return WillPopScope(
              onWillPop: () async => false,
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Scaffold(
                  backgroundColor: widget.isDark
                      ? DarkTheme.backgroundColor
                      : LightTheme.backgroundColor,
                  appBar: AppBar(
                    title: Text(
                      widget.localizations!.myCourses,
                      style: TextStyle(
                          color: widget.isDark ? Colors.white : Colors.black),
                    ),
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.transparent,
                    centerTitle: true,
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: userCourses.length,
                          itemBuilder: (context, index) {
                            final userCourseData = userCourses[index];
                            final course = userCourseData;

                            return BuildCard(
                              price: course.price!,
                              courseImage: course.image!,
                              userId: widget.userId,
                              authorId: course.authorId!,
                              course: course,
                              authorName:
                              course.authorId.toString() ?? 'Unknown',
                              icon: Icons.book,
                              courseName: course.name!,
                              description: course.description!,
                              rating: course.rating!,
                              level: course.levelId!,
                              isDark: widget.isDark,
                              localizations: widget.localizations,
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }
}
