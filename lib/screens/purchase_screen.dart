import 'package:cyber_security_app/screens/build_card.dart';
import 'package:flutter/material.dart';
import '../../../models/course.dart';
import '../../../services/api_services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PurchaseScreen extends StatelessWidget {
  final Course course;
  final bool isDark;
  final int userId;
  final AppLocalizations? localizations;

  const PurchaseScreen({
    Key? key,
    required this.course,
    required this.isDark,
    required this.userId,
    required this.localizations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalPrice = course.price! - course.discount!;
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : Colors.black,
        ),
        title: Text(
          localizations!.purchase,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
        backgroundColor: isDark ? Colors.grey[900] : Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Card (Static, non-clickable)
            BuildCard(
                courseName: course.name!,
                description: course.description!,
                rating: course.rating!,
                level: course.levelId!,
                icon: Icons.book,
                isDark: isDark,
                course: course,
                authorName: course.authorId.toString(),
                authorId: course.authorId!,
                userId: userId,
                localizations: localizations,
                courseImage: course.image!,
                price: course.price!),
            SizedBox(height: 20),
            // Price Details
            Text(
              '${localizations!.price} \$${course.price}',
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 8),
            if (course.discount != null && course.discount! > 0)
              Text(
                '${localizations!.discountPrice} \$${course.discount}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
            SizedBox(height: 40),

            Text(
              '${localizations!.totalPrice} \$ ${totalPrice.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            // Purchase Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                onPressed: () async {
                  try {
                    final int? studentId =
                        await ApiService.getStudentIdByUserId(userId);
                    if (studentId != null) {
                      await ApiService.postRequest(
                        '/api/Courses/enroll?studentId=$studentId&courseId=${course.courseID}',
                        {},
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(localizations!.purchaseSuccess)),
                      );
                    } else {
                      throw Exception('Failed to get student ID.');
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(localizations!.purchaseFail)),
                    );
                  }
                },
                child: Text(
                  localizations!.purchaseNow,
                  style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
