import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber_security_app/models/course.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../build_card.dart';
import '../course_detail/course_detail_screen.dart';

class FavoritesPage extends StatefulWidget {
  final String userId;
  final bool isDark;

  const FavoritesPage({Key? key, required this.userId,required this.isDark}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Future<List<Map<String, dynamic>>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _favoritesFuture = fetchFavorites(widget.userId);
  }

  Future<List<Map<String, dynamic>>> fetchFavorites(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        List<dynamic> favorites = userDoc.data()?['favorites'] ?? [];
        return favorites.map((favorite) => Map<String, dynamic>.from(favorite)).toList();
      }
      return [];
    } catch (e) {
      print("Favori verileri alınırken hata oluştu: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'My Favorites Courses',
            style: TextStyle(
              color: widget.isDark?  Colors.white : Colors.black,
              fontSize: 18,
              fontFamily: 'Prompt',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: widget.isDark? Colors.black :Colors.white,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: FutureBuilder<List<Map<String, dynamic>>>(

          future: _favoritesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Bir hata oluştu."));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("Henüz favori eklemediniz."));
            }

            final favorites = snapshot.data!;
            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final favorite = favorites[index];
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('authors')
                      .doc(favorite['authorId'])
                      .get(),
                  builder: (context, authorSnapshot) {
                    if (authorSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (authorSnapshot.hasError || !authorSnapshot.hasData || !authorSnapshot.data!.exists) {
                      return Center(child: Text("Yazar bilgisi alınamadı."));
                    }

                    final authorData = authorSnapshot.data!.data() as Map<String, dynamic>;
                    final authorName = authorData['name'] ?? 'Bilinmeyen Yazar';

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('authors')
                          .doc(favorite['authorId'])
                          .collection('courses')
                          .doc(favorite['courseId'])
                          .get(),
                      builder: (context, courseSnapshot) {
                        if (courseSnapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (courseSnapshot.hasError || !courseSnapshot.hasData || !courseSnapshot.data!.exists) {
                          return Center(child: Text("Kurs bilgisi alınamadı."));
                        }

                        final course = Course.fromFirestore(courseSnapshot.data!);

                        return BuildCard(
                          userId: widget.userId,
                          authorId: favorite['authorId'],
                          sectionId: '',
                          course: course,
                          authorName: authorName, // Burada çekilen yazar adı kullanılıyor
                          icon: FontAwesomeIcons.graduationCap,
                          courseName: course.name,
                          description: course.description,
                          rating: course.rating,
                          level: course.level,
                          isDark: widget.isDark,
                        );
                      },
                    );
                  },
                );

              },
            );
          },
        ),
      ),

    );
  }
}
