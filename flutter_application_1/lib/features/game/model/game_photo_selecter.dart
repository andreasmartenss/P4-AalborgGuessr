import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/services/pocketbase_service.dart';
import 'package:flutter_application_1/features/score/view/score_page.dart';
import 'package:flutter_application_1/features/score/model/scorepage_model.dart';
import 'package:pocketbase/pocketbase.dart';
import 'dart:async';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class PhotoPickerModel {
  final List<String> _usedIds = [];

  Future<RecordModel> pickUnseenPhoto() async {
    final countResult = await PocketBaseService.pb
        .collection('photos_and_geopoint')
        .getList(page: 1, perPage: 1);

    final totalItems = countResult.totalItems;

    if (_usedIds.length >= totalItems) _usedIds.clear();

    RecordModel? selected;
    do {
      final randomPage = Random().nextInt(totalItems) + 1;
      final result = await PocketBaseService.pb
          .collection('photos_and_geopoint')
          .getList(page: randomPage, perPage: 1);

      final candidate = result.items.first;
      if (!_usedIds.contains(candidate.id)) selected = candidate;
    } while (selected == null);

    _usedIds.add(selected.id);
    return selected;
  }

  void reset() => _usedIds.clear();
}