import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/shop_state.dart';
import '../../theme/app_colors.dart';
import 'nav_item.dart';

/// Floating, frosted-glass navigation bar with a fluid expanding pill.
///
/// Subscribes only to the two badge counts it displays.
class FloatingNavBar extends StatelessWidget {
  const FloatingNavBar({
    super.key,
    required this.index,
    required this.onSelect,
  });

  final int index;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final (int wishlistCount, int cartCount) = context
        .select<ShopState, (int, int)>(
          (ShopState s) => (s.wishlistCount, s.cartCount),
        );

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.glassWhite,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
              boxShadow: AppColors.floatingShadow,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                NavItem(
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home_rounded,
                  label: 'Home',
                  selected: index == 0,
                  onTap: () => onSelect(0),
                ),
                NavItem(
                  icon: Icons.favorite_border_rounded,
                  selectedIcon: Icons.favorite_rounded,
                  label: 'Saved',
                  badge: wishlistCount,
                  selected: index == 1,
                  onTap: () => onSelect(1),
                ),
                NavItem(
                  icon: Icons.shopping_bag_outlined,
                  selectedIcon: Icons.shopping_bag_rounded,
                  label: 'Bag',
                  badge: cartCount,
                  selected: index == 2,
                  onTap: () => onSelect(2),
                ),
                NavItem(
                  icon: Icons.person_outline_rounded,
                  selectedIcon: Icons.person_rounded,
                  label: 'Profile',
                  selected: index == 3,
                  onTap: () => onSelect(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
