import 'package:flutter/material.dart';
import '../../../../constants/styles.dart';
import '../../login_screen/login_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginRow extends StatelessWidget {
  final double fontSize;

  const LoginRow({super.key, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.alreadyHaveAnAcc, 
          style: AppTextStyles.infoTextStyle(fontSize),
        ),
        GestureDetector(
          onTap: () {
            //Navigator.pushNamed(context, LoginScreen.id);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ));
          },
          child: Text(
            AppLocalizations.of(context)!.logIn, 
            style: AppTextStyles.linkTextStyle(fontSize),
          ),
        ),
      ],
    );
  }
}
