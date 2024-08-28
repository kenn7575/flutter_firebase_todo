import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignOutBtn extends StatelessWidget {
  const SignOutBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await FirebaseAuth.instance.signOut();
      },
      child: const Text('Sign out'),
    );
  }
}
