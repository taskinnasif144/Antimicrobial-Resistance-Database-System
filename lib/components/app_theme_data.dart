import 'package:flutter/material.dart';

const colorAccent = Color(0xFF030637);
const colorPrimary = Color(0xFF3B3486);
TextStyle primaryBtnTextStyle = TextStyle(
  color: Colors.white.withOpacity(0.9)
);

ThemeData purpleTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: colorPrimary,

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all<TextStyle>(primaryBtnTextStyle),
        backgroundColor: MaterialStateProperty.all<Color>(colorPrimary),
        shadowColor: MaterialStateProperty.all<Color>(Colors.black),
        elevation: MaterialStateProperty.all(8),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0)
          )
        )
      )
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
          textStyle: primaryBtnTextStyle,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        )
      )
    ),
    scaffoldBackgroundColor: colorAccent);
