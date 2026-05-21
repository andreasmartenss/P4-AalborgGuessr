import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/score/model/scorepage_model.dart';
import 'package:flutter_application_1/features/game/viewmodel/game_page_vm.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_application_1/features/location/viewmodel/OSM_location_vm.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/features/game/view/game_page.dart';
import 'package:flutter_application_1/features/home/view/home_page.dart';

class ScorePageApp extends StatelessWidget {
  final GamePageVM gamePageVM;
  const ScorePageApp({super.key, required this.gamePageVM});

  @override
  Widget build(BuildContext context) {
    return ScorePage(title: 'Score Page', gamePageVM: gamePageVM);
  }
}

class ScorePage extends StatefulWidget {
  final GamePageVM gamePageVM;
  const ScorePage({super.key, required this.gamePageVM, required this.title});

  final String title;

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  final GamePageVM _gamePageVM = GamePageVM();
  int totalScore = 0;
  int accuracyScore = 0;
  int timeScore = 0;
  String timeDisplay = '00:00';

  final osmVm = OsmLocationVm();

  @override
  void initState() {
    super.initState();

    osmVm.mapController = MapController.withPosition(
      initPosition: GeoPoint(latitude: 57.0488, longitude: 9.9217),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 1000));
      await osmVm.addMarker(widget.gamePageVM); // sætter distanceInMeters

      widget.gamePageVM.addRoundScore(); // beregn score EFTER GPS er hentet

      final distance = widget.gamePageVM.distanceInMeters ?? 9999.0;
      final time = widget.gamePageVM.timeUsage;
      final model = ScorepageModel();

      setState(() {
        totalScore = model.calculatePoints(distance, time);
        accuracyScore = model.calculatePoints(distance, 0);
        timeScore = totalScore - accuracyScore;

        final minutes = (time ~/ 60).toString().padLeft(2, '0');
        final seconds = (time % 60).toString().padLeft(2, '0');
        timeDisplay = '$minutes:$seconds';
      });
    });
  }

  void _showSkipExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Text(
          "Leave game?",
          style: GoogleFonts.signika(fontSize: 14, color: Colors.grey),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── Map ────────────────────────────────────────────────────
            Expanded(
              child: Container(
                color: Colors.grey[300],
                child: OSMFlutter(
                  controller: osmVm.mapController,
                  osmOption: OSMOption(
                    zoomOption: ZoomOption(
                      initZoom: 13,
                      minZoomLevel: 3,
                      maxZoomLevel: 19,
                    ),
                    userTrackingOption: UserTrackingOption(
                      enableTracking: false,
                      unFollowUser: true,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Bottom buttons ─────────────────────────────────────────
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

                  const Spacer(),

                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await Future.delayed(Duration.zero);
                        widget.gamePageVM.nextRound();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          216,
                          110,
                          183,
                          58,
                        ),
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
                  const SizedBox(width: 52),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
