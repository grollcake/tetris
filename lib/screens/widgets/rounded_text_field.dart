import 'package:flutter/material.dart';
import 'package:tetris/constants/app_style.dart';

class RoundedTextField extends StatefulWidget {
  RoundedTextField({
    Key? key,
    this.minLines = 1,
    this.maxLines = 1,
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.text = '',
    this.autofocus = false,
    this.height,
    this.hintText = '',
  }) : super(key: key);
  final String text;
  final int minLines;
  final int maxLines;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  TextEditingController? controller;
  final bool autofocus;
  final double? height;
  final String hintText;

  @override
  State<RoundedTextField> createState() => _RoundedTextFieldState();
}

class _RoundedTextFieldState extends State<RoundedTextField> {
  @override
  void initState() {
    super.initState();
    widget.controller ??= TextEditingController();
    widget.controller!.text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? 40,
      padding: EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppStyle.bgColorWeak,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppStyle.bgColorAccent,
          width: 1.0,
        ),
      ),
      child: TextField(
        autofocus: widget.autofocus,
        controller: widget.controller,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        keyboardType: widget.maxLines > 1 ? TextInputType.multiline : TextInputType.name,
        style: TextStyle(fontSize: 16, color: AppStyle.lightTextColor),
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
