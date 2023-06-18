import 'package:datemate/screen/CreateProfile/createprofile_screen.dart';
import 'package:datemate/screen/home_screen.dart';
import 'package:datemate/screen/onboarding_screen.dart';
import 'package:datemate/screen/Auth/signin_screen.dart';
import 'package:datemate/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key});

  static const String route = 'AuthScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final currentUser = FirebaseAuth.instance.currentUser;
            return FutureBuilder<bool>(
              future: AuthService().doesUserProfileExist(currentUser!.uid),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.done) {
                  if (userSnapshot.data!) {
                    return HomeScreen();
                  } else {
                    return CreateProfileScreen();
                  }
                } else {
                  return Center(
                      child:
                          CircularProgressIndicator()); // Show loading indicator while checking profile existence
                }
              },
            );
          } else {
            return const OnboardingScreen();
          }
        },
      ),
    );
  }
}
