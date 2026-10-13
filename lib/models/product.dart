import 'package:flutter/material.dart';

/// Immutable product entity used across the catalogue, detail, cart and
/// wishlist screens.
@immutable
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.categoryId,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.oldPrice,
    this.rating = 4.5,
    this.reviewCount = 0,
    this.colors = const <Color>[],
    this.sizes = const <String>[],
    this.isFeatured = false,
    this.freeShipping = false,
  });

  final String id;
  final String name;
  final String brand;
  final String categoryId;
  final String description;
  final double price;
  final double? oldPrice;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final List<Color> colors;
  final List<String> sizes;
  final bool isFeatured;
  final bool freeShipping;

  bool get hasDiscount => oldPrice != null && oldPrice! > price;

  int get discountPercent =>
      hasDiscount ? (((oldPrice! - price) / oldPrice!) * 100).round() : 0;

  String get displayPrice => '\$${price.toStringAsFixed(2)}';

  String get displayOldPrice =>
      hasDiscount ? '\$${oldPrice!.toStringAsFixed(2)}' : '';
}
