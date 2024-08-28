import 'package:app/login_screen.dart';
import 'package:app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthStateHandler extends StatelessWidget {
  const AuthStateHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Check if the snapshot has data (i.e., user is signed in)
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;

          if (user == null) {
            // If the user is not signed in, show the login screen
            return const LoginScreen();
          } else {
            // If the user is signed in, show the logged-in screen
            return const NavigationBarApp();
          }
        } else {
          // While waiting for the authentication state to load, show a loading spinner
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
