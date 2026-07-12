# Campus Navigator App - Implementation Guide

## Overview
A modern, feature-rich Campus Navigator App built with Flutter following the latest standards and best practices.

## Architecture

### Clean Architecture with Feature-Based Structure
```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   └── location_model.dart   # Location and Category models
├── data/                     # Static data and repositories
│   └── campus_data.dart      # Campus locations data
├── providers/                # State management (Provider pattern)
│   ├── location_provider.dart
│   └── navigation_provider.dart
├── screens/                  # UI screens
│   ├── home_screen.dart
│   ├── map_screen.dart
│   ├── location_detail_screen.dart
│   ├── favorites_screen.dart
│   └── settings_screen.dart
└── widgets/                  # Reusable widgets
    ├── category_card.dart
    └── location_card.dart
```

## Features

### 1. Home Screen
- **Search Functionality**: Search for buildings, labs, and facilities
- **Category Filtering**: Browse locations by category (Academic, Library, Cafeteria, etc.)
- **Location Cards**: Beautiful cards showing location details
- **Quick Access**: Tap any location to view details

### 2. Interactive Map
- **Google Maps Integration**: Uses google_maps_flutter for map display and navigation polyline overlays
- **Location Markers**: All campus locations marked on the map
- **Current Location**: Shows user's current GPS location
- **Zoom Controls**: Zoom in/out functionality
- **Destination Selection**: Tap markers to select destinations
- **Distance & Time**: Shows estimated distance and travel time

### 3. Location Details
- **Comprehensive Information**: 
  - Description
  - Building code
  - Opening hours
  - Contact information
  - Floor number
  - Available facilities
- **Category Badge**: Visual category indicator
- **Favorite Toggle**: Add/remove from favorites
- **Get Directions**: Navigate to location on map

### 4. Favorites
- **Persistent Storage**: Favorites saved using SharedPreferences
- **Quick Access**: Easy access to frequently visited locations
- **Empty State**: Helpful message when no favorites

### 5. Settings
- **Navigation Mode Selection**:
  - Walking (5 km/h)
  - Cycling (15 km/h)
  - Driving (30 km/h)
- **About Information**: App details and features
- **Privacy Policy**: Privacy information
- **Data Management**: Clear favorites option

## Technology Stack

### Dependencies
```yaml
# State Management
provider: ^6.1.2

# Map & Location
google_maps_flutter: ^2.4.0
latlong2: ^0.9.1
geolocator: ^13.0.2
permission_handler: ^11.3.1

# HTTP & API
http: ^1.2.2

# UI Components
google_fonts: ^6.2.1

# Storage
shared_preferences: ^2.3.3
```

## Data Models

### LocationCategory Enum
- Academic
- Administrative
- Library
- Cafeteria
- Sports
- Hostel
- Lab
- Auditorium
- Other

### CampusLocation Model
```dart
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
}
```

## Static Data

The app includes comprehensive static data for:
- 20+ campus locations
- Multiple categories
- Detailed facility information
- Contact details and opening hours

### Sample Locations
1. Main Academic Block
2. CSIT Block
3. Civil Engineering Block
4. Santosh Anand Central Library
5. Main Canteen
6. Sports Complex
7. Hostels (Boys A, B, Girls)
8. Computer Labs (Param, Aryabhatt)
9. Main Auditorium
10. Medical Center
... and more

## State Management

### LocationProvider
Manages:
- All locations
- Filtered locations
- Favorite locations
- Selected location
- Search query
- Category filter

### NavigationProvider
Manages:
- Current location (GPS)
- Destination
- Navigation mode
- Distance calculation
- Time estimation

## UI/UX Features

### Material Design 3
- Uses Material 3 design system
- Custom color scheme based on teal
- Consistent card design
- Smooth animations

### Google Fonts
- Uses Inter font family for modern typography

### Responsive Design
- Adapts to different screen sizes
- Proper spacing and padding
- Scrollable content

### Navigation
- Bottom Navigation Bar with 4 tabs:
  1. Home
  2. Map
  3. Favorites
  4. Settings
- IndexedStack for efficient screen switching

## Permissions

### Required Permissions
- **Location**: For showing user's current position on map
- Handled gracefully with permission_handler package

## How to Run

### Prerequisites
- Flutter SDK (3.6.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Device or Emulator

### Steps
1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to launch the app

### Platform Support
- ✅ Android
- ✅ iOS
- ✅ Windows
- ✅ macOS
- ✅ Linux
- ✅ Web

## Customization

### Adding New Locations
Edit `lib/data/campus_data.dart`:
```dart
CampusLocation(
  id: 'unique_id',
  name: 'Location Name',
  description: 'Description',
  coordinates: LatLng(latitude, longitude),
  category: LocationCategory.academic,
  facilities: ['Facility 1', 'Facility 2'],
  openingHours: '9:00 AM - 5:00 PM',
  contactInfo: '+91-1234567890',
  buildingCode: 'CODE',
),
```

### Changing Campus Center
Edit `lib/data/campus_data.dart`:
```dart
static const LatLng campusCenter = LatLng(your_lat, your_lng);
```

### Customizing Theme
Edit `lib/main.dart`:
```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: Colors.yourColor,
  brightness: Brightness.light,
),
```

## Best Practices Followed

1. **Clean Architecture**: Separation of concerns
2. **Provider Pattern**: Efficient state management
3. **Immutable Models**: Using copyWith pattern
4. **Null Safety**: Full null safety support
5. **Error Handling**: Proper try-catch blocks
6. **Code Organization**: Feature-based structure
7. **Reusable Widgets**: DRY principle
8. **Responsive Design**: Adaptive layouts
9. **Performance**: Efficient rendering with IndexedStack
10. **User Experience**: Loading states, empty states, error messages

## Future Enhancements

Potential features to add:
1. **Real-time Navigation**: Turn-by-turn directions
2. **Indoor Maps**: Floor plans for buildings
3. **Events Integration**: Campus events on map
4. **AR Navigation**: Augmented reality directions
5. **Offline Mode**: Cached maps for offline use
6. **Multi-language Support**: Internationalization
7. **Dark Theme**: Dark mode support
8. **Accessibility**: Screen reader support
9. **Analytics**: Usage tracking
10. **Push Notifications**: Event reminders

## Troubleshooting

### Common Issues

1. **Map not loading**
   - Check internet connection
   - Verify google_maps_flutter dependency

2. **Location permission denied**
   - Grant location permission in device settings
   - Check permission_handler configuration

3. **Build errors**
   - Run `flutter clean`
   - Run `flutter pub get`
   - Restart IDE

## Contributing

To contribute:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is open source and available under the MIT License.

## Support

For issues or questions:
- Create an issue on GitHub
- Contact the development team

---

**Built with ❤️ using Flutter**
