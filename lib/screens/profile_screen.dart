import 'package:cyber_security_app/OnboardingScreen.dart';
import 'package:cyber_security_app/main.dart';
import 'package:cyber_security_app/screens/account_security_screen.dart';
import 'package:cyber_security_app/screens/contact_us_screen.dart';
import 'package:cyber_security_app/screens/edit_profile_screen.dart';
import 'package:cyber_security_app/screens/language_settings_screen.dart';
import 'package:cyber_security_app/screens/leaderboard_screen.dart';
import 'package:cyber_security_app/screens/login_or_signup_screen.dart';
import 'package:cyber_security_app/screens/notification_settings.dart';
import 'package:cyber_security_app/screens/notification_settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/users.dart';
import '../services/auth_service.dart';
import 'package:cyber_security_app/models/users.dart' as app_user;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ProfileScreen extends StatefulWidget {
  final String userId;
  final bool isDark;
  final AppLocalizations? localizations;

  const ProfileScreen({
    super.key,
    required this.userId,
    required this.isDark,
    required this.localizations,
  });

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDark ? Colors.black : Colors.white,
      body: SafeArea(
        child: FutureBuilder<app_user.User>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${widget.localizations!.anErrorOccured}  ${snapshot.error}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            } else if (!snapshot.hasData) {
              return  Center(
                child: Text(
                  widget.localizations!.userDataNotFound,
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else {
              final user = snapshot.data!;
              return Column(
                children: [
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
                                _showImageOptions(context ,widget.localizations! ,widget.isDark);
                              },
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor:
                                    widget.isDark ? Colors.black : Colors.white,
                                child: Icon(
                                  Icons.edit,
                                  size: 28,
                                  color: widget.isDark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          user.name,
                          style: TextStyle(
                            color: widget.isDark
                                ? Colors.white
                                : Color(0xFF222222),
                            fontSize: 24,
                            fontFamily: 'Prompt',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                        Text(
                          user.email,
                          style: TextStyle(
                            color: widget.isDark
                                ? Colors.white
                                : Color(0xFF888888),
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
                        color: widget.isDark ? Colors.black : Color(0xffffffff),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                      ),
                      child: ListView(
                        children: [
                           Container(
                            margin: EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: widget.isDark
                                    ? Colors.black
                                    : Colors.white),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                               context,
                                       MaterialPageRoute(builder: (context) =>  LeaderboardPage(localizations: widget.localizations,isDark: widget.isDark,userId: user.id,)),
                                            );
                              },
                              splashColor: Colors.white.withOpacity(0.1),
                              highlightColor: Colors.white.withOpacity(0.05),
                              child: ListTile(
                                title: Text(
                                  widget.localizations!.leaderboard,
                                  
                                  style: TextStyle(
                                    color: widget.isDark
                                        ? Colors.white
                                        : Color(0xFF161719),
                                    fontSize: 18,
                                    fontFamily: 'DM Sans',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                                leading: Icon(Icons.leaderboard,
                                    color: widget.isDark
                                        ? Colors.white
                                        : Colors.black),
                                trailing: Icon(
                                    Icons.arrow_circle_right_outlined,
                                    color: widget.isDark
                                        ? Colors.white
                                        : Colors.black),
                              ),
                              
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              widget.localizations!.accSettings,
                              style: TextStyle(
                                color: widget.isDark
                                    ? Colors.white
                                    : Color(0xFF90909F),
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
                              color:
                                  widget.isDark ? Colors.black : Colors.white,
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditProfileScreen(
                                            userId: widget.userId,
                                            isDark: widget.isDark,
                                            localizations: widget.localizations,
                                          )),
                                );
                              },
                              splashColor: Colors.white.withOpacity(0.1),
                              highlightColor: Colors.white.withOpacity(0.05),
                              child: ListTile(
                                title: Text(
                                  widget.localizations!.editProfile,
                                  style: TextStyle(
                                    color: widget.isDark
                                        ? Colors.white
                                        : Color(0xFF161719),
                                    fontSize: 18,
                                    fontFamily: 'DM Sans',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                                leading: Icon(Icons.edit_outlined,
                                    color: widget.isDark
                                        ? Colors.white
                                        : Colors.black),
                                trailing: Icon(
                                  Icons.arrow_circle_right_outlined,
                                  color: widget.isDark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: widget.isDark
                                    ? Colors.black
                                    : Colors.white),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NotificationSettings(
                                            isDark: widget.isDark,
                                            localizations: widget.localizations,
                                          )),
                                );
                              },
                              splashColor: Colors.white.withOpacity(0.1),
                              highlightColor: Colors.white.withOpacity(0.05),
                              child: ListTile(
                                title: Text(
                                  widget.localizations!.notiSettings,
                                  style: TextStyle(
                                    color: widget.isDark
                                        ? Colors.white
                                        : Color(0xFF161719),
                                    fontSize: 18,
                                    fontFamily: 'DM Sans',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                                leading: Icon(
                                    Icons.notifications_active_outlined,
                                    color: widget.isDark
                                        ? Colors.white
                                        : Colors.black),
                                trailing: Icon(
                                    Icons.arrow_circle_right_outlined,
                                    color: widget.isDark
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: widget.isDark
                                    ? Colors.black
                                    : Colors.white),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AccountSecurityScreen(
                                            userId: widget.userId,
                                            isDark: widget.isDark,
                                            localizations: widget.localizations
                                          )),
                                );
                              },
                              splashColor: Colors.white.withOpacity(0.1),
                              highlightColor: Colors.white.withOpacity(0.05),
                              child: ListTile(
                                title: Text(
                                  widget.localizations!.accSec,
                                  style: TextStyle(
                                    color: widget.isDark
                                        ? Colors.white
                                        : Color(0xFF161719),
                                    fontSize: 18,
                                    fontFamily: 'DM Sans',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                                leading: Icon(Icons.security,
                                    color: widget.isDark
                                        ? Colors.white
                                        : Colors.black),
                                trailing: Icon(
                                    Icons.arrow_circle_right_outlined,
                                    color: widget.isDark
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ),
                           Container(
                            margin: EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: widget.isDark
                                    ? Colors.black
                                    : Colors.white),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                               context,
                                       MaterialPageRoute(builder: (context) =>  LanguageSettings(localizations: widget.localizations,isDark: widget.isDark,)),
                                            );
                              },
                              splashColor: Colors.white.withOpacity(0.1),
                              highlightColor: Colors.white.withOpacity(0.05),
                              child: ListTile(
                                title: Text(
                                  widget.localizations!.langSettings,
                                  style: TextStyle(
                                    color: widget.isDark
                                        ? Colors.white
                                        : Color(0xFF161719),
                                    fontSize: 18,
                                    fontFamily: 'DM Sans',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                                leading: Icon(Icons.language,
                                    color: widget.isDark
                                        ? Colors.white
                                        : Colors.black),
                                trailing: Icon(
                                    Icons.arrow_circle_right_outlined,
                                    color: widget.isDark
                                        ? Colors.white
                                        : Colors.black),
                              ),
                              
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              widget.localizations!.support,
                              style: TextStyle(
                                color: widget.isDark
                                    ? Colors.white
                                    : Color(0xFF90909F),
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
                                color: widget.isDark
                                    ? Colors.black
                                    : Colors.white),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ContactUsPage(isDark: widget.isDark,localizations: widget.localizations,)),
                                );
                              },
                              splashColor: Colors.white.withOpacity(0.1),
                              highlightColor: Colors.white.withOpacity(0.05),
                              child: ListTile(
                                title: Text(
                                  widget.localizations!.contactUs,
                                  style: TextStyle(
                                    color: widget.isDark
                                        ? Colors.white
                                        : Color(0xFF161719),
                                    fontSize: 18,
                                    fontFamily: 'DM Sans',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                                leading: Icon(Icons.support_agent,
                                    color: widget.isDark
                                        ? Colors.white
                                        : Colors.black),
                                trailing: Icon(
                                    Icons.arrow_circle_right_outlined,
                                    color: widget.isDark
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ),
                           Container(
                            margin: EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: widget.isDark
                                    ? Colors.black
                                    : Colors.white),
                            child: InkWell(
                              onTap: () {
                                print('tıklandı');
                              },
                              splashColor: Colors.white.withOpacity(0.1),
                              highlightColor: Colors.white.withOpacity(0.05),
                              child: ListTile(
                                title: Text(
                                  widget.localizations!.aboutApp,
                                  style: TextStyle(
                                    color: widget.isDark
                                        ? Colors.white
                                        : Color(0xFF161719),
                                    fontSize: 18,
                                    fontFamily: 'DM Sans',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                                leading: Icon(Icons.info_outline_rounded,
                                    color: widget.isDark
                                        ? Colors.white
                                        : Colors.black),
                                trailing: Icon(
                                    Icons.arrow_circle_right_outlined,
                                    color: widget.isDark
                                        ? Colors.white
                                        : Colors.black),
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

void _showImageOptions(BuildContext context,AppLocalizations localizations, bool isDark) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 200,
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.camera),
              title: Text(localizations!.camera),
              onTap: () {
                // Implement camera functionality
                Navigator.pop(context); // Close the bottom sheet
              },
            ),
            ListTile(
              leading: Icon(Icons.photo),
              title: Text(localizations!.gallery),
              onTap: () {
                // Implement gallery functionality
                Navigator.pop(context); // Close the bottom sheet
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text(localizations!.delete),
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
