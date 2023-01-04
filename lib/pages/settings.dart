import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:stringy_mess/settings.dart';
import 'package:stringy_mess/theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                const Text("Theme: "),
                DropdownButton<UserTheme>(
                  items: settingsManager.themes.map((theme) {
                    return DropdownMenuItem<UserTheme>(
                      value: theme,
                      child: Text(theme.name),
                    );
                  }).toList(),
                  onChanged: (theme) {
                    if (theme != null) {
                      userTheme = theme;
                      theme.apply();
                      setState(() {});
                    }
                  },
                  value: userTheme,
                  dropdownColor: turnaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
