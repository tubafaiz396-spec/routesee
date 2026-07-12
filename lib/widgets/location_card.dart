import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/location_model.dart';
import '../providers/location_provider.dart';
import '../providers/navigation_provider.dart';

class LocationCard extends StatelessWidget {
  final CampusLocation location;
  final VoidCallback onTap;

  const LocationCard({
    super.key,
    required this.location,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Image or Icon/Category indicator
              location.imageUrl != null && location.imageUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        location.imageUrl!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildCategoryIcon(location.category),
                      ),
                    )
                  : _buildCategoryIcon(location.category),
              const SizedBox(width: 12),

              // Location info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      location.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(location.category)
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            location.category.displayName,
                            style: TextStyle(
                              fontSize: 11,
                              color: _getCategoryColor(location.category),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (location.buildingCode != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            location.buildingCode!,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Favorite button
              Consumer<LocationProvider>(
                builder: (context, provider, child) {
                  final isFavorite = provider.isFavorite(location);
                  return IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      provider.toggleFavorite(location);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(LocationCategory category) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: _getCategoryColor(category).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          category.icon,
          style: const TextStyle(fontSize: 30),
        ),
      ),
    );
  }

  Color _getCategoryColor(LocationCategory category) {
    switch (category) {
      case LocationCategory.academic:
        return Colors.blue;
      case LocationCategory.administrative:
        return Colors.purple;
      case LocationCategory.library:
        return Colors.brown;
      case LocationCategory.cafeteria:
        return Colors.orange;
      case LocationCategory.sports:
        return Colors.green;
      case LocationCategory.hostel:
        return Colors.indigo;
      case LocationCategory.lab:
        return Colors.teal;
      case LocationCategory.auditorium:
        return Colors.red;
      case LocationCategory.other:
        return Colors.grey;
    }
  }
}

class LocationPopup extends StatelessWidget {
  final CampusLocation location;

  const LocationPopup({
    super.key,
    required this.location,
  });

  Color _getCategoryColor(LocationCategory category) {
    switch (category) {
      case LocationCategory.academic:
        return Colors.blue;
      case LocationCategory.administrative:
        return Colors.purple;
      case LocationCategory.library:
        return Colors.brown;
      case LocationCategory.cafeteria:
        return Colors.orange;
      case LocationCategory.sports:
        return Colors.green;
      case LocationCategory.hostel:
        return Colors.indigo;
      case LocationCategory.lab:
        return Colors.teal;
      case LocationCategory.auditorium:
        return Colors.red;
      case LocationCategory.other:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final navProvider = context.read<NavigationProvider>();
    final currentLocation = navProvider.currentLocation;
    String? distanceText;
    String? timeText;

    if (currentLocation != null) {
      final distanceMeters = navProvider.calculateDistance(
        currentLocation,
        location.coordinates,
      );
      distanceText = navProvider.formatDistance(distanceMeters);
      timeText = navProvider.getEstimatedTime(distanceMeters);
    }

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                location.imageUrl != null && location.imageUrl!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          location.imageUrl!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildCategoryIcon(location.category),
                        ),
                      )
                    : _buildCategoryIcon(location.category),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(location.category)
                              .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          location.category.displayName,
                          style: TextStyle(
                            fontSize: 10,
                            color: _getCategoryColor(location.category),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (distanceText != null && timeText != null) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.straighten, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Distance: $distanceText',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 12),
                  Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Est. time: $timeText',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 8),
            Text(
              location.description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(LocationCategory category) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: _getCategoryColor(category).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          category.icon,
          style: const TextStyle(fontSize: 28),
        ),
      ),
    );
  }
}