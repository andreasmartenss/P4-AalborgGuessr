import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:async';
import '../ViewModel/database.dart';

class GamePageVM extends ChangeNotifier {
  int score = 0;
  int currentRound = 1;
  int totalRounds = 5;
  int timeUsage = 0;
  String? url = "";
  final double latitude;
  final double longitude;

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

  Picture? _pictures;

  void getPicture() {
    _pictures = Picture.
  }

  void startRound() {
    timeUsage = 0;
    _timer?.cancel();
    startTimer();
    notifyListeners();
  }

  void nextRound() {
    if (currentRound < totalRounds) {
      currentRound++;
      startRound();
    } else {
      _timer?.cancel();
    }
    notifyListeners();
  }

  void skipRound() {
  nextRound();
  }

  void leaveGame() {
    _timer?.cancel();
    notifyListeners();
  }

  void onGuess() {
    nextRound();// guess logic skal her
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}