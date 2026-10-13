import 'package:flutter/material.dart';

/// A product category shown in the home filter row.
@immutable
class ProductCategory {
  const ProductCategory({
    required this.id,
    required this.name,
    required this.icon,
  });

  final String id;
  final String name;
  final IconData icon;
}
