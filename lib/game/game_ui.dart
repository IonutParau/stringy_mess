import 'dart:math';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:stringy_mess/game/game.dart';
import 'package:stringy_mess/game/game_bar.dart';
import 'package:stringy_mess/game/game_side_bar.dart';
import 'package:stringy_mess/theme.dart';

var stringyGame = StringyGame();

class GameUI extends StatelessWidget {
  const GameUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, oriantation, deviceType) {
      return MouseRegion(
        onEnter: (_) => stringyGame.mouseInside = true,
        onExit: (_) => stringyGame.mouseInside = false,
        onHover: (e) {
          stringyGame.mousex = e.position.dx;
          stringyGame.mousey = e.position.dy;
          stringyGame.mouseInside = true;
        },
        child: Listener(
          onPointerDown: stringyGame.onPointerDown,
          onPointerUp: stringyGame.onPointerUp,
          onPointerSignal: stringyGame.onPointerSignal,
          onPointerMove: stringyGame.onPointerMove,
          child: GameWidget(
            game: stringyGame,
            overlayBuilderMap: {
              // ignore: prefer_const_constructors
              'cellbar': (ctx, game) => GameBar(),
              // ignore: prefer_const_constructors
              'sidebar': (ctx, game) => GameSideBar(),
            },
            initialActiveOverlays: const ['cellbar', 'sidebar'],
          ),
        ),
      );
    });
  }
}

class StringyGame extends Game with KeyboardEvents {
  double smoothCamX = 0;
  double smoothCamY = 0;
  double camX = 0;
  double camY = 0;
  double cellSize = 64;
  double smoothCellSize = 64;
  late double originalCellSize;
  int camSpeed = 600;

  bool loaded = false;

  int currentState = 1;
  int maxState = 1;

  Set<LogicalKeyboardKey> keysPressed = {};

  String current = "gol";

  bool running = false;
  double itime = 0;
  double delay = 0.05;
  double normTime = 0;

  double get ilerp => (delay == 0) || !running ? 1 : itime / delay;

  double lerpT(double t) {
    return t;
  }

  double deadOpacity = 0.2;
  double aliveOpacity = 1;

  double lerp(double a, double b, double t) => a + (b - a) * min(1, max(t, 0));

  double mousex = 0;
  double mousey = 0;
  bool mouseInside = false;

  int mouseButton = 0;
  bool mouseDown = false;

  int brushSize = 0;

  bool canplace = true;

  @override
  Future<void>? onLoad() async {
    originalCellSize = cellSize;
    loaded = true;
    return super.onLoad();
  }

  Grid? initialGrid;

  void playPause() {
    running = !running;
    itime = delay;

    if (running) {
      initialGrid ??= grid.copy;
    }

    overlays.remove('sidebar');
  }

  late Canvas canvas;

  @override
  void render(Canvas canvas) {
    this.canvas = canvas;
    canvas.drawRect(
        Offset.zero & canvasSize.toSize(), Paint()..color = turnaryColor);
    if (!loaded) {
      return;
    }
    if (grid.infinite) {
      grid.iterate((x, y, cell) {
        drawCell(x, y);
      });
    } else {
      int sx = smoothCamX ~/ cellSize;
      int sy = smoothCamY ~/ cellSize;
      int ex = sx + (canvasSize.x / cellSize).ceil();
      int ey = sy + (canvasSize.y / cellSize).ceil();

      sx = max(sx, 0);
      sy = max(sy, 0);
      ex = min(ex, grid.width - 1);
      ey = min(ey, grid.height - 1);

      for (var x = sx; x <= ex; x++) {
        for (var y = sy; y <= ey; y++) {
          drawCell(x, y);
        }
      }
    }

    if (mouseInside) {
      final mx = (mousex + smoothCamX) ~/ cellSize;
      final my = (mousey + smoothCamY) ~/ cellSize;

      if (grid.doesNotWrap(mx, my)) {
        final size = cellSize / 3;
        final off = ((lerp(0, 1, (normTime % 0.5) / 0.5) - 0.5) * size).abs();

        canvas.drawRect(
          Offset(mx * cellSize - smoothCamX - brushSize * cellSize,
                  my * cellSize - smoothCamY - brushSize * cellSize) &
              Size(cellSize * (brushSize * 2 + 1),
                  cellSize * (brushSize * 2 + 1)),
          Paint()
            ..color = Colors.white.withOpacity(0.25)
            ..style = PaintingStyle.stroke
            ..strokeWidth = off,
        );
      }
    }

    for (var ox = -brushSize; ox <= brushSize; ox++) {
      for (var oy = -brushSize; oy <= brushSize; oy++) {
        Sprite(Flame.images.fromCache('cells/$current.png')).render(
          canvas,
          position: Vector2(mousex - cellSize / 2 + ox * cellSize,
              mousey - cellSize / 2 + oy * cellSize),
          size: Vector2.all(cellSize),
          overridePaint: Paint()
            ..color = Colors.white.withOpacity(0.2 * (currentState / maxState)),
        );
      }
    }

    final text =
        "${brushSize * 2 + 1}x${brushSize * 2 + 1} | $currentState / $maxState (${(currentState / maxState * 100).toStringAsFixed(2)}%)";

    final tp = TextPainter(
      text: TextSpan(
        text: text,
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    tp.layout();

    final textPos = Vector2(mousex - tp.width / 2,
        mousey - cellSize / 2 + brushSize * cellSize + 1.3 * cellSize);
    tp.paint(canvas, textPos.toOffset());
  }

  void drawCell(int x, int y) {
    final cell = grid.read(x, y);

    final screenX = x * cellSize - smoothCamX;
    final screenY = y * cellSize - smoothCamY;

    final lot = cell.lastState / cell.states;
    final cot = cell.state / cell.states;
    final lastOp = lerp(deadOpacity, aliveOpacity, lot);
    final currentOp = lerp(deadOpacity, aliveOpacity, cot);
    Sprite(Flame.images.fromCache('cells/${cell.id}.png')).render(
      canvas,
      position: Vector2(screenX, screenY),
      size: Vector2.all(cellSize.toDouble()),
      overridePaint: Paint()
        ..color =
            Colors.white.withOpacity(lerp(lastOp, currentOp, lerpT(ilerp))),
    );
  }

  @override
  void update(double dt) {
    final speed = keysPressed.contains(LogicalKeyboardKey.shiftLeft)
        ? camSpeed * 2
        : camSpeed;
    if (keysPressed.contains(LogicalKeyboardKey.keyW)) {
      camY -= speed * dt;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyS)) {
      camY += speed * dt;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyA)) {
      camX -= speed * dt;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyD)) {
      camX += speed * dt;
    }

    smoothCamX += (camX - smoothCamX) * dt;
    smoothCamY += (camY - smoothCamY) * dt;
    smoothCellSize += (cellSize - smoothCellSize) * dt;

    if (mouseButton == kPrimaryMouseButton &&
        mouseDown &&
        mouseInside &&
        canplace) {
      final cx = (mousex + smoothCamX) ~/ cellSize;
      final cy = (mousey + smoothCamY) ~/ cellSize;

      for (var x = cx - brushSize; x <= cx + brushSize; x++) {
        for (var y = cy - brushSize; y <= cy + brushSize; y++) {
          if (grid.doesNotWrap(x, y)) {
            grid.write(x, y, Cell.withState(current, currentState));
          }
        }
      }
    }
    if (mouseButton == kSecondaryMouseButton &&
        mouseDown &&
        mouseInside &&
        canplace) {
      final cx = (mousex + smoothCamX) ~/ cellSize;
      final cy = (mousey + smoothCamY) ~/ cellSize;

      for (var x = cx - brushSize; x <= cx + brushSize; x++) {
        for (var y = cy - brushSize; y <= cy + brushSize; y++) {
          if (grid.doesNotWrap(x, y)) {
            keysPressed.contains(LogicalKeyboardKey.controlLeft)
                ? grid.reset(x, y)
                : grid.write(x, y, Cell(current));
          }
        }
      }
    }

    normTime += dt;

    if (running) {
      itime += dt;
      while (itime > delay) {
        itime -= delay;
        if (delay == 0) itime = 0;

        grid.update();
      }
    }

    if (!overlays.isActive('cellbar')) {
      overlays.add('cellbar');
    }
    if (!overlays.isActive('sidebar')) {
      overlays.add('sidebar');
    }
  }

  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is RawKeyDownEvent) {
      this.keysPressed = keysPressed;
      if (keysPressed.contains(LogicalKeyboardKey.space)) {
        playPause();
      }
      if (keysPressed.contains(LogicalKeyboardKey.keyZ)) {
        final cellsL = cells.toList();
        current = cellsL[(cellsL.indexOf(current) - 1) % cells.length];
      }
      if (keysPressed.contains(LogicalKeyboardKey.keyX)) {
        final cellsL = cells.toList();
        current = cellsL[(cellsL.indexOf(current) + 1) % cells.length];
      }
    }
    if (event is RawKeyUpEvent) {
      this.keysPressed = keysPressed;
    }
    return super.onKeyEvent(event, keysPressed);
  }

  void onPointerDown(PointerDownEvent event) {
    mouseDown = true;
    mouseButton = event.buttons;
  }

  void onPointerUp(PointerUpEvent event) {
    mouseDown = false;
    canplace = true;
  }

  void onPointerMove(PointerMoveEvent event) {
    mousex = event.position.dx;
    mousey = event.position.dy;
  }

  double scrollBuff = 0;
  double scrollAmount = 60;

  void onPointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      scrollBuff += event.scrollDelta.dy;

      while (scrollBuff.abs() >= scrollAmount) {
        scrollBuff -= (scrollAmount * scrollBuff.sign);

        if (keysPressed.contains(LogicalKeyboardKey.controlLeft)) {
          if (event.scrollDelta.dy > 0) {
            brushSize = max(brushSize - 1, 0);
          } else if (event.scrollDelta.dy < 0) {
            brushSize++;
          }
        } else if (keysPressed.contains(LogicalKeyboardKey.shiftLeft)) {
          if (event.scrollDelta.dy > 0) {
            currentState = max(currentState - 1, 1);
          } else if (event.scrollDelta.dy < 0) {
            currentState = min(currentState + 1, maxState);
          }
        } else {
          if (event.scrollDelta.dy > 0) {
            setCellSize(cellSize / 2);
          } else if (event.scrollDelta.dy < 0) {
            setCellSize(cellSize * 2);
          }
        }
      }
    }
  }

  void setCellSize(double newCellSize) {
    if (newCellSize > (originalCellSize * 16)) {
      return;
    }
    if (newCellSize < (originalCellSize / 16)) {
      return;
    }

    final oldCellSize = cellSize;
    final scale = newCellSize / oldCellSize;
    cellSize = newCellSize;

    camX = (camX + canvasSize.x / 2) * scale - canvasSize.x / 2;
    camY = (camY + canvasSize.y / 2) * scale - canvasSize.y / 2;
    smoothCamX = (smoothCamX + canvasSize.x / 2) * scale - canvasSize.x / 2;
    smoothCamY = (smoothCamY + canvasSize.y / 2) * scale - canvasSize.y / 2;
  }
}
