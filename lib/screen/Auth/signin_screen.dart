import 'package:datemate/screen/home_screen.dart';
import 'package:datemate/screen/Auth/signup_screen.dart';
import 'package:datemate/screen/privacypolicy_screen.dart';
import 'package:datemate/screen/terms_screen.dart';
import 'package:datemate/utils/google_auth_btn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});
  static const String route = 'SigninScreen';

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
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

  void showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(message),
          );
        });
  }

  Future signIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.pop(context);
      disposeFocusNode();
      Navigator.pop(context);

      // Navigator.pushReplacementNamed(context, HomeScreen.route);
    } on FirebaseAuthException catch (e) {
      // ? User Not found message
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        showErrorMessage('User not found');
      }
      // ? Wrong password message
      else if (e.code == 'wrong-password') {
        showErrorMessage('Incorrect Credentials');
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                                    onPressed: () {
                                      signIn();
                                    },
                                    child: Text('Log in'),
                                  ),
                                ),
                                // SizedBox(
                                //   height: 10,
                                // ),
                                // GestureDetector(
                                //   onTap: () {
                                //     Navigator.pushReplacementNamed(
                                //         context, SignupScreen.route);
                                //   },
                                //   child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.center,
                                //     children: [
                                //       Text(
                                //         'Don\'t have an account? ',
                                //         style: TextStyle(color: Colors.grey),
                                //       ),
                                //       Text(
                                //         'Register',
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
