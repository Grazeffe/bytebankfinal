import 'package:flutter/material.dart';

import 'screens/dashboard.dart';

void main() {
  runApp(const BytebankApp());
}

class BytebankApp extends StatelessWidget {
  const BytebankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      //   appBarTheme: AppBarTheme(color: Colors.blueAccent),
      //   useMaterial3: true,
      // ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green, secondary: Colors.blueAccent[700]),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blueAccent[700],
          textTheme: ButtonTextTheme.primary,
        ),
        appBarTheme: AppBarTheme(color: Colors.green[900]),
      ),
      // theme: ThemeData(
      //     primaryColor: Colors.green[900],
      //     accentColor: Colors.blueAccent[700],
      //     buttonTheme: ButtonThemeData(
      //       buttonColor: Colors.blueAccent[700],
      //       textTheme: ButtonTextTheme.primary,
      //     )),
      home: const Dashboard(),
    );
  }
}
