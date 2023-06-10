import 'package:flutter/material.dart';

ThemeData getApplicationTheme(context) {
  return ThemeData(
    primarySwatch: Colors.red,
    fontFamily: 'SKModernistRegular',
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.only(left: 25, right: 25, top: 13, bottom: 13),
          backgroundColor: Color.fromARGB(255, 215, 78, 91),
          textStyle: TextStyle(fontFamily: 'SKModernistBold'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
    ),
  );
}
