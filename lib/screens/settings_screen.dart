import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/location_provider.dart';
import '../providers/navigation_provider.dart' as nav;

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Theme.of(context).colorScheme.primary,
              title: const Text(
                'Settings',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Map View',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Consumer<nav.NavigationProvider>(
                        builder: (context, navProvider, child) {
                          return Column(
                            children: [
                              _MapViewModeTile(
                                title: '2D Map',
                                subtitle: 'Classic top-down campus map',
                                icon: Icons.map_outlined,
                                isSelected: navProvider.mapViewMode ==
                                    nav.MapViewMode.normal2d,
                                onTap: () => navProvider.setMapViewMode(
                                  nav.MapViewMode.normal2d,
                                ),
                              ),
                              const Divider(height: 1),
                              _MapViewModeTile(
                                title: '3D Buildings',
                                subtitle: 'Tilted normal map with buildings',
                                icon: Icons.location_city_outlined,
                                isSelected: navProvider.mapViewMode ==
                                    nav.MapViewMode.buildings3d,
                                onTap: () => navProvider.setMapViewMode(
                                  nav.MapViewMode.buildings3d,
                                ),
                              ),
                              const Divider(height: 1),
                              _MapViewModeTile(
                                title: 'Hybrid',
                                subtitle: 'Satellite imagery with roads',
                                icon: Icons.satellite_alt_outlined,
                                isSelected: navProvider.mapViewMode ==
                                    nav.MapViewMode.hybrid,
                                onTap: () => navProvider.setMapViewMode(
                                  nav.MapViewMode.hybrid,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'About',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Column(
                        children: [
                          const ListTile(
                            leading: Icon(Icons.info_outline),
                            title: Text('Version'),
                            subtitle: Text('1.0.0'),
                          ),
                          const Divider(height: 1),
                          ListTile(
                            leading: const Icon(Icons.description_outlined),
                            title: const Text('About RouteSee'),
                            onTap: () {
                              _showAboutDialog(context);
                            },
                          ),
                          const Divider(height: 1),
                          ListTile(
                            leading: const Icon(Icons.privacy_tip_outlined),
                            title: const Text('Privacy Policy'),
                            onTap: () {
                              _showPrivacyDialog(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Data',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: ListTile(
                        leading:
                            const Icon(Icons.delete_outline, color: Colors.red),
                        title: const Text(
                          'Clear Favorites',
                          style: TextStyle(color: Colors.red),
                        ),
                        onTap: () {
                          _showClearFavoritesDialog(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About RouteSee'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'RouteSee is a comprehensive navigation app designed to help students, faculty, and visitors find their way around campus.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),
              Text(
                'Features:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Interactive campus map'),
              Text('• Search for buildings and facilities'),
              Text('• Browse locations by category'),
              Text('• Detailed location information'),
              Text('• Save favorite locations'),
              Text('• Get directions and estimated time'),
              Text('• Walking directions'),
              SizedBox(height: 16),
              Text(
                'Developed with Flutter',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Privacy Matters',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text(
                'RouteSee respects your privacy. Here\'s what you should know:',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 12),
              Text('• Location data is only used for navigation purposes'),
              Text('• No personal data is collected or shared'),
              Text('• Favorites are stored locally on your device'),
              Text('• No analytics or tracking is performed'),
              SizedBox(height: 12),
              Text(
                'This app uses your device location only when you request directions or want to see your position on the map.',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showClearFavoritesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Favorites'),
        content: const Text(
          'Are you sure you want to remove all favorite locations? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<LocationProvider>().clearAllFavorites();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Favorites cleared'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapViewModeTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _MapViewModeTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? Colors.blue.withValues(alpha: 0.06) : Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  key: ValueKey(isSelected),
                  color:
                      isSelected ? Theme.of(context).colorScheme.primary : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
