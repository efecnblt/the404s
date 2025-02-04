import 'package:cyber_security_app/models/video.dart';

class Section {
  final int sectionID;
  final int courseID;
  final int? order;
  final String? title;
  final List<Video> videos;

  Section({
    required this.sectionID,
    required this.courseID,
    this.order,
    this.title,
     required this.videos,
  });

  

  factory Section.fromMap(Map<String, dynamic> map) {
    return Section(
      sectionID: map['sectionID'],
      title: map['title'] ?? '',
      courseID: map['courseID'] ?? 0,
      videos: map['videos'] != null
          ? List<Video>.from(map['videos'].map((data) => Video.fromMap(data)))
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sectionID': sectionID,
      'courseID': courseID,
      'order': order,
      'title': title,
    };
  }
}
