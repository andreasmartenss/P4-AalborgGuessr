import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
void main() {
  runApp(const WellDonePage());
}

class WellDonePage extends StatelessWidget {
  const WellDonePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Well done page',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: const Color(0x00fffae6)),
        textTheme: GoogleFonts.signikaTextTheme(),
      ),
      home: const UIPage(title: 'Well Done Page'),
    );
  } 
}

class UIPage extends StatefulWidget {
  const UIPage({super.key, required this.title});

  final String title;

  @override
  State<UIPage> createState() => _UIPageState();
}

class _UIPageState extends State<UIPage> {

void _UIbutton() {
    setState(() {
      
    });
  }

  late ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: Duration(seconds: 3));
    _controller.play(); // starter automatisk
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        Align(
          alignment:Alignment.topCenter,
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
            mainAxisAlignment: .center,
            children: const [
              Text("ROUND 1:", style: TextStyle(fontSize: 25)),
              Text(" ", style: TextStyle(fontSize: 20)),
              Text("ROUND 2:", style: TextStyle(fontSize: 25)),
              Text(" ", style: TextStyle(fontSize: 20)),
              Text("ROUND 3:", style: TextStyle(fontSize: 25)),
              Text(" ", style: TextStyle(fontSize: 20)),
              Text("ROUND 4:", style: TextStyle(fontSize: 25)),
              Text(" ", style: TextStyle(fontSize: 20)),
              Text("ROUND 5:", style: TextStyle(fontSize: 25)),
            ],
          ),
        ),
      
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(130),
            child: LiquidGlassLayer(
              settings: const LiquidGlassSettings(
                blur: 10,
                thickness: 20,
                glassColor: Color.fromARGB(255, 139, 207, 95), 
              ),
              child: LiquidGlass(
                shape: LiquidRoundedSuperellipse(borderRadius: 30),
                child: SizedBox(
                  width: 200,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _UIbutton,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 110, 184, 58), 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text("FINISH", style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 23
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
  );
}
}