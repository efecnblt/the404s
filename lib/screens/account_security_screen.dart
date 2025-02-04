import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_or_signup_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountSecurityScreen extends StatefulWidget {
  final bool isDark;
  final AppLocalizations? localizations;

  const AccountSecurityScreen({
    Key? key,
    required this.isDark,
    required this.localizations,
  }) : super(key: key);

  @override
  State<AccountSecurityScreen> createState() => _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends State<AccountSecurityScreen> {
  int _activeStep = 0;
  var currentPasswordKey = GlobalKey<FormFieldState>();
  var newPasswordKey = GlobalKey<FormFieldState>();
  var confirmNewPasswordKey = GlobalKey<FormFieldState>();

  String? currentPassword;
  String? newPassword;
  String? confirmNewPassword;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null && user.email != null) {
        // Kullanıcının mevcut şifresiyle kimlik doğrulama
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );

        // Kimlik doğrulama
        await user.reauthenticateWithCredential(credential);

        // Yeni şifreyi güncelleme
        await user.updatePassword(newPassword);

        // Başarılı durum mesajı
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(widget.localizations!.success),
            content: Text(widget.localizations!.passChangedSuccess),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const LoginSignupScreen()),
                    (route) => false,
                  );
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'User not found or email is null.',
        );
      }
    } catch (e) {
      // Hata durumunda mesaj
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(widget.localizations!.error),
          content: Text('${"widget.localizations!.passChangeFailed"}: $e'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.localizations!.error),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: widget.isDark ? Colors.black : Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: widget.isDark ? Colors.white : Colors.black,
          ),
        ),
        title: Text(
          widget.localizations!.accSec,
          style: TextStyle(
            color: widget.isDark ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Theme(
            data: ThemeData(
              colorScheme: ColorScheme.light(
                primary: widget.isDark ? Colors.green : Colors.green,
              ),
            ),
            child: Stepper(
              controlsBuilder: (context, details) {
                return Row(
                  children: [
                    ElevatedButton(
                      onPressed: details.onStepContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            widget.isDark ? Colors.white : Colors.black,
                      ),
                      child: Text(
                        widget.localizations!.contiune,
                        style: TextStyle(
                          color: widget.isDark ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: details.onStepCancel,
                      child: Text(
                        widget.localizations!.cancel,
                        style: TextStyle(
                          color: widget.isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ],
                );
              },
              currentStep: _activeStep,
              onStepContinue: () async {
                if (_activeStep == 0) {
                  currentPasswordKey.currentState?.save();
                  if (currentPassword == null || currentPassword!.isEmpty) {
                    showErrorDialog(widget.localizations!.enterCurrentPassword);
                    return;
                  }
                } else if (_activeStep == 1) {
                  newPasswordKey.currentState?.save();
                  if (newPassword == null || newPassword!.isEmpty) {
                    showErrorDialog(widget.localizations!.enterNewPassword);
                    return;
                  }
                } else if (_activeStep == 2) {
                  confirmNewPasswordKey.currentState?.save();
                  if (confirmNewPassword == null ||
                      confirmNewPassword != newPassword) {
                    showErrorDialog(
                        "widget.localizations!.passwordsDoNotMatch");
                    return;
                  }

                  await changePassword(currentPassword!, newPassword!);
                }

                setState(() {
                  if (_activeStep < 2) {
                    _activeStep++;
                  }
                });
              },
              onStepCancel: () {
                setState(() {
                  if (_activeStep != 0) {
                    _activeStep--;
                  }
                });
              },
              onStepTapped: (step) {
                setState(() {
                  _activeStep = step;
                });
              },
              steps: [
                Step(
                  isActive: true,
                  title: Text(
                    widget.localizations!.enterPassword,
                    style: TextStyle(
                      color: widget.isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  content: TextFormField(
                    style: TextStyle(
                      color: widget.isDark ? Colors.white : Colors.black,
                    ),
                    key: currentPasswordKey,
                    obscureText: true,
                    decoration: InputDecoration(
                      label: Text(
                        widget.localizations!.enterPassword,
                        style: TextStyle(
                          color: widget.isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.key_outlined,
                        color: widget.isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    onSaved: (value) {
                      currentPassword = value;
                    },
                  ),
                ),
                Step(
                  isActive: true,
                  title: Text(
                    widget.localizations!.enterNewPassword,
                    style: TextStyle(
                      color: widget.isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  content: TextFormField(
                    style: TextStyle(
                      color: widget.isDark ? Colors.white : Colors.black,
                    ),
                    key: newPasswordKey,
                    obscureText: true,
                    decoration: InputDecoration(
                      label: Text(
                        widget.localizations!.enterNewPassword,
                        style: TextStyle(
                          color: widget.isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.key_outlined,
                        color: widget.isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    onSaved: (value) {
                      newPassword = value;
                    },
                  ),
                ),
                Step(
                  isActive: true,
                  title: Text(
                    widget.localizations!.enterNewPasswordAgain,
                    style: TextStyle(
                      color: widget.isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  content: TextFormField(
                    style: TextStyle(
                      color: widget.isDark ? Colors.white : Colors.black,
                    ),
                    key: confirmNewPasswordKey,
                    obscureText: true,
                    decoration: InputDecoration(
                      label: Text(
                        widget.localizations!.enterNewPasswordAgain,
                        style: TextStyle(
                          color: widget.isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.key_outlined,
                        color: widget.isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    onSaved: (value) {
                      confirmNewPassword = value;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
