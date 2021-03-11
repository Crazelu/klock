import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class SimpleAnalogClockView extends StatefulWidget {
  @override
  _SimpleAnalogClockViewState createState() => _SimpleAnalogClockViewState();
}

class _SimpleAnalogClockViewState extends State<SimpleAnalogClockView> {
  DateTime _date;
  TimeOfDay _time;

  @override
  void initState() {
    super.initState();
    _date = DateTime.now();
    _time = TimeOfDay.fromDateTime(_date);
    Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        _date = DateTime.now();
        _time = TimeOfDay.fromDateTime(_date);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClockPainterWrapper(date: _date),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                    '${_time.hourOfPeriod.toString().padLeft(2, '0')} : ${_time.minute.toString().padLeft(2, '0')}',
                    style: Theme.of(context).textTheme.headline2),
                Text('${_time.period == DayPeriod.am ? 'AM' : 'PM'}',
                    style: Theme.of(context).textTheme.headline6)
              ],
            ),
          ],
        ));
  }
}

class ClockPainterWrapper extends StatelessWidget {
  final DateTime date;

  const ClockPainterWrapper({Key key, this.date}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        width: 300,
        child: Transform.rotate(
            angle: -pi / 2, child: CustomPaint(painter: ClockPainter(date))));
  }
}

class ClockPainter extends CustomPainter {
  final DateTime date;

  ClockPainter(this.date);
  @override
  void paint(Canvas canvas, Size size) {
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var radius = min(centerX, centerY);
    var center = Offset(centerX, centerY);

    var clockBrush = Paint()..color = Colors.white;
    var dotBrush = Paint()..color = Colors.grey[100];
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
    canvas.drawCircle(center, radius - 30, outlineClockBrush);
    //main clock face
    canvas.drawCircle(center, radius - 30, clockBrush);
    //inner stroke
    canvas.drawCircle(center, radius - 65, inlineClockBrush);

    var secX = centerX + 80 * cos(date.second * 6 * pi / 180);
    var secY = centerY + 80 * sin(date.second * 6 * pi / 180);

    var minX = centerX + 70 * cos(date.minute * 6 * pi / 180);
    var minY = centerY + 70 * sin(date.minute * 6 * pi / 180);

    var hourX =
        centerX + 50 * cos((date.hour * 30 + date.minute * 0.5) * pi / 180);
    var hourY =
        centerY + 50 * sin((date.hour * 30 + date.minute * 0.5) * pi / 180);

    var secHandBrush = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..color = Colors.grey;
    var minHandBrush = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..color = Colors.black;
    var hourHandBrush = Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.7
      ..color = Colors.blue;

//clock hands
    canvas.drawLine(center, Offset(minX, minY), minHandBrush);
    canvas.drawLine(center, Offset(hourX, hourY), hourHandBrush);
    canvas.drawLine(center, Offset(secX, secY), secHandBrush);
    canvas.drawCircle(center, 6, dotBrush);

    //minutes lines
    var linesBrush = Paint()
      ..color = Colors.blueGrey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    var outerRadius = radius - 34;
    var innerRadius = radius - 44;

    for (double i = 0; i < 360; i += 12) {
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
