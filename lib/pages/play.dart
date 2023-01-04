import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:stringy_mess/game/game.dart';
import 'package:stringy_mess/game/game_ui.dart';
import 'package:stringy_mess/theme.dart';

class PlayMenu extends StatefulWidget {
  const PlayMenu({super.key});

  @override
  State<PlayMenu> createState() => _PlayMenuState();
}

class _PlayMenuState extends State<PlayMenu> {
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();

  @override
  void initState() {
    _widthController.text = "100";
    _heightController.text = "100";
    super.initState();
  }

  @override
  void dispose() {
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1.w),
              color: primaryColor,
            ),
            height: 10.h,
            child: Column(
              children: [
                SizedBox(
                  width: 20.w,
                  height: 5.h,
                  child: Row(
                    children: [
                      const Spacer(),
                      SizedBox(
                        width: 7.w,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _widthController,
                          decoration: InputDecoration(
                            label: Text('Width', style: TextStyle(fontSize: 4.sp)),
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      SizedBox(
                        width: 7.w,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _heightController,
                          decoration: InputDecoration(
                            label: Text('Height', style: TextStyle(fontSize: 4.sp)),
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.all(0.5.h),
                  child: MaterialButton(
                    onPressed: () {
                      grid = Grid(int.tryParse(_widthController.text) ?? 1, int.tryParse(_heightController.text) ?? 1);
                      stringyGame = StringyGame();
                      Navigator.pushNamed(context, '/game');
                    },
                    child: Text(
                      "Play Finite Grid",
                      style: TextStyle(fontSize: 5.sp),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: MaterialButton(
              onPressed: () {
                print("Unsupported u dumbass");
              },
              color: primaryColor,
              child: Text("Play Infinite Grid", style: TextStyle(fontSize: 9.sp)),
            ),
          ),
        ),
      ],
    );
  }
}
