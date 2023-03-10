import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stringy_mess/game/game.dart';
import 'package:stringy_mess/game/game_ui.dart';
import 'package:stringy_mess/pages/home.dart';
import 'package:stringy_mess/settings.dart';
import 'package:stringy_mess/theme.dart';

void main() async {
  initBaseRules();
  WidgetsFlutterBinding.ensureInitialized();
  for (var id in cells) {
    await Flame.images.load('cells/$id.png');
  }
  storage = await SharedPreferences.getInstance();
  settingsManager.load();
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
            title: 'Stringy Mess',
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
