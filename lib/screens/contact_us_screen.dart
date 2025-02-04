import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContactUsPage extends StatelessWidget {
  final bool isDark;
  final AppLocalizations? localizations;
  ContactUsPage({super.key, required this.isDark, required this.localizations});
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : Colors.black,
        ),
        title: Text(
          localizations!.contactUs,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      '404 Academy',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff2CA459),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      localizations!.wouldHear,
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.white : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              // İsim Alanı
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  color: isDark ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: TextField(
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: localizations!.nameAndSurname,
                    labelStyle: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.person,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              // E-posta Alanı
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  color: isDark ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: TextField(
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle:
                        TextStyle(color: isDark ? Colors.white : Colors.black),
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.email,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              SizedBox(height: 15),
              // Mesaj Alanı
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  color: isDark ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: TextField(
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  controller: messageController,
                  decoration: InputDecoration(
                    labelText: localizations!.message,
                    labelStyle: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.message,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  maxLines: 5,
                ),
              ),
              SizedBox(height: 20),
              // Gönder Butonu
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Gönderim işlemleri
                    String name = nameController.text;
                    String email = emailController.text;
                    String message = messageController.text;

                    // Burada gönderim mantığı veya API entegrasyonu yapılabilir.
                    print("Name: $name\nEmail: $email\nMessage: $message");

                    // Kullanıcıya geri bildirim
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(localizations!.messageSent),
                        backgroundColor: Colors.teal,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    backgroundColor: Color(0xff2CA459),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    localizations!.sendMessage,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 30),
              // Alt Bilgi Alanı: Telefon ve Sosyal Medya
              Divider(),
              Center(
                child: Column(
                  children: [
                    Text(
                      localizations!.orReach,
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.white : Colors.grey,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.phone,
                          color: Color(0xff2CA459),
                        ),
                        SizedBox(width: 5),
                        Text(
                          '+1 (234) 567-890',
                          style: TextStyle(
                              fontSize: 16,
                              color: isDark ? Colors.white : Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.email, color: Color(0xff2CA459)),
                        SizedBox(width: 5),
                        Text(
                          'contact@404academy.com',
                          style: TextStyle(
                              fontSize: 16,
                              color: isDark ? Colors.white : Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      localizations!.followUs,
                      style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.white : Colors.grey),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.facebook,
                            color: Color(0xff2CA459),
                          ),
                          onPressed: () {
                            // Facebook sayfasına gitme işlemi
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            FontAwesomeIcons.twitter,
                            color: Color(0xff2CA459),
                          ),
                          onPressed: () {
                            // Twitter sayfasına gitme işlemi
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            FontAwesomeIcons.linkedin,
                            color: Color(0xff2CA459),
                          ),
                          onPressed: () {
                            // LinkedIn sayfasına gitme işlemi
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
