import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactUsPage extends StatelessWidget {
  // TextEditingController’ları tanımlıyoruz
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Contact Us'),
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
                      'We would love to hear from you!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              // İsim Alanı
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
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
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
              ),
              SizedBox(height: 15),
              // E-posta Alanı
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
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

                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border:  InputBorder.none,
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              SizedBox(height: 15),
              // Mesaj Alanı
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
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
                  controller: messageController,
                  decoration: InputDecoration(
                    labelText: 'Message',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.message),
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
                        content: Text('Your message has been sent!'),
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
                    'Send Message',
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
                      'Or reach us at:',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.phone, color: Color(0xff2CA459),),
                        SizedBox(width: 5),
                        Text(
                          '+1 (234) 567-890',
                          style: TextStyle(fontSize: 16),
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
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Follow us on:',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.facebook, color:Color(0xff2CA459),),
                          onPressed: () {
                            // Facebook sayfasına gitme işlemi
                          },
                        ),
                        IconButton(
                          icon: Icon(FontAwesomeIcons.twitter, color: Color(0xff2CA459),),
                          onPressed: () {
                            // Twitter sayfasına gitme işlemi
                          },
                        ),
                        IconButton(
                          icon: Icon(FontAwesomeIcons.linkedin, color: Color(0xff2CA459),),
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
