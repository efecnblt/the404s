import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/auth_service.dart';
import '../widgets/course_card.dart';
import 'app_theme.dart';
import 'course_detail/course_detail_screen.dart';

class CourseListItem extends StatefulWidget {
  final Course course;
  final bool isDark;
  final IconData icon;
  final String authorName;
  final String authorId;
  final String sectionId; // Add sectionId
  final String userId; // Add sectionId
  CourseListItem(
      {super.key,
      required this.course,
      required this.isDark,
      required this.icon,
      required this.authorName,
      required this.authorId,
      required this.userId,
      required this.sectionId});
  List<Color> colors = [
    Color(0xffFE7E7E),
    Color(0xffC81004),
    Color(0xffA03C2E),
    Color(0xffB73E23),
    Color(0xffF65C2B),
    Color(0xffF04B04),
    Color(0xffB5673C),
    Color(0xffAE4D07),
    Color(0xffAA5C15),
    Color(0xffDB7C0C),
    Color(0xffA97F41),
    Color(0xffF4BA49),
    Color(0xffC58F04),
    Color(0xffCFB636),
    Color(0xffA89845),
    Color(0xffB6A615),
    Color(0xffDAD561),
    Color(0xffC7C945),
    Color(0xff9FA64F),
    Color(0xffB5D202),
    Color(0xff9DAF46),
    Color(0xff9DD402),
    Color(0xffABD454),
    Color(0xffA5D359),
    Color(0xff4A8202),
    Color(0xff59AA07),
    Color(0xff429B08),
    Color(0xff56803B),
    Color(0xff67CB37),
    Color(0xff44B01E),
    Color(0xff329919),
    Color(0xff48A938),
    Color(0xff13C504),
    Color(0xff0BF206),
    Color(0xff00CA08),
    Color(0xff03B215),
    Color(0xff52CB65),
    Color(0xff2A9241),
    Color(0xff0AD643),
    Color(0xff2FC863),
    Color(0xff45A36B),
    Color(0xff60FEA8),
    Color(0xff018344),
    Color(0xff13B06F),
    Color(0xff4CA887),
    Color(0xff65FCCD),
    Color(0xff2C957B),
    Color(0xff5AC0AD),
    Color(0xff1A877A),
    Color(0xff208E87),
    Color(0xff30CDCD),
    Color(0xff3D9AA0),
    Color(0xff247C88),
    Color(0xff218095),
    Color(0xff59C5E8),
    Color(0xff1180AF),
    Color(0xff2F92CA),
    Color(0xff4BA0DD),
    Color(0xff5F9CD4),
    Color(0xff2F5A8D),
    Color(0xff3577DA),
    Color(0xff2668E7),
    Color(0xff1D3C8D),
    Color(0xff1738AE),
    Color(0xff495AB3),
    Color(0xff7885F9),
    Color(0xff2F339A),
    Color(0xff130FDA),
    Color(0xff433AA0),
    Color(0xff2D14C8),
    Color(0xff392588),
    Color(0xff5528D8),
    Color(0xff6328E0),
    Color(0xff5F0EE3),
    Color(0xff5714AB),
    Color(0xff5406A2),
    Color(0xff7C48A4),
    Color(0xffA517FC),
    Color(0xffB013FA),
    Color(0xff772993),
    Color(0xff712884),
    Color(0xffDB1FF9),
    Color(0xff901F9B),
    Color(0xffC35BC5),
    Color(0xffBC2AB7),
    Color(0xff9B3E91),
    Color(0xffDE44C5),
    Color(0xffC14EA8),
    Color(0xffF466CC),
    Color(0xffCC138D),
    Color(0xffE773B8),
    Color(0xff9C4172),
    Color(0xffD84B8E),
    Color(0xffCB3B77),
    Color(0xffDB457B),
    Color(0xffDA1550),
    Color(0xffFC6287),
    Color(0xffF43A5B),
    Color(0xffD80F27),
    Color(0xffBA2931)
  ];

  @override
  State<CourseListItem> createState() => _CourseListItemState();
}

class _CourseListItemState extends State<CourseListItem> {
  @override
  void initState() {
    super.initState();
    checkIfCourseIsInFavorites();
  }

  static final FirebaseAuth _auth = FirebaseAuth.instance;
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

  @override
  Widget build(BuildContext context) {
    Random random = Random();
    int pickColor = random.nextInt(colors.length);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailPage(
              course: widget.course,
              isDark: true,
              authorId: widget.authorId,
              sectionId: widget.sectionId,
              userId: widget.userId,
            ),
          ),
        );
      },
      child: Dismissible(
        key: ValueKey(widget.course.id), // Benzersiz bir anahtar gereklidir
        direction: DismissDirection
            .endToStart, // Kartı sadece sağa kaydırmaya izin veriyoruz
        confirmDismiss: (direction) async {
          toggleFavorite(); // Kartın kaydırılması sırasında favori durumunu değiştiriyoruz
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isFavorite
                  ? 'Favorilerden kaldırıldı'
                  : 'Favorilere eklendi'),
              duration: Duration(seconds: 2),
            ),
          );
          return false;
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: 20),
          color:
              Colors.red, // Kaydırma işlemi sırasında görünen arka plan rengi
          child: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: Colors.white,
          ),
        ),
        child: Container(

          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          padding: const EdgeInsets.all(15),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            shadows: [
              BoxShadow(
                color: widget.isDark
                    ? Colors.transparent
                    : LightTheme.shadowColor,
                blurRadius: 2,
              )
            ],
            color: widget.isDark
                ? Colors.white
                : LightTheme.cardBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.height * 0.085,
                height: MediaQuery.of(context).size.height * 0.085,
                decoration: ShapeDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(0.67, 0.75),
                    end: Alignment(-0.67, -0.75),
                    colors: [colors[pickColor], colors[pickColor]],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Icon(
                  widget.icon,
                  size: MediaQuery.of(context).size.height * 0.05,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.course.name,
                        style: TextStyle(
                          color: widget.isDark
                              ? Colors.black
                              : LightTheme.textColor,
                          fontFamily: "Prompt",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        widget.course.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: widget.isDark
                              ? Color(0xFF161719)
                              : LightTheme.subTitleColor,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber,
                          ),
                          Text(widget.course.rating.toString(),
                              style: TextStyle(
                                  color: widget.isDark
                                      ? Colors.black
                                      : LightTheme.textColor,
                                  fontWeight: FontWeight.bold)),
                          _buildDot(),
                          Text(
                            widget.authorName,
                            style: TextStyle(
                              color: widget.isDark
                                  ? Color(0xFF90909F)
                                  : LightTheme.instructorAndLevel,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          _buildDot(),
                          Text(
                            widget.course.level,
                            style: TextStyle(
                              color: widget.isDark
                                  ? Color(0xFF90909F)
                                  : LightTheme.instructorAndLevel,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildDot() {
  return Container(
    width: 3,
    height: 3,
    decoration: const BoxDecoration(
      color: Colors.grey,
      shape: BoxShape.circle,
    ),
  );
}