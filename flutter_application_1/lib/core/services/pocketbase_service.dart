import "dart:async";
import 'package:pocketbase/pocketbase.dart';


class PocketBaseService {
  static final PocketBase pb = PocketBase(
    'http://130.225.39.250',
  );


  Future<void> fetchData() async {
    final records = await pb.collection('photos_and_geopoint').getFullList();
    
    for (final record in records) {
      final imageFile = record.data['photos'];
      final imageUrl = 'http://130.225.39.250/api/files/${record.collectionId}/${record.id}/$imageFile?thumb=0x0'; //Thumb bruges til at konvertere billedet til en mindre størrelse, hvilket gør det hurtigere at hente og vise i appen
      print(imageUrl); // paste this URL in a browser to verify it loads
      print(record.data);
    }
  }

  void main() {
    fetchData();
    }
}
