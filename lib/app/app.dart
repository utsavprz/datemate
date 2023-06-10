import 'package:datemate/app/routes.dart';
import 'package:datemate/screen/CreateProfile/createprofile_screen.dart';
import 'package:datemate/screen/CreateProfile/profile1_screen.dart';

import 'package:datemate/screen/splash_screen.dart';
import 'package:datemate/theme/theme_data.dart';

import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'DateMate',
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.route,
      routes: getAppRoutes,
      theme: getApplicationTheme(context),
    );
  }
}
