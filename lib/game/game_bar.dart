import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:stringy_mess/game/game.dart';
import 'package:stringy_mess/game/game_ui.dart';
import 'package:stringy_mess/theme.dart';

class GameBar extends StatefulWidget {
  const GameBar({super.key});

  @override
  State<GameBar> createState() => _GameBarState();
}

class _GameBarState extends State<GameBar> {
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cellsL = cells.toList();
    return Sizer(builder: (context, _, __) {
      return LayoutBuilder(builder: (context, constraints) {
        return Align(
          alignment: Alignment.bottomLeft,
          child: MouseRegion(
            onEnter: (e) {
              stringyGame.canplace = false;
            },
            onExit: (e) {
              stringyGame.canplace = true;
            },
            child: Container(
              width: constraints.maxWidth - 10.w,
              height: 7.h,
              color: turnaryColor,
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: Scrollbar(
                      thickness: 1.h,
                      scrollbarOrientation: ScrollbarOrientation.bottom,
                      controller: scrollController,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        controller: scrollController,
                        itemCount: cells.length,
                        itemBuilder: (ctx, i) {
                          return MaterialButton(
                            key: ValueKey(cellsL[i]),
                            child: Opacity(
                              opacity:
                                  stringyGame.current == cellsL[i] ? 1 : 0.2,
                              child: Image.asset(
                                'assets/images/cells/${cellsL[i]}.png',
                                width: 8.w,
                                height: 8.w,
                                fit: BoxFit.cover,
                                filterQuality: FilterQuality.none,
                              ),
                            ),
                            onPressed: () {
                              stringyGame.canplace = false;
                              stringyGame.current = cellsL[i];
                              stringyGame.currentState =
                                  rules[cellsL[i]]!.states;
                              stringyGame.maxState = rules[cellsL[i]]!.states;
                              setState(() {});
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          ),
        );
      });
    });
  }
}
