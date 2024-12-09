import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cyber_security_app/models/users.dart' as app_user;
import 'package:cyber_security_app/services/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditProfileScreen extends StatefulWidget {
  final String userId;
  final bool isDark;
  final AppLocalizations? localizations;

  const EditProfileScreen({
    super.key,
    required this.userId,
    required this.isDark,
    required this.localizations
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String _newName = '', _newUsername = '';
  final _formKey = GlobalKey<FormState>();
  late Future<app_user.User> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = AuthService.getUserData(widget.userId);
  }

  Future<void> _saveChanges(app_user.User user) async {
    try {
      user.name = _newName.isNotEmpty ? _newName : user.name;
      user.username = _newUsername.isNotEmpty ? _newUsername : user.username;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update(user.toFirestore());

      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text(widget.localizations!.changesSaved),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text('${widget.localizations!.changesNotSaved}  $e'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: widget.isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: widget.isDark ? Colors.black : Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_left_outlined,
            color: widget.isDark ? Colors.white : Colors.black,
          ),
        ),
        title: Text(
          widget.localizations!.editProfile,
          style: TextStyle(
            color: widget.isDark ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<app_user.User>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${widget.localizations!.anErrorOccured} ${snapshot.error}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            } else if (!snapshot.hasData) {
              return Center(
                child: Text(
                  widget.localizations!.userDataNotFound,
                  style: const TextStyle(color: Colors.white),
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
                          GestureDetector(
                            onTap: () {
                              _showImageOptions(context,widget.localizations! ,widget.isDark);
                            },
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: widget.isDark
                                  ? Colors.black
                                  : Colors.white,
                              child: Icon(
                                Icons.camera_alt,
                                size: 18,
                                color: widget.isDark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              initialValue: user.name,
                              style: TextStyle(
                                color: widget.isDark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              decoration: InputDecoration(
                                label: Text(
                                  widget.localizations!.nameAndSurname,
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
                                ),
                              ),
                              onChanged: (value) {
                                _newName = value;
                              },
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              initialValue: user.username,
                              style: TextStyle(
                                color: widget.isDark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              decoration: InputDecoration(
                                label: Text(
                                  widget.localizations!.username,
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
                                ),
                              ),
                              onChanged: (value) {
                                _newUsername = value;
                              },
                            ),
                            SizedBox(height: 20),
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
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: widget.isDark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () => _saveChanges(user),
                              child: Text(
                                widget.localizations!.save,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: widget.isDark
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                onTap: () async {
                  Navigator.pop(context);
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
                title: Text(localizations!.gallery),
                onTap: () async {
                  Navigator.pop(context);
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
                title: Text(localizations!.delete),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _image = null;
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
