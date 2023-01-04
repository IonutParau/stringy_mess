import 'package:stringy_mess/formats/decoders.dart';

Set<String> cells = {
  "gol",
  "brian_brain",
  "seeds",
  "string",
  "maze",
  "square",
  "surface",
  "gap",
  "wall",
  "sunflower",
  "spherical",
  "bosco",
  "spaceship",
  "boom",
  "chaos",
  "chaotic_gol",
  "chaotic_bosco",
};

void initBaseRules() {
  if (rules.isNotEmpty) return;

  rules["gol"] = parseCellRules("GoSC1-D0145678R3n");
  rules["chaos"] = parseCellRules("H1@5,41|79|34|73|18|47|89|18|47|91,31|9|38|2|13,C,1,10");
  rules["maze"] = parseCellRules("GoSC1-R1n");
  rules["square"] = parseCellRules("GoSC1-D04R2a");
  rules["gap"] = parseCellRules("GoSC1-D012345678Rn");
  rules["wall"] = parseCellRules("GoSC1-DR012345678n");
  rules["sunflower"] = parseCellRules("GoSC1-D034R2d");
  rules["spherical"] = parseCellRules("H1@2,4|5,0-2|6-25,C,1,1");
  rules["seeds"] = parseCellRules("STD@2");
  rules["bosco"] = parseCellRules("H1@5,34-45,0-32|58-121,B,1,1");
  rules["spaceship"] = parseCellRules("STD@2/2/5/M");
  rules["boom"] = parseCellRules("STD@1-8//5/M");
  rules["chaotic_bosco"] = parseCellRules("H1@5,34-45,0-32|58-121,B,1,2");
  rules["chaotic_gol"] = parseCellRules("H1@1,3,0|1|4-8,B,1,3");
  rules["brian_brain"] = parseCellRules("H1@1,2,0-8,B,1,2");
  rules["string"] = parseCellRules("H1@2,5,0-4|8-23,B,1,1");
  rules["surface"] = parseCellRules("H1@2,6,0-4|7-23,B,1,3");
}

Map<String, CellRules> rules = {};

class Cell {
  String id;
  late int state;
  late int lastState;
  late int states;

  Cell(this.id) {
    states = rules[id]?.states ?? 1;
    lastState = 0;
    state = 0;
  }

  Cell.alive(this.id) {
    states = rules[id]?.states ?? 1;
    lastState = states;
    state = states;
  }

  Cell get copy => Cell(id)
    ..state = state
    ..lastState = lastState
    ..states = states;

  bool get wasDead => lastState < states;
  bool get dead => state < states;
}

class Grid {
  List<List<Cell>> _grid = [];

  int width, height;

  Grid(this.width, this.height) {
    init();
  }

  void init() {
    _grid = [];

    for (var x = 0; x < width; x++) {
      _grid.add([]);

      for (var y = 0; y < height; y++) {
        _grid.last.add(Cell("gol"));
      }
    }
  }

  bool doesNotWrap(int x, int y) {
    return (x >= 0 && y >= 0 && x < width && y < height);
  }

  Cell read(int x, int y) {
    return _grid[x % width][y % height];
  }

  void write(int x, int y, Cell cell) {
    _grid[x % width][y % height] = cell;
  }

  void iterate(void Function(int x, int y, Cell cell) cb) {
    for (var x = 0; x < width; x++) {
      for (var y = 0; y < height; y++) {
        cb(x, y, _grid[x][y]);
      }
    }
  }

  void updateCell(int x, int y, Cell cell) {
    final rule = rules[cell.id]!;

    cell.state = rule.newState(this, cell, x, y);
  }

  void update() {
    iterate((x, y, c) => c.lastState = c.state);
    iterate(updateCell);
  }

  Grid get copy {
    final g = Grid(width, height);

    iterate((x, y, cell) => g.write(x, y, cell.copy));

    return g;
  }
}

class CellRules {
  List<List<int>> counters = [];
  List<int> death = [];
  List<int> birth = [];
  int scale = 1;
  int states = 1;

  int count(Grid grid, int x, int y) {
    var c = 0;

    for (var counter in counters) {
      final cx = x + counter[0];
      final cy = y + counter[1];
      if (cx == x && cy == y) continue;
      final cell = grid.read(cx, cy);
      if (cell.lastState != cell.states) continue;
      final rule = rules[cell.id]!;

      c += rule.scale * counter[2];
    }

    return c;
  }

  int newState(Grid grid, Cell cell, int x, int y) {
    final neighbors = count(grid, x, y);

    if (cell.lastState < cell.states && cell.lastState != 0) return cell.lastState - 1;

    if (cell.lastState == 0) {
      return birth.contains(neighbors) ? cell.states : 0;
    } else if (cell.lastState == cell.states) {
      return death.contains(neighbors) ? cell.lastState - 1 : cell.lastState;
    }

    return cell.lastState;
  }
}

var grid = Grid(100, 100);
