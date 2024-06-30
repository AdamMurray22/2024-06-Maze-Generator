import 'package:flutter/material.dart';

import 'Screen/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainScreen(title: 'Maze Generator by Adam Murray'),
        debugShowCheckedModeBanner: false
    );
  }
}