import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tetris/constants/app_style.dart';
import 'package:tetris/constants/constants.dart';
import 'package:tetris/managers/app_settings.dart';
import 'package:tetris/managers/gameplay_manager.dart';
import 'package:tetris/models/enums.dart';
import 'package:tetris/modules/flashing_widget.dart';
import 'package:tetris/modules/shaker_widget.dart';
import 'package:tetris/screens/gampeplay/widgets/gameend_dialog.dart';
import 'package:tetris/screens/widgets/game_dialog.dart';
import 'package:tetris/screens/widgets/toast_message.dart';
import 'package:tetris/screens/widgets/tttile.dart';

class GameplayTetrisPanel extends StatefulWidget {
  const GameplayTetrisPanel({Key? key}) : super(key: key);

  @override
  State<GameplayTetrisPanel> createState() => _GameplayTetrisPanelState();
}

class _GameplayTetrisPanelState extends State<GameplayTetrisPanel> {
  GlobalKey<ShakeWidgetState> shakeKey = GlobalKey();
  late final GamePlayManager _manager;

  @override
  void initState() {
    super.initState();

    _manager = context.read<GamePlayManager>();
    Future.delayed(Duration.zero, () => _manager.startGame());
    _manager.gamePlayEvents.listen((event) => _eventHandler(event));
  }

  void _eventHandler(GamePlayEvents event) {
    switch (event) {
      case GamePlayEvents.gameStarted:
        break;
      case GamePlayEvents.gamePaused:
        _pauseDialog();
        break;
      case GamePlayEvents.gameResumed:
        break;
      case GamePlayEvents.gameEnded:
        _gameendDialog();
        break;
      case GamePlayEvents.stageCleared:
        _stageClearDialog();
        break;
      case GamePlayEvents.blockDropped:
        shakeKey.currentState!.shake();
        break;
      case GamePlayEvents.gameEndDialogRecall:
        _gameendDialog(isRecall: true);
        break;
      case GamePlayEvents.recordBreaked:
        showNewRecordToast(context: context, message: 'New record! Keep going', icon: FontAwesomeIcons.trophy);
        break;
    }
  }

  void _pauseDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return GameDialog(
          title: 'G A M E   P A U S E D',
          primaryText: 'Resume',
          primaryPressed: () => _manager.resumeGame(),
        );
      },
    );
  }

  void _stageClearDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return GameDialog(
            title: 'Congratulation!', primaryText: 'Next Stage', primaryPressed: () => _manager.nextStage());
      },
    );
  }

  void _gameendDialog({bool isRecall = false}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return GameEndDialog(isRecall: isRecall);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('GameplayTetrisPanel builded');

    return ShakeWidget(
      key: shakeKey,
      child: Container(
        padding: EdgeInsets.all(2),
        color: Colors.white,
        child: Builder(builder: (context) {
          final showGridLine = context.select((AppSettings settings) => settings.showGridLine);
          final showShadowBlock = context.select((AppSettings settings) => settings.showShadowBlock);
          return Container(
            color: showGridLine ? AppStyle.bgColor : AppStyle.bgColorAccent,
            child: MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: Builder(builder: (context) {
                final manager = context.watch<GamePlayManager>();
                final removeSpacing = context.select((AppSettings settings) => settings.tileTypeId) == 2;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: kTetrisMatrixWidth * kTetrisMatrixHeight,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: kTetrisMatrixWidth,
                    crossAxisSpacing: removeSpacing ? 0 : 1.0,
                    mainAxisSpacing: removeSpacing ? 0 : 1.0,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    int gridX = index % kTetrisMatrixWidth;
                    int gridY = index ~/ kTetrisMatrixWidth;

                    TTBlockID? blockId = manager.getBlockId(gridX, gridY);
                    TTTileStatus blockStatus = manager.getBlockStatus(gridX, gridY);

                    // 1) 빈 타일이면 배경만 그리고 종료
                    if (blockId == null) {
                      return Container(
                        margin: removeSpacing ? EdgeInsets.all(0.5) : null, // 레고블록은 다른 방식으로 구분선을 그린다.
                        color: AppStyle.bgColorAccent,
                      );
                    }

                    // 2) 그림자 블록 미표시 옵션인 경우 배경만 그린다
                    if (blockStatus == TTTileStatus.shadow && !showShadowBlock) {
                      return Container(
                        margin: removeSpacing ? EdgeInsets.all(0.5) : null, // 레고블록은 다른 방식으로 구분선을 그린다.
                        color: AppStyle.bgColorAccent,
                      );
                    }

                    // 3) 완성줄 애니메이션(깜빡임) 상태라면 배경만 그린다
                    if (_manager.hideCompletedRow && blockStatus == TTTileStatus.completed) {
                      return Container(
                        padding: removeSpacing ? EdgeInsets.all(1) : null, // 레고블록은 다른 방식으로 구분선을 그린다.
                        color: AppStyle.bgColorAccent,
                      );
                    }

                    // 4) 테트리스 블록 타일을 그린다 (정상 타일, 그림자 타일)
                    return Container(
                      color: AppStyle.bgColorAccent,
                      child: blockStatus == TTTileStatus.justFixed
                          ? FlashingWidget(child: TTTile(blockId: blockId, status: blockStatus))
                          : TTTile(blockId: blockId, status: blockStatus),
                    );
                  },
                );
              }),
            ),
          );
        }),
      ),
    );
  }
}
