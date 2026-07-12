import 'package:flutter/material.dart';

import '../models/location_model.dart';

class CategoryCard extends StatelessWidget {
  final LocationCategory category;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;
  final int index;

  const CategoryCard({
    super.key,
    required this.category,
    required this.count,
    required this.isSelected,
    required this.onTap,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 240 + (index * 40)),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 10 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          width: 100,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: isSelected ? _getCategoryColor(category) : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  isSelected ? _getCategoryColor(category) : Colors.grey[300]!,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                category.icon,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 4),
              Text(
                category.displayName,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: Text(
                  '$count',
                  key: ValueKey(count),
                  style: TextStyle(
                    fontSize: 11,
                    color: isSelected ? Colors.white70 : Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
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
