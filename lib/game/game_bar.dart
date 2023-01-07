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
              width: constraints.maxWidth,
              height: 5.h,
              color: turnaryColor,
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: Scrollbar(
                      thickness: 0.5.h,
                      scrollbarOrientation: ScrollbarOrientation.bottom,
                      controller: scrollController,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        controller: scrollController,
                        itemCount: cells.length,
                        itemBuilder: (ctx, i) {
                          return MaterialButton(
                            child: Opacity(
                              opacity: stringyGame.current == cellsL[i] ? 1 : 0.2,
                              child: Image.asset(
                                'assets/images/cells/${cellsL[i]}.png',
                                width: 8.w,
                                height: 8.w,
                                fit: BoxFit.cover,
                                filterQuality: FilterQuality.none,
                              ),
                            ),
                            onPressed: () {
                              stringyGame.current = cellsL[i];
                              stringyGame.currentState = rules[cellsL[i]]!.states;
                              stringyGame.maxState = rules[cellsL[i]]!.states;
                              setState(() {});
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Tooltip(
                    message: 'Load Level',
                    decoration: BoxDecoration(
                      color: turnaryColor,
                    ),
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 7.sp,
                    ),
                    verticalOffset: 2.h,
                    child: MaterialButton(
                      height: 5.h,
                      child: Image.asset(
                        'assets/images/buttons/load_btn.png',
                        width: 8.w,
                        height: 8.w,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.none,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) {
                            return const AlertDialog(
                              title: Text('Not implemented!'),
                              content: Text('This feature is not yet implemented'),
                            );
                          },
                        );
                        setState(() {});
                      },
                    ),
                  ),
                  Tooltip(
                    message: 'Save Level',
                    decoration: BoxDecoration(
                      color: turnaryColor,
                    ),
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 7.sp,
                    ),
                    verticalOffset: 2.h,
                    child: MaterialButton(
                      height: 5.h,
                      child: Image.asset(
                        'assets/images/buttons/save_btn.png',
                        width: 8.w,
                        height: 8.w,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.none,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) {
                            return const AlertDialog(
                              title: Text('Not implemented!'),
                              content: Text('This feature is not yet implemented'),
                            );
                          },
                        );
                        setState(() {});
                      },
                    ),
                  ),
                  if (stringyGame.initialGrid != null)
                    Tooltip(
                      message: 'Reset To Initial',
                      decoration: BoxDecoration(
                        color: turnaryColor,
                      ),
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 7.sp,
                      ),
                      verticalOffset: 2.h,
                      child: MaterialButton(
                        height: 5.h,
                        child: Image.asset(
                          'assets/images/buttons/reset_btn.png',
                          width: 8.w,
                          height: 8.w,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.none,
                        ),
                        onPressed: () {
                          stringyGame.running = false;
                          stringyGame.itime = stringyGame.delay;
                          grid = stringyGame.initialGrid!.copy;
                          stringyGame.initialGrid = null;
                          setState(() {});
                        },
                      ),
                    ),
                  Tooltip(
                    message: stringyGame.running ? 'Pause' : 'Play',
                    decoration: BoxDecoration(
                      color: turnaryColor,
                    ),
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 7.sp,
                    ),
                    verticalOffset: 2.h,
                    child: MaterialButton(
                      height: 5.h,
                      child: Image.asset(
                        stringyGame.running ? 'assets/images/buttons/pause_btn.png' : 'assets/images/buttons/play_btn.png',
                        width: 8.w,
                        height: 8.w,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.none,
                      ),
                      onPressed: () {
                        stringyGame.playPause();
                        setState(() {});
                      },
                    ),
                  ),
                  Tooltip(
                    message: 'Exit',
                    decoration: BoxDecoration(
                      color: turnaryColor,
                    ),
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 7.sp,
                    ),
                    verticalOffset: 2.h,
                    child: MaterialButton(
                      height: 5.h,
                      child: Image.asset(
                        'assets/images/buttons/exit_btn.png',
                        width: 8.w,
                        height: 8.w,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.none,
                      ),
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.settings.name == "/home");
                      },
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
