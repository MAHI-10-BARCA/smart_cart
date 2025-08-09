// lib/screens/auth_gate.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'login_screen.dart'; // We will create this next

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If the snapshot has no data, it means the user is not logged in.
        if (!snapshot.hasData) {
          return const LoginScreen(); // Show login screen
        }

        // If the user is logged in, show the home screen.
        return const HomeScreen();
      },
    );
  }
}