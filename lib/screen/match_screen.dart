import 'package:flutter/material.dart';
import 'package:datemate/models/user_model.dart';

class MatchScreen extends StatelessWidget {
  static const String route = 'MatchScreen';

  const MatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as UserModel;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(user.image!),
              ),
              SizedBox(height: 30),
              SizedBox(height: 10),
              Text(
                'It\'s a match with ${user.firstName}',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 220, 78, 78)),
              ),
              SizedBox(
                height: 10,
              ),
              Text('Start a conversation now in the chat room'),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Handle button action, e.g., navigate back to the swipe screen
                  Navigator.pop(context);
                },
                child: Text(
                  'Continue Swiping',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
