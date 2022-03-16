import 'package:flutter/material.dart';

class Responsive {
  Responsive(this.context) : size = MediaQuery.of(context).size;

  final Size size;
  final BuildContext context;
  final _tetrisPanelRatio = 2.8; // 전체화면높이 / 테스트리스페널넓이

  double get tetrisPanelWidth => size.height / _tetrisPanelRatio;

  double get defalutHorizontalPadding => (size.width - tetrisPanelWidth) / 2;

  double get defaultDialogWidth => tetrisPanelWidth * 1.1;

  double get defaultDialogHeight => size.height * .7;

  double get gameDialogHorizontalPadding => defalutHorizontalPadding - tetrisPanelWidth * .1;
}
