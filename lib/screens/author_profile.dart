import 'package:cyber_security_app/screens/build_card.dart';
import 'package:cyber_security_app/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/authors.dart';
import '../models/course.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthorProfileDetail extends StatefulWidget {
  final int authorId;
  final int userId;
  final bool isDark;
  final AppLocalizations? localizations;

  const AuthorProfileDetail(
      {super.key,
      required this.authorId,
      required this.isDark,
      required this.userId,
      required this.localizations});

  @override
  _AuthorProfileDetailState createState() => _AuthorProfileDetailState();
}

class _AuthorProfileDetailState extends State<AuthorProfileDetail> {
  Author? _author;
  List<Course>? _courses;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAuthorData();
  }

  Future<void> _loadAuthorData() async {
    try {
      final response = await ApiService.getRequest(
          '/api/Authors/getauthorallprofile?authorId=${widget.authorId}');
      final allCoursesResponse =
          await ApiService.getRequest('/api/Courses/getall');
      if (response == null || !response.containsKey('authorID')) {
        throw Exception('Invalid response format');
      }
      if (allCoursesResponse == null ||
          !allCoursesResponse.containsKey('data')) {
        throw Exception('No courses found.');
      }

      final allCoursesList = allCoursesResponse['data'] as List<dynamic>;
      final allCourses =
          allCoursesList.map((course) => Course.fromMap(course)).toList();
      final matchedCourses = allCourses
          .where((course) => course.authorId == widget.authorId)
          .toList();
      setState(() {
        _courses = matchedCourses;
        _isLoading = false;
      });

      // Fetch the department map
      final departmentMap = await ApiService.getDepartmentMap();

      setState(() {
        _author = Author.fromMap(response);

        // Map department ID to department name
        _author!.departmentName =
            departmentMap[_author!.departmentID] ?? 'Unknown Department';

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _error != null || _author == null) {
      return Scaffold(
        backgroundColor: widget.isDark ? Colors.black : Colors.white,
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: IconButton(
              icon: Icon(
                Icons.arrow_circle_left_outlined,
                size: 32,
                color: widget.isDark ? Colors.white : Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              widget.localizations!.authorDetails,
              style: TextStyle(
                color: widget.isDark ? Colors.white : Colors.black,
                fontSize: 18,
                fontFamily: 'Prompt',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
        backgroundColor: widget.isDark ? Colors.black : Colors.white,
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: IconButton(
              icon: Icon(
                Icons.arrow_circle_left_outlined,
                size: 32,
                color: widget.isDark ? Colors.white : Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              widget.localizations!.authorDetails,
              style: TextStyle(
                color: widget.isDark ? Colors.white : Colors.black,
                fontSize: 18,
                fontFamily: 'Prompt',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        body: Column(children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    padding: const EdgeInsets.all(16),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: MediaQuery.of(context).size.height * -0.045,
                          left: MediaQuery.of(context).size.width * -0.12,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.35,
                            height: MediaQuery.of(context).size.width * 0.35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                "images/new_logo.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.007,
                          left: MediaQuery.of(context).size.width * 0.007,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: MediaQuery.of(context).size.width * 0.15,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x7EFCFCFF),
                                  blurRadius: 12.76,
                                  offset: Offset(0, 5),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: ClipOval(
                              child: Image.network(
                                _author!.imageURL ?? '',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                      "images/default_author.png");
                                },
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          left: MediaQuery.of(context).size.width * 0.2,
                          child: SizedBox(
                            child: Row(
                              children: [
                                Text(
                                  _author!.name ?? '',
                                  style: TextStyle(
                                    color: widget.isDark
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'Prompt',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Icon(
                                  Icons.verified,
                                  color: Colors.blue,
                                  size: 20,
                                )
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 30,
                          left: MediaQuery.of(context).size.width * 0.2,
                          child: Text(
                            '${_author?.departmentName}',
                            style: TextStyle(
                              color:
                                  widget.isDark ? Colors.white : Colors.black,
                              fontSize: 18,
                              fontFamily: 'Prompt',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 65,
                          left: MediaQuery.of(context).size.width * 0.2,
                          child: Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.medal,
                                color: Colors.amber,
                              ),
                              SizedBox(width: 5),
                              Text(
                                widget.localizations!.topRated,
                                style: TextStyle(
                                  color: Color(0xFFFFC73C),
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  fontFamily: 'Prompt',
                                  fontWeight: FontWeight.w300,
                                  height: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    child: Text(
                      _author!.biography!,
                      style: TextStyle(
                          color: widget.isDark ? Colors.white : Colors.black,
                          fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      margin: EdgeInsets.only(left: 10, right: 10, bottom: 30),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconContainer(
                            icon: FontAwesomeIcons.chalkboardTeacher,
                            label: widget.localizations!.totalStudent,
                            value: _author!.studentCount.toString(),
                            isDark: widget.isDark,
                          ),
                          SizedBox(width: 15),
                          IconContainer(
                            isDark: widget.isDark,
                            icon: FontAwesomeIcons.bookBookmark,
                            label: widget.localizations!.courses,
                            value: _author!.courseCount.toString(),
                          ),
                          SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.localizations!.authorReviews,
                                style: TextStyle(
                                  color: widget.isDark
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Prompt',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 5),
                              buildStarRating(_author?.rating ?? 0),
                            ],
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: ShapeDecoration(
                color: widget.isDark ? Colors.grey.shade800 : Color(0xFFF6F6F6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: _courses?.length ?? 0,
                  itemBuilder: (context, index) {
                    return BuildCard(
                        courseName: _courses![index].name!,
                        description: _courses![index].description!,
                        rating: _courses![index].rating!,
                        level: _courses![index].levelId!,
                        icon: FontAwesomeIcons.graduationCap,
                        isDark: widget.isDark,
                        course: _courses![index],
                        authorName: _courses![index].authorName ?? "",
                        authorId: _courses![index].authorId!,
                        userId: widget.userId,
                        localizations: widget.localizations,
                        courseImage: _courses![index].image!,
                        price: _courses![index].price!);
                  }),
            ),
          ),
        ]));
  }

  Widget buildStarRating(double rating) {
    return Row(
      children: List.generate(5, (index) {
        if (index < rating.round()) {
          return Icon(
            Icons.star,
            color: Colors.amber,
            size: 16,
          );
        } else {
          return Icon(
            Icons.star_border,
            color: Colors.grey,
            size: 16,
          );
        }
      }),
    );
  }
}

class IconContainer extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isDark;

  const IconContainer({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: isDark ? Colors.white : Colors.black,
          size: 24,
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black87,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
