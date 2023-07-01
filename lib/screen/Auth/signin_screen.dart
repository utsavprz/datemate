import 'package:datemate/screen/home_screen.dart';
import 'package:datemate/screen/Auth/signup_screen.dart';
import 'package:datemate/screen/privacypolicy_screen.dart';
import 'package:datemate/screen/terms_screen.dart';
import 'package:datemate/services/auth_service.dart';
import 'package:datemate/statemanagement/user_provider.dart';
import 'package:datemate/utils/google_auth_btn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SigninScreen extends ConsumerStatefulWidget {
  const SigninScreen({super.key});
  static const String route = 'SigninScreen';

  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends ConsumerState<SigninScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  void disposeFocusNode() {
    // Clean up the focus nodes when the screen is disposed
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  void showErrorMessage(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(message),
      ),
    );
  }

  Future<void> getuserdata() async {
    await ref.read(userProvider).fetchUserDataFromFirebase();
  }

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
                    flex: 2,
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
                    flex: 4,
                    child: Container(
                      // color: Colors.yellow,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Log in to your account',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              )),
                          Column(
                            children: [
                              Container(
                                height: 55,
                                // color: Colors.red,
                                alignment: Alignment.center,
                                child: TextField(
                                  focusNode: emailFocusNode,
                                  controller: emailController,
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
                                    focusNode: passwordFocusNode,
                                    controller: passwordController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        labelText: 'Password')),
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
                                    onPressed: () async {
                                      if (emailController.text.isNotEmpty &&
                                          passwordController.text.isNotEmpty) {
                                        SignupStatus status =
                                            await AuthService().signIn(
                                          emailController.text,
                                          passwordController.text,
                                          context,
                                        );

                                        if (status == SignupStatus.success) {
                                          getuserdata(); // Sign-in successful
                                          disposeFocusNode();
                                          Navigator.pop(context);
                                          // Handle success response or perform additional actions
                                        } else if (status ==
                                            SignupStatus.userDoesnotExists) {
                                          // User does not exist
                                          showErrorMessage(
                                              'User doesn\'t exist', context);
                                        } else if (status ==
                                            SignupStatus.incorrectPassword) {
                                          // Incorrect password
                                          showErrorMessage(
                                              'Incorrect credentials', context);
                                        } else {
                                          // Other sign-in error
                                          showErrorMessage(
                                              'Error during sign-in. Please try again.',
                                              context);
                                        }
                                      } else {
                                        showErrorMessage(
                                            'Fields can\'t be empty', context);
                                      }
                                    },
                                    child: Text('Log in'),
                                  ),
                                ),
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
                    flex: 2,
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
