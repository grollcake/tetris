import 'package:flutter/material.dart';

class ShakeWidget extends StatefulWidget {
  const ShakeWidget({
    Key? key,
    required this.child,
    this.shakeAxis = Axis.vertical,
    this.shakeOffset = 3.0,
    this.duration = const Duration(milliseconds: 50),
    this.listener,
  }) : super(key: key);

  final Axis shakeAxis;
  final double shakeOffset;
  final Duration duration;
  final Widget child;
  final Function(AnimationStatus, double, Duration)? listener;

  @override
  ShakeWidgetState createState() => ShakeWidgetState();
}

class ShakeWidgetState extends State<ShakeWidget> with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;
  late Stopwatch stopwatch;

  @override
  void initState() {
    super.initState();
    stopwatch = Stopwatch();

    _animationController = AnimationController(
        vsync: this,
        duration: widget.duration,
        // 돌아올때는 1.5배 느리게 처리
        reverseDuration: Duration(milliseconds: (widget.duration.inMilliseconds * 1.3).toInt()))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          stopwatch.stop();
          stopwatch.reset();
        }
        // if (widget.listener != null) {
        //   widget.listener!(status, _animationController.value);
        // }
      })
      ..addListener(() {
        if (widget.listener != null) {
          widget.listener!(_animationController.status, _animationController.value, stopwatch.elapsed);
        }
      });
    _animation = Tween<double>(
      begin: 0,
      end: widget.shakeOffset,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
        reverseCurve: Curves.decelerate,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  void shake() {
    _animationController.forward();
    stopwatch.start();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: widget.child,
      builder: (BuildContext context, Widget? child) {
        double offsetX = widget.shakeAxis == Axis.horizontal ? _animation.value : 0;
        double offsetY = widget.shakeAxis == Axis.vertical ? _animation.value : 0;
        return Transform.translate(
          offset: Offset(offsetX, offsetY),
          child: child,
        );
      },
    );
  }
}
