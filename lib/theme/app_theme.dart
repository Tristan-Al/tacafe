import 'package:flutter/material.dart';

class AppTheme {
  static const Color white = Color(0xFFF0F0F0);
  static const Color black = Color(0xFF090909);
  static const Color lightBrown = Color(0xFFB29F91);
  static const Color brown = Color(0xFF846046);
  static const Color darkBrown = Color(0xFF422110);
  static const Color grey = Color(0xFF8F9698);

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppTheme.white,
    colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: darkBrown,
        onPrimary: white,
        secondary: lightBrown,
        onSecondary: darkBrown,
        error: Colors.red,
        onError: black,
        background: white,
        onBackground: darkBrown,
        surface: white,
        onSurface: darkBrown),
    fontFamily: 'Raleway',
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: grey),
      iconColor: grey,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: darkBrown),
      ),
      errorBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          // minimumSize: const Size.fromHeight(50),
          // textStyle: TextStyle( color: black ),
          // backgroundColor: lightBrown,
          // shape: StadiumBorder(),
          // elevation: 5,
          ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: brown,
      unselectedItemColor: grey,
      showUnselectedLabels: true,
      showSelectedLabels: true,
      backgroundColor: Color(0xFFF8F7FA),
      unselectedIconTheme: IconThemeData(size: 30),
      selectedIconTheme: IconThemeData(size: 30),
      elevation: 0,
    ),
  );
}
