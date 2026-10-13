import 'package:flutter/material.dart';

import '../models/product.dart';
import '../screens/cart_screen.dart';
import '../screens/category_products_screen.dart';
import '../screens/checkout_screen.dart';
import '../screens/product_detail_screen.dart';
import '../screens/search_screen.dart';

/// Thin wrapper around [Navigator] calls so every screen pushes routes the
/// same way.
abstract final class AppRoutes {
  static Future<void> openProduct(BuildContext context, Product product) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProductDetailScreen(product: product),
      ),
    );
  }

  static Future<void> openCart(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const CartScreen()),
    );
  }

  static Future<void> openSearch(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const SearchScreen()),
    );
  }

  static Future<void> openCategory(BuildContext context, String categoryId) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CategoryProductsScreen(categoryId: categoryId),
      ),
    );
  }

  static Future<void> openCheckout(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const CheckoutScreen()),
    );
  }
}
