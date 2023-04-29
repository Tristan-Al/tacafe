import 'package:flutter/material.dart';

class AppTheme {
  static const Color white = Color(0xFFF0F0F0);
  static const Color black = Color(0xFF090909);
  static const Color lightBrown = Color(0xFFB29F91);
  static const Color brown = Color(0xFF422110);
  static const Color grey = Color(0xFF8F9698);
  

  static final ThemeData lightTheme = ThemeData(

    primaryColor: white,

    fontFamily: 'Raleway',

    inputDecorationTheme: const InputDecorationTheme(
      
      labelStyle: TextStyle( color: grey),

      enabledBorder : OutlineInputBorder(
        borderSide: BorderSide(color: grey),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: brown),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
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
  );
}