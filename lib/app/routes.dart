import 'package:datemate/screen/Auth/auth_screen.dart';
import 'package:datemate/screen/CreateProfile/createprofile_screen.dart';
import 'package:datemate/screen/CreateProfile/finalizing_screen.dart';
import 'package:datemate/screen/CreateProfile/profile1_screen.dart';
import 'package:datemate/screen/CreateProfile/profile3_screen.dart';
import 'package:datemate/screen/NavScreens/account_screen.dart';
import 'package:datemate/screen/edit_profile_screen.dart';

import 'package:datemate/screen/home_screen.dart';
import 'package:datemate/screen/match_screen.dart';
import 'package:datemate/screen/onboarding_screen.dart';
import 'package:datemate/screen/Auth/signin_screen.dart';
import 'package:datemate/screen/Auth/signup_screen.dart';
import 'package:datemate/screen/privacypolicy_screen.dart';
import 'package:datemate/screen/splash_screen.dart';
import 'package:datemate/screen/terms_screen.dart';
import 'package:datemate/screen/user_detail_screen.dart';

import 'package:flutter/cupertino.dart';

import '../screen/CreateProfile/profile2_screen.dart';

var getAppRoutes = <String, WidgetBuilder>{
  OnboardingScreen.route: (context) => const OnboardingScreen(),
  SplashScreen.route: (context) => const SplashScreen(),
  AuthScreen.route: (context) => const AuthScreen(),
  SignupScreen.route: (context) => const SignupScreen(),
  SigninScreen.route: (context) => const SigninScreen(),
  HomeScreen.route: (context) => HomeScreen(),
  CreateProfileScreen.route: (context) => const CreateProfileScreen(),
  FinalizingScreen.route: (context) => const FinalizingScreen(),
  TermsOfUseScreen.route: (context) => TermsOfUseScreen(),
  PrivacyPolicyScreen.route: (context) => PrivacyPolicyScreen(),
  MatchScreen.route: (context) => MatchScreen(),
  UserDetailScreen.route: (context) => UserDetailScreen(),
  EditProfileScreen.route: (context) => EditProfileScreen(),
  AccountScreen.route: (context) => AccountScreen(),
  // Profile1Screen.route: (context) =>  Profile1Screen(),
  // Profile2Screen.route: (context) => const Profile2Screen(),
  // Profile3Screen.route: (context) => const Profile3Screen()
};
