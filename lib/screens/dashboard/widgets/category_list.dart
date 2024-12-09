import 'package:flutter/material.dart';
import '../../../models/category.dart';
import '../../../constants/styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoryList extends StatelessWidget {
  final List<Category> categories;
  final AppLocalizations? localizations;    
  const CategoryList({super.key, required this.categories,required this.localizations});

  void _onCategoryTap(int index) {
    print('Kategori $index tıklandı!');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Kategoriler başlığı
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 25),
          child: Text(
            localizations!.categories,
            style: const TextStyle(
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
