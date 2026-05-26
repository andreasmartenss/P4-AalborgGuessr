import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_application_1/features/game/viewmodel/game_page_vm.dart';

/// This ViewModel is responsible for handling map-related logic using OpenStreetMap (OSM)
class OsmLocationVm {

  /// Controller that communicates with the OSM map widget
  /// Marked as [late] because it is initialized AFTER the map widget is ready
  late MapController mapController;

  /// Adds markers on the map, and draws a line between the user and the picture location
  ///
  /// [gamePageVM] is used to retrieve the target location
  Future<void> addMarker(GamePageVM gamePageVM) async {

    // Small delay to ensure the map is fully loaded before interacting with it
    // Without this, map operations may fail silently
    await Future.delayed(const Duration(milliseconds: 500));

    // Uses the location from the game state, or fall back to default coordinate (Aalborg, Denmark) if no location is set yet
    final pictureLocation =
        gamePageVM.location ?? GeoPoint(latitude: 57.0488, longitude: 9.9217);

    // Places a red flag marker at the pictures location on the map
    await mapController.addMarker(
      pictureLocation,
      markerIcon: MarkerIcon(
        icon: Icon(
          Icons.flag,
          size: 80,
          color: const Color.fromARGB(255, 199, 1, 1),
        ),
      ),
    );

    // Tries to get the users current GPS location and draw a line to the target
    // Wrapped in try/catch because location access can fail (e.g. if permission is denied)
    try {
      // Fetches the users current position from the map controller
      final userLocation = await mapController.myLocation();

      // Draws a black line between the user and the picture location
      // [zoomInto: true] automatically adjusts the map zoom to fit both points
      await mapController.drawRoadManually([
        userLocation,
        pictureLocation,
      ], RoadOption(roadColor: Colors.black, roadWidth: 5, zoomInto: true));

      // Places a red pin marker at the users current location
      await mapController.addMarker(
        userLocation,
        markerIcon: MarkerIcon(
          icon: Icon(
            Icons.place,
            size: 80,
            color: const Color.fromARGB(255, 199, 1, 1),
          ),
        ),
      );
    } catch (e) {
      // If anything above fails, it logs the error instead of crashing the app
      print('Kunne ikke tegne linje: $e');
    }
  }
}
