import 'package:datemate/screen/NavScreens/account_screen.dart';
import 'package:datemate/screen/NavScreens/chat_screen.dart';
import 'package:datemate/screen/NavScreens/match_screen.dart';

import 'package:datemate/screen/NavScreens/swipe_screen.dart';
import 'package:datemate/statemanagement/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  static const String route = 'Home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    SwipeScreen(),
    MatchesScreen(),
    UserSelectionScreen(),
    AccountScreen()
  ];

  final List<BottomNavigationBarItem> _bottomNavigationBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.amp_stories_rounded),
      label: 'Swipe',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.favorite),
      label: 'Matches',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.chat),
      label: 'Chat',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.account_circle_rounded),
      label: 'Accounts',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (ref.read(userProvider).user == null) {
      return Center(
        child:
            CircularProgressIndicator(), // Show a loading indicator while fetching user data
      );
    }

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: IconThemeData(
          color: Colors.red,
        ),
        unselectedIconTheme: IconThemeData(color: Colors.grey),
        currentIndex: _currentIndex,
        items: _bottomNavigationBarItems,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: _screens[_currentIndex],
    );
  }
}
