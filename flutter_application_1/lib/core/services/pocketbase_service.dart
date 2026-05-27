import "dart:async";
import 'package:pocketbase/pocketbase.dart';

/// Service class which is responsible for all communication with the PocketBase database
///
/// Only one connection to the database is created ([static]), and reused everywhere in the app
class PocketBaseService {

  /// The connection to the PocketBase database
  /// [static] means only ONE exists for the whole app, instead of a new one being created each time
  static final PocketBase pb = PocketBase('http://130.225.39.250:8090');

  /// Fetches the highest TotalScore from the 'user' collection.
  ///
  /// Sorts users by [TotalScore] in descending order and returns only the top 1.
  /// Returns 0 if no users exist yet or the score field is null.
  Future<int> getHighScore() async {
    // Fetch only 1 record, sorted by TotalScore highest-first (the '-' prefix means descending).
    final records = await pb
        .collection('user')
        .getList(sort: '-TotalScore', perPage: 1);

    if (records.items.isNotEmpty) {
      // Use ?? to safely fall back to 0 if TotalScore is null in the database.
      return records.items.first.data['TotalScore'] ?? 0;
    }
    return 0;
  }
}