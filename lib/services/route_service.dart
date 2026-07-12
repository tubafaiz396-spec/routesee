import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class CampusRoute {
  final List<LatLng> points;
  final double distanceMeters;
  final Duration duration;

  const CampusRoute({
    required this.points,
    required this.distanceMeters,
    required this.duration,
  });
}

class RouteService {
  static const _host = 'router.project-osrm.org';

  Future<CampusRoute?> fetchRoute({
    required LatLng from,
    required LatLng to,
    required String profile,
  }) async {
    final uri = Uri.https(
      _host,
      '/route/v1/$profile/'
      '${from.longitude},${from.latitude};'
      '${to.longitude},${to.latitude}',
      const {
        'overview': 'full',
        'geometries': 'geojson',
        'steps': 'false',
      },
    );

    final response = await http.get(uri).timeout(const Duration(seconds: 8));
    if (response.statusCode != 200) {
      return null;
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    if (decoded['code'] != 'Ok') {
      return null;
    }

    final routes = decoded['routes'];
    if (routes is! List || routes.isEmpty) {
      return null;
    }

    final firstRoute = routes.first;
    if (firstRoute is! Map<String, dynamic>) {
      return null;
    }

    final geometry = firstRoute['geometry'];
    if (geometry is! Map<String, dynamic>) {
      return null;
    }

    final coordinates = geometry['coordinates'];
    if (coordinates is! List || coordinates.length < 2) {
      return null;
    }

    final points = <LatLng>[];
    for (final coordinate in coordinates) {
      if (coordinate is! List || coordinate.length < 2) {
        continue;
      }

      final longitude = coordinate[0];
      final latitude = coordinate[1];
      if (longitude is! num || latitude is! num) {
        continue;
      }

      points.add(LatLng(latitude.toDouble(), longitude.toDouble()));
    }

    if (points.length < 2) {
      return null;
    }

    final distance = firstRoute['distance'];
    final duration = firstRoute['duration'];

    return CampusRoute(
      points: points,
      distanceMeters: distance is num ? distance.toDouble() : 0,
      duration: Duration(
        seconds: duration is num ? duration.round() : 0,
      ),
    );
  }
}
