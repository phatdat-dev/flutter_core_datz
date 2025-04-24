import 'package:flutter/material.dart';

class CountDownTimer extends StatefulWidget {
  const CountDownTimer({super.key, required this.secondsRemaining, this.whenTimeExpires, this.countDownFormatter, this.style, this.onChanged});

  final int secondsRemaining;
  final VoidCallback? whenTimeExpires;
  final ValueChanged<int>? onChanged;
  final TextStyle? style;
  final String Function(int seconds)? countDownFormatter;

  @override
  State<CountDownTimer> createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> with TickerProviderStateMixin {
  late AnimationController _controller;
  late int _currentSeconds;

  String get timerDisplayString {
    final remainingSeconds = (_controller.duration! * _controller.value).inSeconds;
    return widget.countDownFormatter?.call(remainingSeconds) ?? _formatHHMMSS(remainingSeconds);
  }

  @override
  void initState() {
    super.initState();
    _initializeController(widget.secondsRemaining);
  }

  @override
  void didUpdateWidget(CountDownTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.secondsRemaining != oldWidget.secondsRemaining) {
      _controller.dispose();
      _initializeController(widget.secondsRemaining);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initializeController(int seconds) {
    _currentSeconds = seconds;
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: seconds))
          ..reverse(from: seconds.toDouble())
          ..addListener(() {
            final remainingSeconds = (_controller.duration! * _controller.value).inSeconds;
            if (remainingSeconds != _currentSeconds) {
              _currentSeconds = remainingSeconds;
              widget.onChanged?.call(remainingSeconds);
            }
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.dismissed || status == AnimationStatus.completed) {
              widget.whenTimeExpires?.call();
            }
          });
  }

  String _formatHHMMSS(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secondsRemaining = seconds % 60;

    final hoursStr = hours.toString().padLeft(2, '0');
    final minutesStr = minutes.toString().padLeft(2, '0');
    final secondsStr = secondsRemaining.toString().padLeft(2, '0');

    if (hours > 0) {
      return '$hoursStr:$minutesStr:$secondsStr';
    } else if (minutes > 0) {
      return '$minutesStr:$secondsStr';
    }
    return secondsStr;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Text(timerDisplayString, style: widget.style);
      },
    );
  }
}
