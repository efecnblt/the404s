// Updated login_prompt.dart to ensure UI consistency
import 'package:flutter/material.dart';

class LoginPrompt extends StatelessWidget {
  final VoidCallback onLoginPressed;
  final String message;

  const LoginPrompt(
      {Key? key, required this.onLoginPressed, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          message,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        TextButton(
          onPressed: onLoginPressed,
          child: const Text(
            'Log In',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}
