class Category {
  final int categoryId;
  final String? name;
  final String? description;

  Category({
    required this.categoryId,
    this.name,
    this.description,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      categoryId: map['categoryId'] ?? 0,
      name: map['name'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'name': name,
      'description': description,
    };
  }
}
