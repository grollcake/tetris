import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tetris/constants/app_style.dart';
import 'package:tetris/managers/app_settings.dart';
import 'package:tetris/managers/gameplay_manager.dart';
import 'package:tetris/screens/scoreboard/scoreboard_screen.dart';
import 'package:tetris/screens/widgets/game_dialog.dart';

class GameEndDialog extends StatelessWidget {
  const GameEndDialog({Key? key, required this.isRecall}) : super(key: key);
  final bool isRecall;

  @override
  Widget build(BuildContext context) {
    final manager = context.read<GamePlayManager>();

    Widget? content;

    if (!isRecall && manager.score > context.select((AppSettings settings) => settings.highestScore)) {
      content = Text(
        "We've achieved a new record.\nLet's check the scoreboard.",
        style: TextStyle(fontSize: 14, color: AppStyle.lightTextColor, height: 1.5),
      );
    }

    return GameDialog(
      title: 'G A M E  E N D',
      content: content,
      primaryText: 'Restart',
      primaryPressed: () => manager.startGame(),
      secondaryText: 'Scoreboard',
      secondaryPressed: () async {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return ScoreBoardScreen();
          },
        );
        manager.addEvent(GamePlayEvents.gameEndDialogRecall);
      },
    );
  }
}
