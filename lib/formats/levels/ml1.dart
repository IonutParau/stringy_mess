import 'dart:convert';
import 'dart:io';

import 'package:stringy_mess/game/game.dart';

Grid decodeML1(String str) {
  final segs = str.substring(4).split(';');

  final grid = segs[0] == 'INF'
      ? Grid.infinite()
      : Grid(
          int.parse(segs[0].split(',')[0], radix: 16),
          int.parse(segs[0].split(',')[1], radix: 16),
        );

  // Cells: ID:state;x:y,<next>
  final cellData = utf8.decode(zlib.decode(base64.decode(segs[1]))).split(',');

  var i = 0;
  for (var cellstr in cellData) {
    if (grid.infinite) {
      final cellinfo = cellstr.split(';')[0].split(':');
      final posinfo = cellstr.split(';')[1].split(':');

      final cell = cellinfo.length == 1
          ? Cell.alive(cellinfo[0])
          : Cell.withState(
              cellinfo[0],
              int.parse(cellinfo[1]),
            );

      grid.write(int.parse(posinfo[0]), int.parse(posinfo[1]), cell);
    } else {
      final cellinfo = cellstr.split(':');

      final cell = cellinfo.length == 1
          ? Cell.alive(cellinfo[0])
          : Cell.withState(
              cellinfo[0],
              int.parse(cellinfo[1]),
            );

      grid.write(i % grid.width, i ~/ grid.width, cell);
    }
    i++;
  }

  return grid;
}

String encodeML1(Grid grid) {
  var str = "ML1@";

  if (grid.infinite) {
    str += "INF;";
  } else {
    str += "${grid.width.toRadixString(16)},${grid.height.toRadixString(16)};";
  }

  var rawCellData = [];

  if (grid.infinite) {
    grid.iterate((x, y, cell) {
      if (cell.state == cell.states) {
        rawCellData.add('${cell.id};$x:$y');
      } else {
        rawCellData.add('${cell.id}:${cell.state};$x:$y');
      }
    });
  } else {
    for (var y = 0; y < grid.height; y++) {
      for (var x = 0; x < grid.width; x++) {
        final cell = grid.read(x, y);
        if (cell.state == cell.states) {
          rawCellData.add(cell.id);
        } else {
          rawCellData.add('${cell.id}:${cell.state}');
        }
      }
    }
  }

  str +=
      '${base64.encode(ZLibCodec(level: ZLibOption.maxLevel).encode(utf8.encode(rawCellData.join(','))))};';

  return str;
}
