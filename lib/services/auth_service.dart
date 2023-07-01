import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum SignupStatus {
  success,
  userExists,
  error,
  incorrectPassword,
  userDoesnotExists
}

class AuthService {
  signInWithGoogle() async {

    // begin itneractive sign in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    // obtain auth details from request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    // create a new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<SignupStatus> signIn(
      String email, String password, BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Successfully signed in
      Navigator.pop(context);
      return SignupStatus.success;
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      if (e.code == 'user-not-found') {
        // User not found
        return SignupStatus.userDoesnotExists;
      } else if (e.code == 'wrong-password') {
        // Incorrect password
        return SignupStatus.incorrectPassword;
      } else {
        // Other sign-in error
        return SignupStatus.error;
      }
    }
  }

  Future<SignupStatus> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      // Check if the user already exists
      List<String> signInMethods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (signInMethods.isNotEmpty) {
        // User already exists with the given email
        return SignupStatus.userExists;
      }

      // Proceed with creating the user account
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Signup successful
      return SignupStatus.success;
    } catch (error) {
      // Handle signup errors
      print('Error during signup: $error');
      return SignupStatus.error;
    }
  }

  Future<bool> doesUserProfileExist(String uid) async {
    final userDoc =
        FirebaseFirestore.instance.collection('userProfile').doc(uid);
    final userSnapshot = await userDoc.get();
    return userSnapshot.exists;
  }
}
