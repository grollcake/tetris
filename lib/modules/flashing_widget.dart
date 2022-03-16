import 'package:flutter/material.dart';

class FlashingWidget extends StatefulWidget {
  const FlashingWidget({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  _FlashingWidgetState createState() => _FlashingWidgetState();
}

class _FlashingWidgetState extends State<FlashingWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: 100), vsync: this);
    _animation = Tween<double>(begin: 1, end: 0.7).animate(_controller);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();

    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}
