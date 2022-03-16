import 'package:flutter/material.dart';
import 'package:tetris/constants/app_style.dart';

void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: TextStyle(fontSize: 14, color: AppStyle.lightTextColor)),
      backgroundColor: AppStyle.accentColor,
      duration: Duration(seconds: 2),
    ),
  );
}
