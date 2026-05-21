import 'dart:math';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';



class GeoModel {
  /// This model is the model that calculaes the distance from the player to the selected photo 
  /// using the Haversine equation. 
  double calculateDistance(GeoPoint correct, GeoPoint guessed) {

    /// Variable the sets the earths radious in meters as a constant.
    const double earthRadius = 6371000;

    /// Converting the degrees of latitude of the picture (lat2) and the players location(lat2) into radians.
    final double lat1 = correct.latitude * (pi / 180);
    final double lat2 = guessed.latitude * (pi / 180);

    /// Calculate the disance between the player and the picture
    final double dLat = (guessed.latitude - correct.latitude) * (pi / 180);
    final double dLon = (guessed.longitude - correct.longitude) * (pi / 180);


    /**
     * This is were the Haversine equation is implemented. 
     * The variable calculates the difference in latitude and longitude,
     * converted to radians, to determine the central angle between two coordinates on the Earth's surface.
     * 
     * Using the Haversine formula is appropriate when calculating the distance in a sphere, and takes the 
     * difference between latittude and longtitude in to account.
     */
    final double haversineTheta = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    
    /// Calculating the angle between the two points
    final double calculatePoints = 2 * atan2(sqrt(haversineTheta), sqrt(1 - haversineTheta));

    /// Returns the distance in meters by multiplying the earths radius in meters and the angle of the pictures.
    return earthRadius * calculatePoints;
  }
}