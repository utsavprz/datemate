import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datemate/models/user_model.dart';
import 'package:datemate/screen/match_screen.dart';
import 'package:datemate/screen/user_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SwipeScreen extends StatefulWidget {
  @override
  _SwipeScreenState createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen>
    with SingleTickerProviderStateMixin {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ...

  Future<List<UserModel>> fetchFilteredUsers() async {
    // Get the current user's information
    final currentUser = await _auth.currentUser;
    final currentUserDoc =
        await _firestore.collection('userProfile').doc(currentUser!.uid).get();
    final currentUserData = currentUserDoc.data();

    if (currentUserData == null) {
      return []; // Return an empty list if the current user's data is not found
    }

    final currentUserInterests =
        List<String>.from(currentUserData['interest'] ?? []);
    final currentUserGender = currentUserData['gender'];
    final currentUserBirthday = DateTime.parse(currentUserData['birthday']);

    // Calculate the minimum and maximum birth years based on the age difference criteria
    final maxBirthYear = currentUserBirthday.year - 4;
    final minBirthYear = currentUserBirthday.year + 4;

    // Query users with opposite gender
    final filteredUsersSnapshot = await _firestore
        .collection('userProfile')
        .where('gender', isNotEqualTo: currentUserGender)
        .get();

    final filteredUsersData =
        filteredUsersSnapshot.docs.map((doc) => doc.data()).toList();

    // Filter and map the fetched user data to UserModel objects based on interests and swiped profiles
    final likedProfiles = currentUserData['likedProfiles'] ?? [];
    final dislikedProfiles = currentUserData['dislikedProfiles'] ?? [];
    final filteredUsers = filteredUsersData.map((userData) {
      final userInterests = List<String>.from(userData['interest'] ?? []);

      // Check for similar interests
      final hasSimilarInterests = userInterests
          .any((interest) => currentUserInterests.contains(interest));
      if (!hasSimilarInterests) {
        return null; // Skip users without similar interests
      }

      final userId = userData['userId'];

      // Check if the user has been swiped or disliked by the current user
      final isLiked =
          likedProfiles.any((profile) => profile['userId'] == userId);
      final isDisliked =
          dislikedProfiles.any((profile) => profile['userId'] == userId);
      if (isLiked || isDisliked) {
        return null; // Skip users who have been swiped or disliked
      }

      // Convert the stored date string to DateTime object
      final userBirthday = DateTime.parse(userData['birthday']);

      // Perform additional filtering in memory
      if (userBirthday.year > minBirthYear ||
          userBirthday.year < maxBirthYear) {
        return null; // Skip users outside the desired age range
      }

      return UserModel(
        id: userData['id'],
        userId: userId,
        firstName: userData['firstName'],
        lastName: userData['lastName'],
        birthday: userBirthday,
        phoneNumber: userData['phoneNumber'],
        gender: userData['gender'],
        image: userData['image'],
        lat: userData['lat'],
        lon: userData['lon'],
        interest: List<String>.from(userData['interest'] ?? []),
      );
    }).toList();

    return filteredUsers
        .where((user) => user != null)
        .cast<UserModel>()
        .toList();
  }

  // ...

  Future<void> handleSwipeLeft(UserModel user) async {
    final currentUser = await _auth.currentUser;
    final currentUserDoc =
        _firestore.collection('userProfile').doc(currentUser!.uid);

    // Get the current server timestamp
    final serverTimestamp = DateTime.now();

    // Update the user's preferences or indicate not interested
    await currentUserDoc.update({
      'dislikedProfiles': FieldValue.arrayUnion([
        {
          'userId': user.userId,
          'timestamp': serverTimestamp,
        }
      ]),
    });

    // Log the swipe action in the swipeData collection
    await _firestore.collection('swipeData').add({
      'userId': currentUser.uid,
      'profileId': user.userId,
      'action': 'left',
      'timestamp': serverTimestamp,
    });
  }

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
        _firestore.collection('userProfile').doc(currentUser!.uid);

// Get the current server timestamp
    final serverTimestamp = DateTime.now();

    // Update the user's preferences or indicate not interested
    await currentUserDoc.update({
      'likedProfiles': FieldValue.arrayUnion([
        {
          'userId': user.userId,
          'timestamp': serverTimestamp,
        }
      ]),
    });

    // Check for mutual likes and display match screen if found
    final likedByUser = await userLikedByCurrentUser(user);
    if (likedByUser) {
      print("USER LIKED BY USER");
      // Notify both users and display match screen
      showMatchScreen(user);

      // Remove the profile from potential matches or hide it temporarily
      await currentUserDoc
          .collection('potentialMatches')
          .doc(user.userId)
          .delete();
      await currentUserDoc
          .collection('likedProfiles')
          .doc(user.userId)
          .delete();
    }

    // Log the swipe action in the swipeData collection
    await _firestore.collection('swipeData').add({
      'userId': currentUser.uid,
      'profileId': user.userId,
      'action': 'right',
      'timestamp': serverTimestamp,
    });
  }

  // ...

  Widget _buildSwipeScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(bottom: 10, right: 20, left: 20, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Find Your Match',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontFamily: 'SKModernistBold',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Kathmandu, Nepal',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
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
                          Icons.filter_list_outlined,
                          color: Color.fromARGB(255, 215, 78, 91),
                        ),
                        onPressed: () {},
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<List<UserModel>>(
                  future: fetchFilteredUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No users to swipe currently'));
                    } else {
                      final userList = snapshot.data!;
                      print('USERLIST:${userList.toString()}');

                      return AppinioSwiper(
                        cardsCount: userList.length,
                        onSwiping: (AppinioSwiperDirection direction) {
                          print(direction.toString());
                        },
                        onEnd: () {
                          Center(
                            child: Text('No more users to swipe.'),
                          );
                        },
                        swipeOptions: AppinioSwipeOptions.horizontal,
                        onSwipe: (index, direction) async {
                          index = index - 1;

                          final user = userList[index];

                          if (direction == AppinioSwiperDirection.left) {
                            await handleSwipeLeft(user)
                                .then((value) => print(user.firstName));
                          } else if (direction ==
                              AppinioSwiperDirection.right) {
                            await handleSwipeRight(user)
                                .then((value) => print(user.firstName));
                          }
                        },
                        cardsBuilder: (BuildContext context, int index) {
                          if (index < 0) {
                            return Container(
                              child: Center(
                                child: Text('No users to swipe'),
                              ),
                            ); // Return an empty container if index is out of bounds
                          }

                          final user = userList[index];
                          return _buildCard(context, user);
                          // ...
                        },
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 255, 255, 255),
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(16.0),
                        shadowColor:
                            Color.fromARGB(255, 196, 196, 196).withOpacity(0.6),
                        elevation: 10,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.close_rounded,
                          size: 28.0,
                          color: Color.fromARGB(255, 244, 112, 36),
                        ),
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
                      child: Center(
                        child: Icon(
                          Icons.star_rounded,
                          size: 46.0,
                          color: Colors.white,
                        ),
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
                        shadowColor:
                            Color.fromARGB(255, 196, 196, 196).withOpacity(0.6),
                        elevation: 10,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.favorite,
                          size: 28.0,
                          color: Color.fromARGB(255, 236, 85, 85),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, UserModel user) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, UserDetailScreen.route, arguments: user);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          image: DecorationImage(
            image: NetworkImage(user.image!),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                decoration: BoxDecoration(
                    color: Color.fromARGB(206, 0, 0, 0),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${user.firstName} ${user.lastName}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${user.interest!.first}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSwipeScreen();
  }
}
