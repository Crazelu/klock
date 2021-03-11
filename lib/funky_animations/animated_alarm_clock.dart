import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedAlarmClockView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white.withOpacity(.97),
        appBar: AppBar(
            backgroundColor: Colors.blueGrey,
            title: Text('Animated Alarm Clock'),
            centerTitle: true,
            automaticallyImplyLeading: false),
        body: Container(
            alignment: Alignment.center, child: AnimatedAlarmClock()));
  }
}

class AnimatedAlarmClock extends StatefulWidget {
  @override
  _AnimatedAlarmClockState createState() => _AnimatedAlarmClockState();
}

class _AnimatedAlarmClockState extends State<AnimatedAlarmClock>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  DateTime _time;

  @override
  void initState() {
    super.initState();
    _time = DateTime.now();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    _controller.forward();
    _controller.addListener(() {
      setState(() {});
      if (_controller.isCompleted) {
        _controller.reverse();
      }
      if (_controller.value == 0.0) {
        _controller.forward();
      }
    });

    Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        _time = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        width: 300,
        child: Transform.rotate(
          angle: -pi / 2,
          child: CustomPaint(
              painter: AlarmClockPainter(
                  animationValue: _controller.value, time: _time)),
        ));
  }
}

class AlarmClockPainter extends CustomPainter {
  DateTime _time;
  double _animationValue;
  AlarmClockPainter({DateTime time, double animationValue}) {
    _time = time ?? DateTime.now();
    _animationValue = animationValue ?? 1;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var radius = min(centerX, centerY);
    var center = Offset(centerX, centerY);

    var clockBrush = Paint()..color = Colors.white;

    var dotBrush = Paint()..color = Colors.grey[300];

    var outlineClockBrush = Paint()
      ..shader = RadialGradient(colors: [
        Colors.grey[50],
        Colors.grey[100],
        Colors.grey[200],
      ]).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15;
    var inlineClockBrush = Paint()
      ..color = Colors.grey[50]
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    //outer stroke
    canvas.drawCircle(center, radius - 80, outlineClockBrush);
    //main clock face
    canvas.drawCircle(center, radius - 80, clockBrush);
    //inner stroke
    canvas.drawCircle(center, radius - 100, inlineClockBrush);

    var secX = centerX + 45 * cos(_time.second * 6 * pi / 180);
    var secY = centerY + 45 * sin(_time.second * 6 * pi / 180);

    var minX = centerX + 38 * cos(_time.minute * 6 * pi / 180);
    var minY = centerY + 38 * sin(_time.minute * 6 * pi / 180);

    var hourX =
        centerX + 25 * cos((_time.hour * 30 + _time.minute * 0.5) * pi / 180);
    var hourY =
        centerY + 25 * sin((_time.hour * 30 + _time.minute * 0.5) * pi / 180);

    var secHandBrush = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..color = Colors.grey[400];
    var minHandBrush = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..color = Colors.redAccent;
    var hourHandBrush = Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.7
      ..color = Colors.orangeAccent;

    //clock hands
    canvas.drawLine(center, Offset(minX, minY), minHandBrush);
    canvas.drawLine(center, Offset(hourX, hourY), hourHandBrush);
    canvas.drawLine(center, Offset(secX, secY), secHandBrush);
    canvas.drawCircle(center, 5.5, dotBrush);

    //minutes lines
    var linesBrush = Paint()
      ..color = Colors.deepOrangeAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3 * _animationValue;

    var outerRadius = (radius - 84) * _animationValue;
    var innerRadius = (radius - 94) * _animationValue;

    for (double i = 0; i < 360; i += 24) {
      var x1 = centerX + outerRadius * cos(i * pi / 180);
      var y1 = centerX + outerRadius * sin(i * pi / 180);

      var x2 = centerY + innerRadius * cos(i * pi / 180);
      var y2 = centerY + innerRadius * sin(i * pi / 180);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), linesBrush);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
