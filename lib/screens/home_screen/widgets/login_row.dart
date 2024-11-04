import 'package:flutter/material.dart';
import '../../../../constants/styles.dart';
import '../../login_screen/login_screen.dart';

class LoginRow extends StatelessWidget {
  final double fontSize;

  const LoginRow({super.key, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: AppTextStyles.infoTextStyle(fontSize),
        ),
        GestureDetector(
          onTap: () {
            //Navigator.pushNamed(context, LoginScreen.id);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ));
          },
          child: Text(
            "Log in",
            style: AppTextStyles.linkTextStyle(fontSize),
          ),
        ),
      ],
    );
  }
}
