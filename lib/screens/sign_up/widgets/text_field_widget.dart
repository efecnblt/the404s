import 'package:flutter/material.dart';
import '../../../constants/styles.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final double screenWidth;
  final double screenHeight;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const TextFieldWidget({
    super.key,
    required this.controller,
    required this.labelText,
    required this.screenWidth,
    required this.screenHeight,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: AppTextStyles.labelTextStyle(screenWidth * 0.05),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          floatingLabelStyle: AppTextStyles.labelTextStyle(screenWidth * 0.05),
          contentPadding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.015,
            horizontal: screenWidth * 0.05,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
