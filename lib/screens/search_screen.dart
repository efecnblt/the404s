import 'package:cyber_security_app/screens/build_card.dart';
import 'package:cyber_security_app/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/course.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchScreen extends StatefulWidget {
  final int userId;
  final bool isDark;
  final AppLocalizations? localizations;

  const SearchScreen({
    Key? key,
    required this.userId,
    required this.isDark,
    this.localizations,
  }) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  String searchTerm = '';
  List<String> popularHashtags = ['flutter', 'security', 'hack', 'mobile'];
  List<Course> allCourses = [];
  List<Course> recommendedCourses = [];
  List<Course> matchingCourses = [];
  late Future<void> _allCoursesFuture;

  @override
  void initState() {
    super.initState();
    _allCoursesFuture = _fetchAllCourses();
  }

  Future<void> _fetchAllCourses() async {
    try {
      final coursesData = await ApiService.getAllCourses();
      print('Debug: Raw all courses data fetched: $coursesData');

      setState(() {
        allCourses = coursesData
            .map((data) {
              if (data != null) {
                return Course.fromMap(data);
              } else {
                print('Null course data found and skipped.');
                return null;
              }
            })
            .whereType<Course>()
            .toList();
      });

      print('Debug: All courses successfully parsed: $allCourses');
    } catch (e) {
      print('Error fetching all courses: $e');
    }
  }

  void searchCourses(String keyword) {
    setState(() {
      if (keyword.isEmpty) {
        matchingCourses = [];
        return;
      }
      matchingCourses = allCourses.where((course) {
        final courseName = course.name?.toLowerCase() ?? '';
        final hashtags = course.hashtags?.toLowerCase() ?? '';
        return courseName.contains(keyword.toLowerCase()) ||
            hashtags.contains(keyword.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: _allCoursesFuture,
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor:
                widget.isDark ? Colors.black : const Color(0xFFEEEEEE),
            body: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  style: TextStyle(
                                    color: widget.isDark
                                        ? Colors.white
                                        : const Color(0xFF252525),
                                  ),
                                  controller: searchController,
                                  onChanged: (value) {
                                    setState(() {
                                      searchTerm = value;
                                    });
                                    searchCourses(searchTerm);
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 18),
                                    filled: true,
                                    fillColor: widget.isDark
                                        ? Colors.grey.shade800
                                        : Colors.white,
                                    labelText:
                                        widget.localizations!.searchForaCourse,
                                    labelStyle: TextStyle(
                                      color: widget.isDark
                                          ? Colors.grey.shade200
                                          : const Color(0xFF888888),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    suffixIcon: const Icon(
                                        FontAwesomeIcons.magnifyingGlass),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                if (searchTerm.isEmpty) ...[
                                  Text(
                                    widget.localizations!.popularHashtags,
                                    style: TextStyle(
                                      color: widget.isDark
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 15.0,
                                    runSpacing: 10.0,
                                    children: popularHashtags.map((hashtag) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            searchTerm = hashtag;
                                            searchController.text = hashtag;
                                          });
                                          searchCourses(hashtag);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 12.0),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: widget.isDark
                                                  ? [
                                                      Colors.green.shade900,
                                                      Colors.green.shade800
                                                    ]
                                                  : [
                                                      const Color(0xFF21C8F6),
                                                      const Color(0xFF637BFF)
                                                    ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: Text(
                                            hashtag,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    widget.localizations!.recommended,
                                    style: TextStyle(
                                      color: widget.isDark
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Column(
                                    children: allCourses.map((course) {
                                      return BuildCard(
                                        price: course.price!,
                                        courseImage: course.image!,
                                        userId: widget.userId,
                                        authorId: course.authorId!,
                                        course: course,
                                        authorName: '',
                                        icon: FontAwesomeIcons.graduationCap,
                                        courseName: course.name!,
                                        description: course.description!,
                                        rating: course.rating!,
                                        level: course.levelId!,
                                        isDark: widget.isDark,
                                        localizations: widget.localizations,
                                      );
                                    }).toList(),
                                  ),
                                ] else if (matchingCourses.isNotEmpty) ...[
                                  Column(
                                    children: matchingCourses.map((course) {
                                      return BuildCard(
                                        price: course.price!,
                                        courseImage: course.image!,
                                        userId: widget.userId,
                                        authorId: course.authorId!,
                                        course: course,
                                        authorName: '',
                                        icon: FontAwesomeIcons.graduationCap,
                                        courseName: course.name!,
                                        description: course.description!,
                                        rating: course.rating!,
                                        level: course.levelId!,
                                        isDark: widget.isDark,
                                        localizations: widget.localizations,
                                      );
                                    }).toList(),
                                  ),
                                ] else ...[
                                  Center(
                                    child: Text(
                                      'widget.localizations!.noResultsFound',
                                      style: TextStyle(
                                        color: widget.isDark
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          );
        });
  }
}
