import 'package:cyber_security_app/screens/account_security_screen.dart';
import 'package:cyber_security_app/screens/contact_us_screen.dart';
import 'package:cyber_security_app/screens/edit_profile_screen.dart';
import 'package:cyber_security_app/screens/home_screen/home_screen.dart';
import 'package:cyber_security_app/screens/notification_settings.dart';
import 'package:cyber_security_app/screens/premium_ad_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import '../models/users.dart';
import '../services/auth_service.dart';
import 'package:cyber_security_app/models/users.dart' as app_user;
import 'package:shared_preferences/shared_preferences.dart';
import 'login_or_signup_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<app_user.User> _userFuture;

  @override
  void initState() {
    bool themeState = false;
    super.initState();
    // Initialize the future to fetch user data
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Set status bar color to transparent
      statusBarIconBrightness: Brightness.light,
      // Light icons for dark background
    ));
    _userFuture = AuthService.getUserData(widget.userId);
  }

  bool themeState = false;
  String secilenDil = "tr";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<User>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Bir hata oluştu: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            } else if (!snapshot.hasData) {
              return const Center(
                child: Text(
                  'Kullanıcı verisi bulunamadı.',
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else {
              final user = snapshot.data!;
              return Column(
                children: [
                  // Üst kısım - Profil bilgileri (sabit)
                  /*ElevatedButton(
                    onPressed: () {
                      // Open Modal Sheet without setState
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Icon(Icons.language_outlined),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Text("Change Language",
                                        style: TextStyle(fontSize: 16)),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    DropdownButton(
                                      items: [
                                        DropdownMenuItem(
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 24,
                                                height: 24,
                                                margin: EdgeInsets.only(
                                                    right: 10),
                                              ),
                                              Text("Türkçe")
                                            ],
                                          ),
                                          value: "tr",
                                        ),
                                        DropdownMenuItem(
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 24,
                                                height: 24,
                                                margin: EdgeInsets.only(
                                                    right: 10),
                                              ),
                                              Text("İngilizce")
                                            ],
                                          ),
                                          value: "eng",
                                        )
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          secilenDil = value ?? "tr";
                                        });
                                      },
                                      hint: Text(secilenDil),
                                      value: secilenDil,
                                    ),
                                  ],
                                ),
                                // Language change logic

                                SwitchListTile(
                                  value: themeState,
                                  onChanged: (bool value) {
                                    setState(() {
                                      themeState = value;
                                    });
                                  },
                                  title: Text("Switch Theme"),
                                  secondary: Icon(Icons.sunny),
                                ),
                                ListTile(
                                  leading: Icon(Icons.logout),
                                  title: Text('Log Out'),
                                  onTap: () async {
                                    final prefs = await SharedPreferences
                                        .getInstance();
                                    await prefs.clear();

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LoginSignupScreen()),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: CircleBorder(),
                    ),
                    child: Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                  ),*/
                  Container(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            CircleAvatar(
                              radius: 120,
                              backgroundImage: NetworkImage(user.imageUrl),
                            ),
                            GestureDetector(
                              onTap: () {
                                _showImageOptions(context);
                              },
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.edit,
                                  size: 28,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          user.name,
                          style: const TextStyle(
                            color: Color(0xFF222222),
                            fontSize: 24,
                            fontFamily: 'Prompt',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                        Text(
                          user.email,
                          style: const TextStyle(
                            color: Color(0xFF888888),
                            fontSize: 16,
                            fontFamily: 'Prompt',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),

                  // Alt kısım - Ayarlar (kaydırılabilir)
                 /* Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(25)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.grey.shade900, // Buton rengini ayarla
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius
                                    .zero, // Köşe yumuşatmayı sıfırla
                              ),
                              foregroundColor:
                                  Colors.black, // Metin rengini beyaz yap
                            ),
                            onPressed: () {
                              print("Button 1 clicked!");
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    padding: EdgeInsets.all(20),
                                    height:
                                        1000, // Bilgi kutucuğunun yüksekliği
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Image(
                                            image: AssetImage("images/bro.png"),
                                            //badge buraya gelecek
                                            height: 200,
                                            width: 200,
                                          ),
                                          Text(
                                            '20680 Points\n*İzlediğin her 10dk için 50 puan kazanırsın\nBitirdiğin her kurs için 200 puan kazanırsın\n',
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '20.680\n', //Point will be here
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      // Bold font weight for "20.680"
                                      fontSize: 16,
                                      // Font size can be adjusted
                                      color: Colors.white, // Text color
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Superhero', //badge will be here
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      // Normal font weight for "Superhero"
                                      fontSize: 12,
                                      // Font size can be adjusted
                                      color: Colors.white, // Text color
                                    ),
                                  ),
                                ],
                              ),
                              textAlign:
                                  TextAlign.center, // Center align the text
                            ),
                          ),
                        ),
                        const VerticalDivider(
                          width: 20,
                          thickness: 2,
                          color: Colors.grey,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.grey.shade900, // Buton rengini ayarla
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius
                                    .zero, // Köşe yumuşatmayı sıfırla
                              ),
                              foregroundColor:
                                  Colors.white, // Metin rengini beyaz yap
                            ),
                            onPressed: () {
                              print("Button 2 clicked!");
                              //Leaderboard sayafasına navigate
                            },
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '226\n', //Sıralama burada olacak
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      // Bold font weight for "20.680"
                                      fontSize: 16,
                                      // Font size can be adjusted
                                      color: Colors.white, // Text color
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Leaderboard',
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      // Normal font weight for "Superhero"
                                      fontSize: 12,
                                      // Font size can be adjusted
                                      color: Colors.white, // Text color
                                    ),
                                  ),
                                ],
                              ),
                              textAlign:
                                  TextAlign.center, // Center align the text
                            ),
                          ),
                        ),
                        const VerticalDivider(
                          width: 20,
                          thickness: 2,
                          color: Colors.grey,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.grey.shade900, // Buton rengini ayarla
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius
                                    .zero, // Köşe yumuşatmayı sıfırla
                              ),
                              foregroundColor:
                                  Colors.white, // Metin rengini beyaz yap
                            ),
                            onPressed: () {
                              print("Button 3 clicked!");
                            },
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '30\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      // Bold font weight for "20.680"
                                      fontSize: 16,
                                      // Font size can be adjusted
                                      color: Colors.white, // Text color
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Daily Streak',
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      // Normal font weight for "Superhero"
                                      fontSize: 12,
                                      // Font size can be adjusted
                                      color: Colors.white, // Text color
                                    ),
                                  ),
                                ],
                              ),
                              textAlign:
                                  TextAlign.center, // Center align the text
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),*/
                  /*Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "ROZETLER",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),*/
                 /* SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(children: [
                      Row(
                        //buraya rozet badgeleri gelecek
                        children: [
                          Text("ROZETS  ",
                              style: TextStyle(color: Colors.white)),
                          Text("ROZETS  ",
                              style: TextStyle(color: Colors.white)),
                          Text("ROZETS  ",
                              style: TextStyle(color: Colors.white)),
                          Text("ROZETS  ",
                              style: TextStyle(color: Colors.white)),
                          Text("ROZETS  ",
                              style: TextStyle(color: Colors.white)),
                          Text("ROZETS  ",
                              style: TextStyle(color: Colors.white)),
                          Text("ROZETS  ",
                              style: TextStyle(color: Colors.white)),
                          Text("ROZETS  ",
                              style: TextStyle(color: Colors.white)),
                          Text("ROZETS  ",
                              style: TextStyle(color: Colors.white)),
                        ],
                      )
                    ]),
                  ),
*/
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 5),
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      decoration: ShapeDecoration(
                        color: Color(0xffffffff),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                      ),
                      child: ListView(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              'Account Settings',
                              style: TextStyle(
                                color: Color(0xFF90909F),
                                fontSize: 15,
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: Colors.white,
                            ),
                            child: InkWell(
                              onTap: () {
                                print('tıklandı');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditProfileScreen(
                                            userId: widget.userId,
                                          )),
                                );
                              },
                              splashColor: Colors.white.withOpacity(0.1),
                              highlightColor: Colors.white.withOpacity(0.05),
                              child: ListTile(
                                title: Text(
                                  "Edit profile",
                                  style: const TextStyle(
                                    color: Color(0xFF161719),
                                    fontSize: 18,
                                    fontFamily: 'DM Sans',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                                leading: const Icon(Icons.edit_outlined),
                                trailing: const Icon(
                                    Icons.arrow_circle_right_outlined,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: Colors.white,
                            ),
                            child: InkWell(
                              onTap: () {
                                print('tıklandı');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NotificationSettings()),
                                );
                              },
                              splashColor: Colors.white.withOpacity(0.1),
                              highlightColor: Colors.white.withOpacity(0.05),
                              child: ListTile(
                                title: Text(
                                  "Notifications Settings",
                                  style: const TextStyle(
                                    color: Color(0xFF161719),
                                    fontSize: 18,
                                    fontFamily: 'DM Sans',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                                leading: const Icon(
                                    Icons.notifications_active_outlined),
                                trailing: const Icon(
                                    Icons.arrow_circle_right_outlined,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: Colors.white,
                            ),
                            child: InkWell(
                              onTap: () {
                                print('tıklandı');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AccountSecurityScreen(
                                              userId: widget.userId)),
                                );
                              },
                              splashColor: Colors.white.withOpacity(0.1),
                              highlightColor: Colors.white.withOpacity(0.05),
                              child: ListTile(
                                title: Text(
                                  "Account Security",
                                  style: const TextStyle(
                                    color: Color(0xFF161719),
                                    fontSize: 18,
                                    fontFamily: 'DM Sans',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                                leading: const Icon(Icons.security),
                                trailing: const Icon(
                                    Icons.arrow_circle_right_outlined,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              'Support',
                              style: TextStyle(
                                color: Color(0xFF90909F),
                                fontSize: 15,
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: Colors.white,
                            ),
                            child: InkWell(
                              onTap: () {
                                //go to contact us page
                                print('tıklandı');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ContactUsPage()),
                                );
                              },
                              splashColor: Colors.white.withOpacity(0.1),
                              highlightColor: Colors.white.withOpacity(0.05),
                              child: ListTile(
                                title: Text(
                                  "Contact us",
                                  style: const TextStyle(
                                    color: Color(0xFF161719),
                                    fontSize: 18,
                                    fontFamily: 'DM Sans',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                                leading: const Icon(Icons.support_agent),
                                trailing: const Icon(
                                    Icons.arrow_circle_right_outlined,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: Colors.white,
                            ),
                            child: InkWell(
                              onTap: () {
                                print('tıklandı');
                              },
                              splashColor: Colors.white.withOpacity(0.1),
                              highlightColor: Colors.white.withOpacity(0.05),
                              child: ListTile(
                                title: Text(
                                  "About CyberGuard App",
                                  style: const TextStyle(
                                    color: Color(0xFF161719),
                                    fontSize: 18,
                                    fontFamily: 'DM Sans',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                                leading: const Icon(Icons.info_outline_rounded),
                                trailing: const Icon(
                                    Icons.arrow_circle_right_outlined,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

void _showImageOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 200,
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('Camera'),
              onTap: () {
                // Implement camera functionality
                Navigator.pop(context); // Close the bottom sheet
              },
            ),
            ListTile(
              leading: Icon(Icons.photo),
              title: Text('Gallery'),
              onTap: () {
                // Implement gallery functionality
                Navigator.pop(context); // Close the bottom sheet
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete'),
              onTap: () {
                // Implement delete functionality
                Navigator.pop(context); // Close the bottom sheet
              },
            ),
          ],
        ),
      );
    },
  );
}
