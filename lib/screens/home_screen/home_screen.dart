import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import 'widgets/animated_title.dart';
import 'widgets/sign_up_button.dart';
import 'widgets/login_row.dart';
import '../../../constants/styles.dart';

class HomeScreen extends StatelessWidget {
  static const String id = 'home_screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double defaultMargin = 20.0; // 20px kenar boşluğu

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: defaultMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Sola hizalama
              children: <Widget>[
                SizedBox(height: screenHeight * 0.05),
                // "Welcome to" Metni
                Text(
                  "Welcome to",
                  style: AppTextStyles.welcomeTextStyle(screenWidth * 0.12),
                ),
                // Animasyonlu Başlık
                AnimatedTitle(fontSize: screenWidth * 0.12),
                SizedBox(height: screenHeight * 0.04),
                // Alt Metin
                Text(
                  "Step Into the Future of\nSecurity",
                  style: AppTextStyles.subtitleTextStyle(screenWidth * 0.08),
                ),
                SizedBox(height: screenHeight * 0.06),
                // Logo
                Center(
                  child: Image.asset(
                    "images/logo.png",
                    width: screenWidth * 0.5,
                    height: screenWidth * 0.5,
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                // "Sign Up" Butonu
                SignUpButton(
                  height: screenHeight * 0.07,
                  fontSize: screenWidth * 0.08,
                ),
                SizedBox(height: screenHeight * 0.01),
                // "Already have an account? Log in"
                LoginRow(fontSize: screenWidth * 0.05),
              ],
            ),
          ),
          // Alt Sağ Köşedeki Resim
          Positioned(
            bottom: screenHeight * -0.05,
            right: screenWidth * -0.05,
            child: Image.asset(
              'images/Mobile.png',
              fit: BoxFit.contain,
              width: screenWidth * 0.6,
              height: screenHeight * 0.30,
            ),
          ),
        ],
      ),
    );
  }
}
