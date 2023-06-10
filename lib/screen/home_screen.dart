import 'package:datemate/screen/Auth/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const String route = 'Home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Home'),
            Text('${FirebaseAuth.instance.currentUser}'),
            ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) => {
                        Navigator.pushReplacementNamed(
                            context, AuthScreen.route)
                      });
                },
                child: Text('Logout'))
          ],
        ),
      )),
    );
  }
}
