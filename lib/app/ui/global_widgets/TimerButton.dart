import 'dart:async';

import 'package:flutter/material.dart';

typedef CallBack = void Function();

class TimerButton extends StatefulWidget {
  const TimerButton({
    Key? key,
    this.sameCallBack = true,
    this.time = 15,
    required this.onTap,
    this.onTimeOut,
    this.style,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.splashColor,
    this.title = 'Reject',
  }) : assert(style != null || backgroundColor != null);

  final int time;
  final bool sameCallBack;
  final CallBack onTap;
  final CallBack? onTimeOut;
  final ButtonStyle? style;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final Color? splashColor;
  final String title;

  @override
  _TimerButtonState createState() => _TimerButtonState(time);
}

class _TimerButtonState extends State<TimerButton> {
  _TimerButtonState(this.maximumTime);

  int maximumTime;
  late Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (tim) {
      if (maximumTime <= 0) {
        _timer.cancel();
        if (widget.sameCallBack) {
          widget.onTap();
        } else {
          var callback = widget.onTimeOut ?? widget.onTap;
          callback();
        }
      } else
        this.setState(() => maximumTime--);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: FittedBox(
        child: Row(
          children: [
            Text(
              '${maximumTime}s',
              style: TextStyle(
                color: widget.textColor,
              ),
            ),
            SizedBox(width: 8),
            Text(
              widget.title,
              style: TextStyle(
                color: widget.textColor,
              ),
            ),
          ],
        ),
      ),
      style: widget.style ??
          TextButton.styleFrom(
            backgroundColor: widget.backgroundColor,
            primary: widget.splashColor ?? Colors.white,
            minimumSize: Size(100, 50),
            shape: StadiumBorder(
              side: BorderSide(
                  color:
                      (widget.borderColor ?? widget.backgroundColor) as Color),
            ),
          ),
      onPressed: widget.onTap,
    );
  }
}
