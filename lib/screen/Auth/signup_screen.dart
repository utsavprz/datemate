import 'package:datemate/screen/Auth/signin_screen.dart';
import 'package:datemate/screen/privacypolicy_screen.dart';
import 'package:datemate/screen/terms_screen.dart';
import 'package:datemate/services/auth_service.dart';
import 'package:datemate/utils/google_auth_btn.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);
  static const String route = 'SignupScreen';

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool _passwordValid = true;
  bool _samepassword = true;

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmpasswordFocusNode = FocusNode();

  void disposeFocusNode() {
    // Clean up the focus nodes when the screen is disposed
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _isPasswordValid() {
    // Add your password validation logic here
    String password = _passwordController.text;
    return password.length >= 6; // Minimum password length of 6 characters
  }

  void _validatePassword() {
    setState(() {
      _passwordValid = _isPasswordValid();
    });
  }

  void _validateConfirmPassword() {
    setState(() {
      _samepassword =
          _passwordController.text == _confirmPasswordController.text;
    });
  }

  void showErrorMessage(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(message),
      ),
    );
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
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 120,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Let\'s create an account for you',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                height: 55,
                                alignment: Alignment.center,
                                child: TextField(
                                  focusNode: emailFocusNode,
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    labelText: 'Email',
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                height: !_passwordValid ? 85 : 55,
                                // color: Colors.blue,
                                child: SizedBox(
                                  height: 55,
                                  child: TextField(
                                    focusNode: passwordFocusNode,
                                    controller: _passwordController,
                                    onChanged: (_) => _validatePassword(),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      labelText: 'Password',
                                      errorText: _passwordValid
                                          ? null
                                          : 'Password not strong',
                                      errorStyle: TextStyle(fontSize: 14),
                                    ),
                                    obscureText: true,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              SizedBox(
                                height: !_samepassword ? 85 : 55,
                                child: Container(
                                  height: 55,
                                  child: TextField(
                                    focusNode: confirmpasswordFocusNode,
                                    controller: _confirmPasswordController,
                                    onChanged: (_) =>
                                        _validateConfirmPassword(),
                                    decoration: InputDecoration(
                                      errorText: _samepassword
                                          ? null
                                          : 'Password does\'nt match',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      labelText: 'Confirm Password',
                                    ),
                                    obscureText: true,
                                  ),
                                ),
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
                                      // Validate the password before proceeding
                                      if (_emailController.text.isNotEmpty &&
                                          _passwordController.text.isNotEmpty &&
                                          _confirmPasswordController
                                              .text.isNotEmpty) {
                                        SignupStatus status =
                                            await AuthService()
                                                .signUpWithEmailAndPassword(
                                          _emailController.text,
                                          _passwordController.text,
                                        );

                                        if (status == SignupStatus.success) {
                                          SignupStatus status =
                                              await AuthService().signIn(
                                                  _emailController.text,
                                                  _passwordController.text,
                                                  context);
                                          if (status == SignupStatus.success) {
                                            // Sign-in successful
                                            disposeFocusNode();
                                            Navigator.pop(context);
                                            // Handle success response or perform additional actions
                                          } else {
                                            // Other sign-in error
                                            showErrorMessage(
                                                'Error during sign-in. Please try again.',
                                                context);
                                          }
                                          // Signup successful
                                          // Handle success response or perform additional actions
                                        } else if (status ==
                                            SignupStatus.userExists) {
                                          // User already exists with the given email
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              backgroundColor: Colors.red,
                                              content: Text(
                                                  'User with email already exists'),
                                            ),
                                          );
                                        } else {
                                          // Error occurred during signup
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              backgroundColor: Colors.red,
                                              content: Text(
                                                  'Error during signup. Please try again.'),
                                            ),
                                          );
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.red,
                                            content:
                                                Text('Fields can\'t be empty'),
                                          ),
                                        );
                                      }
                                    },
                                    child: Text('Sign up'),
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
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
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
                                    fontWeight: FontWeight.w500,
                                  ),
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
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
