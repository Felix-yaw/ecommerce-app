import 'package:flutter/material.dart';

import 'product.dart';

/// A single line inside the shopping cart.
///
/// Two lines are considered the same product variant when the product id,
/// colour and size all match, which lets the cart merge duplicates.
@immutable
class CartItem {
  const CartItem({
    required this.product,
    this.quantity = 1,
    this.selectedColor,
    this.selectedSize,
  });

  final Product product;
  final int quantity;
  final Color? selectedColor;
  final String? selectedSize;

  double get lineTotal => product.price * quantity;

  /// Stable key used to merge/remove matching variants.
  String get variantKey =>
      '${product.id}|${selectedColor?.toARGB32()}|${selectedSize ?? ''}';

  CartItem copyWith({
    int? quantity,
    Color? selectedColor,
    String? selectedSize,
  }) {
    return CartItem(
      product: product,
      quantity: quantity ?? this.quantity,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedSize: selectedSize ?? this.selectedSize,
    );
  }
}
