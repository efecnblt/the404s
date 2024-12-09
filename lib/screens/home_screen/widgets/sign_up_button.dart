import 'package:flutter/material.dart';
import '../../../../constants/styles.dart';
import '../../sign_up/sign_up.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpButton extends StatelessWidget {
  final double height;
  final double fontSize;

  const SignUpButton({
    super.key,
    required this.height,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, SignUpScreen.id);
      },
      child: Container(
        height: height,
        margin: const EdgeInsets.symmetric(horizontal: 53),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            AppLocalizations.of(context)!.signup,
            style: AppTextStyles.buttonTextStyle(fontSize),
          ),
        ),
      ),
    );
  }
}
