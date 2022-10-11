/// Generic theme for the application will be configured here.
import "package:flutter/material.dart";

class ThemeConfig {
  static final theme = ThemeData(
    primarySwatch: Colors.yellow,
    backgroundColor: Color.fromRGBO(252, 245, 227, 1),
    // primaryColor: Color.fromRGBO(210, 101, 192),
    // errorColor: Color.fromRGBO(183, 28, 28),
    // accentColor: Color.fromRGBO(0,121, 134, 203),
    textTheme: TextTheme(
      headline1: TextStyle(
        // fontWeight: FontWeight.bold,
        fontSize: 26,
        fontFamily: "Nunito",
        color: Color.fromARGB(255, 27, 27, 27),
      ),
      headline2: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 20,
        fontFamily: "Nunito",
        color: Color.fromARGB(255, 27, 27, 27),
      ),
      headline4: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 18,
        fontFamily: "Nunito",
        color: Color.fromARGB(255, 27, 27, 27),
      ),
      headline5: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 16,
        fontFamily: "Nunito",
        color: Color.fromARGB(255, 27, 27, 27),
      ),
      headline6: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 14,
        fontFamily: "Nunito",
        color: Color.fromARGB(255, 27, 27, 27),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.black),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.black),
      ),
      focusColor: Colors.black,
      hoverColor: Colors.black,
      labelStyle: TextStyle(color: Colors.black),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.black, //<-- SEE HERE
    ),
  );
}
