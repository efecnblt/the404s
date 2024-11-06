import 'package:cyber_security_app/screens/login_screen/widgets/custom_button.dart';
import 'package:cyber_security_app/screens/login_screen/widgets/google_sign_in_button.dart';
import 'package:cyber_security_app/screens/login_screen/widgets/password_field.dart';
import 'package:cyber_security_app/screens/sign_up/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../generated/l10n.dart';
import '../services/auth_service.dart';
import 'app_theme.dart';
import 'login_screen/login_screen.dart';
import 'login_screen/widgets/email_field.dart'; // Yerelleştirilmiş metinler için

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
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
  void initState() {
    super.initState();
    // Durum çubuğunu şeffaf yapmak için ayar
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Durum çubuğunu saydam yapar
      statusBarIconBrightness: Brightness.dark, // İkonların görünümünü ayarlar
    ));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 80),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 150),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        width: 120,
                        height: 120,
                        decoration: ShapeDecoration(

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          shadows: [
                            BoxShadow(
                              color: Color(0xFF2A9D61),
                              blurRadius: 80,
                              offset: Offset(7, 7),
                              spreadRadius: 1,
                            )
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: 120,
                                height: 120,
                                child: Image.asset(
                                  "images/new_logo.png",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '404 Academy',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF2A9D61),
                          fontSize: 36,
                          fontFamily: 'Prompt',
                          height: 0.01,
                          letterSpacing: 0.34,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'Free app for learning cyber security things',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.25),
                    fontSize: 16,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 25, right: 25, top: 55),
                  width: 350,
                  child: EmailField(
                    fieldBackgroundColor: Colors.white,
                    shadowColor: Colors.black,
                    hintTextColor: Colors.grey,
                    textColor: Colors.black,
                    fontSize: screenWidth * 0.03,
                    controller: emailController,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 40),
                  width: 350,
                  child: PasswordField(
                    fieldBackgroundColor: Colors.white,
                    shadowColor: Colors.black,
                    hintTextColor: Colors.grey,
                    textColor: Colors.black,
                    fontSize: screenWidth * 0.03,
                    controller: passwordController,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: CustomButton(
                      text: "Login",
                      colors: [Color(0xFF637BFF), Color(0xFF21C8F6)],
                      onPressed: () {
                        AuthService.signInWithEmailAndPassword(context, "efecanbolat34@gmail.com", "123456");
                      }),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 40),
                  child: GoogleSignInButton(
                    colors: [Color(0xFF132924), Color(0xFF288E50) ],
                  ),
                ),
                GestureDetector(
                  child: Opacity(
                    opacity: 0.50,
                    child: Text(
                      'Having trouble logging in?',
                      style: TextStyle(
                        color: Color(0xFF243656),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30, bottom: 30),
                  width: 85,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: Color(0xFFC2C2C2),
                      ),
                    ),
                  ),
                ),

                GestureDetector(

                  child: Opacity(
                    opacity: 0.50,
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        color: Color(0xFF243656),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ));
  }
}
