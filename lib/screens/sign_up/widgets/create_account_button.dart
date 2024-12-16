import 'package:flutter/material.dart';
import '../../../constants/styles.dart';
import '../../../constants/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateAccountButton extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final VoidCallback onPressed;

  const CreateAccountButton({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
        decoration: BoxDecoration(
          color: AppColors.accentColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Text(
            AppLocalizations.of(context)?.createAccount ?? "Create an account",
            style: AppTextStyles.buttonTextStyle(screenWidth * 0.05),
          ),
        ),
      ),
    );
  }
}
