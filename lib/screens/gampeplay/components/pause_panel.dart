import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tetris/constants/app_style.dart';
import 'package:tetris/managers/gameplay_manager.dart';
import 'package:tetris/managers/ttboard_manager.dart';
import 'package:tetris/models/enums.dart';
import 'package:tetris/screens/widgets/game_dialog.dart';

class GamePlayPausePanel extends StatelessWidget {
  const GamePlayPausePanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('GamePlayPausePanel builded');
    final manager = context.read<GamePlayManager>();

    return IconButton(
      icon: Builder(builder: (context) {
        final playingStatus = context.select((GamePlayManager manager) => manager.playingStatus);
        return Icon(
          playingStatus == PlayingStatus.paused ? FontAwesomeIcons.play : FontAwesomeIcons.pause,
          color: AppStyle.lightTextColor,
          size: 16,
        );
      }),
      onPressed: () => manager.pauseGame(eventForwarding: true),
    );
  }
}
