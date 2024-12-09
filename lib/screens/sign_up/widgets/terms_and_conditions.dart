import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../constants/styles.dart';
import '../../../constants/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              text: AppLocalizations.of(context)!.agree,
              style: AppTextStyles.labelTextStyle(screenWidth * 0.045)
                  .copyWith(color: AppColors.textColor),
              children: <TextSpan>[
                TextSpan(
                  text: AppLocalizations.of(context)!.terms,
                  style: AppTextStyles.labelTextStyle(screenWidth * 0.045)
                      .copyWith(
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = onTermsTap,
                ),
                 TextSpan(text: AppLocalizations.of(context)!.and),
                TextSpan(
                  text: AppLocalizations.of(context)!.privacyPolicy,
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
