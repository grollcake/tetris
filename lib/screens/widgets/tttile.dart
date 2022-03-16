import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tetris/managers/app_settings.dart';
import 'package:tetris/models/enums.dart';

class TTTile extends StatelessWidget {
  const TTTile({Key? key, required this.blockId, required this.status, this.color, this.typeId}) : super(key: key);
  final TTBlockID blockId;
  final TTTileStatus status;
  final Color? color;
  final int? typeId;
  static const typeCount = 4;

  @override
  Widget build(BuildContext context) {
    // 설정에서 색상 테마 변경 시 즉시 반영을 위해서 모니터링 추가
    context.select((AppSettings settings) => settings.colorSetId);

    // 설정에서 타일 모양 변경 시 즉시 반영을 위해서 모니터링 추가
    context.select((AppSettings settings) => settings.tileTypeId);

    final settings = context.read<AppSettings>();

    Color color = this.color ?? settings.tileColor(blockId);
    bool isShadow = status == TTTileStatus.shadow;

    return _getShape(typeId ?? settings.tileTypeId, color, isShadow);
  }

  static Widget _getShape(int id, [Color color = Colors.green, bool isShadow = false]) {
    switch (id) {
      case 0:
        return TileType1(color: color, isShadow: isShadow);
      case 1:
        return TileType2(color: color, isShadow: isShadow);
      case 2:
        return TileType3(color: color, isShadow: isShadow);
      case 3:
        return TileType4(color: color, isShadow: isShadow);
    }
    return SizedBox();
  }

  static Widget shapeType(int index) {
    return _getShape(index);
  }
}

class TileType1 extends StatelessWidget {
  const TileType1({Key? key, required this.color, required this.isShadow}) : super(key: key);
  final _adjustRatio = 0.10;

  final Color color;
  final bool isShadow;

  @override
  Widget build(BuildContext context) {
    Color baseColor = isShadow ? color.withOpacity(.2) : color;
    final currentValue = HSVColor.fromColor(baseColor).value;
    final lightValue = min(currentValue + _adjustRatio, 1.0);
    Color lightColor = HSVColor.fromColor(baseColor).withValue(lightValue).toColor();
    Color darkColor =
        lightValue < 1.0 ? baseColor : HSVColor.fromColor(baseColor).withValue(1 - _adjustRatio).toColor();

    return Stack(
      children: [
        ClipPath(
          clipper: TileType1Clipper(clippingSide: 'LB'),
          child: Container(
            color: darkColor,
          ),
        ),
        ClipPath(
          clipper: TileType1Clipper(clippingSide: 'RT'),
          child: Container(
            color: lightColor,
          ),
        ),
      ],
    );
  }
}

class TileType1Clipper extends CustomClipper<Path> {
  // 조각대상: LB-LeftBottom, RT-RightTop
  final String clippingSide;

  TileType1Clipper({required this.clippingSide});

  @override
  Path getClip(Size size) {
    Path path = Path();
    if (clippingSide == 'LB') {
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    } else if (clippingSide == 'RT') {
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0);
    }
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class TileType2 extends StatelessWidget {
  const TileType2({Key? key, required this.color, required this.isShadow}) : super(key: key);
  final _adjustRatio = 0.10;
  final Color color;
  final bool isShadow;

  @override
  Widget build(BuildContext context) {
    final Color baseColor = isShadow ? color.withOpacity(0.2) : color;
    final Color lightColor = HSVColor.fromColor(baseColor).withValue(1).toColor();

    var lightValue = max(HSVColor.fromColor(baseColor).value - _adjustRatio, 0.0);
    final Color mediumColor = HSVColor.fromColor(baseColor).withValue(lightValue).toColor();

    lightValue = max(HSVColor.fromColor(baseColor).value - _adjustRatio * 2, 0.0);
    final Color darkColor = HSVColor.fromColor(baseColor).withValue(lightValue).toColor();

    return Stack(
      children: [
        if (isShadow) Container(color: baseColor),
        ClipPath(
          child: Container(
            color: mediumColor,
          ),
          clipper: TileType2Clipper(clippingSide: 'Left'),
        ),
        ClipPath(
          child: Container(
            color: mediumColor,
          ),
          clipper: TileType2Clipper(clippingSide: 'Right'),
        ),
        ClipPath(
          child: Container(
            color: lightColor,
          ),
          clipper: TileType2Clipper(clippingSide: 'Up'),
        ),
        ClipPath(
          child: Container(
            color: darkColor,
          ),
          clipper: TileType2Clipper(clippingSide: 'Down'),
        ),
        LayoutBuilder(builder: (context, size) {
          return Container(
            margin: EdgeInsets.all(size.maxWidth * .15),
            color: baseColor,
          );
        }),
      ],
    );
  }
}

class TileType2Clipper extends CustomClipper<Path> {
  final String clippingSide;

  TileType2Clipper({required this.clippingSide});

  @override
  Path getClip(Size size) {
    Path path = Path();
    switch (clippingSide) {
      case 'Left':
        path.lineTo(size.width / 2, size.height / 2);
        path.lineTo(0, size.height);
        break;
      case 'Right':
        path.moveTo(size.width, 0);
        path.lineTo(size.width / 2, size.height / 2);
        path.lineTo(size.width, size.height);
        break;
      case 'Up':
        path.lineTo(size.width / 2, size.height / 2);
        path.lineTo(size.width, 0);
        break;
      case 'Down':
        path.moveTo(0, size.height);
        path.lineTo(size.width / 2, size.height / 2);
        path.lineTo(size.width, size.height);
        break;
    }
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class TileType3 extends StatelessWidget {
  const TileType3({Key? key, required this.color, required this.isShadow}) : super(key: key);
  final Color color;
  final bool isShadow;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double size = constraints.maxWidth * .6;
      return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isShadow ? color.withOpacity(.2) : color,
        ),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isShadow ? color.withOpacity(.05) : color,
            boxShadow: [
              if (!isShadow)
                BoxShadow(
                  color: Colors.grey.shade700,
                  offset: const Offset(1, 1),
                  blurRadius: 2,
                  spreadRadius: 1,
                ),
              if (!isShadow)
                const BoxShadow(
                  color: Colors.white,
                  offset: Offset(-1, -1),
                  blurRadius: 0,
                  spreadRadius: 0,
                ),
            ],
          ),
        ),
      );
    });
  }
}

class TileType4 extends StatelessWidget {
  const TileType4({Key? key, required this.color, required this.isShadow}) : super(key: key);
  final Color color;
  final bool isShadow;
  final _adjustRatio = 0.25;

  @override
  Widget build(BuildContext context) {
    final currentValue = HSVColor.fromColor(color).value;
    final lightValue = min(currentValue + _adjustRatio, 1.0);
    Color lightColor = HSVColor.fromColor(color).withValue(lightValue).toColor();
    Color darkColor = lightValue < 1.0 ? color : HSVColor.fromColor(color).withValue(1 - _adjustRatio).toColor();

    return isShadow
        ? Container(
            margin: EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: color.withOpacity(.2),
              shape: BoxShape.circle,
            ),
          )
        : Container(
            margin: EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [lightColor, darkColor],
                center: Alignment.center,
              ),
            ),
          );
  }
}
