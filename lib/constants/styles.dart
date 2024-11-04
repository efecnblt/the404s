import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  static TextStyle welcomeTextStyle(double fontSize) => TextStyle(
        color: AppColors.primaryColor,
        fontSize: fontSize,
        fontFamily: "Jersey10",
      );

  static TextStyle animatedTextStyle(double fontSize) => TextStyle(
        fontSize: fontSize,
        fontFamily: "Jersey10",
        color: AppColors.accentColor,
        height: 0.7,
      );

  static TextStyle subtitleTextStyle(double fontSize) => TextStyle(
        color: AppColors.accentColor,
        fontSize: fontSize,
        fontFamily: "Jersey10",
        height: 0.9,
      );

  static TextStyle buttonTextStyle(double fontSize) => TextStyle(
        color: AppColors.textColor,
        fontSize: fontSize,
        fontFamily: "Jersey10",
      );

  static TextStyle infoTextStyle(double fontSize) => TextStyle(
        fontSize: fontSize,
        fontFamily: "Jersey10",
        color: AppColors.textColor,
      );

  static TextStyle linkTextStyle(double fontSize) => TextStyle(
        fontSize: fontSize,
        fontFamily: "Jersey10",
        color: AppColors.accentColor,
      );

  static TextStyle sectionTitleStyle(double fontSize) => TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: AppColors.accentColor,
      );
  static TextStyle bodyTextStyle(double fontSize) => TextStyle(
    fontSize: fontSize,
    color: AppColors.textColor,
  );
  static TextStyle videoTitleStyle (double fontSize) => TextStyle(
    fontSize: fontSize,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
  );
  static TextStyle videoDescriptionStyle = const TextStyle(
    fontSize: 14,
    color: Colors.grey,
  );
  static TextStyle categoryTitleStyle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
  );
  static TextStyle categoryDescriptionStyle = const TextStyle(
    fontSize: 14,
    color: Colors.grey,
  );

  static TextStyle headingTextStyle(double fontSize) => TextStyle(
        color: AppColors.textColor,
        fontSize: fontSize,
        fontFamily: "Jersey10",
      );

  static TextStyle hintTextStyle(double fontSize) => TextStyle(
        color: Colors.grey,
        fontFamily: "Jersey10",
        fontSize: fontSize,
      );

  static TextStyle labelTextStyle(double fontSize) => TextStyle(
        color: Colors.black54,
        fontFamily: "Jersey10",
        fontSize: fontSize,
      );

  static TextStyle errorTextStyle(double fontSize) => TextStyle(
        color: AppColors.errorColor,
        fontSize: fontSize,
      );
}
