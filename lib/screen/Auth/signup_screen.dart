import 'package:datemate/screen/Auth/signin_screen.dart';
import 'package:datemate/screen/privacypolicy_screen.dart';
import 'package:datemate/screen/terms_screen.dart';
import 'package:datemate/utils/google_auth_btn.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  static const String route = 'SignupScreen';

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: (MediaQuery.of(context).size.height * 1) -
                MediaQuery.of(context).padding.top,
            child: Padding(
              padding:
                  EdgeInsets.only(top: 40, bottom: 40, left: 40, right: 40),
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      // color: Colors.red,
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 120,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      // color: Colors.yellow,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Let\'s create an account for you',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              )),
                          Column(
                            children: [
                              Container(
                                height: 55,
                                // color: Colors.red,
                                alignment: Alignment.center,
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    labelText: 'Email',
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                height: 55,
                                child: TextField(
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        labelText: 'Password')),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                height: 55,
                                child: TextField(
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        labelText: 'Confirm Password')),
                              ),
                            ],
                          ),
                          SizedBox(
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    child: Text('Sign up'),
                                  ),
                                ),
                                // SizedBox(
                                //   height: 10,
                                // ),
                                // GestureDetector(
                                //   onTap: () {
                                //     Navigator.pushReplacementNamed(
                                //         context, SigninScreen.route);
                                //   },
                                //   child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.center,
                                //     children: [
                                //       Text(
                                //         'Already have an account? ',
                                //         style: TextStyle(color: Colors.grey),
                                //       ),
                                //       Text(
                                //         'Log in',
                                //         style: TextStyle(color: Colors.red),
                                //       ),
                                //     ],
                                //   ),
                                // )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    // color: Colors.green,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 0.5,
                          decoration: BoxDecoration(color: Colors.grey),
                        ),
                        Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Container(
                          width: 100,
                          height: 0.5,
                          decoration: BoxDecoration(color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      // color: Colors.blue,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GoogleAuthBtn(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, TermsOfUseScreen.route);
                                  },
                                  child: Text(
                                    'Terms of use',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, PrivacyPolicyScreen.route);
                                  },
                                  child: Text(
                                    'Privacy Policy',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            )
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
