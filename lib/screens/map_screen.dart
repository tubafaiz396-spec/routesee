import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:latlong2/latlong.dart' as latlng;
import 'package:provider/provider.dart';
import '../data/campus_data.dart';
import '../models/location_model.dart';
import '../providers/location_provider.dart';
import '../providers/navigation_provider.dart';
import '../widgets/location_card.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  gmaps.GoogleMapController? _mapController;
  late gmaps.LatLng _currentCenter;
  double _zoomLevel = 16.0;
  CampusLocation? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _currentCenter = _toGoogleLatLng(CampusData.campusCenter);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestCurrentLocation();
    });
  }

  Future<void> _requestCurrentLocation() async {
    final navProvider = context.read<NavigationProvider>();
    final success = await navProvider.getCurrentLocationFromGPS();

    if (success && navProvider.currentLocation != null) {
      _centerMap(_toGoogleLatLng(navProvider.currentLocation!));
    }
  }

  void _centerMap(gmaps.LatLng target) {
    _mapController?.animateCamera(
      gmaps.CameraUpdate.newCameraPosition(
        gmaps.CameraPosition(target: target, zoom: _zoomLevel),
      ),
    );

    setState(() {
      _currentCenter = target;
    });
  }

  void _changeZoom(double delta) {
    final newZoom = (_zoomLevel + delta).clamp(3.0, 20.0);
    setState(() {
      _zoomLevel = newZoom;
    });

    _mapController?.animateCamera(
      gmaps.CameraUpdate.newLatLngZoom(_currentCenter, newZoom),
    );
  }

  gmaps.LatLng _toGoogleLatLng(latlng.LatLng source) {
    return gmaps.LatLng(source.latitude, source.longitude);
  }

  latlng.LatLng _toLatLng(gmaps.LatLng source) {
    return latlng.LatLng(source.latitude, source.longitude);
  }

  latlng.LatLng _projectPointOnSegment(
    latlng.LatLng start,
    latlng.LatLng end,
    latlng.LatLng point,
  ) {
    final dx = end.longitude - start.longitude;
    final dy = end.latitude - start.latitude;
    final lengthSquared = dx * dx + dy * dy;

    if (lengthSquared == 0) {
      return start;
    }

    final t = (((point.longitude - start.longitude) * dx) +
            ((point.latitude - start.latitude) * dy)) /
        lengthSquared;
    final clampedT = t.clamp(0.0, 1.0);

    return latlng.LatLng(
      start.latitude + dy * clampedT,
      start.longitude + dx * clampedT,
    );
  }

  Set<gmaps.Marker> _buildMarkers(
    List<CampusLocation> locations,
    latlng.LatLng? currentLocation,
    CampusLocation? destination,
  ) {
    final markers = <gmaps.Marker>{};

    for (final location in locations) {
      final isDestination = destination?.id == location.id;

      markers.add(
        gmaps.Marker(
          markerId: gmaps.MarkerId(location.id),
          position: _toGoogleLatLng(location.coordinates),
          icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(
            isDestination
                ? gmaps.BitmapDescriptor.hueRed
                : _getMarkerHue(location.category),
          ),
          infoWindow: gmaps.InfoWindow(
            title: location.name,
            snippet: location.buildingCode,
          ),
          onTap: () => _onMarkerTap(location),
        ),
      );
    }

    if (currentLocation != null) {
      markers.add(
        gmaps.Marker(
          markerId: const gmaps.MarkerId('current_location'),
          position: _toGoogleLatLng(currentLocation),
          icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(
            gmaps.BitmapDescriptor.hueAzure,
          ),
          infoWindow: const gmaps.InfoWindow(title: 'You are here'),
        ),
      );
    }

    return markers;
  }

  double _getMarkerHue(LocationCategory category) {
    switch (category) {
      case LocationCategory.academic:
        return gmaps.BitmapDescriptor.hueBlue;
      case LocationCategory.administrative:
        return gmaps.BitmapDescriptor.hueViolet;
      case LocationCategory.library:
        return gmaps.BitmapDescriptor.hueYellow;
      case LocationCategory.cafeteria:
        return gmaps.BitmapDescriptor.hueOrange;
      case LocationCategory.sports:
        return gmaps.BitmapDescriptor.hueGreen;
      case LocationCategory.hostel:
        return gmaps.BitmapDescriptor.hueAzure;
      case LocationCategory.lab:
        return gmaps.BitmapDescriptor.hueCyan;
      case LocationCategory.auditorium:
        return gmaps.BitmapDescriptor.hueRose;
      case LocationCategory.other:
        return gmaps.BitmapDescriptor.hueMagenta;
    }
  }

  Set<gmaps.Polyline> _buildPolylines(
    NavigationProvider navProvider,
    Color color,
  ) {
    final currentLocation = navProvider.currentLocation;
    final destination = navProvider.destination;
    final routeStart = navProvider.navigationStart;

    if (currentLocation == null || destination == null) {
      return {};
    }

    if (!navProvider.isNavigating || routeStart == null) {
      return {
        gmaps.Polyline(
          polylineId: const gmaps.PolylineId('route'),
          points: [
            _toGoogleLatLng(currentLocation),
            _toGoogleLatLng(destination.coordinates),
          ],
          color: color,
          width: 5,
        ),
      };
    }

    final projectedPoint = _projectPointOnSegment(
      _toLatLng(_toGoogleLatLng(routeStart)),
      _toLatLng(_toGoogleLatLng(destination.coordinates)),
      _toLatLng(_toGoogleLatLng(currentLocation)),
    );

    return {
      gmaps.Polyline(
        polylineId: const gmaps.PolylineId('route_traveled'),
        points: [
          _toGoogleLatLng(routeStart),
          gmaps.LatLng(projectedPoint.latitude, projectedPoint.longitude),
        ],
        color: Colors.black26,
        width: 5,
      ),
      gmaps.Polyline(
        polylineId: const gmaps.PolylineId('route_remaining'),
        points: [
          gmaps.LatLng(projectedPoint.latitude, projectedPoint.longitude),
          _toGoogleLatLng(destination.coordinates),
        ],
        color: color,
        width: 5,
      ),
    };
  }

  void _onMarkerTap(CampusLocation location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  Widget _buildDestinationCard(
    CampusLocation destination,
    NavigationProvider navProvider,
    Color accentColor,
  ) {
    final currentLocation = navProvider.currentLocation;
    final distanceMeters = navProvider.isNavigating
        ? navProvider.remainingDistanceMeters
        : currentLocation != null
            ? navProvider.calculateDistance(
                currentLocation,
                destination.coordinates,
              )
            : null;
    final distance = distanceMeters != null
        ? navProvider.formatDistance(distanceMeters)
        : null;
    final estimatedTime = distanceMeters != null
        ? navProvider.getEstimatedTime(distanceMeters)
        : null;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        destination.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        destination.category.displayName,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    context.read<NavigationProvider>().stopNavigation();
                  },
                ),
              ],
            ),
            if (distance != null && estimatedTime != null) ...[
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Icon(Icons.straighten, color: accentColor),
                      const SizedBox(height: 4),
                      Text(
                        distance,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.access_time, color: Colors.green),
                      const SizedBox(height: 4),
                      Text(
                        estimatedTime,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Map'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              final navProvider = context.read<NavigationProvider>();
              final current = navProvider.currentLocation;
              if (current != null) {
                _centerMap(_toGoogleLatLng(current));
              } else {
                _requestCurrentLocation();
              }
            },
          ),
        ],
      ),
      body: Consumer2<LocationProvider, NavigationProvider>(
        builder: (context, locationProvider, navProvider, child) {
          final destination = navProvider.destination;
          final markers = _buildMarkers(
            locationProvider.allLocations,
            navProvider.currentLocation,
            destination,
          );
          final polylineColor = Theme.of(context).colorScheme.primary;

          return Stack(
            children: [
              gmaps.GoogleMap(
                initialCameraPosition: gmaps.CameraPosition(
                  target: _currentCenter,
                  zoom: _zoomLevel,
                ),
                markers: markers,
                polylines: _buildPolylines(navProvider, polylineColor),
                onMapCreated: (controller) {
                  _mapController = controller;

                  if (navProvider.currentLocation != null) {
                    _centerMap(_toGoogleLatLng(navProvider.currentLocation!));
                  }
                },
                onCameraMove: (position) {
                  _currentCenter = position.target;
                  _zoomLevel = position.zoom;
                },
                zoomControlsEnabled: false,
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
                buildingsEnabled: true,
                indoorViewEnabled: true,
                padding: const EdgeInsets.only(bottom: 200),
              ),
              Positioned(
                right: 16,
                bottom: destination != null ? 200 : 120,
                child: Column(
                  children: [
                    FloatingActionButton(
                      mini: true,
                      heroTag: 'zoom_in',
                      onPressed: () => _changeZoom(1),
                      child: const Icon(Icons.add),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton(
                      mini: true,
                      heroTag: 'zoom_out',
                      onPressed: () => _changeZoom(-1),
                      child: const Icon(Icons.remove),
                    ),
                  ],
                ),
              ),
              if (destination != null)
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: _buildDestinationCard(
                    destination,
                    navProvider,
                    polylineColor,
                  ),
                ),
              if (_selectedLocation != null)
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedLocation = null;
                      });
                    },
                    child: LocationPopup(
                      location: _selectedLocation!,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
