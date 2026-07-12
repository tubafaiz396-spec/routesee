import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/location_model.dart';
import '../data/campus_data.dart';

class LocationProvider with ChangeNotifier {
  List<CampusLocation> _allLocations = [];
  List<CampusLocation> _filteredLocations = [];
  List<CampusLocation> _favoriteLocations = [];
  CampusLocation? _selectedLocation;
  LocationCategory? _selectedCategory;
  String _searchQuery = '';

  // Getters
  List<CampusLocation> get allLocations => _allLocations;
  List<CampusLocation> get filteredLocations => _filteredLocations;
  List<CampusLocation> get favoriteLocations => _favoriteLocations;
  CampusLocation? get selectedLocation => _selectedLocation;
  LocationCategory? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  LocationProvider() {
    _loadLocations();
    _loadFavorites();
  }

  // Load all locations from static data and SharedPreferences
  Future<void> _loadLocations() async {
    _allLocations = List.from(CampusData.locations);
    try {
      final prefs = await SharedPreferences.getInstance();
      for (int i = 0; i < _allLocations.length; i++) {
        final customHours =
            prefs.getString('opening_hours_${_allLocations[i].id}');
        if (customHours != null) {
          _allLocations[i] =
              _allLocations[i].copyWith(openingHours: customHours);
          final campusIndex = CampusData.locations
              .indexWhere((loc) => loc.id == _allLocations[i].id);
          if (campusIndex != -1) {
            CampusData.locations[campusIndex] = _allLocations[i];
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading custom opening hours: $e');
    }
    _filteredLocations = _allLocations;
    notifyListeners();
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

      final campusIndex =
          CampusData.locations.indexWhere((loc) => loc.id == locationId);
      if (campusIndex != -1) {
        CampusData.locations[campusIndex] = _allLocations[index];
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

    if (query.isEmpty) {
      if (_selectedCategory != null) {
        _filteredLocations =
            CampusData.getLocationsByCategory(_selectedCategory!);
      } else {
        _filteredLocations = _allLocations;
      }
    } else {
      final searchResults = CampusData.searchLocations(query);

      if (_selectedCategory != null) {
        _filteredLocations = searchResults
            .where((loc) => loc.category == _selectedCategory)
            .toList();
      } else {
        _filteredLocations = searchResults;
      }
    }

    notifyListeners();
  }

  // Filter by category
  void filterByCategory(LocationCategory? category) {
    _selectedCategory = category;

    if (category == null) {
      if (_searchQuery.isEmpty) {
        _filteredLocations = _allLocations;
      } else {
        _filteredLocations = CampusData.searchLocations(_searchQuery);
      }
    } else {
      final categoryLocations = CampusData.getLocationsByCategory(category);

      if (_searchQuery.isEmpty) {
        _filteredLocations = categoryLocations;
      } else {
        _filteredLocations = categoryLocations
            .where((loc) =>
                loc.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                loc.description
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()))
            .toList();
      }
    }

    notifyListeners();
  }

  // Clear filters
  void clearFilters() {
    _selectedCategory = null;
    _searchQuery = '';
    _filteredLocations = _allLocations;
    notifyListeners();
  }

  // Get locations by category
  List<CampusLocation> getLocationsByCategory(LocationCategory category) {
    return CampusData.getLocationsByCategory(category);
  }

  // Get category counts
  Map<LocationCategory, int> getCategoryCounts() {
    return CampusData.getCategoryCounts();
  }

  // Get location by ID
  CampusLocation? getLocationById(String id) {
    return CampusData.getLocationById(id);
  }
}
