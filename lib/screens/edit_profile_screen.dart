import 'dart:io';

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
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final String userId;
  final bool isDark;
  const EditProfileScreen(
      {super.key, required this.userId, required this.isDark});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

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
      backgroundColor: widget.isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: widget.isDark ? Colors.black : Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_left_outlined,
                color: widget.isDark ? Colors.white : Colors.black)),
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: widget.isDark ? Colors.white : Colors.black,
          ),
        ),
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
                            backgroundImage: _image != null
                                ? FileImage(_image!)
                                : NetworkImage(user.imageUrl) as ImageProvider,
                          ),
                          // Circular icon button
                          GestureDetector(
                            onTap: () {
                              _showImageOptions(
                                  context); // Method to show options for changing the image
                            },
                            child: CircleAvatar(
                              radius: 20, // Smaller radius for the icon button
                              backgroundColor: widget.isDark
                                  ? Colors.black
                                  : Colors
                                      .white, // Background color for visibility
                              child: Icon(
                                  Icons
                                      .camera_alt, // Icon to represent image change
                                  size: 18,
                                  color: widget.isDark
                                      ? Colors.white
                                      : Colors.black // Color of the icon
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
                                style: TextStyle(
                                  color: widget.isDark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                decoration: InputDecoration(
                                    label: Text(
                                      "Name and Surname",
                                      style: TextStyle(
                                        color: widget.isDark
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: widget.isDark
                                          ? Colors.white
                                          : Colors.black,
                                    )),
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
                                style: TextStyle(
                                  color: widget.isDark
                                      ? Colors.white
                                      : Colors.black,
                                ),
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
                                    label: Text(
                                      "Username",
                                      style: TextStyle(
                                          color: widget.isDark
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: widget.isDark
                                          ? Colors.white
                                          : Colors.black,
                                    )),
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
                                style: TextStyle(
                                    color: widget.isDark
                                        ? Colors.white
                                        : Colors.black),
                                readOnly: true,
                                initialValue: user.email,
                                decoration: InputDecoration(
                                    label: Text(
                                      "E-mail",
                                      style: TextStyle(
                                          color: widget.isDark
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.mail,
                                      color: widget.isDark
                                          ? Colors.white
                                          : Colors.black,
                                    )),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: widget.isDark
                                          ? Colors.white
                                          : Colors.black),
                                  onPressed: () {
                                    bool _validate =
                                        _formKey.currentState!.validate();
                                    if (_validate) {
                                      setState(() {
                                        user.username = _newUsername;
                                        user.name = _newName;
                                        _formKey.currentState!.save();
                                      });

                                      /*     Map<String, dynamic> updatedData = {
                                        user.username: _newUsername,
                                        user.name: _newName
                                      };
                                      AuthService.updateUserData(
                                          context, widget.userId, updatedData);*/
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          content:
                                              Text('Değişiklikler kaydedildi!'),
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
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: widget.isDark
                                            ? Colors.black
                                            : Colors.white),
                                  )),
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
                onTap: () async {
                  Navigator.pop(context); // Close the bottom sheet
                  final pickedFile =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      _image = File(pickedFile.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Gallery'),
                onTap: () async {
                  Navigator.pop(context); // Close the bottom sheet
                  final pickedFile =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _image = File(pickedFile.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  setState(() {
                    _image = null; // Remove the current image
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
