import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/shop_state.dart';
import '../theme/app_colors.dart';
import '../widgets/profile/member_card.dart';
import '../widgets/profile/profile_menu.dart';
import '../widgets/profile/profile_stats.dart';

/// Account tab with a premium membership card and settings list.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const List<ProfileMenuItem> _accountItems = <ProfileMenuItem>[
    ProfileMenuItem(
      Icons.receipt_long_outlined,
      'My Orders',
      'Track and manage your orders',
    ),
    ProfileMenuItem(
      Icons.location_on_outlined,
      'Shipping Addresses',
      'Home, work and more',
    ),
    ProfileMenuItem(
      Icons.credit_card_outlined,
      'Payment Methods',
      'Cards and wallets',
    ),
  ];

  static const List<ProfileMenuItem> _settingsItems = <ProfileMenuItem>[
    ProfileMenuItem(
      Icons.notifications_none_rounded,
      'Notifications',
      'Offers and order updates',
    ),
    ProfileMenuItem(
      Icons.lock_outline_rounded,
      'Privacy & Security',
      'Passwords and data',
    ),
    ProfileMenuItem(
      Icons.help_outline_rounded,
      'Help Centre',
      'FAQs and support',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final (int wishlistCount, int cartCount) = context
        .select<ShopState, (int, int)>(
          (ShopState s) => (s.wishlistCount, s.cartCount),
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Settings',
            onPressed: () => _notImplemented(context, 'Settings'),
            icon: const Icon(Icons.settings_outlined),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 130),
        children: <Widget>[
          const MemberCard(),
          const SizedBox(height: 24),
          ProfileStats(
            orders: 12,
            saved: wishlistCount,
            inBag: cartCount,
          ),
          const SizedBox(height: 26),
          ProfileMenu(
            items: _accountItems,
            onItemTap: (ProfileMenuItem item) =>
                _notImplemented(context, item.title),
          ),
          const SizedBox(height: 16),
          ProfileMenu(
            items: _settingsItems,
            onItemTap: (ProfileMenuItem item) =>
                _notImplemented(context, item.title),
          ),
          const SizedBox(height: 26),
          OutlinedButton.icon(
            onPressed: () => _notImplemented(context, 'Log out'),
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Log out'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.accent,
              side: const BorderSide(color: AppColors.accent, width: 1.5),
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'ecommerce_app · v1.0.0',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _notImplemented(BuildContext context, String label) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('$label is not part of this prototype')),
      );
  }
}
