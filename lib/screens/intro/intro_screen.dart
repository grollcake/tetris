import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:tetris/constants/app_style.dart';
import 'package:tetris/managers/app_settings.dart';
import 'package:tetris/models/enums.dart';
import 'package:tetris/screens/gampeplay/gameplay_screen.dart';
import 'package:tetris/screens/widgets/mini_block.dart';
import 'package:tetris/screens/widgets/tttile.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: AppStyle.bgColor,
        body: buildBody(context),
      ),
    );
  }

  // 메인화면 그리기
  Widget buildBody(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0),
            Colors.black.withOpacity(0.6),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(),
          buildLogo(),
          Spacer(flex: 2),
          FadeIn(
            delay: Duration(milliseconds: 1200),
            duration: Duration(milliseconds: 200),
            child: SizedBox(
              width: 200,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NewPlayScreen()));
                },
                style: ElevatedButton.styleFrom(
                  primary: AppStyle.accentColor,
                ),
                child: Text(
                  'P L A Y',
                  style: TextStyle(fontSize: 20, color: AppStyle.darkTextColor, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget buildLogo() {
    double tileSize = 34;
    return SizedBox(
      width: tileSize * 3,
      height: tileSize * 2,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: FadeInLeft(
              duration: Duration(milliseconds: 300),
              from: 40,
              child: SizedBox(
                width: tileSize,
                height: tileSize,
                child: TTTile(
                  blockId: TTBlockID.T,
                  status: TTTileStatus.fixed,
                  typeId: 0,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: tileSize * 1,
            child: FadeInDown(
              delay: Duration(milliseconds: 200),
              duration: Duration(milliseconds: 300),
              from: 40,
              child: SizedBox(
                width: tileSize,
                height: tileSize,
                child: TTTile(
                  blockId: TTBlockID.T,
                  status: TTTileStatus.fixed,
                  typeId: 0,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: tileSize * 2,
            child: FadeInRight(
              delay: Duration(milliseconds: 400),
              duration: Duration(milliseconds: 300),
              from: 40,
              child: SizedBox(
                width: tileSize,
                height: tileSize,
                child: TTTile(
                  blockId: TTBlockID.T,
                  status: TTTileStatus.fixed,
                  typeId: 0,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          Positioned(
            top: tileSize,
            left: tileSize * 1,
            child: FadeInUp(
              delay: Duration(milliseconds: 400),
              duration: Duration(milliseconds: 300),
              from: 40,
              child: SizedBox(
                width: tileSize,
                height: tileSize,
                child: TTTile(
                  blockId: TTBlockID.T,
                  status: TTTileStatus.fixed,
                  typeId: 0,
                  color: Colors.blue,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
