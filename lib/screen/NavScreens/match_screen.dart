import 'package:flutter/material.dart';

class MatchesScreen extends StatefulWidget {
  static List<User> matches = [
    User(
      name: 'Lorina Wales',
      age: 24,
      bio: 'Software Engineer',
      profileImageUrl:
          'https://th.bing.com/th/id/OIP.3Kh-mRqMygC1LhgF2wolQQHaHa?pid=ImgDet&w=640&h=640&rs=1',
      matchedDate: DateTime.now(),
    ),
    User(
      name: 'Gloria Pritchhet',
      bio: 'Professional Model',
      age: 22,
      profileImageUrl:
          'https://th.bing.com/th/id/R.83231b134415668ba8703ab9cb2792ca?rik=v%2bdk9PXA3wGpSw&pid=ImgRaw&r=0',
      matchedDate: DateTime.now().subtract(Duration(days: 1)),
    ),
    // Add more User objects as needed
  ];

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 50, right: 50, top: 30, bottom: 30),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 10),
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
                          Icons.sort,
                          color: Color.fromARGB(255, 215, 78, 91),
                        ),
                        onPressed: () {},
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: MatchesScreen.matches.length ~/
                      2, // Divide by 2 to show two users in a row
                  itemBuilder: (context, index) {
                    final user1 = MatchesScreen
                        .matches[index * 2]; // First user in the row
                    final user2 = MatchesScreen
                        .matches[index * 2 + 1]; // Second user in the row

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: MatchCard(user: user1),
                          ),
                          SizedBox(width: 20.0),
                          Expanded(
                            child: MatchCard(user: user2),
                          ),
                        ],
                      ),
                    );
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

class MatchCard extends StatelessWidget {
  final User user;

  MatchCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(user.profileImageUrl),
              ),
            ),
          ),
          Text(
            user.name,
            style: TextStyle(
              fontSize: 13.0,
            ),
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(color: Colors.black),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                Icon(
                  Icons.check,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class User {
  final String name;
  final String bio;
  final String profileImageUrl;
  final int age;
  final DateTime matchedDate;

  User({
    required this.name,
    required this.bio,
    required this.profileImageUrl,
    required this.age,
    required this.matchedDate,
  });
}
