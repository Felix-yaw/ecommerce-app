import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

/// Single source of truth for the shopping experience.
///
/// It is a plain [ChangeNotifier] so we avoid external dependencies and keep
/// rebuilds scoped: widgets listen through [ShopScope] and `ListenableBuilder`.
class ShopState extends ChangeNotifier {
  ShopState() {
    _catalogue = SampleData.products;
  }

  late final List<Product> _catalogue;

  final List<CartItem> _cart = <CartItem>[];
  final Set<String> _wishlistIds = <String>{};

  String _selectedCategoryId = 'all';
  String _searchQuery = '';
  String _sortMode = 'popular';

  static const double _freeShippingThreshold = 75;
  static const double _shippingFee = 6.99;
  static const double _taxRate = 0.08;

  // ────────────────────────────── Catalogue ──────────────────────────────

  List<Product> get catalogue => List<Product>.unmodifiable(_catalogue);

  List<Product> get featured => SampleData.featured;

  List<Product> get filteredProducts {
    Iterable<Product> items = _catalogue;

    if (_selectedCategoryId != 'all') {
      items = items.where(
        (Product p) => p.categoryId == _selectedCategoryId,
      );
    }

    final String query = _searchQuery.trim().toLowerCase();
    if (query.isNotEmpty) {
      items = items.where(
        (Product p) =>
            p.name.toLowerCase().contains(query) ||
            p.brand.toLowerCase().contains(query),
      );
    }

    final List<Product> result = items.toList(growable: false);
    switch (_sortMode) {
      case 'priceLow':
        result.sort((Product a, Product b) => a.price.compareTo(b.price));
      case 'priceHigh':
        result.sort((Product a, Product b) => b.price.compareTo(a.price));
      case 'rating':
        result.sort((Product a, Product b) => b.rating.compareTo(a.rating));
      default:
        result.sort(
          (Product a, Product b) => b.reviewCount.compareTo(a.reviewCount),
        );
    }
    return result;
  }

  String get selectedCategoryId => _selectedCategoryId;
  String get searchQuery => _searchQuery;
  String get sortMode => _sortMode;

  void selectCategory(String id) {
    if (_selectedCategoryId == id) return;
    _selectedCategoryId = id;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    notifyListeners();
  }

  void setSortMode(String mode) {
    if (_sortMode == mode) return;
    _sortMode = mode;
    notifyListeners();
  }

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
      _cart.fold(0, (int sum, CartItem item) => sum + item.quantity);

  bool get isCartEmpty => _cart.isEmpty;

  double get subtotal =>
      _cart.fold(0, (double sum, CartItem item) => sum + item.lineTotal);

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
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _cart.removeWhere((CartItem e) => e.variantKey == item.variantKey);
    notifyListeners();
  }

  void clearCart() {
    if (_cart.isEmpty) return;
    _cart.clear();
    notifyListeners();
  }

  // ───────────────────────────── Wishlist ────────────────────────────────

  Set<String> get wishlistIds => Set<String>.unmodifiable(_wishlistIds);

  bool isWishlisted(Product product) => _wishlistIds.contains(product.id);

  int get wishlistCount => _wishlistIds.length;

  List<Product> get wishlistProducts => _catalogue
      .where((Product p) => _wishlistIds.contains(p.id))
      .toList(growable: false);

  void toggleWishlist(Product product) {
    if (_wishlistIds.remove(product.id)) {
      notifyListeners();
      return;
    }
    _wishlistIds.add(product.id);
    notifyListeners();
  }
}
