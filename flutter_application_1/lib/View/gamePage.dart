import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const GamePage());
}

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Page',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: const GamePage(),
    );
  }
}

class TheGamePage extends StatefulWidget {
  const TheGamePage({super.key});

  @override
  State<TheGamePage> createState() => _TheGamePageState();
}

class _TheGamePageState extends State<TheGamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '02:30',
                  style: GoogleFonts.signika(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Score: 2500',
                  style: GoogleFonts.signika(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '2/5',
                  style: GoogleFonts.signika(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(Icons.image, size: 64, color: Colors.grey),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Cancel button on the left
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.cancel, size: 36, color: Colors.black),
                  ), // IconButton
                ), // Align
                // Centered GUESS button
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(216, 110, 183, 58),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: const StadiumBorder(),
                    ), // styleFrom
                    child: Text(
                      'GUESS!',
                      style: GoogleFonts.signika(
                        fontSize: 25,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
