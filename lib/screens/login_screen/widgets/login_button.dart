import 'package:flutter/material.dart';
import '../../../constants/styles.dart';
import '../../../constants/colors.dart';
import '../../../generated/l10n.dart';
import '../../../services/auth_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginButton extends StatelessWidget {
  final double fontSize;
  final String email;
  final String password;

  const LoginButton({
    super.key,
    required this.fontSize,
    required this.email,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        AuthService.signInWithEmailAndPassword(
            context, "efecanbolat34@gmail.com", "123456");
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
        decoration: BoxDecoration(
          color: AppColors.accentColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Text(
            AppLocalizations.of(context)!.login,
            style: AppTextStyles.buttonTextStyle(fontSize),
          ),
        ),
      ),
    );
  }
}
