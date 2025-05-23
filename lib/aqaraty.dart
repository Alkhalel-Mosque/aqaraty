import 'package:aqaraty/pages/home_page.dart';
import 'package:aqaraty/provider/notifiers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pages/new_log.dart';
// import 'package:aqaraty/pages/home_page.dart';
import '../themes/dark_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class Aqaraty extends ConsumerStatefulWidget {
  const Aqaraty({super.key});

  @override
  ConsumerState<Aqaraty> createState() => _AqaratyState();
}

class _AqaratyState extends ConsumerState<Aqaraty> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await ref.read(coreProvider).getCashedUser();
        setState(() {});
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(coreProvider).user;
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
      home: user == null ? const LoginPage() : const HomePage(),
    );
  }
}
