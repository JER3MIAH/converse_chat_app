import 'package:converse/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final baseTheme = ThemeData.light();    

ThemeData lightTheme = ThemeData(
  textTheme: GoogleFonts.interTextTheme().copyWith(
    headlineMedium: TextStyle(
      fontSize: 25.sp,
      fontWeight: FontWeight.w700,
    ),
    displayMedium: TextStyle(
      fontSize: 18.sp,
    ),
  ),
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    primary: appColors.blue,
    onPrimary: appColors.white,
    secondary: appColors.grey,
    surface: appColors.white,
    onSurface: appColors.black,
  ),
);

ThemeData darkTheme = ThemeData(
  textTheme: GoogleFonts.interTextTheme().copyWith(
    headlineMedium: TextStyle(
      fontSize: 25.sp,
      fontWeight: FontWeight.w700,
    ),
    displayMedium: TextStyle(
      fontSize: 18.sp,
    ),
  ),
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    primary: appColors.blue,
    onPrimary: appColors.white,
    secondary: appColors.coolGrey,
    surface: appColors.black,
    onSurface: appColors.white,
  ),
);

var appColors = AppColors();
