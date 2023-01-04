import 'package:stringy_mess/game/game.dart';

// Standard notation
// For example: 2/2/3/M
// This means "born if 2 alive neighbors, die if 2 alive neighbors, 3 states, Moore neighboring"

CellRules parseSTDcell(String str) {
  str = str.substring(4);

  final cr = CellRules();

  final parts = str.split('/');
  final birth = <int>[];
  final death = [0, 1, 2, 3, 4, 5, 6, 7, 8];

  if (parts.isEmpty) {
    parts.add('');
  }
  if (parts.length == 1) {
    parts.add('');
  }
  if (parts.length == 2) {
    parts.add('1');
  }
  if (parts.length == 3) {
    parts.add('M');
  }

  final brules = parts[0].split(',');
  final srules = parts[1].split(',');
  final states = int.parse(parts[2]);
  final neighborCounting = parts[3];

  for (var brule in brules) {
    if (brule == "") continue;
    if (brule.contains('-')) {
      final bruleParts = brule.split('-');
      final s = int.parse(bruleParts[0]);
      final e = int.parse(bruleParts[1]);

      for (var i = s; i <= e; i++) {
        birth.add(i);
      }
    } else {
      birth.add(int.parse(brule));
    }
  }

  for (var srule in srules) {
    if (srule == "") continue;
    if (srule.contains('-')) {
      final sruleParts = srule.split('-');
      final s = int.parse(sruleParts[0]);
      final e = int.parse(sruleParts[1]);

      for (var i = s; i <= e; i++) {
        death.remove(i);
      }
    } else {
      death.remove(int.parse(srule));
    }
  }

  cr.birth = birth;
  cr.death = death;
  cr.states = states;

  if (neighborCounting == "VM") {
    cr.counters.add([1, 0, 1]);
    cr.counters.add([-1, 0, 1]);
    cr.counters.add([0, 1, 1]);
    cr.counters.add([0, -1, 1]);
  } else if (neighborCounting == "M") {
    cr.counters.add([1, 0, 1]);
    cr.counters.add([-1, 0, 1]);
    cr.counters.add([0, 1, 1]);
    cr.counters.add([0, -1, 1]);
    cr.counters.add([1, -1, 1]);
    cr.counters.add([-1, 1, 1]);
    cr.counters.add([1, 1, 1]);
    cr.counters.add([-1, -1, 1]);
  }

  return cr;
}
