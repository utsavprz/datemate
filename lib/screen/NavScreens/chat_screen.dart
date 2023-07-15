import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datemate/models/user_model.dart';
import 'package:datemate/screen/chat_room_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserSelectionScreen extends StatefulWidget {
  @override
  _UserSelectionScreenState createState() => _UserSelectionScreenState();
}

class _UserSelectionScreenState extends State<UserSelectionScreen> {
  List<UserModel> userList = [];

  @override
  void initState() {
    super.initState();
    fetchMatchedUsers();
  }

  Future<void> fetchMatchedUsers() async {
    // Replace 'currentUser.uid' with the appropriate user ID
    String currentUserID = FirebaseAuth.instance.currentUser!.uid;

    try {
      DocumentSnapshot userProfileSnapshot = await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(currentUserID)
          .get();

      Map<String, dynamic>? userProfileData =
          userProfileSnapshot.data() as Map<String, dynamic>?;

      if (userProfileData != null) {
        List<Map<String, dynamic>> matchedWithList =
            List<Map<String, dynamic>>.from(
                userProfileData['matchedWith'] ?? []);

        List<UserModel> matchedUsers = [];
        for (var matchedWithMap in matchedWithList) {
          String matchedUserID = matchedWithMap['userId'];
          // Fetch the user details from the 'users' collection based on matchedUserID
          DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
              .collection('userProfile')
              .doc(matchedUserID)
              .get();
          UserModel user =
              UserModel.fromJson(userSnapshot.data() as Map<String, dynamic>);
          matchedUsers.add(user);
        }

        setState(() {
          userList = matchedUsers;
        });
      }
    } catch (e) {
      print('Error fetching matched users: $e');
    }
  }

  UserModel selectedChat = UserModel(
      userId: null,
      firstName: null,
      lastName: null,
      birthday: null,
      phoneNumber: null,
      gender: null,
      interest: null);

  void close() {
    print('close');
    setState(() {
      selectedChat = UserModel(
          userId: null,
          firstName: null,
          lastName: null,
          birthday: null,
          phoneNumber: null,
          gender: null,
          interest: null);
    });
    print(selectedChat.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 50, right: 50, top: 30, bottom: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                          'Chat Room',
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
                          width: 250,
                          child: Text(
                            'You can chat here with people who have matched with you',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Color.fromARGB(255, 169, 169, 169),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              selectedChat.userId != null
                  ? Container()
                  : Expanded(
                      flex: 1,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: userList.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          return userList.isNotEmpty
                              ? Container(
                                  width:
                                      100, // Adjust the width according to your needs
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedChat = userList[index];
                                          });
                                        },
                                        child: Container(
                                          width: 70,
                                          height: 70,
                                          child: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                userList[index].image!),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  child:
                                      Center(child: Text('No matched users')),
                                );
                        },
                      ),
                    ),
              // Container(
              //   width: double.infinity,
              //   color: Color.fromARGB(255, 211, 211, 211),
              //   height: 1,
              // ),
              Expanded(
                flex: 5,
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  // color: Colors.red,
                  child: selectedChat.userId != null
                      ? ChatScreen(user: selectedChat, close: close)
                      : Container(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
