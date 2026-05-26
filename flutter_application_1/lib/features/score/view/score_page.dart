import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/score/model/scorepage_model.dart';
import 'package:flutter_application_1/features/game/viewmodel/game_page_vm.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_application_1/features/location/viewmodel/OSM_location_vm.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/features/home/view/home_page.dart';

///Widget that passes the GamePageVM to the ScorePage
class ScorePageApp extends StatelessWidget {
  final GamePageVM gamePageVM;
  const ScorePageApp({super.key, required this.gamePageVM});

  @override
  Widget build(BuildContext context) {
    return ScorePage(title: 'Score Page', gamePageVM: gamePageVM);
  }
}

/// Widget for the score page that is being shown after each gameround
class ScorePage extends StatefulWidget {
  final GamePageVM gamePageVM;
  const ScorePage({super.key, required this.gamePageVM, required this.title});

  final String title;

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  ///A local instance of the gamepage used for the leave game function
  final GamePageVM _gamePageVM = GamePageVM();

  ///Initialized variables for the score values displayed on the scorepage
  int totalScore = 0;
  int accuracyScore = 0;
  int timeScore = 0;
  String timeDisplay = '00:00';

  ///Handler for the open street map controller and marker placer
  final osmVm = OsmLocationVm();

  @override
  void initState() {
    super.initState();

    /// Initializes the map with the position defaulting to central Aalborg as the games takes places there
    osmVm.mapController = MapController.withPosition(
      initPosition: GeoPoint(latitude: 57.0488, longitude: 9.9217),
    );

    ///Waits for the widgets to build before interacting with the map
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      /// Adding a short delay to make sure the map is fully loaded before plaing markers down
      await Future.delayed(const Duration(milliseconds: 1000));

      /// Adds markers for the pictures location and the players position (based on gps)
      /// Draws a line between the 2 positions on the map
      await osmVm.addMarker(widget.gamePageVM); 

      ///Getting the distance and time used from the gamepageVM
      final distance = widget.gamePageVM.distanceInMeters ?? 9999.0;
      final time = widget.gamePageVM.timeUsage;
      final model = ScorepageModel();

      /// Updates the ui with the scores and the time
      setState(() {
        ///total score based on time and distance
        totalScore = model.calculatePoints(distance, time);
        
        ///Accuraceyscore calculated on distance and with time set to 0 to ignore it
        accuracyScore = model.calculatePoints(distance, 0);

        ///Sets the timeScore as the difference between the totalscore and the accuraceyscore
        timeScore = totalScore - accuracyScore;

        ///Formatting the time to MM:SS for the display in the app
        final minutes = (time ~/ 60).toString().padLeft(2, '0');
        final seconds = (time % 60).toString().padLeft(2, '0');
        timeDisplay = '$minutes:$seconds';
      });
    });
  }

  ///Shows the leave dialog
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
                  /// uses the leaveGame() method to cancel the timer and leave the game
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
            //Top score section
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
                  ///Shows total score for the round
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

            // Accuracey and time row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Left column shows the accuracey score without the time calculation
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
                  /// Right column shos the time used and the score penalty
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

            // OSM Map
            //This displays the map on the scorePage, where the player is positioned and where the target location is
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
                    ///Tracking is disabled so the map stays focused on the route and not the player
                    userTrackingOption: UserTrackingOption(
                      enableTracking: false,
                      unFollowUser: true,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            //Bottom buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ///The 'x' button that opens the leave game / skip round dialog
                  IconButton(
                    onPressed: _showSkipExitDialog,
                    icon: const Icon(
                      Icons.cancel_outlined,
                      size: 36,
                      color: Colors.black,
                    ),
                  ),
                  /// the 'Next' button that navigates to the gamepage to start the next round
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
                  // Empty box that fills out the layout to ensure the rows are ballanced
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
