import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../constants/styles.dart';
import '../../../constants/colors.dart';

class TermsAndConditions extends StatelessWidget {
  final bool isChecked;
  final Function(bool) onChanged;
  final double screenWidth;
  final VoidCallback onTermsTap;
  final VoidCallback onPrivacyTap;

  const TermsAndConditions({
    super.key,
    required this.isChecked,
    required this.onChanged,
    required this.screenWidth,
    required this.onTermsTap,
    required this.onPrivacyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          checkColor: AppColors.primaryColor,
          activeColor: AppColors.textColor,
          onChanged: (bool? value) {
            onChanged(value ?? false);
          },
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: 'I agree with the ',
              style: AppTextStyles.labelTextStyle(screenWidth * 0.045)
                  .copyWith(color: AppColors.textColor),
              children: <TextSpan>[
                TextSpan(
                  text: 'Terms of Service',
                  style: AppTextStyles.labelTextStyle(screenWidth * 0.045)
                      .copyWith(
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = onTermsTap,
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: AppTextStyles.labelTextStyle(screenWidth * 0.045)
                      .copyWith(
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = onPrivacyTap,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
