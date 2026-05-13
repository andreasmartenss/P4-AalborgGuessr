import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/home/view/home_page.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import 'package:share_plus/share_plus.dart';

// This is the UI page for the result page.

// Void main runs the application
void main() {
  runApp(const WellDonePage(roundScores: []));
}

class WellDonePage extends StatelessWidget {
  // Attribute that makes a list of integers of individual rounds.
  final List<int> roundScores;

  // Reqirements to run the result page.
  const WellDonePage({super.key, required this.roundScores});

  // Build the page.
  @override
  Widget build(BuildContext context) {
    return UIPage(title: 'Well Done Page', roundScores: roundScores);
  }
}

// This class contains reqirements to build the application.
class UIPage extends StatefulWidget {

  // These attributes builds the application.
  const UIPage({super.key, required this.title, required this.roundScores});
  final String title;
  final List<int> roundScores;

  @override
  State<UIPage> createState() => _UIPageState();
}

// These are the UI elements and functions in the result page.
class _UIPageState extends State<UIPage> {

  // This widget are the individual round's results.
  Widget _buildRound(String title, int index) {

    /**
     * if-statement that states, if the rounds are less than, or equal to the index of results, then it should return 
     * a new titled round with the value zero.
     */
    if (widget.roundScores.length <= index) {
      return Text("$title: 0", style: const TextStyle(fontSize: 25));
    }
    // Else it should return the points of the round.
    return Text(
      "$title: ${widget.roundScores[index]}",
      style: const TextStyle(fontSize: 25),
    );
  }

  // UI button funcationality that sents the user back to the home page.
  void _UIbutton() {
    setState(() {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false,
      );
    });
  }

  // Confetti object initialized.
  late ConfettiController _controller;

  // initState is the method that initializes the functionaliies of the confetti effect.
  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: Duration(seconds: 3));
    _controller.play();
  }

  // Disposes the confetti object after initializing it, so the object does not remain in the heap.
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // These are the visual elements.
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
        // Title border.
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 80),

                child: Column(
                  children:  [
                    Text('WELL DONE!', style: TextStyle(fontSize: 40,)),
                    // Taking each individual rounds and adds them together to show the user their total score.
                    Text(
                      widget.roundScores
                          .fold(0, (sum, item) => sum + item)
                          .toString(),
                      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            // Showing the user their results of individual rounds.
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
               
                ],
              ),
            ),

          // Share button.
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

            // Button that sends the user back to the home page.
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
                        // Functionality taken from the _UIbutton method above.
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

                        // Text inside of the button.
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

            // Confetti effect that shoots from the top left corner of the screen.
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

            // Confetti effectthat shoots from the top right corner of the screen.
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
