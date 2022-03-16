import 'package:flutter/material.dart';
import 'package:tetris/constants/app_style.dart';
import 'package:tetris/models/enums.dart';
import 'package:tetris/screens/widgets/mini_block.dart';

class BlockPreview extends StatelessWidget {
  const BlockPreview({
    Key? key,
    required this.blockId,
    required this.title,
  }) : super(key: key);

  final String title;
  final TTBlockID? blockId;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
          color: AppStyle.secondaryColor.withOpacity(.2),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(14), topRight: Radius.circular(14))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
          Expanded(child: MiniBlock(blockID: blockId, size: 10, color: Colors.white)),
        ],
      ),
    );
  }
}
