import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_application_1/features/game/viewmodel/game_page_vm.dart';

class OsmLocationVm {
  late MapController mapController;

  Future<void> addMarker(GamePageVM gamePageVM) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final pictureLocation =
        gamePageVM.location ?? GeoPoint(latitude: 57.0488, longitude: 9.9217);

    await mapController.addMarker(
      pictureLocation,
      markerIcon: MarkerIcon(
        icon: Icon(Icons.flag, size: 80, color: const Color.fromARGB(255, 199, 1, 1)),
      ),
    );

    try {
      final userLocation = await mapController.myLocation();
      gamePageVM.setGuessLocation(userLocation);
      await mapController.drawRoadManually([
        userLocation,
        pictureLocation,
      ], RoadOption(roadColor: Colors.black, roadWidth: 5, zoomInto: true));
      await mapController.addMarker(
        userLocation,
        markerIcon: MarkerIcon(
          icon: Icon(Icons.place, size: 80, color: const Color.fromARGB(255, 199, 1, 1)),
        ),
      );
    } catch (e) {
      print('Kunne ikke tegne linje: $e');
    }
  }
}