class Course {
  final int courseID;
  final String? name;
  int? categoryId;
  final String? description;
  final int? authorId;
  final double? rating;
  final int? ratingCount;
  final double? price;
  final double? discount;
  final int? totalStudentCount;
  final String? image;
  final String? hashtags;
  final int? levelId;
  String? authorName;
  String? categoryName;

  Course({
    required this.courseID,
    this.name,
    this.categoryId,
    this.description,
    this.authorId,
    this.rating,
    this.ratingCount,
    this.price,
    this.discount,
    this.totalStudentCount,
    this.image,
    this.hashtags,
    this.levelId,
    this.authorName,
    this.categoryName
  });

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      courseID: map['courseID'] ?? 0,
      name: map['name'],
      categoryId: map['categoryId'],
      description: _cleanDescription(map['description']),
      authorId: map['authorId'],
      rating: (map['rating'] as num?)?.toDouble(),
      ratingCount: map['ratingCount'],
      price: (map['price'] as num?)?.toDouble(),
      discount: (map['discount'] as num?)?.toDouble(),
      totalStudentCount: map['totalStudentCount'],
      image: map['image'],
      hashtags: map['hashtags'],
      levelId: map['levelId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'courseID': courseID,
      'name': name,
      'categoryId': categoryId,
      'description': description,
      'authorId': authorId,
      'rating': rating,
      'ratingCount': ratingCount,
      'price': price,
      'discount': discount,
      'totalStudentCount': totalStudentCount,
      'image': image,
      'hashtags': hashtags,
      'levelId': levelId,
    };
  }

    static String _cleanDescription(String? description) {
    if (description == null) return '';
    // Remove [n] patterns from the description
    return description.replaceAll(RegExp(r'\[\d+\]'), '').trim();
  }
}
