import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GpsLocationVM extends ChangeNotifier {
  Position? currentPosition;
  String? errorMessage;
  bool isLoading = false;

  Future<void> fetchLocation() async {
    isLoading = true;
    notifyListeners();

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        errorMessage = 'Location services are disabled.';
        isLoading = false;
        notifyListeners();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          errorMessage = 'Location permissions are denied.';
          isLoading = false;
          notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        errorMessage = 'Location permissions are permanently denied.';
        isLoading = false;
        notifyListeners();
        return;
      }

      currentPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}