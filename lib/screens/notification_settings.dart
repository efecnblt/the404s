import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

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
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_left_outlined),
        ),
        title: Text("Notification Settings"),
      ),
      body: // Show loading indicator while settings load
          Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Email notifications"),
                AnimatedToggleSwitch.dual(
                  current: mailNotifications,
                  first: false,
                  second: true,
                  onChanged: (value) {
                    setState(() => mailNotifications = value);
                  },
                ),
              ],
            ),
            SizedBox(height: 75),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("App notifications"),
                AnimatedToggleSwitch.dual(
                  current: appNotifications,
                  first: false,
                  second: true,
                  onChanged: (value) {
                    setState(() => appNotifications = value);
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    saveSettings();
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        content: Text(
                            'Değişiklikler kaydedildi!, Email Notifications: $mailNotifications, App notifications: $appNotifications'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text("Kaydet"),
                ),
              ],
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
