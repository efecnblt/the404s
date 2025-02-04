import 'package:cyber_security_app/OnboardingScreen.dart';
import 'package:cyber_security_app/screens/login_or_signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

AppLocalizations? globalLocalizations;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FirebaseAuth.instance.setLanguageCode('en');

  final prefs = await SharedPreferences.getInstance();
  String? savedLanguageCode =
      prefs.getString('selectedLanguage') ?? 'en'; // Varsayılan 'en'
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Durum çubuğu rengini şeffaf yapar
  ));
  runApp(MyApp(initialLanguageCode: savedLanguageCode));
}

class MyApp extends StatefulWidget {
  final String initialLanguageCode;
  const MyApp({super.key, required this.initialLanguageCode});

  @override
  _MyAppState createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  static void setLocale(Locale locale) {
    setLocale(locale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale _locale = Locale('en');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  Locale get currentLocale => _locale;

  @override
  void initState() {
    super.initState();
    _locale = Locale(widget.initialLanguageCode);
  }

  void _changeLanguage(String languageCode) async {
    setState(() {
      _locale = Locale(languageCode);
    });

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedLanguage', languageCode);
  }

  @override
  Widget build(BuildContext context) {
    //FirebaseAuth.instance.setLanguageCode("tr");
    globalLocalizations = AppLocalizations.of(context);
    return MaterialApp(
      locale: _locale,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''), // İngilizce
        Locale('tr', ''), // Türkçe
      ],
      debugShowCheckedModeBanner: false,
      home: LoginSignupScreen(),
    );
  }
}
