import 'dart:math';
import 'package:tetris/models/enums.dart';

class TTCoord {
  int x = 0;
  int y = 0;

  TTCoord(this.x, this.y);
}

class TTBlock {
  late final TTBlockID id;
  int rotateShapeId = 0; // 블록 회전형태: 0-초기형태 1-1회전형태 2-2회전상태 3-3회전상태

  // 테트리스 전체 블록모양 미리 준비
  var _figures = List.generate(7, (index) => List.filled(4, TTCoord(0, 0), growable: false), growable: false);

  // 테트리스 현재 블록모양
  List<TTCoord> _figure = List<TTCoord>.filled(4, TTCoord(0, 0), growable: false);
  List<TTCoord> _beforeFigure = List<TTCoord>.filled(4, TTCoord(0, 0), growable: false);

  TTBlock([TTBlockID? id]) {
    _initFigures();

    if (id == null) {
      this.id = TTBlockID.values[Random().nextInt(7)];
    } else {
      this.id = id;
    }

    // 블록 지정
    _figure = [..._figures[this.id.index]]; // array deep copy
  }

  List<TTCoord> get figure => _figure;
  set setFigure(List<TTCoord> newFigure) => _figure = [...newFigure];

  // 블록 회전
  // - 오른쪽으로 회전
  // - 2번째 조각을 기준으로 회전
  void rotate() {
    if (id == TTBlockID.O) return; // O 블록은 회전하지 않는다.

    _beforeFigure = [..._figure]; // 회전 전으로 원복할 수도 있기 때문에 백업해둔다.

    while (true) {
      for (int i = 0; i < 4; i++) {
        int offsetX = _figure[i].x;
        int offsetY = _figure[i].y;
        _figure[i] = TTCoord(-offsetY, offsetX);
      }
      rotateShapeId = (rotateShapeId + 1) % 4;

      // I 블록은 0,1번 형태만 허용한다. 나머지 볼록은 모든 형태를 허용한다.
      if (id == TTBlockID.I && (rotateShapeId == 0 || rotateShapeId == 1)) {
        break;
      } else if (id != TTBlockID.I) {
        break;
      }
    }
  }

  // 회전 전으로 원복한다.
  void unRotate() {
    if (id == TTBlockID.O) return; // O 블록은 원복할 필요가 없다
    _figure = [..._beforeFigure];
  }

  // 블록 좌표 반환
  List<TTCoord> getCoord(int x, int y) {
    List<TTCoord> blockCoords = List.generate(4, (idx) => TTCoord(0, 0));

    // 가장 작은 마이너스 y값 찾기
    int minMinusY = _figure.map((e) => min(e.y, 0)).reduce(min);

    for (int i = 0; i < 4; i++) {
      blockCoords[i].x = x + _figure[i].x;
      blockCoords[i].y = y + _figure[i].y - minMinusY;
    }

    return blockCoords;
  }

  // 전체 블록모양 생성
  void _initFigures() {
    // Block I
    _figures[0][0] = TTCoord(0, -1);
    _figures[0][1] = TTCoord(0, 0);
    _figures[0][2] = TTCoord(0, 1);
    _figures[0][3] = TTCoord(0, 2);

    // Block J
    _figures[1][0] = TTCoord(0, -1);
    _figures[1][1] = TTCoord(0, 0);
    _figures[1][2] = TTCoord(0, 1);
    _figures[1][3] = TTCoord(-1, 1);

    // Block L
    _figures[2][0] = TTCoord(0, -1);
    _figures[2][1] = TTCoord(0, 0);
    _figures[2][2] = TTCoord(0, 1);
    _figures[2][3] = TTCoord(1, 1);

    // Block O
    _figures[3][0] = TTCoord(-1, 0);
    _figures[3][1] = TTCoord(0, 0);
    _figures[3][2] = TTCoord(-1, 1);
    _figures[3][3] = TTCoord(0, 1);

    // Block S
    _figures[4][0] = TTCoord(1, 0);
    _figures[4][1] = TTCoord(0, 0);
    _figures[4][2] = TTCoord(0, 1);
    _figures[4][3] = TTCoord(-1, 1);

    // Block T
    _figures[5][0] = TTCoord(-1, 0);
    _figures[5][1] = TTCoord(0, 0);
    _figures[5][2] = TTCoord(1, 0);
    _figures[5][3] = TTCoord(0, 1);

    // Block Z
    _figures[6][0] = TTCoord(-1, 0);
    _figures[6][1] = TTCoord(0, 0);
    _figures[6][2] = TTCoord(0, 1);
    _figures[6][3] = TTCoord(1, 1);
  }

  // 블록 좌표 출력
  void dumpBlockCoords() {
    String dumpStr = _figure.map((e) => '(${e.x},${e.y})').join(' ');
    print(dumpStr);
  }
}

main() {
  TTBlock block = TTBlock();
  print('${block.id}');
  block.dumpBlockCoords();

  List<TTCoord> blockCoords = block.getCoord(5, 5);
  print('Initial coords: ' + blockCoords.map((e) => '(${e.x},${e.y})').join(' '));

  block.rotate();
  blockCoords = block.getCoord(5, 5);
  print('After rotate: ' + blockCoords.map((e) => '(${e.x},${e.y})').join(' '));

  print(blockCoords.contains(TTCoord(5, 5)));
  print(blockCoords.any((e) => e.x == 5 && e.y == 5));
  print(blockCoords.any((e) => e.x == 4 && e.y == 5));
  print(blockCoords.any((e) => e.x == 4 && e.y == 4));
}
