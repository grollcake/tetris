import 'package:flutter/material.dart';
import 'package:tetris/constants/app_style.dart';
import 'package:tetris/managers/gameplay_manager.dart';
import 'package:tetris/managers/ttboard_manager.dart';
import 'package:provider/provider.dart';
import 'package:tetris/screens/gampeplay/widgets/block_preview.dart';

class GameplayTopPanel extends StatelessWidget {
  const GameplayTopPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('GameplayTopPanel builded');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Builder(builder: (context) {
          final holdBlockId = context.select((GamePlayManager manager) => manager.holdBlockId);
          return BlockPreview(title: 'HOLD', blockId: holdBlockId);
        }),
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 16),
            color: Colors.transparent,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Score', style: TextStyle(fontSize: 12, color: AppStyle.lightTextColor)),
                      Builder(builder: (context) {
                        final score = context.select((GamePlayManager manager) => manager.score);
                        return Text(score.toString(),
                            style: TextStyle(fontSize: 16, color: AppStyle.accentColor, fontWeight: FontWeight.bold));
                      }),
                    ],
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: Builder(builder: (context) {
                    final stage = context.select((GamePlayManager manager) => manager.stage);
                    return Center(
                        child: Text(stage.toString(),
                            style: TextStyle(fontSize: 40, color: AppStyle.accentColor, fontWeight: FontWeight.bold)));
                  }),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Time', style: TextStyle(fontSize: 12, color: AppStyle.lightTextColor)),
                      Builder(builder: (context) {
                        final elapsedTime = context.select((GamePlayManager manager) => manager.elapsedTime);
                        return Text(elapsedTime,
                            style: TextStyle(fontSize: 16, color: AppStyle.accentColor, fontWeight: FontWeight.bold));
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Builder(builder: (context) {
          final nextBlockId = context.select((GamePlayManager manager) => manager.nextBlockId);
          return BlockPreview(title: 'NEXT', blockId: nextBlockId);
        }),
      ],
    );
  }
}
