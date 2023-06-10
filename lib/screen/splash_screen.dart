import 'package:datemate/screen/Auth/auth_screen.dart';
import 'package:datemate/screen/onboarding_screen.dart';
import 'package:datemate/screen/Auth/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String route = "SplashScreen";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add a delay to simulate a loading process
    Future.delayed(Duration(seconds: 2), () {
      // Navigate to the home screen after the splash screen
      Navigator.pushReplacementNamed(context, AuthScreen.route);
    });
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
              "v 0.1",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            )
          ],
        ),
      )),
    );
  }
}
