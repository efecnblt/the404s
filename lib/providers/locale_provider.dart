// lib/providers/locale_provider.dart

import 'package:flutter/material.dart';

import '../generated/l10n.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = Locale('en');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!S.delegate.supportedLocales.contains(locale)) return;
    _locale = locale;
    notifyListeners();
  }

  void clearLocale() {
    _locale = Locale('en');
    notifyListeners();
  }
}
