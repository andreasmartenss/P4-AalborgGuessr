import 'package:flutter/material.dart';
import 'dart:async';

class GamePageVM extends ChangeNotifier {
  int score = 0;
  int currentRound = 1;
  int totalRounds = 5;
  int timeUsage = 150;

  Timer? _timer;

  String get formattedTime {
    int minutes = timeUsage ~/ 60;
    int seconds = timeUsage % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeUsage > 0) {
        timeUsage--;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  void skipRound() {
    currentRound++;
    timeUsage = 150;
    notifyListeners();
  } 

  void leaveGame() {
    _timer?.cancel();
    notifyListeners();
  }

  void onGuess() {
    // guess logic skal her
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}