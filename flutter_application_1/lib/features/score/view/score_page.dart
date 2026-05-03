import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/score/model/scorepage_model.dart';
import 'package:flutter_application_1/features/game/model/gamepage_model.dart';
import 'package:flutter_application_1/features/game/viewmodel/game_page_vm.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

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
  late int totalScore;
  late int accuracyScore;
  late int timeScore;
  late String timeDisplay;

  late MapController mapController;

  @override
  void initState() {
    super.initState();

    final distance = widget.gamePageVM.distanceInMeters ?? 9999.0;
    final time = widget.gamePageVM.timeUsage;
    final model = ScorepageModel();

    totalScore = model.calculatePoints(distance, time);
    accuracyScore = model.calculatePoints(distance, 0);
    timeScore = totalScore - accuracyScore;

    final minutes = (time ~/ 60).toString().padLeft(2, '0');
    final seconds = (time % 60).toString().padLeft(2, '0');
    timeDisplay = '$minutes:$seconds';

    mapController = MapController.withPosition(
      initPosition: GeoPoint(latitude: 57.0488, longitude: 9.9217),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 1000));
      print('current position: ${await mapController.myLocation()}');
      await _addMarker();
    });
  }

  Future<void> _addMarker() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final pictureLocation =
        widget.gamePageVM.location ??
        GeoPoint(latitude: 57.0488, longitude: 9.9217);

    await mapController.addMarker(
      pictureLocation,
      markerIcon: MarkerIcon(
        icon: Icon(
          Icons.flag,
          size: 80,
          color: const Color.fromARGB(255, 199, 1, 1),
        ),
      ),
    );

    try {
      final userLocation = await mapController.myLocation();
      await mapController.drawRoadManually([
        userLocation,
        pictureLocation,
      ], RoadOption(roadColor: Colors.black, roadWidth: 5, zoomInto: true));
      await mapController.addMarker(
        userLocation,
        markerIcon: MarkerIcon(
          icon: Icon(
            Icons.place,
            size: 80,
            color: const Color.fromARGB(255, 199, 1, 1),
          ),
        ),
      );
    } catch (e) {
      print('Kunne ikke tegne linje: $e');
    }
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
                      Text('$timeScore', style: const TextStyle(fontSize: 16)),
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
                  controller: mapController,
                  osmOption: OSMOption(
                    zoomOption: ZoomOption(
                      initZoom: 13,
                      minZoomLevel: 3,
                      maxZoomLevel: 19,
                    ),
                    userTrackingOption: UserTrackingOption(
                      enableTracking: true,
                      unFollowUser: true,
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
