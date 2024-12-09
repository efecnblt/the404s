import 'package:cyber_security_app/screens/login_or_signup_screen.dart';
import 'package:flutter/material.dart';
import '../../../constants/styles.dart';
import '../../login_screen/login_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            AppLocalizations.of(context)!.alreadyHaveAnAcc,
            style: AppTextStyles.labelTextStyle(screenWidth * 0.05)
                .copyWith(color: Colors.white),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginSignupScreen(),
                  ));
            },
            child: Text(
              AppLocalizations.of(context)!.login,
              style: AppTextStyles.linkTextStyle(screenWidth * 0.05),
            ),
          ),
        ],
      ),
    );
  }
}
