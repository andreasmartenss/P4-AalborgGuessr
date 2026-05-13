import 'dart:math';
import 'package:flutter_application_1/core/services/pocketbase_service.dart';
import 'package:pocketbase/pocketbase.dart';
import 'dart:async';

// This is the model that randomizes the pictures in the game view page.
class PhotoPickerModel {
  // Attribute that stotres the photo ID's in an array of strings.
  final List<String> _usedIds = [];

// This promise takes the data stored in the pocketbase, and implements the randomizer based on the photo ID.
  Future<RecordModel> pickUnseenPhoto() async {
    final countResult = await PocketBaseService.pb
        .collection('photos_and_geopoint')
        .getList(page: 1, perPage: 1);

    // Total set of pictures with their coordinates.
    final totalItems = countResult.totalItems;

    /**
     * An if statement, that states if the used photoID is bigger or equal to the photo ID that has already been used,  
     * then it must clear the list.
     */
    if (_usedIds.length >= totalItems) {
      _usedIds.clear();
    }
 
   // The record that is made into a null if nothing else is declared.
    RecordModel? selected;

    /**
     * this is a do-while loop, that parses the list of photos into integers, and then dart math to randomize.
     * the selected photo in the list.
     */
    do {
      final randomPage = Random().nextInt(totalItems) + 1;
      final result = await PocketBaseService.pb
          .collection('photos_and_geopoint')
          .getList(page: randomPage, perPage: 1);

      final candidate = result.items.first;

      // if-statement that states, if the used photos are not contained in the unsued photo, then it will select the new photo.
      if (!_usedIds.contains(candidate.id)) {
        selected = candidate;
      }
    // the loop will stop if the selected photo is equal to null.
    } while (selected == null);
    // thien it will add the selected photo and add it to the array of used photos, and thus return the selected photo.
    _usedIds.add(selected.id);
    return selected;
  }
  // An arrrow-function that will clear the list of used photo when the game has ended.
  void reset() => _usedIds.clear();
}