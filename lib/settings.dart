import 'package:shared_preferences/shared_preferences.dart';
import 'package:stringy_mess/theme.dart';

class SettingsManager {
  final themes = <UserTheme>[
    UserTheme.ocean(),
    UserTheme.nord(),
    UserTheme.chaotic(),
    UserTheme.cosmic(),
    UserTheme.walrus(),
    UserTheme.stringy(),
    UserTheme.sunny(),
  ];

  void load() {
    final theme = storage.getString("current-theme");
    if (theme != null) {
      for (var t in themes) {
        if (theme == t.name) {
          t.apply();
        }
      }
    }
  }

  void setSavedTheme(UserTheme theme) {
    storage.setString("current-theme", theme.name);
  }
}

late SharedPreferences storage;

final settingsManager = SettingsManager();
