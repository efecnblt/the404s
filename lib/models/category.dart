import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Category {
  final String id;
  final String title;
  final String description;
  final IconData iconData;
  final List<String> courseIds;

  Category({
    required this.id,
    required this.title,
    required this.description,
    required this.iconData,
    required this.courseIds,
  });

  factory Category.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Category(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      iconData: IconData(data['icon_code'] ?? 0, fontFamily: 'MaterialIcons'),
      courseIds: List<String>.from(data['courseIds'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'icon_code': iconData.codePoint,
      'courseIds': courseIds,
    };
  }

  Icon get icon => Icon(iconData);
}