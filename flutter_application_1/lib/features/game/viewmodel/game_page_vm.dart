import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/score/model/scorepage_model.dart';
import 'package:flutter_application_1/features/game/model/game_geo_model.dart';
import 'package:flutter_application_1/features/game/model/game_photo_selecter.dart';
import 'package:pocketbase/pocketbase.dart';
import 'dart:async';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class GamePageVM extends ChangeNotifier {
  final GeoModel _geoModel = GeoModel();
  final PhotoPickerModel _photoModel = PhotoPickerModel();
  final ScorepageModel _scorepageModel = ScorepageModel();

  int score = 0;
  int currentRound = 1;
  int totalRounds = 5;
  int timeUsage = 0;
  bool navigateToScore = false;
  bool navigateToWellDone = false;

  double? distanceInMeters;
  final List<int> _roundScores = [];
  List<int> get roundScores => _roundScores;

  Timer? _timer;

  String get formattedTime {
    int minutes = timeUsage ~/ 60;
    int seconds = timeUsage % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timeUsage++;
      notifyListeners();
    });
  }

  RecordModel? pictures;

  GeoPoint? get location {
    final raw = pictures?.data['location'];
    if (raw == null) return null;
    final lat = double.parse(raw['lat'].toString());
    final lon = double.parse(raw['lon'].toString());
    return GeoPoint(latitude: lat, longitude: lon);
  }

  // NOW uses PhotoPickerModel instead of inline logic
  Future<void> getPicture() async {
    pictures = await _photoModel.pickUnseenPhoto();
    notifyListeners();
  }

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

  // NOW uses GeoModel instead of inline Haversine math
  void setGuessLocation(GeoPoint guessedPoint) {
    final correct = location;
    if (correct == null) {
      print("DEBUG: correct location er null!");
      return;
    }
    distanceInMeters = _geoModel.calculateDistance(correct, guessedPoint);
    print("DEBUG: distanceInMeters = $distanceInMeters");
    notifyListeners();
  }

  // Round logic kept exactly as-is
  void addRoundScore() {
    final distance = distanceInMeters ?? 9999.0;
    print("DEBUG: addRoundScore bruger distance = $distance, tid = $timeUsage");
    final roundScore = _scorepageModel.calculatePoints(distance, timeUsage);
    print("DEBUG: roundScore = $roundScore");
    score += roundScore;
    _roundScores.add(roundScore);
    notifyListeners();
  }

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

  Future<void> nextRound() async {
    if (currentRound < totalRounds) {
      currentRound++;
      await startRound();
    } else {
      currentRound++;
      _timer?.cancel();
      await saveAllScores(); // gem til database
      navigateToWellDone = true; // naviger med data stadig i _roundScores
    }
    notifyListeners();
  }

  Future<void> skipRound() async {
    nextRound();
  }

  void leaveGame() {
    _timer?.cancel();
    notifyListeners();
  }

  void onGuess() {
  navigateToScore = true;
  if (currentRound >= totalRounds) {
    _timer?.cancel();
  }
  notifyListeners();
}

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
