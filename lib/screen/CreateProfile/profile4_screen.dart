import 'package:datemate/screen/CreateProfile/finalizing_screen.dart';
import 'package:datemate/statemanagement/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Profile4Screen extends ConsumerStatefulWidget {
  static const String route = 'Profile4Screen';
  PageController? pageController;
  Profile4Screen({required this.pageController});
  @override
  _Profile4ScreenState createState() => _Profile4ScreenState();
}

class _Profile4ScreenState extends ConsumerState<Profile4Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
          padding:
              const EdgeInsets.only(left: 50, right: 50, top: 50, bottom: 90),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(
                    width: 230,
                    height: 230,
                    child: Image.asset(
                      'assets/images/notification.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    'We recommend turning on notifications. You\'ll receive alerts when someone likes your profile or messages you',
                    style: TextStyle(
                        fontFamily: 'SKModernistRegular',
                        letterSpacing: 0.5,
                        height: 1.3),
                  )
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final usrProvider = ref.read(userProvider);

                        widget.pageController!.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications),
                          SizedBox(
                            width: 5,
                          ),
                          Text('I want to be notified'),
                        ],
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, FinalizingScreen.route);
                      },
                      child: Text('I don\'t want to be notified'))
                ],
              ),
            ],
          )),
    ));
  }
}
