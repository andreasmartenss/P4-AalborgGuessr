// ignore_for_file: unnecessary_lambdas

import "dart:async";
import 'package:pocketbase/pocketbase.dart';

final pb = PocketBase('http://130.225.39.250');

Future<void> fetchData() async {
  final records = await pb.collection('photos_and_geopoint').getFullList();
  
  for (final record in records) {
    print(record.id);
    print(record.data); // all fields
  }
}

void main() {
  fetchData();
}
