// Yerelleştirme sınıfı
import 'dart:convert';

import 'package:flutter/cupertino.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  late Map<String, String> _localizedStrings;

  Future<bool> load() async {
    // Yerelleştirilmiş dosyayı yükleyin
    String jsonString = await DefaultAssetBundle.of(globalContext)
        .loadString('lib/l10n/app_${locale.languageCode}.arb');
    Map<String, dynamic> jsonMap =
        Map<String, dynamic>.from(json.decode(jsonString));

    _localizedStrings =
        jsonMap.map((key, value) => MapEntry(key, value.toString()));

    return true;
  }

  String? translate(String key) {
    return _localizedStrings[key];
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'tr'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

// Global context holder
late BuildContext globalContext;
