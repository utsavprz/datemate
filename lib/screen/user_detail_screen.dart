import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datemate/models/user_model.dart';
import 'package:datemate/utils/interests.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserDetailScreen extends StatefulWidget {
  static const String route = 'UserDetailScreen';

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  Future<bool> isMatchedUser(UserModel user) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null && user != null) {
      final currentUserID = currentUser.uid;

      // Retrieve the current user's document from the 'userProfile' collection
      final userSnapshot = await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(currentUserID)
          .get();

      if (userSnapshot.exists) {
        // Get the 'matchedWith' field value from the current user's document
        final matchedWith =
            userSnapshot.data()?['matchedWith'] as List<dynamic>?;

        if (matchedWith != null) {
          // Check if the user from the arguments exists in the 'matchedWith' array
          return matchedWith.any((match) => match['userId'] == user.userId);
        }
      }
    }

    return false;
  }



  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as UserModel?;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            FutureBuilder<bool>(
              future: isMatchedUser(user!),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Show a loading indicator while fetching the data
                } else if (snapshot.hasError) {
                  return Text(
                      'Error: ${snapshot.error}'); // Show an error message if there's an error
                } else {
                  final isMatched = snapshot.data ?? false;
                  print('ISMATCHED${isMatched}');
                  return Stack(
                    children: [
                      Container(
                        height: 400,
                        width: double.infinity,
                        child: Image.network(
                          user!.image!,
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
                              color: Color.fromARGB(255, 158, 158, 158),
                            ),
                          ),
                        ),
                      ),
                      !isMatched
                          ? Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        // Add "Nope" button functionality here
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary:
                                            Color.fromARGB(255, 255, 255, 255),
                                        shape: CircleBorder(),
                                        padding: EdgeInsets.all(16.0),
                                        shadowColor:
                                            Color.fromARGB(255, 196, 196, 196)
                                                .withOpacity(0.6),
                                        elevation: 10,
                                      ),
                                      child: Icon(
                                        Icons.close_rounded,
                                        size: 28.0,
                                        color:
                                            Color.fromARGB(255, 244, 112, 36),
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
                                        shadowColor:
                                            Colors.black.withOpacity(0.3),
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
                                        primary:
                                            Color.fromARGB(255, 255, 255, 255),
                                        shape: CircleBorder(),
                                        padding: EdgeInsets.all(16.0),
                                        shadowColor:
                                            Color.fromARGB(255, 196, 196, 196)
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
                            )
                          : Container()
                    ],
                  );
                }
              },
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
                                  '${user!.firstName} ${user.lastName}, ${calculateAge(user.birthday!)}',
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
                            Container(
                              height: 250,
                              child: GridView.count(
                                physics: NeverScrollableScrollPhysics(),
                                crossAxisCount: 2,
                                childAspectRatio: 0.6,
                                crossAxisSpacing: 5,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FullScreenImage(
                                              imageUrl: user!.images != null &&
                                                      user.images!.isNotEmpty
                                                  ? user.images![0]
                                                  : 'https://cdn.pixabay.com/photo/2017/07/18/23/23/user-2517433__480.png'),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      child: Image.network(
                                        user!.images != null &&
                                                user.images!.isNotEmpty
                                            ? user.images![0]
                                            : 'https://cdn.pixabay.com/photo/2017/07/18/23/23/user-2517433__480.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FullScreenImage(
                                              imageUrl: user.images != null &&
                                                      user.images!.isNotEmpty
                                                  ? user.images![1]
                                                  : 'https://cdn.pixabay.com/photo/2017/07/18/23/23/user-2517433__480.png'),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      child: Image.network(
                                        user.images != null &&
                                                user.images!.isNotEmpty
                                            ? user.images![1]
                                            : 'https://cdn.pixabay.com/photo/2017/07/18/23/23/user-2517433__480.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 250,
                              child: GridView.count(
                                physics: NeverScrollableScrollPhysics(),
                                crossAxisCount: 3,
                                childAspectRatio: 0.6,
                                crossAxisSpacing: 5,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FullScreenImage(
                                              imageUrl: user.images != null &&
                                                      user.images!.isNotEmpty
                                                  ? user.images![2]
                                                  : 'https://cdn.pixabay.com/photo/2017/07/18/23/23/user-2517433__480.png'),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      child: Image.network(
                                        user.images != null &&
                                                user.images!.isNotEmpty
                                            ? user.images![2]
                                            : 'https://cdn.pixabay.com/photo/2017/07/18/23/23/user-2517433__480.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FullScreenImage(
                                              imageUrl: user.images != null &&
                                                      user.images!.isNotEmpty
                                                  ? user.images![3]
                                                  : 'https://cdn.pixabay.com/photo/2017/07/18/23/23/user-2517433__480.png'),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      child: Image.network(
                                        user.images != null &&
                                                user.images!.isNotEmpty
                                            ? user.images![3]
                                            : 'https://cdn.pixabay.com/photo/2017/07/18/23/23/user-2517433__480.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FullScreenImage(
                                              imageUrl: user.images != null &&
                                                      user.images!.isNotEmpty
                                                  ? user.images![4]
                                                  : 'https://cdn.pixabay.com/photo/2017/07/18/23/23/user-2517433__480.png'),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      child: Image.network(
                                        user.images != null &&
                                                user.images!.isNotEmpty
                                            ? user.images![4]
                                            : 'https://cdn.pixabay.com/photo/2017/07/18/23/23/user-2517433__480.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
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

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
