import 'package:app_descuento_virtual/data/models/category.dart';
import 'package:flutter/material.dart';

class CategoryChipWidget extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChipWidget({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? category.color
              : (isDark ? const Color(0xFF252535) : Colors.white),
          borderRadius: BorderRadius.circular(30),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: category.color.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ), // BoxShadow
                ]
              : [],
          border: isSelected
              ? null
              : Border.all(
                  color: isDark
                      ? const Color(0xFF252535)
                      : const Color(0xFF252535),
                  width: 1.5,
                ), // Border.all
        ), // BoxDecoration
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _iconData(category.icon),
              size: 16,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.white70 : const Color(0xFF6B7280)),
            ), // Icon
            const SizedBox(width: 6),
            Text(
              category.name,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white70 : const Color(0xFF6B7280)),
              ), // TextStyle
            ),
          ],
        ), // Row
      ), // AnimatedContainer
    ); // GestureDetector
  }

  IconData _iconData(String name) {
    switch (name) {
      case 'grid_view':
        return Icons.grid_view_rounded;
      case 'restaurant':
        return Icons.restaurant_menu_rounded;
      case 'devices':
        return Icons.devices_rounded;
      case 'checkroom':
        return Icons.checkroom_rounded;
      case 'flight':
        return Icons.flight_rounded;
      case 'sports_soccer':
        return Icons.sports_soccer_rounded;
      case 'theaters':
        return Icons.theaters_rounded;
      case 'favorite':
        return Icons.favorite_rounded;
      default:
        return Icons.label_rounded;
    }
  }
}
