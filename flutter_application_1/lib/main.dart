import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/game/view/game_page.dart';


void main() {
  runApp(const GamePage());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const GamePage(),
    );
  }
}

