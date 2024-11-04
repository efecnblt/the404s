import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:contactus/contactus.dart';

class Contact_Us extends StatefulWidget {
  const Contact_Us({super.key});

  @override
  State<Contact_Us> createState() => _Contact_UsState();
}

class _Contact_UsState extends State<Contact_Us> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_left_outlined),
            color: Colors.white,
          ),
          title: Text(
            "Contact Us",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.black,
        body: ContactUs(
          taglineColor: Colors.blue,
          companyColor: Colors.red,
          cardColor: Colors.yellow.shade900,
          textColor: Colors.white,
          logo: AssetImage('images/404.png'),
          email: 'the404s@gmail.com',
          companyName: 'Team 404',
          phoneNumber: '+905000000000',
          dividerThickness: 2,
          website: 'https://gtu.edu.tr',
          githubUserName: '/efecnblt/the404s',
          linkedinURL: 'https://gtu.edu.tr',
          tagLine: 'Flutter Developer Team',
          twitterHandle: 'https://gtu.edu.tr',
        ),
      ),
    );
  }
}
