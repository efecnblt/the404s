import 'package:flutter/material.dart';
import '../../../constants/styles.dart';
import '../../../generated/l10n.dart';
import '../../sign_up/sign_up.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpPrompt extends StatelessWidget {
  final double fontSize;

  const SignUpPrompt({super.key, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.noAccount,
          style: AppTextStyles.labelTextStyle(fontSize),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpPage()),
            );
          },
          child: Text(
            AppLocalizations.of(context)!.signup,
            style: AppTextStyles.linkTextStyle(fontSize),
          ),
        ),
      ],
    );
  }
}
