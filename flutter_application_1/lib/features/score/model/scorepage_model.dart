import 'package:pocketbase/pocketbase.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:flutter_application_1/core/services/pocketbase_service.dart';

class ScorepageModel {

  final pb = PocketBaseService.pb;

  int calculatePoints(double distanceInMeters, int timeInSeconds) {
    const int maxPoints = 5000;

    if (distanceInMeters <= 5.0) {
      return maxPoints;
    } else {
      int distancePenalty = (distanceInMeters * 5).toInt();
      int timePenalty = timeInSeconds * 2;
      int finalScore = maxPoints - distancePenalty - timePenalty;
      return finalScore > 0 ? finalScore : 0;
    }
  }

  Future<void> saveGameScore({
    required int round1,
    required int round2,
    required int round3,
    required int round4,
    required int round5,
  }) async {
    final int totalScore = round1 + round2 + round3 + round4 + round5;

    try {
     await pb.collection('users').create(body: {
        'round_1': round1,
        'round_2': round2,
        'round_3': round3,
        'round_4': round4,
        'round_5': round5,
        'TotalScore': totalScore,
      });
      print('Score gemt! Total: $totalScore');
    } catch (e) {
      print('Fejl ved gemning af score: $e');
    }
  }
}