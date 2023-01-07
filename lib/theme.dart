import 'dart:async';
import 'dart:ui';

import 'package:flame/flame.dart';

var primaryColor = const Color.fromARGB(255, 7, 38, 68);
var secondaryColor = const Color.fromARGB(255, 1, 27, 53);
var turnaryColor = const Color.fromARGB(255, 5, 34, 62);
var userTheme = UserTheme.ocean();

final themeRefresher = StreamController<UserTheme>.broadcast();

final defaultTheme = UserTheme.current();

class UserTheme {
  String name;
  Color primary, secondary, turnary;

  @override
  bool operator ==(Object other) {
    if (other is! UserTheme) return false;
    return name == other.name && primary == other.primary && secondary == other.secondary && turnary == other.turnary;
  }

  UserTheme(this.name, this.primary, this.secondary, this.turnary);

  UserTheme.current()
      : name = "current",
        primary = primaryColor,
        secondary = secondaryColor,
        turnary = turnaryColor;

  void apply() {
    primaryColor = primary;
    secondaryColor = secondary;
    turnaryColor = turnary;
    userTheme = this;
    themeRefresher.sink.add(this);
  }

  factory UserTheme.fromStr(String str) {
    final segs = str.split('/');
    final name = segs[0];
    final parts = segs.sublist(1);

    final colors = List<Color>.generate(parts.length, (i) {
      final part = parts[i];
      final r = int.parse(part.substring(0, 2), radix: 16);
      final g = int.parse(part.substring(2, 4), radix: 16);
      final b = int.parse(part.substring(4, 6), radix: 16);

      return Color.fromARGB(255, r, g, b);
    });

    return UserTheme(name, colors[0], colors[1], colors[2]);
  }

  factory UserTheme.ocean() {
    return UserTheme("Ocean", const Color.fromARGB(255, 7, 38, 68), const Color.fromARGB(255, 1, 27, 53), const Color.fromARGB(255, 5, 34, 62));
  }

  factory UserTheme.nord() {
    return UserTheme.fromStr("Nord (Polar Night)/434C5E/3B4252/2E3440");
  }

  factory UserTheme.sunny() {
    return UserTheme.fromStr("Sunny/919117/7B7A0E/605F00");
  }

  factory UserTheme.walrus() {
    return UserTheme.fromStr("Walrus/292929/242424/1F1F1F");
  }

  factory UserTheme.chaotic() {
    return UserTheme.fromStr("Chaotic/3A0756/2E0344/230136");
  }

  factory UserTheme.stringy() {
    return UserTheme.fromStr("Stringy/FF7676/D94D4D/B52D2D");
  }

  factory UserTheme.cosmic() {
    return UserTheme.fromStr("Cosmic/0E5753/064844/013632");
  }

  @override
  int get hashCode => Object.hashAll([name, primary, secondary, turnary]);
}
