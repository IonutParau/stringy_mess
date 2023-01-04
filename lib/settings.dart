import 'package:stringy_mess/theme.dart';

class SettingsManager {
  final themes = <UserTheme>[
    UserTheme.ocean(),
    UserTheme.nord(),
    UserTheme.chaotic(),
    UserTheme.walrus(),
    UserTheme.stringy(),
    UserTheme.sunny(),
  ];
}

final settingsManager = SettingsManager();
