// components/build_card.dart
import 'dart:math';

import 'package:cyber_security_app/services/api_services.dart';
import 'package:flutter/material.dart';

List<Color> colors = [
  Color(0xFFFE7E7E),
  Color(0xFFC81004),
  Color(0xFFA03C2E),
  Color(0xFFB73E23),
  Color(0xFFF65C2B),
  Color(0xFFF04B04),
  Color(0xFFB5673C),
  Color(0xFFAE4D07),
  Color(0xFFAA5C15),
  Color(0xFFDB7C0C),
  Color(0xFFA97F41),
  Color(0xFFF4BA49),
  Color(0xFFC58F04),
  Color(0xFFCFB636),
  Color(0xFFA89845),
  Color(0xFFB6A615),
  Color(0xFFDAD561),
  Color(0xFFC7C945),
  Color(0xFF9FA64F),
  Color(0xFFB5D202),
  Color(0xFF9DAF46),
  Color(0xFF9DD402),
  Color(0xFFABD454),
  Color(0xFFA5D359),
  Color(0xFF4A8202),
  Color(0xFF59AA07),
  Color(0xFF429B08),
  Color(0xFF56803B),
  Color(0xFF67CB37),
  Color(0xFF44B01E),
  Color(0xFF329919),
  Color(0xFF48A938),
  Color(0xFF13C504),
  Color(0xFF0BF206),
  Color(0xFF00CA08),
  Color(0xFF03B215),
  Color(0xFF52CB65),
  Color(0xFF2A9241),
  Color(0xFF0AD643),
  Color(0xFF2FC863),
  Color(0xFF45A36B),
  Color(0xFF60FEA8),
  Color(0xFF018344),
  Color(0xFF13B06F),
  Color(0xFF4CA887),
  Color(0xFF65FCCD),
  Color(0xFF2C957B),
  Color(0xFF5AC0AD),
  Color(0xFF1A877A),
  Color(0xFF208E87),
  Color(0xFF30CDCD),
  Color(0xFF3D9AA0),
  Color(0xFF247C88),
  Color(0xFF218095),
  Color(0xFF59C5E8),
  Color(0xFF1180AF),
  Color(0xFF2F92CA),
  Color(0xFF4BA0DD),
  Color(0xFF5F9CD4),
  Color(0xFF2F5A8D),
  Color(0xFF3577DA),
  Color(0xFF2668E7),
  Color(0xFF1D3C8D),
  Color(0xFF1738AE),
  Color(0xFF495AB3),
  Color(0xFF7885F9),
  Color(0xFF2F339A),
  Color(0xFF130FDA),
  Color(0xFF433AA0),
  Color(0xFF2D14C8),
  Color(0xFF392588),
  Color(0xFF5528D8),
  Color(0xFF6328E0),
  Color(0xFF5F0EE3),
  Color(0xFF5714AB),
  Color(0xFF5406A2),
  Color(0xFF7C48A4),
  Color(0xFFA517FC),
  Color(0xFFB013FA),
  Color(0xFF772993),
  Color(0xFF712884),
  Color(0xFFDB1FF9),
  Color(0xFF901F9B),
  Color(0xFFC35BC5),
  Color(0xFFBC2AB7),
  Color(0xFF9B3E91),
  Color(0xFFDE44C5),
  Color(0xFFC14EA8),
  Color(0xFFF466CC),
  Color(0xFFCC138D),
  Color(0xFFE773B8),
  Color(0xFF9C4172),
  Color(0xFFD84B8E),
  Color(0xFFCB3B77),
  Color(0xFFDB457B),
  Color(0xFFDA1550),
  Color(0xFFFC6287),
  Color(0xFFF43A5B),
  Color(0xFFD80F27),
  Color(0xFFBA2931),
];
Map<String, Color> courseColors = {};

class CourseCard extends StatelessWidget {
  CourseCard({
    super.key,
    required this.courseName,
    required this.rating,
    required this.instructor,
    required this.levelId,
    required this.progress,
    required this.authorId,
    this.levelName,
    this.authorName,
  });

  final String courseName;
  final int authorId;
  final double rating;
  final String instructor;
  final int levelId;
  String? levelName;
  String? authorName;
  final double progress; // Progress percentage
  final Random random = Random();

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
    if (!courseColors.containsKey(courseName)) {
      int randomIndex = random.nextInt(colors.length);
      courseColors[courseName] =
          colors[randomIndex]; // Reuse color for the same course
    }
    // Use previously assigned color
    Color progressBarColor = courseColors[courseName]!;

    return FutureBuilder<Map<String, String>>(
        future: _fetchAuthorAndLevelInfo(authorId, levelId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final data = snapshot.data ?? {};
            final authorName = data['authorName'] ?? 'Unknown';
            final levelName = data['levelName'] ?? 'Unknown';
            return Container(
              height: 120,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.only(left: 15, right: 15),
              decoration: BoxDecoration(
                color: Colors.transparent, // Background color
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Center alignment
                children: [
                  Text(
                    courseName,
                    textAlign: TextAlign.center, // Center text alignment
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 5),
                          Text(
                            rating.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      _buildDot(),
                      Text(
                        authorName,
                        style: const TextStyle(color: Colors.white),
                      ),
                      _buildDot(),
                      Text(
                        levelName,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  // Progress Bar
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: 15,
                          color: Colors.grey[300], // Grey background color
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              height: 10, // Smaller height for green bar
                              width: MediaQuery.of(context).size.width *
                                  progress, // Width based on progress
                              color: progressBarColor, // Green color
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        });
  }

  Widget _buildDot() {
    return Container(
      width: 5,
      height: 5,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}
