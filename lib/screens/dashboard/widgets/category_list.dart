import 'package:flutter/material.dart';
import '../../../models/category.dart';
import '../../../constants/styles.dart';

class CategoryList extends StatelessWidget {
  final List<Category> categories;

  const CategoryList({super.key, required this.categories});

  void _onCategoryTap(int index) {
    print('Kategori $index tıklandı!');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Kategoriler başlığı
        const Padding(
          padding: EdgeInsets.only(left: 20, top: 25),
          child: Text(
            "Kategoriler",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              onTap: () => _onCategoryTap(index),
              child: ListTile(
                leading: category.icon,
                title: Text(
                  category.title,
                  style: AppTextStyles.categoryTitleStyle,
                ),
                subtitle: Text(
                  category.description,
                  style: AppTextStyles.categoryDescriptionStyle,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
