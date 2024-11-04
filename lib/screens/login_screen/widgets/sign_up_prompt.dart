import 'package:flutter/material.dart';
import '../../../constants/styles.dart';
import '../../../generated/l10n.dart';
import '../../sign_up/sign_up.dart';

class SignUpPrompt extends StatelessWidget {
  final double fontSize;

  const SignUpPrompt({super.key, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          S.of(context).noAccount,
          style: AppTextStyles.labelTextStyle(fontSize),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpScreen()),
            );
          },
          child: Text(
            S.of(context).signup,
            style: AppTextStyles.linkTextStyle(fontSize),
          ),
        ),
      ],
    );
  }
}
