import 'package:cyber_security_app/models/user_model.dart';
import 'package:cyber_security_app/screens/account_security_screen.dart';
import 'package:cyber_security_app/screens/contact_us_screen.dart';
import 'package:cyber_security_app/screens/edit_profile_screen.dart';
import 'package:cyber_security_app/screens/language_settings_screen.dart';
import 'package:cyber_security_app/screens/notification_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  //final int userId;
  final bool isDark;
  final AppLocalizations? localizations;
  final UserModel user;

  const ProfileScreen({
    super.key,
    required this.isDark,
    required this.localizations,
    required this.user,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize the future to fetch user data
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Set status bar color to transparent
      statusBarIconBrightness: Brightness.light,
      // Light icons for dark background
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDark ? Colors.black : Colors.white,
      body: SafeArea(
          child: Column(
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
                      backgroundImage: NetworkImage(widget.user.imageUrl!),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  widget.user.firstName!,
                  style: TextStyle(
                    color: widget.isDark ? Colors.white : Color(0xFF222222),
                    fontSize: 24,
                    fontFamily: 'Prompt',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
                Text(
                  widget.user.email!,
                  style: TextStyle(
                    color: widget.isDark ? Colors.white : Color(0xFF888888),
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
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 5),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      widget.localizations!.accSettings,
                      style: TextStyle(
                        color: widget.isDark ? Colors.white : Color(0xFF90909F),
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
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: widget.isDark ? Colors.black : Colors.white,
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfileScreen(
                                    user: widget.user,
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
                            color: widget.isDark ? Colors.white : Colors.black),
                        trailing: Icon(
                          Icons.arrow_circle_right_outlined,
                          color: widget.isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: widget.isDark ? Colors.black : Colors.white),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationSettings(
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
                        leading: Icon(Icons.notifications_active_outlined,
                            color: widget.isDark ? Colors.white : Colors.black),
                        trailing: Icon(Icons.arrow_circle_right_outlined,
                            color: widget.isDark ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: widget.isDark ? Colors.black : Colors.white),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccountSecurityScreen(
                                  isDark: widget.isDark,
                                  localizations: widget.localizations)),
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
                            color: widget.isDark ? Colors.white : Colors.black),
                        trailing: Icon(Icons.arrow_circle_right_outlined,
                            color: widget.isDark ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: widget.isDark ? Colors.black : Colors.white),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LanguageSettings(
                                    localizations: widget.localizations,
                                    isDark: widget.isDark,
                                  )),
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
                            color: widget.isDark ? Colors.white : Colors.black),
                        trailing: Icon(Icons.arrow_circle_right_outlined,
                            color: widget.isDark ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      widget.localizations!.support,
                      style: TextStyle(
                        color: widget.isDark ? Colors.white : Color(0xFF90909F),
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
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: widget.isDark ? Colors.black : Colors.white),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ContactUsPage(
                                    isDark: widget.isDark,
                                    localizations: widget.localizations,
                                  )),
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
                            color: widget.isDark ? Colors.white : Colors.black),
                        trailing: Icon(Icons.arrow_circle_right_outlined,
                            color: widget.isDark ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
