import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../constants/styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class GoogleSignUpButton extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const GoogleSignUpButton({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Google ile kayıt olma işlemi
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
        decoration: BoxDecoration(
          color: AppColors.accentColor,
          borderRadius: BorderRadius.circular(50),
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
              AppLocalizations.of(context)!.signUpWithGoogle,
              style: AppTextStyles.buttonTextStyle(screenWidth * 0.05),
            ),
          ],
        ),
      ),
    );
  }
}
