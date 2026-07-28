import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/location_model.dart';
import '../providers/location_provider.dart';
import '../providers/navigation_provider.dart';
import 'map_screen.dart';

class LocationDetailScreen extends StatefulWidget {
  final CampusLocation location;

  const LocationDetailScreen({
    super.key,
    required this.location,
  });

  @override
  State<LocationDetailScreen> createState() => _LocationDetailScreenState();
}

class _LocationDetailScreenState extends State<LocationDetailScreen> {
  bool _isStartingNavigation = false;

  @override
  Widget build(BuildContext context) {
    final location = context.select<LocationProvider, CampusLocation?>(
          (provider) => provider.getLocationById(widget.location.id),
        ) ??
        widget.location;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                location.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3.0,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
              background: location.imageUrl != null &&
                      location.imageUrl!.isNotEmpty
                  ? GestureDetector(
                      onTap: () =>
                          _showFullScreenImage(context, location.imageUrl!),
                      child: Hero(
                        tag: 'location-media-${location.id}',
                        child: Image.network(
                          location.imageUrl!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return _buildCategoryBackground(location.category);
                          },
                        ),
                      ),
                    )
                  : _buildCategoryBackground(location.category),
            ),
            actions: [
              Consumer<LocationProvider>(
                builder: (context, provider, child) {
                  final isFavorite = provider.isFavorite(location);
                  return IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white,
                    ),
                    onPressed: () async {
                      await provider.toggleFavorite(location);
                      if (!context.mounted) {
                        return;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isFavorite
                                ? 'Removed from favorites'
                                : 'Added to favorites',
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 10 * (1 - value)),
                  child: Opacity(opacity: value, child: child),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(location.category)
                            .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        location.category.displayName,
                        style: TextStyle(
                          color: _getCategoryColor(location.category),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      location.description,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (location.buildingCode != null) ...[
                      _buildInfoRow(
                        Icons.business,
                        'Building Code',
                        location.buildingCode!,
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (location.openingHours != null) ...[
                      _buildOpeningHours(location),
                      const SizedBox(height: 12),
                    ],
                    if (location.contactInfo != null) ...[
                      _buildInfoRow(
                        Icons.phone,
                        'Contact',
                        location.contactInfo!,
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (location.floor != null) ...[
                      _buildInfoRow(
                        Icons.layers,
                        'Floor',
                        'Floor ${location.floor}',
                      ),
                      const SizedBox(height: 12),
                    ],
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _isStartingNavigation
                            ? null
                            : () => _handleGetDirections(location),
                        icon: _isStartingNavigation
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Icon(Icons.directions),
                        label: Text(
                          _isStartingNavigation
                              ? 'Starting navigation...'
                              : 'Get Directions',
                          style: const TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleGetDirections(CampusLocation location) async {
    setState(() {
      _isStartingNavigation = true;
    });

    final navProvider = context.read<NavigationProvider>();
    final hasLocation = await navProvider.startNavigation(location);

    if (!mounted) {
      return;
    }

    setState(() {
      _isStartingNavigation = false;
    });

    if (!hasLocation) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Location access is needed to show your position and route line.',
          ),
          duration: Duration(seconds: 2),
        ),
      );
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MapScreen(),
      ),
    );
  }

  Widget _buildOpeningHours(CampusLocation location) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.access_time, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 12),
            Text(
              'Opening Hours',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: Text(
            location.openingHours ?? '',
            key: ValueKey(location.openingHours),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
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

  Widget _buildCategoryBackground(LocationCategory category) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _getCategoryColor(category),
            _getCategoryColor(category).withValues(alpha: 0.7),
          ],
        ),
      ),
      child: Center(
        child: Text(
          category.icon,
          style: const TextStyle(fontSize: 80),
        ),
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          body: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Center(
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
