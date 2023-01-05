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
}

final settingsManager = SettingsManager();
