import 'package:datemate/screen/Auth/auth_screen.dart';
import 'package:datemate/screen/intro_screen.dart';
import 'package:datemate/screen/Auth/signin_screen.dart';
import 'package:datemate/screen/Auth/signup_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  static const String route = 'OnboardingScreen';
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
// controller to keep track of which page you are on

  PageController _pageController = PageController();

  List onboardText = [
    {
      'title': 'Find your Special Someone',
      'desc':
          'Whether you\'re looking for a serious relationship or fun, we\'ve got you covered. What are you waiting for? Let\'s find your someone special together.'
    },
    {
      'title': 'Partner of Same Interest',
      'desc':
          'By analyzing your interests, values, and personality traits, we can suggest potential matches that are perfect for you.'
    },
    {
      'title': 'Interact Around the World',
      'desc':
          'Check out their photos, read their bio, and see if you have anything in common. If you like what you see, swipe right. If not, swipe left. It\'s that simple!'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    // color: Colors.red,
                    child: Image.asset(
                      'assets/images/logoWithName.png',
                      width: 200,
                    ),
                  )),
              Expanded(
                flex: 6,
                child: Stack(
                  children: [
                    Container(
                      // color: Colors.blue,
                      child: PageView(
                        controller: _pageController,
                        children: [
                          IntroPage(
                            index: 0,
                            text: onboardText[0],
                            image: 'assets/images/onboard1.png',
                          ),
                          IntroPage(
                            index: 1,
                            text: onboardText[1],
                            image: 'assets/images/aiGirl/withbf.png',
                          ),
                          IntroPage(
                            index: 2,
                            text: onboardText[2],
                            image: 'assets/images/aiGirl/datemate.png',
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SmoothPageIndicator(
                              effect: WormEffect(
                                  activeDotColor: Colors.pinkAccent,
                                  dotHeight: 10,
                                  dotWidth: 10),
                              controller: _pageController,
                              count: 3),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(right: 50, left: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, SignupScreen.route);
                          },
                          child: Text(
                            'Create an account',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, SigninScreen.route);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 41, 41, 41),
                                  fontFamily: 'SKModernistRegular'),
                            ),
                            const Text(
                              'Sign in',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontFamily: 'SKModernistBold'),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
