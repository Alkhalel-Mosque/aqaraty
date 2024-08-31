import 'package:aqaraty/pages/home_page.dart';
import 'package:aqaraty/themes/dark_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class Aqaraty extends StatelessWidget {
  const Aqaraty({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ar')],
      theme: lightTheme,
      darkTheme: darkTheme,
      locale: const Locale("ar"),
      home: const HomePage(),
    );
  }
}
