import 'package:ecommerce_app/main.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/state/shop_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ShopState', () {
    test('adds and merges cart items', () {
      final ShopState shop = ShopState();
      final Product product = shop.catalogue.first;

      shop.addToCart(product);
      shop.addToCart(product);

      expect(shop.cartCount, 2);
      expect(shop.cartItems.length, 1);
    });

    test('removes items when quantity drops to zero', () {
      final ShopState shop = ShopState();
      final Product product = shop.catalogue.first;

      shop.addToCart(product);
      shop.decrement(shop.cartItems.first);

      expect(shop.isCartEmpty, isTrue);
    });

    test('applies free shipping above the threshold', () {
      final ShopState shop = ShopState();
      shop.addToCart(shop.catalogue.first, quantity: 5);

      expect(shop.subtotal, greaterThan(shop.freeShippingThreshold));
      expect(shop.shipping, 0);
    });

    test('toggles wishlist membership', () {
      final ShopState shop = ShopState();
      final Product product = shop.catalogue.first;

      shop.toggleWishlist(product);
      expect(shop.isWishlisted(product), isTrue);

      shop.toggleWishlist(product);
      expect(shop.isWishlisted(product), isFalse);
    });

    test('filters products by search query', () {
      final ShopState shop = ShopState();
      final List<Product> results = shop.search('hoodie');

      expect(results, isNotEmpty);
      expect(
        results.every((Product p) => p.name.toLowerCase().contains('hoodie')),
        isTrue,
      );
    });
  });

  testWidgets('home screen renders shell and catalog', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EcommerceApp());
    await tester.pump();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Home'), findsWidgets);
    expect(find.text('Hello, Felix 👋'), findsOneWidget);
  });
}
