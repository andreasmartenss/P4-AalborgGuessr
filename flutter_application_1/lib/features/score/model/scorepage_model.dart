import 'package:flutter_application_1/core/services/pocketbase_service.dart'; //Importing the pocketbase service file

//Model that calculates and saves the scores from the games to the databse
class ScorepageModel {
  ///Declaring the pocketbase as a variable
  final pb = PocketBaseService.pb;

  //round tracking
  final List<int> _roundScores = []; ///Creating a list for the roundscores
  List<int> get roundScores => List.unmodifiable(_roundScores); ///A getter that returns the list as unmodifiable so it cant be accessed externally
  int get totalScore => _roundScores.fold(0, (sum, s) => sum + s); ///Calculates the total score from all the rounds

  void addRound(double distanceInMeters, int timeUsage) { /// uses distanceinmeters and timeusage to calculate the score for each round
    final points = calculatePoints(distanceInMeters, timeUsage);
    _roundScores.add(points); ///Adds the points to the roundscores list
  }

  void clearRounds() => _roundScores.clear(); /// Clears all the points from roundscores

  ///Pointcalculation based on distance and time used, if within 5 meters of the geopoint it will grand maxpoints which is 5000
  ///Deducts points based on time used if not within 5 meters
  int calculatePoints(double distanceInMeters, int timeInSeconds) {
    const int maxPoints = 5000;

    if (distanceInMeters <= 5.0) {
      ///The player is within 5 meters anb it reutrns maxpoints
      return maxPoints;
    } else {
      ///If the player isnt within 5 meters it calculates a distance penalty and a time penalty
      int distancePenalty = (distanceInMeters * 5).toInt();
      int timePenalty = timeInSeconds * 2;
      ///Calculates finalscore and deducts the penalties
      int finalScore = maxPoints - distancePenalty - timePenalty;
      ///Returns finalscore, if the score goes below 0 it returns 0
      return finalScore > 0 ? finalScore : 0;
    }
  }

  /// Saves the scores from all the rounds to the database 
  /// If there is less than 5 rounds played it will do nothing
  Future<void> saveGameScore({
    required int round1,
    required int round2,
    required int round3,
    required int round4,
    required int round5,
  }) async {
    /// Calculates the total roundscore
    final int totalScore = round1 + round2 + round3 + round4 + round5;

    try {
      /// Creates a record in the database that stores the roundscores and the total score
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
      print('Error when saving score: $e');
    }
  }
   
}