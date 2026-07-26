import 'package:latlong2/latlong.dart';

enum LocationCategory {
  academic,
  administrative,
  library,
  cafeteria,
  sports,
  hostel,
  lab,
  auditorium,
  other,
}

class CampusLocation {
  final String id;
  final String name;
  final String description;
  final LatLng coordinates;
  final LocationCategory category;
  final String? imageUrl;
  final List<String> facilities;
  final String? openingHours;
  final String? contactInfo;
  final int? floor;
  final String? buildingCode;

  CampusLocation({
    required this.id,
    required this.name,
    required this.description,
    required this.coordinates,
    required this.category,
    this.imageUrl,
    this.facilities = const [],
    this.openingHours,
    this.contactInfo,
    this.floor,
    this.buildingCode,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'latitude': coordinates.latitude,
      'longitude': coordinates.longitude,
      'category': category.toString(),
      'imageUrl': imageUrl,
      'facilities': facilities,
      'openingHours': openingHours,
      'contactInfo': contactInfo,
      'floor': floor,
      'buildingCode': buildingCode,
    };
  }

  // Create from JSON
  factory CampusLocation.fromJson(Map<String, dynamic> json) {
    return CampusLocation(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      coordinates: LatLng(
        (json['latitude'] as num).toDouble(),
        (json['longitude'] as num).toDouble(),
      ),
      category: LocationCategory.values.firstWhere(
        (e) => e.toString() == json['category'],
        orElse: () => LocationCategory.other,
      ),
      imageUrl: json['imageUrl'],
      facilities: List<String>.from(json['facilities'] ?? []),
      openingHours: json['openingHours'],
      contactInfo: json['contactInfo'],
      floor: json['floor'],
      buildingCode: json['buildingCode'],
    );
  }

  // Copy with method for immutability
  CampusLocation copyWith({
    String? id,
    String? name,
    String? description,
    LatLng? coordinates,
    LocationCategory? category,
    String? imageUrl,
    List<String>? facilities,
    String? openingHours,
    String? contactInfo,
    int? floor,
    String? buildingCode,
  }) {
    return CampusLocation(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      coordinates: coordinates ?? this.coordinates,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      facilities: facilities ?? this.facilities,
      openingHours: openingHours ?? this.openingHours,
      contactInfo: contactInfo ?? this.contactInfo,
      floor: floor ?? this.floor,
      buildingCode: buildingCode ?? this.buildingCode,
    );
  }
}

// Helper extension for category
extension LocationCategoryExtension on LocationCategory {
  String get displayName {
    switch (this) {
      case LocationCategory.academic:
        return 'Academic';
      case LocationCategory.administrative:
        return 'Administrative';
      case LocationCategory.library:
        return 'Library';
      case LocationCategory.cafeteria:
        return 'Cafeteria';
      case LocationCategory.sports:
        return 'Sports';
      case LocationCategory.hostel:
        return 'Hostel';
      case LocationCategory.lab:
        return 'Lab';
      case LocationCategory.auditorium:
        return 'Auditorium';
      case LocationCategory.other:
        return 'Other';
    }
  }

  String get icon {
    switch (this) {
      case LocationCategory.academic:
        return '🎓';
      case LocationCategory.administrative:
        return '🏢';
      case LocationCategory.library:
        return '📚';
      case LocationCategory.cafeteria:
        return '🍽️';
      case LocationCategory.sports:
        return '⚽';
      case LocationCategory.hostel:
        return '🏠';
      case LocationCategory.lab:
        return '🔬';
      case LocationCategory.auditorium:
        return '🎭';
      case LocationCategory.other:
        return '📍';
    }
  }
}
