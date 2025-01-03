import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:cyber_security_app/screens/login_or_signup_screen.dart';
import 'package:cyber_security_app/widgets/course_card.dart';
import 'package:cyber_security_app/screens/favorite_screen/favoritesModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/course.dart';
import '../../models/user_model.dart';
import '../../models/users.dart';
import '../../services/auth_service.dart';
import '../../widgets/bottom_navigation_bar.dart';
import '../app_theme.dart';
import '../build_card.dart';
import '../profile_screen.dart';
import 'package:cyber_security_app/models/users.dart' as app_user;
import 'package:shared_preferences/shared_preferences.dart';
import '../search_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cyber_security_app/main.dart';

class Dashboard extends StatefulWidget {
  final UserModel user;
  static const String id = "dashboard_screen";

  const Dashboard({super.key, required this.user});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Future<List<Map<String, dynamic>>> _userCoursesFuture;
  final List<Map<String, dynamic>> _userCourses = [];
  
  int _selectedIndex = 0;
  bool _isDarkTheme = true;
  int value = 0;
  late Future<app_user.User> _userFuture;

  @override
  void initState() {
    super.initState();
    readSettings();
   
    _userCoursesFuture = AuthService.fetchUserCourses();
    _userFuture = AuthService.getUserData(widget.user.userId);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleTheme(bool value) {
    setState(() {
      _isDarkTheme = value;
    });
  }

  bool isDark = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    print("Current User:  ${widget.user.userId}");
    
    // Ekran boyutlarını al
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    // Sayfaları tanımla
    List<Widget> pages = <Widget>[
      // Ana sayfa
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          // Ayarlanan padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              const SizedBox(height: 10), // Üstten boşluk
              Row(
                
                children: [
                  FutureBuilder<app_user.User>(
                      future: _userFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
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
                                                NetworkImage(widget.user.imageUrl),
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
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            '${widget.user.username} ',
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
                                          SizedBox(width: 5),
                                          Icon(
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
                            }
                          );
                        }
                      }),
                      SizedBox(width:80 ,),
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
                  SizedBox(width: 10,),
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
            onPressed: () => Navigator.of(context).pop(false), // Hayır
            child: Text(localizations!.no),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Evet
            child: Text(localizations!.yes),
          ),
        ],
      );
    },
  );

  if (shouldLogout == true) {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginSignupScreen()),
      (route) => false,
    );
  }
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent, // Arka planı saydam yapar
    shadowColor: Colors.transparent, // Gölgeyi saydam yapar
    shape: const CircleBorder(), // Yuvarlak şekil
     // Boyut ayarı
  ),
  child: Icon(
    Icons.logout,
    size: 24, // İkon boyutu
    color: isDark ? Colors.white : Colors.black, // İkon rengi
  ),
),
                ],
              ),
              Container(
                width: screenWidth,
                padding: EdgeInsets.all(16),
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
                  boxShadow: [
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
                    SizedBox(
                      height: 20,
                    ),
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: AuthService.fetchUserCourses(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // Veriler yükleniyor
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          // Hata oluştu
                          return Center(
                              child:
                                  Text( '${localizations!.anErrorOccured}  ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          // Veri yok
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
                          // Veriler yüklendi
                          final userCourses = snapshot.data!;

                          return SizedBox(
                            height: 180,
                            // Sabit bir yükseklik vererek kaydırılabilir alanı sınırlıyoruz
                            child: ListView.builder(
                              itemCount: userCourses.length,
                              itemBuilder: (context, index) {
                                final userCourseData = userCourses[index];
                                final course =
                                    userCourseData['course'] as Course;
                                final progress =
                                    userCourseData['progress'] as double;
                                final authorName =
                                    userCourseData['authorName'] as String;

                                return Dismissible(
                                  key: ValueKey(course
                                      .id), // course.id benzersiz bir tanımlayıcı
                                  // Her kurs için benzersiz bir key
                                  direction: DismissDirection.endToStart,
                                  // Sağdan sola kaydırma
                                  background: Container(
                                    color: Colors.red,
                                    // Kaydırma sırasında kırmızı arkaplan
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: const Icon(Icons.delete,
                                        color: Colors.white),
                                  ),
                                  onDismissed: (direction) {
                                    // Kart silindiğinde yapılacak işlemler
                                    setState(() {
                                      _userCourses.removeAt(index);
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('${course.name} ${localizations!.removed}')),
                                    );
                                  },
                                  child: SizedBox(
                                    height: 100, // Sabit kart yüksekliği
                                    child: CourseCard(
                                      courseName: course.name,
                                      rating: course.rating,
                                      level: course.level,
                                      progress: progress,
                                      instructor: authorName,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 20,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            strokeAlign: BorderSide.strokeAlignCenter,
                            color: isDark
                                ? DarkTheme.textColor.withOpacity(0.5)
                                : LightTheme.textColor.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      localizations!.recommendation,
                      style: TextStyle(
                        color:
                            isDark ? DarkTheme.textColor : LightTheme.textColor,
                        fontSize: 18,
                        fontFamily: 'Prompt',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 20,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            strokeAlign: BorderSide.strokeAlignCenter,
                            color: isDark
                                ? DarkTheme.textColor.withOpacity(0.5)
                                : LightTheme.textColor.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              StreamBuilder<List<Map<String, dynamic>>>(
                stream: AuthService.fetchAllCourses(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Veriler yükleniyor
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    // Hata oluştu
                    return Center(
                      child: Text(
                        '${localizations!.anErrorOccured} ${snapshot.error}',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    // Veri yok
                    return Center(
                      child: Text(
                        localizations!.youDontHaveAnyRegisteredCoursesYet,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  } else {
                    // Veriler yüklendi
                    final allCoursesWithAuthor = snapshot.data!;

                    return ListView.builder(
                      shrinkWrap: true,
                      // ListView'ın yalnızca içeriği kadar yer kaplamasını sağlar
                      physics: const NeverScrollableScrollPhysics(),
                      // ListView'ın kendi kaydırmasını engeller
                      itemCount: allCoursesWithAuthor.length,
                      itemBuilder: (context, index) {
                        final courseData = allCoursesWithAuthor[index];
                        final course = courseData['course'] as Course;
                        final authorId = courseData['authorId'] as String;
                        final authorName = courseData['authorName'] as String;

                        return FutureBuilder<List<Map<String, dynamic>>>(
                          future: AuthService.fetchSectionsForCourse(authorId,
                              course.id), // Fetch sections dynamically
                          builder: (context, sectionSnapshot) {
                            if (sectionSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (sectionSnapshot.hasError) {
                              return Text(localizations!.errorFethingSections);
                            } else if (!sectionSnapshot.hasData ||
                                sectionSnapshot.data!.isEmpty) {
                              return Text(localizations!.noSectionFound,style: TextStyle(color: isDark? Colors.white:Colors.black),);
                            } else {
                              // Sections loaded
                              final sections = sectionSnapshot.data!;
                              String? sectionId;

                              // Get the first sectionId (if any)
                              if (sections.isNotEmpty) {
                                sectionId = sections[0][
                                    'sectionId']; // Assume each section has a sectionId
                              } else {
                                sectionId =
                                    localizations!.noSectionFound; // Handle missing sections
                              }
                              return BuildCard(
                                userId: widget.user.userId,
                                authorId: authorId,
                                sectionId: sectionId ??
                                    'No Section', // Handle null cases
                                course: course,
                                authorName: authorName,
                                icon: FontAwesomeIcons.graduationCap,
                                courseName: course.name,
                                description: course.description,
                                rating: course.rating,
                                level: course.level,
                                isDark: isDark,
                                localizations: localizations,
                              );
                            }
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
        userId: widget.user.userId,
        isDark: isDark,
        localizations: localizations,
      ),
      FavoritesPage(
        userId: widget.user.userId,
        isDark: isDark,
        localizations: localizations,
      ),
      FavoritesPage(
        userId: widget.user.userId,
        isDark: isDark,
        localizations: localizations,
      ),
      ProfileScreen(
        userId: widget.user.userId,
        isDark: isDark,
        localizations: localizations,
      ),
    ];

    return WillPopScope(
      onWillPop: _onWillPop,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor:
                isDark ? DarkTheme.backgroundColor : LightTheme.backgroundColor,
            appBar: AppBar(
              toolbarHeight: 1,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              centerTitle: true,
            ),
            body: pages[_selectedIndex], // Seçilen sayfayı göster
            bottomNavigationBar: CustomBottomNavigationBar(
              isDark: isDark,
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
              backgroundColor: Colors.black,
            )),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0; // Ana sayfaya dön
      });
      return false; // Uygulamadan çıkmayı engelle
    } else {
      return true; // Uygulamadan çıkmaya izin ver
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
      // Settings are loaded
    });
  }
}
