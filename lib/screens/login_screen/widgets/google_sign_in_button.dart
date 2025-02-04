import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import '../../../services/auth_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GoogleSignInButton extends StatelessWidget {
  final List<Color> colors;
  const GoogleSignInButton({
    super.key,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        //  AuthService.signInWithGoogle(context);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        height: 65,
        decoration: ShapeDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.94, 0.34),
            end: Alignment(0.94, -0.34),
            colors: colors,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          shadows: [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 10,
              offset: Offset(0, 5),
              spreadRadius: 0,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "images/Google_logo.png",
              width: screenWidth * 0.05,
              height: screenWidth * 0.05,
            ),
            SizedBox(width: screenWidth * 0.02),
            Text(
              AppLocalizations.of(context)?.loginWithGoogle ??
                  "Log in with Google",
              style: TextStyle(
                color: Color(0xFFFCFCFF),
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
