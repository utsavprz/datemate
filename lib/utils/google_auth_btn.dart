import 'package:datemate/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthBtn extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await AuthService().signInWithGoogle();
        Navigator.pop(context);
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Image.asset(
            'assets/images/googleLogo.png',
            height: 30,
            width: 30,
            isAntiAlias: true,
          ),
        ),
      ),
    );
  }
}
