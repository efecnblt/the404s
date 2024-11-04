import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/styles.dart';
import '../../services/auth_service.dart';
import 'widgets/animated_title.dart';
import 'widgets/google_sign_up_button.dart';
import 'widgets/text_field_widget.dart';
import 'widgets/terms_and_conditions.dart';
import 'widgets/create_account_button.dart';
import 'widgets/login_prompt.dart';

class SignUpScreen extends StatefulWidget {
  static const String id = "sign_up_screen";

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isChecked = false;
  final _formKey = GlobalKey<FormState>();

  // Text field controller'ları
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Ekran boyutları
  late double screenWidth;
  late double screenHeight;

  @override
  void dispose() {
    // Controller'ları dispose ediyoruz
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ekran boyutlarını alıyoruz
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    double defaultMargin = 42.0;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: screenHeight * 0.05),
                // "Sign up to" Metni
                Text(
                  "Sign up to",
                  style: AppTextStyles.headingTextStyle(screenWidth * 0.12),
                ),
                AnimatedTitle(fontSize: screenWidth * 0.12),
                SizedBox(height: screenHeight * 0.03),
                // Google ile kayıt ol butonu
                GoogleSignUpButton(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                SizedBox(height: screenHeight * 0.02),
                // Bölme çizgisi
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 2,
                        color: AppColors.accentColor,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                      child: Text(
                        "Or continue with Email",
                        style: AppTextStyles.linkTextStyle(screenWidth * 0.05),
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
                SizedBox(height: screenHeight * 0.03),
                // İsim TextField
                TextFieldWidget(
                  controller: nameController,
                  labelText: "Enter your name",
                  screenWidth: screenWidth,
                  screenHeight: screenHeight * 0.3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                // Kullanıcı adı TextField
                TextFieldWidget(
                  controller: usernameController,
                  labelText: "Enter username",
                  screenWidth: screenWidth,
                  screenHeight: screenHeight * 0.3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                // Email TextField
                TextFieldWidget(
                  controller: emailController,
                  labelText: "Enter Email",
                  keyboardType: TextInputType.emailAddress,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight * 0.3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    } else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                        .hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                // Şifre TextField
                TextFieldWidget(
                  controller: passwordController,
                  labelText: "Enter password",
                  obscureText: true,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight * 0.3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                // Şifre doğrulama TextField
                TextFieldWidget(
                  controller: confirmPasswordController,
                  labelText: "Confirm password",
                  obscureText: true,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight * 0.3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    } else if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                // Şartlar ve koşullar
                TermsAndConditions(
                  isChecked: _isChecked,
                  onChanged: (value) {
                    setState(() {
                      _isChecked = value;
                    });
                  },
                  screenWidth: screenWidth,
                  onTermsTap: () =>
                      _showTermsDialog(context, 'Terms of Service'),
                  onPrivacyTap: () =>
                      _showTermsDialog(context, 'Privacy Policy'),
                ),
                if (!_isChecked)
                  Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.05),
                    child: Text(
                      'Required field',
                      style: AppTextStyles.errorTextStyle(screenWidth * 0.035),
                    ),
                  ),
                SizedBox(height: screenHeight * 0.02),
                // Hesap oluştur butonu
                CreateAccountButton(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  onPressed: _registerAccount,
                ),
                SizedBox(height: screenHeight * 0.02),
                // Giriş yapma yönlendirmesi
                LoginPrompt(
                  screenWidth: screenWidth,
                ),
                SizedBox(height: screenHeight * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Şartlar ve koşullar dialog
  void _showTermsDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Text(
              title == 'Terms of Service'
                  ? '''[Şartlar ve koşullar metniniz buraya gelecek.]'''
                  : '''[Gizlilik politikası metniniz buraya gelecek.]''',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _registerAccount() async {
    if (_formKey.currentState!.validate() && _isChecked) {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      String username = usernameController.text.trim();
      String name = nameController.text.trim();

      // Yükleniyor göstergesi
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        // E-posta kontrolü
        bool emailExists = await AuthService.isEmailRegistered(email);
        if (emailExists) {
          Navigator.of(context).pop(); // Yükleniyor göstergesini kapat
          _showErrorDialog('Email is already registered.');
          return;
        }

        // Kullanıcı oluşturma
        UserCredential userCredential =
            await AuthService.registerWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Görünen adı güncelleme
        await userCredential.user?.updateDisplayName(username);
        User? user = userCredential.user;

        // Fetch the user's document from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();

        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;

        Navigator.of(context).pop(); // Yükleniyor göstergesini kapat

        // Dashboard'a yönlendirme
        //Navigator.pushReplacement(
        // context,
        // MaterialPageRoute(
        //builder: (context) => Dashboard(name: '',),
        //),
        //);
      } on FirebaseAuthException catch (e) {
        Navigator.of(context).pop(); // Yükleniyor göstergesini kapat
        _showErrorDialog(e.message ?? 'Registration failed.');
      } catch (e) {
        Navigator.of(context).pop(); // Yükleniyor göstergesini kapat
        _showErrorDialog('An unexpected error occurred.');
        print('Registration error: $e'); // Hata ayıklama için
      }
    } else if (!_isChecked) {
      // Checkbox işaretlenmemiş
      setState(() {}); // 'Required field' mesajını göstermek için
    }
  }

  // Hata dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registration Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
