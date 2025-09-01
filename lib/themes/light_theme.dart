import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  cardColor: const Color.fromARGB(216, 255, 255, 255),
  canvasColor: Colors.black,
  focusColor: Color.fromARGB(255, 195, 108, 32),
  useMaterial3: true,
  fontFamily: 'Cairo', // خط عربي أنيق
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: const Color(0xFFD2B48C),
    secondary: const Color(0xFFFAF9F6),
    surface: const Color(0xFFFFFFFF),
    background: const Color(0xFFF5F6FA),
    onPrimary: const Color.fromARGB(255, 166, 164, 164),
    error: Colors.red.shade700,
  ),
  scaffoldBackgroundColor: const Color(0xFFF5F6FA),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 1, 42, 90),
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    filled: true,
    fillColor: Colors.grey.shade50,
    labelStyle: TextStyle(color: Colors.grey.shade700),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 1, 42, 90),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      minimumSize: const Size.fromHeight(48),
    ),
  ),
);
