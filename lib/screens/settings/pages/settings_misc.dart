import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tetris/constants/app_style.dart';
import 'package:tetris/managers/app_settings.dart';
import 'package:tetris/screens/settings/widgets/selectedItem.dart';
import 'package:tetris/screens/settings/widgets/subtitle.dart';

class SettingsDetailMisc extends StatefulWidget {
  const SettingsDetailMisc({Key? key}) : super(key: key);

  @override
  _SettingsDetailMiscState createState() => _SettingsDetailMiscState();
}

class _SettingsDetailMiscState extends State<SettingsDetailMisc> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Background Music
        buildBackgroundMusicChoice(),
        SizedBox(height: 30),
        // Sound effect
        buildSoundEffectChoice(),
        SizedBox(height: 30),
        // GridLine
        buildGridlineChoice(),
        SizedBox(height: 30),
        // Shadow block
        buildShadowBlockChoice(),
        SizedBox(height: 30),
        // 조작 감도
        buildSensitivityChoice(),
      ],
    );
  }

  Widget buildBackgroundMusicChoice() {
    final settings = context.watch<AppSettings>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSubtitle(title: 'Background music'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () => settings.backgroundMusic = true,
              child: SelectedItem(
                isSelected: settings.backgroundMusic,
                child: Container(
                  width: 50,
                  height: 30,
                  alignment: Alignment.center,
                  child: Text('On', style: TextStyle(fontSize: 14, color: AppStyle.lightTextColor)),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => settings.backgroundMusic = false,
              child: SelectedItem(
                isSelected: !settings.backgroundMusic,
                child: Container(
                  width: 50,
                  height: 30,
                  alignment: Alignment.center,
                  child: Text('Off', style: TextStyle(fontSize: 14, color: AppStyle.lightTextColor)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildSoundEffectChoice() {
    final settings = context.watch<AppSettings>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSubtitle(title: 'Sound effect'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () => settings.soundEffect = true,
              child: SelectedItem(
                isSelected: settings.soundEffect,
                child: Container(
                  width: 50,
                  height: 30,
                  alignment: Alignment.center,
                  child: Text('On', style: TextStyle(fontSize: 14, color: AppStyle.lightTextColor)),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => settings.soundEffect = false,
              child: SelectedItem(
                isSelected: !settings.soundEffect,
                child: Container(
                  width: 50,
                  height: 30,
                  alignment: Alignment.center,
                  child: Text('Off', style: TextStyle(fontSize: 14, color: AppStyle.lightTextColor)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildGridlineChoice() {
    final settings = context.watch<AppSettings>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSubtitle(title: 'Guide line'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () => settings.showGridLine = true,
              child: SelectedItem(
                isSelected: settings.showGridLine,
                child: Container(
                  width: 50,
                  height: 30,
                  alignment: Alignment.center,
                  child: Text('On', style: TextStyle(fontSize: 14, color: AppStyle.lightTextColor)),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => settings.showGridLine = false,
              child: SelectedItem(
                isSelected: !settings.showGridLine,
                child: Container(
                  width: 50,
                  height: 30,
                  alignment: Alignment.center,
                  child: Text('Off', style: TextStyle(fontSize: 14, color: AppStyle.lightTextColor)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildShadowBlockChoice() {
    final settings = context.watch<AppSettings>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSubtitle(title: 'Shadow block'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () => settings.showShadowBlock = true,
              child: SelectedItem(
                isSelected: settings.showShadowBlock,
                child: Container(
                  width: 50,
                  height: 30,
                  alignment: Alignment.center,
                  child: Text('On', style: TextStyle(fontSize: 14, color: AppStyle.lightTextColor)),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => settings.showShadowBlock = false,
              child: SelectedItem(
                isSelected: !settings.showShadowBlock,
                child: Container(
                  width: 50,
                  height: 30,
                  alignment: Alignment.center,
                  child: Text('Off', style: TextStyle(fontSize: 14, color: AppStyle.lightTextColor)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildSensitivityChoice() {
    final settings = context.watch<AppSettings>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSubtitle(title: 'Sensitivity'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () => settings.swipeSensitivity = 0,
              child: SelectedItem(
                isSelected: settings.swipeSensitivity == 0,
                child: Container(
                  width: 50,
                  height: 30,
                  alignment: Alignment.center,
                  child: Text('Normal', style: TextStyle(fontSize: 14, color: AppStyle.lightTextColor)),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => settings.swipeSensitivity = 1,
              child: SelectedItem(
                isSelected: settings.swipeSensitivity == 1,
                child: Container(
                  width: 50,
                  height: 30,
                  alignment: Alignment.center,
                  child: Text('Slow', style: TextStyle(fontSize: 14, color: AppStyle.lightTextColor)),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => settings.swipeSensitivity = 2,
              child: SelectedItem(
                isSelected: settings.swipeSensitivity == 2,
                child: Container(
                  width: 50,
                  height: 30,
                  alignment: Alignment.center,
                  child: Text('Fast', style: TextStyle(fontSize: 14, color: AppStyle.lightTextColor)),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
