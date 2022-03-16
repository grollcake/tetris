import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tetris/managers/app_settings.dart';

enum SwipeDirection { left, right, up, down }

class SwipeDetector extends StatefulWidget {
  const SwipeDetector(
      {Key? key,
      required this.child,
      required this.onTap,
      required this.onSwipeUp,
      required this.onSwipeDown,
      required this.onSwipeLeft,
      required this.onSwipeRight,
      required this.onSwipeDrop})
      : super(key: key);
  final Widget child;
  final Function() onTap;
  final Function() onSwipeUp;
  final Function(int) onSwipeDown;
  final Function(int) onSwipeLeft;
  final Function(int) onSwipeRight;
  final Function() onSwipeDrop;

  @override
  State<SwipeDetector> createState() => _SwipeDetectorState();
}

class _SwipeDetectorState extends State<SwipeDetector> {
  final double _xAxisThreadhold = 40.0;
  final double _yAxisThreadhold = 20.0;
  final double _dropTriggerSpeed = 0.15; // 마지막 아래방향으로 이동속도가 이 이상이면 Drop으로 판정
  final int _dropCheckMillisecond = 50;
  final double _dropTriggerDistance = 20;

  List<Timer> _delayedSwipeDownTimer = [];
  int _startTimestamp = 0;
  List<Map<String, dynamic>> _moveHistory = [];
  double _totalSwipeDistance = 0.0;
  double _verticalSwipeDistance = 0.0;
  double _horizontalSwipeDistance = 0.0;
  bool _isSwipeDone = false;
  int _callBackCount = 0;

  AppSettings settings = AppSettings();

  // 이동 정보 처리
  void handleMoveEvent(Offset delta) {
    // 0. 기준 임계치 계산
    double xAxisThreadhold = _xAxisThreadhold;
    if (settings.swipeSensitivity == 1) {
      xAxisThreadhold *= 1.5;
    } else if (settings.swipeSensitivity == 2) {
      xAxisThreadhold *= 0.6;
    }

    double yAxisThreadhold = _yAxisThreadhold;
    if (settings.swipeSensitivity == 1) {
      yAxisThreadhold *= 1.5;
    } else if (settings.swipeSensitivity == 2) {
      yAxisThreadhold *= 0.6;
    }

    // 1. 이동 거리 정보 기록
    int currentElapsedMs = DateTime.now().millisecondsSinceEpoch - _startTimestamp;
    _moveHistory.add({'elapsedMillisecond': currentElapsedMs, 'deltaX': delta.dx, 'deltaY': delta.dy});

    // 2. 이동 거리 누적값 계산
    _totalSwipeDistance += delta.dx.abs() + delta.dy.abs();
    _horizontalSwipeDistance += delta.dx;
    _verticalSwipeDistance += delta.dy;

    // 3. 임계치 초과 시 콜백 함수 호출
    if (_horizontalSwipeDistance ~/ xAxisThreadhold != 0) {
      int steps = _horizontalSwipeDistance ~/ xAxisThreadhold;
      _horizontalSwipeDistance = _horizontalSwipeDistance - xAxisThreadhold * steps;
      _verticalSwipeDistance = 0;
      _callBackCount += steps.abs();
      if (steps > 0) {
        widget.onSwipeRight(steps);
      } else {
        widget.onSwipeLeft(-steps);
      }
    }
    if (_verticalSwipeDistance ~/ yAxisThreadhold != 0) {
      int steps = _verticalSwipeDistance ~/ yAxisThreadhold;
      _verticalSwipeDistance = _verticalSwipeDistance - yAxisThreadhold * steps;
      _horizontalSwipeDistance = 0;
      if (steps > 0) {
        _callBackCount += steps.abs();
        // SwipeDown인 경우 Drop 일수도 있기 때문에 약간 지연 처리한다.
        _delayedSwipeDownTimer.add(
          Timer(const Duration(milliseconds: 100), () {
            widget.onSwipeDown(steps);
          }),
        );
      }
      // 좌우로 움직인 이력이 없는 경우에만 swipe up 이벤트 처리
      else if (_callBackCount == 0) {
        _callBackCount = 1;
        widget.onSwipeUp();
        _isSwipeDone = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      child: widget.child,
      onPointerDown: (PointerDownEvent event) {
        _isSwipeDone = false;
        _callBackCount = 0;
        _totalSwipeDistance = 0.0;
        _verticalSwipeDistance = 0;
        _horizontalSwipeDistance = 0;
        _startTimestamp = DateTime.now().millisecondsSinceEpoch;
        _moveHistory = [];
      },
      onPointerUp: (PointerUpEvent event) {
        handleMoveEvent(event.delta);

        if (_callBackCount == 0 && _totalSwipeDistance <= 3) {
          widget.onTap();
          return;
        }

        // Drop이 발생했는지 확인: 마지막 50ms 동안 아래로 움직인 속도 확인
        if (_isDropOccurred()) {
          // Drop 직전의 SwipeDown은 취소해버린다.
          for (final t in _delayedSwipeDownTimer) {
            if (t.isActive) t.cancel();
          }
          widget.onSwipeDrop();
          return;
        }

        // 여기까지 왔다면 너무 조금 움직여서 아무 이벤트도 발생하지 않은 경우이다
        // 좌우 이동 정도는 처리하고 종료하자
        if (_callBackCount == 0) {
          if (_horizontalSwipeDistance.abs() > _verticalSwipeDistance.abs()) {
            if (_horizontalSwipeDistance > 0) {
              widget.onSwipeRight(1);
            } else {
              widget.onSwipeLeft(1);
            }
          }
        }
      },
      onPointerMove: (PointerMoveEvent event) {
        if (_isSwipeDone) return;
        handleMoveEvent(event.delta);
      },
    );
  }

  bool _isDropOccurred() {
    int currentElapsedMilliseconds = DateTime.now().millisecondsSinceEpoch - _startTimestamp;
    double dropDistance = 0;
    double horizontalDistance = 0;
    int dropElapsedMilliseconds = 0;

    for (int i = _moveHistory.length - 1; i >= 0; i--) {
      // 50ms 이내 기록 또는 최소 이동거리 20 이상의 데이터만 취합해서 속도 계산
      if (currentElapsedMilliseconds - _moveHistory[i]['elapsedMillisecond'] <= _dropCheckMillisecond ||
          dropDistance < _dropTriggerDistance) {
        dropDistance += _moveHistory[i]['deltaY'];
        horizontalDistance += _moveHistory[i]['deltaX'];
      } else {
        dropElapsedMilliseconds = currentElapsedMilliseconds - _moveHistory[i]['elapsedMillisecond'] as int;
        break;
      }
    }
    // 이동 기록 중에 50ms 이상 경과된 건이 없다면 현재 경과시간으로 계산한다.
    if (dropElapsedMilliseconds == 0) {
      dropElapsedMilliseconds = currentElapsedMilliseconds;
    }

    // Drop 속도 계산
    if (dropDistance > horizontalDistance.abs() && dropDistance >= 20) {
      double dropVelocity = dropDistance / dropElapsedMilliseconds;
      double totalVelocity = _verticalSwipeDistance / currentElapsedMilliseconds;
      // print(
      //     'Drop( ${dropDistance.toStringAsFixed(2)} / ${dropElapsedMilliseconds}ms => ${dropVelocity.toStringAsFixed(2)})  '
      //     'Total( ${verticalSwipeDistance.toStringAsFixed(2)} / ${currentElapsedMilliseconds}ms => ${totalVelocity.toStringAsFixed(2)})');

      // 임계치를 넘어섰다면 SwipeDown 콜백
      if (dropVelocity >= _dropTriggerSpeed) {
        return true;
      }
    }
    return false;
  }
}
