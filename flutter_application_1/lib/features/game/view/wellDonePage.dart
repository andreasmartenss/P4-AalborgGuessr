import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/home/view/home_page.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import 'package:share_plus/share_plus.dart';
import '../../score/model/scorepage_model.dart';
import '../viewmodel/gamePageVM.dart';
import 'scorePage.dart';

void main() {
  runApp(const WellDonePage(roundScores: []));
}

class WellDonePage extends StatelessWidget {
  final List<int> roundScores;

  const WellDonePage({super.key, required this.roundScores});

  @override
  Widget build(BuildContext context) {
    return UIPage(title: 'Well Done Page', roundScores: roundScores);
  }
}

class UIPage extends StatefulWidget {
  const UIPage({super.key, required this.title, required this.roundScores});

  final String title;
  final List<int> roundScores;

  @override
  State<UIPage> createState() => _UIPageState();
}

class _UIPageState extends State<UIPage> {
  Widget _buildRound(String title, int index) {
    if (widget.roundScores.length <= index) {
      return Text("$title: 0", style: const TextStyle(fontSize: 25));
    }

    return Text(
      "$title: ${widget.roundScores[index]}",
      style: const TextStyle(fontSize: 25),
    );
  }

  void _UIbutton() {
    setState(() {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false,
      );
    });
  }

  late ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: Duration(seconds: 3));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 250, 225),
            ],
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 80),

                child: Column(
                  children: const [
                    Text('WELL DONE!', style: TextStyle(fontSize: 40)),
                  ],
                ),
              ),
            ),

            Align(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildRound("ROUND 1", 0),
                  const SizedBox(height: 10),

                  _buildRound("ROUND 2", 1),
                  const SizedBox(height: 10),

                  _buildRound("ROUND 3", 2),
                  const SizedBox(height: 10),

                  _buildRound("ROUND 4", 3),
                  const SizedBox(height: 10),

                  _buildRound("ROUND 5", 4),
                  const SizedBox(height: 20),

                  Text(
                    widget.roundScores
                        .fold(0, (sum, item) => sum + item)
                        .toString(),
                    style: const TextStyle(fontSize: 40),
                  ),
                ],
              ),
            ),

            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    Share.share('Share your score!', subject: 'AalborgGuessur');
                  },
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(100),
                child: LiquidGlassLayer(
                  settings: const LiquidGlassSettings(
                    blur: 10,
                    thickness: 20,
                    glassColor: Color.fromARGB(255, 139, 207, 95),
                  ),
                  child: LiquidGlass(
                    shape: LiquidRoundedSuperellipse(borderRadius: 30),
                    child: SizedBox(
                      width: 150,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _UIbutton,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            110,
                            184,
                            58,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "FINISH",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 23,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Align(
              alignment: Alignment.topLeft,
              child: ConfettiWidget(
                confettiController: _controller,
                blastDirection: pi / 4,
                emissionFrequency: 0.05,
                numberOfParticles: 20,
                maxBlastForce: 20,
                minBlastForce: 5,
                gravity: 0.3,
                shouldLoop: false,
              ),
            ),

            Align(
              alignment: Alignment.topRight,
              child: ConfettiWidget(
                confettiController: _controller,
                blastDirection: pi / 1,
                emissionFrequency: 0.05,
                numberOfParticles: 20,
                maxBlastForce: 20,
                minBlastForce: 5,
                gravity: 0.3,
                shouldLoop: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
