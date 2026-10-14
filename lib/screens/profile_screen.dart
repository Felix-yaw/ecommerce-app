import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/shop_state.dart';
import '../theme/app_colors.dart';

/// Account tab with a premium membership card and settings list.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
          const _MemberCard(),
          const SizedBox(height: 24),
          _StatsRow(wishlistCount: wishlistCount, cartCount: cartCount),
          const SizedBox(height: 26),
          const _MenuGroup(
            items: <_MenuItem>[
              _MenuItem(Icons.receipt_long_outlined, 'My Orders',
                  'Track and manage your orders'),
              _MenuItem(Icons.location_on_outlined, 'Shipping Addresses',
                  'Home, work and more'),
              _MenuItem(Icons.credit_card_outlined, 'Payment Methods',
                  'Cards and wallets'),
            ],
          ),
          const SizedBox(height: 16),
          const _MenuGroup(
            items: <_MenuItem>[
              _MenuItem(Icons.notifications_none_rounded, 'Notifications',
                  'Offers and order updates'),
              _MenuItem(Icons.lock_outline_rounded, 'Privacy & Security',
                  'Passwords and data'),
              _MenuItem(Icons.help_outline_rounded, 'Help Centre',
                  'FAQs and support'),
            ],
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

class _MemberCard extends StatelessWidget {
  const _MemberCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 196,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Color(0xFF1E1E28), Color(0xFF101016)],
        ),
        boxShadow: AppColors.floatingShadow,
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 54,
                height: 54,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[AppColors.accent, AppColors.violet],
                  ),
                ),
                child: const Center(
                  child: Text(
                    'FA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Felix Azaglo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'felix@example.com',
                      style: TextStyle(
                        color: Color(0xFF9A9AAE),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: <Widget>[
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.workspace_premium_rounded,
                          size: 14,
                          color: AppColors.star,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'GOLD MEMBER',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            letterSpacing: 1.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              const Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    '••••  4821',
                    style: TextStyle(
                      color: Color(0xFF7C7C90),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.wishlistCount, required this.cartCount});

  final int wishlistCount;
  final int cartCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: AppColors.softShadow,
      ),
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: Row(
        children: <Widget>[
          _StatItem(value: '12', label: 'Orders'),
          const _StatDivider(),
          _StatItem(value: '$wishlistCount', label: 'Saved'),
          const _StatDivider(),
          _StatItem(value: '$cartCount', label: 'In bag'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.6,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 38, color: AppColors.divider);
  }
}

class _MenuGroup extends StatelessWidget {
  const _MenuGroup({required this.items});

  final List<_MenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          children: <Widget>[
            for (int i = 0; i < items.length; i++) ...<Widget>[
              _MenuTile(item: items[i]),
              if (i != items.length - 1)
                const Divider(height: 1, indent: 68),
            ],
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.item});

  final _MenuItem item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(item.icon, size: 20, color: AppColors.textPrimary),
      ),
      title: Text(
        item.title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        item.subtitle,
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textTertiary,
      ),
      onTap: () => ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('${item.title} is not part of this prototype')),
        ),
    );
  }
}

@immutable
class _MenuItem {
  const _MenuItem(this.icon, this.title, this.subtitle);

  final IconData icon;
  final String title;
  final String subtitle;
}
