import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

/// Single source of truth for the shopping experience.
///
/// Exposed via `provider`'s `ChangeNotifierProvider`, so widgets subscribe with
/// `context.watch`/`context.select` and mutate with `context.read`.
///
/// Derived collections (filtered products, wishlist, cart totals) are cached
/// and only recomputed when their inputs change, so repeated reads inside a
/// `build()` never re-do the same work.
class ShopState extends ChangeNotifier {
  ShopState() {
    _catalogue = List<Product>.unmodifiable(SampleData.products);
    _popular = List<Product>.of(SampleData.products)
      ..sort((Product a, Product b) => b.reviewCount.compareTo(a.reviewCount));
  }

  late final List<Product> _catalogue;

  /// Catalogue pre-sorted by popularity (the default ordering).
  late final List<Product> _popular;

  final List<CartItem> _cart = <CartItem>[];
  final Set<String> _wishlistIds = <String>{};

  String _selectedCategoryId = 'all';

  static const double _freeShippingThreshold = 75;
  static const double _shippingFee = 6.99;
  static const double _taxRate = 0.08;

  // ── Caches ───────────────────────────────────────────────────────────────
  String? _filteredKey;
  List<Product>? _filteredCache;
  List<Product>? _wishlistCache;
  double? _subtotalCache;
  int? _countCache;

  // ────────────────────────────── Catalogue ──────────────────────────────

  /// Read-only catalogue. The unmodifiable wrapper is built once, not per read.
  List<Product> get catalogue => _catalogue;

  String get selectedCategoryId => _selectedCategoryId;

  /// Products for the currently selected category, in popularity order.
  ///
  /// Returns a stable instance for a given category so `context.select` can
  /// skip rebuilds when nothing changed.
  List<Product> get filteredProducts {
    if (_filteredKey == _selectedCategoryId && _filteredCache != null) {
      return _filteredCache!;
    }
    final List<Product> list = _selectedCategoryId == 'all'
        ? _popular
        : _popular
              .where((Product p) => p.categoryId == _selectedCategoryId)
              .toList(growable: false);
    _filteredKey = _selectedCategoryId;
    _filteredCache = list;
    return list;
  }

  void selectCategory(String id) {
    if (_selectedCategoryId == id) return;
    _selectedCategoryId = id;
    notifyListeners();
  }

  /// Case-insensitive search over product name and brand.
  List<Product> search(String query) {
    final String q = query.trim().toLowerCase();
    if (q.isEmpty) return const <Product>[];
    return _catalogue
        .where(
          (Product p) =>
              p.name.toLowerCase().contains(q) ||
              p.brand.toLowerCase().contains(q),
        )
        .toList(growable: false);
  }

  // ─────────────────────────────── Cart ──────────────────────────────────

  List<CartItem> get cartItems => List<CartItem>.unmodifiable(_cart);

  int get cartCount =>
      _countCache ??= _cart.fold<int>(0, (int s, CartItem i) => s + i.quantity);

  bool get isCartEmpty => _cart.isEmpty;

  double get subtotal => _subtotalCache ??= _cart.fold<double>(
    0,
    (double s, CartItem i) => s + i.lineTotal,
  );

  double get shipping =>
      _cart.isEmpty || subtotal >= _freeShippingThreshold ? 0 : _shippingFee;

  double get tax => subtotal * _taxRate;

  double get total => subtotal + shipping + tax;

  double get freeShippingThreshold => _freeShippingThreshold;

  double get amountToFreeShipping =>
      (subtotal >= _freeShippingThreshold)
      ? 0
      : _freeShippingThreshold - subtotal;

  bool get qualifiesForFreeShipping =>
      _cart.isNotEmpty && subtotal >= _freeShippingThreshold;

  void addToCart(
    Product product, {
    int quantity = 1,
    Color? color,
    String? size,
  }) {
    final CartItem incoming = CartItem(
      product: product,
      quantity: quantity,
      selectedColor: color,
      selectedSize: size,
    );

    final int index = _cart.indexWhere(
      (CartItem item) => item.variantKey == incoming.variantKey,
    );
    if (index >= 0) {
      _cart[index] = _cart[index].copyWith(
        quantity: _cart[index].quantity + quantity,
      );
    } else {
      _cart.add(incoming);
    }
    _invalidateTotals();
    notifyListeners();
  }

  void increment(CartItem item) => _updateQuantity(item, 1);
  void decrement(CartItem item) => _updateQuantity(item, -1);

  void _updateQuantity(CartItem item, int delta) {
    final int index = _cart.indexWhere(
      (CartItem e) => e.variantKey == item.variantKey,
    );
    if (index < 0) return;
    final int next = _cart[index].quantity + delta;
    if (next <= 0) {
      _cart.removeAt(index);
    } else {
      _cart[index] = _cart[index].copyWith(quantity: next);
    }
    _invalidateTotals();
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _cart.removeWhere((CartItem e) => e.variantKey == item.variantKey);
    _invalidateTotals();
    notifyListeners();
  }

  void clearCart() {
    if (_cart.isEmpty) return;
    _cart.clear();
    _invalidateTotals();
    notifyListeners();
  }

  void _invalidateTotals() {
    _subtotalCache = null;
    _countCache = null;
  }

  // ───────────────────────────── Wishlist ────────────────────────────────

  bool isWishlisted(Product product) => _wishlistIds.contains(product.id);

  int get wishlistCount => _wishlistIds.length;

  List<Product> get wishlistProducts =>
      _wishlistCache ??= _catalogue
          .where((Product p) => _wishlistIds.contains(p.id))
          .toList(growable: false);

  void toggleWishlist(Product product) {
    if (!_wishlistIds.remove(product.id)) {
      _wishlistIds.add(product.id);
    }
    _wishlistCache = null;
    notifyListeners();
  }
}
