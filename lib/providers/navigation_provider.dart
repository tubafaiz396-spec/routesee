import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/location_model.dart';
import '../services/route_service.dart';

enum NavigationMode {
  walking,
  driving,
  cycling,
}

enum MapViewMode {
  normal2d,
  buildings3d,
  hybrid,
}

class NavigationProvider with ChangeNotifier {
  static const String _mapViewModeKey = 'map_view_mode';
  static const double _routeRefreshDistanceMeters = 8;
  static const Duration _routeRefreshInterval = Duration(seconds: 3);

  final RouteService _routeService = RouteService();
  LatLng? _currentLocation;
  CampusLocation? _destination;
  LatLng? _navigationStart;
  NavigationMode _navigationMode = NavigationMode.walking;
  MapViewMode _mapViewMode = MapViewMode.normal2d;
  bool _isNavigating = false;
  bool _isLoadingLocation = false;
  bool _isLoadingRoute = false;
  double _remainingDistanceMeters = 0;
  double? _routeDistanceMeters;
  Duration? _routeDuration;
  List<LatLng> _routePoints = [];
  String? _routeError;
  LatLng? _lastRouteOrigin;
  String? _lastRouteDestinationId;
  DateTime? _lastRouteRefreshAt;
  bool _isRefreshingRoute = false;
  int _routeRequestId = 0;
  StreamSubscription<Position>? _positionSubscription;

  NavigationProvider() {
    _loadPreferences();
  }

  LatLng? get currentLocation => _currentLocation;
  CampusLocation? get destination => _destination;
  LatLng? get navigationStart => _navigationStart;
  NavigationMode get navigationMode => _navigationMode;
  MapViewMode get mapViewMode => _mapViewMode;
  bool get isNavigating => _isNavigating;
  bool get isLoadingLocation => _isLoadingLocation;
  bool get isLoadingRoute => _isLoadingRoute;
  double get remainingDistanceMeters => _remainingDistanceMeters;
  double? get routeDistanceMeters => _routeDistanceMeters;
  Duration? get routeDuration => _routeDuration;
  List<LatLng> get routePoints => List.unmodifiable(_routePoints);
  String? get routeError => _routeError;
  bool get hasResolvedRoute => _routePoints.length > 2;

  void setCurrentLocation(LatLng location) {
    _currentLocation = location;
    if (_isNavigating) {
      _updateRemainingDistance();
      unawaited(_refreshRouteIfNeeded());
    }
    notifyListeners();
  }

  void setDestination(CampusLocation? location) {
    _destination = location;
    if (_isNavigating) {
      _navigationStart ??= _currentLocation;
      _updateRemainingDistance();
    }
    notifyListeners();
  }

  Future<void> setNavigationMode(NavigationMode mode) async {
    _navigationMode = NavigationMode.walking;
    notifyListeners();
    if (_isNavigating) {
      unawaited(_refreshRoute(force: true));
    }
  }

  Future<void> setMapViewMode(MapViewMode mode) async {
    _mapViewMode = mode;
    notifyListeners();
    await _saveMapViewMode();
  }

  Future<bool> startNavigation(CampusLocation destination) async {
    _destination = destination;
    _isNavigating = true;
    _routeError = null;
    final hasLocation =
        _currentLocation != null || await getCurrentLocationFromGPS();
    _navigationStart = _currentLocation;
    _startLocationTracking();
    await _refreshRoute(force: true);
    _updateRemainingDistance();
    notifyListeners();
    return hasLocation;
  }

  void stopNavigation() {
    _destination = null;
    _isNavigating = false;
    _navigationStart = null;
    _remainingDistanceMeters = 0;
    _clearRouteState();
    _stopLocationTracking();
    notifyListeners();
  }

  Future<bool> getCurrentLocationFromGPS() async {
    _isLoadingLocation = true;
    notifyListeners();

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _isLoadingLocation = false;
          notifyListeners();
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _isLoadingLocation = false;
        notifyListeners();
        return false;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      _currentLocation = LatLng(position.latitude, position.longitude);
      if (_isNavigating) {
        _updateRemainingDistance();
        unawaited(_refreshRoute(force: true));
      }
      _isLoadingLocation = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error getting location: $e');
      _isLoadingLocation = false;
      notifyListeners();
      return false;
    }
  }

  void _startLocationTracking() {
    _stopLocationTracking();

    try {
      final settings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 3,
      );

      _positionSubscription = Geolocator.getPositionStream(
        locationSettings: settings,
      ).listen(
        (position) {
          _currentLocation = LatLng(position.latitude, position.longitude);
          if (_isNavigating) {
            _updateRemainingDistance();
            unawaited(_refreshRouteIfNeeded());
          }
          notifyListeners();
        },
        onError: (error) {
          debugPrint('Location tracking error: $error');
        },
      );
    } catch (e) {
      debugPrint('Unable to start location tracking: $e');
    }
  }

  void _stopLocationTracking() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  void _updateRemainingDistance() {
    final current = _currentLocation;
    final destination = _destination;
    if (current == null || destination == null) {
      _remainingDistanceMeters = 0;
      return;
    }

    _remainingDistanceMeters = _routeDistanceMeters ??
        calculateDistance(current, destination.coordinates);
  }

  Future<void> _refreshRouteIfNeeded() async {
    final current = _currentLocation;
    final destination = _destination;
    if (!_isNavigating || current == null || destination == null) {
      return;
    }

    if (_isRefreshingRoute) {
      return;
    }

    final isDestinationChanged = _lastRouteDestinationId != destination.id;
    final movedEnough = _lastRouteOrigin == null ||
        calculateDistance(current, _lastRouteOrigin!) >=
            _routeRefreshDistanceMeters;
    final waitedEnough = _lastRouteRefreshAt == null ||
        DateTime.now().difference(_lastRouteRefreshAt!) >=
            _routeRefreshInterval;
    final hasNoRoute = _routePoints.length < 2;

    if (isDestinationChanged || hasNoRoute || (movedEnough && waitedEnough)) {
      await _refreshRoute(force: isDestinationChanged || hasNoRoute);
    }
  }

  Future<void> _refreshRoute({bool force = false}) async {
    final current = _currentLocation;
    final destination = _destination;
    if (!_isNavigating || current == null || destination == null) {
      return;
    }

    if (_isRefreshingRoute) {
      return;
    }

    final requestId = ++_routeRequestId;
    _isRefreshingRoute = true;
    _isLoadingRoute = force || _routePoints.isEmpty;
    notifyListeners();

    try {
      final route = await _routeService.fetchRoute(
        from: current,
        to: destination.coordinates,
        profile: _profileForNavigationMode(),
      );

      if (requestId != _routeRequestId || _destination?.id != destination.id) {
        return;
      }

      if (route == null) {
        _setFallbackRoute(current, destination.coordinates);
        _routeError = 'Unable to load the routed path right now.';
      } else {
        _routePoints = route.points;
        _routeDistanceMeters = route.distanceMeters;
        _routeDuration = route.duration;
        _routeError = null;
      }
    } catch (e) {
      debugPrint('Error fetching route: $e');
      _setFallbackRoute(current, destination.coordinates);
      _routeError = 'Unable to load the routed path right now.';
    } finally {
      if (requestId == _routeRequestId && _destination?.id == destination.id) {
        _lastRouteOrigin = current;
        _lastRouteDestinationId = destination.id;
        _lastRouteRefreshAt = DateTime.now();
        _updateRemainingDistance();
      }
      _isRefreshingRoute = false;
      _isLoadingRoute = false;
      notifyListeners();
    }
  }

  void _setFallbackRoute(LatLng from, LatLng to) {
    _routePoints = [from, to];
    _routeDistanceMeters = calculateDistance(from, to);
    _routeDuration = null;
  }

  void _clearRouteState() {
    _routeRequestId++;
    _routePoints = [];
    _routeDistanceMeters = null;
    _routeDuration = null;
    _routeError = null;
    _lastRouteOrigin = null;
    _lastRouteDestinationId = null;
    _lastRouteRefreshAt = null;
    _isRefreshingRoute = false;
    _isLoadingRoute = false;
  }

  String _profileForNavigationMode() {
    switch (_navigationMode) {
      case NavigationMode.walking:
        return 'walking';
      case NavigationMode.cycling:
        return 'cycling';
      case NavigationMode.driving:
        return 'driving';
    }
  }

  double calculateDistance(LatLng from, LatLng to) {
    return Geolocator.distanceBetween(
      from.latitude,
      from.longitude,
      to.latitude,
      to.longitude,
    );
  }

  String getEstimatedTime(double distanceInMeters) {
    double speedKmh;

    switch (_navigationMode) {
      case NavigationMode.walking:
        speedKmh = 5.0;
        break;
      case NavigationMode.cycling:
        speedKmh = 15.0;
        break;
      case NavigationMode.driving:
        speedKmh = 30.0;
        break;
    }

    final distanceKm = distanceInMeters / 1000;
    final timeHours = distanceKm / speedKmh;
    final timeMinutes = (timeHours * 60).round();

    if (timeMinutes < 1) {
      return '< 1 min';
    } else if (timeMinutes < 60) {
      return '$timeMinutes min';
    } else {
      final hours = timeMinutes ~/ 60;
      final mins = timeMinutes % 60;
      return '$hours h $mins min';
    }
  }

  String formatDuration(Duration duration) {
    final totalMinutes = duration.inMinutes;

    if (totalMinutes < 1) {
      return '< 1 min';
    }

    if (totalMinutes < 60) {
      return '$totalMinutes min';
    }

    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    return '$hours h $minutes min';
  }

  String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()} m';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(2)} km';
    }
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final mapViewModeIndex = prefs.getInt(_mapViewModeKey);
      await prefs.remove('navigation_mode');

      if (mapViewModeIndex != null &&
          mapViewModeIndex >= 0 &&
          mapViewModeIndex < MapViewMode.values.length) {
        _mapViewMode = MapViewMode.values[mapViewModeIndex];
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading navigation preferences: $e');
    }
  }

  Future<void> _saveMapViewMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_mapViewModeKey, _mapViewMode.index);
    } catch (e) {
      debugPrint('Error saving map view mode: $e');
    }
  }

  @override
  void dispose() {
    _stopLocationTracking();
    super.dispose();
  }
}
