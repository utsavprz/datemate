import 'package:datemate/models/user_model.dart';
import 'package:datemate/screen/match_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MatchesScreen extends StatefulWidget {
  static const String route = 'MatchesScreen';

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<bool> userLikedByCurrentUser(UserModel user) async {
    final currentUser = await _auth.currentUser;
    final currentUserDoc =
        _firestore.collection('userProfile').doc(user.userId);

    final currentUserData = await currentUserDoc.get();
    final likedProfiles = currentUserData.data()?['likedProfiles'];

    if (likedProfiles != null) {
      // Check if the user ID exists in the likedProfiles array
      final likedUserIds =
          likedProfiles.map((profile) => profile['userId']).toList();
      if (likedUserIds.contains(currentUser!.uid)) {
        return true;
      }
    }

    return false;
  }

  void showMatchScreen(UserModel user) {
    Navigator.pushNamed(context, MatchScreen.route, arguments: user);
  }

  Future<void> handleSwipeRight(UserModel user) async {
    final currentUser = await _auth.currentUser;
    final currentUserDoc =
        _firestore.collection('userProfile').doc(user.userId);
    final LoggedUserData =
        _firestore.collection('userProfile').doc(currentUser!.uid);

    final serverTimestamp = DateTime.now();

    // Update the liked user's data to include the liker's information
    await currentUserDoc.update({
      'likedBy': FieldValue.arrayUnion([
        {
          'userId': currentUser.uid,
          'timestamp': serverTimestamp.toString(),
        },
      ]),
    });

    await LoggedUserData.update({
      'likedProfiles': FieldValue.arrayUnion([
        {
          'userId': user.userId,
          'timestamp': serverTimestamp,
        },
      ]),
    });

    // Check for mutual likes and display match screen if found
    final likedByCurrentUser = await userLikedByCurrentUser(user);
    if (likedByCurrentUser) {
      await LoggedUserData.update({
        'matchedWith': FieldValue.arrayUnion([
          {
            'userId': user.userId,
            'timestamp': serverTimestamp,
          },
        ]),
      });
      await currentUserDoc.update({
        'matchedWith': FieldValue.arrayUnion([
          {
            'userId': currentUser.uid,
            'timestamp': serverTimestamp,
          },
        ]),
      });
      // Notify both users and display match screen
      showMatchScreen(user);

      // Remove the profile from potential matches or hide it temporarily
      await currentUserDoc
          .collection('potentialMatches')
          .doc(currentUser.uid)
          .delete();
      await currentUserDoc
          .collection('likedProfiles')
          .doc(currentUser.uid)
          .delete();

      // Retrieve current user data
      final currentUserData = await LoggedUserData.get();
      final userName = currentUserData['firstName'];
      final userImage = currentUserData['image'];

      // Add a notification for the liked user
      await _firestore.collection('notifications').add({
        'userId': user.userId,
        'userName': userName,
        'userImage': userImage,
        'message': 'You have been matched with $userName!',
        'time': DateFormat('hh:mm a').format(serverTimestamp),
        'read': false,
      });
    }

    // Log the swipe action in the swipeData collection
    await _firestore.collection('swipeData').add({
      'userId': currentUser.uid,
      'profileId': user.userId,
      'action': 'right',
      'timestamp': serverTimestamp.toString(),
    });
  }

  Stream<List<LikedProfileModel>> fetchLikedProfiles() {
    final currentUser = FirebaseAuth.instance.currentUser;

    return FirebaseFirestore.instance
        .collection('userProfile')
        .doc(currentUser!.uid)
        .snapshots()
        .map((documentSnapshot) {
      final likedProfileData = documentSnapshot.data();
      if (likedProfileData != null) {
        final likedByProfiles = likedProfileData['likedBy'];
        final matchedWithUsers = likedProfileData['matchedWith'] ?? [];

        final likedProfiles = likedByProfiles
            .where((likedProfile) => !matchedWithUsers.any((matchedUser) =>
                matchedUser['userId'] == likedProfile['userId']))
            .map<LikedProfileModel>((likedProfile) {
          final likedProfileId = likedProfile['userId'];
          final likedProfileTimestamp = likedProfile['timestamp'];
          return LikedProfileModel(
            id: likedProfileId,
            userId: likedProfileId,
            timestamp: DateTime.parse(likedProfileTimestamp),
          );
        }).toList();

        return likedProfiles;
      } else {
        return <LikedProfileModel>[];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 50, right: 50, top: 30, bottom: 30),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 30, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Matches',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontFamily: 'SKModernistBold',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 230,
                          child: Text(
                            'This is a list of people who have liked you and your matches',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Container(
                    //   width: 40,
                    //   height: 40,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(10),
                    //     border: Border.all(
                    //       color: Color.fromARGB(255, 212, 212, 212),
                    //     ),
                    //   ),
                    //   child: IconButton(
                    //     splashRadius: 1,
                    //     icon: Icon(
                    //       Icons.sort,
                    //       color: Color.fromARGB(255, 215, 78, 91),
                    //     ),
                    //     onPressed: () {},
                    //   ),
                    // ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<List<LikedProfileModel>>(
                  stream: fetchLikedProfiles(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final likedProfiles = snapshot.data!;
                      return likedProfiles.isEmpty
                          ? Center(
                              child: Text('No Matches'),
                            )
                          : GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                              ),
                              itemCount: likedProfiles.length,
                              itemBuilder: (context, index) {
                                final likedProfile = likedProfiles[index];
                                return FutureBuilder<
                                    DocumentSnapshot<Map<String, dynamic>>>(
                                  future: FirebaseFirestore.instance
                                      .collection('userProfile')
                                      .doc(likedProfile.userId)
                                      .get(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final userData = snapshot.data!.data()!;
                                      final user = UserModel.fromJson(userData);

                                      return GestureDetector(
                                        onTap: () {
                                          // Handle profile tap
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                image: DecorationImage(
                                                  image:
                                                      NetworkImage(user.image!),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Container(
                                                padding: EdgeInsets.all(8.0),
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                child: Text(
                                                  '${user.firstName} ${user.lastName}',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.center,
                                              child: Container(
                                                // padding: EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    IconButton(
                                                      onPressed: () {
                                                        // Handle like button tap
                                                        handleSwipeRight(user);
                                                      },
                                                      icon:
                                                          Icon(Icons.favorite),
                                                      color: Colors.red,
                                                      iconSize: 35,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return Container(); // Placeholder widget
                                    }
                                  },
                                );
                              },
                            );
                    } else if (snapshot.hasError) {
                      print(snapshot.error);
                      return Center(
                        child: Text('No matches yet'),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LikedProfileModel {
  final String id;
  final String userId;
  final DateTime timestamp;

  LikedProfileModel({
    required this.id,
    required this.userId,
    required this.timestamp,
  });
}
