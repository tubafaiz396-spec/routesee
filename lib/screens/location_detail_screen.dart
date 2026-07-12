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
  late TextEditingController _openingHoursController;

  @override
  void initState() {
    super.initState();
    _openingHoursController = TextEditingController(text: widget.location.openingHours ?? '');
  }

  @override
  void dispose() {
    _openingHoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.location.name,
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
              background: widget.location.imageUrl != null &&
                      widget.location.imageUrl!.isNotEmpty
                  ? GestureDetector(
                      onTap: () =>
                          _showFullScreenImage(context, widget.location.imageUrl!),
                      child: Image.network(
                        widget.location.imageUrl!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return _buildCategoryBackground(widget.location.category);
                        },
                      ),
                    )
                  : _buildCategoryBackground(widget.location.category),
            ),
            actions: [
              Consumer<LocationProvider>(
                builder: (context, provider, child) {
                  final isFavorite = provider.isFavorite(widget.location);
                  return IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white,
                    ),
                    onPressed: () {
                      provider.toggleFavorite(widget.location);
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

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(widget.location.category)
                          .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.location.category.displayName,
                      style: TextStyle(
                        color: _getCategoryColor(widget.location.category),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.location.description,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Building Code
                  if (widget.location.buildingCode != null) ...[
                    _buildInfoRow(
                      Icons.business,
                      'Building Code',
                      widget.location.buildingCode!,
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Opening Hours (Editable)
                  if (widget.location.openingHours != null) ...[
                    _buildEditableOpeningHours(),
                    const SizedBox(height: 12),
                  ],

                  // Contact Info
                  if (widget.location.contactInfo != null) ...[
                    _buildInfoRow(
                      Icons.phone,
                      'Contact',
                      widget.location.contactInfo!,
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Floor
                  if (widget.location.floor != null) ...[
                    _buildInfoRow(
                      Icons.layers,
                      'Floor',
                      'Floor ${widget.location.floor}',
                    ),
                    const SizedBox(height: 12),
                  ],

                  const SizedBox(height: 24),

                  // Navigate Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context
                            .read<NavigationProvider>()
                            .startNavigation(widget.location);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MapScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.directions),
                      label: const Text(
                        'Get Directions',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
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
        ],
      ),
    );
  }

  Widget _buildEditableOpeningHours() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            IconButton(
              icon: const Icon(Icons.edit, size: 18),
              onPressed: () => _editOpeningHours(context),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          widget.location.openingHours ?? '',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _editOpeningHours(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Opening Hours'),
        content: TextField(
          controller: _openingHoursController,
          decoration: const InputDecoration(
            labelText: 'Opening Hours',
            hintText: 'e.g., 9:00 AM - 5:00 PM',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final newHours = _openingHoursController.text;
              context.read<LocationProvider>().updateLocationOpeningHours(
                widget.location.id,
                newHours,
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Opening hours updated'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
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
