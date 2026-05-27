import 'package:flutter_application_1/core/services/pocketbase_service.dart';
import 'package:flutter/material.dart';


// ViewModel for the Home screen, responsible for managing the state and business logic related to the high score
// Extends ChangeNotifier to allow the UI to listen for changes and update accordingly
class HomeViewModel extends ChangeNotifier {

  // Backend service for fetching the high score from the PocketBase backend
  final PocketBaseService _service;
  
  // Variable to hold the total score, initialized to 0
  // Fetches from the backend when the ViewModel is created
  int totalScore = 0;

  // Constructor that triggers a highscore fetch so the UI has fresh data as soon as the ViewModel is instantiated
  HomeViewModel(this._service) {
    loadHighScore();
  }

  // Fetches the highscore from the backend service and updates the totalScore variable, then notifies listeners to update the UI
  // async/await is used to handle the asynchronous nature of the data fetching from the backend
  // notifyListeners() is called after the score is updated to ensure that any UI components listening to this ViewModel will rebuild with the new data
  Future<void> loadHighScore() async {
    totalScore = await _service.getHighScore();
    notifyListeners();
  }
}