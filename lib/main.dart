import 'package:cyber_security_app/OnboardingScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart'; // Oluşturulan yerelleştirme sınıfı

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = Locale('eng'); // Varsayılan dil

  // Dil seçimini güncelleyen fonksiyon
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.setLanguageCode("eng"); // İngilizce için
    return MaterialApp(
      locale: _locale,
      supportedLocales: S.delegate.supportedLocales,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        S.delegate,
        // Diğer gerekli delegeler
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: OnboardingScreen(),
    );
  }
}
