import 'package:flutter/material.dart';
import 'package:klock/clocks/simple_analog_clock_view.dart';
import 'package:klock/funky_animations/animated_alarm_clock.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Klocks',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        children: [AnimatedAlarmClock(), SimpleAnalogClockView()],
      ),
    ));
  }
}
