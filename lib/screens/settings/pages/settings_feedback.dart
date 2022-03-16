import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tetris/constants/app_style.dart';
import 'package:tetris/managers/app_settings.dart';
import 'package:tetris/managers/sendmail_manager.dart';
import 'package:tetris/screens/settings/widgets/subtitle.dart';
import 'package:tetris/screens/widgets/toast_message.dart';

class SettingsDetailFeedback extends StatefulWidget {
  const SettingsDetailFeedback({Key? key}) : super(key: key);

  @override
  _SettingsDetailFeedbackState createState() => _SettingsDetailFeedbackState();
}

class _SettingsDetailFeedbackState extends State<SettingsDetailFeedback> {
  final TextEditingController controller = TextEditingController();
  bool _isSending = false;
  bool _hasMessage = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSubtitle(title: 'Feedback'),
        Text('Do you enjoy the game?\nSend me of your feeling or something',
            style: TextStyle(fontSize: 12, color: Colors.grey)),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppStyle.bgColorWeak,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppStyle.bgColorAccent,
              width: 1.0,
            ),
          ),
          child: TextField(
            controller: controller,
            onChanged: (value) {
              setState(() {
                _hasMessage = value.trim().length > 0;
              });
            },
            minLines: 5,
            maxLines: 20,
            keyboardType: TextInputType.multiline,
            style: TextStyle(fontSize: 16, color: AppStyle.lightTextColor),
            decoration: InputDecoration(
              isDense: false,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        SizedBox(height: 10),
        Spacer(flex: 1),
        Center(
          child: _isSending
              ? Lottie.asset('assets/animations/loading.json')
              : ElevatedButton.icon(
                  icon: Icon(Icons.mail, color: AppStyle.darkTextColor, size: 18),
                  onPressed: _hasMessage ? () async => sendFeedbackMail() : null,
                  label: Text('S E N D', style: TextStyle(fontSize: 16, color: AppStyle.darkTextColor)),
                  style: ElevatedButton.styleFrom(
                    primary: AppStyle.accentColor,
                    minimumSize: Size(160, 34),
                  ),
                ),
        ),
        Spacer(flex: 2),
      ],
    );
  }

  void sendFeedbackMail() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final AppSettings settings = AppSettings();
    final platform = '${defaultTargetPlatform.toString().split('.').last} (isWeb: $kIsWeb)';

    setState(() {
      _isSending = true;
    });

    final result = await SendMailManager().sendEmail(
      controller.text,
      settings.userId,
      settings.username,
      platform,
    );

    if (result) {
      setState(() {
        controller.text = '';
        _hasMessage = false;
        _isSending = false;
      });
      showNewRecordToast(context: context, message: 'Thanks for your feedback', icon: Icons.check);
    } else {
      showNewRecordToast(context: context, message: 'Something wrong', icon: Icons.block);
    }
  }

  Future<void> sendFeedback(String message) async {
    final feedbackDoc = FirebaseFirestore.instance.collection('feedbacks').doc();
    final AppSettings settings = AppSettings();
    final platform = '${defaultTargetPlatform.toString().split('.').last} (isWeb: $kIsWeb)';

    final feedback = <String, dynamic>{
      'userId': settings.userId,
      'username': settings.username,
      'message': message,
      'dateTime': DateTime.now(),
      'platform': platform,
    };

    await feedbackDoc.set(feedback);
    return;
  }
}
