import 'package:cyber_security_app/screens/login_or_signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cyber_security_app/models/users.dart' as app_user;
import 'package:flutter/services.dart';
import '../models/users.dart';
import '../services/auth_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountSecurityScreen extends StatefulWidget {
  final String userId;
  final bool isDark;
  final AppLocalizations? localizations;

  const AccountSecurityScreen({
    super.key,
    required this.userId,
    required this.isDark,
    required this.localizations,
  });

  @override
  State<AccountSecurityScreen> createState() => _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends State<AccountSecurityScreen> {
  int _aktifStep = 0;
  var key0 = GlobalKey<FormFieldState>();
  var key1 = GlobalKey<FormFieldState>();
  var key2 = GlobalKey<FormFieldState>();

  late Future<app_user.User> _userFuture;
  String? controlPassword;
  String? controlnewPassword;
  String? newPassword;

  @override
  void initState() {
    super.initState();
    // Initialize the future to fetch user data
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Set status bar color to transparent
        statusBarIconBrightness:
            Brightness.light, // Light icons for dark background
      ),
    );
    _userFuture = AuthService.getUserData(widget.userId);
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
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
                onPressed: () async{
                  Navigator.pop(context);
                  Navigator.pop(context);
                  await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushAndRemoveUntil(
                       MaterialPageRoute(builder: (context) => const LoginSignupScreen()),
                     (route) => false,);
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
            child: Text('OK'),
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
          icon: Icon(Icons.arrow_left_outlined,
              color: widget.isDark ? Colors.white : Colors.black),
        ),
        title: Text(
          widget.localizations!.accSec,
          style: TextStyle(
            color: widget.isDark ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<app_user.User>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${widget.localizations!.anErrorOccured}  ${snapshot.error}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            } else if (!snapshot.hasData) {
              return Center(
                child: Text(
                  widget.localizations!.userDataNotFound,
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else {
              return SingleChildScrollView(
                child: Theme(
                  data: ThemeData(
                    colorScheme: ColorScheme.light(
                      primary: widget.isDark ? Colors.green : Colors.green,
                    ),
                  ),
                  child: Stepper(
                    controlsBuilder: (context, details) {
                      return Row(
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: details.onStepContinue,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.isDark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            child: Text(
                              widget.localizations!.contiune,
                              style: TextStyle(
                                color: widget.isDark
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: details.onStepCancel,
                            child: Text(
                              widget.localizations!.cancel,
                              style: TextStyle(
                                color: widget.isDark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    currentStep: _aktifStep,
                    onStepContinue: () async {
                      if (_aktifStep == 0) {
                        key0.currentState?.save();
                        if (controlPassword == null ||
                            controlPassword!.isEmpty) {
                          showErrorDialog(
                              widget.localizations!.enterCurrentPassword);
                          return;
                        }
                      } else if (_aktifStep == 1) {
                        key1.currentState?.save();
                        if (controlnewPassword == null ||
                            controlnewPassword!.isEmpty) {
                          showErrorDialog(
                              widget.localizations!.enterNewPassword);
                          return;
                        }
                      } else if (_aktifStep == 2) {
                        key2.currentState?.save();
                        if (newPassword == null ||
                            newPassword != controlnewPassword) {
                          showErrorDialog(
                              "widget.localizations!.passwordsDoNotMatch");
                          return;
                        }

                        // Şifre değiştirme
                        await changePassword(
                            controlPassword!, newPassword!);
                      }

                      setState(() {
                        if (_aktifStep < 2) {
                          _aktifStep++;
                        }
                      });
                    },
                    onStepCancel: () {
                      setState(() {
                        if (_aktifStep != 0) {
                          _aktifStep--;
                        }
                      });
                    },
                    onStepTapped: (tiklanilanStep) {
                      setState(() {
                        _aktifStep = tiklanilanStep;
                      });
                    },
                    steps: [
                      Step(
                        isActive: true,
                        title: Text(
                          widget.localizations!.enterPassword,
                          style: TextStyle(
                              color: widget.isDark
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        content: TextFormField(
                          style: TextStyle(
                            color:
                                widget.isDark ? Colors.white : Colors.black,
                          ),
                          key: key0,
                          obscureText: true,
                          decoration: InputDecoration(
                            label: Text(
                              widget.localizations!.enterPassword,
                              style: TextStyle(
                                  color: widget.isDark
                                      ? Colors.white
                                      : Colors.black),
                            ),
                            prefixIcon: Icon(
                              Icons.key_outlined,
                              color: widget.isDark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          onSaved: (girilendeger) {
                            controlPassword = girilendeger;
                          },
                        ),
                      ),
                      Step(
                        isActive: true,
                        title: Text(
                          widget.localizations!.enterNewPassword,
                          style: TextStyle(
                              color: widget.isDark
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        content: TextFormField(
                          style: TextStyle(
                            color:
                                widget.isDark ? Colors.white : Colors.black,
                          ),
                          key: key1,
                          obscureText: true,
                          decoration: InputDecoration(
                            label: Text(
                              widget.localizations!.enterNewPassword,
                              style: TextStyle(
                                  color: widget.isDark
                                      ? Colors.white
                                      : Colors.black),
                            ),
                            prefixIcon: Icon(
                              Icons.key_outlined,
                              color: widget.isDark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          onSaved: (girilendeger) {
                            controlnewPassword = girilendeger;
                          },
                        ),
                      ),
                      Step(
                        isActive: true,
                        title: Text(
                          widget.localizations!.enterNewPasswordAgain,
                          style: TextStyle(
                              color: widget.isDark
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        content: TextFormField(
                          style: TextStyle(
                            color:
                                widget.isDark ? Colors.white : Colors.black,
                          ),
                          key: key2,
                          obscureText: true,
                          decoration: InputDecoration(
                            label: Text(
                              widget.localizations!.enterNewPasswordAgain,
                              style: TextStyle(
                                  color: widget.isDark
                                      ? Colors.white
                                      : Colors.black),
                            ),
                            prefixIcon: Icon(
                              Icons.key_outlined,
                              color: widget.isDark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          onSaved: (girilendeger) {
                            newPassword = girilendeger;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
