import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Aalborg Guessr', home: const HomePage());
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
          Image.asset('assets/AalborgLuftfoto.jpeg', fit: BoxFit.cover),

          // Semi-transparent white overlay
          Container(color: Colors.white.withValues(alpha: 0.25)),

          // Foreground content
          SafeArea(
            child: Column(
              children: [
                // Info button - top right
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 8.0,
                    ),
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
                Text(
                  'Aalborg\nGuessr',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cutive(
                    fontSize: 48,
                    color: Colors.black87,
                    height: 1.1,
                  ),
                ),

                const SizedBox(height: 48),

                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    // Highscore text is places underneath
                    Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ), // pushes the text down, so the GIF overlaps it
                        Text(
                          'HIGHSCORE',
                          style: GoogleFonts.signika(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '4821',
                          style: GoogleFonts.signika(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xDD000000),
                          ),
                        ),
                      ],
                    ),

                    Image.asset(
                      'assets/StarsSparkle.gif',
                      width: 120,
                      height: 120,
                    ),
                  ],
                ),

                const Spacer(),

                // New Game button
                Padding(
                  padding: const EdgeInsets.only(bottom: 150),
                  child: LiquidGlassLayer(
                    settings: const LiquidGlassSettings(
                      blur: 10,
                      thickness: 20,
                      glassColor: Color.fromARGB(255, 40, 120, 10),
                    ),
                    child: LiquidGlass(
                      shape: LiquidRoundedSuperellipse(borderRadius: 30),
                      child: SizedBox(
                        width: 220,
                        height: 64,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'NEW GAME',
                            style: GoogleFonts.signika(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              letterSpacing: 2,
                            ),
                          ),
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
