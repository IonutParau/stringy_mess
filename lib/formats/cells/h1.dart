import 'dart:math';

import 'package:stringy_mess/game/game.dart';

CellRules parseH1(String str) {
  // Removes H1@ header
  str = str.substring(3);

  while (str.endsWith('\t') || str.endsWith('\n') || str.endsWith(' ')) {
    str = str.substring(0, str.length - 1);
  }

  final cr = CellRules();

  final parts = str.split(',');

  final radius = int.parse(parts[0]);

  final birthStr = parts[1];
  final deathStr = parts[2];
  final shape = parts[3];
  cr.scale = int.parse(parts[4]);
  cr.states = int.parse(parts[5]);

  final birthParts = birthStr.split('|');
  for (var part in birthParts) {
    if (part.contains('-')) {
      final p = part.split('-');
      final min = int.parse(p[0]);
      final max = int.parse(p[1]);

      for (var i = min; i <= max; i++) {
        cr.birth.add(i);
      }
    } else {
      cr.birth.add(int.parse(part));
    }
  }

  final deathParts = deathStr.split('|');
  for (var part in deathParts) {
    if (part.contains('-')) {
      final p = part.split('-');
      final min = int.parse(p[0]);
      final max = int.parse(p[1]);

      for (var i = min; i <= max; i++) {
        cr.death.add(i);
      }
    } else {
      cr.death.add(int.parse(part));
    }
  }

  if (shape == "B") {
    for (var x = -radius; x <= radius; x++) {
      for (var y = -radius; y <= radius; y++) {
        if (x == 0 && y == 0) continue;
        cr.counters.add([x, y, 1]);
      }
    }
  }
  if (shape == "C") {
    for (var x = -radius; x <= radius; x++) {
      for (var y = -radius; y <= radius; y++) {
        if (x == 0 && y == 0) continue;
        if (sqrt(x * x + y * y) <= radius) {
          cr.counters.add([x, y, 1]);
        }
      }
    }
  }
  if (shape == "X") {
    for (var i = -radius; i <= radius; i++) {
      if (i == 0) continue;
      cr.counters.add([i, i, 1]);
    }
    for (var i = -radius; i <= radius; i++) {
      if (i == 0) continue;
      cr.counters.add([-i, i, 1]);
    }
  }
  if (shape == "+") {
    for (var i = -radius; i <= radius; i++) {
      if (i == 0) continue;
      cr.counters.add([0, i, 1]);
    }
    for (var i = -radius; i <= radius; i++) {
      if (i == 0) continue;
      cr.counters.add([i, 0, 1]);
    }
  }

  return cr;
}
