import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  textSelectionTheme: TextSelectionThemeData(
    selectionHandleColor: Colors.white,
    cursorColor: Color.fromARGB(255, 195, 108, 32), // لون المؤشر
    selectionColor:
        const Color.fromARGB(72, 255, 255, 255), // لون الخلفية عند تحديد النص
  ),
  cardColor: Colors.grey[900],
  canvasColor: Colors.white,
  focusColor: Color.fromARGB(255, 195, 108, 32),
  useMaterial3: true,
  fontFamily: 'Cairo',
  brightness: Brightness.dark,

  // 🎨 نفس تدرج الألوان من صفحة اللوغن
  colorScheme: const ColorScheme.dark(
      primary: Color(0xff181C14), // الخلفية الداكنة الأساسية
      secondary: Color(0xff222831), // رمادي غامق للسطوح الثانوية
      surface: Color(0xff393E46), // البطاقات/العناصر

      error: Colors.redAccent,
      onPrimary: Colors.white),

  scaffoldBackgroundColor: const Color(0xFF0D0D0D),
  dialogTheme: DialogTheme(
    backgroundColor: const Color(0xFF1A1A1A), // لون خلفية الديالوغ
    surfaceTintColor: Colors.transparent, // يوقف تأثير Material 3 overlay
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16), // زوايا دائرية
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1A1A1A),
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
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    filled: true,
    fillColor: const Color(0xFF1A1A1A), // مثل حقول الإدخال في اللوغن
    labelStyle: const TextStyle(color: Colors.white70),
    prefixIconColor: Colors.white70,
    suffixIconColor: Colors.white70,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade700),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Colors.blue, width: 2),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue, // نفس زر الدخول
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      minimumSize: const Size.fromHeight(48),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.blueAccent, // مثل "نسيت كلمة المرور؟"
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
    ),
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Color(0xFF1A1A1A), // خلفية الدراور
    scrimColor: Colors.black54, // طبقة التعتيم خلف الدراور
    surfaceTintColor: Colors.transparent, // لإلغاء لمعة Material 3
    elevation: 8, // ظل الدراور
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(16),
        bottomRight: Radius.circular(16),
      ),
    ),
  ),

  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.grey[900],
    contentTextStyle: const TextStyle(color: Colors.white),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    behavior: SnackBarBehavior.floating,
  ),
);
