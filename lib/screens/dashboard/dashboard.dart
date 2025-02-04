import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:cyber_security_app/models/user_model.dart';
import 'package:cyber_security_app/screens/login_or_signup_screen.dart';
import 'package:cyber_security_app/screens/user_courses_screen.dart';
import 'package:cyber_security_app/services/api_services.dart';
import 'package:cyber_security_app/widgets/course_card.dart';
import 'package:cyber_security_app/screens/favorite_screen/favoritesModel.dart';
import 'package:flutter/material.dart';
import '../../models/course.dart';
import '../../widgets/bottom_navigation_bar.dart';
import '../app_theme.dart';
import '../build_card.dart';
import '../profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../search_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Dashboard extends StatefulWidget {
  final int userId;
  static const String id = "dashboard_screen";

  const Dashboard({super.key, required this.userId});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Future<List<Course>> _userCoursesFuture;
  late Future<UserModel> _userFuture;
  late Future<List<Course>> _recommendedCoursesFuture;

  int _selectedIndex = 0;
  int value = 0;
  bool isDark = false;
  @override
  void initState() {
    super.initState();
    readSettings();
    _userCoursesFuture = _fetchUserCourses(widget.userId);
    _userFuture = _fetchUserProfile(widget.userId);
    _recommendedCoursesFuture = _fetchRecommendedCourses(widget.userId);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  bool loading = false;

  Future<double> _fetchProgressByCourseIndex(int courseId, int userId) async {
    final studentsResponse = await ApiService.getRequest('/api/Students');

    // Handle both cases: response as List or Map with "data"
    final List<Map<String, dynamic>> students = studentsResponse is List
        ? List<Map<String, dynamic>>.from(studentsResponse)
        : (studentsResponse is Map && studentsResponse.containsKey('data'))
            ? List<Map<String, dynamic>>.from(studentsResponse['data'])
            : throw Exception('Invalid students response format.');

    print('Students response: $students');

    // Find the matching student
    final matchingStudent = students.firstWhere(
      (student) => student['userId'] == userId,
      orElse: () =>
          throw Exception('No matching studentId for userId: $userId'),
    );

    final int? studentId = matchingStudent['studentId'];
    if (studentId == null) {
      throw Exception('Student ID is null for userId: $userId');
    }
    print('Matched studentId: $studentId');

    try {
      final response = await ApiService.getRequest(
          '/api/CourseProgress/$courseId/$studentId');
      if (response != null && response.containsKey('totalProgress')) {
        return response['totalProgress'];
      } else {
        return 0;
      }
    } catch (e) {
      print('Error fetching progress for course index : $e');
      return 0;
    }
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

  Future<UserModel> _fetchUserProfile(int userId) async {
    try {
      print('Fetching user profile for userId: $userId...');
      final userData = await ApiService.getUserProfile(userId);
      print('Fetched user profile: $userData');
      return userData;
    } catch (e) {
      print('Error fetching user profile: $e');
      throw Exception('Failed to load user profile.');
    }
  }

  Future<List<Course>> _fetchRecommendedCourses(int userId) async {
    try {
      print('Debug: Fetching user courses for userId $userId...');
      final recommendedCoursesData =
          await ApiService.recommendedCourses(userId);
      print('Debug: Raw course data fetched: $recommendedCoursesData');

      final recommendedCourses = recommendedCoursesData.map((data) {
        print('Debug: Processing course data: $data');
        return data['course'] as Course;
      }).toList();

      print('Debug: User courses successfully parsed: $recommendedCourses');
      return recommendedCourses;
    } catch (e) {
      print('Error fetching user courses: $e');
      throw Exception('Failed to load courses.');
    }
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    List<Widget> pages = <Widget>[
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  FutureBuilder<UserModel>(
                    future: _userFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            '${localizations!.anErrorOccured}  ${snapshot.error}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      } else if (!snapshot.hasData) {
                        return Center(
                          child: Text(
                            localizations!.userDataNotFound,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      } else {
                        final user = snapshot.data!;
                        print(user.id);
                        return Builder(
                          builder: (context) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 125,
                                      height: 125,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: Image.asset(
                                          "images/new_logo.png",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 45,
                                      top: 40,
                                      child: SizedBox(
                                        width: 55,
                                        height: 55,
                                        child: CircleAvatar(
                                          radius: 45,
                                          backgroundImage:
                                              NetworkImage(user.imageUrl!),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      localizations!.welcomeBack,
                                      style: TextStyle(
                                        color: isDark
                                            ? DarkTheme.textColor
                                            : LightTheme.textColor,
                                        fontSize: 12,
                                        fontFamily: 'DM Sans',
                                        fontWeight: FontWeight.w700,
                                        height: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          ('${user.firstName} ${user.lastName}'),
                                          style: TextStyle(
                                            color: isDark
                                                ? DarkTheme.textColor
                                                : LightTheme.textColor,
                                            fontSize: 14,
                                            fontFamily: 'DM Sans',
                                            fontWeight: FontWeight.w700,
                                            height: 1.2,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        const Icon(
                                          Icons.verified,
                                          color: Colors.blue,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 40),
                  SizedBox(
                    width: screenWidth * 0.13,
                    height: screenHeight * 0.03,
                    child: AnimatedToggleSwitch<bool>.dual(
                      current: isDark,
                      first: false,
                      second: true,
                      spacing: 5.0,
                      style: ToggleStyle(
                        backgroundColor: isDark ? Colors.black : Colors.white,
                        borderColor: Colors.transparent,
                        boxShadow: [
                          BoxShadow(
                            color: isDark ? Colors.white12 : Colors.black26,
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 1.5),
                          ),
                        ],
                      ),
                      borderWidth: 2.0,
                      height: 65,
                      onChanged: (b) => setState(() {
                        isDark = b;
                        saveSettings();
                      }),
                      styleBuilder: (b) => ToggleStyle(
                        indicatorColor: b ? Colors.black : Colors.white,
                      ),
                      iconBuilder: (value) => value
                          ? Icon(
                              Icons.dark_mode,
                              size: 20,
                              color: Colors.white,
                            )
                          : Icon(
                              Icons.light_mode,
                              size: 20,
                              color: Colors.black,
                            ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final shouldLogout = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(localizations!.confirmLogOut),
                            content: Text(localizations!.sureLogOut),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text(localizations!.no),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: Text(localizations!.yes),
                              ),
                            ],
                          );
                        },
                      );

                      if (shouldLogout == true) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => LoginSignupScreen()),
                          (route) => false,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: const CircleBorder(),
                    ),
                    child: Icon(
                      Icons.logout,
                      size: 24,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
              Container(
                width: screenWidth,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                  gradient: LinearGradient(
                    colors: isDark
                        ? DarkTheme.progressCardBackground
                        : LightTheme.progressCardBackground,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: const [
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      localizations!.yourProgressInCourses,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FutureBuilder<List<Course>>(
                      future: _userCoursesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text(
                                  '${localizations!.anErrorOccured}  ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(
                              child: Text(
                            localizations!.youDontHaveAnyRegisteredCoursesYet,
                            style: TextStyle(
                              color: isDark
                                  ? DarkTheme.textColor
                                  : LightTheme.textColor,
                            ),
                          ));
                        } else {
                          final userCourses = snapshot.data!;

                          return SizedBox(
                              height: 180,
                              child: ListView.builder(
                                itemCount: userCourses.length,
                                itemBuilder: (context, index) {
                                  final userCourseData = userCourses[index];
                                  final course = userCourseData;
                                  final authorName = course.authorId;

                                  return FutureBuilder<double>(
                                    future: _fetchProgressByCourseIndex(
                                        course.courseID, widget.userId),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return SizedBox(
                                          height: 100,
                                          child: Center(
                                              child: Text(
                                                  'Error: ${snapshot.error}')),
                                        );
                                      } else {
                                        final progress = snapshot.data ?? 0;
                                        print("PROGRESS: $progress");
                                        return SizedBox(
                                          height: 100,
                                          child: CourseCard(
                                            authorId: course.authorId!,
                                            courseName: course.name!,
                                            rating: course.rating!,
                                            levelId: course.levelId!,
                                            progress: progress,
                                            instructor: course.authorName ??
                                                course.authorId.toString(),
                                          ),
                                        );
                                      }
                                    },
                                  );
                                },
                              ));
                        }
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                child: Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    localizations!.recommendation,
                    style: TextStyle(
                      color:
                          isDark ? DarkTheme.textColor : LightTheme.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              FutureBuilder<List<Course>>(
                future: _recommendedCoursesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                      '${localizations!.anErrorOccured} ${snapshot.error}',
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        'localizations!.noAvailableCourses',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  } else {
                    final recommendedCourses = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recommendedCourses.length,
                      itemBuilder: (context, index) {
                        final course = recommendedCourses[index];
                        return FutureBuilder<List<Course>>(
                          future: _userCoursesFuture,
                          builder: (context, userCoursesSnapshot) {
                            if (userCoursesSnapshot.hasData &&
                                userCoursesSnapshot.data!.any((userCourse) =>
                                    userCourse.courseID == course.courseID)) {
                              return Container(); // Skip owned courses
                            }
                            return BuildCard(
                              price: course.price!,
                              courseImage: course.image!,
                              userId: widget.userId,
                              authorId: course.authorId!,
                              course: course,
                              authorName:
                                  course.authorId.toString() ?? 'Unknown',
                              icon: Icons.library_books,
                              courseName: course.name!,
                              description: course.description!,
                              rating: course.rating!,
                              level: course.levelId!,
                              isDark: isDark,
                              localizations: localizations,
                            );
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      SearchScreen(
        userId: widget.userId,
        isDark: isDark,
        localizations: localizations,
      ),
      UserCoursesScreen(
        userId: widget.userId,
        isDark: isDark,
        localizations: localizations,
      ),
      FavoritesPage(
        userId: widget.userId,
        isDark: isDark,
        localizations: localizations,
      ),
      FutureBuilder<UserModel>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No user data found'));
          } else {
            return ProfileScreen(
              user: snapshot.data!,
              isDark: isDark,
              localizations: localizations,
            );
          }
        },
      ),
    ];

    return WillPopScope(
      onWillPop: _onWillPop,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
              backgroundColor: isDark
                  ? DarkTheme.backgroundColor
                  : LightTheme.backgroundColor,
              appBar: AppBar(
                toolbarHeight: 1,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                centerTitle: true,
              ),
              body: pages[_selectedIndex],
              bottomNavigationBar: CustomBottomNavigationBar(
                isDark: isDark,
                selectedIndex: _selectedIndex,
                onItemTapped: _onItemTapped,
                backgroundColor: Colors.black,
              ))),
    );
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return false;
    } else {
      return true;
    }
  }

  Future<void> saveSettings() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setBool('isDark', isDark);
  }

  Future<void> readSettings() async {
    final preferences = await SharedPreferences.getInstance();
    setState(() {
      isDark = preferences.getBool('isDark') ?? true;
    });
  }
}
