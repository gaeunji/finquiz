import 'package:flutter/material.dart';

class Category {
  final int id;
  final IconData icon;
  final String label;
  final Color color;

  const Category({
    required this.id,
    required this.icon,
    required this.label,
    required this.color,
  });
}
