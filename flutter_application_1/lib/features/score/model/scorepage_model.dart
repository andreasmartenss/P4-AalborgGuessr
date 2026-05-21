import 'package:flutter_application_1/core/services/pocketbase_service.dart';

class ScorepageModel {
  final pb = PocketBaseService.pb;

  // --- NEW: round tracking ---
  final List<int> _roundScores = [];
  List<int> get roundScores => List.unmodifiable(_roundScores);
  int get totalScore => _roundScores.fold(0, (sum, s) => sum + s);

  void addRound(double distanceInMeters, int timeUsage) {
    final points = calculatePoints(distanceInMeters, timeUsage);
    _roundScores.add(points);
  }

  void clearRounds() => _roundScores.clear();
  // --- END NEW ---

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

  // NEW: replaces saveGameScore, saves and then clears the round list
  Future<void> saveAndClear() async {
    if (_roundScores.length < 5) return;

    try {
      final int total = totalScore;
      await pb.collection('user').create(body: {
        'round_1': _roundScores[0],
        'round_2': _roundScores[1],
        'round_3': _roundScores[2],
        'round_4': _roundScores[3],
        'round_5': _roundScores[4],
        'TotalScore': total,
      });
      print('Score gemt! Total: $total');
    } catch (e) {
      print('Fejl ved gemning af score: $e');
    }

    clearRounds();
  }

  // Keep the old method if anything else still calls it
  Future<void> saveGameScore({
    required int round1,
    required int round2,
    required int round3,
    required int round4,
    required int round5,
  }) async {
    final int totalScore = round1 + round2 + round3 + round4 + round5;

    try {
      await pb.collection('user').create(body: {
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