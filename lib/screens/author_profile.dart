import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/authors.dart';
import '../models/course.dart';
import '../services/auth_service.dart';
import 'course_list_item.dart';

class AuthorProfileDetail extends StatefulWidget {
  final String authorId;
  final String userId;
  final bool isDark;

  const AuthorProfileDetail(
      {super.key, required this.authorId, required this.isDark, required this.userId});

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
      final author = await AuthService.fetchAuthorDetails(widget.authorId);
      final courses = await AuthService.fetchAuthorCourses(widget.authorId);

      setState(() {
        _author = author;
        _courses = courses;
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
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Author Profile')),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: Text('Author Profile')),
        body: Center(child: Text('Error: $_error')),
      );
    }
    if (_author == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Author Profile')),
        body: Center(child: Text('Author not found')),
      );
    }
    return Scaffold(
      backgroundColor: widget.isDark? Colors.black: Colors.white,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: IconButton(
            icon: Icon(
              Icons.arrow_circle_left_outlined,
              size: 32,
              color: widget.isDark? Colors.white:Colors.black,
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
            'Author details',
            style: TextStyle(
              color: widget.isDark ? Colors.white:Colors.black,
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
                        //ORTALAMA YAPILACAK
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
                              _author!.imageUrl, // Load image from URL
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                    "images/default_author.png"); // Fallback image
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
                                maxLines: 1,
                                _author!.name,
                                style: TextStyle(
                                  color: widget.isDark?  Colors.white :Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'Prompt',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
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
                          _author!.department,
                          style: TextStyle(
                            color: widget.isDark? Colors.white :Colors.black,
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
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'TOP RATED',
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
                          )),
                    ],
                  ),
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
                          label: "Total student",
                          value: _author!.studentCount.toString(),
                          isDark: widget.isDark,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        IconContainer(
                          isDark: widget.isDark,
                          icon: FontAwesomeIcons.bookBookmark,
                          label: "Courses",
                          value: _author!.courseCount.toString(),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Author reviews",
                              style: TextStyle(
                                color: widget.isDark ? Colors.white :Colors.black,
                                fontSize: 14,
                                fontFamily: 'Prompt',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 5),
                            buildStarRating(_author?.rating ?? 0),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
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
              color: widget.isDark? Colors.grey.shade800 : Color(0xFFF6F6F6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: _courses?.length,
              itemBuilder: (context, index) {
                String sectionId = '';
                if (_courses![index].sections.isNotEmpty) {
                  sectionId = _courses![index]
                      .sections[0]
                      .id; // Access the first section's ID
                }
                return CourseListItem(
                  userId: widget.userId,
                  sectionId: sectionId,
                  course: _courses![index],
                  isDark: widget.isDark,
                  authorName: _author!.name,
                  icon: FontAwesomeIcons.personBooth,
                  authorId: _author!.id,
                );
              },
            ),
          ),
        ),
      ]),
    );
  }

  // Function to build the star rating row
  Widget buildStarRating(double rating, {int starCount = 5}) {
    return Row(
      children: List.generate(starCount, (index) {
        double starValue = index + 1;
        return Icon(
          _getStarIcon(starValue, rating),
          color: Colors.yellow.shade900,
          size: 15, // Adjust the size of the star
        );
      })
        ..add(SizedBox(width: 5)) // Add space between stars and rating text
        ..add(Text(
          textAlign: TextAlign.center,
          rating.toString(),
          style: TextStyle(
            fontSize: 12,
            color: widget.isDark ? Colors.white : Colors.black,
            fontFamily: 'Prompt',
            fontWeight: FontWeight.bold,
          ),
        )), // Display the rating number next to the stars
    );
  }

// Determine which star icon to show (full, half, or empty)
  IconData _getStarIcon(double starValue, double rating) {
    if (rating >= starValue) {
      return Icons.star; // Full star
    } else if (rating >= starValue - 0.5) {
      return Icons.star_half; // Half star
    } else {
      return Icons.star_border; // Empty star
    }
  }
}

class IconContainer extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isDark;

  const IconContainer({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 45,
          height: 45,
          decoration: ShapeDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.00, -1.00),
              end: Alignment(0, 1),
              colors: [Color(0xFF21C8F6), Color(0xFF637BFF)],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Icon(
            icon,
            size: 24,
            color: Colors.white,
          ),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: isDark ?  Colors.white :Colors.black),
            ),
            SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
                color: isDark ?  Colors.white :Colors.black,
                fontSize: 16,
                fontFamily: 'Prompt',
                fontWeight: FontWeight.w400,

              ),
            ),
          ],
        ),
      ],
    );
  }
}
