import "dart:async";
import 'package:pocketbase/pocketbase.dart';

/// Service class which is responsible for all communication with the PocketBase database
///
/// Only one connection to the database is created ([static]), and reused everywhere in the app
class PocketBaseService {

  /// The connection to the PocketBase database
  /// [static] means only ONE exists for the whole app, instead of a new one being created each time
  static final PocketBase pb = PocketBase('http://130.225.39.250:8090');

  // BRUGER VI FETCHDATA TIL NOGET?? BLEV FORVIRRET FORDI THUMB OG 0x0 ER LIDT MODSIGENDE SÅ SPURGTE CLAUDE OG DEN SIGER AT:
  // "The actual fetching of photos for the game is entirely handled by PhotoPickerModel.pickUnseenPhoto(), which uses PocketBaseService.pb directly to query the photos_and_geopoint collection. fetchData() is completely separate from this and only ever printed to the console. It plays no role in the app whatsoever."
  Future<void> fetchData() async {

    final records = await pb.collection('photos_and_geopoint').getFullList();

    for (final record in records) {
      final imageFile = record.data['photos'];
      final imageUrl =
          'http://130.225.39.250:8090/api/files/${record.collectionId}/${record.id}/$imageFile?thumb=0x0'; //Thumb bruges til at konvertere billedet til en mindre størrelse, hvilket gør det hurtigere at hente og vise i appen

      print(imageUrl); // Paste this URL in a browser to verify the image loads
      print(record.data); // Prints the full record data for inspection
    }
  }

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

  /// Kan dette ikke slettes? Det har måske været til at teste fetchData?
  void main() {
    fetchData();
  }
}