import 'package:flutter/material.dart';
import 'package:tetris/constants/app_style.dart';

class SettingsSubtitle extends StatelessWidget {
  const SettingsSubtitle({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: AppStyle.lightTextColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
