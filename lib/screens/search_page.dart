import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/course.dart';
import 'build_card.dart';

class SearchPage extends StatefulWidget {
  final String? searchHashtag; // Aranacak hashtag
  final String userId; // Kullanıcı ID'si, eklendi
  final Course course;
  final String authorId;
  final String sectionId;

  const SearchPage(
      {super.key,
      required this.searchHashtag,
      required this.userId,
      required this.course,
      required this.authorId,
      required this.sectionId});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String, dynamic>> matchingCourses =
      []; // Eşleşen kursları tutmak için
  String searchTerm = ''; // Arama çubuğu için manuel terim

  @override
  void initState() {
    super.initState();
    if (widget.searchHashtag != null) {
      // Otomatik arama hashtag'e göre başlatılıyor
      searchCourses(widget.searchHashtag!);
    }
  }

  // Veritabanında hashtag ile eşleşen kursları bulma fonksiyonu
  // Veritabanında hashtag ile eşleşen kursları bulma fonksiyonu
  Future<void> searchCourses(String searchTerm) async {
    QuerySnapshot authorsSnapshot =
        await FirebaseFirestore.instance.collection('authors').get();

    List<Map<String, dynamic>> results = [];

    for (var authorDoc in authorsSnapshot.docs) {
      var coursesSnapshot =
          await authorDoc.reference.collection('courses').get();

      for (var courseDoc in coursesSnapshot.docs) {
        List<dynamic> hashtags = courseDoc['hashtags'];
        String courseName = courseDoc['name'];

        // Eğer manuel terim veya hashtag varsa filtreleme yapılıyor
        if (hashtags.contains(searchTerm) ||
            courseName.toLowerCase().contains(searchTerm.toLowerCase())) {
          results.add({
            'authorName': authorDoc['name'],
          });
        }
      }
    }

    setState(() {
      matchingCourses = results; // Sonuçları güncelle
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Explore"),
      ),
      body: SafeArea(
        child: matchingCourses.isEmpty
            ? Center(
                child: CircularProgressIndicator()) // Yükleniyor animasyonu
            : Container(
                decoration: ShapeDecoration(
                  color: Color(0xFFE1E1E1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 10, top: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Results for \"${widget.searchHashtag}\"",
                            style: TextStyle(
                              color: Color(0xFF161719),
                              fontSize: 16,
                              fontFamily: 'Prompt',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          Text(
                            "Total searches: ${matchingCourses.length}",
                            style: TextStyle(
                              color: Color(0xFF888888),
                              fontSize: 16,
                              fontFamily: 'Prompt',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Toplam kurs sayısı
                    Expanded(
                      child: ListView.builder(
                        itemCount: matchingCourses.length,
                        itemBuilder: (context, index) {
                          final courseData = matchingCourses[index];

                          return BuildCard(
                            userId: widget.userId,
                            authorId: widget.authorId,
                            sectionId: widget.sectionId,
                            // Handle null cases
                            course: widget.course,
                            authorName: courseData['authorName'],
                            icon: FontAwesomeIcons.graduationCap,
                            courseName: widget.course.name,
                            description: widget.course.description,
                            rating: widget.course.rating,
                            level: widget.course.level,
                            isDark: true,
                          );
                        },
                      ),
                    )
                  ],
                )),
      ),
    );
  }
}
