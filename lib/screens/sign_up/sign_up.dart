// Updated sign_up.dart to include consistent UI and logic
import 'package:cyber_security_app/screens/sign_up/widgets/create_account_button.dart';
import 'package:cyber_security_app/screens/sign_up/widgets/google_sign_up_button.dart';
import 'package:cyber_security_app/screens/sign_up/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? _errorText;
  bool _acceptedTerms = false;

  void _onSignUpPressed() {
    if (!_acceptedTerms) {
      setState(() {
        _errorText = 'Please accept the terms and conditions.';
      });
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorText = 'Passwords do not match.';
      });
      return;
    }

    setState(() {
      _errorText = null;
    });

    // Proceed with the signup logic (e.g., call backend API)
    print('Sign up successful for ${_emailController.text}');
  }

  void _onGoogleSignUpPressed() {
    // Handle Google Sign-Up logic here
    print('Google Sign-Up initiated.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldWidget(
                labelText: 'Name',
                controller: _nameController,
              ),
              TextFieldWidget(
                labelText: 'Email',
                controller: _emailController,
              ),
              TextFieldWidget(
                labelText: 'Password',
                controller: _passwordController,
                isPassword: true,
              ),
              TextFieldWidget(
                labelText: 'Confirm Password',
                controller: _confirmPasswordController,
                isPassword: true,
              ),
              Row(
                children: [
                  Checkbox(
                    value: _acceptedTerms,
                    onChanged: (value) {
                      setState(() {
                        _acceptedTerms = value ?? false;
                      });
                    },
                  ),
                  const Expanded(
                    child: Text(
                      'I accept the terms and conditions.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              if (_errorText != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    _errorText!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
              CreateAccountButton(onPressed: _onSignUpPressed),
              const SizedBox(height: 16),
              GoogleSignUpButton(onPressed: _onGoogleSignUpPressed),
            ],
          ),
        ),
      ),
    );
  }
}
