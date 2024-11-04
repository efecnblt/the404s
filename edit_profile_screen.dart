import 'package:flutter/material.dart';
import 'package:cyber_security_app/models/users.dart' as app_user;
import 'package:cyber_security_app/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import '../models/users.dart';
import '../services/auth_service.dart';
import 'package:cyber_security_app/models/users.dart' as app_user;
import 'package:shared_preferences/shared_preferences.dart';
import 'login_or_signup_screen.dart';
import 'profile_screen.dart';

class EditProfileScreen extends StatefulWidget {
  final String userId;
  const EditProfileScreen({super.key, required this.userId});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String _newEmail = '', _newUsername = '', _newName = '';
  final _formKey = GlobalKey<FormState>();
  late Future<app_user.User> _userFuture;
  @override
  void initState() {
    super.initState();
    // Initialize the future to fetch user data
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Set status bar color to transparent
      statusBarIconBrightness:
          Brightness.light, // Light icons for dark background
    ));
    _userFuture = AuthService.getUserData(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_left_outlined)),
        title: Text("Edit Profile"),
      ),
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
              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 70,
                            backgroundImage: NetworkImage(user.imageUrl),
                          ),
                          // Circular icon button
                          GestureDetector(
                            onTap: () {
                              _showImageOptions(
                                  context); // Method to show options for changing the image
                            },
                            child: CircleAvatar(
                              radius: 20, // Smaller radius for the icon button
                              backgroundColor: Colors
                                  .yellow, // Background color for visibility
                              child: Icon(
                                Icons
                                    .camera_alt, // Icon to represent image change
                                size: 18,
                                color: Colors.black, // Color of the icon
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                autovalidateMode: AutovalidateMode.always,
                                initialValue: user.name,
                                decoration: InputDecoration(
                                    label: Text("Name and Surname"),
                                    prefixIcon: Icon(Icons.person)),
                                onSaved: (value) {
                                  setState(() {
                                    _newName = value!;
                                  });
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                autovalidateMode: AutovalidateMode.always,
                                validator: (value) {
                                  if (value!.length < 4 || value.length > 20) {
                                    return "Username en az 4 en fazla 20 karakterli olabilir!";
                                  } else
                                    return null;
                                },
                                textInputAction: TextInputAction.done,
                                autofocus: false,
                                initialValue: user.username,
                                decoration: InputDecoration(
                                    label: Text("Username"),
                                    prefixIcon: Icon(Icons.person)),
                                onChanged: (value) {
                                  setState(() {
                                    _newUsername = value;
                                  });
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                readOnly: true,
                                initialValue: user.email,
                                decoration: InputDecoration(
                                    label: Text("E-mail"),
                                    prefixIcon: Icon(Icons.mail)),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.yellow),
                                  onPressed: () {
                                    bool _validate =
                                        _formKey.currentState!.validate();
                                    if (_validate) {
                                      user.username = _newUsername;
                                      user.name = _newName;
                                      _formKey.currentState!.save();
                                      Map<String, dynamic> updatedData = {
                                        user.username: _newUsername,
                                        user.name: _newName
                                      };
                                      AuthService.updateUserData(
                                          context, widget.userId, updatedData);
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          content: Text(
                                              'Değişiklikler kaydedildi!, New Username: ${user.username},New Name: ${user.name}'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () async {
                                                Navigator.pop(
                                                  context,
                                                );
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          content: const Text(
                                              'Değişiklikler kaydedilemedi!'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () async {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                  child: Text(
                                    "Kaydet",
                                    style: TextStyle(fontSize: 20),
                                  )),
                              IconButton(
                                  onPressed: () {
                                    Map<String, dynamic> updatedData = {
                                      user.username: _newUsername,
                                      user.name: _newName
                                    };
                                    AuthService.updateUserData(
                                        context, widget.userId, updatedData);
                                    Navigator.pop(context, user);
                                  },
                                  icon: Icon(Icons.arrow_left_outlined))
                            ],
                          ))
                    ],
                  ),
                ),
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
