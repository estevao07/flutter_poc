import 'package:flutter/material.dart';

import 'package:flutter_mottu_poc/screens/battery_screen.dart';
import 'package:flutter_mottu_poc/screens/home_screen.dart';
import 'package:flutter_mottu_poc/screens/show_string_parameters_screen.dart';
import 'package:flutter_mottu_poc/screens/show_string_screen.dart';
import 'package:flutter_mottu_poc/screens/sms_screen.dart';
import 'package:flutter_mottu_poc/screens/timer_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
      routes: {
        '/timer': (context) => const TimerScreen(),
        '/show_string': (context) => const ShowStringScreen(),
        '/show_string_parameters': (context) =>
            const ShowStringParametersScreen(),
        '/battery': (context) => const BatteryScreen(),
        '/sms': (context) => const SmsScreen(),
      },
    );
  }
}
