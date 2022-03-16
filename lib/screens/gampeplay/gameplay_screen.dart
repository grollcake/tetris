import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tetris/constants/app_style.dart';
import 'package:tetris/managers/app_settings.dart';
import 'package:tetris/managers/gameplay_manager.dart';
import 'package:tetris/models/enums.dart';
import 'package:tetris/modules/responsive.dart';
import 'package:tetris/modules/swipe_detector.dart';
import 'package:tetris/screens/gampeplay/components/pause_panel.dart';
import 'package:tetris/screens/gampeplay/components/tetris_panel.dart';
import 'package:tetris/screens/gampeplay/components/top_panel.dart';
import 'package:tetris/screens/scoreboard/scoreboard_screen.dart';
import 'package:tetris/screens/settings/settings_screen.dart';

class NewPlayScreen extends StatelessWidget {
  const NewPlayScreen({Key? key}) : super(key: key);

  void _showScoreBoardDialog(BuildContext context) async {
    final manager = context.read<GamePlayManager>();
    manager.pauseGame(eventForwarding: false);

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ScoreBoardScreen();
      },
    );

    manager.resumeGame();
  }

  void _showMenuDialog(BuildContext context) async {
    final manager = context.read<GamePlayManager>();
    manager.pauseGame(eventForwarding: false);

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SettingsScreen();
      },
    );

    manager.resumeGame();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('GamePlayScreen rebuilded');

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppStyle.bgColor,
        extendBodyBehindAppBar: true,
        appBar: buildAppBar(context),
        body: buildBody(context),
      ),
    );
  }

  // 투명한 AppBar 생성
  AppBar buildAppBar(BuildContext context) {
    print('AppBar builded');

    final username = context.select((AppSettings settings) => settings.username);

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      leadingWidth: 200,
      leading: Center(child: Text(username ?? '', style: TextStyle(fontSize: 16, color: AppStyle.lightTextColor))),
      actions: [
        IconButton(
          onPressed: () async => _showScoreBoardDialog(context),
          icon: Icon(FontAwesomeIcons.trophy, size: 18, color: AppStyle.lightTextColor),
        ),
        IconButton(
          onPressed: () async => _showMenuDialog(context),
          icon: Icon(FontAwesomeIcons.bars, size: 18, color: AppStyle.lightTextColor),
        ),
      ],
    );
  }

  // 게임화면 생성
  Widget buildBody(BuildContext context) {
    print('buildBody called');

    final manager = context.read<GamePlayManager>();
    final backgroundImage = context.select((AppSettings settings) => settings.backgroundImage);
    final isLottie = backgroundImage.endsWith('.json');

    // 화면의 넓이가 변하더라도 게임판이 짤리지 않도록 좌우 패딩값을 조정한다.
    double responsivePadding = Responsive(context).defalutHorizontalPadding;

    return Stack(
      children: [
        Positioned.fill(
          child: isLottie
              ? Lottie.asset(backgroundImage, fit: BoxFit.cover)
              : Image.asset(backgroundImage, fit: BoxFit.cover),
        ),
        Column(
          children: [
            Spacer(),
            // 상단 상태 패널
            Container(
              padding: EdgeInsets.symmetric(horizontal: responsivePadding),
              height: 70,
              child: GameplayTopPanel(),
            ),
            SizedBox(height: 6),
            // 메인 게임 패널
            SwipeDetector(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: responsivePadding),
                child: GameplayTetrisPanel(),
              ),
              onTap: () => manager.rotateBlock(),
              onSwipeLeft: (int steps) => manager.moveBlock(MoveDirection.left, steps),
              onSwipeRight: (int steps) => manager.moveBlock(MoveDirection.right, steps),
              onSwipeUp: () => manager.holdBlock(),
              onSwipeDown: (int steps) => manager.moveBlock(MoveDirection.down, steps),
              onSwipeDrop: () => manager.dropBlock(),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 20 + MediaQuery.of(context).padding.bottom),
              alignment: Alignment.centerRight,
              child: GamePlayPausePanel(),
            ),
          ],
        ),
      ],
    );
  }
}
