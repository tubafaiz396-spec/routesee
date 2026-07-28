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
  final MapScreenController? controller;

  const MapScreen({
    super.key,
    this.controller,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class MapScreenController {
  VoidCallback? _showCampusOverviewHandler;
  VoidCallback? _focusActiveRouteHandler;

  void _bind({
    required VoidCallback onShowCampusOverview,
    required VoidCallback onFocusActiveRoute,
  }) {
    _showCampusOverviewHandler = onShowCampusOverview;
    _focusActiveRouteHandler = onFocusActiveRoute;
  }

  void showCampusOverview() {
    _showCampusOverviewHandler?.call();
  }

  void focusActiveRoute() {
    _focusActiveRouteHandler?.call();
  }
}

class _MapScreenState extends State<MapScreen> {
  gmaps.GoogleMapController? _mapController;
  late gmaps.LatLng _currentCenter;
  double _zoomLevel = 18.0;
  CampusLocation? _selectedLocation;
  String? _lastFocusedRouteKey;
  MapViewMode? _lastAppliedMapViewMode;

  @override
  void initState() {
    super.initState();
    _currentCenter = _toGoogleLatLng(CampusData.campusCenter);
    _bindController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestCurrentLocation();
    });
  }

  @override
  void didUpdateWidget(covariant MapScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _bindController();
    }
  }

  void _bindController() {
    widget.controller?._bind(
      onShowCampusOverview: focusOnCampusOverview,
      onFocusActiveRoute: _focusActiveRoute,
    );
  }

  Future<void> _requestCurrentLocation() async {
    final navProvider = context.read<NavigationProvider>();
    final success = await navProvider.getCurrentLocationFromGPS();

    if (!mounted) {
      return;
    }

    if (success && navProvider.currentLocation != null) {
      final destination = navProvider.destination;
      if (destination != null) {
        _focusOnRoute(navProvider.currentLocation!, destination.coordinates);
      }
    } else if (navProvider.destination != null) {
      _centerMap(_toGoogleLatLng(navProvider.destination!.coordinates));
    }
  }

  void _centerMap(gmaps.LatLng target) {
    final tilt =
        _getTiltForMode(context.read<NavigationProvider>().mapViewMode);
    _mapController?.animateCamera(
      gmaps.CameraUpdate.newCameraPosition(
        gmaps.CameraPosition(target: target, zoom: _zoomLevel, tilt: tilt),
      ),
    );

    setState(() {
      _currentCenter = target;
    });
  }

  void _focusOnRoute(latlng.LatLng from, latlng.LatLng to) {
    final navProvider = context.read<NavigationProvider>();
    final routePoints = navProvider.routePoints.length > 1
        ? navProvider.routePoints.map(_toGoogleLatLng).toList()
        : [_toGoogleLatLng(from), _toGoogleLatLng(to)];

    _fitPoints(routePoints, padding: routePoints.length > 2 ? 56 : 68);
  }

  void _focusActiveRoute() {
    final navProvider = context.read<NavigationProvider>();
    final currentLocation = navProvider.currentLocation;
    final destination = navProvider.destination;

    if (currentLocation == null || destination == null) {
      return;
    }

    _focusOnRoute(currentLocation, destination.coordinates);
  }

  void focusOnCampusOverview() {
    if (!mounted) {
      return;
    }

    setState(() {
      _selectedLocation = null;
      _currentCenter = _toGoogleLatLng(CampusData.campusCenter);
    });

    _fitPoints(
      CampusData.locations
          .map((location) => _toGoogleLatLng(location.coordinates))
          .toList(),
      padding: 70,
    );
  }

  void _fitPoints(
    List<gmaps.LatLng> points, {
    double padding = 70,
  }) {
    if (_mapController == null) {
      if (points.isNotEmpty) {
        _currentCenter = points.first;
      }
      return;
    }

    if (points.isEmpty) {
      _centerMap(_toGoogleLatLng(CampusData.campusCenter));
      return;
    }

    if (points.length == 1) {
      _centerMap(points.first);
      return;
    }

    double? minLatitude;
    double? maxLatitude;
    double? minLongitude;
    double? maxLongitude;

    for (final point in points) {
      minLatitude = minLatitude == null
          ? point.latitude
          : (point.latitude < minLatitude ? point.latitude : minLatitude);
      maxLatitude = maxLatitude == null
          ? point.latitude
          : (point.latitude > maxLatitude ? point.latitude : maxLatitude);
      minLongitude = minLongitude == null
          ? point.longitude
          : (point.longitude < minLongitude ? point.longitude : minLongitude);
      maxLongitude = maxLongitude == null
          ? point.longitude
          : (point.longitude > maxLongitude ? point.longitude : maxLongitude);
    }

    final bounds = gmaps.LatLngBounds(
      southwest: gmaps.LatLng(minLatitude!, minLongitude!),
      northeast: gmaps.LatLng(maxLatitude!, maxLongitude!),
    );

    _mapController!.animateCamera(
      gmaps.CameraUpdate.newLatLngBounds(bounds, padding),
    );

    _currentCenter = gmaps.LatLng(
      (minLatitude + maxLatitude) / 2,
      (minLongitude + maxLongitude) / 2,
    );
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

  double _getTiltForMode(MapViewMode mode) {
    switch (mode) {
      case MapViewMode.normal2d:
        return 0;
      case MapViewMode.buildings3d:
        return 55;
      case MapViewMode.hybrid:
        return 0;
    }
  }

  gmaps.MapType _getMapTypeForMode(MapViewMode mode) {
    switch (mode) {
      case MapViewMode.normal2d:
      case MapViewMode.buildings3d:
        return gmaps.MapType.normal;
      case MapViewMode.hybrid:
        return gmaps.MapType.hybrid;
    }
  }

  void _applyMapViewMode(NavigationProvider navProvider) {
    if (_mapController == null) {
      return;
    }

    if (_lastAppliedMapViewMode == navProvider.mapViewMode) {
      return;
    }

    _lastAppliedMapViewMode = navProvider.mapViewMode;

    _mapController!.animateCamera(
      gmaps.CameraUpdate.newCameraPosition(
        gmaps.CameraPosition(
          target: _currentCenter,
          zoom: _zoomLevel,
          tilt: _getTiltForMode(navProvider.mapViewMode),
        ),
      ),
    );
  }

  Set<gmaps.Marker> _buildMarkers(
    List<CampusLocation> locations,
    latlng.LatLng? currentLocation,
    CampusLocation? destination,
  ) {
    final markers = <gmaps.Marker>{};
    final visibleLocations = destination != null ? [destination] : locations;

    for (final location in visibleLocations) {
      markers.add(
        gmaps.Marker(
          markerId: gmaps.MarkerId(location.id),
          position: _toGoogleLatLng(location.coordinates),
          icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(
            destination?.id == location.id
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

    if (currentLocation == null || destination == null) {
      return {};
    }

    final routePoints = navProvider.routePoints.length > 1
        ? navProvider.routePoints.map(_toGoogleLatLng).toList()
        : [
            _toGoogleLatLng(currentLocation),
            _toGoogleLatLng(destination.coordinates),
          ];

    return {
      gmaps.Polyline(
        polylineId: const gmaps.PolylineId('live_route'),
        points: routePoints,
        color: color,
        width: 6,
        startCap: gmaps.Cap.roundCap,
        endCap: gmaps.Cap.roundCap,
        jointType: gmaps.JointType.round,
      ),
    };
  }

  void _onMarkerTap(CampusLocation location) {
    setState(() {
      _selectedLocation = location;
    });
    _centerMap(_toGoogleLatLng(location.coordinates));
  }

  void _maybeFocusSelectedRoute(NavigationProvider navProvider) {
    final destination = navProvider.destination;
    final currentLocation = navProvider.currentLocation;

    if (_mapController == null) {
      return;
    }

    if (destination == null) {
      _lastFocusedRouteKey = null;
      return;
    }

    if (currentLocation == null) {
      return;
    }

    final routeKey = '${destination.id}:${navProvider.hasResolvedRoute}';
    if (_lastFocusedRouteKey == routeKey) {
      return;
    }

    _lastFocusedRouteKey = routeKey;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _focusOnRoute(currentLocation, destination.coordinates);
    });
  }

  Widget _buildDestinationCard(
    CampusLocation destination,
    NavigationProvider navProvider,
    Color accentColor,
  ) {
    final currentLocation = navProvider.currentLocation;
    final isActiveDestination = navProvider.destination?.id == destination.id;
    final distanceMeters = isActiveDestination
        ? (navProvider.routeDistanceMeters ??
            (currentLocation != null
                ? navProvider.calculateDistance(
                    currentLocation,
                    destination.coordinates,
                  )
                : null))
        : (currentLocation != null
            ? navProvider.calculateDistance(
                currentLocation,
                destination.coordinates,
              )
            : null);
    final distance = distanceMeters != null
        ? navProvider.formatDistance(distanceMeters)
        : null;
    final estimatedTime = isActiveDestination
        ? (navProvider.routeDuration != null
            ? navProvider.formatDuration(navProvider.routeDuration!)
            : (distanceMeters != null
                ? navProvider.getEstimatedTime(distanceMeters)
                : null))
        : (distanceMeters != null
            ? navProvider.getEstimatedTime(distanceMeters)
            : null);

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
            if (navProvider.isLoadingRoute) ...[
              const SizedBox(height: 12),
              const LinearProgressIndicator(minHeight: 3),
            ] else if (navProvider.routeError != null) ...[
              const SizedBox(height: 10),
              Text(
                navProvider.routeError!,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.orange[800],
                ),
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
            tooltip: 'Show all departments',
            icon: const Icon(Icons.apartment),
            onPressed: focusOnCampusOverview,
          ),
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () async {
              final navProvider = context.read<NavigationProvider>();
              final current = navProvider.currentLocation;
              if (current != null) {
                _centerMap(_toGoogleLatLng(current));
              } else {
                await _requestCurrentLocation();
                if (!mounted ||
                    context.read<NavigationProvider>().currentLocation !=
                        null) {
                  return;
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Unable to get your live location.'),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Consumer2<LocationProvider, NavigationProvider>(
        builder: (context, locationProvider, navProvider, child) {
          _maybeFocusSelectedRoute(navProvider);
          _applyMapViewMode(navProvider);
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
                  tilt: _getTiltForMode(navProvider.mapViewMode),
                ),
                mapType: _getMapTypeForMode(navProvider.mapViewMode),
                markers: markers,
                polylines: _buildPolylines(navProvider, polylineColor),
                onMapCreated: (controller) {
                  _mapController = controller;
                  _lastAppliedMapViewMode = navProvider.mapViewMode;

                  if (navProvider.currentLocation != null) {
                    if (destination != null) {
                      _focusActiveRoute();
                    } else {
                      focusOnCampusOverview();
                    }
                  } else if (destination != null) {
                    _centerMap(_toGoogleLatLng(destination.coordinates));
                  } else {
                    focusOnCampusOverview();
                  }
                },
                onTap: (_) {
                  setState(() {
                    _selectedLocation = null;
                  });
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
                tiltGesturesEnabled:
                    navProvider.mapViewMode == MapViewMode.buildings3d,
                padding: const EdgeInsets.only(bottom: 200),
              ),
              Positioned(
                right: 16,
                bottom: destination != null ? 200 : 120,
                child: Column(
                  children: [
                    FloatingActionButton(
                      mini: true,
                      heroTag: 'show_overview',
                      tooltip: 'Show all departments',
                      onPressed: focusOnCampusOverview,
                      child: const Icon(Icons.center_focus_strong),
                    ),
                    if (destination != null) ...[
                      const SizedBox(height: 8),
                      FloatingActionButton(
                        mini: true,
                        heroTag: 'focus_route',
                        tooltip: 'Focus current route',
                        onPressed: _focusActiveRoute,
                        child: const Icon(Icons.alt_route),
                      ),
                    ],
                    const SizedBox(height: 8),
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
              if (_selectedLocation != null && destination == null)
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
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      child: LocationPopup(
                        key: ValueKey(_selectedLocation!.id),
                        location: _selectedLocation!,
                      ),
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
