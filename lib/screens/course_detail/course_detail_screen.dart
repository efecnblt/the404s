import 'package:cyber_security_app/screens/purchase_screen.dart';
import 'package:cyber_security_app/screens/author_profile.dart';
import 'package:cyber_security_app/screens/video_player/video_player_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/authors.dart';
import '../../models/course.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../services/api_services.dart';

class CourseDetailPage extends StatefulWidget {
  final Course course;
  final bool isDark;
  final int authorId;
  final int userId;
  final AppLocalizations? localizations;

  const CourseDetailPage({
    super.key,
    required this.course,
    required this.authorId,
    required this.userId,
    required this.isDark,
    required this.localizations,
  });

  @override
  _CourseDetailPageState createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  bool isFavorite = false;
  late Future<Author> _authorFuture;

  bool isRegistered = false;
  Author? author;
  int? _studentId;

  @override
  void initState() {
    super.initState();
    _fetchCategoryName();
    _fetchStudentId().then((_) => checkIfCourseIsFavorite());
    _checkIfCourseIsRegistered();
    _authorFuture = ApiService.getAuthorById(widget.authorId);
  }

  Future<void> _checkIfCourseIsRegistered() async {
    setState(() {
      isProcessing = true;
    });

    try {
      final userCourses = await ApiService.getUserCourses(widget.userId);
      final isRegisteredCourse = userCourses.any((course) {
        return course['course'].courseID == widget.course.courseID;
      });

      setState(() {
        isRegistered = isRegisteredCourse;
        isProcessing = false;
      });
    } catch (e) {
      print('Error checking course registration: $e');
      setState(() {
        isRegistered = false;
        isProcessing = false;
      });
    }
  }

  Widget _buildRegisteredText() {
    if (isProcessing) {
      return Text(
        "Loading...",
        style: TextStyle(
          color: Color(0xFFFCFCFF),
          fontSize: 16,
          fontFamily: 'DM Sans',
          fontWeight: FontWeight.w700,
          height: 0,
        ),
      );
    } else if (isRegistered) {
      return Text(
        widget.localizations!.startCourse,
        style: TextStyle(
          color: Color(0xFFFCFCFF),
          fontSize: 16,
          fontFamily: 'DM Sans',
          fontWeight: FontWeight.w700,
          height: 0,
        ),
      );
    } else {
      return Text(
        widget.localizations!.purchase,
        style: TextStyle(
          color: Color(0xFFFCFCFF),
          fontSize: 16,
          fontFamily: 'DM Sans',
          fontWeight: FontWeight.w700,
          height: 0,
        ),
      );
    }
  }

  Future<void> _fetchCategoryName() async {
    try {
      // Fetch category data
      final categoryResponse =
          await ApiService.getCategoryById(widget.course.categoryId!);
      final categoryName = categoryResponse['name'] ?? 'Unknown Category';

      setState(() {
        widget.course.categoryName = categoryName;
      });
    } catch (e) {
      print('Error fetching category: $e');
    }
  }

  Future<void> _fetchStudentId() async {
    try {
      final studentId = await ApiService.getStudentIdByUserId(widget.userId);
      setState(() {
        _studentId = studentId;
      });
      print('Student ID: $_studentId');
    } catch (e) {
      print('Error fetching studentId: $e');
    }
  }

  Future<void> checkIfCourseIsFavorite() async {
    if (_studentId == null) {
      await _fetchStudentId();
    }

    try {
      final status = await ApiService.checkFavoriteStatus(
          _studentId!, widget.course.courseID);
      setState(() {
        isFavorite = status;
      });
    } catch (e) {
      print('Error checking favorite status: $e');
    }
  }

  Future<void> toggleFavorite() async {
    if (_studentId == null) {
      await _fetchStudentId();
    }

    try {
      if (isFavorite) {
        // Remove from favorites
        final statusCode = await ApiService.removeFromFavorites(
            widget.course.courseID, _studentId!);
        if (statusCode == 200) {
          setState(() {
            isFavorite = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(widget.localizations?.removedFav ??
                    'Removed from favorites')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(widget.localizations?.errorRemovedFav ??
                    'Failed to remove from favorites')),
          );
        }
      } else {
        // Add to favorites
        final statusCode = await ApiService.addToFavorites(
            widget.course.courseID, _studentId!);
        if (statusCode == 200) {
          setState(() {
            isFavorite = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    widget.localizations?.addedFav ?? 'Added to favorites')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(widget.localizations?.errorAddedFav ??
                    'Failed to add to favorites')),
          );
        }
      }
    } catch (e) {
      print('Error toggling favorite: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred.')),
      );
    }
  }

  bool isProcessing = false; // Flag to prevent multiple API calls

  bool isExpanded = false; // Metin genişletme durumunu kontrol etmek için

  List<String> _parseHashtags(String? hashtags) {
    if (hashtags == null || hashtags.isEmpty) return [];
    return hashtags.split(',').map((tag) => tag.trim()).toList();
  }

// Add this widget to display the hashtags
  Widget _buildHashtagsSection() {
    final hashtags = _parseHashtags(widget.course.hashtags);
    if (hashtags.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        children: hashtags.map((tag) {
          return GestureDetector(
            onTap: () {
              print(tag);
            },
            child: Text(
              '#$tag     ',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ApiService.getCategoryById(widget.course.categoryId!);
    ApiService.getStudentIdByUserId(widget.userId);

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
              widget.localizations!.courseDetails,
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
              icon: Icon(
                isFavorite
                    ? FontAwesomeIcons.solidHeart
                    : FontAwesomeIcons.heart,
                color: isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  toggleFavorite();
                });
              },
            ),
          ],
        ),
        extendBodyBehindAppBar: true,
        backgroundColor: widget.isDark ? Colors.black : Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: ShapeDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(0.00, -1.00),
                    end: Alignment(0, 1),
                    colors: widget.isDark
                        ? [Colors.grey.shade700, Colors.grey.shade900]
                        : [Color(0xFF21C8F6), Color(0xFF637BFF)],
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
                                widget.course.name!,
                                style: TextStyle(
                                  height: 1.2,
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.04,
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
                                  widget.course.categoryName ?? "",
                                  textAlign: TextAlign.justify,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  softWrap: true,
                                  style: TextStyle(
                                    fontFamily: 'Prompt',
                                    fontWeight: FontWeight.w400,
                                    height: 1.2,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.02,
                                    color: widget.isDark
                                        ? Colors.white
                                        : Colors.black54,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              _buildHashtagsSection(),
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
                      widget.localizations!.description,
                      style: TextStyle(
                        color: Color(0xFF888888),
                        fontSize: 16,
                        fontFamily: 'Prompt',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        isExpanded
                            ? widget.course.description!
                            : widget.course.description!.length > 300
                                ? widget.course.description!.substring(0, 300)
                                : widget.course.description!,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontFamily: 'Prompt',
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: widget.isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    if (widget.course.description!.length > 300)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        child: Text(
                          isExpanded
                              ? widget.localizations!.showLess
                              : widget.localizations!.showMore,
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
                        widget.localizations!.author,
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
                        return Text(widget.localizations!.errorAuthorData);
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return Text(widget.localizations!.noAuthorInform);
                      } else {
                        author = snapshot.data; // Assign the author data
                        return buildAuthorInfo(); // Build UI with author data
                      }
                    },
                  ),
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
                            isDark: widget.isDark,
                            localizations: widget.localizations,
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
                            widget.localizations!.authorProfile,
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
                    onTap: isProcessing
                        ? null
                        : () {
                            if (isRegistered) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VideoPlayerPage(
                                    userId: widget.userId,
                                    courseId: widget.course.courseID,
                                  ),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PurchaseScreen(
                                    course: widget.course,
                                    isDark: widget.isDark,
                                    userId: widget.userId,
                                    localizations: widget.localizations,
                                  ),
                                ),
                              );
                            }
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
                        children: [_buildRegisteredText()],
                      ),
                    ),
                  )
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
        color: widget.isDark ? Colors.grey.shade800 : Color(0xFFF1F1FA),
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
                  width: 1,
                ),
              ),
              child: ClipOval(
                child: author?.imageURL != null
                    ? Image.network(
                        author!.imageURL!, // Load image from URL
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
                    author?.name ?? widget.localizations!.unknownAuthor,
                    style: TextStyle(
                      color: widget.isDark ? Colors.white : Color(0xFF161719),
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
                    author!.courseCount! >= 50
                        ? '${widget.localizations!.fiftyCourse}'
                        : "${(author?.courseCount ?? 0).toString()} ${widget.localizations!.courses}",
                    style: TextStyle(
                      color: widget.isDark
                          ? Colors.grey.shade400
                          : Color(0xFF888888),
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
                      color: widget.isDark
                          ? Colors.grey.shade400
                          : Color(0xFF90909F),
                      shape: OvalBorder(),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    author!.studentCount! >= 1000
                        ? widget.localizations!.thousandStudent
                        : "${(author?.studentCount ?? 0).toString()} ${widget.localizations!.students}",
                    style: TextStyle(
                      color: widget.isDark
                          ? Colors.grey.shade400
                          : Color(0xFF888888),
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
                    widget.localizations!.authorReviews,
                    style: TextStyle(
                      color: widget.isDark
                          ? Colors.grey.shade400
                          : Color(0xFF888888),
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

// Determine the color of the star
  Color _getStarColor(double starValue, double rating) {
    return rating >= starValue ? Colors.yellow.shade900 : Colors.grey;
  }
}
