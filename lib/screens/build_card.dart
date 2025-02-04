import 'dart:math';
import 'package:cyber_security_app/screens/app_theme.dart';
import 'package:cyber_security_app/services/api_services.dart';
import 'package:flutter/material.dart';
import '../models/course.dart';
import 'course_detail/course_detail_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BuildCard extends StatelessWidget {
  BuildCard(
      {super.key,
      required this.courseName,
      required this.description,
      required this.rating,
      required this.level,
      required this.icon,
      required this.isDark,
      required this.course,
      required this.authorName,
      required this.authorId,
      required this.userId,
      required this.localizations,
      required this.courseImage,
      required this.price});

  final String courseImage;
  final double price;
  final IconData icon;
  final String courseName;
  final String description;
  final double rating;
  final int level;
  final bool isDark;
  final Course course;
  final String authorName;
  final int authorId;
  final int userId;
  final AppLocalizations? localizations;

  final List<Color> colors = [
    // Preserved color list
    Color(0xffFE7E7E),
    Color(0xffC81004),
    Color(0xffA03C2E),
    // (Other colors omitted for brevity)
  ];

  Future<Map<String, String>> _fetchAuthorAndLevelInfo(
      int authorId, int levelId) async {
    try {
      // Fetch authors
      final authorsData = await ApiService.getAllAuthors();
      final author = authorsData.firstWhere(
        (author) => author['authorID'] == authorId,
        orElse: () => {'name': 'Unknown'},
      );

      // Fetch levels
      final levelMap = await ApiService.matchLevelIdAndName();
      final levelName = levelMap[levelId] ?? 'Unknown Level';

      return {
        'authorName': author['name'] ?? 'Unknown',
        'levelName': levelName,
      };
    } catch (e) {
      print('Error fetching author or level info: $e');
      return {
        'authorName': 'Unknown',
        'levelName': 'Unknown',
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    print(
        'Debug: Building card with course: ${course.name}, authorName: $authorName, userId: $userId');

    Random random = Random();
    int pickColor = random.nextInt(colors.length);

    return FutureBuilder<Map<String, String>>(
        future: _fetchAuthorAndLevelInfo(authorId, level),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final data = snapshot.data ?? {};
            final authorName = data['authorName'] ?? 'Unknown';
            final levelName = data['levelName'] ?? 'Unknown';
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      if (course == null ||
                          course.name == null ||
                          course.description == null ||
                          course.rating == null) {
                        return Scaffold(
                          body: Center(
                            child: Text('Invalid course data'),
                          ),
                        );
                      }
                      return CourseDetailPage(
                        course: course,
                        authorId: authorId,
                        userId: userId,
                        isDark: isDark,
                        localizations: localizations,
                      );
                    },
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                padding: const EdgeInsets.all(15),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  shadows: [
                    BoxShadow(
                      color: isDark
                          ? DarkTheme.shadowColor
                          : LightTheme.shadowColor,
                      blurRadius: 2,
                    )
                  ],
                  color: isDark
                      ? DarkTheme.cardBackgroundColor
                      : LightTheme.cardBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 85,
                      height: 85,
                      decoration: ShapeDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.67, 0.75),
                          end: Alignment(-0.67, -0.75),
                          colors: [colors[pickColor], colors[pickColor]],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: courseImage.isNotEmpty
                            ? Image.network(
                                courseImage,
                                fit: BoxFit.fill,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.broken_image,
                                    size: 50,
                                    color: Colors.grey,
                                  );
                                },
                              )
                            : Icon(
                                Icons.image_not_supported,
                                size: 50,
                                color: Colors.grey,
                              ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              courseName,
                              style: TextStyle(
                                color: isDark
                                    ? DarkTheme.textColor
                                    : LightTheme.textColor,
                                fontFamily: "Prompt",
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                            Text(
                              description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isDark
                                    ? DarkTheme.subTitleColor
                                    : LightTheme.subTitleColor,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Wrap(
                              spacing: 5,
                              runSpacing: 5,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Colors.amber,
                                ),
                                Text(
                                  rating.toString(),
                                  style: TextStyle(
                                    color: isDark
                                        ? DarkTheme.textColor
                                        : LightTheme.textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                _buildDot(),
                                Text(
                                  authorName.toString(),
                                  style: TextStyle(
                                    color: isDark
                                        ? DarkTheme.instructorAndLevel
                                        : LightTheme.instructorAndLevel,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                _buildDot(),
                                _buildLevelText(levelName),
                                _buildDot(),
                                Text(
                                  '$price\$',
                                  style: TextStyle(
                                    color: isDark
                                        ? DarkTheme.instructorAndLevel
                                        : LightTheme.instructorAndLevel,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }

  Widget _buildLevelText(String levelName) {
    switch (levelName) {
      case 'Beginner':
        return Text(
          localizations!.beginner,
          style: TextStyle(
            color: isDark
                ? DarkTheme.instructorAndLevel
                : LightTheme.instructorAndLevel,
          ),
        );
      case 'Intermediate':
        return Text(
          localizations!.intermediate,
          style: TextStyle(
            color: isDark
                ? DarkTheme.instructorAndLevel
                : LightTheme.instructorAndLevel,
          ),
        );
      case 'Advanced':
        return Text(
          localizations!.advanced,
          style: TextStyle(
            color: isDark
                ? DarkTheme.instructorAndLevel
                : LightTheme.instructorAndLevel,
          ),
        );
      default:
        return Text(
          levelName,
          style: TextStyle(
            color: isDark
                ? DarkTheme.instructorAndLevel
                : LightTheme.instructorAndLevel,
          ),
        );
    }
  }

  Widget _buildDot() {
    return Container(
      width: 3,
      height: 3,
      decoration: const BoxDecoration(
        color: Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}
