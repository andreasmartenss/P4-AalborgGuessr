import 'package:flutter_application_1/core/services/pocketbase_service.dart';
import 'package:flutter/material.dart';


class HomeViewModel extends ChangeNotifier {
  final PocketBaseService _service;
  
  int totalScore = 0;

  HomeViewModel(this._service) {
    loadHighScore();
  }

  Future<void> loadHighScore() async {
    totalScore = await _service.getHighScore();
    notifyListeners();
  }
}