import 'package:flutter/material.dart';

import '../state/shop_scope.dart';
import '../state/shop_state.dart';
import '../theme/app_colors.dart';
import 'cart_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'wishlist_screen.dart';

/// Root scaffold that hosts the four primary tabs.
///
/// An [IndexedStack] keeps each tab's state alive while only the selected tab
/// is painted. The bar itself subscribes to [ShopState] through a
/// [ListenableBuilder] so cart/wishlist badge changes never rebuild the tabs.
class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  void _onSelect(int index) {
    if (index == _index) return;
    setState(() => _index = index);
  }

  @override
  Widget build(BuildContext context) {
    final ShopState shop = ShopScope.read(context);

    final List<Widget> tabs = <Widget>[
      const HomeScreen(),
      WishlistScreen(onBrowse: () => _onSelect(0)),
      CartScreen(embedded: true, onBrowse: () => _onSelect(0)),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: tabs),
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 18,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: ListenableBuilder(
            listenable: shop,
            builder: (BuildContext context, Widget? _) {
              return NavigationBar(
                selectedIndex: _index,
                onDestinationSelected: _onSelect,
                height: 66,
                backgroundColor: AppColors.surface,
                indicatorColor: AppColors.primaryLight,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                destinations: <Widget>[
                  const NavigationDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home_rounded),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: _WishlistNavIcon(count: shop.wishlistCount),
                    selectedIcon: _WishlistNavIcon(
                      count: shop.wishlistCount,
                      filled: true,
                    ),
                    label: 'Wishlist',
                  ),
                  NavigationDestination(
                    icon: _CartNavIcon(count: shop.cartCount),
                    selectedIcon: _CartNavIcon(count: shop.cartCount),
                    label: 'Cart',
                  ),
                  const NavigationDestination(
                    icon: Icon(Icons.person_outline_rounded),
                    selectedIcon: Icon(Icons.person_rounded),
                    label: 'Profile',
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _CartNavIcon extends StatelessWidget {
  const _CartNavIcon({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Badge(
      isLabelVisible: count > 0,
      label: Text('$count'),
      backgroundColor: AppColors.accent,
      child: const Icon(Icons.shopping_bag_outlined),
    );
  }
}

class _WishlistNavIcon extends StatelessWidget {
  const _WishlistNavIcon({required this.count, this.filled = false});

  final int count;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Badge(
      isLabelVisible: count > 0,
      label: Text('$count'),
      backgroundColor: AppColors.accent,
      child: Icon(
        filled ? Icons.favorite_rounded : Icons.favorite_border_rounded,
      ),
    );
  }
}
