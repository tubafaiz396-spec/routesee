import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

import '../models/location_model.dart';

class RemoteConfigService {
  static const campusLocationsKey = 'camp_locations';

  Future<List<CampusLocation>?> fetchCampusLocations() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );

      await remoteConfig.fetchAndActivate();
      final value = remoteConfig.getString(campusLocationsKey).trim();
      if (value.isEmpty) {
        return null;
      }

      final decoded = jsonDecode(value);
      final locations =
          decoded is Map<String, dynamic> ? decoded['locations'] : decoded;
      if (locations is! List) {
        return null;
      }

      final parsedLocations = locations
          .whereType<Map<String, dynamic>>()
          .map(CampusLocation.fromJson)
          .toList();
      return parsedLocations.isEmpty ? null : parsedLocations;
    } catch (error) {
      debugPrint('Unable to load campus locations from Remote Config: $error');
      return null;
    }
  }
}
