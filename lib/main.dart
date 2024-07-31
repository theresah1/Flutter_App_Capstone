
// // change directory to = C:\Users\THERESAH\OneDrive - Ashesi University\Desktop\MY CAPSTONE\scrcpy-win64-v2.4\scrcpy-win64-v2.4
// //enter= scrcpy

import 'package:flutter/material.dart';
import 'Screens/login.dart';
import 'Screens/dashboard.dart';
import 'Screens/conductivity.dart';
import 'Screens/all_readings.dart';
import 'Screens/ph.dart';
import 'Screens/od.dart';
import 'Screens/resistivity.dart';
import 'Screens/help.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyApp',
      initialRoute: '/',
      routes: {
        '/': (context) => const Login(),
        '/dashboard': (context) => const Dashboard(),
        '/conductivity': (context) => const Conductivity(),
        '/allReadings': (context) => const AllReadings(),
        '/ph': (context) => const Ph(),
        '/od': (context) => const Od(),
        '/help': (context) => const Help(),
        '/resistivity': (context) => const Resistivity(),
      },
    );
  }
}

