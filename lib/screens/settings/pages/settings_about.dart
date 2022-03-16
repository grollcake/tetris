import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:tetris/constants/app_style.dart';
import 'package:tetris/constants/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsDetailAbout extends StatefulWidget {
  const SettingsDetailAbout({Key? key}) : super(key: key);

  @override
  _SettingsDetailAboutState createState() => _SettingsDetailAboutState();
}

class _SettingsDetailAboutState extends State<SettingsDetailAbout> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Lottie.asset('assets/animations/lottie-space.json'),
        SizedBox(height: 30),
        Text('Developed by ERA, 2022',
            style: TextStyle(fontSize: 16, color: AppStyle.accentColor, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Text('grollcake@gmail.com', style: TextStyle(fontSize: 14, color: AppStyle.lightTextColor)),
        SizedBox(height: 30),
        Text('Source Code', style: TextStyle(fontSize: 14, color: Colors.grey)),
        ElevatedButton.icon(
          icon: Icon(FontAwesomeIcons.github, color: AppStyle.darkTextColor, size: 16),
          onPressed: () async {
            if (!await launch(
              kGithubUrl,
              forceSafariVC: false,
              forceWebView: false,
            )) throw 'Could not launch $kGithubUrl';
          },
          label: Text('Github', style: TextStyle(fontSize: 16, color: AppStyle.darkTextColor)),
          style: ElevatedButton.styleFrom(
            primary: AppStyle.accentColor,
            minimumSize: Size(160, 34),
          ),
        ),
      ],
    );
  }
}
