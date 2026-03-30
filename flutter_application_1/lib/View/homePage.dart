import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aalborg Guessr',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background picture
          Image.asset(
            'assets/AalborgLuftfoto.jpeg',
          fit: BoxFit.cover,
          ),
        
        // Semi-transparent white overlay
        Container(
          color: Colors.white.withValues(alpha: 0.25),
        ),

        // Foreground content
        SafeArea(
          child: Column(
            children: [
              // Info button - top right
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  child: IconButton(
                    icon: const Icon(Icons.info_outline, size: 28),
                    color: Colors.black87,
                    onPressed: () {
                      // TODO: Show info dialog
                    },
                  ),
                ),
              ),

              const Spacer(),

              // Title
              const Text(
                'Aalborg\nGuessr',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  height: 1.1,
                ),
              ),

              const SizedBox(height: 48),

              // Highscore
              const Text(
                'HIGHSCORE',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    '4821',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // New Game button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 48.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Navigate to game screen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      'NEW GAME',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
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