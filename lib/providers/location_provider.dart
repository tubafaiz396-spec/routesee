import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/location_model.dart';
import '../services/remote_config_service.dart';

class LocationProvider with ChangeNotifier {
  List<CampusLocation> _allLocations = [];
  List<CampusLocation> _filteredLocations = [];
  List<CampusLocation> _favoriteLocations = [];
  CampusLocation? _selectedLocation;
  LocationCategory? _selectedCategory;
  String _searchQuery = '';
  bool _isLoading = true;
  String? _loadError;
  late final Future<void> _initialization;
  final RemoteConfigService _remoteConfigService = RemoteConfigService();

  // Getters
  List<CampusLocation> get allLocations => _allLocations;
  List<CampusLocation> get filteredLocations => _filteredLocations;
  List<CampusLocation> get favoriteLocations => _favoriteLocations;
  CampusLocation? get selectedLocation => _selectedLocation;
  LocationCategory? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String? get loadError => _loadError;
  Future<void> get initialization => _initialization;

  LocationProvider() {
    _initialization = _bootstrap();
  }

  Future<void> _bootstrap() async {
    _isLoading = true;
    _loadError = null;
    notifyListeners();

    try {
      await _loadLocations();
      await _loadFavorites();
      _refreshFilteredLocations();
    } catch (e) {
      _loadError = 'Unable to load campus data. Please check your internet connection.';
      debugPrint('Error bootstrapping location provider: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadLocations() async {
    final remoteLocations = await _remoteConfigService.fetchCampusLocations();
    if (remoteLocations == null) {
      throw StateError('Remote Config returned no campus locations.');
    }

    _allLocations = remoteLocations;
    await _applyCustomOpeningHours();
    _syncFavoritesWithLocations();
    _refreshFilteredLocations();
  }

  Future<void> _applyCustomOpeningHours() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      for (int i = 0; i < _allLocations.length; i++) {
        final customHours =
            prefs.getString('opening_hours_${_allLocations[i].id}');
        if (customHours != null) {
          _allLocations[i] =
              _allLocations[i].copyWith(openingHours: customHours);
        }
      }
    } catch (e) {
      debugPrint('Error loading custom opening hours: $e');
    }
  }

  // Load favorites from SharedPreferences
  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteIds = prefs.getStringList('favorite_locations') ?? [];

      _favoriteLocations =
          _allLocations.where((loc) => favoriteIds.contains(loc.id)).toList();

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }

  // Save favorites to SharedPreferences
  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteIds = _favoriteLocations.map((loc) => loc.id).toList();
      await prefs.setStringList('favorite_locations', favoriteIds);
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }

  // Clear all favorites
  Future<void> clearAllFavorites() async {
    _favoriteLocations = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('favorite_locations');
    notifyListeners();
  }

  // Update location opening hours
  Future<void> updateLocationOpeningHours(
      String locationId, String openingHours) async {
    final index = _allLocations.indexWhere((loc) => loc.id == locationId);
    if (index != -1) {
      _allLocations[index] =
          _allLocations[index].copyWith(openingHours: openingHours);
      final favIndex =
          _favoriteLocations.indexWhere((loc) => loc.id == locationId);
      if (favIndex != -1) {
        _favoriteLocations[favIndex] =
            _favoriteLocations[favIndex].copyWith(openingHours: openingHours);
      }

      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('opening_hours_$locationId', openingHours);
      } catch (e) {
        debugPrint('Error saving opening hours: $e');
      }

      notifyListeners();
    }
  }

  // Toggle favorite status
  Future<void> toggleFavorite(CampusLocation location) async {
    final isFavorite = _favoriteLocations.any((loc) => loc.id == location.id);

    if (isFavorite) {
      _favoriteLocations.removeWhere((loc) => loc.id == location.id);
    } else {
      _favoriteLocations.add(location);
    }

    await _saveFavorites();
    notifyListeners();
  }

  // Check if location is favorite
  bool isFavorite(CampusLocation location) {
    return _favoriteLocations.any((loc) => loc.id == location.id);
  }

  // Set selected location
  void setSelectedLocation(CampusLocation? location) {
    _selectedLocation = location;
    notifyListeners();
  }

  // Search locations
  void searchLocations(String query) {
    _searchQuery = query;
    _refreshFilteredLocations();
    notifyListeners();
  }

  // Filter by category
  void filterByCategory(LocationCategory? category) {
    _selectedCategory = category;
    _refreshFilteredLocations();
    notifyListeners();
  }

  // Clear filters
  void clearFilters() {
    _selectedCategory = null;
    _searchQuery = '';
    _refreshFilteredLocations();
    notifyListeners();
  }

  // Get locations by category
  List<CampusLocation> getLocationsByCategory(LocationCategory category) {
    return _allLocations
        .where((location) => location.category == category)
        .toList();
  }

  // Get category counts
  Map<LocationCategory, int> getCategoryCounts() {
    return {
      for (final category in LocationCategory.values)
        category: _allLocations
            .where((location) => location.category == category)
            .length,
    };
  }

  // Get location by ID
  CampusLocation? getLocationById(String id) {
    for (final location in _allLocations) {
      if (location.id == id) {
        return location;
      }
    }
    return null;
  }

  void _syncFavoritesWithLocations() {
    final favoriteIds =
        _favoriteLocations.map((location) => location.id).toSet();
    _favoriteLocations = _allLocations
        .where((location) => favoriteIds.contains(location.id))
        .toList();
  }

  void _refreshFilteredLocations() {
    Iterable<CampusLocation> locations = _allLocations;

    if (_selectedCategory != null) {
      locations = locations.where(
        (location) => location.category == _selectedCategory,
      );
    }

    final query = _searchQuery.trim().toLowerCase();
    if (query.isNotEmpty) {
      locations = locations.where(
        (location) =>
            location.name.toLowerCase().contains(query) ||
            location.description.toLowerCase().contains(query) ||
            (location.buildingCode?.toLowerCase().contains(query) ?? false) ||
            location.facilities.any(
              (facility) => facility.toLowerCase().contains(query),
            ),
      );
    }

    _filteredLocations = locations.toList();
  }
}
