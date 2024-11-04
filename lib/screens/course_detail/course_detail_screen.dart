// lib/screens/course_detail_page.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber_security_app/screens/author_profile.dart';
import 'package:cyber_security_app/screens/video_player/video_player_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/authors.dart';
import '../../models/course.dart';
import '../../models/sections.dart';
import '../../models/video.dart';
import '../../services/auth_service.dart';

import '../search_page.dart';

class CourseDetailPage extends StatefulWidget {
  final Course course;
  final bool isDark;
  final String authorId;
  final String userId;
  final String sectionId;

  const CourseDetailPage(
      {super.key,
      required this.course,
      required this.authorId,
      required this.userId,
      required this.sectionId,
      required this.isDark});

  @override
  _CourseDetailPageState createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  late Future<List<Video>> _videosFuture;
  List<String> unlockedVideos = [];
  List<String> completedVideos = [];
  late Future<Author?> _authorFuture;
  Author? author;
  bool isLoading = true;
  List<bool> _isExpanded = [];

  @override
  void initState() {
    super.initState();
    _authorFuture = AuthService.getAuthorData(widget.authorId);
    //checkIfUserHasRated();

    fetchHashtags();
    _isExpanded = List.generate(widget.course.sections.length, (_) => false);
    checkIfCourseIsInFavorites();
  }

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  // Function to check if the course is already in the user's favorites
  void checkIfCourseIsInFavorites() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not logged in');
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

        List<dynamic> favoriteCourses = data['favorites'] ?? [];

        // Iterate through the list to check if the current course is in the favorites
        bool found = favoriteCourses.any((favorite) {
          return favorite['authorId'] == widget.authorId &&
              favorite['courseId'] == widget.course.id;
        });

        setState(() {
          isFavorite = found;
        });
      }
    } catch (e) {
      print("Error checking if course is in favorites: $e");
    }
  }

  void fetchHashtags() async {
    try {
      final courseDoc = await FirebaseFirestore.instance
          .collection('authors')
          .doc(widget.authorId)
          .collection('courses')
          .doc(widget.course.id)
          .get();

      if (courseDoc.exists) {
        final courseData = courseDoc.data();

        if (courseData != null && courseData.containsKey('hashtags')) {
          setState(() {
            hashtags = List<String>.from(courseData['hashtags'] ?? []);
          });
        } else {
          print("Hashtags alanı mevcut değil.");
        }
      } else {
        print("Kurs belgesi bulunamadı.");
      }
    } catch (e) {
      print("Hashtags verileri alınırken hata oluştu: $e");
    }
  }

  bool isFavorite = false;

  void toggleFavorite() async {
    setState(() {
      isFavorite = !isFavorite;
    });

    try {
      if (isFavorite) {
        await AuthService.addFavorite(widget.course.id, widget.authorId);
      } else {
        await AuthService.removeFavoriteCourse(
            widget.course.id, widget.authorId);
      }
    } catch (e) {
      // If an error occurs, revert the favorite status
      setState(() {
        isFavorite = !isFavorite;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Favori işleminde bir hata oluştu.')),
      );
    }
  }

  bool isExpanded = false; // Metin genişletme durumunu kontrol etmek için

  void navigateToSearch(String query) {
    // Arama sayfasına yönlendirme işlemi burada yapılacak.
    // Örneğin:
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(
          searchHashtag: query,
          userId: widget.userId,
          course: widget.course,
          authorId: widget.authorId,
          sectionId: widget.sectionId,
        ),
      ),
    );
  }

  List<String> hashtags = [];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: IconButton(
              icon: Icon(
                Icons.arrow_circle_left_outlined,
                size: 32,
                color: Colors.white,
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
              'Course details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Prompt',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          actions: [
            IconButton(
              padding: EdgeInsets.only(right: 15),
              icon: Icon(
                size: 32,
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.white,
              ),
              onPressed: toggleFavorite,
            ),
          ],
        ),
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.32,
                decoration: ShapeDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(0.00, -1.00),
                    end: Alignment(0, 1),
                    colors: [Color(0xFF2F2F2F), Color(0xFF2F2F2F)],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15)),
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
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 90, right: 20, left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                widget.course.name,
                                style: TextStyle(
                                  height: 1.2,
                                  fontSize: 28,
                                  fontFamily: 'Prompt',
                                  fontWeight: FontWeight.w400,
                                  color: widget.isDark
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 25, top: 10),
                                child: Text(
                                  widget.course.department,
                                  textAlign: TextAlign.justify,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  softWrap: true,
                                  style: TextStyle(
                                    fontFamily: 'Prompt',
                                    fontWeight: FontWeight.w400,
                                    height: 1.2,
                                    fontSize: 16,
                                    color: widget.isDark
                                        ? Colors.white70
                                        : Colors.black54,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Wrap(
                                spacing: 2,
                                runSpacing: 5,
                                children: hashtags.map((hashtag) {
                                  return GestureDetector(
                                    onTap: () {
                                      navigateToSearch(hashtag);
                                    },
                                    child: Card(
                                      color: Color(0xFF2F2F2F),
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            width: 2, color: Colors.white),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 15,
                                        ),
                                        child: Text(
                                          hashtag,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Prompt',
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Description",
                      style: TextStyle(
                        color: Color(0xFF888888),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        isExpanded
                            ? widget.course.description
                            : widget.course.description.length > 300
                                ? widget.course.description.substring(0, 300)
                                : widget.course.description,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontFamily: 'Prompt',
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: widget.isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    if (widget.course.description.length > 300)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        child: Text(
                          isExpanded ? 'Show Less' : 'Show More',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(
                width: 287,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            strokeAlign: BorderSide.strokeAlignCenter,
                            color: Color(0xFF888888),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 7),
                    SizedBox(
                      width: 73,
                      child: Text(
                        'Author',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF888888),
                          fontSize: 14,
                          fontFamily: 'Prompt',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 7),
                    Container(
                      width: 100,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            strokeAlign: BorderSide.strokeAlignCenter,
                            color: Color(0xFF888888),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<Author?>(
                    future: _authorFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // Show loading indicator
                      } else if (snapshot.hasError) {
                        return Text("Error loading author data");
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return Text("Author data not found");
                      } else {
                        author = snapshot.data; // Assign the author data
                        return buildAuthorInfo(); // Build UI with author data
                      }
                    },
                  ),
                  //Sections List
                  /*FutureBuilder<List<Section>>(
                    future: AuthService.fetchSections(
                        widget.authorId, widget.course.id),
                    // Fetch the sections
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text("No sections available"));
                      }

                      // Section data is available
                      List<Section> sections = snapshot.data!;

                      return ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shrinkWrap: true,
                        // Add this to ensure the ListView takes only the space it needs
                        physics: NeverScrollableScrollPhysics(),
                        // Disable ListView's own scrolling
                        itemCount: sections.length,
                        itemBuilder: (context, index) {
                          Section section = sections[index];
                          return ExpansionTile(
                            title: Text(
                              section.title,
                              style: TextStyle(color: Colors.white),
                            ),
                            children: section.videos.map((video) {
                              return ListTile(
                                style: ListTileStyle.drawer,
                                leading: Icon(Icons.play_circle_fill),
                                title: Text(
                                  video.title,
                                  style: TextStyle(color: Colors.white),
                                ),
                                subtitle:
                                    Text("Duration: ${video.duration} mins"),
                              );
                            }).toList(),
                          );
                        },
                      );
                    },
                  ),*/
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AuthorProfileDetail(
                            authorId: widget.authorId,
                            userId: widget.userId,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 170,
                      height: 55,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 15),
                      decoration: ShapeDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.00, -1.00),
                          end: Alignment(0, 1),
                          colors: [Color(0xFF21C8F6), Color(0xFF637BFF)],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0xFF21C8F6),
                            blurRadius: 20,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Author Profile',
                            style: TextStyle(
                              color: Color(0xFFFCFCFF),
                              fontSize: 16,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoPlayerPage(
                            course: widget.course,
                            authorId: widget.authorId,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 170,
                      height: 55,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 15),
                      decoration: ShapeDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.00, -1.00),
                          end: Alignment(0, 1),
                          colors: [
                            Color(0xFF28C76F),
                            Color(0xFF48DA89),
                            Color(0xFF48DA89)
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0xFF4CD964),
                            blurRadius: 20,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Start Course',
                            style: TextStyle(
                              color: Color(0xFFFCFCFF),
                              fontSize: 16,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context); // Geri tuşuna basıldığında önceki sayfaya dön
    return true;
  }

  Widget buildAuthorInfo() {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, top: 30),
      height: 125,
      padding: const EdgeInsets.all(15),
      decoration: ShapeDecoration(
        color: Color(0xFF2F2F2F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 135,
              height: 135,
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
            top: -4,
            left: 1,
            child: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: author?.imageUrl != null
                    ? Image.network(
                        author!.imageUrl, // Load image from URL
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                              "images/default_author.png"); // Fallback image
                        },
                      )
                    : Image.asset(
                        "images/default_author.png"), // Fallback if no URL
              ),
            ),
          ),
          Positioned(
            top: 5,
            left: 75,
            child: SizedBox(
              child: Row(
                children: [
                  Text(
                    maxLines: 1,
                    author?.name ?? "Unknown Author",
                    style: TextStyle(
                      color: Colors.white,
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
            top: 40,
            left: 75,
            child: SizedBox(
              child: Row(
                children: [
                  Text(
                    author!.courseCount >= 50
                        ? "50+ Courses"
                        : "${(author?.courseCount ?? 0).toString()} Courses",
                    style: TextStyle(
                      color: Color(0xFF888888),
                      fontSize: 14,
                      fontFamily: 'Prompt',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 4,
                    height: 4,
                    decoration: ShapeDecoration(
                      color: Color(0xFF90909F),
                      shape: OvalBorder(),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    author!.studentCount >= 1000
                        ? "1000+ Students"
                        : "${(author?.studentCount ?? 0).toString()} Students",
                    style: TextStyle(
                      color: Color(0xFF888888),
                      fontSize: 14,
                      fontFamily: 'Prompt',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 75,
            child: SizedBox(
              child: Row(
                children: [
                  Text(
                    maxLines: 1,
                    "Course Reviews:",
                    style: TextStyle(
                      color: Color(0xFF888888),
                      fontSize: 14,
                      fontFamily: 'Prompt',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  buildStarRating(author?.rating ?? 0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<ExpansionPanel>> _buildSectionPanels(
      Course course, String authorId) async {
    List<ExpansionPanel> panels = [];

    for (Section section in course.sections) {
      List<Video> videos =
          await AuthService.fetchVideos(authorId, course.id, section.id);

      panels.add(
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(section.title),
              subtitle: Text("Videos: ${videos.length}"),
            );
          },
          body: Column(
            children: videos.map<Widget>((video) {
              return ListTile(
                leading: Icon(Icons.play_circle_fill),
                title: Text(video.title),
                subtitle: Text("Duration: ${video.duration} mins"),
                onTap: () {
                  print("Selected video: ${video.title}");
                  // Burada video oynatma işlemi başlatılabilir
                  // Örneğin: navigateToVideoPlayer(video.url);
                },
              );
            }).toList(),
          ),
          isExpanded: false, // You might want to manage this state
        ),
      );
    }

    return panels;
  }

  // Function to build the star rating row
  Widget buildStarRating(double rating, {int starCount = 5}) {
    return Row(
      children: List.generate(starCount, (index) {
        double starValue = index + 1;
        return Icon(
          _getStarIcon(starValue, rating),
          color: Colors.blue,
          size: 15, // Adjust the size of the star
        );
      })
        ..add(SizedBox(width: 5)) // Add space between stars and rating text
        ..add(Text(
          rating.toString(),
          style: TextStyle(
            fontSize: 12,
            color: Colors.black,
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

// Determine the color of the star
  Color _getStarColor(double starValue, double rating) {
    return rating >= starValue ? Colors.blue : Colors.grey;
  }
}

/*
const SizedBox(height: 20),

// Bölümler
ListView.builder(
itemCount: widget.course.sections.length,
itemBuilder: (context, index) {
final section = widget.course.sections[index];
return ExpansionTile(
title: Text(
section.title,
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.w600,
color: widget.isDark ? Colors.white : Colors.black87,
),
),
children: section.videos.map((video) {
return ListTile(
leading:
Icon(Icons.play_arrow, color: Colors.blue)
   ,
title: Text(
video.title,
style: TextStyle(
color:
widget.isDark ? Colors.white : Colors.black87,
),
),
onTap: () {

}
   ,
);
}).toList(),
);
},
),
*/
