// lib/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // This line is now correct

class AuthService {
  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Signs in a user with the given email and password.
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      // Re-throw the exception to be caught by the UI
      throw e;
    }
  }

  /// Creates a new user with email and password, and saves their role to Firestore.
  Future<User?> signUpWithEmailAndPassword(
      String email, String password, String role) async {
    try {
      // Step 1: Create the user in Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        // Step 2: Create a document for the user in the 'users' collection
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'role': role, // Save the selected role
          'createdAt': Timestamp.now(),
        });
      }
      return user;
    } on FirebaseAuthException catch (e) {
      // Re-throw the exception to be caught by the UI
      throw e;
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}