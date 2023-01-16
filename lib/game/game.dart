import 'dart:collection';
import 'dart:math';

import 'package:stringy_mess/formats/usage.dart';

Set<String> cells = {
  "gol",
  "brian_brain",
  "seeds",
  "string",
  "maze",
  "square",
  "surface",
  "stability",
  "chaos",
  "blobby",
  "gap",
  "wall",
  "sunflower",
  "rose",
  "heat",
  "spherical",
  "bosco",
  "spaceship",
  "organic",
  "wind",
  "fog",
  "fluid",
  "boom",
  "expand",
  "pulse",
  "stable_gol",
  "stable_bosco",
  "stable_sunflower",
};

void initBaseRules() {
  if (rules.isNotEmpty) return;

  rules["gol"] = parseCellRules("GoSC1-D0145678R3n");
  rules["chaos"] =
      parseCellRules("H1@5,41|79|34|73|18|47|89|18|47|91,31|9|38|2|13,C,1,10");
  rules["maze"] = parseCellRules("H1@1,1,1,B,1,7,,2|6|4|5|7|3|1");
  rules["square"] = parseCellRules("GoSC1-D04R2a");
  rules["gap"] = parseCellRules("GoSC1-D012345678Rn");
  rules["wall"] = parseCellRules("GoSC1-DR012345678n");
  rules["sunflower"] = parseCellRules("GoSC1-D034R2d");
  rules["spherical"] = parseCellRules("H1@2,4|5,0-2|6-25,C,1,1");
  rules["seeds"] = parseCellRules("STD@/2/1/M");
  rules["bosco"] = parseCellRules("H1@5,34-45,0-32|58-121,B,1,1");
  rules["spaceship"] = parseCellRules("STD@2/2/5/M");
  rules["boom"] = parseCellRules("STD@/1-8/5/M");
  rules["stable_bosco"] = parseCellRules("H1@5,34-45,0-32|58-121,B,1,2");
  rules["stable_gol"] = parseCellRules("H1@1,3,0|1|4-8,B,1,3");
  rules["brian_brain"] = parseCellRules("H1@1,2,0-8,B,1,2");
  rules["string"] = parseCellRules("H1@2,5,0-4|8-23,B,1,1");
  rules["surface"] = parseCellRules("H1@2,6,0-4|7-23,B,1,3");
  rules["stability"] = parseCellRules("STD@3-6/3/7/M");
  rules["stable_sunflower"] = parseCellRules("GoSC1-D034R2d")..states = 5;
  rules["rose"] = parseCellRules("GoSC1-D034R2a");
  rules["blobby"] = parseCellRules("STD@3,4-5,7-8/3/6/M");
  rules["organic"] =
      parseCellRules("H1@4,12|20,12|6|5|26|47,C,1,16,1|15|4|7,12|15|13|4");
  rules["expand"] = parseCellRules(
      "H1@4,32|14|2,12|9|23|29,X,1,20,18|14|15|11|10|19|17|6,2|12|10|19|6|7");
  rules["pulse"] = parseCellRules("H1@1,1,1,C,1,1,1,1");
  rules["wind"] = parseCellRules(
      "H1@2,1|7|8,2|7|5|4|6|3|8|1,C,1,14,12,4|7|10|9|14|8|1|6|5");
  rules["fog"] =
      parseCellRules("H1@2,3|5|2|8|1,1|5|7|4,+,1,10,8|1|6|2,5|4|6|3|1|2|8");
  rules["heat"] = parseCellRules(
      "H1@4,14|3|12|46|55|34|47|6|59|38|63|27|25|61|50|60,4|57|41|2|55|17|49|44|3|26|23|13|30|62|5|50|20|46|54|61,+,1,41,27|24|22|5|30|15|33|20|6|23|29,11|36|17|32");
  rules["fluid"] = parseCellRules(
      "H1@3,16|27|2|18|7|12|11|22|20|3|10|25|4|15|8|13|17|9|23|1|24|21|14|5|19,22|4|8|19|2|24|15|11|27|13,B,1,30,2|15|10,25|10|17|11");
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

  Cell.withState(this.id, int currState) {
    states = rules[id]?.states ?? 1;
    lastState = max(min(currState, states), 0);
    state = max(min(currState, states), 0);
  }

  Cell get copy => Cell(id)
    ..state = state
    ..lastState = lastState
    ..states = states;

  bool get wasDead => lastState < states;
  bool get dead => state < states;

  void invert() {
    state = states - state;
  }

  void invertLast() {
    lastState = states - lastState;
  }
}

class Grid {
  List<List<Cell>> _grid = [];
  final _infgrid = HashMap<String, Cell>();

  int width, height;
  bool infinite = false;

  Grid(this.width, this.height) {
    init();
  }

  Grid.infinite()
      : width = 0,
        height = 0 {
    infinite = true;
    init();
  }

  void init() {
    if (infinite) {
      _infgrid.clear();
      return;
    }
    _grid = [];

    for (var x = 0; x < width; x++) {
      _grid.add([]);

      for (var y = 0; y < height; y++) {
        _grid.last.add(Cell("gol"));
      }
    }
  }

  bool doesNotWrap(int x, int y) {
    if (infinite) return true;
    return (x >= 0 && y >= 0 && x < width && y < height);
  }

  Cell read(int x, int y) {
    if (infinite) return _infgrid["$x $y"] ?? Cell("gol");
    return _grid[x % width][y % height];
  }

  void write(int x, int y, Cell cell) {
    if (infinite) {
      _infgrid["$x $y"] = cell;
      return;
    }
    _grid[x % width][y % height] = cell;
  }

  void reset(int x, int y) {
    if (infinite) {
      _infgrid.remove("$x $y");
    } else {
      _grid[x % width][y % height] = Cell("gol");
    }
  }

  void iterate(void Function(int x, int y, Cell cell) cb) {
    if (infinite) {
      _infgrid.forEach((key, cell) {
        final parts = key.split(' ');
        final x = int.parse(parts[0]);
        final y = int.parse(parts[1]);
        cb(x, y, cell);
      });
      return;
    }
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
    final g = infinite ? Grid.infinite() : Grid(width, height);

    iterate((x, y, cell) => g.write(x, y, cell.copy));

    return g;
  }
}

class CellRules {
  List<CellCounter> counters = [];
  HashSet<int> death = HashSet.identity();
  HashSet<int> birth = HashSet.identity();
  int scale = 1;
  int states = 1;
  HashSet<int> quickAlives = HashSet.identity();
  HashSet<int> quickRevives = HashSet.identity();

  int count(Grid grid, int x, int y, int currentState) {
    var c = 0;

    for (var counter in counters) {
      if (counter.blockedBy.contains(currentState)) continue;
      final cx = x + counter.offX;
      final cy = y + counter.offY;
      if (cx == x && cy == y) continue;
      final cell = grid.read(cx, cy);
      final rule = rules[cell.id]!;
      if (cell.lastState != cell.states &&
          !rule.quickAlives.contains(cell.lastState)) {
        continue;
      }

      c += rule.scale * counter.scale;
    }

    return c;
  }

  int newState(Grid grid, Cell cell, int x, int y) {
    final neighbors = count(grid, x, y, cell.state);

    if (quickRevives.contains(cell.lastState) && birth.contains(neighbors)) {
      return cell.states;
    }

    if (cell.lastState < cell.states && cell.lastState != 0) {
      return cell.lastState - 1;
    }

    if (cell.lastState == 0) {
      return birth.contains(neighbors) ? cell.states : 0;
    } else if (cell.lastState == cell.states) {
      return death.contains(neighbors) ? cell.lastState - 1 : cell.lastState;
    }

    return cell.lastState;
  }

  void addCounter(int offX, int offY, int scale, [HashSet<int>? blockedBy]) {
    counters.add(CellCounter(
      offX,
      offY,
      scale,
      blockedBy ?? HashSet<int>.identity(),
    ));
  }
}

var grid = Grid(100, 100);

List<String> handleDefaultSplit(List<String> current, List<String> def) {
  final cp = [...current];

  while (cp.length < def.length) {
    cp.add(def[cp.length]);
  }

  return cp;
}

class CellCounter {
  int offX;
  int offY;
  int scale;
  HashSet<int> blockedBy;

  CellCounter(this.offX, this.offY, this.scale, this.blockedBy);
}
