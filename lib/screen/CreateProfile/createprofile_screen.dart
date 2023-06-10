import 'dart:io';

import 'package:datemate/screen/Auth/auth_screen.dart';
import 'package:datemate/screen/CreateProfile/profile1_screen.dart';
import 'package:datemate/screen/CreateProfile/profile2_screen.dart';
import 'package:datemate/screen/CreateProfile/profile3_screen.dart';
import 'package:datemate/screen/CreateProfile/profile4_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});
  static const String route = "CreateProfileScreen";

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  PageController _pageController = PageController();

  int _currentPageIndex = 0;

  // Profile1
  String? _firstName;
  String? _lastName;
  DateTime? _selectedDate;
  File? _img;

  void setDataProfile1(
      String firstName, String lastName, DateTime selectedDate, File? img) {
    // Code to set the data received from Profile1Screen
    setState(() {
      _firstName = firstName;
      _lastName = lastName;
      _selectedDate = selectedDate;
      _img = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          // display back button only if the pageindex is greater than 0
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50, top: 50),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Color.fromARGB(255, 212, 212, 212))),
                  child: IconButton(
                    splashRadius: 1,
                    icon: Icon(
                      Icons.chevron_left_sharp,
                      color: Color.fromARGB(255, 215, 78, 91),
                    ),
                    onPressed: () {
                      if (_currentPageIndex == 0) {
                        FirebaseAuth.instance.signOut().then((value) => {
                              Navigator.pushReplacementNamed(
                                  context, AuthScreen.route)
                            });
                      } else {
                        _pageController.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              children: [
                Profile1Screen(pageController: _pageController),
                Profile2Screen(pageController: _pageController),
                Profile3Screen(pageController: _pageController),
                Profile4Screen(pageController: _pageController),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
