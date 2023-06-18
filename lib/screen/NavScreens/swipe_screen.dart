import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';

class SwipeScreen extends StatefulWidget {
  @override
  _SwipeScreenState createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen>
    with SingleTickerProviderStateMixin {
  List<User> userList = [
    User(
      name: 'Ema Watson',
      age: 25,
      job: "Professional Dancer",
      imageUrl:
          'https://th.bing.com/th/id/OIP.bABgCXnOvlRAgbb1tofSxgHaLH?pid=ImgDet&rs=1',
    ),
    User(
      name: 'Evangel Smith',
      age: 28,
      job: "Professional Singer",
      imageUrl:
          'https://th.bing.com/th/id/OIP.67N3pDmwJpzUZUGO7VIscAHaLJ?pid=ImgDet&w=797&h=1200&rs=1',
    ),
    // Add more User objects as needed
  ];

  Widget _buildCard(BuildContext context, int index) {
    final user = userList[index];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        image: DecorationImage(
          image: NetworkImage(user.imageUrl),
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
                    '${user.name}, ${user.age}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${user.job}',
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
    );
  }

  @override
  Widget build(BuildContext context) {
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
                child: AppinioSwiper(
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
                  onSwipe: (index, direction) {
                    if (direction == AppinioSwiperDirection.left) {
                      print(userList[index].name);
                      print('nope');
                    } else if (direction == AppinioSwiperDirection.right) {
                      print(userList[index].name);
                      print('like');
                    }
                  },
                  cardsBuilder: (BuildContext context, int index) {
                    return _buildCard(context, index);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15),
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
}

class User {
  final String name;
  final int age;
  final String imageUrl;
  final String job;

  User(
      {required this.name,
      required this.age,
      required this.imageUrl,
      required this.job});
}
