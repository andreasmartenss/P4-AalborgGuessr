import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import '../../game/view/game_page.dart';
import 'package:flutter_application_1/features/home/viewmodel/home_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/core/services/pocketbase_service.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => HomeViewModel(PocketBaseService()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Aalborg Guessr', home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().loadHighScore();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/AalborgLuftfoto.jpeg', fit: BoxFit.cover),
          Container(color: Colors.white.withValues(alpha: 0.25)),
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
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (_) => AlertDialog(
                            title: const Text('Wellcome to AalborgGuessr!'),
                            content: const Text('Press “NEW GAME” to begin the game. The game consists of five rounds, where you have to go to each of the locations as shown in the picture. Have fun!'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color.fromARGB(255, 50, 50, 50),
                                ),
                                child: const Text('Close'),
                              ),
                            ],
                            elevation: 24.0,
                            actionsPadding: const EdgeInsets.only(right: 12.0, bottom: 8.0),
                            backgroundColor: const Color.fromARGB(255, 255, 250, 225),
                            titleTextStyle: GoogleFonts.signika(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            contentTextStyle: GoogleFonts.signika(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        );
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
                    Column(
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          'HIGHSCORE',
                          style: GoogleFonts.signika(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Consumer<HomeViewModel>(
                          builder: (context, vm, child) {
                            return Text(
                              '${vm.totalScore}',
                              style: GoogleFonts.signika(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Image.asset(
                      'assets/StarsSparkle.gif',
                      width: 140,
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
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GamePage(),
                              ),
                            );
                            // Opdater highscore når vi vender tilbage fra spillet
                            if (context.mounted) {
                              context.read<HomeViewModel>().loadHighScore();
                            }
                          },
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