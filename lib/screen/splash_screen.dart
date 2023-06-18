import 'package:datemate/screen/Auth/auth_screen.dart';
import 'package:datemate/screen/onboarding_screen.dart';
import 'package:datemate/screen/Auth/signin_screen.dart';
import 'package:datemate/statemanagement/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const String route = "SplashScreen";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    getuserdata();
    Future.delayed(Duration(seconds: 2)).then(
        (value) => Navigator.pushReplacementNamed(context, AuthScreen.route));
    // Navigate to the home screen after the splash screen
  }

  Future<void> getuserdata() async {
    await ref.read(userProvider).fetchUserDataFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logoWithName.png',
                width: 180,
              ),
              Text(
                'v 0.1',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
