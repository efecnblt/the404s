import 'package:cyber_security_app/screens/login_screen/widgets/sign_up_prompt.dart';
import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/styles.dart';
import '../../generated/l10n.dart';
import 'widgets/animated_title.dart';
import 'widgets/login_button.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ekran boyutlarını alıyoruz
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double defaultMargin = 42.0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: screenHeight * 0.05),
                  // "Log in to" Metni
                  Text(
                    S.of(context).loginTo, // Yerelleştirilmiş metin
                    style: AppTextStyles.headingTextStyle(screenWidth * 0.12),
                  ),
                  // Animasyonlu Başlık
                  AnimatedTitle(fontSize: screenWidth * 0.12),
                  SizedBox(height: screenHeight * 0.03),
                  // Google Sign-In Butonu

                  SizedBox(height: screenHeight * 0.02),
                  // Divider with Text
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 2,
                          color: AppColors.accentColor,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.02),
                        child: Text(
                          S
                              .of(context)
                              .orLoginWithEmail, // Yerelleştirilmiş metin
                          style:
                              AppTextStyles.linkTextStyle(screenWidth * 0.05),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 2,
                          color: AppColors.accentColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  // Email TextField

                  SizedBox(height: screenHeight * 0.02),
                  // Password TextField

                  SizedBox(height: screenHeight * 0.03),
                  // Log In Button
                  LoginButton(
                    fontSize: screenWidth * 0.05,
                    email: emailController.text,
                    password: passwordController.text,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  // Sign Up Prompt
                ],
              ),
            ),
          ),
          // Sign Up Prompt and Image
          Positioned(
            bottom: screenHeight * 0.16,
            left: screenWidth * 0.15,
            child: SignUpPrompt(fontSize: screenWidth * 0.05),
          ),
          Positioned(
            bottom: screenHeight * -0.06,
            right: screenWidth * -0.12,
            child: IgnorePointer(
              child: Image.asset(
                'images/bro.png',
                fit: BoxFit.contain,
                width: screenWidth * 0.7,
                height: screenHeight * 0.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
