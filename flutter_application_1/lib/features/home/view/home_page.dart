import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import '../../game/view/game_page.dart';
import 'package:flutter_application_1/features/home/viewmodel/home_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/core/services/pocketbase_service.dart';

// Wraps the app in a ChangeNotifierProvider to provide the HomeViewModel to the widget tree
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => HomeViewModel(PocketBaseService()), // Injects the PocketBaseService (backend) into the HomeViewModel
      child: const MyApp(),
    ),
  );
}

// The main app widget, which sets up the MaterialApp and home page
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Aalborg Guessr', home: const HomePage());
  }
}

// The home page of the app, which displays the title, high score, and a button to start a new game
// HomePage is stateful because we want to load the high score when the page is first displayed, and update it when we return from the game page
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // addPostFrameCallback ensures that the high score is loaded after the first frame is rendered, which prevents issues with calling context.read() during initState
    // safe way to trigger ViewModel logic on startup without risking context-related errors
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().loadHighScore();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand, // Each child in the stack will be sized to fill the entire screen
        children: [
          // Background image with a semi-transparent white overlay to soften the image
          Image.asset('assets/AalborgLuftfoto.jpeg', fit: BoxFit.cover),
          Container(color: Colors.white.withValues(alpha: 0.25)),
          // SafeArea ensures that the content is not obscured by system UI elements like the notch or status bar
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
                        // Show a dialog with instructions when the info button is pressed
                        showDialog(
                          context: context,
                          barrierDismissible: true, // Allows the user to dismiss the dialog by tapping outside of it
                          builder: (_) => AlertDialog(
                            title: const Text('Welcome to AalborgGuessr!'),
                            content: const Text('Press “NEW GAME” to begin the game. The game consists of five rounds, where you have to go to each of the locations as shown in the picture. Have fun!'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(), // Closes the dialog when the "Close" button is pressed
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

                // Spacer takes up all the remaining space in the column, pushing the title and high score towards the center of the screen
                const Spacer(),

                // Title of the app
                Text(
                  'Aalborg\nGuessr',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cutive(
                    fontSize: 48,
                    color: Colors.black87,
                    height: 1.1, // Adjusts the line height to create a tighter spacing between "Aalborg" and "Guessr"
                  ),
                ),

                const SizedBox(height: 48),

                // High score display with a sparkle animation on top
                // A stack is used to overlay the sparkle animation on top of the high score text, creating a visually appealing effect that draws attention to the player's high score
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
                        // Consumer widget listens to changes in the HomeViewModel and rebuilds the Text widget displaying the high score whenever the totalScore value changes, 
                        // ensuring that the displayed high score is always up to date with the latest value from the ViewModel
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
                    // Decorative sparkle animation
                    Image.asset(
                      'assets/StarsSparkle.gif',
                      width: 140,
                      height: 120,
                    ),
                  ],
                ),

                // Spacer to push the New Game button towards the bottom of the screen, while keeping the title and high score centered vertically
                const Spacer(),

                // New Game button
                // LiquidGlassLayer provides the frosted glass effect, while LiquidGlass applies the effect to the button itself, 
                // creating a visually appealing and interactive button that stands out against the background
                Padding(
                  padding: const EdgeInsets.only(bottom: 150),
                  child: LiquidGlassLayer(
                    settings: const LiquidGlassSettings(
                      blur: 10, // Frosted blur effect
                      thickness: 20, // Thickness of the glass layer, which affects how much of the background is visible through the glass
                      glassColor: Color.fromARGB(255, 40, 120, 10),
                    ),
                    child: LiquidGlass(
                      shape: LiquidRoundedSuperellipse(borderRadius: 30),
                      child: SizedBox(
                        width: 220,
                        height: 64,
                        child: ElevatedButton(
                          onPressed: () async {
                            // Navigate to the GamePage when the button is pressed, and wait for the user to return to the HomePage before executing the next line of code
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GamePage(),
                              ),
                            );
                            // When returning from the GamePage, this reloads the high score to ensure that any changes to the score are reflected on the HomePage
                            // in case a new highscore is set
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