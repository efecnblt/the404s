import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationSettings extends StatefulWidget {
  final bool isDark;
  final AppLocalizations? localizations;
  const NotificationSettings(
      {super.key, required this.isDark, required this.localizations});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool mailNotifications = true; // Default values to avoid null
  bool appNotifications = true; // Default values to avoid null

  @override
  void initState() {
    super.initState();
    readSettings(); // Load settings from preferences
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
          widget.localizations!.notSettings,
          style: TextStyle(color: widget.isDark ? Colors.white : Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 75,
            ),
            // Email Notifications
            Container(
              decoration: BoxDecoration(
                color:
                    widget.isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.localizations!.mailNotifications,
                    style: TextStyle(
                        color: widget.isDark ? Colors.white : Colors.black,
                        fontSize: 20),
                  ),
                  AnimatedToggleSwitch.dual(
                    current: mailNotifications,
                    borderWidth: 0,
                    height: 40,
                    indicatorSize: Size(40, 40),
                    style: ToggleStyle(
                        borderColor: Colors.transparent,
                        indicatorColor: Colors.white,
                        backgroundColor: widget.isDark
                            ? (mailNotifications
                                ? Colors.green
                                : Colors.grey.shade600)
                            : (mailNotifications
                                ? Colors.green
                                : Colors.grey.shade300)),
                    first: false,
                    second: true,
                    onChanged: (value) {
                      setState(() => mailNotifications = value);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 75),
            // App Notifications
            Container(
              decoration: BoxDecoration(
                color:
                    widget.isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.localizations!.appNotifications,
                    style: TextStyle(
                        color: widget.isDark ? Colors.white : Colors.black,
                        fontSize: 20),
                  ),
                  AnimatedToggleSwitch.dual(
                    current: appNotifications,
                    borderWidth: 0,
                    height: 40,
                    indicatorSize: Size(40, 40),
                    style: ToggleStyle(
                      borderColor: Colors.transparent,
                      indicatorColor: Colors.white,
                      backgroundColor: widget.isDark
                          ? (appNotifications
                              ? Colors.green
                              : Colors.grey.shade600)
                          : (appNotifications
                              ? Colors.green
                              : Colors.grey.shade300),
                    ),
                    first: false,
                    second: true,
                    onChanged: (value) {
                      setState(() => appNotifications = value);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: widget.isDark ? Colors.white : Colors.black),
              onPressed: () {
                saveSettings();
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    content: Text(widget.localizations!.changesSaved),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: Text(
                widget.localizations!.save,
                style: TextStyle(
                    color: widget.isDark ? Colors.black : Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveSettings() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setBool('appNotifications', appNotifications);
    preferences.setBool('mailNotifications', mailNotifications);
  }

  Future<void> readSettings() async {
    final preferences = await SharedPreferences.getInstance();
    setState(() {
      appNotifications = preferences.getBool('appNotifications') ?? true;
      mailNotifications = preferences.getBool('mailNotifications') ?? true;
      // Settings are loaded
    });
  }
}
