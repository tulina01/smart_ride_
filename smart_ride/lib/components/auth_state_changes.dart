import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../View/login.view.dart';
import '../View/menu.dart';

class AuthChanges extends StatelessWidget {
  const AuthChanges({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          if (snapshot.hasData) {
            return const Menu();
          } else {
            return LoginView();
          }
        }
      },
    );
  }
}