import 'package:flutter/material.dart';
import 'package:tetris/managers/ttblock.dart';
import 'package:tetris/models/enums.dart';
import 'package:tetris/screens/widgets/tttile.dart';

class MiniBlock extends StatelessWidget {
  MiniBlock({Key? key, this.blockID, this.size = 10, this.color = Colors.yellowAccent}) : super(key: key);

  final TTBlockID? blockID;
  double size;
  Color color;

  @override
  Widget build(BuildContext context) {
    if (blockID == null) return SizedBox();

    List<List<int>> block = _getBlockShape(blockID!);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        block.length,
        (row) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              block[row].length,
              (col) => Container(
                padding: EdgeInsets.all(0.5),
                width: size,
                height: size,
                child: Container(
                  decoration: BoxDecoration(
                    color: block[row][col] == 1 ? color : null,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<List<int>> _getBlockShape(TTBlockID id) {
    switch (id) {
      case TTBlockID.I:
        return [
          [1],
          [1],
          [1],
          [1]
        ];
      case TTBlockID.J:
        return [
          [0, 1],
          [0, 1],
          [1, 1],
        ];
        break;
      case TTBlockID.L:
        return [
          [1, 0],
          [1, 0],
          [1, 1],
        ];
      case TTBlockID.O:
        return [
          [1, 1],
          [1, 1]
        ];

      case TTBlockID.S:
        return [
          [0, 1, 1],
          [1, 1, 0]
        ];

      case TTBlockID.T:
        return [
          [1, 1, 1],
          [0, 1, 0]
        ];

      case TTBlockID.Z:
        return [
          [1, 1, 0],
          [0, 1, 1]
        ];
    }
  }
}
