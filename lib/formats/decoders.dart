import 'package:stringy_mess/formats/cells/gosc1.dart';
import 'package:stringy_mess/formats/cells/h1.dart';
import 'package:stringy_mess/formats/cells/std.dart';
import 'package:stringy_mess/game/game.dart';

CellRules parseCellRules(String rules) {
  if (rules.startsWith('GoSC1-')) return parseGoSC1(rules);
  if (rules.startsWith('H1@')) return parseH1(rules);
  if (rules.startsWith('STD@')) return parseSTDcell(rules);
  throw "Unsupported Cell Rules Format";
}
