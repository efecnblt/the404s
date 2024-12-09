import 'package:flutter/material.dart';
import 'package:cyber_security_app/models/users.dart' as app_user;
import 'package:flutter/services.dart';
import '../models/users.dart';
import '../services/auth_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountSecurityScreen extends StatefulWidget {
  final String userId;
  final bool isDark;
  final AppLocalizations? localizations;
  const AccountSecurityScreen(
      {super.key, required this.userId, required this.isDark,required this.localizations});

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
          widget.localizations!.accSec,
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
                  '${widget.localizations!.anErrorOccured}  ${snapshot.error}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            } else if (!snapshot.hasData) {
              return  Center(
                child: Text(
                  widget.localizations!.userDataNotFound,
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
                      onStepContinue: () {
                        setState(() {
                          if (_aktifStep < 2) {
                            _aktifStep++;
                          } else if (_aktifStep == 2) {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                content:  Text(
                                    widget.localizations!.passChangedSuccess),
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
                                )),
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

