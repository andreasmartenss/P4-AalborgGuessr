import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/services/pocketbase_service.dart';
import 'package:flutter_application_1/features/score/view/score_page.dart';
import 'package:flutter_application_1/features/score/model/scorepage_model.dart';
import 'package:pocketbase/pocketbase.dart';
import 'dart:async';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class GeoModel {
  double calculateDistance(GeoPoint correct, GeoPoint guessed) {
    const double earthRadius = 6371000;
    final double lat1 = correct.latitude * (pi / 180);
    final double lat2 = guessed.latitude * (pi / 180);
    final double dLat = (guessed.latitude - correct.latitude) * (pi / 180);
    final double dLon = (guessed.longitude - correct.longitude) * (pi / 180);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }
}