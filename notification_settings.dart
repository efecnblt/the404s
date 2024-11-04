import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool mailNotifications = true;
  bool appNotifications = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_left_outlined)),
          title: Text("Notification Settings"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Text("Email notifications"),
                AnimatedToggleSwitch.dual(
                  current: mailNotifications,
                  first: false,
                  second: true,
                  onChanged: (a) => setState(() => mailNotifications = a),
                ),
              ]),
              SizedBox(
                height: 75,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("App notifications"),
                  AnimatedToggleSwitch.dual(
                    current: appNotifications,
                    first: false,
                    second: true,
                    onChanged: (c) => setState(() => appNotifications = c),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
