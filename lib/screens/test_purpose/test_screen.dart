import 'package:flutter/material.dart';
import 'package:tetris/constants/app_style.dart';
import 'package:tetris/screens/widgets/primary_button.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: AppStyle.bgColor,
        body: TestPage(),
      ),
    );
  }
}

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PrimaryButton(text: 'Something', isLoading: true, width: 80, onPressed: () {}),
          SizedBox(height: 50),
          PrimaryButton(text: 'Something', isLoading: true, onPressed: () {}),
          SizedBox(height: 50),
          PrimaryButton(text: 'Something', isLoading: true, width: 200, onPressed: () {}),
          SizedBox(height: 50),
          PrimaryButton(text: 'Something', isLoading: true, height: 60, width: 200, onPressed: () {}),
          SizedBox(height: 50),
          PrimaryButton(text: 'Something', isLoading: true, height: 30, width: 200, onPressed: () {}),
        ],
      ),
    );
  }
}
