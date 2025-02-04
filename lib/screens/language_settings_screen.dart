import 'package:cyber_security_app/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageSettings extends StatefulWidget {
  final AppLocalizations? localizations;
  final bool isDark;
  const LanguageSettings({
    super.key,
    required this.localizations,
    required this.isDark,
  });

  @override
  State<LanguageSettings> createState() => _LanguageSettingsState();
}

class _LanguageSettingsState extends State<LanguageSettings> {
  String _selectedLanguage = 'en'; // Varsayılan dil

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference();
  }

  Future<void> _loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('selectedLanguage') ?? 'en';
    });
  }

  Future<void> _updateLanguagePreference(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', languageCode);
    setState(() {
      _selectedLanguage = languageCode;
    });

    // Uygulamanın ana widget'ına dil değişikliğini bildir
    MyApp.of(context)?.setLocale(Locale(languageCode));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: widget.isDark ? Colors.black : Colors.white,
        title: Text(
          widget.localizations!.langSettings,
          style: TextStyle(color: widget.isDark ? Colors.white : Colors.black),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_left_outlined,
            color: widget.isDark ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('${widget.localizations!.chooseLang}:',
              style: TextStyle(
                  color: widget.isDark ? Colors.white : Colors.black,
                  fontSize: 18)),
          ListTile(
            title: Text(widget.localizations!.english,
                style: TextStyle(
                    color: widget.isDark ? Colors.white : Colors.black)),
            leading: Radio<String>(
              value: 'en',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                if (value != null) {
                  _updateLanguagePreference(value);
                }
              },
            ),
          ),
          ListTile(
            title: Text(widget.localizations!.turkish,
                style: TextStyle(
                    color: widget.isDark ? Colors.white : Colors.black)),
            leading: Radio<String>(
              value: 'tr',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                if (value != null) {
                  _updateLanguagePreference(value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
