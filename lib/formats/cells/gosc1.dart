import 'package:stringy_mess/game/game.dart';

// Credit to the creators of GoSC1: Blendi.
// I wrote the code of this implementation, but he wrote and invented the format.
// Please don't sue me Blendi, I don't wanna call Saul.

CellRules parseGoSC1(String rules) {
  final cr = CellRules();

  final chars = rules.substring(6).split('');

  var shape = "n";
  final dead = <int>[];
  final birth = <int>[];
  var mode = "none";

  for (var char in chars) {
    if (char == "D") {
      mode = "dead";
      continue;
    }
    if (char == "R") {
      mode = "revive";
      continue;
    }
    if (char == "n" || char == "a" || char == "d") {
      shape = char;
      mode = "none";
      continue;
    }
    if (int.tryParse(char) != null) {
      if (mode == "dead") dead.add(int.parse(char));
      if (mode == "revive") birth.add(int.parse(char));
    }
  }

  cr.death = dead;
  cr.birth = birth;

  if (shape == "d" || shape == "n") {
    cr.addCounter(-1, -1, 1);
    cr.addCounter(1, 1, 1);
    cr.addCounter(-1, 1, 1);
    cr.addCounter(1, -1, 1);
  }
  if (shape == "a" || shape == "n") {
    cr.addCounter(0, -1, 1);
    cr.addCounter(0, 1, 1);
    cr.addCounter(-1, 0, 1);
    cr.addCounter(1, 0, 1);
  }

  return cr;
}
