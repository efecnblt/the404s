class Author {
  final int authorID;
  final String? name;
  final String? biography;
  final int? departmentID;
  final double? rating;
  final int? studentCount;
  final int? courseCount;
  final String? imageURL;
  String? departmentName;

  Author({
    required this.authorID,
    this.name,
    this.biography,
    this.departmentID,
    this.rating,
    this.studentCount,
    this.courseCount,
    this.imageURL,
    this.departmentName,
  });

  factory Author.fromMap(Map<String, dynamic> map) {
    return Author(
      authorID: map['authorID'] ?? 0,
      name: map['name'],
      biography: map['biography'],
      departmentID: map['departmentID'],
      rating: (map['rating'] as num?)?.toDouble(),
      studentCount: map['studentCount'],
      courseCount: map['courseCount'],
      imageURL: map['imageURL'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'authorID': authorID,
      'name': name,
      'biography': biography,
      'departmentID': departmentID,
      'rating': rating,
      'studentCount': studentCount,
      'courseCount': courseCount,
      'imageURL': imageURL,
    };
  }
}
