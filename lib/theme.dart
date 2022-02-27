import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chat_app/colors.dart';

const appBarTheme = AppBarTheme(
    centerTitle: false, elevation: 0, backgroundColor: Colors.white);

ThemeData lightTheme(BuildContext context) => ThemeData.light().copyWith(
    primaryColor: appColor,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: appBarTheme,
    iconTheme: const IconThemeData(color: iconLight),
    textTheme: GoogleFonts.comfortaaTextTheme(Theme.of(context).textTheme)
        .apply(displayColor: Colors.black),
    visualDensity: VisualDensity.adaptivePlatformDensity);

ThemeData darkTheme(BuildContext context) => ThemeData.dark().copyWith(
    primaryColor: appColor,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: appBarTheme.copyWith(backgroundColor: appBarDark),
    iconTheme: const IconThemeData(color: Colors.black),
    textTheme: GoogleFonts.comfortaaTextTheme(Theme.of(context).textTheme)
        .apply(displayColor: Colors.white),
    visualDensity: VisualDensity.adaptivePlatformDensity);

bool isLightTheme(BuildContext context) {
  return MediaQuery.of(context).platformBrightness == Brightness.light;
}
