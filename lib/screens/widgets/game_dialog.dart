import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tetris/modules/responsive.dart';

class GameDialog extends StatelessWidget {
  const GameDialog(
      {Key? key,
      required this.primaryPressed,
      required this.title,
      required this.primaryText,
      this.content,
      this.secondaryPressed,
      this.secondaryText})
      : super(key: key);
  final String title;
  final String primaryText;
  final Function primaryPressed;
  final String? secondaryText;
  final Function? secondaryPressed;
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    const borderRadius = 12.0;
    final responsive = Responsive(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: responsive.gameDialogHorizontalPadding),
        child: FittedBox(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: AlertDialog(
                insetPadding: EdgeInsets.zero,
                backgroundColor: Colors.white.withOpacity(0.07),
                elevation: 0.0,
                title: Align(
                  alignment: Alignment.center,
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                content: content,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  side: BorderSide(width: 1.5, color: Colors.white.withOpacity(0.3)),
                ),
                actions: [
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            primaryPressed();
                          },
                          child: Text(
                            primaryText,
                            style: TextStyle(fontSize: 14, color: Colors.yellow),
                          ),
                        ),
                        if (secondaryText != null)
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              secondaryPressed!();
                            },
                            child: Text(
                              secondaryText!,
                              style: TextStyle(fontSize: 14, color: Colors.yellow),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
