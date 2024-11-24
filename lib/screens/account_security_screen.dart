import 'package:flutter/material.dart';
import 'package:cyber_security_app/models/users.dart' as app_user;
import 'package:cyber_security_app/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import '../models/users.dart';
import '../services/auth_service.dart';
import 'package:cyber_security_app/models/users.dart' as app_user;
import 'package:shared_preferences/shared_preferences.dart';

class AccountSecurityScreen extends StatefulWidget {
  final String userId;
  final bool isDark;
  const AccountSecurityScreen(
      {super.key, required this.userId, required this.isDark});

  @override
  State<AccountSecurityScreen> createState() => _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends State<AccountSecurityScreen> {
  int _aktifStep = 0;
  var key0 = GlobalKey<FormFieldState>();
  var key1 = GlobalKey<FormFieldState>();
  var key2 = GlobalKey<FormFieldState>();

  late Future<app_user.User> _userFuture;
  @override
  void initState() {
    super.initState();
    // Initialize the future to fetch user data
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Set status bar color to transparent
      statusBarIconBrightness:
          Brightness.light, // Light icons for dark background
    ));
    _userFuture = AuthService.getUserData(widget.userId);
  }

  String? controlPassword;
  String? controlnewPassword;
  String? newPassword;
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
                color: widget.isDark ? Colors.white : Colors.black)),
        title: Text(
          "Account Security",
          style: TextStyle(
            color: widget.isDark ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<User>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Bir hata oluştu: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            } else if (!snapshot.hasData) {
              return const Center(
                child: Text(
                  'Kullanıcı verisi bulunamadı.',
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else {
              final user = snapshot.data!;
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
                                backgroundColor:
                                    widget.isDark ? Colors.white : Colors.black,
                              ),
                              child: Text(
                                'Continue',
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
                                'Cancel',
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
                      onStepContinue: () {
                        setState(() {
                          if (_aktifStep < 2) {
                            _aktifStep++;
                          } else if (_aktifStep == 2) {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                content: const Text(
                                    'Şifreniz başarıyla değiştirilmiştir!'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
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
                            "Şifrenizi giriniz",
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
                                  "Enter your password",
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
                                )),
                            onSaved: (girilendeger) {
                              controlPassword = girilendeger;
                            },
                          ),
                        ),
                        Step(
                          isActive: true,
                          title: Text(
                            "Yeni şifrenizi giriniz",
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
                                  "Enter your password",
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
                                )),
                            onSaved: (control_yeni_sifre) {
                              /*  if(user.password==controlPassword){
                          controlnewPassword=control_yeni_sifre;
                        }*/
                            },
                          ),
                        ),
                        Step(
                          isActive: true,
                          title: Text(
                            "Yeni şifrenizi tekrar giriniz",
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
                                  "Enter your password",
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
                                )),
                            onSaved: (yeniSifre) {
                              /* if(controlnewPassword==yeni_sifre){
                          user.password=yenisifre;
                        }*/
                            },
                          ),
                        ),
                      ],
                    )),
              );
            }
          },
        ),
      ),
    );
  }
}

void _showImageOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 200,
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('Camera'),
              onTap: () {
                // Implement camera functionality
                Navigator.pop(context); // Close the bottom sheet
              },
            ),
            ListTile(
              leading: Icon(Icons.photo),
              title: Text('Gallery'),
              onTap: () {
                // Implement gallery functionality
                Navigator.pop(context); // Close the bottom sheet
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete'),
              onTap: () {
                // Implement delete functionality
                Navigator.pop(context); // Close the bottom sheet
              },
            ),
          ],
        ),
      );
    },
  );
}
