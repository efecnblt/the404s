import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyber_security_app/screens/dashboard/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/api_services.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Sign in with email and password using Firebase Authentication.
  static Future<void> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      // Firebase Authentication
      print('Attempting Firebase login...');
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      User? user = userCredential.user;

      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-null',
          message: 'Firebase user data is null.',
        );
      }
      print('Firebase login successful. UID: ${user.uid}');

      // Fetch user details from backend
      final firebaseUID = user.uid;
      print('Fetching backend user details for UID: $firebaseUID...');
      final backendUser = await ApiService.getRequest(
        '/api/Users/getbyfirebaseuid/$firebaseUID',
      );

      if (backendUser == null || !backendUser.containsKey('id')) {
        print('Backend is offline or user not found.');

        return;
      }

      // Extract backend user ID and navigate to Dashboard
      final userId = backendUser['id'];
      print('Backend user ID: $userId');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Dashboard(
            userId: userId,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth error: ${e.code}');
      _showErrorDialog(context, _getFirebaseErrorMessage(e.code));
    } catch (e) {
      print('Error during login: $e');
      _showErrorDialog(
        context,
        'An unexpected error occurred. Please try again later.',
      );
    }
  }

  static Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleSignInAccount =
          await GoogleSignIn().signIn();
      if (googleSignInAccount == null) {
        // User canceled the sign-in
        print('Google sign-in canceled by user.');
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      print('Signing in to Firebase with Google credential...');
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-null',
          message: 'User data is null after Google sign-in.',
        );
      }
      print('Firebase Google sign-in successful. UID: ${user.uid}');

      // Fetch user details from backend
      final firebaseUID = user.uid;
      print('Fetching backend user details for UID: $firebaseUID...');
      final backendUser = await ApiService.getRequest(
        '/api/Users/getbyfirebaseuid/$firebaseUID',
      );

      if (backendUser == null || !backendUser.containsKey('id')) {
        print('Backend is offline or user not found.');
        return;
      }

      // Extract backend user ID and navigate to Dashboard
      final userId = backendUser['id'];
      print('Backend user ID: $userId');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Dashboard(userId: userId),
        ),
      );
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth error during Google sign-in: ${e.code}');
      _showErrorDialog(context, _getFirebaseErrorMessage(e.code));
    } catch (e) {
      print('Error during Google sign-in: $e');
      _showErrorDialog(
        context,
        'An unexpected error occurred. Please try again later.',
      );
    }
  }

  /// Helper function to handle backend offline scenarios.

  /// Helper function to display error dialogs.
  static void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Maps Firebase authentication error codes to user-friendly messages.
  static String _getFirebaseErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-email':
        return 'The email address is not valid.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
