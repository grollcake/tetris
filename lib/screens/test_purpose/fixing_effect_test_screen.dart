import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tetris/constants/app_style.dart';
import 'package:tetris/models/enums.dart';
import 'package:tetris/modules/flashing_widget.dart';
import 'package:tetris/screens/widgets/tttile.dart';

class FixingEffectTestScreen extends StatefulWidget {
  const FixingEffectTestScreen({Key? key}) : super(key: key);

  @override
  _FixingEffectTestScreenState createState() => _FixingEffectTestScreenState();
}

class _FixingEffectTestScreenState extends State<FixingEffectTestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
    );
  }

  List<int> _effectTiles = [81, 82, 83, 93];
  // List<int> _effectTiles = [81];

  Widget buildBody() {
    final blockId = TTBlockID.values[Random().nextInt(7)];
    return Container(
      padding: EdgeInsets.all(60),
      decoration: BoxDecoration(
        color: AppStyle.bgColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GridView.builder(
            itemCount: 11 * 11,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 11,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
            ),
            itemBuilder: (_, index) {
              if (_effectTiles.contains(index)) {
                return FlashingWidget(
                  child: TTTile(blockId: blockId, status: TTTileStatus.fixed),
                );
              } else {
                return Container(
                  color: AppStyle.bgColorAccent,
                );
              }
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => setState(() {}),
            child: Text('DO Magic'),
          ),
        ],
      ),
    );
  }
}
