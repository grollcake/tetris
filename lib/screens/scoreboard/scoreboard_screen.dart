import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tetris/constants/app_style.dart';
import 'package:tetris/managers/app_settings.dart';
import 'package:tetris/managers/scoreboard_manager.dart';
import 'package:tetris/models/score.dart';
import 'package:tetris/modules/responsive.dart';
import 'package:tetris/screens/widgets/primary_button.dart';
import 'package:tetris/screens/widgets/rounded_text_field.dart';

class ScoreBoardScreen extends StatefulWidget {
  const ScoreBoardScreen({Key? key}) : super(key: key);

  @override
  _ScoreBoardScreenState createState() => _ScoreBoardScreenState();
}

class _ScoreBoardScreenState extends State<ScoreBoardScreen> {
  late ScoreBoardManager scoreBoard;
  late ScrollController scrollController;
  late TextEditingController textEditingcontroller;
  var _myScoreKey = GlobalKey();
  bool _isValidUsername = false;
  int _usernameChangeStep = 0; // 0: 변경대기  1: 이름입력  2: 변경등록중

  AppSettings settings = AppSettings();

  @override
  void initState() {
    super.initState();
    scoreBoard = ScoreBoardManager();
    scrollController = ScrollController();
    textEditingcontroller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    textEditingcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool _hasName = settings.username != null && settings.username!.isNotEmpty;
    final responsive = Responsive(context);

    return Dialog(
      child: Container(
        height: responsive.defaultDialogHeight,
        width: responsive.defaultDialogWidth,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(color: AppStyle.bgColor),
        child: Column(
          children: [
            buildTitleBar(),
            !_hasName ? buildRequestUsername() : buildScoreBoard(),
          ],
        ),
      ),
    );
  }

  Widget buildTitleBar() {
    return Container(
      height: 40,
      margin: EdgeInsets.only(bottom: 20),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text('S C O R E    B O A R D',
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          Align(
            alignment: Alignment(1, 0),
            child: ClipOval(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 24,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRequestUsername() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Spacer(flex: 2),
            const Text(
              'Want to see scoreboard?\nFirst, let me know your name.',
              style: TextStyle(fontSize: 14, color: AppStyle.lightTextColor),
              textAlign: TextAlign.center,
            ),
            Spacer(flex: 1),
            RoundedTextField(
              autofocus: true,
              hintText: 'Your name?',
              controller: textEditingcontroller,
              onChanged: (value) {
                setState(() {
                  _isValidUsername = value.isNotEmpty && value.trim().length > 0;
                });
              },
              onSubmitted: (value) => setUsername(value.trim()),
            ),
            Spacer(flex: 5),
            PrimaryButton(
              text: 'Register',
              onPressed: _isValidUsername
                  ? () {
                      if (_usernameChangeStep == 2) return;
                      setUsername(textEditingcontroller.text);
                    }
                  : null,
              isLoading: _usernameChangeStep == 2,
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Widget buildScoreBoard() {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Score>>(
              stream: scoreBoard.fetchAllScores(),
              builder: (BuildContext context, AsyncSnapshot<List<Score>> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong'));
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  // 사용자의 점수가 제일 위에 나타나도록 스크롤 위치 조정
                  WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                    Scrollable.ensureVisible(_myScoreKey.currentContext!);
                  });
                  List<Score> allScores = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        children:
                            List.generate(allScores.length, (index) => buildScoreRow(index + 1, allScores[index])),
                      ),
                    ),
                  );
                } else if (snapshot.connectionState != ConnectionState.done) {
                  return Center(child: Lottie.asset('assets/animations/loading.json', width: 250));
                } else {
                  return Center(child: Text('Something wrong'));
                }
              },
            ),
          ),
          _usernameChangeStep == 0 ? buildChangeLabel() : buildChangeUsername(),
        ],
      ),
    );
  }

  Widget buildScoreRow(int rank, Score score) {
    return Container(
      key: score.userId == settings.userId ? _myScoreKey : null,
      height: 30,
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
          color: rank % 2 == 1 ? AppStyle.bgColorWeak : Colors.transparent,
          border: score.userId == settings.userId
              ? Border.all(
                  color: AppStyle.accentColor,
                  width: 2.0,
                )
              : null),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.baseline,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$rank',
              style: TextStyle(fontSize: 16, color: AppStyle.lightTextColor),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              (score.username == null || score.username!.isEmpty) ? 'Unknown' : score.username!,
              style: TextStyle(fontSize: 16, color: AppStyle.lightTextColor),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${score.score ?? 0}',
              style: TextStyle(fontSize: 16, color: AppStyle.lightTextColor),
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Lvl.${score.stage}',
              style: TextStyle(fontSize: 14, color: AppStyle.lightTextColor),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildChangeLabel() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => setState(() {
          _usernameChangeStep = 1;
        }),
        child: Text('Change name', style: TextStyle(fontSize: 14, color: AppStyle.accentColor)),
      ),
    );
  }

  Widget buildChangeUsername() {
    return Container(
      height: 40,
      margin: EdgeInsets.only(top: 30, bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: RoundedTextField(
              text: settings.username ?? '',
              controller: textEditingcontroller,
              onSubmitted: (newName) => setUsername(newName),
            ),
          ),
          SizedBox(width: 10),
          PrimaryButton(
            width: 100,
            onPressed: () {
              if ((settings.username ?? '') == textEditingcontroller.text || textEditingcontroller.text.isEmpty) {
                setState(() {
                  _usernameChangeStep = 0;
                });
                return;
              }
              setUsername(textEditingcontroller.text);
            },
            text: 'Change',
            isLoading: _usernameChangeStep == 2,
          ),
        ],
      ),
    );
  }

  Future<void> setUsername(String? name) async {
    if (name != null && name.isNotEmpty && name.trim().length > 0) {
      setState(() {
        _usernameChangeStep = 2;
      });
      await ScoreBoardManager().updateUsername(name);
      setState(() {
        _usernameChangeStep = 0;
      });
    }
  }
}
