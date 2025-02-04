import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordField extends StatelessWidget {
  final double fontSize;
  final TextEditingController controller;
  final Color fieldBackgroundColor;
  final Color textColor;
  final Color hintTextColor;
  final Color shadowColor;

  const PasswordField({
    super.key,
    required this.fontSize,
    required this.controller,
    required this.fieldBackgroundColor,
    required this.textColor,
    required this.hintTextColor,
    required this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: fieldBackgroundColor,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: shadowColor.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: TextField(
            textAlign: TextAlign.center,
            style: TextStyle(color: textColor),
            controller: controller,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)?.enterPassword ??
                  "Enter your password",
              hintStyle: TextStyle(color: hintTextColor),
              contentPadding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.015,
                horizontal: screenWidth * 0.05,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
