import 'package:flutter/material.dart';
import 'package:stringy_mess/game/game.dart';
import 'package:stringy_mess/game/game_ui.dart';
import 'package:stringy_mess/pages/home.dart';
import 'package:stringy_mess/theme.dart';

void main() {
  initBaseRules();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: themeRefresher.stream,
        builder: (context, snapshot) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData.dark(
              useMaterial3: true,
            ).copyWith(
              primaryColorDark: primaryColor,
              scaffoldBackgroundColor: secondaryColor,
              appBarTheme: AppBarTheme(
                backgroundColor: turnaryColor,
              ),
              drawerTheme: DrawerThemeData(
                backgroundColor: turnaryColor,
              ),
              dialogBackgroundColor: turnaryColor,
            ),
            debugShowCheckedModeBanner: false,
            initialRoute: '/home',
            routes: {
              '/home': (ctx) => const HomePageUI(),
              '/game': (ctx) => const GameUI(),
            },
          );
        });
  }
}
