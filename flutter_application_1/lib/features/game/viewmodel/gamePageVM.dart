import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/services/database.dart';
import 'package:flutter_application_1/features/game/view/scorePage.dart';
import 'package:flutter_application_1/features/score/model/scorepage_model.dart';
import 'package:pocketbase/pocketbase.dart';
import 'dart:async';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class GamePageVM extends ChangeNotifier {
  int score = 0;
  int currentRound = 1;
  int totalRounds = 5;
  int timeUsage = 0;

  double? distanceInMeters;
  final List<int> _roundScores = [];
  List<int> get roundScores => _roundScores;
  final ScorepageModel _scorepageModel = ScorepageModel();

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

  Future<void> getPicture() async {
    final result = await PocketBaseService.pb
        .collection('photos_and_geopoint')
        .getList(page: 1, perPage: 1, sort: '@random');
    pictures = result.items.first;
    notifyListeners();
  }

  Future<void> startRound() async {
    timeUsage = 0;
    distanceInMeters = null;
    _timer?.cancel();
    startTimer();
    await getPicture();
    notifyListeners();
  }

  bool navigateToScore = false;
  bool navigateToWellDone = false;

  void setGuessLocation(GeoPoint guessedPoint) {
    final correct = location;
    if (correct == null) return;

    const double earthRadius = 6371000;
    final double lat1 = correct.latitude * (pi / 180);
    final double lat2 = guessedPoint.latitude * (pi / 180);
    final double dLat = (guessedPoint.latitude - correct.latitude) * (pi / 180);
    final double dLon = (guessedPoint.longitude - correct.longitude) * (pi / 180);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    distanceInMeters = earthRadius * c;
    notifyListeners();
  }

  void addRoundScore() {
    final distance = distanceInMeters ?? 9999.0;
    final roundScore = _scorepageModel.calculatePoints(distance, timeUsage);
    score += roundScore;
    _roundScores.add(roundScore);
    notifyListeners();
  }

  Future<void> saveAllScores() async {
    if (_roundScores.length < 5) return;

    await _scorepageModel.saveGameScore(
      round1: _roundScores[0],
      round2: _roundScores[1],
      round3: _roundScores[2],
      round4: _roundScores[3],
      round5: _roundScores[4],
    );

    _roundScores.clear();
  }

  Future<void> nextRound() async {
    if (currentRound < totalRounds) {
      currentRound++;
      await startRound();
    } else {
      currentRound++;
      _timer?.cancel();
      await saveAllScores();
      navigateToWellDone = true;
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
    addRoundScore();
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