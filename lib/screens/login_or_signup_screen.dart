import 'package:cyber_security_app/screens/login_screen/widgets/custom_button.dart';
import 'package:cyber_security_app/screens/login_screen/widgets/google_sign_in_button.dart';
import 'package:cyber_security_app/screens/login_screen/widgets/password_field.dart';
import 'package:cyber_security_app/screens/sign_up/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import '../services/auth_service.dart';
import 'login_screen/widgets/email_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final currentLocale = MyApp.of(context)?.currentLocale;

    return Builder(
      builder: (context) => Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 150),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: 120,
                        height: 120,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          shadows: [
                            BoxShadow(
                              color: const Color(0xFF2A9D61),
                              blurRadius: 80,
                              offset: const Offset(7, 7),
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
                      const Text(
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
                const SizedBox(height: 30),
                Text(
                  AppLocalizations.of(context)?.slogan ??
                      "Artificial intelligence supported education application!",
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
                  margin: const EdgeInsets.only(left: 25, right: 25, top: 55),
                  width: 350,
                  child: EmailField(
                    fieldBackgroundColor: Colors.white,
                    shadowColor: Colors.black,
                    hintTextColor: Colors.grey,
                    textColor: Colors.black,
                    fontSize: MediaQuery.of(context).size.width * 0.03,
                    controller: emailController,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: 25, right: 25, top: 15, bottom: 40),
                  width: 350,
                  child: PasswordField(
                    fieldBackgroundColor: Colors.white,
                    shadowColor: Colors.black,
                    hintTextColor: Colors.grey,
                    textColor: Colors.black,
                    fontSize: MediaQuery.of(context).size.width * 0.03,
                    controller: passwordController,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: CustomButton(
                      text: AppLocalizations.of(context)?.login ?? "Login",
                      colors: const [Color(0xFF637BFF), Color(0xFF21C8F6)],
                      onPressed: () {
                        AuthService.signInWithEmailAndPassword(
                            context, "efecanbolat34@gmail.com", "123456");
                      }),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 40),
                  child: const GoogleSignInButton(
                    colors: [Color(0xFF132924), Color(0xFF288E50)],
                  ),
                ),
                /*  GestureDetector(
                  onTap: () {
                    AuthService.signInWithGoogle(context);
                  },
                  child: Opacity(
                    opacity: 0.50,
                    child: Text(
                      AppLocalizations.of(context)?.troubleLoggingIn ??
                          "Having trouble logging in?",
                      style: const TextStyle(
                        color: Color(0xFF243656),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
