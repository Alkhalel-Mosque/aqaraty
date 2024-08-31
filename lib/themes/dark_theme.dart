import 'package:flutter/material.dart';

const Color primeColor = Color.fromARGB(255, 0, 56, 93);
const Color primeLighterColor = Color.fromARGB(255, 5, 146, 189);
const Color tertiaryColor = Color.fromARGB(255, 52, 183, 241);
const Color errorColor = Color.fromARGB(255, 240, 92, 108);

final darkTheme = ThemeData.from(
  colorScheme: ColorScheme.fromSeed(
    seedColor: primeColor,
    brightness: Brightness.dark,
    tertiary: tertiaryColor,
    error: errorColor,
  ),
).copyWith(
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    circularTrackColor: primeLighterColor,
  ),
  dividerTheme: const DividerThemeData(
    endIndent: 10,
    indent: 10,
  ),
);
final lightTheme = ThemeData.from(
  colorScheme: ColorScheme.fromSeed(
    seedColor: primeColor,
    tertiary: tertiaryColor,
    error: errorColor,
  ),
).copyWith(
  dividerTheme: const DividerThemeData(
    endIndent: 10,
    indent: 10,
  ),
);
