import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/score/model/scorepage_model.dart';
import 'package:flutter_application_1/features/game/model/game_geo_model.dart';
import 'package:flutter_application_1/features/game/model/game_photo_selecter.dart';
import 'package:pocketbase/pocketbase.dart';
import 'dart:async';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';

/// This class is s a view-model for the game, that fetches elements from the geo model, photo selecter model and the score model
/// and turn it into data for the view to show.
class GamePageVM extends ChangeNotifier {
  /// Objects from the models initialized
  final GeoModel _geoModel = GeoModel();
  final PhotoPickerModel _photoModel = PhotoPickerModel();
  final ScorepageModel _scorepageModel = ScorepageModel();

  /// Attributes from the score, inidividual rounds, total rounds, the amount of time and navigations to different pages.
  int score = 0;
  int currentRound = 1;
  int totalRounds = 5;
  int timeUsage = 0;
  bool navigateToScore = false;
  bool navigateToWellDone = false;

  /// Attributes that takes the distance in meters from the geo model.
  double? distanceInMeters;

  /// List of integers of the scores of individual rounds.
  final List<int> _roundScores = [];

  /// a getter for the list.
  List<int> get roundScores => _roundScores;

  /// Built in timer in dart.
  Timer? _timer;

  /// This method formats the time in the rounds, and parses the integers into strings.
  String get formattedTime {
    int minutes = timeUsage ~/ 60;
    int seconds = timeUsage % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// This method starts the timer from zero and increments the timer by one second.
  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timeUsage++;
      notifyListeners();
    });
  }

  /// Fetches the pictures from the Pocketbase.
  RecordModel? pictures;

  /// Getter that takes the longtitude and latitude from the pictures. These values gets parsed into strings.
  GeoPoint? get location {
    final raw = pictures?.data['location'];
    if (raw == null) return null;
    final lat = double.parse(raw['lat'].toString());
    final lon = double.parse(raw['lon'].toString());
    return GeoPoint(latitude: lat, longitude: lon);
  }

  /// Promise, that uses the randomizer to select an unused photo.
  Future<void> getPicture() async {
    pictures = await _photoModel.pickUnseenPhoto();
    notifyListeners();
  }

  /// Promise, that initializes the selected photo, the timer, distance.
  Future<void> startRound() async {
    if (currentRound == 1) {
      _photoModel.reset();
    }
    timeUsage = 0;
    distanceInMeters = null;
    _timer?.cancel();
    startTimer();
    await getPicture();
    notifyListeners();
  }

  /// This method sets the location of where the player guessed from.
  void setGuessLocation(GeoPoint guessedPoint) {
    final correct = location;

    /// If-statement that states if the photos location is equal to null,than print this in the console.
    if (correct == null) {
      print("DEBUG: correct location er null!");
      return;
    }

    /// Calculaes the distance between the photo and the player in meters using the geo model.
    distanceInMeters = _geoModel.calculateDistance(correct, guessedPoint);
    print("DEBUG: distanceInMeters = $distanceInMeters");
    notifyListeners();
  }

  /// This method adds the score to the rounds when the player has guessed.
  void addRoundScore() {
    final distance = distanceInMeters ?? 9999.0;
    print("DEBUG: addRoundScore bruger distance = $distance, tid = $timeUsage");
    final roundScore = _scorepageModel.calculatePoints(distance, timeUsage);
    print("DEBUG: roundScore = $roundScore");
    score += roundScore;
    _roundScores.add(roundScore);
    notifyListeners();
  }

  /// Promise, that saves all individual rounds. This is for the result page.
  Future<void> saveAllScores() async {
    print("DEBUG: _roundScores ved saveAllScores = $_roundScores");
    if (_roundScores.length < 5) {
      print("DEBUG: for få scores! Antal = ${_roundScores.length}");
      return;
    }

    await _scorepageModel.saveGameScore(
      round1: _roundScores[0],
      round2: _roundScores[1],
      round3: _roundScores[2],
      round4: _roundScores[3],
      round5: _roundScores[4],
    );
  }

  /// Promise, that increments the rounds until the fith round.
  Future<void> nextRound() async {
    if (currentRound < totalRounds) {
      currentRound++;
      await startRound();
    } else {
      currentRound++;

      /// giver dette mening? når den har ramt 5 runder, burde den så imcrement endnu engang?
      _timer?.cancel();
      await saveAllScores();
      navigateToWellDone = true;
    }
    notifyListeners();
  }

  /// Promise, that allows the user to skip the round.
  Future<void> skipRound() async {
    nextRound();
  }

  /// Method that allows the player to leave the game.
  void leaveGame() {
    _timer?.cancel();
    notifyListeners();
  }

  /// Method that navigates the user to the score page.
  Future<void> onGuess() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      final guessedPoint = GeoPoint(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      setGuessLocation(guessedPoint);
    } catch (e) {
      print("DEBUG: GPS fejl: $e");
    }
    addRoundScore();
    navigateToScore = true;
    if (currentRound >= totalRounds) {
      _timer?.cancel();
    }
    notifyListeners();
  }

  /// This method stops the timer, and disposes it from the heap.
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
