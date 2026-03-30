import 'package:flutter/material.dart';

void main() {
  runApp(const ScorePageApp());
}

class ScorePageApp extends StatelessWidget {
  const ScorePageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Score Page',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      home: const ScorePage(title: 'Score Page'),
    );
  }
}

class ScorePage extends StatefulWidget {
  const ScorePage({super.key, required this.title});

  final String title;

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  // Example values – replace with real data later
  final int totalScore = 4123;
  final int accuracyScore = 3123;
  final int timeScore = 1000;
  final String timeDisplay = '05:30';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top score section ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Column(
                children: [
                  const Text(
                    'SCORE',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  Text(
                    '$totalScore',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // ── Accuracy & Time row ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Accuracy
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Accuracy',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '$accuracyScore',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  // Time
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Time: $timeDisplay',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text('$timeScore', style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── Map placeholder ────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Text(
                      'Map Placeholder',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Bottom buttons ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Close / cancel button
                  GestureDetector(
                    onTap: () {
                      // TODO: handle close
                    },
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.shade400,
                          width: 2,
                        ),
                      ),
                      child: const Icon(Icons.close, size: 26),
                    ),
                  ),

                  const Spacer(),

                  // NEXT button
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: handle next
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(216, 110, 183, 58),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'NEXT',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),
                  const SizedBox(width: 52), // Sized box som fylder lige så meget som close knappen, for at holde NEXT centreret
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
