import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_model.dart';
import '../services/api_services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;
  final bool isDark;
  final AppLocalizations? localizations;

  const EditProfileScreen({
    Key? key,
    required this.user,
    required this.isDark,
    required this.localizations,
  }) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final ImagePicker _picker = ImagePicker();
  late String _username;
  late String _firstName;
  late String _lastName;
  //late String _biography;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    _username = widget.user.username ?? '';
    _firstName = widget.user.firstName ?? '';
    _lastName = widget.user.lastName ?? '';
    // _biography = widget.user.biography ?? '';
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      try {
        final updatedUser = {
          'userId': widget.user.id,
          'username': _username,
          'firstName': _firstName,
          'lastName': _lastName,
          'biography': '_biography',
          'imageUrl': widget.user.imageUrl ?? '',
        };

        print('Debug: Sending profile update PUT request...');
        await ApiService.putRequest('/api/Users/updateprofile', updatedUser);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.localizations!.updateSuccess)),
        );
      } catch (e) {
        print('Error saving changes: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.localizations!.failedUpdate)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: widget.isDark ? Colors.white : Colors.black,
        ),
        title: Text(
          widget.localizations!.editProfile,
          style: TextStyle(color: widget.isDark ? Colors.white : Colors.black),
        ),
        backgroundColor: widget.isDark ? Colors.black : Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildProfilePicture(),
              const SizedBox(height: 20),
              _buildTextField(
                label: widget.localizations!.username,
                initialValue: _username,
                onChanged: (value) => _username = value,
              ),
              _buildTextField(
                label: widget.localizations!.firstName,
                initialValue: _firstName,
                onChanged: (value) => _firstName = value,
              ),
              _buildTextField(
                label: widget.localizations!.lastName,
                initialValue: _lastName,
                onChanged: (value) => _lastName = value,
              ),
              /*_buildTextField(
                label: 'Biography',
                initialValue: _biography,
                onChanged: (value) => _biography = value,
              ),*/
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveChanges,
                child: Text(widget.localizations!.save),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePicture() {
    return CircleAvatar(
      radius: 70,
      backgroundImage: _image != null
          ? FileImage(_image!)
          : NetworkImage(widget.user.imageUrl!),
      child: GestureDetector(
        onTap: () => _showImageOptions(),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.black54,
          child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required ValueChanged<String> onChanged,
  }) {
    return TextFormField(
      style: TextStyle(color: widget.isDark ? Colors.white : Colors.black),
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
            color: widget.isDark ? Colors.white : Colors.black, fontSize: 24),
      ),
      onChanged: onChanged,
    );
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 150,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: Text(widget.localizations!.camera),
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
                leading: const Icon(Icons.photo),
                title: Text(widget.localizations!.gallery),
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
            ],
          ),
        );
      },
    );
  }
}
