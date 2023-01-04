import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:stringy_mess/pages/play.dart';
import 'package:stringy_mess/pages/settings.dart';
import 'package:stringy_mess/theme.dart';

class HomePageUI extends StatefulWidget {
  const HomePageUI({super.key});

  @override
  State<HomePageUI> createState() => _HomePageState();
}

enum HomePage {
  play,
  settings,
}

class _HomePageState extends State<HomePageUI> {
  var _current = HomePage.play;

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        final shouldRenderSidebar = orientation == Orientation.landscape;
        return StreamBuilder(
            stream: themeRefresher.stream,
            builder: (context, snapshot) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Stringy Mess'),
                ),
                drawer: shouldRenderSidebar ? null : drawer(false),
                body: shouldRenderSidebar
                    ? Row(
                        children: [
                          drawer(true),
                          Expanded(child: body),
                        ],
                      )
                    : body,
              );
            });
      },
    );
  }

  Widget get body {
    if (_current == HomePage.play) {
      return const PlayMenu();
    }

    if (_current == HomePage.settings) {
      return const SettingsPage();
    }

    return const Center(
      child: Text("How did you get here"),
    );
  }

  Widget drawer(bool isSidebar) {
    final column = Column(
      children: [
        if (!isSidebar) ...[
          Text("Stringy Mess", style: TextStyle(fontSize: 9.sp)),
          const Divider(),
        ],
        drawerTile(HomePage.play, "Play"),
        drawerTile(HomePage.settings, "Settings"),
        const Spacer(),
        const Divider(),
        MaterialButton(
          child: Text("Quit", style: TextStyle(fontSize: 7.sp)),
          onPressed: () {
            exit(0);
          },
        ),
        const Divider(),
      ],
    );
    if (isSidebar) {
      return Container(
        color: turnaryColor,
        child: column,
      );
    }
    return Drawer(
      width: 20.w,
      child: column,
    );
  }

  Widget drawerTile(HomePage page, String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: MaterialButton(
        onPressed: () => setState(() => _current = page),
        child: Text(title, style: TextStyle(fontSize: 7.sp)),
      ),
    );
  }
}
