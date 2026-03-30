import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:google_fonts/google_fonts.dart';
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
        colorScheme: .fromSeed(seedColor: Colors.amberAccent),
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

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        Align(
          alignment:Alignment.topCenter,
          child: Column(
            children: const [
              Text('WELL DONE!', style: TextStyle(fontSize: 24)),
            ],
          ),
        ),

        Align(
          child: Column(
            mainAxisAlignment: .center,
            children: const [
              Text("ROUND 1:", style: TextStyle(fontSize: 20)),
              Text(" ", style: TextStyle(fontSize: 20)),
              Text("ROUND 2:", style: TextStyle(fontSize: 20)),
              Text(" ", style: TextStyle(fontSize: 20)),
              Text("ROUND 3:", style: TextStyle(fontSize: 20)),
              Text(" ", style: TextStyle(fontSize: 20)),
              Text("ROUND 4:", style: TextStyle(fontSize: 20)),
              Text(" ", style: TextStyle(fontSize: 20)),
              Text("ROUND 5:", style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: LiquidGlassLayer(
              settings: const LiquidGlassSettings(
                blur: 10,
                thickness: 20,
                glassColor: Color.fromARGB(51, 131, 169, 108), 
              ),
              child: LiquidGlass(
                shape: LiquidRoundedSuperellipse(borderRadius: 30),
                child: SizedBox(
                  width: 200,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _UIbutton,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text("FINISH", style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 23
                      ),),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
}