import 'package:flutter/material.dart';
import 'package:app/sign_out.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(user != null ? "Welcome ${user.email!}" : ''),
          const Text('Account page'),
          const SignOutBtn(),
        ],
      ),
    );
  }
}
