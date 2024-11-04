import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


import '../models/authors.dart';
import '../models/course.dart';
import '../widgets/bottom_navigation_bar.dart';
import 'build_card.dart';

class SearchScreen extends StatefulWidget {
  final String? initialHashtag;
  final String userId;

  const SearchScreen({super.key, required this.userId, this.initialHashtag});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Course> matchingCourses = [];
  String searchTerm = '';
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> recommendedCourses = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialHashtag != null) {
      searchCourses(widget.initialHashtag!);
      searchTerm = widget.initialHashtag!;
      searchController.text = widget.initialHashtag!;
    }
    fetchRecommendedCourses();
  }

  Future<void> searchCourses(String searchTerm) async {
    QuerySnapshot authorsSnapshot =
        await FirebaseFirestore.instance.collection('authors').get();

    List<Course> results = [];

    for (var authorDoc in authorsSnapshot.docs) {
      Author author =
          Author.fromFirestore(authorDoc); // Author nesnesini oluşturuyoruz

      var coursesSnapshot =
          await authorDoc.reference.collection('courses').get();

      for (var courseDoc in coursesSnapshot.docs) {
        List<dynamic> hashtags = courseDoc['hashtags'] ?? [];
        String courseName = courseDoc['name'] ?? '';

        if (hashtags.contains(searchTerm) ||
            courseName.toLowerCase().contains(searchTerm.toLowerCase())) {
          Course course = Course.fromFirestore(courseDoc);
          course.loadSections(author.id); // Bölümleri yükleyebiliriz
          author.courses
              .add(course); // Kursları yazarın kurs listesine ekleyelim
          results.add(course);
        }
      }
    }

    setState(() {
      matchingCourses = results;
    });
  }

  Future<void> fetchRecommendedCourses() async {
    QuerySnapshot authorsSnapshot =
        await FirebaseFirestore.instance.collection('authors').get();

    List<Map<String, dynamic>> results = [];

    for (var authorDoc in authorsSnapshot.docs) {
      Author author =
          Author.fromFirestore(authorDoc); // Author nesnesini oluşturuyoruz

      var coursesSnapshot =
          await authorDoc.reference.collection('courses').limit(5).get();

      for (var courseDoc in coursesSnapshot.docs) {
        Course course = Course.fromFirestore(courseDoc);
        await course.loadSections(author.id); // Bölümleri yükleyelim
        results.add({
          'course': course,
          'author': author,
        });
      }
    }

    setState(() {
      recommendedCourses = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> categories = [
      'Game development',
      'Finance',
      'Python',
      'Programming',
      'Reactjs',
      'Flutter',
    ];

    return Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar:
            true, // AppBar'ın arkasında kalan kısmın uzamasını sağlar.

        body: CustomScrollView(
          slivers: [
            //sliver app barı sildim *mert
            SliverList(
                delegate: SliverChildListDelegate([
              SingleChildScrollView(
                  child: Column(
                children: [
                  Container(

                    height: MediaQuery.of(context).size.height *1.3,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    //decoration sildim edgeleri kaldırdım *mert
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(

                          padding: EdgeInsets.all(1),
                          child: TextField(

                            style: TextStyle(
                              color: Color(0xFF90909F),
                            ),
                            controller: searchController,
                            onChanged: (value) {
                              setState(() {
                                searchTerm = value;
                              });
                              searchCourses(searchTerm);
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 18),
                              filled: true,
                              icon:Icon(
                                FontAwesomeIcons.magnifyingGlass,
                                color: Colors.white,
                                size: 24,
                              ) ,
                              fillColor: Color(0xFF161719),
                              labelText: 'Search for a course...',
                              hintStyle: TextStyle(
                                color: Color(0xFF90909F),
                              ),
                              labelStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide(
                                  color: Color(0xFF161719),
                                  width: 0.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide(
                                  color: Color(0xFF161719),
                                  width: 0.0,
                                ),
                              ),

                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            'Browser Category',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Prompt',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (searchTerm.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Text(
                                  'Search results for "$searchTerm"',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: 'Prompt',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            Wrap(
                              spacing: 15.0,
                              runSpacing: 10.0,
                              children: categories.map((category) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      searchTerm = category;
                                      searchController.text = category;
                                    });
                                    searchCourses(category);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 12.0),
                                    decoration: ShapeDecoration(
                                      color: Color(0xFF2F2F2F),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            width: 1.3, color: Colors.white),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      shadows: [
                                        BoxShadow(
                                          color: Color(0xFF303030),
                                          blurRadius: 30,
                                          offset: Offset(0, 4),
                                          spreadRadius: 0,
                                        ),
                                        BoxShadow(
                                          color: Color(0x3F000000),
                                          blurRadius: 4,
                                          offset: Offset(0, 4),
                                          spreadRadius: 0,
                                        )
                                      ],
                                    ),
                                    child: Text(
                                      category,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 20),
                            if(searchTerm=='') //search terme bir şey yazılmamışken not found hatasını almamak için *mert
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 30,
                                          decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                width: 0.7,
                                                strokeAlign: BorderSide
                                                    .strokeAlignCenter,
                                                color: Color(0xFF888888),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 7),
                                        SizedBox(
                                          child: Text(
                                            'Recommended Courses',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontFamily: 'Prompt',
                                              fontWeight: FontWeight.w400,
                                              height: 0,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 7),
                                        Container(
                                          width: 30,
                                          decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                width: 0.7,
                                                strokeAlign: BorderSide
                                                    .strokeAlignCenter,
                                                color: Color(0xFF888888),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Column(
                                    children: recommendedCourses.map((data) {
                                      Course courseData = data['course'];
                                      Author authorData = data['author'];
                                      print(authorData.name);
                                      return BuildCard(
                                        userId: widget.userId,
                                        authorId: authorData.id,
                                        sectionId:
                                        courseData.sections.isNotEmpty
                                            ? courseData.sections[0].id
                                            : 'No Section',
                                        course: courseData,
                                        authorName: authorData.name,
                                        icon: FontAwesomeIcons.graduationCap,
                                        courseName: courseData.name,
                                        description: courseData.description,
                                        rating: courseData.rating,
                                        level: courseData.level,
                                        isDark: true,
                                      );
                                    }).toList(),
                                  ),
                                ],
                              )

                            else if (matchingCourses.isNotEmpty)
                              Column(
                                children: matchingCourses.map((courseData) {
                                  return BuildCard(
                                    userId: widget.userId,
                                    authorId: courseData.id,
                                    sectionId: courseData.sections.isNotEmpty
                                        ? courseData.sections[0].id
                                        : 'No Section',
                                    course: courseData,
                                    authorName: courseData.name,
                                    icon: FontAwesomeIcons.graduationCap,
                                    courseName: courseData.name,
                                    description: courseData.description,
                                    rating: courseData.rating,
                                    level: courseData.level,
                                    isDark: true,
                                  );
                                }).toList(),
                              )
                            else
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.only(bottom: 20, top: 20),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "No search Results found",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 30,
                                          decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                width: 0.7,
                                                strokeAlign: BorderSide
                                                    .strokeAlignCenter,
                                                color: Color(0xFF888888),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 7),
                                        SizedBox(
                                          child: Text(
                                            'Recommended Courses',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontFamily: 'Prompt',
                                              fontWeight: FontWeight.w400,
                                              height: 0,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Container(
                                          width: 30,
                                          decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                width: 0.7,
                                                strokeAlign: BorderSide
                                                    .strokeAlignCenter,
                                                color: Color(0xFF888888),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Column(
                                    children: recommendedCourses.map((data) {
                                      Course courseData = data['course'];
                                      Author authorData = data['author'];
                                      print(authorData.name);
                                      return BuildCard(
                                        userId: widget.userId,
                                        authorId: authorData.id,
                                        sectionId:
                                            courseData.sections.isNotEmpty
                                                ? courseData.sections[0].id
                                                : 'No Section',
                                        course: courseData,
                                        authorName: authorData.name,
                                        icon: FontAwesomeIcons.graduationCap,
                                        courseName: courseData.name,
                                        description: courseData.description,
                                        rating: courseData.rating,
                                        level: courseData.level,
                                        isDark: true,
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )),
            ]))
          ],
        ));
  }
}