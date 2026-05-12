import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/score/view/score_page.dart';
import 'package:flutter_application_1/features/game/view/result_page.dart';
import 'package:flutter_application_1/features/home/view/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pocketbase/pocketbase.dart';
import '../viewmodel/game_page_vm.dart';
import 'package:flutter_application_1/core/services/pocketbase_service.dart';

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
      home: const TheGamePage(title: 'game page'),
    );
  }
}

class TheGamePage extends StatefulWidget {
  const TheGamePage({super.key, required this.title});

  final String title;

  @override
  State<TheGamePage> createState() => _TheGamePageState();
}

class _TheGamePageState extends State<TheGamePage> {
  final GamePageVM _gamePageVM = GamePageVM();

  @override
  void initState() {
    super.initState();
    _gamePageVM.startRound();
    _gamePageVM.addListener(() {
      if (_gamePageVM.navigateToScore) {
        _gamePageVM.navigateToScore = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScorePageApp(gamePageVM: _gamePageVM),
            ),
          );
        });
      }
      if (_gamePageVM.navigateToWellDone) {
        _gamePageVM.navigateToWellDone = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  WellDonePage(roundScores: _gamePageVM.roundScores),
            ),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _gamePageVM.dispose();
    super.dispose();
  }

  void _showSkipExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Text(
          "Skip round or leave game?",
          style: GoogleFonts.signika(fontSize: 14, color: Colors.grey),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _gamePageVM.skipRound();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                child: Text(
                  'SKIP',
                  style: GoogleFonts.signika(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _gamePageVM.leaveGame();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                child: Text(
                  'LEAVE',
                  style: GoogleFonts.signika(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _gamePageVM,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 40,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _gamePageVM.formattedTime,
                      style: GoogleFonts.signika(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Score: ${_gamePageVM.score}',
                      style: GoogleFonts.signika(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${_gamePageVM.currentRound}/${_gamePageVM.totalRounds}',
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _gamePageVM.pictures == null
                        ? const Center(child: CircularProgressIndicator())
                        : Image.network(
                            'http://130.225.39.250:8090/api/files/${_gamePageVM.pictures!.collectionId}/${_gamePageVM.pictures!.id}/${_gamePageVM.pictures!.data['photos']}?thumb=500x500',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: _showSkipExitDialog,
                        icon: const Icon(
                          Icons.cancel_outlined,
                          size: 36,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: _gamePageVM.onGuess,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            216,
                            110,
                            183,
                            58,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: const StadiumBorder(),
                        ),
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
      },
    );
  }
}
