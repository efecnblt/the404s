import 'package:flutter/material.dart';

class LightTheme {
  static const Color backgroundColor = Colors.white;
  static const Color textColor = Colors.black;
  static Color subTitleColor = Colors.grey;
  static const Color fieldBackgroundColor = Color(0xD0FFFFFF);
  static const Color shadowColor = Color(0xFFE3E3E3);

  //Dashboard Req.
  static const Color cardBackgroundColor = Color(0xFFF5F5F5);
  static const List<Color> progressCardBackground = [
    Color(0xFF21C8F6),
    Color(0xFF637BFF)
  ];
  static const Color instructorAndLevel = Color(0xFF90909F);
}

class DarkTheme {
  static const Color backgroundColor = Colors.black;
  static const Color textColor = Colors.white;
  static Color subTitleColor = Colors.white;
  static const Color fieldBackgroundColor = Color(0xFF222222);
  static const Color shadowColor = Color(0xff5d5d5d);

  //Dashboard Req.
  static const Color cardBackgroundColor = Color(0xFF2F2F2F);
  static const List<Color> progressCardBackground = [
    Color(0xFF2F2F2F),
    Color(0xFF2F2F2F)
  ];
  static const Color instructorAndLevel = Color(0xFF90909F);
}
