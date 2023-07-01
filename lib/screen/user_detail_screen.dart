import 'dart:ffi';

import 'package:datemate/models/user_model.dart';
import 'package:datemate/utils/interests.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserDetailScreen extends StatelessWidget {
  static const String route = 'UserDetailScreen';

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as UserModel;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 400,
                  width: double.infinity,
                  child: Image.network(
                    user.image!,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 40,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Color.fromARGB(255, 212, 212, 212))),
                      child: Icon(
                        // size: 14,
                        Icons.chevron_left_sharp,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Add "Nope" button functionality here
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 255, 255, 255),
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(16.0),
                            shadowColor: Color.fromARGB(255, 196, 196, 196)
                                .withOpacity(0.6),
                            elevation: 10,
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            size: 28.0,
                            color: Color.fromARGB(255, 244, 112, 36),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Add "Superlike" button functionality here
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF8A2283),
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(24.0),
                            shadowColor: Colors.black.withOpacity(0.3),
                            elevation: 4.0,
                          ),
                          child: Icon(
                            Icons.star_rounded,
                            size: 46.0,
                            color: Colors.white,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Add "Like" button functionality here
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 255, 255, 255),
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(16.0),
                            shadowColor: Color.fromARGB(255, 196, 196, 196)
                                .withOpacity(0.6),
                            elevation: 10,
                          ),
                          child: Icon(
                            Icons.favorite,
                            size: 28.0,
                            color: Color.fromARGB(255, 236, 85, 85),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 40, right: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${user.firstName} ${user.lastName}, ${calculateAge(user.birthday!)}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              '${user.interest!.first}',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 30),
                            Text(
                              'Location',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Baneshwor, Kathmandu, Nepal', // Replace with actual location
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 30),
                            Text(
                              'About Me',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                              'Sed faucibus tellus at vestibulum commodo. Maecenas euismod magna eu libero '
                              'varius, ac sodales ligula vestibulum. Integer aliquet justo id libero hendrerit dictum.',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 30),
                            Text(
                              'Interests',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Wrap(
                              spacing: 10,
                              runSpacing: 5,
                              children: user.interest!.map((interest) {
                                return Interests(interest);
                              }).toList(),
                            ),
                            SizedBox(height: 30),
                            Text(
                              'Gallery',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Image.network(
                                        'Image 1', // Replace with actual image URL
                                        height: 150,
                                      ),
                                      SizedBox(height: 10),
                                      Image.network(
                                        'Image 2', // Replace with actual image URL
                                        height: 150,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Image.network(
                                        'Image 3', // Replace with actual image URL
                                        height: 150,
                                      ),
                                      SizedBox(height: 10),
                                      Image.network(
                                        'Image 4', // Replace with actual image URL
                                        height: 150,
                                      ),
                                      SizedBox(height: 10),
                                      Image.network(
                                        'Image 5', // Replace with actual image URL
                                        height: 150,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String calculateAge(DateTime birthday) {
    final now = DateTime.now();
    final age = now.year - birthday.year;
    if (now.month < birthday.month ||
        (now.month == birthday.month && now.day < birthday.day)) {
      return (age - 1).toString();
    }
    return age.toString();
  }
}
