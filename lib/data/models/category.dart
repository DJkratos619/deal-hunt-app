import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final String icon;
  final Color color;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

class Categories {
  Categories._();

  static const List<Category> all = [
    Category(id: 'all', name: 'Todos', icon: 'grid_view', color: Color(0xFF6C63FF)),
    Category(id: 'food', name: 'Comida', icon: 'restaurant', color: Color(0xFFFF6B6B)),
    Category(id: 'tech', name: 'Tecnología', icon: 'devices', color: Color(0xFF4ECDC4)),
    Category(id: 'fashion', name: 'Moda', icon: 'checkroom', color: Color(0xFFFF8ED4)),
    Category(id: 'travel', name: 'Viajes', icon: 'flight', color: Color(0xFF45b7d1)),
    Category(id: 'sports', name: 'Deportes', icon: 'sports_soccer', color: Color(0xFF96CEB4)),
    Category(id: 'entertainment', name: 'Entretenimiento', icon: 'theaters', color: Color(0xFFFFBE0B)),
    Category(id: 'health', name: 'Salud', icon: 'favorite', color: Color(0xFF06D6A0)),
  ];
static Category findById(String id) {
    return all.firstWhere((c) => c.id == id, orElse: () => all.first);
  }
}