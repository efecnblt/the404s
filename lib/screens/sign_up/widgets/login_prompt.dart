import 'package:flutter/material.dart';
import '../../../constants/styles.dart';
import '../../login_screen/login_screen.dart';

class LoginPrompt extends StatelessWidget {
  final double screenWidth;

  const LoginPrompt({
    super.key,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            "Already have an account?",
            style: AppTextStyles.labelTextStyle(screenWidth * 0.05)
                .copyWith(color: Colors.white),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, LoginScreen.id);
            },
            child: Text(
              "Login",
              style: AppTextStyles.linkTextStyle(screenWidth * 0.05),
            ),
          ),
        ],
      ),
    );
  }
}
