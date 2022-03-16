import 'package:fluttertoast/fluttertoast.dart';
import 'package:tetris/constants/app_style.dart';

void showToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    fontSize: 14,
    backgroundColor: AppStyle.accentColor,
  );
}
