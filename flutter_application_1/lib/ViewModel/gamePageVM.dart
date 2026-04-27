import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/View/scorePage.dart';
import 'package:pocketbase/pocketbase.dart';
import 'dart:async';
import 'database.dart';

class GamePageVM extends ChangeNotifier {
  int score = 0;
  int currentRound = 1;
  int totalRounds = 5;
  int timeUsage = 0;

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

  Future<void> getPicture() async {
  final records = await pb.collection('photos_and_geopoint').getFullList();
  records.shuffle();
  pictures = records.first;
  notifyListeners();
}

  Future<void> startRound() async {
    timeUsage = 0;
    _timer?.cancel();
    startTimer();
    await getPicture();
    notifyListeners();
  }

  bool navigateToScore = false;

  Future<void> nextRound() async {
    if (currentRound < totalRounds) {
      currentRound++;
      startRound();
    } else {
      currentRound++;
      _timer?.cancel();
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
    if (currentRound < totalRounds) {
      currentRound++;
    } else {
      currentRound++;
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