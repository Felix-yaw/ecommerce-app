import 'package:ecommerce_app/main.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/screens/cart_screen.dart';
import 'package:ecommerce_app/screens/category_products_screen.dart';
import 'package:ecommerce_app/screens/checkout_screen.dart';
import 'package:ecommerce_app/screens/product_detail_screen.dart';
import 'package:ecommerce_app/screens/profile_screen.dart';
import 'package:ecommerce_app/screens/search_screen.dart';
import 'package:ecommerce_app/screens/wishlist_screen.dart';
import 'package:ecommerce_app/state/shop_scope.dart';
import 'package:ecommerce_app/state/shop_state.dart';
import 'package:ecommerce_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(ShopState shop, Widget child) {
  return ShopScope(
    state: shop,
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: child,
    ),
  );
}

void _phoneSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

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
    _phoneSurface(tester);
    await tester.pumpWidget(const EcommerceApp());
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('GOOD MORNING'), findsOneWidget);
    expect(find.text('Felix Azaglo'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('product detail renders without overflow', (
    WidgetTester tester,
  ) async {
    _phoneSurface(tester);
    final ShopState shop = ShopState();
    await tester.pumpWidget(
      _wrap(shop, ProductDetailScreen(product: shop.catalogue.first)),
    );
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('Add to bag'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('cart renders filled state without overflow', (
    WidgetTester tester,
  ) async {
    _phoneSurface(tester);
    final ShopState shop = ShopState();
    shop.addToCart(shop.catalogue.first, quantity: 2);
    shop.addToCart(shop.catalogue[1]);

    await tester.pumpWidget(_wrap(shop, const CartScreen()));
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('My Bag'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('checkout renders without overflow', (WidgetTester tester) async {
    _phoneSurface(tester);
    final ShopState shop = ShopState();
    shop.addToCart(shop.catalogue.first);

    await tester.pumpWidget(_wrap(shop, const CheckoutScreen()));
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('Delivery address'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('wishlist renders saved items without overflow', (
    WidgetTester tester,
  ) async {
    _phoneSurface(tester);
    final ShopState shop = ShopState();
    shop.toggleWishlist(shop.catalogue.first);
    shop.toggleWishlist(shop.catalogue[2]);

    await tester.pumpWidget(_wrap(shop, const WishlistScreen()));
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.textContaining('Saved'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('profile renders without overflow', (WidgetTester tester) async {
    _phoneSurface(tester);
    final ShopState shop = ShopState();

    await tester.pumpWidget(_wrap(shop, const ProfileScreen()));
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('GOLD MEMBER'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('search renders suggestions without overflow', (
    WidgetTester tester,
  ) async {
    _phoneSurface(tester);
    final ShopState shop = ShopState();

    await tester.pumpWidget(_wrap(shop, const SearchScreen()));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Popular searches'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('category grid renders without overflow', (
    WidgetTester tester,
  ) async {
    _phoneSurface(tester);
    final ShopState shop = ShopState();

    await tester.pumpWidget(
      _wrap(shop, const CategoryProductsScreen(categoryId: 'electronics')),
    );
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.textContaining('items'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
