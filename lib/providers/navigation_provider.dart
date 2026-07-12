import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../models/location_model.dart';

enum NavigationMode {
  walking,
  driving,
  cycling,
}

class NavigationProvider with ChangeNotifier {
  LatLng? _currentLocation;
  CampusLocation? _destination;
  LatLng? _navigationStart;
  NavigationMode _navigationMode = NavigationMode.walking;
  bool _isNavigating = false;
  bool _isLoadingLocation = false;
  double _remainingDistanceMeters = 0;
  StreamSubscription<Position>? _positionSubscription;

  // Getters
  LatLng? get currentLocation => _currentLocation;
  CampusLocation? get destination => _destination;
  LatLng? get navigationStart => _navigationStart;
  NavigationMode get navigationMode => _navigationMode;
  bool get isNavigating => _isNavigating;
  bool get isLoadingLocation => _isLoadingLocation;
  double get remainingDistanceMeters => _remainingDistanceMeters;

  // Set current location
  void setCurrentLocation(LatLng location) {
    _currentLocation = location;
    if (_isNavigating) {
      _updateRemainingDistance();
    }
    notifyListeners();
  }

  // Set destination
  void setDestination(CampusLocation? location) {
    _destination = location;
    if (_isNavigating) {
      _navigationStart ??= _currentLocation;
      _updateRemainingDistance();
    }
    notifyListeners();
  }

  // Set navigation mode
  void setNavigationMode(NavigationMode mode) {
    _navigationMode = mode;
    notifyListeners();
  }

  // Start navigation
  void startNavigation(CampusLocation destination) {
    _destination = destination;
    _isNavigating = true;
    _navigationStart = _currentLocation;
    _startLocationTracking();
    _updateRemainingDistance();
    notifyListeners();
  }

  // Stop navigation
  void stopNavigation() {
    _destination = null;
    _isNavigating = false;
    _navigationStart = null;
    _remainingDistanceMeters = 0;
    _stopLocationTracking();
    notifyListeners();
  }

  // Get current location from GPS
  Future<bool> getCurrentLocationFromGPS() async {
    _isLoadingLocation = true;
    notifyListeners();

    try {
      // Check permissions
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

      // Get position
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      _currentLocation = LatLng(position.latitude, position.longitude);
      if (_isNavigating) {
        _updateRemainingDistance();
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
      ).listen((position) {
        _currentLocation = LatLng(position.latitude, position.longitude);
        if (_isNavigating) {
          _updateRemainingDistance();
        }
        notifyListeners();
      }, onError: (error) {
        debugPrint('Location tracking error: $error');
      });
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

    _remainingDistanceMeters = calculateDistance(current, destination.coordinates);
  }

  // Calculate distance between two points
  double calculateDistance(LatLng from, LatLng to) {
    return Geolocator.distanceBetween(
      from.latitude,
      from.longitude,
      to.latitude,
      to.longitude,
    );
  }

  // Get estimated time based on mode and distance
  String getEstimatedTime(double distanceInMeters) {
    double speedKmh;
    
    switch (_navigationMode) {
      case NavigationMode.walking:
        speedKmh = 5.0; // Average walking speed
        break;
      case NavigationMode.cycling:
        speedKmh = 15.0; // Average cycling speed
        break;
      case NavigationMode.driving:
        speedKmh = 30.0; // Average driving speed on campus
        break;
    }

    double distanceKm = distanceInMeters / 1000;
    double timeHours = distanceKm / speedKmh;
    int timeMinutes = (timeHours * 60).round();

    if (timeMinutes < 1) {
      return '< 1 min';
    } else if (timeMinutes < 60) {
      return '$timeMinutes min';
    } else {
      int hours = timeMinutes ~/ 60;
      int mins = timeMinutes % 60;
      return '$hours h $mins min';
    }
  }

  // Format distance
  String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()} m';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(2)} km';
    }
  }

  @override
  void dispose() {
    _stopLocationTracking();
    super.dispose();
  }
}
