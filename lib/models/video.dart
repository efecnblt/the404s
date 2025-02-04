class Video {
  final int videoID;
  final int sectionID;
  final int? order;
  final String? title;
  final int? duration;
  final String? url;

  Video({
    required this.videoID,
    required this.sectionID,
    this.order,
    this.title,
    this.duration,
    this.url,
  });

  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
      videoID: map['videoID'] ?? 0,
      sectionID: map['sectionID'] ?? 0,
      order: map['order'],
      title: map['title'],
      duration: map['duration'],
      url: map['url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'videoID': videoID,
      'sectionID': sectionID,
      'order': order,
      'title': title,
      'duration': duration,
      'url': url,
    };
  }
}
